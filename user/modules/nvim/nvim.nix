{ config, pkgs, ...}:

{
    # programs.neovim = {
    #     enable = true;
    #
    #     viAlias = true;
    #     vimAlias = true;
    #     vimdiffAlias = true;
    # };
    programs.neovim = 
    let
        toLua = str: "lua << EOF\n${str}\nEOF\n";
        toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
    in
    {
        enable = true;

        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;

        extraPackages = with pkgs; [
            lua-language-server

            xclip
            # wl-clipboard
        ];

        plugins = with pkgs.vimPlugins; [
            {
                plugin = catppuccin-nvim;
                type = "lua";
                config = builtins.readFile ./nvim/plugin/catppuccin.lua;
                # config = toLuaFile ./nvim/plugin/catppuccin.lua;
            }

            {
                plugin = telescope-nvim;
                type = "lua";
                config = builtins.readFile ./nvim/plugin/telescope.lua;
            }
            telescope-fzf-native-nvim

            {
                # plugin = (nvim-treesitter.withPlugins (p: [
                #             p.tree-sitter-nix
                #             p.tree-sitter-vim
                #             p.tree-sitter-bash
                #             p.tree-sitter-lua
                #             p.tree-sitter-python
                #             p.tree-sitter-json
                # ]));
                plugin = nvim-treesitter.withAllGrammars;
                config = toLuaFile ./nvim/plugin/treesitter.lua;
            }

            {
                plugin = nvim-lspconfig;
                config = toLuaFile ./nvim/plugin/lsp.lua;
            }

            {
                plugin = comment-nvim;
                config = toLua "require(\"Comment\").setup()";
            }


            neodev-nvim

            nvim-cmp 
            {
                plugin = nvim-cmp;
                config = toLuaFile ./nvim/plugin/cmp.lua;
            }


            cmp_luasnip
            cmp-nvim-lsp

            luasnip
            friendly-snippets


            lualine-nvim
            nvim-web-devicons



            vim-nix

            # {
            #   plugin = vimPlugins.own-onedark-nvim;
            #   config = "colorscheme onedark";
            # }
        ];

        extraLuaConfig = ''
            ${builtins.readFile ./nvim/options.lua}
        '';

        # extraLuaConfig = ''
        #   ${builtins.readFile ./nvim/options.lua}
        #   ${builtins.readFile ./nvim/plugin/lsp.lua}
        #   ${builtins.readFile ./nvim/plugin/cmp.lua}
        #   ${builtins.readFile ./nvim/plugin/telescope.lua}
        #   ${builtins.readFile ./nvim/plugin/treesitter.lua}
        #   ${builtins.readFile ./nvim/plugin/other.lua}
        # '';
    };
    home.file = {
        ".config/nvim.bak" = {
            source = ./config;
            recursive = true;
        };
    };
}
