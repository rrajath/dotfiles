{ ... }: {
  programs.alacritty = {
    enable = true;

    settings = {
      window = {
        opacity = 0.5;
        blur = true;
      };
    };
  };
}
