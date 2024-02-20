{
  home-manager.users.alex = {
    programs.alacritty = {
      enable = true;
      settings = {
        window = {
          opacity = 0.9;
          padding = {
            x = 5;
            y = 7;
          };
        };
        font = {
          normal.family = "MesloLGS NF";
          size = 12.0;
        };
        keyboard.bindings = [
          {
            key = "Return";
            mods = "Control|Shift";
            action = "SpawnNewInstance";
          }
        ];
      };
    };
  };
}
