#!/usr/bin/env ruby
# Encoding: UTF-8

# Monkey patch for Ruby 2.3+
Kernel.class_exec { define_method(:then) { |&block| block === self } }

# Exit if Ruby version is lesser than 2.3
abort("Minimum Ruby version 2.3+ is required. You are running #{RUBY_VERSION}") if RUBY_VERSION.split(?.).first(2).join.to_i < 23

require_relative File.join(__dir__, 'checksizes.rb')

puts ":: Detected Sizes: #{SIZES.join(', ')}\n\n"

OUT_DIR = File.join(File.expand_path('..', __dir__), 'src', 'config').freeze

CURSORS = %w[
	alias all-scroll
	bottom_left_corner bottom_right_corner
	bottom_side cell center_ptr
	color-picker col-resize context-menu
	copy crosshair default dnd-move
	dnd-no-drop down-arrow draft fleur
	help left-arrow left_side no-drop not-allowed
	openhand pencil pirate pointer progress right-arrow
	right_ptr right_side row-resize size_bdiag size_fdiag
	size_hor size_ver text top_left_corner top_right_corner
	top_side up-arrow vertical-text wait
	wayland-cursor x-cursor zoom-in zoom-out
].freeze

ATTRIBUTES = <<~'EOF'.split(?%).each(&:strip!).freeze
	64 16 2 alias
	%
	64 30 30 all-scroll
	%
	64 30 30 bottom_left_corner
	%
	64 30 30 bottom_right_corner
	%
	64 30 30 bottom_side
	%
	64 30 30 cell
	%
	64 30 2 center_ptr
	%
	64 12 12 color-picker
	%
	64 30 30 col-resize
	%
	64 16 2 context-menu
	%
	64 16 2 copy
	%
	64 30 30 crosshair
	%
	64 16 2 default
	%
	64 30 30 dnd-move
	%
	64 30 30 dnd-no-drop
	%
	64 30 30 down-arrow
	%
	64 10 10 draft
	%
	64 30 30 fleur
	%
	64 16 2 help
	%
	64 30 30 left-arrow
	%
	64 30 30 left_side
	%
	64 16 2 no-drop
	%
	64 30 30 not-allowed
	%
	64 30 30 openhand
	%
	64 10 52 pencil
	%
	64 30 30 pirate
	%
	64 26 8 pointer
	%
	64 16 2 progress-01 30,
	64 16 2 progress-02 30,
	64 16 2 progress-03 30,
	64 16 2 progress-04 30,
	64 16 2 progress-05 30,
	64 16 2 progress-06 30,
	64 16 2 progress-07 30,
	64 16 2 progress-08 30,
	64 16 2 progress-09 30,
	64 16 2 progress-10 30,
	64 16 2 progress-11 30,
	64 16 2 progress-12 30,
	64 16 2 progress-13 30,
	64 16 2 progress-14 30,
	64 16 2 progress-15 30,
	64 16 2 progress-16 30,
	64 16 2 progress-17 30,
	64 16 2 progress-18 30,
	64 16 2 progress-19 30,
	64 16 2 progress-20 30,
	64 16 2 progress-21 30,
	64 16 2 progress-22 30,
	64 16 2 progress-23 30,
	64 16 2 progress-24 30,
	64 16 2 progress-25 30,
	64 16 2 progress-26 30,
	64 16 2 progress-27 30,
	64 16 2 progress-28 30,
	64 16 2 progress-29 30,
	64 16 2 progress-30 30,
	64 16 2 progress-31 30,
	64 16 2 progress-32 30,
	64 16 2 progress-33 30,
	64 16 2 progress-34 30,
	64 16 2 progress-35 30,
	64 16 2 progress-36 30,
	64 16 2 progress-37 30,
	64 16 2 progress-38 30,
	64 16 2 progress-39 30,
	64 16 2 progress-40 30,
	64 16 2 progress-41 30,
	64 16 2 progress-42 30,
	64 16 2 progress-43 30,
	64 16 2 progress-44 30,
	64 16 2 progress-45 30,
	64 16 2 progress-46 30,
	64 16 2 progress-47 30,
	64 16 2 progress-48 30
	%
	64 30 30 right-arrow
	%
	64 46 2 right_ptr
	%
	64 30 30 right_side
	%
	64 30 30 row-resize
	%
	64 30 30 size_bdiag
	%
	64 30 30 size_fdiag
	%
	64 30 30 size_hor
	%
	64 30 30 size_ver
	%
	64 30 30 text
	%
	64 30 30 top_left_corner
	%
	64 30 30 top_right_corner
	%
	64 30 30 top_side
	%
	64 30 30 up-arrow
	%
	64 30 30 vertical-text
	%
	64 30 30 wait-01 30,
	64 30 30 wait-02 30,
	64 30 30 wait-03 30,
	64 30 30 wait-04 30,
	64 30 30 wait-05 30,
	64 30 30 wait-06 30,
	64 30 30 wait-07 30,
	64 30 30 wait-08 30,
	64 30 30 wait-09 30,
	64 30 30 wait-10 30,
	64 30 30 wait-11 30,
	64 30 30 wait-12 30,
	64 30 30 wait-13 30,
	64 30 30 wait-14 30,
	64 30 30 wait-15 30,
	64 30 30 wait-16 30,
	64 30 30 wait-17 30,
	64 30 30 wait-18 30,
	64 30 30 wait-19 30,
	64 30 30 wait-20 30,
	64 30 30 wait-21 30,
	64 30 30 wait-22 30,
	64 30 30 wait-23 30,
	64 30 30 wait-24 30,
	64 30 30 wait-25 30,
	64 30 30 wait-26 30,
	64 30 30 wait-27 30,
	64 30 30 wait-28 30,
	64 30 30 wait-29 30,
	64 30 30 wait-30 30,
	64 30 30 wait-31 30,
	64 30 30 wait-32 30,
	64 30 30 wait-33 30,
	64 30 30 wait-34 30,
	64 30 30 wait-35 30,
	64 30 30 wait-36 30,
	64 30 30 wait-37 30,
	64 30 30 wait-38 30,
	64 30 30 wait-39 30,
	64 30 30 wait-40 30,
	64 30 30 wait-41 30,
	64 30 30 wait-42 30,
	64 30 30 wait-43 30,
	64 30 30 wait-44 30,
	64 30 30 wait-45 30,
	64 30 30 wait-46 30,
	64 30 30 wait-47 30,
	64 30 30 wait-48 30,
	%
	64 30 30 wayland-cursor
	%
	64 30 30 x-cursor
	%
	64 30 30 zoom-in
	%
	64 30 30 zoom-out
