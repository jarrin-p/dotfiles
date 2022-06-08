-- vim-plug initialization
local Plug = vim.fn['plug#']
if vim.fn.has('unix') == 1 then vim.call('plug#begin', '~/.config/nvim/autoload/plugged')
elseif vim.fn.has('mac') == 1 then vim.call('plug#begin', '~/.config/nvim/autoload/plugged')
end

-- import plugins
Plug 'psliwka/vim-smoothie'
Plug 'petertriho/nvim-scrollbar'
Plug 'tpope/vim-fugitive'
Exec "Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }"
Exec "Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}"
Plug 'williamboman/nvim-lsp-installer'

Plug 'hrsh7th/nvim-cmp' -- Autocompletion plugin
Plug 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
Plug 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
Plug 'L3MON4D3/LuaSnip' -- Snippets plugin

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim' -- depends on `plenary.vim`
Plug 'preservim/nerdtree'
Plug 'tpope/vim-surround'

-- end of plugin defining
vim.call('plug#end')

-- setup plugins
require('scrollbar').setup()
require 'nvim-treesitter.configs'.setup {
    ensure_installed = 'all',             -- 'all', 'maintained', or a table of languages
    sync_install = true,                  -- install languages synchronously (only applied to `ensure_installed`)
    -- ignore_install = { 'javascript' }, -- list of parsers to ignore installing
    highlight = {
        enable = true,                    -- `false` will disable the whole extension
        --disable = { 'c', 'rust' },      -- list of languages that will be disabled
        additional_vim_regex_highlighting = true,
    },
}
require('nvim-lsp-installer').setup{ automatic_installation = true }
-- lsp server setups. defaults are fine for most.
local servers = {
    'pyright',
    'jdtls',
    'sumneko_lua',
    'terraformls',
    'bashls'
}
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
local r = require('lspconfig')
for _, s in pairs(servers) do
    if s == 'sumneko_lua' then
        r[s].setup {
            capabilities = capabilities,
            settings = { Lua = { version = 'LuaJIT', diagnostics = { globals = { 'vim' } } } }
        }
    elseif s == 'bashls' then
        r[s].setup {
            capabilities = capabilities,
            filetypes = { "sh", "bash", "zsh" }
        }
    else
        r[s].setup {
            capabilities = capabilities,
        }
    end
end

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

-- some additional plugin settings that need to be set through globals.
GSet.NERDTreeWinSize = 50
GSet.NERDTreeShowBookmarks = 1
