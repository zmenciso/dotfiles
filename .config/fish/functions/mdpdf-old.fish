function mdpdf -d "Convert markdown to PDF via pandoc and xelatex"
    set texhead '%Change background color for inline code and quote style
\definecolor{bgcolor}{HTML}{FCE8E8}
\let\oldtexttt\texttt

\renewcommand{\texttt}[1]{
  \colorbox{bgcolor}{\oldtexttt{#1}}
}

\usepackage{siunitx}
\usepackage{hyperref}

\@ifpackageloaded{hyperref}{}{%
  \RequirePackage{float}%
  \RequirePackage[unicode, pdftex, CJKbookmarks]{hyperref}%
  \RequirePackage{algorithm}%
}

\urlstyle{rm}
\hypersetup{
  breaklinks=true,
  unicode=true,
  citebordercolor=0.7 1 0.7,
  filebordercolor=0 0.5 0.5,
  linkbordercolor=1 0.7 0.7,
  menubordercolor=1 0.7 0.0,
  urlbordercolor=0.8 0.8 1,
  runbordercolor=1 0.7 1
}'

    set pandoc_args "--pdf-engine=xelatex" \
        "--highlight-style=tango" \
        "-V colorlinks -V urlcolor=NavyBlue" \
        "-V geometry:\"top=2.54cm, bottom=2.54cm, left=2.54cm, right=2.54cm\"" \
        "-H head.tex"

    argparse --min-args=1 h/help n/number-sections 'f/font=?' 'o/output=?' -- $argv

    if set -ql _flag_h
        echo 'mdpdf [OPTIONS] INPUT'
        echo '  -h  --help        Show this message'
        echo '  -n  --number      Number sections and produce a ToC'
        echo '  -f  --font        Change main font'
        echo '  -o  --ouptut      Specify output filename'

        exit 0
    end

    set rpath (dirname $argv[1])

    if not test -f $rpath/head.tex
        echo -n $texhead >$rpath/head.tex
        set cleanup
    end

    set -ql _flag_f
    and set pandoc_args --mainfont=$_flag_f $pandoc_args

    set -ql $_flag_n
    and set pandoc_args --toc -N $pandoc_args

    if set -ql _flag_o
        set output $_flag_o
    else
        set output (string split '.' $argv[1])[1].pdf
    end

    echo pandoc $pandoc_args $argv[1] -o $output
    pandoc $pandoc_args $argv[1] -o $output

    set -ql cleanup
    and /bin/rm $rpath/head.tex
end
