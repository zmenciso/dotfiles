function mdpdf -d "Convert markdown to PDF via pandoc and xelatex"
    set texhead '%Change background color for inline code and quote style
\definecolor{bgcolor}{HTML}{FCE8E8}
\let\oldtexttt\texttt

\renewcommand{\texttt}[1]{
    \colorbox{bgcolor}{\oldtexttt{#1}}
}'

    set pandoc_args "--pdf-engine=xelatex" \
        "--highlight-style=tango" \
        # "-V geometry:\"top=2.54cm, bottom=2.54cm, left=2.54cm, right=2.54cm\"" \
        "-V colorlinks -V urlcolor=NavyBlue" \
        "-H /tmp/head.tex"

    argparse --min-args=1 h/help n/number-sections 'f/font=?' 'o/output=?' -- $argv

    if set -ql _flag_h
        echo 'mdpdf [OPTIONS] INPUT'
        echo '  -h  --help      Show this message'
        echo '  -n  --number    Number sections and produce a ToC'
        echo '  -f  --font      Change main font'
        echo '  -o  --ouptut    Specify output filename'

        exit 0
    end

    if not test -f /tmp/head.tex
        echo -n $texhead >/tmp/head.tex
    end

    set mainfont $_flag_f
    if test -n "$mainfont"
        set pandoc_args --mainfont=$mainfont $pandoc_args
    end

    if test -n "$_flag_n"
        set pandoc_args --toc -N $pandoc_args
    end

    set output $_flag_o
    if test -z "$output"
        set output (string split '.' $argv[1])[1].pdf
    end

    eval pandoc $pandoc_args $argv[1] -o $output
end
