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

-- Save with ^s
nmap({ "<C-s>", fn = "save" })

-- Close buffers / quit with ^q
nmap({ "<C-q>", fn = "quit" })

-- Window movement
nmap({ "<Tab>", "<C-W><C-w>" })
nmap({ "<S-Tab>", "<C-W><S-W>" })

-- Buffer management
nmap({ "<C-]>", "<cmd>bnext<CR>" })
nmap({ "<C-[>", "<cmd>bprev<CR>" })

-- Do not move cursor when using *
nmap({
  "*",
  "<cmd>let s = winsaveview()<CR>*<cmd>:call winrestview(s)<CR>",
})

-- Quick system copy and paste
nmap({ "<Leader>y", '"+y', {} })
nmap({ "<Leader>Y", '"+Y', {} })
vmap({ "<Leader>y", '"+y', {} })

-- fzf
nmap({ "<Leader><Leader>", "<cmd>lua require('fzf-lua').git_files()<CR>" })
nmap({ "<Leader>p", "<cmd>lua require('fzf-lua').files()<CR>" })
nmap({ "<Leader>b", "<cmd>lua require('fzf-lua').buffers()<CR>" })
nmap({ "<Leader>f", "<cmd>lua require('fzf-lua').live_grep_native()<CR>" })

-- Toggle spelling
nmap({ "<Leader>s", "<cmd>set spell!<CR>" })

-- Git
nmap({ "gb", ":Git blame<cr>" })
nmap({ "gh", ":GBrowse<cr>" })
vmap({ "gh", ":'<'>GBrowse<cr>" })

-- Substitute
nmap({ "s", "<cmd>lua require('substitute').operator()<CR>" })
nmap({ "ss", "<cmd>lua require('substitute').line()<CR>" })
nmap({ "S", "<cmd>lua require('substitute').eol()<CR>" })

-- Yank filepath into system clipboard
nmap({
  "<Leader>yp",
  ":let @+ = expand('%:p')<CR>:echom 'Path copied to system clipboard'<CR>",
})

-- Clear search
nmap({ "<C-l>", ":nohlsearch<CR>:call clearmatches()<CR>" })

-- Repeat the last execuded macro
nmap({ ",", "@@" })

-- Functions defined in this may be used in any of the map functions by passing
-- the `lua` key and the name of any function
local fn = {}

function fn.save()
  local path = vim.fn.expand("%")
  local perms = vim.fn.getfperm(path)
  local writeable = vim.fn.filewritable(path)

  if writeable or path == "" or perms == "" then
    vim.cmd("write")
  else
    vim.cmd("write suda://%")
  end
end

function fn.quit()
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
end

M.fn = fn

return M
