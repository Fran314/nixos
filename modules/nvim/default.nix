{ config, pkgs, inputs, ...}:

{
    home-manager.users.baldo = { config, pkgs, pkgs-unstable, inputs, ... }:
    {
        nixpkgs = {
            overlays = [
                (final: prev: {
                    vimPlugins = prev.vimPlugins // {
                        own-mini-starter = prev.vimUtils.buildVimPlugin {
                            name = "mini.starter";
                            src = inputs.plugin-mini-starter;
                        };
                    };
                })
            ];
        };

        programs.neovim = 
        {
            enable = true;

            viAlias = true;
            vimAlias = true;
            vimdiffAlias = true;

            extraPackages = (with pkgs; [
                #-- LSP --#
                rust-analyzer
                lua-language-server
                nil                     # Nix language server
                pyright
                haskell-language-server
                vscode-langservers-extracted    # For cssls
                texlab

                #-- Formatters --#
                prettierd
                rustfmt
                stylua

                #-- Utility --#
                xclip
                # wl-clipboard
            ]) ++ (with pkgs-unstable; [
                astro-language-server
            ]);

            plugins = with pkgs.vimPlugins; [
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
                neodev-nvim
                {
                    plugin = fidget-nvim;
                    type = "lua";
                    config = builtins.readFile ./nvim/plugin/fidget.lua;
                }
                {
                    plugin = otter-nvim;
                    type = "lua";
                    config = builtins.readFile ./nvim/plugin/otter.lua;
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
                    plugin = nvim-colorizer-lua;
                    type = "lua";
                    config = "require(\"colorizer\").setup()";
                }
                
                {
                    plugin = auto-session;
                    type = "lua";
                    config = "require(\"auto-session\").setup()";
                }
                {
                    plugin = own-mini-starter;
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
            ".config/nvim/utils" = {
                source = ./nvim/utils;
                recursive = true;
            };
        };
    };
}
