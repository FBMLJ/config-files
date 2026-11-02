-- Bootstrap do gerenciador de plugins (lazy.nvim) + LazyVim.
--
-- Na primeira execução do Neovim este arquivo:
--   1. clona o lazy.nvim em ~/.local/share/nvim/lazy/lazy.nvim
--   2. registra o LazyVim e seus plugins
--   3. instala tudo o que estiver declarado em lua/plugins/
--
-- Os plugins ficam em ~/.local/share/nvim (fora do git). Apenas o
-- lazy-lock.json (versões travadas) vive na config, então vale commitar.

-- Clona o lazy.nvim se ainda não existir.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Falha ao clonar o lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPressione qualquer tecla para sair...", "WarningMsg" },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- O líder precisa ser definido ANTES de carregar o lazy.nvim, senão os
-- atalhos padrão do LazyVim (que usam <leader>) são registrados errados.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
  spec = {
    -- Carrega o LazyVim e todos os plugins padrão dele.
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- Seus plugins/extras (tudo em lua/plugins/).
    { import = "plugins" },
  },
  defaults = {
    -- Só os plugins do LazyVim são carregados sob demanda; os seus carregam
    -- no início (mais simples de entender).
    lazy = false,
    -- `false` = sempre a última versão do git. É o recomendado pela doc.
    version = false,
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  -- Avisa quando houver atualização de plugin.
  checker = { enabled = true },
  performance = {
    rtp = {
      -- Plugins embutidos do Neovim que não usamos.
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
