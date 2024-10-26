-- Thiết lập biến leader key
vim.g.mapleader = " "

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system {
        "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", lazypath
    }
end
vim.opt.rtp:prepend(lazypath)

-- Cài đặt các plugin với lazy.nvim
require("lazy").setup({
    -- Theme và giao diện
    { "catppuccin/nvim", as = "catppuccin" },
    { "goolord/alpha-nvim" },
    { "nvim-tree/nvim-tree.lua" },
    { "nvim-tree/nvim-web-devicons" },
    { "nvim-lualine/lualine.nvim" },
    { "akinsho/bufferline.nvim" },
    { "nanozuki/tabby.nvim" },
    { "akinsho/toggleterm.nvim" },
    { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
    { "neovim/nvim-lspconfig" },
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "L3MON4D3/LuaSnip" },
    { "saadparwaiz1/cmp_luasnip" },
    { "kyazdani42/nvim-web-devicons" },
    { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },
    { "folke/which-key.nvim" },
    { "NvChad/base46" },
    { "NvChad/ui" },
    -- Thêm noice.nvim và dressing.nvim
    { "folke/noice.nvim", dependencies = { "MunifTanjim/nui.nvim" } },
    { "stevearc/dressing.nvim" },

    -- Project Management
    { "ahmedkhalf/project.nvim", config = function()
        require("project_nvim").setup {
            detection_methods = { "pattern" },
            patterns = { ".git", "Makefile", "package.json" },
        }
        require("telescope").load_extension("projects")
    end },

    -- Tăng cường tìm kiếm và di chuyển
    { "phaazon/hop.nvim", branch = "v2", config = function()
        require("hop").setup()
        vim.api.nvim_set_keymap("n", "s", ":HopChar2<CR>", { silent = true })
    end },
    { "windwp/nvim-spectre", config = function()
        require("spectre").setup()
    end },

    -- Giám sát mã và hiển thị lỗi
    { "folke/trouble.nvim", dependencies = "nvim-tree/nvim-web-devicons", config = function()
        require("trouble").setup()
        vim.api.nvim_set_keymap("n", "<leader>xx", "<cmd>TroubleToggle<CR>", { silent = true, noremap = true })
    end },

    -- Hiển thị Git
    { "lewis6991/gitsigns.nvim", config = function()
        require("gitsigns").setup()
    end },

    -- Thêm animations
    { "echasnovski/mini.animate", config = function()
        require("mini.animate").setup()
    end },
})

-- Tích hợp thêm vào Which-key
local wk = require("which-key")
wk.setup {}
wk.register({
    ["<leader>p"] = { ":Telescope projects<CR>", "Projects" },
    ["<leader>s"] = { ":HopChar2<CR>", "Jump to character" },
    ["<leader>sr"] = { ":lua require('spectre').open()<CR>", "Spectre" },
    ["<leader>x"] = { name = "Trouble" },
    ["<leader>xx"] = { ":TroubleToggle<CR>", "Toggle Trouble" },
    ["<leader>"] = {
        n = { ":NvimTreeToggle<CR>", "Toggle File Tree" },
        f = {
            name = "Telescope",
            f = { "<cmd>Telescope find_files<CR>", "Find File" },
            g = { "<cmd>Telescope live_grep<CR>", "Live Grep" },
            r = { "<cmd>Telescope oldfiles<CR>", "Recent Files" },
        },
        b = {
            name = "Buffer",
            l = { "<cmd>ls<CR>", "List Buffers" },
            n = { "<cmd>bn<CR>", "Next Buffer" },
            p = { "<cmd>bp<CR>", "Previous Buffer" },
            d = { "<cmd>bd<CR>", "Delete Buffer" },
        },
        g = {
            name = "Git",
            s = { "<cmd>Git<CR>", "Git Status" },
            l = { "<cmd>Git log<CR>", "Git Log" },
            p = { "<cmd>Git push<CR>", "Git Push" },
            f = { "<cmd>Git pull<CR>", "Git Pull" },
        },
        q = { ":qa<CR>", "Quit" },
        t = { ":ToggleTerm<CR>", "Toggle Terminal" },
    }
})

