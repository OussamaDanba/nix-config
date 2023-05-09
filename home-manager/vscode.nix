{
  config,
  pkgs,
  ...
}: {
  programs.vscode = {
    enable = true;
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    extensions = with pkgs.vscode-extensions;
      [
        jnoortheen.nix-ide
        ms-vscode.cpptools
        usernamehw.errorlens
        xaver.clang-format
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
      "extensions.ignoreRecommendations" = true;
      "explorer.confirmDelete" = false;
      "[c]" = {
        "editor.defaultFormatter" = "xaver.clang-format";
      };
      "editor.rulers" = [80 100 120];
    };
  };

  home.packages = with pkgs; [
    alejandra
    nil
  ];
}
