import {
  type Dependencies,
  parseAdbDevices,
  parseArgs,
  parseMdnsServices,
  run,
} from "./adb-wireless";

function assert(
  condition: unknown,
  message = "assertion failed",
): asserts condition {
  if (!condition) {
    throw new Error(message);
  }
}

function assertEquals(actual: unknown, expected: unknown): void {
  const normalize = (value: unknown): unknown => {
    if (Array.isArray(value)) {
      return value.map(normalize);
    }
    if (value !== null && typeof value === "object") {
      return Object.fromEntries(
        Object.entries(value).sort(([left], [right]) =>
          left.localeCompare(right)
        )
          .map(([key, child]) => [key, normalize(child)]),
      );
    }
    return value;
  };
  const actualJson = JSON.stringify(normalize(actual));
  const expectedJson = JSON.stringify(normalize(expected));
  assert(
    actualJson === expectedJson,
    `expected ${expectedJson}, got ${actualJson}`,
  );
}

Deno.test("parses mDNS services and adb device details", () => {
  assertEquals(
    parseMdnsServices(`List of discovered mdns services
adb-serial-aBc123\t_adb-tls-pairing._tcp\t192.168.1.42:37123
adb-serial-ZyX987 _adb-tls-connect._tcp 192.168.1.42:41487
adb-serial _adb._tcp 192.168.1.42:5555
`),
    [
      {
        name: "adb-serial-aBc123",
        type: "_adb-tls-pairing._tcp",
        endpoint: "192.168.1.42:37123",
      },
      {
        name: "adb-serial-ZyX987",
        type: "_adb-tls-connect._tcp",
        endpoint: "192.168.1.42:41487",
      },
      {
        name: "adb-serial",
        type: "_adb._tcp",
        endpoint: "192.168.1.42:5555",
      },
    ],
  );

  assertEquals(
    parseAdbDevices(`List of devices attached
192.168.1.42:41487 device product:husky model:Pixel_8 device:husky transport_id:4
emulator-5554 offline transport_id:2
`),
    [
      {
        serial: "192.168.1.42:41487",
        state: "device",
        details: "product:husky model:Pixel_8 device:husky transport_id:4",
      },
      {
        serial: "emulator-5554",
        state: "offline",
        details: "transport_id:2",
      },
    ],
  );
});

Deno.test("parses manual endpoints and poll interval", () => {
  assertEquals(
    parseArgs([
      "--pair=192.168.1.42:37123",
      "--connect",
      "192.168.1.42:41487",
      "--poll",
      "0.5",
    ]),
    {
      pairEndpoint: "192.168.1.42:37123",
      connectEndpoint: "192.168.1.42:41487",
      pollMilliseconds: 500,
      help: false,
    },
  );
});

Deno.test("reports how to install a missing adb dependency", async () => {
  const deps: Dependencies = {
    adb() {
      return {
        success: false,
        code: 127,
        stdout: "",
        stderr: "adb was not found in PATH",
      };
    },
    prompt() {
      throw new Error("prompt should not be called");
    },
    sleep() {
      throw new Error("sleep should not be called");
    },
    out() {},
    err() {},
  };

  let message = "";
  try {
    await run(parseArgs([]), deps);
  } catch (error) {
    message = error instanceof Error ? error.message : String(error);
  }

  assert(message.includes("Missing dependency: adb"));
  assert(message.includes("pacman -S android-tools"));
  assert(message.includes("apt install adb"));
});

Deno.test("discovers, pairs, connects, and confirms the device", async () => {
  let paired = false;
  let connected = false;
  const calls: string[][] = [];
  const output: string[] = [];

  const deps: Dependencies = {
    adb(args) {
      calls.push(args);
      if (args[0] === "version" || args[0] === "start-server") {
        return { success: true, code: 0, stdout: "", stderr: "" };
      }
      if (args[0] === "devices") {
        return {
          success: true,
          code: 0,
          stdout: connected
            ? "List of devices attached\n192.168.1.42:41487 device product:husky model:Pixel_8\n"
            : "List of devices attached\n\n",
          stderr: "",
        };
      }
      if (args[0] === "mdns") {
        return {
          success: true,
          code: 0,
          stdout: `List of discovered mdns services
adb-serial-aBc123 _adb-tls-pairing._tcp 192.168.1.42:37123
adb-serial-ZyX987 _adb-tls-connect._tcp 192.168.1.42:41487
adb-serial _adb._tcp 192.168.1.42:5555
`,
          stderr: "",
        };
      }
      if (args[0] === "pair") {
        assertEquals(args, ["pair", "192.168.1.42:37123", "123456"]);
        paired = true;
        return {
          success: true,
          code: 0,
          stdout: "Successfully paired\n",
          stderr: "",
        };
      }
      if (args[0] === "connect") {
        if (paired) {
          connected = true;
          return { success: true, code: 0, stdout: "connected\n", stderr: "" };
        }
        return {
          success: false,
          code: 1,
          stdout: "",
          stderr: "failed to authenticate\n",
        };
      }
      throw new Error(`unexpected adb call: ${args.join(" ")}`);
    },
    prompt() {
      return "123456";
    },
    sleep() {
      return Promise.resolve();
    },
    out(message) {
      output.push(message);
    },
    err(message) {
      output.push(message);
    },
  };

  await run(parseArgs([]), deps);

  assert(calls.some((call) => call[0] === "pair"));
  assert(calls.filter((call) => call[0] === "connect").length === 2);
  assert(output.at(-1)?.includes("192.168.1.42:41487 device"));
});

Deno.test("exits immediately when one wireless device is already online", async () => {
  const calls: string[][] = [];
  const deps: Dependencies = {
    adb(args) {
      calls.push(args);
      if (args[0] === "devices") {
        return {
          success: true,
          code: 0,
          stdout:
            "List of devices attached\n10.0.0.8:40221 device model:phone\n",
          stderr: "",
        };
      }
      return { success: true, code: 0, stdout: "", stderr: "" };
    },
    prompt() {
      throw new Error("prompt should not be called");
    },
    sleep() {
      throw new Error("sleep should not be called");
    },
    out() {},
    err() {},
  };

  await run(parseArgs([]), deps);
  assert(!calls.some((call) => call[0] === "mdns"));
});
