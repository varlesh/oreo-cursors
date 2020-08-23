#!/usr/bin/env ruby
# Frozen_String_Literal: true

REPLACE = "#4E81ED".upcase.freeze
BASE = File.join(__dir__, 'oreo_base_cursors')
CONFIG_FILE = 'colours.conf'
OUT_DIR = File.join(File.expand_path('..', __dir__), 'src')

# Content of index.theme inside each theme
INDEX_THEME = proc do |x|
	<<~EOF
		[Icon Theme]
		Name=Oreo #{x.split(?_).map(&:capitalize).join(?\s)} Cursors
		Comment=design by varlesh
	EOF
end

### Code ###
puts "Error with the output directory. Does it exist? Is it writable?" unless File.writable?(OUT_DIR)

colours = {}
hex = (?0..?9).to_a + (?a..?f).to_a << ?#

if File.readable?(CONFIG_FILE)
	IO.readlines(CONFIG_FILE).each_with_index do |x, i|
		next if x.start_with?(?#) || x.strip.empty?

		name, colour = x.split(?=).then { |y| [y[0].to_s.strip, y[1].to_s.strip] }

		# Make sure colour name is not 0 characters long or too long
		if name.length.zero? || name.length > 512
			puts %Q(:: Line #{i.next}: "#{name}" is not a valid name.)
			next
		end

		# Make sure all the colour characters are valid hex
		if !colour.chars.all? { |y| hex.include?(y.downcase) } || ![3, 6, 4, 7].include?(colour.length)
			puts %Q(:: Line #{i.next}: "#{colour}" is not a valid colour)
			next
		end

		# Make sure colour starts with #
		colour.prepend(?#) unless colour.start_with?(?#)

		# Make sure colour is 6 characters long
		colour.replace(?# + colour.chars[1..-1].map { |y| y + y }.join) if colour.length == 4

		# Print RGB in the terminal
		r, g, b = colour[1..2].to_i(16), colour[3..4].to_i(16), colour[5..6].to_i(16)
		puts "\e[38;2;#{r};#{g};#{b}m#{name}: #{colour}\e[0m"

		colours.merge!(name => colour)
	end
else
	puts "Unable to read #{CONFIG_FILE}"
end

r = []
r << REPLACE[1] if REPLACE.split('').drop(1).uniq.count == 1

str = REPLACE[1..-1].downcase.+(REPLACE[1..-1].upcase).split('')
r.concat(str.combination(6).to_a.map { |x| x.prepend(?#).join } ) unless str.all? { |x| x == x.to_i }
r.uniq!

colours.each do |x, y|
	dirname = File.join(OUT_DIR, "oreo_#{x}_cursors")
	Dir.mkdir(dirname) unless Dir.exist?(dirname)

	Dir.glob("#{BASE}/*.svg").each do |z|
		if File.file?(z)
			dest_file = File.join(dirname, File.basename(z))
			data = IO.read(z)
			r.each { |c| data.gsub!(c, y) }
			IO.write(dest_file, data)
		end
	end

	IO.write(File.join(dirname, 'index.theme'), INDEX_THEME.call(x))
end
