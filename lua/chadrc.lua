-- Thiết lập biến leader key
vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46/"
vim.g.mapleader = " "  -- Thiết lập leader key là phím khoảng trắng

-- Bootstrap lazy.nvim (Tải và cài đặt lazy.nvim nếu chưa có)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end
vim.opt.rtp:prepend(lazypath)  -- Thêm lazy.nvim vào runtime path

-- Cài đặt các plugin với lazy.nvim
require("lazy").setup({
  -- NvChad base plugin
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",  -- Sử dụng phiên bản v2.5 của NvChad
    import = "nvchad.plugins",
  },
  -- Các plugin cho việc phát triển và giao diện
  "nvim-treesitter/nvim-treesitter",  -- Cài đặt plugin treesitter (hỗ trợ cú pháp tốt hơn)
  "neovim/nvim-lspconfig",  -- Cấu hình LSP cho ngôn ngữ
  "hrsh7th/nvim-cmp",  -- Plugin auto-completion
  "hrsh7th/cmp-nvim-lsp",  -- Nguồn cho LSP completion
  "hrsh7th/cmp-buffer",  -- Nguồn cho buffer completion
  "hrsh7th/cmp-path",  -- Nguồn cho path completion
  "L3MON4D3/LuaSnip",  -- Plugin cho snippet
  "saadparwaiz1/cmp_luasnip",  -- Tích hợp LuaSnip vào nvim-cmp
  "catppuccin/nvim", -- Cài đặt theme Catppuccin
  "nvim-telescope/telescope.nvim", -- Cài đặt plugin telescope (tìm kiếm)
  "nvim-lua/plenary.nvim", -- Dependency cho telescope
  "goolord/alpha-nvim", -- Giao diện chào mừng đẹp với Alpha
  "akinsho/bufferline.nvim", -- Hiển thị danh sách buffer
  "nvim-tree/nvim-tree.lua", -- Cài đặt cây thư mục
  "kyazdani42/nvim-web-devicons", -- Icon cho nvim-tree và bufferline
  "romgrk/barbar.nvim", -- Hiển thị tab theo kiểu trình duyệt
  "nvim-lualine/lualine.nvim", -- Thanh trạng thái đẹp hơn với lualine
  "jose-elias-alvarez/null-ls.nvim", -- Tích hợp linters và formatters
  "folke/which-key.nvim", -- Hiển thị phím tắt nhanh với which-key
  "onsails/lspkind-nvim", -- Thêm icon cho completion
  "tpope/vim-vinegar",  -- Thêm plugin vim-vinegar
  "lewis6991/gitsigns.nvim", -- Hiển thị thay đổi git trong buffer
  "jose-elias-alvarez/typescript.nvim", -- Cấu hình cho TypeScript
  "folke/trouble.nvim", -- Hiển thị lỗi và cảnh báo
  "simrat39/symbols-outline.nvim", -- Hiển thị biểu đồ ký hiệu
  "hrsh7th/vim-vsnip", -- Plugin hỗ trợ snippet
})

-- Kích hoạt netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Gán phím tắt cho lệnh :Explore từ netrw
vim.api.nvim_set_keymap("n", "<leader>e", ":Explore<CR>", { noremap = true, silent = true })

-- Cấu hình cho theme Catppuccin
local selected_theme = "catppuccin"  -- Theme được chọn ban đầu
require("catppuccin").setup({
  flavour = "macchiato",  -- Chọn màu sắc của theme (latte, frappe, macchiato, mocha)
  background = { light = "latte", dark = "macchiato" },  -- Màu nền cho light và dark
  styles = {
    comments = { "italic" },  -- In nghiêng cho comment
    functions = { "bold" },  -- In đậm cho hàm
    keywords = { "italic" },  -- In nghiêng cho từ khóa
  },
})

-- Áp dụng theme
vim.cmd("colorscheme " .. selected_theme)

-- Gán phím tắt để thay đổi theme
vim.api.nvim_set_keymap("n", "<leader>ct", ":lua change_theme()<CR>", { noremap = true, silent = true })

-- Hàm thay đổi theme giữa Catppuccin và Gruvbox
function change_theme()
  if selected_theme == "catppuccin" then
    selected_theme = "gruvbox"  -- Chuyển sang Gruvbox
  else
    selected_theme = "catppuccin"  -- Quay lại Catppuccin
  end
  vim.cmd("colorscheme " .. selected_theme)  -- Áp dụng theme mới
end

-- Cấu hình Base46
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

