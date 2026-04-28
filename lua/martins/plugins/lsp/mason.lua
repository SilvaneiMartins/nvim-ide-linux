return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        { "WhoIsSethDaniel/mason-tool-installer.nvim", version = "*" },
    },
    config = function()
        local mason = require("mason")
        local mason_lspconfig = require("mason-lspconfig")
        local mason_tool_installer = require("mason-tool-installer")

        local has_go = vim.fn.executable("go") == 1

        local function has_supported_python_for_cmake_ls()
            if vim.fn.executable("python3") ~= 1 then
                return false
            end

            local output = vim.fn.systemlist({ "python3", "-c", "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')" })
            local version = output and output[1] or ""
            local major, minor = version:match("^(%d+)%.(%d+)$")

            major = tonumber(major)
            minor = tonumber(minor)

            return major == 3 and minor >= 8 and minor < 14
        end

        mason.setup({
            ui = {
                icons = {
                    package_installed   = "✓",
                    package_pending     = "➜",
                    package_uninstalled = "✗",
                },
            },
        })

        local lsp_servers = {
            "ts_ls",                  -- ✅ TypeScript (formerly tsserver)
            "html",                   -- HTML
            "cssls",                  -- CSS
            "tailwindcss",            -- TailwindCSS
            "svelte",                 -- Svelte
            "lua_ls",                 -- Lua
            "graphql",                -- GraphQL
            "emmet_ls",               -- Emmet
            "prismals",               -- ✅ Prisma
            "pyright",                -- Python
            "eslint",                 -- ESLint
            "rust_analyzer",          -- ✅ Rust
            "clangd",                 -- ✅ C/C++
        }

        if has_go then
            table.insert(lsp_servers, "gopls") -- ✅ Go
        end

        mason_lspconfig.setup({
            ensure_installed = lsp_servers,
        })

        local tools = {
            "prettier",       -- formatter JS/TS
            "stylua",         -- formatter Lua
            "isort",          -- formatter Python
            "black",          -- formatter Python
            "pylint",         -- linter Python
            "eslint_d",       -- linter JS/TS
            "clang-format",   -- formatter C/C++
        }

        if has_go then
            table.insert(tools, "golangci-lint") -- linter Go
        end

        if has_supported_python_for_cmake_ls() then
            table.insert(tools, "cmake-language-server") -- LSP CMake
        end

        mason_tool_installer.setup({
            ensure_installed = tools,
            run_on_start = true, -- instala tudo ao abrir o Neovim
        })
    end,
}
