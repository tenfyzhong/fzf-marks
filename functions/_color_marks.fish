function _color_marks
    if test "$FZF_MARKS_NO_COLORS" = "1"
        cat
    else
        set -l esc (printf '\033')
        set -l c_lhs $FZF_MARKS_COLOR_LHS
        set -lq c_lhs[1]; or set c_lhs[1] 39
        set -l c_rhs $FZF_MARKS_COLOR_RHS
        set -lq c_rhs[1]; or set c_rhs[1] 36
        set -l c_colon $FZF_MARKS_COLOR_COLON
        set -lq c_colon[1]; or set c_colon[1] 33
        sed "s/^\\(.*\\) : \\(.*\\)\$/"$esc"["$c_lhs"m\\1"$esc"[0m "$esc"["$c_colon"m:"$esc"[0m "$esc"["$c_rhs"m\\2"$esc"[0m/"
    end
end
