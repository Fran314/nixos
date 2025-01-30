{ config, pkgs, inputs, ...}:

{
    imports = [
        ./with-gnome.nix
    ];

    home-manager.users.baldo = { config, pkgs-nvim, inputs, ... }:
    {
        programs.neovim = 
        {
            enable = true;

            viAlias = true;
            vimAlias = true;
            vimdiffAlias = true;

            extraPackages = with pkgs-nvim; [
                #-- LSP --#
                rust-analyzer
                lua-language-server
                nil                     # Nix language server
                # pyright
                ruff
                # haskell-language-server
                vscode-langservers-extracted    # For cssls
                texlab
                ghc
                astro-language-server
                # nodePackages.vls

                #-- Formatters --#
                nodePackages.prettier
                rustfmt
                stylua

                #-- Utility --#
                xclip
                # wl-clipboard
            ];

            plugins = with pkgs-nvim.vimPlugins; [
                {
                    plugin = catppuccin-nvim;
                    type = "lua";
                    config = builtins.readFile ./nvim/plugin/catppuccin.lua;
                }

                {
                    plugin = telescope-nvim;
                    type = "lua";
                    config = builtins.readFile ./nvim/plugin/telescope.lua;
                }
                telescope-fzf-native-nvim

                {
                    plugin = nvim-treesitter.withAllGrammars;
                    type = "lua";
                    config = builtins.readFile ./nvim/plugin/treesitter.lua;
                }
                nvim-treesitter-textobjects

                {
                    plugin = nvim-lspconfig;
                    type = "lua";
                    config = builtins.readFile ./nvim/plugin/lsp.lua;
                }
                # neodev-nvim
                {
                    plugin = fidget-nvim;
                    type = "lua";
                    config = builtins.readFile ./nvim/plugin/fidget.lua;
                }
                
                {
                    plugin = null-ls-nvim;
                    type = "lua";
                    config = builtins.readFile ./nvim/plugin/null-ls.lua;
                }

                nvim-cmp 
                {
                    plugin = nvim-cmp;
                    type = "lua";
                    config = builtins.readFile ./nvim/plugin/cmp.lua;
                }
                cmp_luasnip
                cmp-nvim-lsp
                luasnip

                {
                  plugin = comment-nvim;
                  type = "lua";
                  config = ''require("Comment").setup()'';
                }

                {
                  plugin = lualine-nvim;
                  type = "lua";
                  config = builtins.readFile ./nvim/plugin/lualine.lua;
                }

                nvim-web-devicons

                barbar-nvim

                {
                    plugin = gitsigns-nvim;
                    type = "lua";
                    config = "require(\"gitsigns\").setup()";
                }

                {
                    plugin = nvim-autopairs;
                    type = "lua";
                    config = "require(\"nvim-autopairs\").setup()";
                }

                {
                    plugin = auto-session;
                    type = "lua";
                    config = "require(\"auto-session\").setup()";
                }
                {
                    plugin = mini-starter;
                    type = "lua";
                    config = builtins.readFile ./nvim/plugin/mini-starter.lua;
                }


                # vim-nix
            ];

            extraLuaConfig = ''
                ${builtins.readFile ./nvim/options.lua}
                ${builtins.readFile ./nvim/remaps.lua}
                ${builtins.readFile ./nvim/autowrap.lua}
                ${builtins.readFile ./nvim/persistent-undo.lua}
                ${builtins.readFile ./nvim/restore-cursor-position.lua}
            '';
        };

        home.file = {
            ".config/nvim/luasnippets" = {
                source = ./nvim/luasnippets;
                recursive = true;
            };
			".prettierrc.json" = {
				source = ./nvim/utils/linter-config/.prettierrc.json;
			};
            # ".config/nvim/utils" = {
            #     source = ./nvim/utils;
            #     recursive = true;
            # };
        };
    };
}