-- Cấu hình Lualine để chỉ hiển thị tên file
require('lualine').setup {
  options = {
    theme = 'catppuccin', -- Hoặc theme mà bạn đang sử dụng
    section_separators = '', -- Không sử dụng separator
    component_separators = '', -- Không sử dụng separator
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'filename'}, -- Chỉ hiển thị tên file
    lualine_c = {},
    lualine_x = {'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
}

-- Tạo phím tắt lưu file
vim.schedule(function()
  vim.api.nvim_set_keymap("n", "<leader>w", ":w<CR>", { noremap = true, silent = true })
end)

-- Cấu hình cho telescope
require("telescope").setup {
  defaults = {
    layout_config = {
      horizontal = { preview_width = 0.6 },  -- Chiều rộng phần preview
    },
  }
}

-- Phím tắt cho telescope
vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true })  -- Tìm file
vim.api.nvim_set_keymap("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { noremap = true, silent = true })  -- Tìm kiếm văn bản
vim.api.nvim_set_keymap("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { noremap = true, silent = true })  -- Tìm kiếm buffer
vim.api.nvim_set_keymap("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { noremap = true, silent = true })  -- Tìm kiếm help
vim.api.nvim_set_keymap("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", { noremap = true, silent = true })  -- Tìm kiếm file đã mở gần đây

-- Cấu hình cho Alpha (giao diện chào mừng)
local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

-- Phần header (cải thiện thẩm mỹ)
dashboard.section.header.val = {
    " ███╗   ██╗██╗   ██╗  ╔██████╗  ██║  ██║   █████╗   ██████╗    ",
    " ████╗  ██║██║   ██║  ██╔═══█╝  ██║  ██║  ██╔══██╗  ██╔═══██╗    ",
    " ██╔██╗ ██║██║   ██║  ██║       ███████║  ███████║  ██║   ██║    ",
    " ██║╚██╗██║╚██╗ ██╔╝  ██╚═══█╗  ██╔══██║  ██╔══██║  ██║   ██║    ",
    " ██║ ╚████║ ╚████╔╝   ║██████║  ██║  ██║  ██║  ██║  ╚██████╔╝    ",
    " ╚═╝  ╚═══╝  ╚═══╝    ╚══════╝  ╚═╝  ╚═╝  ╚═╝  ╚═╝   ╚═════╝     "
}

-- Thiết lập các phím tắt cho Alpha
dashboard.section.buttons.val = {
    dashboard.button("e", "  New File"),
    dashboard.button("f", "  Find File"),
    dashboard.button("r", "  Recent Files"),
    dashboard.button("s", "  Settings"),
    dashboard.button("q", "  Quit"),
}

-- Thiết lập cấu hình Alpha
dashboard.section.footer.val = "Welcome to Neovim!"
alpha.setup(dashboard.config)

-- Cấu hình cho nvim-tree (cây thư mục)
require("nvim-tree").setup {
  view = {
    width = 30,  -- Chiều rộng cây thư mục
    side = "left",  -- Vị trí bên trái
  },
  filters = {
    dotfiles = false,  -- Hiện thị file ẩn
  },
}

-- Gán phím tắt cho nvim-tree
vim.api.nvim_set_keymap("n", "<leader>nt", ":NvimTreeToggle<CR>", { noremap = true, silent = true })  -- Hiển thị/ẩn cây thư mục

-- Cấu hình cho gitsigns
require('gitsigns').setup()

-- Cấu hình cho which-key
require("which-key").setup {}

-- Cấu hình cho bufferline
require("bufferline").setup {}

-- Cấu hình cho trouble
require("trouble").setup {}

-- Cấu hình cho lspconfig
local lspconfig = require('lspconfig')
lspconfig.tsserver.setup{}  -- Cấu hình cho TypeScript
lspconfig.pyright.setup{}  -- Cấu hình cho Python
lspconfig.html.setup{}  -- Cấu hình cho HTML
lspconfig.cssls.setup{}  -- Cấu hình cho CSS

-- Cấu hình cho null-ls
require("null-ls").setup {
  sources = {
    require("null-ls").builtins.formatting.prettier,
    require("null-ls").builtins.diagnostics.eslint,
  },
}

-- Thêm icon cho lspkind
local lspkind = require('lspkind')
lspkind.init {}

-- Gán phím tắt cho symbol outline
vim.api.nvim_set_keymap("n", "<leader>so", ":SymbolsOutline<CR>", { noremap = true, silent = true })  -- Hiện thị biểu đồ ký hiệu
