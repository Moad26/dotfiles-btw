{ pkgs, ... }:
{
  # CLI tools only: the Docker daemon remains managed by NixOS.
  packages = with pkgs; [
    docker
    kubectl
    kind
    minikube
    kubernetes-helm
    kustomize
    k9s
    jq
    yq-go
  ];

  # Short commands available only in this development shell.
  scripts = {
    kstart = {
      description = "Start local Minikube profile 'devops'";
      exec = ''
        if ! docker info >/dev/null 2>&1; then
          echo "Docker is not available. On NixOS, try: sudo systemctl start docker" >&2
          exit 1
        fi
        minikube start --profile devops --driver=docker "$@"
      '';
    };

    kstop = {
      description = "Stop the local Minikube cluster";
      exec = "minikube stop --profile devops";
    };

    kstatus = {
      description = "Show local Minikube status";
      exec = "minikube status --profile devops";
    };

    kpods = {
      description = "Show pods in the local devops context";
      exec = ''
        kubectl --context devops get pods -A "$@"
      '';
    };
  };

  enterShell = ''
    echo "Current kubectl context: $(kubectl config current-context 2>/dev/null || echo none)"
  '';

}
