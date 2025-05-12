-- autocommands
--  See `:help lua-guide-autocommands`

-- setup tab expansion for YAML files
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "yaml", "helm", "json", "html" },
	callback = function ()
		vim.bo.tabstop = 2
		vim.bo.softtabstop = 2
		vim.bo.shiftwidth = 2
		vim.bo.expandtab = true
	end,
})
-- Highlight when yanking
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function ()
		vim.highlight.on_yank()
	end,
})

-- go imports
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.go",
	callback = function ()
		local params = vim.lsp.util.make_range_params()
		params.context = { only = { "source.organizeImports" } }
		-- buf_request_sync defaults to a 1000ms timeout. Depending on your
		-- machine and codebase, you may want longer. Add an additional
		-- argument after params if you find that you have to write the file
		-- twice for changes to be saved.
		-- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
		local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
		for cid, res in pairs(result or {}) do
			for _, r in pairs(res.result or {}) do
				if r.edit then
					local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
					vim.lsp.util.apply_workspace_edit(r.edit, enc)
				end
			end
		end
		vim.lsp.buf.format({ async = false })
	end
})

-- auto toggle nvim-tree
-- vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
-- 	callback = function (args)
-- 		if vim.fn.expand("%:p") ~= "" then
-- 			vim.api.nvim_del_autocmd(args.id)
-- 			vim.cmd("noautocmd NvimTreeOpen")
-- 			vim.schedule(function ()
-- 				vim.cmd("wincmd p")
-- 			end)
-- 		end
-- 	end,
-- })
