{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in
{
 # make sure to change these if cloning this config
  home.username = "bowluckie";
  home.homeDirectory = "/home/bowluckie";
  home.stateVersion = "26.05";

  programs.git = {
    enable = true;
    settings = {
      user.name = "bowluckie";
      user.email = "bowluckie@gmail.com";
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
  };

  xdg.configFile = {
    "ghostty".source = link ".config/ghostty";
    "btop".source = link ".config/btop";
    "fastfetch".source = link ".config/fastfetch";
    "waybar".source = link ".config/waybar";
    "nvim".source = link ".config/nvim";
    "hypr".source = link ".config/hypr";
    "rofi".source = link ".config/rofi";
    "swayosd".source = link ".config/swayosd";
  };

  home.file = {
    ".zshrc".source = link ".zshrc";
    ".tmux.conf".source = link ".tmux.conf";
    ".clang-format".source = link ".clang-format";
    ".clang-tidy".source = link ".clang-tidy";
    ".local/bin/dot-move".source = link ".local/bin/dot-move";
    "Pictures/wallpapers".source = link "Pictures/wallpapers";
  };

  programs.home-manager.enable = true;
}