EOF


file, output = '', []

Dir.mkdir(OUT_DIR) unless File.exist?(OUT_DIR)

Dir.glob("#{OUT_DIR}/*.cursor").each do |x|
	File.delete(x)
	puts "\e[38;2;255;80;80m:: Deleted #{x}\e[0m"
end

CURSORS.zip(ATTRIBUTES).each do |cur, attrs|
	file.replace(File.join(OUT_DIR, "#{cur}.cursor"))
	output.clear

	attrs.split(?,).each(&:strip!).each do |_attr|
		splitted_attr = _attr.split(?\s.freeze)

		size, x_coord, y_coord = *splitted_attr.first(3).map(&:to_i)
		name = splitted_attr[3]
		refresh_time =splitted_attr[4].then { |_x| _x.to_i.to_s.freeze == _x ? " #{_x.to_s}" : ''.freeze }

		# Check for mismatch in the CURSORS and ATTRIBUTES
		unless cur.eql?('progress') || cur.eql?('wait')
			abort "Filename and attribute name mismatch: #{name} #{cur}" unless name == cur
		end

		SIZES.each do |sz|
			_x_coord = sz.*(x_coord).fdiv(size).round.then { |_x| _x < 1 ? 1 : _x }
			_y_coord = sz.*(y_coord).fdiv(size).round.then { |_x| _x < 1 ? 1 : _x }
			output.push("#{sz} #{_x_coord} #{_y_coord} #{name}_#{sz}.png#{refresh_time}\n")
		end
	end

	sorted_output = output.sort

	puts "\e[38;2;80;155;0m:: #{file}\e[0m", sorted_output, ?\n
	IO.write(file, sorted_output.join)
end

puts "\e[38;2;80;155;0m:: Generated configuration for #{SIZES.join(', ')} sized cursors\e[0m"
