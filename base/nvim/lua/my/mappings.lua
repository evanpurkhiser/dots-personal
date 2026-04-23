local M = {}

local utils = require("my.utils")

local map = vim.keymap.set

---Visual star, search selected text
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
      vim.hl.range(
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
  map("n", "r<C-c>", "<NOP>")
  map("n", "<C-c>", "<NOP>")
  map("n", "<C-c>", "<C-[>")
  map("i", "<C-c>", "<C-[>")

  -- Disable EX mode
  map({ "n", "v", "o" }, "Q", "<Nop>")

  -- Navigate command mode with proper partial-completion matching (the native
  -- c-n c-p bindings don't do this for some reason)
  map("c", "<C-p>", "<Up>")
  map("c", "<C-n>", "<Down>")

  -- Window movement
  map("n", "<Tab>", "<C-W><C-w>")
  map("n", "<S-Tab>", "<C-W><S-W>")

  -- Do not move cursor when using *
  map("n", "*", "<cmd>let s = winsaveview()<CR>*<cmd>:call winrestview(s)<CR>")

  -- Visual mode star
  map("v", "*", visual_star)

  -- System copy paste. Uses the "c register. A TextYankPost autocmd will
  -- handle trimming the leading white space for improved pasting, since
  -- clipboard copy is almost always to share code somewhere.
  map("n", "<Leader>y", '"cy', { remap = true })
  map("n", "<Leader>Y", '"cY', { remap = true })
  map("v", "<Leader>y", '"cy', { remap = true })

  vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Trim leading whitesapce",
    group = vim.api.nvim_create_augroup("YankClipboard", {}),
    pattern = "*",
    callback = yank_clipboard_trimmed,
  })

  -- Yank filepath into system clipboard
  map("n", "<Leader>yp", function()
    vim.fn.setreg("+", vim.fn.expand("%:p"))
  end)

  -- Yank current diagnostic error message
  map("n", "<Leader>ye", yank_diagnostic)

  -- Open directory of current file for editing
  map("n", "<Leader>o", ":edit %:p:h<CR>")

  -- Toggle spelling
  map("n", "<Leader>s", "<cmd>set spell!<CR>")

  -- Sort visual selection
  map("v", "<Leader>s", ":'<,'>sort<CR>")

  -- Git blame
  map("n", "gb", ":Git blame<cr>")

  -- Clear search
  map("n", "<C-l>", ":nohlsearch<CR>:call clearmatches()<CR>")

  -- Repeat the last executed macro
  map("n", ",", "@@")

  -- Execute lua string in visual selection
  map("v", "ge", visual_lua_exec)

  map("n", "<C-s>", save)
  map("n", "<C-q>", quit)

  -- Incremental treesitter node selection
  map({ "n", "x", "o" }, "<CR>", function()
    if vim.treesitter.get_parser(nil, nil, { error = false }) then
      require("vim.treesitter._select").select_parent(vim.v.count1)
    end
  end, { desc = "Expand treesitter selection" })

  map({ "n", "x", "o" }, "<S-CR>", function()
    if vim.treesitter.get_parser(nil, nil, { error = false }) then
      require("vim.treesitter._select").select_child(vim.v.count1)
    end
  end, { desc = "Shrink treesitter selection" })
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

  local function move_right()
    bufferline.move(1)
  end

  -- XXX: Using `<Esc>` for the previous buffer (which in typical terminals is
  -- outputted for ^[) since for whatever reason, sometimes vim doesn't
  -- understand <C-[>`
  map("n", "<C-[>", cycle_left)
  map("n", "<C-]>", cycle_right)

  map("n", "<S-C-[>", move_left)
  map("n", "<S-C-]>", move_right)
end

-- Git remote URLs
map("n", "gh", ":GBrowse!<CR>")
map("v", "gh", ":GBrowse!<CR>")

-- fzf
function M.fzf_mapping(fzf)
  local function visual_grep()
    local query = utils.get_visual_selection()
    fzf.grep({ search = query })
  end

  map("n", "<Leader><Leader>", fzf.git_files)
  map("n", "<Leader>w", fzf.specific_project_git_files)
  map("n", "<Leader>s", fzf.git_status)
  map("n", "<Leader>p", fzf.files)
  map("n", "<Leader>b", fzf.buffers)
  map("n", "<Leader>r", fzf.command_history)

  map("n", "<Leader>f", fzf.grep)
  map("n", "<Leader>F", fzf.specific_project_grep)
  map("v", "<Leader>f", visual_grep)
end

function M.substitute_mapping(substitute)
  map("n", "s", substitute.operator)
  map("n", "ss", substitute.line)
  map("n", "S", substitute.eol)
end

-- Upload image and insert markdown
function M.image_paste_mapping(imagePaste)
  map("i", "<C-v>", imagePaste.paste_image)
end

-- Git hunk navigiations
function M.gitsigns_mappings(gitsigns, bufnr)
  local b = { buffer = bufnr }

  map("n", "]h", function() gitsigns.nav_hunk("next") end, b)
  map("n", "[h", function() gitsigns.nav_hunk("prev") end, b)

  map("n", "<Leader>hr", gitsigns.reset_hunk, b)
  map("n", "<Leader>hs", gitsigns.stage_hunk, b)
  map("v", "<Leader>hs", function()
    gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
  end, b)

  map("v", "ih", ":<C-U>Gitsigns select_hunk<CR>", b)
  map("o", "ih", ":<C-U>Gitsigns select_hunk<CR>", b)
end

function M.lsp_mapping(bufnr)
  local fzf = require("fzf-lua")
  local border = require("my.styles").border
  local b = { buffer = bufnr }

  local function fzf_lsp(name, opts)
    local fn = fzf[string.format("lsp_%s", name)]
    return function()
      fn(opts)
    end
  end

  -- fzf lsp triggers
  map("n", "gD", fzf_lsp("declarations"), b)
  map("n", "gd", fzf_lsp("definitions"), b)
  map("n", "gr", fzf_lsp("references"), b)
  map("n", "ga", fzf_lsp("code_actions"), b)
  map("n", "gi", fzf_lsp("implementations"), b)

  map("n", "<Leader>d", fzf_lsp("workspace_diagnostics"), b)

  map("n", "gs", fzf_lsp("document_symbols", { current_buffer_only = true }), b)

  -- Renmae symbols
  map("n", "gn", vim.lsp.buf.rename, b)

  -- Space to show hover details
  map("n", "<space>", function()
    vim.lsp.buf.hover({ border = border })
  end, b)

  map("n", "<C-p>", function()
    vim.diagnostic.jump({ count = -1, float = true })
  end, b)

  map("n", "<C-n>", function()
    vim.diagnostic.jump({ count = 1, float = true })
  end, b)
end

return M
