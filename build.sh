#!/usr/bin/env bash

# Tiny cursors, based on KDE Breeze
# Copyright (c) 2016 Keefer Rourke <keefer.rourke@gmail.com>
# Copyright (c) 2020 Sergei Eremenko <https://github.com/SmartFinn>

set -e

convert_to_png() {
	local src_dir="$1"
	local out_dir="${2:-.}"
	local file size bitmap_file png_mtime svg_mtime

	[ -d "$src_dir" ] || return 1
	[ -d "$out_dir" ] || mkdir -p "$out_dir"

	# shellcheck disable=SC2016
	for file in "$src_dir"/*.svg; do
		[ -f "$file" ] || continue
		for size in 32 64; do
			bitmap_file="${out_dir%/}/$(basename "$file" .svg)_${size}.png"

			svg_mtime="$(stat -c '%Y' "$file")"
			png_mtime="$(stat -c '%Y' "$bitmap_file" 2>/dev/null || echo 0)"

			if (( png_mtime > svg_mtime )); then
				# skip if PNG file exists and the modification time is
				# newer than on SVG file
				continue
			fi

			printf '%s\0%s\0%s\0' "$bitmap_file" "$size" "$file"
		done
	done | xargs -r -0 -n 3 -P "$(nproc)" sh -c 'inkscape -z -e "$0" -w $1 -h $1 "$2"'
}

convert_to_x11cursor() {
	local src_dir="$1"
	local out_dir="$2"
	local config base_name

	[ -d "$src_dir" ] || return 1

	if [ -d "$out_dir" ]; then
		rm -rf "$out_dir"
	fi

	mkdir -p "$out_dir"

	echo -ne "Generating cursor theme...\\r"
	for config in "$CONFIG_DIR"/*.cursor; do
		[ -f "$config" ] || continue
		base_name="$(basename "$config" .cursor)"
		xcursorgen -p "$src_dir" "$config" "$out_dir/$base_name"
	done
	echo -e "Generating cursor theme... DONE"
}

create_aliases() {
	local out_dir="$1"
	local symlink target

	echo -ne "Generating shortcuts...\\r"
	while read -r symlink target; do
		[ -e "$out_dir/$symlink" ] && continue
		ln -sf "$target" "$out_dir/$symlink"
	done < "$ALIASES"
	echo -e "Generating shortcuts... DONE"
}

SCRIPT_DIR="$(dirname "$0")"

: "${SRC_DIR:="$SCRIPT_DIR"/src}"
: "${OUT_DIR:="$SCRIPT_DIR"/dist}"
: "${BUILD_DIR:="$SCRIPT_DIR"/build}"
: "${ALIASES:="$SCRIPT_DIR"/src/cursorList}"
: "${CONFIG_DIR:="$SCRIPT_DIR"/src/config}"

for theme_src_dir in "$SRC_DIR"/*; do
	# skip directory that not contains index.theme file
	[ -f "$theme_src_dir/index.theme" ] || continue
	theme_name="$(basename "$theme_src_dir")"
	theme_build_dir="$BUILD_DIR/$theme_name"
	theme_out_dir="$OUT_DIR/$theme_name"

	echo "=> Workon '$theme_src_dir' ..."
	convert_to_png "$theme_src_dir" "$theme_build_dir"
	convert_to_x11cursor "$theme_build_dir" "$theme_out_dir"/cursors
	create_aliases "$theme_out_dir"/cursors

	cp -f "$theme_src_dir/index.theme" "$theme_out_dir"/
done
