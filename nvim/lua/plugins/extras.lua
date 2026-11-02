-- Plugins e "extras" do LazyVim.
--
-- Tudo que estiver em lua/plugins/*.lua é carregado automaticamente pelo
-- lazy.nvim. Para adicionar um plugin novo, basta retornar a spec dele.
--
-- Extras prontos do LazyVim (linguagens, lint, debug, etc.):
--   https://www.lazyvim.org/extras
--
-- Exemplo: descomente as linhas abaixo conforme for usando.

return {
  -- { import = "lazyvim.plugins.extras.lang.python" },      -- Python (ruff, pyright)
  -- { import = "lazyvim.plugins.extras.lang.typescript" },  -- TypeScript/JS
  -- { import = "lazyvim.plugins.extras.lang.json" },        -- JSON
  -- { import = "lazyvim.plugins.extras.lang.markdown" },    -- Markdown
  -- { import = "lazyvim.plugins.extras.editor.mini-files" },-- explorador alternativo
  -- { import = "lazyvim.plugins.extras.dap.core" },         -- debugger

  -- Exemplo de plugin avulso (aqui, um tema extra):
  -- {
  --   "catppuccin/nvim",
  --   name = "catppuccin",
  --   priority = 1000,
  --   config = function()
  --     require("catppuccin").setup({ flavour = "mocha" })
  --     vim.cmd.colorscheme("catppuccin")
  --   end,
  -- },
}
