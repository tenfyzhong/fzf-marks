function mark -d 'mark this directory'
    argparse -i -X 1 'h/help' -- $argv 2>/dev/null

    if test $status -ne 0
        return 1
    end

    if set -q _flag_help
        _mark_help
        return 0
    end

    set tag "$argv"
    # use the current directory name as the tag
    if test -z "$tag"
        set tag (pwd)
        set tag (basename $tag)
    end


    command -v fzf > /dev/null 2>&1 or return
    _init_fzf_marks

    set -l mark_to_add "$tag : "(pwd)

    if command grep -qxFe "$mark_to_add" "$FZF_MARKS_FILE"
        echo "** The following mark already exists **"
    else
        echo "$mark_to_add" >> "$FZF_MARKS_FILE"
        echo "** The following mark has been added **"
    end
    echo "$mark_to_add" | _color_marks
end

function _mark_help
    printf %s\n \
        'mark: mark this directory' \
        'Usage: mark [options] tag' \
        '' \
        'Options:' \
        '  -h/--help            print this help message'
end
