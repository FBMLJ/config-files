-- Comandos automáticos, disparados por eventos (`:h autocmd`).
--
-- Formato: vim.api.nvim_create_autocmd(<evento>, { pattern, callback, desc })
-- O `augroup` serve para não duplicar os autocmds quando a config recarrega.

local augroup = vim.api.nvim_create_augroup("user_config", { clear = true })

-- Pisca o cursor ao copiar/colar: feedback visual de que o texto foi copiado.
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  desc = "Destacar texto copiado",
  callback = function()
    vim.hl.on_yank({ timeout = 150 })
  end,
})

-- Avisa quando um arquivo aberto muda no disco (ex.: `git checkout`) e o
-- Neovim recarrega o buffer.
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  group = augroup,
  desc = "Avisar quando o arquivo mudou no disco",
  callback = function(args)
    vim.notify("Recarregado do disco: " .. vim.fn.fnamemodify(args.file, ":t"), vim.log.levels.INFO)
  end,
})

-- Exemplo: usar 4 espaços só em arquivos Python (o LazyVim já faz isso via
-- extras de linguagem, mas serve de modelo).
--
-- vim.api.nvim_create_autocmd("FileType", {
--   group = augroup,
--   pattern = "python",
--   callback = function()
--     vim.opt_local.shiftwidth = 4
--     vim.opt_local.tabstop = 4
--   end,
-- })
