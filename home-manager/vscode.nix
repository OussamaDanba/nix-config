{
  config,
  pkgs,
  ...
}: {
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions;
      [
        bbenoist.nix
        kamadorueda.alejandra
      ]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "hyper-term-theme";
          publisher = "hsnazar";
          version = "0.3.0";
          sha256 = "sha256-EIRsvvjns3FX4fTom3hHtQALEnaWf+jxakza2HTyPcw=";
        }
      ];
    userSettings = {
      "workbench.colorTheme" = "Hyper Term Black";
      "workbench.colorCustomizations" = {
        "editorInlayHint.background" = "#00000000";
        "editorInlayHint.foreground" = "#666666FF";
      };
      "editor.cursorStyle" = "block";
      "workbench.startupEditor" = "none";
      "explorer.confirmDragAndDrop" = false;
    };
  };
  home.packages = with pkgs; [
    alejandra
  ];
}
