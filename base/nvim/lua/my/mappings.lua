local M = {}

local utils = require("my.utils")

local nmap = utils.map.nmap
local imap = utils.map.imap
local vmap = utils.map.vmap
local cmap = utils.map.cmap
local bmap = utils.map.bmap
local omap = utils.map.omap

-- Visual star, search selected text
local function visual_star()
  local win = vim.fn.winsaveview()
  local sel = utils.get_visual_selection()

  sel = vim.fn.escape(sel, "/\\.*$^~[")
  sel = vim.fn.substitute(sel, "\n", "\\\\_s\\\\+", "g")

  vim.cmd("/" .. sel)
  vim.fn.winrestview(win)
end

local function visual_lua_exec()
  loadstring(utils.get_visual_selection())()
end

---Extract text from the "c register, trim the leading whitespace, and place
---the text into the "+ system clipboard.
local function yank_clipboard_trimmed()
  -- Only trim and move yanked text from the "c register into the clipboard
  if vim.v.event.regname ~= "c" then
    return
  end

  local lines = vim.v.event.regcontents
  local trimmed = utils.trim_leading_whitespace(lines)
  vim.fn.setreg("+", trimmed)
end

local yank_diagnostic_ns = vim.api.nvim_create_namespace("hlyankdiag")

local function yank_diagnostic()
  local bufnr, lnum, col, _ = unpack(vim.fn.getpos("."))

  for _, diag in ipairs(vim.diagnostic.get(bufnr)) do
    -- XXX: Note that the lnum and col in the diagnostic result is 0
    -- indexed, so we need to account for that
    if diag.lnum == lnum - 1 and diag.col == col - 1 then
      vim.fn.setreg("+", diag.message)

      -- highlight the diagnostic area we just yanked
      vim.highlight.range(
        0,
        yank_diagnostic_ns,
        "Search",
        { diag.lnum, diag.col },
        { diag.end_lnum, diag.end_col }
      )

      vim.defer_fn(function()
        vim.api.nvim_buf_clear_namespace(0, yank_diagnostic_ns, 0, -1)
      end, 800)
      break
    end
  end
end

---Save the file. If the file is not writeable attempt to save using suda.
local function save()
  local path = vim.fn.expand("%")
  local writeable = vim.fn.filewritable(path) == 1
  local exists = vim.fn.empty(vim.fn.glob(path)) == 0

  if path == "" then
    print("Buffer does not have a filename")
    return false
  end

  if writeable or not exists then
    vim.cmd("write")
  else
    vim.cmd("write suda://%")
  end

  return true
end

local function quit()
  local buffer_has_changes = vim.fn.getbufinfo("%")[1].changed

  -- Confirm save if we need to save
  if buffer_has_changes == 1 then
    local confirm_success, should_save = pcall(function()
      return vim.fn.confirm("", "Save changes? &Yes\n&No") == 1
    end)

    if not confirm_success then
      return
    end

    -- Try to save. If we fail exit early and do not quit
    if should_save and not save() then
      return
    end
  end

  -- Check if we're closing a buffer or quitting vim
  local buffers = utils.get_buffer_list()

  if #buffers == 1 then
    vim.cmd("quit!")
  else
    require("bufdelete").bufdelete(0, true)
  end
end

function M.setup()
  -- Remap ^c to be the same as escape without telling us to use :q to quit. the
  -- 'r' command is special cased to a NOP.
  nmap({ "r<C-c>", "<NOP>" })
  nmap({ "<C-c>", "<NOP>" })
  nmap({ "<C-c>", "<C-[>" })
  imap({ "<C-c>", "<C-[>" })

  -- Disable EX mode
  bmap({ "Q", "<Nop>" })

  -- Navigate command mode with proper partial-completion matching (the native
  -- c-n c-p bindings don't do this for some reason)
  cmap({ "<C-p>", "<Up>" })
  cmap({ "<C-n>", "<Down>" })

  -- Window movement
  nmap({ "<Tab>", "<C-W><C-w>" })
  nmap({ "<S-Tab>", "<C-W><S-W>" })

  -- Do not move cursor when using *
  nmap({
    "*",
    "<cmd>let s = winsaveview()<CR>*<cmd>:call winrestview(s)<CR>",
  })

  -- Visual mode star
  vmap({ "*", visual_star })

  -- System copy paste. Uses the "c register. A TextYankPost autocmd will
  -- handle trimming the leading white space for improved pasting, since
  -- clipboard copy is almost always to share code somewhere.
  nmap({ "<Leader>y", '"cy', {} })
  nmap({ "<Leader>Y", '"cY', {} })
  vmap({ "<Leader>y", '"cy', {} })

  vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Trim leading whitesapce",
    group = vim.api.nvim_create_augroup("YankClipboard", {}),
    pattern = "*",
    callback = yank_clipboard_trimmed,
  })

  -- Yank filepath into system clipboard
  nmap({
    "<Leader>yp",
    function()
      vim.fn.setreg("+", vim.fn.expand("%:p"))
    end,
  })

  -- Yank current diagnostic error message
  nmap({
    "<Leader>ye",
    yank_diagnostic,
  })

  -- Toggle spelling
  nmap({ "<Leader>s", "<cmd>set spell!<CR>" })

  -- Sort visual selection
  vmap({ "<Leader>s", ":'<,'>sort<CR>" })

  -- Git blame
  nmap({ "gb", ":Git blame<cr>" })

  -- Clear search
  nmap({ "<C-l>", ":nohlsearch<CR>:call clearmatches()<CR>" })

  -- Repeat the last executed macro
  nmap({ ",", "@@" })

  -- Execute lua string in visual selection
  vmap({ "ge", visual_lua_exec })

  nmap({ "<C-s>", save })
  nmap({ "<C-q>", quit })
