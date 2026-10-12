{ ... }:
{
  languages.python = {
    enable = true;
    version = "3.11";

    venv.enable = true;

    uv = {
      enable = true;
      sync.enable = true;
    };
  };
}
