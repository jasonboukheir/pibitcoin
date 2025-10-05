# See how this flake is used in ./usage.sh
# See also:
# https://github.com/erikarvstedt/extra-container
# https://github.com/erikarvstedt/extra-container/blob/master/examples/flake
# Container-related NixOS options
# https://search.nixos.org/options?channel=unstable&query=containers.%3Cname%3E
{
  description = "A basic nix-bitcoin container node";

  inputs = {
    nix-bitcoin.url = "github:fort-nix/nix-bitcoin/nixos-25.05";
    # You can also use a version branch to track a specific NixOS release
    # nix-bitcoin.url = "github:fort-nix/nix-bitcoin/nixos-25.05";

    nixpkgs.follows = "nix-bitcoin/nixpkgs";
    nixpkgs-unstable.follows = "nix-bitcoin/nixpkgs-unstable";
    extra-container.follows = "nix-bitcoin/extra-container";
  };

  outputs = {
    nixpkgs,
    nix-bitcoin,
    extra-container,
    ...
  }:
    extra-container.lib.eachSupportedSystem (system: {
      packages.default = extra-container.lib.buildContainers {
        inherit system;

        # The container uses the nixpkgs from `nix-bitcoin.inputs.nixpkgs` by default

        # Only set this if the `system.stateVersion` of your container
        # host is < 22.05
        # legacyInstallDirs = true;

        config = {
          containers.bitcoin = {
            # Always start container along with the container host
            autoStart = true;
            extra = {
              # Sets
              # privateNetwork = true
              # hostAddress = "${addressPrefix}.1"
              # localAddress = "${addressPrefix}.2"
              # addressPrefix = "10.250.0";

              # Enable internet access for the container
              enableWAN = true;
              # Always allow connections from hostAddress
              firewallAllowHost = true;
              # Make the container's localhost reachable via localAddress
              exposeLocalhost = true;
            };
            bindMounts."/" = {
              hostPath = "/mnt/nix-bitcoin";
              isReadOnly = false;
            };

            config = {
              config,
              pkgs,
              ...
            }: {
              imports = [
                nix-bitcoin.nixosModules.default
                (nix-bitcoin + "/modules/presets/secure-node.nix")
              ];

              # Automatically generate all secrets required by services.
              # The secrets are stored in /etc/nix-bitcoin-secrets in the container
              nix-bitcoin.generateSecrets = true;

              # Enable some services.
              # See ../configuration.nix for all available features.
              services.bitcoind.enable = true;
              services.bitcoind.package = config.nix-bitcoin.pkgs.bitcoind-knots;
              services.clightning.enable = true;
              services.rtl = {
                enable = true;
                nodes.clightning.enable = true;
              };
              services.mempool.enable = true;
            };
          };
        };
      };
    });
}
