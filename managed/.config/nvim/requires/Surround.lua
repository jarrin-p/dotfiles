local vim = vim -- keeps the language server from freaking out

function GetState()
	local states = {
		selection = vim.o.selection,
		clipboard = vim.o.clipboard,
		registers = vim.fn.getreginfo('"'),
		left_vis_mark = vim.fn.getpos("'<"),
		right_vis_mark = vim.fn.getpos("'>"),
	}
	return states
end

function SetState(state)
	Set.selection = state.selection
	Set.clipboard = state.clipboard
	vim.fn.setreg('"', state.registers)
	vim.fn.setpos("'<", state.left_vis_mark)
	vim.fn.setpos("'>", state.right_vis_mark)
end

function Surround(movement)
	if not movement then Set.operatorfunc = 'v:lua.Surround'
    else
        print(movement)
        --local state = GetState() -- Preserve previous settings

        --local start = vim.api.nvim_buf_get_mark(0, '[') -- keeping so I don't have to look this up later
        --local stop = vim.api.nvim_buf_get_mark(0, ']')
        --vim.api.nvim_exec('norm `[v`]ygvc()' .. t'<esc>'.. 'P', false)

        --SetState(state) -- Return settings back to how they were
	end
end
