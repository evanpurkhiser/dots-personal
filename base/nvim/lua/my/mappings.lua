local M = {}

local utils = require("my.utils")

local nmap = utils.map.nmap
local imap = utils.map.imap
local vmap = utils.map.vmap
local cmap = utils.map.cmap
local bmap = utils.map.bmap

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

-- Buffer management
--
-- XXX: Using `<Esc>` for the previous buffer (which in typical terminals is
-- outputted for ^[) since for whatever reason, sometimes vim doesn't
-- understand <C-[>`
nmap({ "<C-]>", "<cmd>bnext<CR>" })
nmap({ "<Esc>", "<cmd>bprev<CR>" })

-- Do not move cursor when using *
nmap({
  "*",
  "<cmd>let s = winsaveview()<CR>*<cmd>:call winrestview(s)<CR>",
})

-- Quick system copy and paste
nmap({ "<Leader>y", '"+y', {} })
nmap({ "<Leader>Y", '"+Y', {} })
vmap({ "<Leader>y", '"+y', {} })

-- Toggle spelling
nmap({ "<Leader>s", "<cmd>set spell!<CR>" })

-- Sort visual selection
vmap({ "<Leader>s", "<cmd>sort<CR>" })

-- Git
nmap({ "gb", ":Git blame<cr>" })

-- Git remote URLs
nmap({ "gh", require("my.configs.gitlinker").normal })
vmap({ "gh", require("my.configs.gitlinker").visual })

-- Yank filepath into system clipboard
nmap({
  "<Leader>yp",
  ":let @+ = expand('%:p')<CR>:echom 'Path copied to system clipboard'<CR>",
})

-- Clear search
nmap({ "<C-l>", ":nohlsearch<CR>:call clearmatches()<CR>" })

-- Repeat the last execuded macro
nmap({ ",", "@@" })

-- Visual star, search selected text
local function visual_star()
  local win = vim.fn.winsaveview()
  local sel = utils.get_visual_selection()

  sel = vim.fn.escape(sel, "/\\.*$^~[")
  sel = vim.fn.substitute(sel, "\n", "\\\\_s\\\\+", "g")

  vim.cmd("/" .. sel)
  vim.fn.winrestview(win)
end

vmap({ "*", visual_star })

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

nmap({ "<C-s>", save })

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

nmap({ "<C-q>", quit })

-- fzf
function M.fzf_mapping()
  local fzf = require("fzf-lua")

  fzf["grep_project_full"] = function()
    fzf.grep_project({
      fzf_opts = { ["--nth"] = "1.." },
    })
  end

  nmap({ "<Leader><Leader>", fzf.git_files })
  nmap({ "<Leader>p", fzf.files })
  nmap({ "<Leader>b", fzf.buffers })
  nmap({ "<Leader>f", fzf.grep_project_full })
  nmap({ "<Leader>r", fzf.command_history })
end

function M.substitue_mapping()
  -- Substitute
  local substitute = require("substitute")

  nmap({ "s", substitute.operator })
  nmap({ "ss", substitute.line })
  nmap({ "S", substitute.eol })
end

-- Upload image and insert markdown
function M.image_paste_mapping()
  imap({ "<C-v>", require("image-paste").paste_image })
end

function M.lsp_mapping(bufnr)
  local fzf = require("fzf-lua")
  local fzf_conf = require("my.configs.fzf")

  local function fzf_lsp(name, opts)
    local fn = fzf[string.format("lsp_%s", name)]
    return function()
      fn(opts or { winopts = fzf_conf.winopts_bottom, jump_to_single_result = true })
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
    fzf_lsp(
      "document_symbols",
      { winopts = fzf_conf.winopts_bottom, current_buffer_only = true }
    ),
    bufnr = bufnr,
  })

  nmap({
    "<space>",
    function()
      vim.lsp.buf.hover()
    end,
    bufnr = bufnr,
  })

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
