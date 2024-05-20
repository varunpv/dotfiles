return {
  {
    'tpope/vim-fugitive',
  },
  {
    'almo7aya/openingh.nvim',
    config = function()
      vim.keymap.set('n', '<Leader>gf', ':OpenInGHFile <CR>', { silent = true, noremap = true })
      vim.keymap.set('v', '<Leader>gf', ':OpenInGHFileLines <CR>', { silent = true, noremap = true })
    end,
  },
}
