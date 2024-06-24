local P = {
  "hrsh7th/nvim-cmp",
}

P.dependencies = {
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "onsails/lspkind.nvim" },
  { "L3MON4D3/luasnip" },
  { "saadparwaiz1/cmp_luasnip", name = "cmp-luasnip" },
}

function P.config()
  local cmp = require("cmp")
  local luasnip = require("luasnip")
  local lspkind = require("lspkind")

  local check_backspace = function()
    local col = vim.fn.col(".") - 1
    return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
  end

  cmp.setup({
    formatting = {
      fields = { "kind", "abbr", "menu" },
      format = lspkind.cmp_format({ mode = "symbol_text", maxwidth = 50 }),
    },
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    duplicates = {
      nvim_lsp = 1,
      luasnip = 1,
      cmp_tabnine = 1,
      buffer = 1,
      path = 1,
    },
    confirm_opts = {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },
    experimental = {
      ghost_text = true,
      native_menu = false,
    },
    completion = {
      keyword_length = 1,
    },
    sources = {
      { name = "nvim_lsp" },
      { name = "copilot" },
      { name = "luasnip" },
      {
        name = "buffer",
        option = {
          -- Complete across visible buffers
          get_bufnrs = function()
            local bufs = {}
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              bufs[vim.api.nvim_win_get_buf(win)] = true
            end
            return vim.tbl_keys(bufs)
          end,
        },
      },
    },
    mapping = {
      ["<C-k>"] = cmp.mapping.select_prev_item(),
      ["<C-j>"] = cmp.mapping.select_next_item(),
      ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
      ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
      ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
      ["<C-y>"] = cmp.config.disable,
      ["<C-e>"] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expandable() then
          luasnip.expand()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif check_backspace() then
          fallback()
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
    },
  })

  local kindColors = {
    Text = { link = "Normal" },
    File = { link = "Normal" },
    Method = { link = "Function" },
    Function = { link = "Function" },
    Folder = { link = "Function" },
    Constructor = { link = "Keyword" },
    Class = { link = "Keyword" },
    Module = { link = "Keyword" },
    Keyword = { link = "Keyword" },
    Interface = { link = "Type" },
    Struct = { link = "Type" },
    Unit = { link = "String" },
    Value = { link = "String" },
    Enum = { link = "String" },
    EnumMember = { link = "String" },
    Constant = { link = "Constant" },
    Snippet = { link = "DiagnosticOk" },
    Field = { link = "Identifier" },
    Property = { link = "Identifier" },
    Variable = { link = "Identifier" },
    Color = { link = "Type" },
    Event = { link = "Type" },
    Operator = { link = "Keyword" },
  }

  -- Setup kind colors
  for key, color in pairs(kindColors) do
    vim.api.nvim_set_hl(0, "CmpItemKind" .. key, color)
  end
end

return P
