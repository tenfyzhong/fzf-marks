function fzm
    command -v fzf > /dev/null 2>&1 or return
    _init_fzf_marks

    set -l marks_del $FZF_MARKS_DELETE
    set -lq marks_del[1]; or set marks_del[1] "ctrl-d"

    set lines (_color_marks < $FZF_MARKS_FILE | eval $FZF_MARKS_COMMAND \
               --ansi \
               --expect="$marks_del" \
               --multi \
               --bind=ctrl-y:accept,ctrl-t:toggle+down \
               --query=$argv \
               --select-1 \
               --tac)
    if test -z "$lines"
        commandline -f repaint
        return 1
    end
    set -l key (echo "$lines" | head -1 | string split " ")
    if test $marks_del = $key[1]
        dmark $key[2..-1]
    else
        jump (echo "$lines" | tail -1)
    end
end

function jump
    set jumpline $argv[1]
    if test -n $jumpline
        set -l jumpdir (echo "$jumpline" | sed 's/.*: \(.*\)$/\1/' | sed "s#^~#$HOME#")
        set -l bookmarks (_handle_symlinks)
        cd $jumpdir
        commandline -f repaint
    end
end

function dmark
    set marks_to_delete $argv
    set -l bookmarks (_handle_symlinks)
    echo "** The following marks have been deleted **"
    for i in (seq 1 3 (count $marks_to_delete))
        set -l begin $i
        set -l end (math $i+2)
        set -l raw $marks_to_delete[$begin..$end]
        set -l line (string replace -a "/" "\/" -- "$raw")
        perl -n -i -e "print unless /^\Q$line\E\$/" "$bookmarks"
        echo "$raw" | _color_marks
    end
    commandline -f repaint
end

