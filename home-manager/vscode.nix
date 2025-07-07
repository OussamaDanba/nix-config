{
  config,
  pkgs,
  ...
}: {
  programs.vscode = {
    enable = true;
    profiles.default = {
      enableExtensionUpdateCheck = false;
      enableUpdateCheck = false;
      extensions = with pkgs.vscode-extensions;
        [
          jnoortheen.nix-ide
          ms-vscode.cmake-tools
          ms-vscode.cpptools
          ms-vsliveshare.vsliveshare
          redhat.vscode-yaml
          twxs.cmake
          usernamehw.errorlens
          xaver.clang-format
          rust-lang.rust-analyzer
          mkhl.direnv
          timonwong.shellcheck
          gruntfuggly.todo-tree
          yzhang.markdown-all-in-one
          sanaajani.taskrunnercode
          ziglang.vscode-zig
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "hyper-term-theme";
            publisher = "hsnazar";
            version = "0.3.0";
            sha256 = "sha256-EIRsvvjns3FX4fTom3hHtQALEnaWf+jxakza2HTyPcw=";
          }
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "doxdocgen";
            publisher = "cschlosser";
            version = "1.4.0";
            sha256 = "sha256-InEfF1X7AgtsV47h8WWq5DZh6k/wxYhl2r/pLZz9JbU=";
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
        "redhat.telemetry.enabled" = false;
        "files.insertFinalNewline" = true;
        "files.trimFinalNewlines" = true;
        "cmake.configureOnOpen" = false;
        "cmake.showOptionsMovedNotification" = false;
        "C_Cpp.errorSquiggles" = "enabled";
        "zig.path" = "zig";
        "zig.zls.path" = "zls";
        "zig.initialSetupDone" = true;
      };
    };
  };

  home.packages = with pkgs; [
    alejandra
    nil
  ];
}
