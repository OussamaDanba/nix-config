{
  config,
  pkgs,
  ...
}: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      ${pkgs.starship}/bin/starship init fish | source
    '';
    plugins = with pkgs.fishPlugins; [
      (with fzf-fish; {inherit name src;})
      (with done; {inherit name src;})
    ];
    shellAliases = {
      lg = "lazygit";
      e = "eza -abhlg --git";
      ls = "eza";
      l = "e";
    };
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    # Fish integration is disabled in favour of the fzf fish plugin. As per this statement from that project's README:
    # Note that the fzf utility has its own out-of-the-box fish package. What
    # sets this package apart is that it has a couple more integrations, most
    # notably tab completion, and will probably be updated more frequently. They
    # are not compatible so either use one or the other.
    #enableFishIntegration = true;
  };
}
