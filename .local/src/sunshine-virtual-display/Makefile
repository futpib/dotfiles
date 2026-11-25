# Build sunshine-virtual-display and the desktop file that lets it use KWin's
# screencast protocol: KWin grants zkde_screencast_unstable_v1 only to
# executables named, by absolute path, in a desktop file with
# X-KDE-Wayland-Interfaces. sunshine-launch runs `make install` on every
# Sunshine start; nothing is rebuilt unless a source changed.
PREFIX ?= $(HOME)/.local
BUILD ?= $(HOME)/.cache/sunshine-virtual-display
PROTO ?= /usr/share/plasma-wayland-protocols/zkde-screencast-unstable-v1.xml

BIN := $(PREFIX)/bin/sunshine-virtual-display
DESKTOP := $(PREFIX)/share/applications/sunshine-virtual-display.desktop
GEN := $(BUILD)/zkde-screencast-unstable-v1-client-protocol.h $(BUILD)/zkde-screencast-unstable-v1-protocol.c

install: $(BIN) $(DESKTOP)

$(BIN): $(BUILD)/sunshine-virtual-display
	install -Dm755 $< $@

$(BUILD)/sunshine-virtual-display: main.c $(GEN)
	$(CC) -O2 -Wall -I$(BUILD) -o $@ main.c $(BUILD)/zkde-screencast-unstable-v1-protocol.c $$(pkg-config --cflags --libs wayland-client)

$(BUILD)/zkde-screencast-unstable-v1-client-protocol.h: $(PROTO)
	@mkdir -p $(@D)
	wayland-scanner client-header $< $@

$(BUILD)/zkde-screencast-unstable-v1-protocol.c: $(PROTO)
	@mkdir -p $(@D)
	wayland-scanner private-code $< $@

$(DESKTOP): Makefile
	@mkdir -p $(@D)
	printf '%s\n' '[Desktop Entry]' 'Type=Application' \
		'Name=Sunshine virtual display' \
		'Comment=Lets sunshine-virtual-display create KWin virtual screens' \
		"Exec=$$(realpath -m '$(BIN)')" \
		'X-KDE-Wayland-Interfaces=zkde_screencast_unstable_v1' \
		'NoDisplay=true' >$@

.PHONY: install
