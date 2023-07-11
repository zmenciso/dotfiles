function marp-all
    if test (count $argv) = 0
        set argv '*.md'
    end

	marp --pdf --pdf-outline --pdf-notes --allow-local-files $argv
	marp --notes $argv
	marp $argv
end
