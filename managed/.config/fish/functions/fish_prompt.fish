function fish_prompt
set -g __fish_git_prompt_describe_style; echo ' '
echo (fish_git_prompt)
echo (pwd) '> '
end
