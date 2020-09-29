#!/usr/bin/env ruby
# Encoding: UTF-8
# Frozen_String_Literal: false
# Warn_Indent: false

# Written by Sourav Goswami <souravgoswami@protonmail.com>

## Future Ruby release may have frozen string literals.
# It's good to keep it false so that our program doesn't crash in the future.

# Version should be floating point number
VERSION = "0.2".freeze

# Make sure sync is enabled
STDOUT.sync = STDERR.sync = true

# Check Ruby version
abort "Error! At least Ruby 2.4 is needed! You are running #{RUBY_VERSION} (#{RUBY_PLATFORM})" if RUBY_VERSION.split(?.).first(2).join.to_i < 24

### User definable ###
## Location of the base cursors
BASE = File.join(__dir__, 'oreo_base_cursors')

## Output directory
OUT_DIR = File.join(File.expand_path('..', __dir__), 'src')

## Content of index.theme inside each theme
INDEX_THEME = proc do |x|
	<<~EOF
		[Icon Theme]
		Name=Oreo #{x.split(?_).map(&:capitalize).join(?\s)} Cursors
		Comment=design by varlesh | colour by #{File.basename(Process.argv0)}
	EOF
end

### Code ###
# Execute these stuff in the beginning even before initializing constants

BEGIN {
	# Monkey Patches for Ruby 2.4 to 2.5
	Kernel.class_exec { define_method(:then) { |&block| block === self } } unless Kernel.respond_to?(:then)
	Dir.define_singleton_method(:children) { |arg| Dir.entries(arg).drop(2) } unless Dir.respond_to?(:children)

	# We need to transform_keys to symbols, but this is not supported until Ruby 2.5, so here's our monkey patch
	class Hash
		def key_to_sym(&block)
			reduce({}) { |h, x| h.merge(x[0].downcase.to_sym => x[1]) }
		end
	end

	# Add rainbow colours to strings!
	class String
		def colourize(line_break = true)
			return print(self) unless STDOUT.tty?

			colours, line_length, temp = [], -1, ''
			sample_colour, rev = rand(7), rand < 0.5

			each_line do |c|
				n, i = c.length, -1

				if line_length != n
					step, line_length = 255.0./(n), n
					colours.clear

					while (i += 1) < n
						colours.<<(
							case sample_colour
								when 0 then i.*(step).then { |l| [ l.*(2).to_i.clamp(0, 255), l.to_i.clamp(0, 255), 255.-(l).to_i.clamp(0, 255) ] }
								when 1 then i.*(step).then { |l| [ 255, 255.-(l).to_i.clamp(0, 255), l.to_i.clamp(0, 255) ] }
								when 2 then i.*(step).then { |l| [ l.to_i.clamp(0, 255), 255.-(l).to_i.clamp(0, 255), l.to_i.clamp(0, 255) ] }
								when 3 then i.*(step).then { |l| [ l.*(2).to_i.clamp(0, 255), 255.-(l).to_i.clamp(0, 255), 100.+(l / 2).to_i.clamp(0, 255) ] }
								when 4 then i.*(step).then { |l| [ 30, 255.-(l / 2).to_i.clamp(0, 255), 110.+(l / 2).to_i.clamp(0, 255) ] }
								when 5 then i.*(step).then { |l| [ 255.-(l * 2).to_i.clamp(0, 255), l.to_i.clamp(0, 255), 200 ] }
								when 6 then i.*(step).then { |l| [ 50.+(255 - l).to_i.clamp(0, 255), 255.-(l / 2).to_i.clamp(0, 255), (l * 2).to_i.clamp(0, 255) ] }
								else  i.*(step).then { |l| [ l.*(2).to_i.clamp(0, 255), 255.-(l).to_i.clamp(0, 255), 100.+(l / 2).to_i.clamp(0, 255) ] }
							end
						)
					end

					colours.reverse! if rev
				end

				i = -1
				temp.concat "\e[38;2;#{colours[i][0]};#{colours[i][1]};#{colours[i][2]}m#{c[i]}" while (i += 1) < n

			end
			STDOUT.print(temp, "\e[0m".freeze)
			STDOUT.puts if line_break
		end
	end
}

