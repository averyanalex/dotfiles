{
  services.privoxy = {
    enable = true;
    settings = {
      toggle = "0";
      enable-remote-toggle = "0";
      forward-socks5 = [
        "api.github.com falcon:1080 ."
        "copilot-proxy.githubusercontent.com falcon:1080 ."
        ".rutracker.org falcon:1080 ."
        ".openai.com falcon:1080 ."
        ".chatgpt.com falcon:1080 ."
      ];
    };
  };

  environment.sessionVariables = {
    HTTPS_PROXY = "http://127.0.0.1:8118";
    HTTP_PROXY = "http://127.0.0.1:8118";
  };
}
