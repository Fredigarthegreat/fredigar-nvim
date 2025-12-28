local debug_enable = false

pdebug = function(...)
  if debug_enable then
    print(...)
  end
end

local state = {
  col_length = {
    3,  -- id
    10, -- date 
    17, -- description_memo 
    22, -- account 
    10, -- debit 
    10, -- credit 
  },
  header_win = nil
}

-- if a namespace already exists then it will not be created again. It will only return the id
local ns_ids = {
  header_id = vim.api.nvim_create_namespace('header'),
  body_id = vim.api.nvim_create_namespace('body'),
}
vim.api.nvim_create_augroup('journal', {clear = true})


function init(ev)
  pdebug('init')
  vim.api.nvim_create_namespace('header')
  state.col_length = get_max_col_lengths()
end

function enter(ev)
  local topline = vim.fn.line('w0')
  -- clear all lines
  vim.api.nvim_buf_clear_namespace(0, -1, 0, -1);
  format_lines(topline)
  print_header(topline)
end

function exit(ev)
  assert(state.header_win ~= nil, 'header win_id was nil upon exit')
  vim.api.nvim_win_close(state.header_win, true)
end

function get_max_col_lengths()
  local max_col_lengths = {}
  for i = 1, vim.api.nvim_buf_line_count(0) - 1 do
    local line = vim.api.nvim_buf_get_lines(0, i, i + 1, 1)
    local char_count = 0
    local col_count = 1
    for j = 1, #line[1] do
      if string.sub(line[1], j, j) == ',' then
        if max_col_lengths[col_count] == nil then
          pdebug('col_length was nil')
          max_col_lengths[col_count] = char_count
        elseif max_col_lengths[col_count] < char_count then
          max_col_lengths[col_count] = char_count
        end
        char_count = 0
        col_count = col_count + 1
  pdebug(vim.inspect(max_col_lengths))
      else
        char_count = char_count + 1
        if col_count == 5 then
          break
        end
      end
      pdebug(
        line[1] .. ' ' .. #line[1] .. '\n' 
        .. 'j: ' .. j ..  ' col_count: ' .. col_count .. ' char_count: ' .. char_count .. '\n'
        .. vim.inspect(max_col_lengths)
      )
    end
  end
  max_col_lengths[5] = 10
  max_col_lengths[6] = 10
  return max_col_lengths
end

function insert_separator_line(row)
  local separator_line = ''

  for i = 1, #state.col_length do
    separator_line = separator_line  .. string.rep('─', state.col_length[i]) .. '┼'
  end

  vim.api.nvim_buf_set_extmark(0, ns_ids.header_id, row - 1, 0, {
    virt_lines = {
      {{separator_line, 'Errormsg'}},
    },
    virt_lines_above = true,
  })
end

function print_header(topline)
  local col_ids1 = {
    ' ID',
    'Date',
    'Description',
    '',
    '',
    '',
  }

  local col_ids2 = {
    '',
    '',
    'Memo',
    'Account',
    '     Debit',
    '    Credit',
  }
  
  assert(#col_ids1 == #col_ids2)
  
  local ids1 = ''
  local ids2 = ''
  local underline = ''

  for i = 1, #col_ids1 do
    ids1 = ids1 .. col_ids1[i] .. string.rep(' ', state.col_length[i] - #col_ids1[i]) .. '│'
    ids2 = ids2 .. col_ids2[i] .. string.rep(' ', state.col_length[i] - #col_ids2[i]) .. '│'
    underline = underline .. string.rep('─', state.col_length[i]) .. '┼'
  end

  local header_buf = vim.api.nvim_create_buf(false, true)
  
  vim.api.nvim_buf_set_lines(header_buf, 0, 0, true, {ids1, ids2, underline})

  state.header_win = vim.api.nvim_open_win(header_buf, false, {
    relative = 'win',
    width = vim.api.nvim_win_get_width(0),
    height = 3,
    row = 0,
    col = 0,
    focusable = false,
    style = 'minimal',
  })
end

function format_lines(topline)
  for i = topline + 1, vim.api.nvim_win_get_height(0) + topline - 1 do
    local line = vim.api.nvim_buf_get_lines(0, i - 1, i, 1)
    if string.sub(line[1], 1, 1) ~= ',' and i ~= 4 then
      insert_separator_line(i)
    end
    -- for each character
    local char_count = 0;
    col_count = 1;
    for j = 1, #line[1] do
      -- count how many characters it takes to get to a comma
      if string.sub(line[1], j, j) == ',' then
        col_difference = state.col_length[col_count] - char_count
        vim.api.nvim_buf_set_extmark(0, ns_ids.body_id, i - 1, j - 1, {
          virt_text = {{string.rep(' ', col_difference), 'Normal'}},
          virt_text_pos = 'inline',
        })
        -- reset char_count
        char_count = 0
        col_count = col_count + 1
        vim.api.nvim_buf_set_extmark(0, ns_ids.body_id, i - 1, j - 1, {
          virt_text = {{'│', 'Normal'}},
          virt_text_pos = 'overlay',
        })
      else
        char_count = char_count + 1
      end
      pdebug(
        line[1] .. ' ' .. #line[1] .. '\n' 
        .. 'j: ' .. j ..  ' col_count: ' .. col_count .. ' char_count: ' .. char_count .. '\n'
      )
    end
    -- add in spaces for alignment

  end
end

  vim.api.nvim_create_autocmd({'BufAdd', }, {
    group = 'journal',
    pattern = '*.jrnl',
    callback = init
  })

  vim.api.nvim_create_autocmd({'BufEnter', 'CursorMoved', 'WinScrolled'}, {
    group = 'journal',
    pattern = '*.jrnl',
    callback = enter
  })

  vim.api.nvim_create_autocmd({'BufLeave'}, {
    group = 'journal',
    pattern = '*.jrnl',
    callback = exit
  })
