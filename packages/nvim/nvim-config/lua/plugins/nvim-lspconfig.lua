-- vim.pack.add({ "https://github.com/neovim/nvim-lspconfig" })

local function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

vim.lsp.config('*', {
  root_markers = { '.git' }
})

vim.lsp.enable("clangd")
vim.lsp.enable("hls")
vim.lsp.config('hls', {
  filetypes = { 'haskell', 'lhaskell', 'cabal' },
})

local hostname = trim(vim.fn.system { 'hostname' })
vim.lsp.config("nixd", {
  settings = {
    nixd = {
      nixpkgs = {
        expr = 'import (builtins.getFlake "/home/skyler/cde/nix/conf").inputs.nixpkgs { }'
      },
      formatting = {
        command = { "alejandra" }
      },
      options = {
        nixos = {
          expr = string.format(
            '(builtins.getFlake "/home/skyler/cde/nix/conf").nixosConfigurations.%q.options',
            hostname),
        },
        flake_parts = {
          expr = '(builtins.getFlake "/home/skyler/cde/nix/conf").debug.options'
        }
      }
    }
  }
})
vim.lsp.enable("nixd")

vim.lsp.enable("jdtls")
vim.lsp.enable("ts_ls")
vim.lsp.enable("html")

vim.lsp.enable("csharp_ls")

vim.lsp.enable("rust_analyzer")
vim.lsp.config("rust_analyzer", {
  settings = {
    ['rust-analyzer'] = {
      diagnostics = {
        enable = true,
      }
    }
  }
})

vim.lsp.enable("lua_ls")
vim.lsp.enable("texlab")
-- vim.lsp.enable("pylsp")
-- vim.lsp.config("pylsp", {
--   settings = {
--     pylsp = {
--       plugins = {
--         pycodestyle = {
--           enabled = false
--         }
--       }
--     }
--   }
-- })
-- vim.lsp.config("ruff")
vim.lsp.enable("basedpyright")
vim.lsp.enable("bashls")
