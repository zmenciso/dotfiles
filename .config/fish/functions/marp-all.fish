function marp-all
	marp --pdf --pdf-outline --pdf-notes --allow-local-files $argv
	marp --notes $argv
	marp $argv
end
