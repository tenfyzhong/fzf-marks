function _handle_symlinks_mark
    if test -L $FZF_MARKS_FILE
        set -l link (readlink "$FZF_MARKS_FILE")
        switch $link
            case '/*'
                echo $link
            case '*'
                echo (dirname $FZF_MARKS_FILE)/$link
        end
    else
        echo $FZF_MARKS_FILE
    end
end