-- Cấu hình Catppuccin theme
require("catppuccin").setup({
    flavour = "macchiato",
    background = { light = "latte", dark = "macchiato" },
    styles = {
        comments = { "italic" },
        functions = { "bold" },
        keywords = { "italic" },
    },
})
vim.cmd("colorscheme catppuccin")

-- Alpha dashboard
local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")
dashboard.section.header.val = {
    " ███╗   ██╗██╗   ██╗  ╔██████╗  ██║  ██║   █████╗   ██████╗    ",
    " ████╗  ██║██║   ██║  ██╔═══█╝  ██║  ██║  ██╔══██╗  ██╔═══██╗    ",
    " ██╔██╗ ██║██║   ██║  ██║       ███████║  ███████║  ██║   ██║    ",
    " ██║╚██╗██║╚██╗ ██╔╝  ██╚═══█╗  ██╔══██║  ██╔══██║  ██║   ██║    ",
    " ██║ ╚████║ ╚████╔╝   ║██████║  ██║  ██║  ██║  ██║  ╚██████╔╝    ",
    " ╚═╝  ╚═══╝  ╚═══╝    ╚══════╝  ╚═╝  ╚═╝  ╚═╝  ╚═╝   ╚═════╝      ",
}
dashboard.section.buttons.val = {
    dashboard.button("e", "  New file", ":ene <BAR> startinsert<CR>"),
    dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
    dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
    dashboard.button("t", "  Open terminal", ":ToggleTerm<CR>"),
    dashboard.button("q", "  Quit", ":qa<CR>"),
}
alpha.setup(dashboard.config)

-- nvim-tree configuration
require("nvim-tree").setup({
    view = {
        width = 30,
        side = "left",
    },
    filters = {
        dotfiles = false,
    },
    renderer = {
        highlight_opened_files = "all",
    },
})
vim.api.nvim_set_keymap("n", "<leader>n", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

-- Lualine setup
require('lualine').setup {
    options = {
        theme = 'catppuccin',
        section_separators = {'', ''},
        component_separators = {'|', '|'},
        icons_enabled = true,
    },
}

-- Bufferline setup
require("bufferline").setup {
    options = {
        numbers = "ordinal",
        diagnostics = "nvim_lsp",
        separator_style = "slant",
        show_buffer_close_icons = true,
        show_close_icon = true,
    },
}

-- Tabby setup
require("tabby.tabline").use_preset("active_wins_at_tail", {
    tab_name = {
        name_fallback = function(tabid)
            return "Tab " .. vim.api.nvim_tabpage_get_number(tabid)
        end,
    },
    theme = {
        fill = "TabLineFill",
        head = "TabLine",
        current_tab = "TabLineSel",
        tab = "TabLine",
        win = "TabLine",
        tail = "TabLine",
    },
})

-- Toggleterm setup
require("toggleterm").setup({
    open_mapping = [[<C-t>]],
    direction = 'horizontal',
    size = 10,
    shell = "pwsh",
})

-- Telescope setup
require("telescope").setup {
    defaults = {
        layout_config = { horizontal = { preview_width = 0.6 } },
        mappings = { i = { ["<C-u>"] = false, ["<C-d>"] = false } },
    },
}
vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { noremap = true, silent = true })

-- Treesitter for syntax highlighting
require("nvim-treesitter.configs").setup {
    ensure_installed = { "lua", "javascript", "typescript", "html", "css", "php" },
    highlight = { enable = true },
}

-- nvim-cmp configuration
local cmp = require("cmp")
cmp.setup({
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    mapping = {
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
    },
    sources = {
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "path" },
    },
})

-- Cấu hình cho noice.nvim
require("noice").setup({
    cmdline = {
        enabled = true,
        view = "cmdline_popup",
    },
    messages = {
        enabled = true,
    },
    popupmenu = {
        enabled = true,
    },
})

-- Cấu hình cho dressing.nvim
require("dressing").setup({
    input = {
        enabled = true,
        default_prompt = "Input:",
        prompt_align = "center",
    },
    select = {
        enabled = true,
        backend = { "telescope", "builtin" },
    },
})
