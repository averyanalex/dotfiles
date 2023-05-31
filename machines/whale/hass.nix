{
  services.home-assistant = {
    config = {
      http = {
        server_host = "10.5.3.20";
      };
      binary_sensor = [
        {
          platform = "ping";
          host = "192.168.3.60";
          name = "PC Status";
          count = 2;
          scan_interval = 5;
        }
      ];
      switch = [
        {
          platform = "template";
          switches.pc = {
            unique_id = "pc";
            friendly_name = "PC";
            value_template = "{{ is_state('binary_sensor.pc_status', 'on') }}";
            availability_template = "{{ not is_state('button.press_pc_power_button', 'unavailable') }}";
            turn_on = [
              {
                condition = "state";
                entity_id = "binary_sensor.pc_status";
                state = "off";
              }
              {
                service = "button.press";
                target.entity_id = "button.press_pc_power_button";
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
                target.entity_id = "button.press_pc_power_button";
              }
            ];
          };
        }
      ];
    };
  };
}