# Get terminal width using stty
require 'io/console'
tw = STDOUT.winsize[1] rescue 64

# Art generated from https://fsymbols.com/generators/carty/
# Used utf-8, editors messes up with the font and makes development harder.
# To generate utf-8 chars to utf-8 codes using String#dump

<<~EOF.lines.map { |x| '//' + ?\s * (tw / 2.0 - x.length / 2 - 2).clamp(0, Float::INFINITY) + x.chomp + ?\s * (tw / 2 - x.length / 2.0 - 2).to_i.clamp(0, Float::INFINITY) + '//' + ?\n}.join.colourize
	#{?- * (tw / 1.25)}

	\u2591\u2588\u2588\u2588\u2588\u2588\u2557\u2591\u2588\u2588\u2588\u2588\u2588\u2588\u2557\u2591\u2588\u2588\u2588\u2588\u2588\u2588\u2588\u2557\u2591\u2588\u2588\u2588\u2588\u2588\u2557\u2591
	\u2588\u2588\u2554\u2550\u2550\u2588\u2588\u2557\u2588\u2588\u2554\u2550\u2550\u2588\u2588\u2557\u2588\u2588\u2554\u2550\u2550\u2550\u2550\u255D\u2588\u2588\u2554\u2550\u2550\u2588\u2588\u2557
	\u2588\u2588\u2551\u2591\u2591\u2588\u2588\u2551\u2588\u2588\u2588\u2588\u2588\u2588\u2554\u255D\u2588\u2588\u2588\u2588\u2588\u2557\u2591\u2591\u2588\u2588\u2551\u2591\u2591\u2588\u2588\u2551
	\u2588\u2588\u2551\u2591\u2591\u2588\u2588\u2551\u2588\u2588\u2554\u2550\u2550\u2588\u2588\u2557\u2588\u2588\u2554\u2550\u2550\u255D\u2591\u2591\u2588\u2588\u2551\u2591\u2591\u2588\u2588\u2551
	\u255A\u2588\u2588\u2588\u2588\u2588\u2554\u255D\u2588\u2588\u2551\u2591\u2591\u2588\u2588\u2551\u2588\u2588\u2588\u2588\u2588\u2588\u2588\u2557\u255A\u2588\u2588\u2588\u2588\u2588\u2554\u255D
	\u2591\u255A\u2550\u2550\u2550\u2550\u255D\u2591\u255A\u2550\u255D\u2591\u2591\u255A\u2550\u255D\u255A\u2550\u2550\u2550\u2550\u2550\u2550\u255D\u2591\u255A\u2550\u2550\u2550\u2550\u255D\u2591

	\u2591\u2588\u2588\u2588\u2588\u2588\u2557\u2591\u2588\u2588\u2557\u2591\u2591\u2591\u2588\u2588\u2557\u2588\u2588\u2588\u2588\u2588\u2588\u2557\u2591\u2591\u2588\u2588\u2588\u2588\u2588\u2588\u2557\u2591\u2588\u2588\u2588\u2588\u2588\u2557\u2591\u2588\u2588\u2588\u2588\u2588\u2588\u2557\u2591\u2591\u2588\u2588\u2588\u2588\u2588\u2588\u2557
	\u2588\u2588\u2554\u2550\u2550\u2588\u2588\u2557\u2588\u2588\u2551\u2591\u2591\u2591\u2588\u2588\u2551\u2588\u2588\u2554\u2550\u2550\u2588\u2588\u2557\u2588\u2588\u2554\u2550\u2550\u2550\u2550\u255D\u2588\u2588\u2554\u2550\u2550\u2588\u2588\u2557\u2588\u2588\u2554\u2550\u2550\u2588\u2588\u2557\u2588\u2588\u2554\u2550\u2550\u2550\u2550\u255D
	\u2588\u2588\u2551\u2591\u2591\u255A\u2550\u255D\u2588\u2588\u2551\u2591\u2591\u2591\u2588\u2588\u2551\u2588\u2588\u2588\u2588\u2588\u2588\u2554\u255D\u255A\u2588\u2588\u2588\u2588\u2588\u2557\u2591\u2588\u2588\u2551\u2591\u2591\u2588\u2588\u2551\u2588\u2588\u2588\u2588\u2588\u2588\u2554\u255D\u255A\u2588\u2588\u2588\u2588\u2588\u2557\u2591
	\u2588\u2588\u2551\u2591\u2591\u2588\u2588\u2557\u2588\u2588\u2551\u2591\u2591\u2591\u2588\u2588\u2551\u2588\u2588\u2554\u2550\u2550\u2588\u2588\u2557\u2591\u255A\u2550\u2550\u2550\u2588\u2588\u2557\u2588\u2588\u2551\u2591\u2591\u2588\u2588\u2551\u2588\u2588\u2554\u2550\u2550\u2588\u2588\u2557\u2591\u255A\u2550\u2550\u2550\u2588\u2588\u2557
	\u255A\u2588\u2588\u2588\u2588\u2588\u2554\u255D\u255A\u2588\u2588\u2588\u2588\u2588\u2588\u2554\u255D\u2588\u2588\u2551\u2591\u2591\u2588\u2588\u2551\u2588\u2588\u2588\u2588\u2588\u2588\u2554\u255D\u255A\u2588\u2588\u2588\u2588\u2588\u2554\u255D\u2588\u2588\u2551\u2591\u2591\u2588\u2588\u2551\u2588\u2588\u2588\u2588\u2588\u2588\u2554\u255D
	\u2591\u255A\u2550\u2550\u2550\u2550\u255D\u2591\u2591\u255A\u2550\u2550\u2550\u2550\u2550\u255D\u2591\u255A\u2550\u255D\u2591\u2591\u255A\u2550\u255D\u255A\u2550\u2550\u2550\u2550\u2550\u255D\u2591\u2591\u255A\u2550\u2550\u2550\u2550\u255D\u2591\u255A\u2550\u255D\u2591\u2591\u255A\u2550\u255D\u255A\u2550\u2550\u2550\u2550\u2550\u255D\u2591

	#{?- * (tw / 1.25)}
