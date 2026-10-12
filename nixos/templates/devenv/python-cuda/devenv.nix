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

    manylinux.enable = true;
  };

  # Make the host NVIDIA driver discoverable.
  enterShell = ''
    export LD_LIBRARY_PATH="/run/opengl-driver/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
  '';
}
