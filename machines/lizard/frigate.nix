{config, ...}: {
  services.nginx.enable = true;
  networking.firewall.interfaces."nebula.averyan".allowedTCPPorts = [80];
  services.frigate = {
    enable = true;
    hostname = "lizard";
    settings = {
      go2rtc.streams = {
        livingroom = "rtsp://192.168.7.51:10554/tcp/av0_0";
        parking = "rtsp://192.168.7.50:10554/tcp/av0_0";
      };
      cameras = {
        livingroom = {
          ffmpeg.inputs = [
            {
              path = "rtsp://127.0.0.1:8554/livingroom";
              roles = ["detect" "record"];
            }
          ];
        };
        parking = {
          objects.track = ["person" "car"];
          ffmpeg.inputs = [
            {
              path = "rtsp://127.0.0.1:8554/parking";
              roles = ["detect" "record"];
            }
          ];
        };
      };
    };
  };

  services.go2rtc = {
    enable = true;
    settings.streams = config.services.frigate.settings.go2rtc.streams;
  };
}
