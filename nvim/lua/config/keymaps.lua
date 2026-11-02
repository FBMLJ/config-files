-- Atalhos próprios (`:h vim.keymap.set`).
--
-- O LazyVim já traz muitos atalhos prontos. Descubra-os com `<leader>` e
-- espere um instante (menu which-key) ou rode `:WhichKey`.
--
-- Lembrando os mais úteis do LazyVim:
--   <leader>gg  -> abre o lazygit
--   <leader>ff  -> busca arquivos (telescope)
--   <leader>sg  -> busca texto no projeto (grep)
--   <leader>e   -> abre o explorador de arquivos (neo-tree)
--   <leader>ca  -> ações de código (renomear, importar...)

local map = vim.keymap.set

-- Salvar e sair sem usar `:w` / `:q`.
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Salvar arquivo" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Fechar janela" })

-- Limpa o destaque da última busca.
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Limpar destaque de busca" })

-- Move linhas para cima/baixo no modo visual (J/K não sobrescrevem o registro).
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Mover seleção para baixo" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Mover seleção para cima" })

-- Abre o terminal embutido na pasta do projeto.
map("n", "<leader>tt", "<cmd>terminal<CR>", { desc = "Abrir terminal" })
