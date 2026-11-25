/*
 * sunshine-virtual-display: ask KWin for a virtual output of a given pixel
 * size and hold it until this process exits. Sunshine (capture = kwin,
 * output_name = Virtual-<name>) then captures that output, which gives a
 * client a native desktop at its own resolution instead of an upscaled panel.
 *
 * Usage: sunshine-virtual-display NAME WIDTH HEIGHT
 *   WIDTH/HEIGHT are the output's pixel mode. KWin 6.7 uses them as the mode
 *   and ignores the protocol's scale argument, so set the scale afterwards
 *   (kscreen-doctor output.Virtual-NAME.scale.N). KWin only grants
 *   zkde_screencast_unstable_v1 to executables listed in a desktop file with
 *   X-KDE-Wayland-Interfaces; `make install` writes one.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <wayland-client.h>
#include "zkde-screencast-unstable-v1-client-protocol.h"

static struct zkde_screencast_unstable_v1 *screencast;
static int done, status;

static void reg_global(void *data, struct wl_registry *reg, uint32_t name, const char *iface, uint32_t ver) {
    if (strcmp(iface, zkde_screencast_unstable_v1_interface.name) == 0 && ver >= 2)
        screencast = wl_registry_bind(reg, name, &zkde_screencast_unstable_v1_interface, ver < 6 ? ver : 6);
}
static void reg_remove(void *data, struct wl_registry *reg, uint32_t name) {}
static const struct wl_registry_listener reg_listener = {reg_global, reg_remove};

static void on_closed(void *data, struct zkde_screencast_stream_unstable_v1 *s) {
    fprintf(stderr, "KWin closed the virtual output\n");
    done = 1;
}
static void on_created(void *data, struct zkde_screencast_stream_unstable_v1 *s, uint32_t node) {
    printf("ready (pipewire node %u)\n", node);
    fflush(stdout);
}
static void on_failed(void *data, struct zkde_screencast_stream_unstable_v1 *s, const char *error) {
    fprintf(stderr, "KWin refused the virtual output: %s\n", error);
    done = 1;
    status = 1;
}
static void on_serial(void *data, struct zkde_screencast_stream_unstable_v1 *s, uint32_t hi, uint32_t lo) {
    printf("ready (pipewire serial %llu)\n", ((unsigned long long)hi << 32) | lo);
    fflush(stdout);
}
static const struct zkde_screencast_stream_unstable_v1_listener stream_listener = {
    on_closed, on_created, on_failed, on_serial,
};

int main(int argc, char **argv) {
    if (argc != 4) {
        fprintf(stderr, "usage: %s NAME WIDTH HEIGHT\n", argv[0]);
        return 2;
    }
    const char *name = argv[1];
    int width = atoi(argv[2]), height = atoi(argv[3]);
    if (width <= 0 || height <= 0) {
        fprintf(stderr, "invalid size\n");
        return 2;
    }

    struct wl_display *display = wl_display_connect(NULL);
    if (!display) {
        fprintf(stderr, "cannot connect to the Wayland compositor\n");
        return 1;
    }
    struct wl_registry *reg = wl_display_get_registry(display);
    wl_registry_add_listener(reg, &reg_listener, NULL);
    wl_display_roundtrip(display);
    if (!screencast) {
        fprintf(stderr, "KWin did not offer zkde_screencast_unstable_v1 v2+ (missing desktop-file permission?)\n");
        return 1;
    }

    char description[64];
    snprintf(description, sizeof description, "Sunshine %dx%d", width, height);
    struct zkde_screencast_stream_unstable_v1 *stream =
        wl_proxy_get_version((struct wl_proxy *)screencast) >= 4
            ? zkde_screencast_unstable_v1_stream_virtual_output_with_description(
                  screencast, name, description, width, height, wl_fixed_from_int(1),
                  ZKDE_SCREENCAST_UNSTABLE_V1_POINTER_HIDDEN)
            : zkde_screencast_unstable_v1_stream_virtual_output(
                  screencast, name, width, height, wl_fixed_from_int(1),
                  ZKDE_SCREENCAST_UNSTABLE_V1_POINTER_HIDDEN);
    zkde_screencast_stream_unstable_v1_add_listener(stream, &stream_listener, NULL);

    while (!done && wl_display_dispatch(display) != -1)
        ;
    wl_display_disconnect(display);
    return status;
}
