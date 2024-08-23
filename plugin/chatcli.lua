local M = {}

-- Helper function to get text from marks
local function get_text_between_marks(start_mark, end_mark)
    local start_line, start_col = unpack(vim.api.nvim_buf_get_mark(0, start_mark))
    local end_line, end_col = unpack(vim.api.nvim_buf_get_mark(0, end_mark))

    -- Adjust for Lua's 1-based indexing
    start_line = start_line - 1
    end_line = end_line - 1

    -- Get lines
    local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line + 1, false)

    -- Adjust first and last line
    if #lines == 1 then
        lines[1] = string.sub(lines[1], start_col + 1, end_col)
    else
        lines[1] = string.sub(lines[1], start_col + 1)
        lines[#lines] = string.sub(lines[#lines], 1, end_col + 1)
    end

    return table.concat(lines, "\n")
end

function M.send_to_chatcli()
    local text = get_text_between_marks('<', '>')

    -- Use io.popen to create a pipe to chatcli
    local handle = io.popen("chatcli add --continue --role user", "w")
    if handle then
        handle:write(text)
        handle:close()
        print("Text sent to chatcli")
    else
        print("Failed to open pipe to chatcli")
    end
end

function M.read_chatcli_result()
  -- Read the result from chatcli
  local handle = io.popen("chatcli show", "r")
  if not handle then
    print("Failed to open pipe to chatcli")
    return
  end

  local result = handle:read("*a")
  handle:close()

  -- Extract code blocks
  local code_blocks = {}
  for block in result:gmatch("```[%w%s]*\n(.-)\n```") do
    table.insert(code_blocks, block)
  end

  if #code_blocks == 0 then
    print("No code blocks found in chatcli result")
    return
  end

  -- Insert code blocks at cursor position
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local row = cursor_pos[1]

  for _, block in ipairs(code_blocks) do
    local lines = vim.split(block, "\n")
    vim.api.nvim_buf_set_lines(0, row, row, false, lines)
    row = row + #lines
  end

  print("Inserted " .. #code_blocks .. " code block(s) from chatcli result")
end

-- Create the commands
vim.api.nvim_create_user_command("ChatCLIRead", M.read_chatcli_result, {})
vim.api.nvim_create_user_command("ChatCLISend", M.send_to_chatcli, {range = true})

-- Create the keybindings
vim.api.nvim_set_keymap('n', '<leader>cr', ':ChatCLIRead<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>cs', ':ChatCLISend<CR>', {noremap = true, expr = true})

function M.open_chatcli_result()
  -- Read the result from chatcli
  local handle = io.popen("chatcli show", "r")
  if not handle then
    print("Failed to open pipe to chatcli")
    return
  end

  local result = handle:read("*a")
  handle:close()

  -- Create a new split
  vim.cmd('split')

  -- Create a new buffer
  local buf = vim.api.nvim_create_buf(false, true)

  -- Set the buffer in the new split
  vim.api.nvim_win_set_buf(0, buf)

  -- Set buffer options
  vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_option(buf, 'swapfile', false)

  -- Set the content of the buffer
  local lines = vim.split(result, "\n")
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- Set the filetype to markdown for syntax highlighting
  vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')

  print("Opened chatcli result in a new split")
end

vim.api.nvim_create_user_command("ChatCLIShow", M.open_chatcli_result, {})
vim.api.nvim_set_keymap('n', '<leader>co', ':ChatCLIShow<CR>', {noremap = true, silent = true})

return M
