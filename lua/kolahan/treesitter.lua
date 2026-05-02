vim.api.nvim_create_autocmd("PackChanged", {

  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind
    if name == "nvim-treesitter" and (kind == "install" or kind == "update") then
      if not ev.data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      vim.cmd("TSUpdate")
    end
  end,
})

vim.pack.add { { src = "https://github.com/nvim-treesitter/nvim-treesitter" } }

require('nvim-treesitter').install { "lua", "vim", "vimdoc", "javascript", "typescript", "html", "css" }

vim.api.nvim_create_autocmd('FileType', {
  pattern = { '<filetype>' },
  callback = function() 
	vim.treesitter.start()
	vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
	vim.wo[0][0].foldmethod = 'expr'
  end,
})
