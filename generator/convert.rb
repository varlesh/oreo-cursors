#!/usr/bin/env ruby
# Enconding: UTF-8
# Frozen_String_Literal: false
# Warn_Indent: true

# Written by Sourav Goswami <souravgoswami@protonmail.com>

# Check Ruby version
abort "Error! Atleast Ruby 2.4 is needed! You are running #{RUBY_VERSION} (#{RUBY_PLATFORM})" if RUBY_VERSION.split(?.).first(2).join.to_i < 24

### User definable ###
## Location of the base cursors
BASE = File.join(__dir__, 'oreo_base_cursors')

## Configuration file to read
CONFIG_FILE = 'colours.conf'

## Output directory
OUT_DIR = File.join(File.expand_path('..', __dir__), 'src')

## Content of index.theme inside each theme
INDEX_THEME = proc do |x|
	<<~EOF
		[Icon Theme]
		Name=Oreo #{x.split(?_).map(&:capitalize).join(?\s)} Cursors
		Comment=design by varlesh | colour by #{Process.argv0}
	EOF
end

### Code ###

# Monkey Patches for Ruby 2.4 to 2.5
Kernel.class_exec { define_method(:then) { |&block| block === self } } unless Kernel.respond_to?(:then)
Dir.define_singleton_method(:children) { |arg| Dir.entries(arg).drop(2) } unless Dir.respond_to?(:children)

puts "Error with the output directory. Does it exist? Is it writable?" unless File.writable?(OUT_DIR)

colours = {}

def colourize(string)
	colours, line_length, temp = [], -1, ''
	sample_colour, rev, repeat = rand(7), rand < 0.5, rand < 0.5

	string.each_line do |c|
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
		end

		i = -1
		temp.concat "\e[1;38;2;#{colours[i][0]};#{colours[i][1]};#{colours[i][2]}m#{c[i]}" while (i += 1) < n
	end

	STDOUT.print(temp, "\e[0m".freeze)

end

