-- Logic to kill rogue clangd instances (to work around an issue where multiple  clangds got spun up)
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("LspConfigCleanup", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or client.name ~= "clangd" then return end

    local is_custom_config = false
    if client.config.cmd then
      for _, arg in ipairs(client.config.cmd) do
        if arg == "--background-index" then
          is_custom_config = true
          break
        end
      end
    end

    if not is_custom_config then
      vim.schedule(function()
        print("DEBUG: Killing rogue clangd client (ID: " .. client.id .. ")")
        client.stop()
      end)
    else
      print("DEBUG: Custom clangd attached successfully (ID: " .. client.id .. ")")
    end
  end,
})
