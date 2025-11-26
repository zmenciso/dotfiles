function mdpdf -d "Convert markdown to PDF via pandoc and xelatex"
    # Uses the excellent template from 
    # https://github.com/Wandmalfarbe/pandoc-latex-template

    # ---
    # title: "The Document Title"
    # author: [Example Author, Another Author]
    # date: "2017-02-20"
    # keywords: [Markdown, Example]
    # ...

    # See the pandoc variables here: https://pandoc.org/MANUAL.html#variables-for-latex

    # Custom Variables:
    #   titlepage (defaults to false)
    #   titlepage-color
    #   titlepage-text-color (defaults to 5F5F5F)
    #   titlepage-rule-color (defaults to 435488)
    #   titlepage-rule-height (defaults to 4)
    #   titlepage-logo
    #   titlepage-background
    #   page-background
    #   page-background-opacity (defaults to 0.2)
    #   caption-justification (defaults to raggedright)
    #   toc-own-page (defaults to false)
    #   listings-disable-line-numbers (defaults to false)
    #   listings-no-page-break (defaults to false)
    #   disable-header-and-footer (default to false)
    #   header-left (defaults to the title)
    #   header-center
    #   header-right (defaults to the date)
    #   footer-left (defaults to the author)
    #   footer-center
    #   footer-right (defaults to the page number)
    #   footnotes-pretty (defaults to false)
    #   footnotes-disable-backlinks (defaults to false)
    #   book (defaults to false)
    #   logo-width (defaults to 35mm), see https://github.com/tweh/tex-units
    #   first-chapter (defaults to 1)
    #   float-placement-figure (defaults to H)
    #   table-use-row-colors (defaults to false)
    #   code-block-font-size (defaults to \small)
    #   watermark (defaults to none)

    set -l USERDIR (pandoc --version | grep 'User data directory')
    set -l USERDIR (string split ': ' $USERDIR)[2]

    if not test -f $USERDIR/templates/eisvogel.latex
        set TEMPDIR (mktemp -d)
        git clone https://github.com/Wandmalfarbe/pandoc-latex-template.git $TEMPDIR/eisvogel
        git clone https://github.com/jgm/pandoc-templates.git $TEMPDIR/base

        if not test -d $USERDIR/templates
            mkdir -p $USERDIR/templates
        end

        /bin/cp $TEMPDIR/base/* $USERDIR/templates
        /bin/cp $TEMPDIR/eisvogel/template-multi-file/* $USERDIR/templates
    end

    set pandoc_args --listings \
        "--template=eisvogel" \
        "--pdf-engine=pdflatex"
    # "--highlight-style=tango" \

    argparse --min-args=1 h/help n/number 'o/output=?' -- $argv

    if set -ql _flag_h
        echo 'mdpdf [OPTIONS] INPUT'
        echo '  -h  --help          Show this message'
        echo '  -o  --ouptut        Specify output filename'
        echo '  -n  --number        Number sections'
        echo '  -t  --toc           Create table of content'

        exit 0
    end

    set -ql $_flag_n
    and set pandoc_args --number-sections $pandoc_args

    set -ql $_flag_t
    and set pandoc_args --toc $pandoc_args

    if set -ql _flag_o
        set output $_flag_o
    else
        set output (string split '.' $argv[1])[1].pdf
    end

    echo pandoc $pandoc_args $argv[1] -o $output
    pandoc $pandoc_args $argv[1] -o $output
end
