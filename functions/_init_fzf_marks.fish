function _init_fzf_marks
    if test -z "$FZF_MARKS_FILE"
        set -g FZF_MARKS_FILE "$HOME/.fzf-marks"
    end

    if test ! -f "$FZF_MARKS_FILE"
        touch "$FZF_MARKS_FILE"
    end

    if test -z "$FZF_MARKS_COMMAND"
        set -l fzf_version (fzf --version | awk -F. '{ print $1 * 1e6 + $2 * 1e3 + $3 }')
        set -l minimum_version 16001

        if test $fzf_version -gt $minimum_version
            set -g FZF_MARKS_COMMAND fzf --height 40% --reverse --header=\'ctrl-y:jump, ctrl-t:toggle, ctrl-d:delete\'
        else if test $FZF_TMUX -eq 1
            set -l tmux_height $FZF_TMUX_HEIGHT
            set -lq tmux_height[1]; or set tmux_height[1] 40
            set -g FZF_MARKS_COMMAND "fzf-tmux -d$tmux_height"
        else
            set -g FZF_MARKS_COMMAND "fzf"
        end
    end

end
