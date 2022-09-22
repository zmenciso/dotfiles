function mdpdf -d "Convert markdown to PDF via pandoc and xelatex"
	set pandoc_cmd "pandoc --pdf-engine=xelatex --highlight-style=kate"

	if contains "-n" $argv
		set pandoc_cmd $pandoc_cmd --number-sections
	end

	if test -n "$argv[3]"
		set pandoc_cmd $pandoc_cmd --mainfont=$argv[3]
	end

	command $pandoc_cmd $argv[1] -o $argv[2]
end
