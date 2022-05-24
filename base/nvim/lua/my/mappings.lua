local M = {}

local map = require("my.utils").map

local nmap = map.nmap
local imap = map.imap
local vmap = map.vmap
local cmap = map.cmap
local bmap = map.bmap

-- Remap ^c to be the same as escape without telling us to use :q to quit. the
-- 'r' command is special cased to a NOP.
nmap({ "r<C-c>", "<NOP>" })
nmap({ "<C-c>", "<NOP>" })
nmap({ "<C-c>", "<Esc>" })
imap({ "<C-c>", "<Esc>" })

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

-- Save with ^s
nmap({
  "<C-s>",
  function()
    local path = vim.fn.expand("%")
    local perms = vim.fn.getfperm(path)
    local writeable = vim.fn.filewritable(path)

    if writeable or path == "" or perms == "" then
      vim.cmd("write")
    else
      vim.cmd("write suda://%")
    end
  end,
})

-- Close buffers / quit with ^q
nmap({
  "<C-q>",
  function()
    local buffers = {}

    -- Get all buffers
    for buffer = 1, vim.fn.bufnr("$") do
      local is_listed = vim.fn.buflisted(buffer) == 1
      if is_listed then
        table.insert(buffers, buffer)
      end
    end

    -- Quit if there is only an empty buffer
    if #buffers == 1 then
      vim.cmd("confirm quit")
    else
      vim.cmd("confirm Bdelete")
    end
  end,
})

-- Quick system copy and paste
nmap({ "<Leader>y", '"+y', {} })
nmap({ "<Leader>Y", '"+Y', {} })
vmap({ "<Leader>y", '"+y', {} })

-- fzf
local fzf = require("fzf-lua")

nmap({ "<Leader><Leader>", fzf.git_files })
nmap({ "<Leader>p", fzf.files })
nmap({ "<Leader>b", fzf.buffers })
nmap({ "<Leader>f", fzf.grep_project })
nmap({ "<Leader>r", fzf.command_history })

-- Toggle spelling
nmap({ "<Leader>s", "<cmd>set spell!<CR>" })

-- Git
nmap({ "gb", ":Git blame<cr>" })
nmap({ "gh", ":GBrowse<cr>" })
vmap({ "gh", ":'<'>GBrowse<cr>" })

-- Substitute
local substitute = require("substitute")

nmap({ "s", substitute.operator })
nmap({ "ss", substitute.line })
nmap({ "S", substitute.eol })

-- Yank filepath into system clipboard
nmap({
  "<Leader>yp",
  ":let @+ = expand('%:p')<CR>:echom 'Path copied to system clipboard'<CR>",
})

-- Clear search
nmap({ "<C-l>", ":nohlsearch<CR>:call clearmatches()<CR>" })

-- Repeat the last execuded macro
nmap({ ",", "@@" })

function M.lsp_mapping(bufnr)
  local fzf_conf = require("my.configs.fzf")

  local function fzf_lsp(name, opts)
    local fn = fzf[string.format("lsp_%s", name)]
    return function()
      fn(opts or { winopts = fzf_conf.winopts_bottom, jump_to_single_result = true })
    end
  end

  -- fzf lsp triggers
  map.nmap({ "gD", bufnr = bufnr, fn = fzf_lsp("declarations") })
  map.nmap({ "gd", bufnr = bufnr, fn = fzf_lsp("definitions") })
  map.nmap({ "gr", bufnr = bufnr, fn = fzf_lsp("references") })
  map.nmap({ "ga", bufnr = bufnr, fn = fzf_lsp("code_actions") })
  map.nmap({ "gi", bufnr = bufnr, fn = fzf_lsp("implementations") })

  map.nmap({
    "gs",
    fzf_lsp(
      "document_symbols",
      { winopts = fzf_conf.winopts_bottom, current_buffer_only = true }
    ),
    bufnr = bufnr,
  })

  map.nmap({
    "<space>",
    function()
      vim.lsp.buf.hover()
    end,
    bufnr = bufnr,
  })

  map.nmap({
    "<C-p>",
    function()
      vim.diagnostic.goto_prev({ border = "rounded" })
    end,
    bufnr = bufnr,
  })

  map.nmap({
    "<C-n>",
    function()
      vim.diagnostic.goto_next({ border = "rounded" })
    end,
    bufnr = bufnr,
  })
end

return M
