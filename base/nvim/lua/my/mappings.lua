local M = {}

local utils = require("my.utils")

local nmap = utils.map.nmap
local imap = utils.map.imap
local vmap = utils.map.vmap
local cmap = utils.map.cmap
local bmap = utils.map.bmap

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

  -- Quick system copy and paste
  nmap({ "<Leader>y", '"+y', {} })
  nmap({ "<Leader>Y", '"+Y', {} })
  vmap({ "<Leader>y", '"+y', {} })

  -- Yank filepath into system clipboard
  nmap({
    "<Leader>yp",
    ":let @+ = expand('%:p')<CR>:echom 'Path copied to system clipboard'<CR>",
  })

  -- Toggle spelling
  nmap({ "<Leader>s", "<cmd>set spell!<CR>" })

  -- Sort visual selection
  vmap({ "<Leader>s", "<cmd>sort<CR>" })

  -- Git blame
  nmap({ "gb", ":Git blame<cr>" })

  -- Clear search
  nmap({ "<C-l>", ":nohlsearch<CR>:call clearmatches()<CR>" })

  -- Repeat the last execuded macro
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
function M.gitlinker_mappings(gitlinker)
  local function normal()
    gitlinker.get_buf_range_url("n")
  end

  local function visual()
    gitlinker.get_buf_range_url("v")
  end

  nmap({ "gh", normal })
  vmap({ "gh", visual })
end

-- fzf
function M.fzf_mapping(fzf)
  local function visual_grep()
    local query = utils.get_visual_selection()
    fzf.grep_project({ query = query })
  end

  nmap({ "<Leader><Leader>", fzf.git_files })
  nmap({ "<Leader>p", fzf.files })
  nmap({ "<Leader>b", fzf.buffers })
  nmap({ "<Leader>r", fzf.command_history })

  nmap({ "<Leader>f", fzf.grep_project })
  vmap({ "<Leader>f", visual_grep })
end

function M.substitue_mapping(substitute)
  nmap({ "s", substitute.operator })
  nmap({ "ss", substitute.line })
  nmap({ "S", substitute.eol })
end

-- Upload image and insert markdown
function M.image_paste_mapping(imagePaste)
  imap({ "<C-v>", imagePaste.paste_image })
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
