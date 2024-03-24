return {
  -- {
  --   "ray-x/lsp_signature.nvim",
  --   event = "BufRead",
  --   config = function()
  --     require("lsp_signature").setup()
  --   end,
  -- },
   {
      "catppuccin/nvim",
      name = "catppuccin",
      config = function()
        require("catppuccin").setup({
    flavour = "macchiato", -- latte, frappe, macchiato, mocha
    background = { -- :h background
        light = "latte",
        dark = "Macchiato",
    },
    transparent_background = true, -- disables setting the background color.
    show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
    term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
    dim_inactive = {
        enabled = false, -- dims the background color of inactive window
        shade = "dark",
        percentage = 0.15, -- percentage of the shade to apply to the inactive window
    },
    no_italic = false, -- Force no italic
    no_bold = false, -- Force no bold
    no_underline = false, -- Force no underline
    styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = { "italic" }, -- Change the style of comments
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
    },
    color_overrides = {},
    custom_highlights = {},
    integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = false,
        mini = {
            enabled = true,
            indentscope_color = "",
        },
    },
})

      end,
    },
   {
       "sainnhe/sonokai",
        init = function() 
         vim.g.sonokai_dim_inactive_windows = 1
        end,
   },
  { 
    "Mofiqul/dracula.nvim",
     name="dracula",
    config=function()
      require("dracula").setup({
  colors = {
    bg = "#282A36",
    fg = "#F8F8F2",
    selection = "#44475A",
    comment = "#6272A4",
    red = "#FF5555",
    orange = "#FFB86C",
    yellow = "#F1FA8C",
    green = "#50fa7b",
    purple = "#BD93F9",
    cyan = "#8BE9FD",
    pink = "#FF79C6",
    bright_red = "#FF6E6E",
    bright_green = "#69FF94",
    bright_yellow = "#FFFFA5",
    bright_blue = "#D6ACFF",
    bright_magenta = "#FF92DF",
    bright_cyan = "#A4FFFF",
    bright_white = "#FFFFFF",
    menu = "#21222C",
    visual = "#3E4452",
    gutter_fg = "#4B5263",
    nontext = "#3B4048",
    white = "#ABB2BF",
    black = "#191A21",
  },
  show_end_of_buffer = true, -- default false
  transparent_bg = true, -- default false
  lualine_bg_color = "#44475a", -- default nil
  italic_comment = true, -- default false
  overrides = {},
      })
    end,
  },

  -- Configure LazyVim to load dracula
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "dracula",
    },
  },
  { import = "astrocommunity.pack.typescript" },
  {
    "sigmasd/deno-nvim",
    -- HACK: This disables tsserver if denols is attached.
    -- A solution that only enables the required lsp should replace it.
    opts = function(_, opts)
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local curr_client = vim.lsp.get_client_by_id(args.data.client_id)
          -- if deno attached, stop all typescript servers
          if curr_client.name == "denols" then
            vim.lsp.for_each_buffer_client(bufnr, function(client, client_id)
              if client.name == "tsserver" then vim.lsp.stop_client(client_id, true) end
            end)
            -- if tsserver attached, stop it if there is a denols server attached
            elseif curr_client.name == "tsserver" then
            for _, client in ipairs(vim.lsp.get_active_clients { bufnr = bufnr }) do
              if client.name == "denols" then
                vim.lsp.stop_client(curr_client.id, true)
                break
              end
            end
          end
        end,
      })
      opts.server = require("astronvim.utils.lsp").config "denols"
      opts.server.root_dir = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function () 
      local configs = require("nvim-treesitter.configs")

      configs.setup({
          ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html" },
          sync_install = false,
          highlight = { enable = true },
          indent = { enable = true },
          autotag = { 
            enable = true,
            enable_rename = true,
            enable_close = true,
            enable_close_on_slash = true,
          },
        })
    end
  },
  {
    'davidhalter/jedi-vim',
    name="jedi-vim",
    config=function()
      require("jedi-vim").setup({})
    end,
  },
}
