# This file is included in the generator.conf
# This will help you define your author name mapped with cursor name.
# Each theme calls this proc below if the file is not found, it's created.
# This is a necessity to run the application.
# Creating this file also adds more flexibility.

# Here x is the filename of the cursor
INDEX_THEME = proc do |x|
	<<~EOF
		[Icon Theme]
		Name=Oreo #{x.split(?_).map(&:capitalize).join(?\s)} Cursors
		Comment=design by varlesh #{"| colour by #{File.basename(Process.argv0)}" if x.downcase.include?('spark') }
	EOF
end
