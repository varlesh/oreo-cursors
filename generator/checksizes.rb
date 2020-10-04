#!/usr/bin/env ruby
# Encoding: UTF-8
# Script reads cursors.conf and retuns the sizes for cursors

# Mention default values if empty
DEFAULTS = '32 64'.freeze

# Get the last defined sizes
n = IO.readlines(File.join(File.expand_path('..', __dir__), 'cursors.conf')).select { |x| x[/^\s*sizes\s*=.*$/] }[-1]

out = if n
	sizes = n.split(?=).drop(1).join(' ').split(/[,\s]/).reject(&:empty?).map(&:strip)
	sizes.empty? ? DEFAULTS : sizes.join(' ')
else
	DEFAULTS
end

if __FILE__ == $0
	STDOUT.write(out)
else
	SIZES = out.split(' ').map(&:to_i)
end