EOF

puts "Error with the output directory. Does it exist? Is it writable?" unless File.writable?(OUT_DIR)

## Grab arguments
# Show help
if ARGV.any? { |x| x[/\A\-(\-help|h)\Z/] }
	<<~EOF.display
		This program is used to generate oreo cursors.
		It can generate cursor of your defined colours.

		\u2B23 Arguments:
			1. --help | -h\t\tShow this help
			2. --config= | -c=\t\tSpecify the configration file
			\t\t\t\t[defaults to colours.conf]
			3. --version | -v\t\tShow version

		\u2B23 Config File:
			You need a config file. The syntax to put everything is:
			# This is a comment.

			Long Syntax with Attributes:
				purple = colour: #ff5, label: #fa0, shadow: #0a0, shadow_opacity: 1, stroke: #08f, stroke_opacity: 1.2
				# OR #
				purple = color: #ff5, label: #fa0, shadow: #0a0, shadow_opacity: 1, stroke: #08f, stroke_opacity: 1.2

				\u2023 "_" can be replaced with "-".
				  For example, "stroke_opacity" can be written as "stroke-opacity".

				\u2023 "colour" can be replaced with "color".
				  For example, "colour: #55f" can be written as "color: #55f".

				\u2023 ":" can be replaced with "=".
				  For example, "stroke-width: 1" can be written as "stroke-width = 1".

			If you want to generate a single colour with the default value for others:
			purple = #fff
	EOF

	exit
end

# Grab the -v | --version option
if ARGV.any? { |x| x[/\A\-(\-version|v)\Z/] }
	"You are running #{Process.argv0} version #{VERSION}".colourize
	exit
end

# Grab the configuration file from arguments, defaults to colours.conf
config_file, cf = ARGV.select { |x| x[/\A\-(\-config|c)=.+\Z/] }[-1], nil
cf = config_file.split(?=)[1] if config_file

CONFIG_FILE = if cf && File.readable?(cf)
	cf
elsif cf && !File.readable?(cf)
	puts ":: #{cf} is not readable, using colours.conf"
	sleep 1
	File.join(__dir__, 'colours.conf')
else
	File.join(__dir__, 'colours.conf')
end

# Define colour hash, which contains arrays of colour attributes for each theme
colours = {}

