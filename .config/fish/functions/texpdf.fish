function texpdf
    argparse h/help 'c/compiler=?' 'b/bib=?' t/tidy p/purge -- $argv

    if set -ql _flag_h
        echo 'texpdf [OPTIONS] [PAPER]'
        echo '  -h  --help		Show this message'
        echo '  -t  --tidy		Remove intermediate files'
        echo '  -p  --purge		Remove intermediate files and output PDF'
        echo '  -c  --compiler	Change LaTeX compiler (default: pdflatex)'
        echo '  -b  --bib		Change bibliography compiler (default: bibtex)'
        echo 'The default paper is main.pdf'

        return 0
    end

    if test -n "$argv[1]"
        set PAPER $argv[1]
    else
        set PAPER main
    end

    if set -ql _flag_p
        /bin/rm $PAPER.pdf 2>/dev/null
        /bin/rm $PAPER.aux $PAPER.bbl $PAPER.blg $PAPER.brf $PAPER.btx $PAPER.log $PAPER.out 2>/dev/null
        return
    end

    if set -ql _flag_t
        /bin/rm $PAPER.aux $PAPER.bbl $PAPER.blg $PAPER.brf $PAPER.btx $PAPER.log $PAPER.out 2>/dev/null
        return
    end

    if test -n "$_flag_b"
        set BIB $_flag_b
    else
        set BIB bibtex
    end

    if test -n "$_flag_c"
        set CC $_flag_c
    else
        set CC pdflatex
    end

    eval $CC $PAPER.tex </dev/null
    eval $BIB $PAPER
    eval $CC $PAPER.tex </dev/null >/dev/null
    eval $CC $PAPER.tex </dev/null >/dev/null
    eval $CC $PAPER.tex </dev/null
end