end

-- Buffer management
function M.bufferline_mappings(bufferline)
  local function cycle_left()
    bufferline.cycle(-1)
  end

  local function cycle_right()
    bufferline.cycle(1)
  end

  local function move_left()
    bufferline.move(-1)
  end

  local function move_Right()
    bufferline.move(-1)
  end

  -- XXX: Using `<Esc>` for the previous buffer (which in typical terminals is
  -- outputted for ^[) since for whatever reason, sometimes vim doesn't
  -- understand <C-[>`
  nmap({ "<C-[>", cycle_left })
  nmap({ "<C-]>", cycle_right })

  nmap({ "<S-C-[>", move_left })
  nmap({ "<S-C-]>", move_Right })
end

-- Git remote URLs
nmap({ "gh", ":GBrowse!<CR>" })
vmap({ "gh", ":GBrowse!<CR>" })

-- fzf
function M.fzf_mapping(fzf)
  local function visual_grep()
    local query = utils.get_visual_selection()
    fzf.grep({ search = query })
  end

  nmap({ "<Leader><Leader>", fzf.git_files })
  nmap({ "<Leader>w", fzf.specific_project_git_files })
  nmap({ "<Leader>s", fzf.git_status })
  nmap({ "<Leader>p", fzf.files })
  nmap({ "<Leader>b", fzf.buffers })
  nmap({ "<Leader>r", fzf.command_history })

  nmap({ "<Leader>f", fzf.grep })
  nmap({ "<Leader>F", fzf.specific_project_grep })
  vmap({ "<Leader>f", visual_grep })
end

function M.substitute_mapping(substitute)
  nmap({ "s", substitute.operator })
  nmap({ "ss", substitute.line })
  nmap({ "S", substitute.eol })
end

-- Upload image and insert markdown
function M.image_paste_mapping(imagePaste)
  imap({ "<C-v>", imagePaste.paste_image })
end

-- Git hunk navigiations
function M.gitsigns_mappings(gitsigns, bufnr)
  local function navigate_hunk(direction)
    return function()
      gitsigns.nav_hunk(direction)
    end
  end

  nmap({ "]h", navigate_hunk("next"), bufnr = bufnr })
  nmap({ "[h", navigate_hunk("prev"), bufnr = bufnr })

  vmap({ "ih", ":<C-U>Gitsigns select_hunk<CR>", bufnr = bufnr })
  omap({ "ih", ":<C-U>Gitsigns select_hunk<CR>", bufnr = bufnr })
end

function M.lsp_mapping(bufnr)
  local fzf = require("fzf-lua")

  local function fzf_lsp(name, opts)
    local fn = fzf[string.format("lsp_%s", name)]
    return function()
      fn(opts or { jump_to_single_result = true })
    end
  end

  -- fzf lsp triggers
  nmap({ "gD", fzf_lsp("declarations"), bufnr = bufnr })
  nmap({ "gd", fzf_lsp("definitions"), bufnr = bufnr })
  nmap({ "gr", fzf_lsp("references"), bufnr = bufnr })
  nmap({ "ga", fzf_lsp("code_actions"), bufnr = bufnr })
  nmap({ "gi", fzf_lsp("implementations"), bufnr = bufnr })

  nmap({ "<Leader>d", fzf_lsp("diagnostics_workspace"), bufnr = bufnr })

  nmap({
    "gs",
    fzf_lsp("document_symbols", { current_buffer_only = true }),
    bufnr = bufnr,
  })

  -- Renmae symbols
  nmap({ "gn", vim.lsp.buf.rename, bufnr = bufnr })

  -- Space to show hover details
  nmap({ "<space>", vim.lsp.buf.hover, bufnr = bufnr })

  nmap({
    "<C-p>",
    function()
      vim.diagnostic.goto_prev({ border = "rounded" })
    end,
    bufnr = bufnr,
  })

  nmap({
    "<C-n>",
    function()
      vim.diagnostic.goto_next({ border = "rounded" })
    end,
    bufnr = bufnr,
  })
end

return M
