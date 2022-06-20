--- vim-plug initialization {{{
local Plug = vim.fn['plug#']
if vim.fn.has('unix') == 1 then vim.call('plug#begin', '~/.config/nvim/autoload/plugged')
elseif vim.fn.has('mac') == 1 then vim.call('plug#begin', '~/.config/nvim/autoload/plugged')
end

-- import plugins
-- Plug 'psliwka/vim-smoothie' -- messes up with folds.
Plug 'petertriho/nvim-scrollbar'
Plug 'tpope/vim-fugitive'
Exec "Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }"
Exec "Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}"
Plug 'williamboman/nvim-lsp-installer'

Plug 'hrsh7th/nvim-cmp' -- autocompletion plugin
Plug 'hrsh7th/cmp-nvim-lsp' -- lsp source for nvim-cmp
Plug 'saadparwaiz1/cmp_luasnip' -- snippets source for nvim-cmp
Plug 'L3MOn4d3/LuaSnip' -- snippets plugin

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim' -- depends on `plenary.vim`
Plug 'preservim/nerdtree'
Plug 'tpope/vim-surround'

-- end of plugin defining
vim.call('plug#end')
-- end vim-plug setup }}}

--- simple nvim specific setups {{{
require('scrollbar').setup()
-- end simple setups }}}

--- treesitter setup {{{
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
-- end treesitter setup }}}

--- nerd tree {{{
GSet.NERDTreeWinSize = 50
GSet.NERDTreeShowBookmarks = 1

--- opens new kitty tab at specified path or `current` directory.
-- @tparam path (string) path to the location of the new tab.
function NewKittyTab(path)
    vim.fn.system('kitty @ launch --cwd=' .. (path or 'current') .. ' --type=tab')
end

--- opens kitty tab at directory of current node.
-- setting it globally to vim allows it to be used as a callback.
-- (it's registered as a global vim function this way)
GSet.NERDTreeOpenKittyTabHere = function()
    local node_path_table = vim.api.nvim_eval('g:NERDTreeFileNode.GetSelected()').path
    local file_name

    -- pop last entry in path segments if it's not a directory. stores file_name.
    if node_path_table.isDirectory == 0 then
        file_name = table.remove(node_path_table.pathSegments)
    end

    local path_str = table.concat(node_path_table.pathSegments, '/')
    NewKittyTab('/' .. path_str) -- need to enforce absolute path.
end

--- create the menu items after everything has been loaded using an autocmd.{{{
vim.api.nvim_create_autocmd(
    {'VimEnter'},
    { callback =
        function()
            vim.fn.NERDTreeAddMenuItem{
                text = 'New kitty (t)erminal tab from this directory.',
                shortcut = 't',
                callback = 'g:NERDTreeOpenKittyTabHere',
            }
        end,
    }
) -- end of autocmd }}}

-- end nerdtree config }}}

--- server configs {{{
require('nvim-lsp-installer').setup{}
local servers = {
    'pyright',
    'jdtls',
    'sumneko_lua',
    'terraformls',
    'bashls',
    'remark_ls',
    'rnix',
    'vimls',
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
    elseif s == 'jdtls' then
        r[s].setup {
            capabilities = capabilities,
            cmd_env = { JAVA_HOME = (vim.env.HOME .. "/.jabba/jdk/openjdk@1.17.0/Contents/Home") },
            use_lombok_agent = true
        }
    else
        r[s].setup {
            capabilities = capabilities,
        }
    end
end
-- end server configs }}}

--- auto complete settings. works with nvim-lsp {{{
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
-- end autocomplete config }}}

-- vim: fdm=marker foldlevel=0
