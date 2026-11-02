-- Configuração do Neovim baseada no LazyVim.
--
-- Estrutura (mesma do starter oficial: https://github.com/LazyVim/starter):
--
--   init.lua                -> ponto de entrada, só carrega o resto
--   lua/config/lazy.lua     -> instala o lazy.nvim e carrega o LazyVim
--   lua/config/options.lua  -> opções do Neovim (vim.opt)
--   lua/config/keymaps.lua  -> atalhos
--   lua/config/autocmds.lua -> comandos automáticos (eventos)
--   lua/plugins/*.lua       -> seus plugins e "extras" do LazyVim
--
-- Documentação:
--   https://www.lazyvim.org/configuration
--   :Lazy  (painel de plugins, dentro do Neovim)

require("config.lazy")
