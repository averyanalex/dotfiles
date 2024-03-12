{
  services.home-assistant = {
    config = {
      # http = {
      #   server_host = "10.57.1.10";
      # };
      switch = [
        {
          platform = "template";
          switches.pc = {
            unique_id = "pc";
            friendly_name = "PC";
            value_template = "{{ is_state('binary_sensor.pc_status', 'on') }}";
            availability_template = "{{ not is_state('button.pc_switch_press_power_button', 'unavailable') }}";
            turn_on = [
              {
                condition = "state";
                entity_id = "binary_sensor.pc_status";
                state = "off";
              }
              {
                service = "button.press";
                target.entity_id = "button.pc_switch_press_power_button";
              }
            ];
            turn_off = [
              {
                condition = "state";
                entity_id = "binary_sensor.pc_status";
                state = "on";
              }
              {
                service = "button.press";
                target.entity_id = "button.pc_switch_press_power_button";
              }
            ];
          };
        }
      ];
    };
  };
}
