{ pkgs
, lib
, config
, ...
}:
let
  browser = [ "firefox.desktop" ];

  associations = {
    "text/html" = browser;
    "x-scheme-handler/http" = browser;
    "x-scheme-handler/https" = browser;
    "x-scheme-handler/ftp" = browser;
    "x-scheme-handler/about" = browser;
    "x-scheme-handler/unknown" = browser;
    "application/x-extension-htm" = browser;
    "application/x-extension-html" = browser;
    "application/x-extension-shtml" = browser;
    "application/xhtml+xml" = browser;
    "application/x-extension-xhtml" = browser;
    "application/x-extension-xht" = browser;

    "audio/*" = [ "mpv.desktop" ];
    "video/*" = [ "mpv.dekstop" ];
    "image/*" = [ "imv.desktop" ];
    "application/json" = browser;
    "application/pdf" = [ "org.pwmt.zathura.desktop.desktop" ];
    "x-scheme-handler/spotify" = [ "spotify.desktop" ];
    "x-scheme-handler/discord" = [ "WebCord.desktop" ];
  };

  texlive = pkgs.texlive.combine {
    inherit
      (pkgs.texlive)
      scheme-small
      noto
      mweights
      cm-super
      cmbright
      fontaxes
      beamer
      ;
  };
  pandoc-watch = pkgs.writeScriptBin "wpandoc" ''
    #!/bin/sh
    while inotifywait -e close_write $1; do pandoc $@; done
  '';
in
{
  home.packages = [ ocrScript texlive pkgs.pandoc pandoc-watch ];
  services = {
    udiskie.enable = true;
    gpg-agent = {
      enable = true;
      pinentryFlavor = "gnome3";
      enableSshSupport = true;
      enableZshIntegration = true;
    };
  };
  programs = {
    gpg.enable = true;
    man.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    tealdeer = {
      enable = true;
      settings = {
        display = {
          compact = false;
          use_pager = true;
        };
        updates = {
          auto_update = true;
        };
      };
    };
    bat = {
      enable = true;
      config = {
        pager = "less -FR";
        theme = "Catppuccin-frappe";
      };
      themes = {
        Catppuccin-mocha = builtins.readFile (pkgs.fetchurl {
          url = "https://github.com/catppuccin/bat/blob/ba4d16880d63e656acced2b7d4e034e4a93f74b1/Catppuccin-frappe.tmTheme";
          hash = "sha256-v8dycvuCdw/zl4LMpa0pMiNVBuk3CMmSCH8vWS+RIVs=";
        });
      };
    };
  };
  xdg = {
    userDirs = {
      enable = true;
      documents = "$HOME/documents ";
      download = "$HOME/downloads ";
      videos = "$HOME/media/videos ";
      music = "$HOME/media/music ";
      pictures = "$HOME/media/pictures ";
      desktop = "$HOME/other ";
      publicShare = "$HOME/other ";
      templates = "$HOME/other ";
    };
    mimeApps.enable = true;
    mimeApps.associations.added = associations;
    mimeApps.defaultApplications = associations;
  };
}