# Note down the invalid colours, syntaxes which caused files to skip
skipped_files = []

def colour_validation!(colour, i, silent = false)
		# Colours are uppercased
		colour.upcase!

		# Spaces are trimmed
		colour.strip!

		# Make sure all the colour characters are valid hex
		if !!colour[/[^a-fA-F0-9#]/] || ![3, 6].include?(colour.start_with?(?#) ? colour[1..-1].length : colour.length)
			puts %Q(\e[5;1;31;255;80;80m:: Line #{i.next}: "#{colour}" is not a valid colour\e[0m) unless silent
			return false
		end

		# Make sure colour starts with #
		colour.prepend(?#) unless colour.start_with?(?#)

		# Make sure colour is 6 characters long
		colour.replace(?# + colour.chars[1..-1].map { |y| y + y }.join) if colour.length == 4
		true
end

if File.readable?(CONFIG_FILE)
	puts "Reading configuration file #{CONFIG_FILE}\n\n"
	attrs = {}

	IO.readlines(CONFIG_FILE).each_with_index do |x, i|
		next if x.start_with?(?#) || x.strip.empty?

		# Configuration file to Ruby hash
		attrs = x.split(?=)[1..-1].join(?=).split(?,).map do |_sa|
			_sa.split(/[:\=]/).each(&:strip!).then { |_ky1, _vl1| [_ky1.to_s, _vl1.to_s] }
		end.to_h.key_to_sym

		# Label colour
		label = '#fff'
		l = +attrs[:label].to_s
		label = l if colour_validation!(l, i, true)
		colour_validation!(label, 0)

		# Shadow colour
		shadow = '#000'
		s = +attrs[:shadow].to_s
		shadow = s if colour_validation!(s, i, true)
		colour_validation!(shadow, 0)

		# Shadow opacity
		shadow_opacity = '0.3'
		so = +(attrs[:'shadow_opacity'] || attrs[:'shadow-opacity']).to_s
		shadow_opacity = +so.strip unless so.empty?

		# Stroke colour
		stroke = '#fff'
		st = +attrs[:stroke].to_s
		stroke = st if colour_validation!(st, i, true)
		colour_validation!(stroke, 0)

		# Stroke opacity
		stroke_opacity = ?0
		st_o = +(attrs[:stroke_opacity] || attrs[:'stroke-opacity']).to_s
		stroke_opacity = st_o.strip unless st_o.empty?

		# Stroke width
		stroke_width = ?0
		st_w = +(attrs[:stroke_width] || attrs[:'stroke-width']).to_s
		stroke_width = st_w unless st_w.empty?

		# Get cursor name and colour
		name, colour = x.split(?=).then { |y| [+y[0].to_s.strip, +y[1].to_s.split[0].to_s.strip] }
		colour = +(attrs[:colour] || attrs[:color]).to_s
		colour = x.split(?=)[1].to_s.strip if colour.empty?

		# Make sure colour name is not 0 characters long or too long
		if name.length.zero? || name.length > 512
			puts %Q(:: Line #{i.next}: "#{name}" is not a valid name.)
			skipped_files << [x, i, 'NameError']
			next
		end

		if colour.length.zero?
			puts %Q(:: Line #{i.next}: colour is empty. Example, "colour: #ff50a6" will generate a pink cursor set. Skipping now.)
			skipped_files << [x, i, 'NoColoursDefined']
			next
		end

		unless colour_validation!(colour, i)
			skipped_files << [x, i, 'ParseError']
			next
		end

		# Print RGB in the terminal, respective to the config file
		r, g, b = colour.chars.drop(1).each_slice(2).map { |_x| _x.join.to_i(16) }
		lr, lg, lb = label.chars.drop(1).each_slice(2).map { |_x| _x.join.to_i(16) }
		sr, sg, sb = shadow.chars.drop(1).each_slice(2).map { |_x| _x.join.to_i(16) }
		str, stg, stb = stroke.chars.drop(1).each_slice(2).map { |_x| _x.join.to_i(16) }

		puts ":: Detected: #{name} \e[1;38;2;#{r};#{g};#{b}m\u2b22 #{colour}"\
			"\e[0m | Label \e[38;2;#{lr};#{lg};#{lb}m\u2b22 #{label}"\
			"\e[0m | Shadow(#{shadow_opacity}) \e[38;2;#{sr};#{sg};#{sb}m\u2b22 #{shadow}"\
			"\e[0m | Stroke(#{stroke_opacity}) \e[38;2;#{str};#{stg};#{stb}m\u2b22 #{stroke}"\
			"\e[0m"

		# Generate a hash out of arrays where keys correspond to the colour/directory name
		colours.merge!(name => [colour, label, shadow, shadow_opacity, stroke, stroke_opacity, stroke_width])
	end
else
	abort ":: Unable to read #{CONFIG_FILE}"
end

# Show some fast yet cool animation!
ANIMS = %w(| / - \\).rotate(-1)
LOADER_TXT = 'Progress'
loader_counter = -1

begin
	colours.each do |x, y|
		# Print the loading animations!
		loader_counter += 1
		lc = loader_counter % LOADER_TXT.length
		percent_done = loader_counter.next.*(100)./(colours.size)
		print "\e[2K#{ANIMS.rotate![0]} "\
			"#{LOADER_TXT[0...lc]}#{LOADER_TXT[lc].swapcase}#{LOADER_TXT[lc + 1..-1]} #{percent_done}%"\
			"#{?..*(loader_counter.%(3).next)}\r"

		# Make the directory name is the colour name mentioned in the config file
		dirname = File.join(OUT_DIR, "oreo_#{x}_cursors")

		# Make the directory mentioned in the config file
		# We will store svg files here, mapped to colours
		Dir.mkdir(dirname) unless Dir.exist?(dirname)

		# Iterate over each base files and add colours to them,
		# and write them to the directories fetched from configuration file
		Dir.glob("#{BASE}/*svg.oreo").each do |z|
			if File.file?(z)
				# Destination file has the name.svg converted from name.svg.oreo
				dest_file = File.join(dirname, File.basename(z).split(?..freeze).tap(&:pop).join(?..freeze))

				# Read the base file
				data = IO.read(z)

				# Cursor Opacity [ doesn't read from config file, better just leave it 1 ]
				data.gsub!(/\{\{\s*opacity\s*\}\}/i, ?1.freeze)

				# Change Background Colour
				data.gsub!(/\{\{\s*background\s*\}\}/i, y[0])

				# Change Label Colour
				data.gsub!(/\{\{\s*label\s*\}\}/i, y[1])

				# Change Shadow Colour
				data.gsub!(/\{\{\s*shadow\s*\}\}/i, y[2])

				# Change Shadow Opacity
				data.gsub!(/\{\{\s*shadow\s*opacity\s*\}\}/i, y[3])

				# Change Stroke Colour
				data.gsub!(/\{\{\s*stroke\s*\}\}/i, y[4])

				# Change Stroke Opacity
				data.gsub!(/\{\{\s*stroke\s*opacity\s*\}\}/i, y[5])

				# Change Stroke Width
				data.gsub!(/\{\{\s*stroke\s*width\s*\}\}/i, y[6])

				# Write converted data to destination file unless the same file exist
				next if File.readable?(dest_file) && data == IO.read(dest_file)

				IO.write(dest_file, data, encoding: 'UTF-8'.freeze)
			end
		end

		# Write to index file
		IO.write(File.join(dirname, 'index.theme'.freeze), INDEX_THEME.call(x), encoding: 'UTF-8'.freeze)

		r, g, b = y[0].chars.drop(1).each_slice(2).map { |_x| _x.join.to_i(16) }
		puts ":: Created \e[38;2;#{r};#{g};#{b}m#{dirname}/\e[0m"
	end
rescue Exception
	puts "\n\nUh oh! Program crashed!\n\t#{$!.backtrace.join(?\n)}\n\t#{$!}".colourize
else
	puts ":: Successfully created src/ files"

	# If files are skipped, print them in the last to bring it to the attention of the user
	unless skipped_files.empty?
		puts <<~EOF
			\nNote that some files were skipped due to invalid configuration:
			#{skipped_files.map.with_index { |_x, _i| "\tLine #{_x[1] + 1}: #{_x[0].strip} (\e[1m#{_x[2]}\e[0m)" }.join(?\n) }
		EOF
	end
end