require 'io/console'
colourize <<~EOF.lines.map { |x| '//' + ?\s * (STDOUT.winsize[1] / 2 - x.length / 2 - 3).clamp(0, Float::INFINITY) + x.chomp + ?\s * (STDOUT.winsize[1] / 2 - x.length / 2.0 - 3).to_i.clamp(0, Float::INFINITY) + '//' + ?\n}.join
	#{?- * (STDOUT.winsize[1] - 20)}
	  .d88b.  d8888b. d88888b  .d88b.
	 .8P  Y8. 88  `8D 88'     .8P  Y8.
	 88    88 88oobY' 88ooooo 88    88
	 88    88 88`8b   88~~~~~ 88    88
	 `8b  d8' 88 `88. 88.     `8b  d8'
	  `Y88P'  88   YD Y88888P  `Y88P'

	  .o88b. db    db d8888b. .d8888.  .d88b.  d8888b. .d8888.
	 d8P  Y8 88    88 88  `8D 88'  YP .8P  Y8. 88  `8D 88'  YP
	8P      88    88 88oobY' `8bo.   88    88 88oobY' `8bo.
	 8b      88    88 88`8b     `Y8b. 88    88 88`8b     `Y8b.
	 Y8b  d8 88b  d88 88 `88. db   8D `8b  d8' 88 `88. db   8D
	  `Y88P' ~Y8888P' 88   YD `8888Y'  `Y88P'  88   YD `8888Y'
	#{?- * (STDOUT.winsize[1] - 20)}
EOF

def colour_validation!(colour, i, silent = false)
		# Colours are uppercased
		colour.upcase!

		# Spaces are trimmed
		colour.strip!

		# Make sure all the colour characters are valid hex
		if !!colour[/[^a-fA-F0-9#]/] || ![3, 6].include?(colour.start_with?(?#) ? colour[1..-1].length : colour.length)
			puts %Q(:: Line #{i.next}: "#{colour}" is not a valid colour) unless silent
			return false
		end

		# Make sure colour starts with #
		colour.prepend(?#) unless colour.start_with?(?#)

		# Make sure colour is 6 characters long
		colour.replace(?# + colour.chars[1..-1].map { |y| y + y }.join) if colour.length == 4
		true
end

if File.readable?(CONFIG_FILE)
	IO.readlines(CONFIG_FILE).each_with_index do |x, i|
		next if x.start_with?(?#) || x.strip.empty?

		# Label colour
		label = '#fff'
		l = +x.split[3].to_s
		label = l if colour_validation!(l, i, true)
		colour_validation!(label, 0)

		# Shadow colour
		shadow = '#000'
		s = +x.split[4].to_s
		shadow = s if colour_validation!(s, i, true)
		colour_validation!(shadow, 0)

		# Shadow opacity
		shadow_opacity = '0.3'
		so = x.split.map(&:strip).select { |y| y.to_f.to_s == y || y.to_i.to_s == y }[-1]
		shadow_opacity = +so.strip if so

		# Get cursor name and colour
		name, colour = x.split(?=).then { |y| [+y[0].to_s.strip, +y[1].to_s.split[0].to_s.strip] }

		# Make sure colour name is not 0 characters long or too long
		if name.length.zero? || name.length > 512
			puts %Q(:: Line #{i.next}: "#{name}" is not a valid name.)
			next
		end

		next unless colour_validation!(colour, i)

		# Print RGB in the terminal, respective to the config file
		r, g, b = colour[1..2].to_i(16), colour[3..4].to_i(16), colour[5..6].to_i(16)
		lr, lg, lb = label[1..2].to_i(16), label[3..4].to_i(16), label[5..6].to_i(16)
		sr, sg, sb = shadow[1..2].to_i(16), shadow[3..4].to_i(16), shadow[5..6].to_i(16)

		puts "\e[1;38;2;#{r};#{g};#{b}m:: #{name}:"\
			"\e[0m \e[38;2;#{r};#{g};#{b}m#{colour}"\
			"\e[0m | \e[38;2;#{lr};#{lg};#{lb}mLabel"\
			"\e[0m | \e[38;2;#{sr};#{sg};#{sb}mShadow(#{shadow_opacity})"\
			"\e[0m |"

		colours.merge!(name => [colour, label, shadow, shadow_opacity])
	end
else
	puts ":: Unable to read #{CONFIG_FILE}"
end

colours.each do |x, y|
	# Make the directory name is the colour name mentioned in the config file
	dirname = File.join(OUT_DIR, "oreo_#{x}_cursors")

	# Make the directory mentioned in the config file
	# We will store svg files here, mapped to colours
	Dir.mkdir(dirname) unless Dir.exist?(dirname)

	# Delete files from dirname if it's not empty. The reason is to get rid of excess files.
	Dir.children(dirname).each do |x|
		file = File.join(dirname, x)
		File.delete(file) if File.file?(file)
	end

	# Iterate over each base files and add colours to them,
	# and write them to the directories fetched from configuration file
	Dir.glob("#{BASE}/*svg.oreo").each do |z|
		if File.file?(z)
			# Destination file has the name.svg converted from name.svg.oreo
			dest_file = File.join(dirname, File.basename(z).split(?..freeze).tap(&:pop).join(?..freeze))

			# Read the base file
			data = IO.read(z)

			# Change Background Colour
			data.gsub!(/\{\{ background \}\}/i, y[0])

			# Change Label Colour
			data.gsub!(/\{\{ label \}\}/i, y[1])

			# Change Shadow Colour
			data.gsub!(/\{\{ shadow \}\}/i, y[2])

			# Change Shadow Opacity
			data.gsub!(/\{\{ shadow\s*opacity \}\}/i, y[3])

			# Write converted data to destination file
			IO.write(dest_file, data)
		end
	end

	# Write to index file
	IO.write(File.join(dirname, 'index.theme'.freeze), INDEX_THEME.call(x))
end
