{
  config,
  pkgs,
  ...
}: {
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions;
      [
        jnoortheen.nix-ide
        usernamehw.errorlens
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
      "editor.formatOnSave" = true;
      "workbench.startupEditor" = "none";
      "explorer.confirmDragAndDrop" = false;
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";
      "nix.serverSettings" = {
        "nil" = {
          "formatting" = {
            "command" = ["alejandra"];
          };
        };
      };
      "editor.renderWhitespace" = "all";
    };
  };

  home.packages = with pkgs; [
    alejandra
    nil
  ];
}
