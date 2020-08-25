#!/usr/bin/env ruby
# Frozen_String_Literal: true
# Written by Sourav Goswami <souravgoswami@protonmail.com>

## Check Ruby version
abort "Error! Atleast Ruby 2.4 is needed! You are running #{RUBY_VERSION} (#{RUBY_PLATFORM})" if RUBY_VERSION.split(?.).first(2).join.to_i < 24

# Location of the base cursors
BASE = File.join(__dir__, 'oreo_base_cursors')

# Configuration file to read
CONFIG_FILE = 'colours.conf'

# Output directory
OUT_DIR = File.join(File.expand_path('..', __dir__), 'src')

# Content of index.theme inside each theme
INDEX_THEME = proc do |x|
	<<~EOF
		[Icon Theme]
		Name=Oreo #{x.split(?_).map(&:capitalize).join(?\s)} Cursors
		Comment=design by varlesh | colour by #{Process.argv0}
	EOF
end

### Code ###
Kernel.class_exec { define_method(:then) { |&block| block === self } }
Dir.define_singleton_method(:children) { |arg| Dir.entries(arg).drop(2) }

puts "Error with the output directory. Does it exist? Is it writable?" unless File.writable?(OUT_DIR)

colours = {}

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
		label = +'#fff'
		l = +x.split[3].to_s
		label = l if colour_validation!(l, i, true)
		colour_validation!(label, 0)

		# Shadow colour
		shadow = +'#000'
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

		# Print RGB in the terminal
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
	dirname = File.join(OUT_DIR, "oreo_#{x}_cursors")
	Dir.mkdir(dirname) unless Dir.exist?(dirname)

	# Delete files from dirname if it's not empty. The reason is to get rid of excess files.
	Dir.children(dirname).each do |x|
		file = File.join(dirname, x)
		File.delete(file)
	end

	Dir.glob("#{BASE}/*svg.oreo").each do |z|
		if File.file?(z)
			dest_file = File.join(dirname, File.basename(z).split(?.).tap(&:pop).join(?.))
			data = IO.read(z)

			# Background Colour
			data.gsub!(/\{\{ background \}\}/i, y[0])

			# Label Colour
			data.gsub!(/\{\{ label \}\}/i, y[1])

			# Shadow Colour
			data.gsub!(/\{\{ shadow \}\}/i, y[2])

			# Shadow Opacity
			data.gsub!(/\{\{ shadow\s*opacity \}\}/i, y[3])

			IO.write(dest_file, data)
		end
	end

	# Write to index file
	IO.write(File.join(dirname, 'index.theme'), INDEX_THEME.call(x))
end
