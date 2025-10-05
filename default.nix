{...}: {
  imports = [
    ../../modules
    ./home-manager
    ./programs
    ./users.nix
  ];
  system = {
    stateVersion = "25.05";
  };
  nix.settings.experimental-features = ["nix-command" "flakes"];
  networking = {
    firewall.enable = true;
    hostName = "pibitcoin";
  };
  services = {
    openssh = {
      enable = true;
      ports = [22];
      settings = {
        UseDns = true;
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
  };
  programs = {
    git.enable = true;
    extra-container.enable = true;
  };
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
      fsType = "ext4";
      options = ["defaults"];
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/c26b49bd-a64b-4ad5-b762-b613730d7931";
      fsType = "ext4";
      options = ["noatime"];
      neededForBoot = true;
    };
    "/var/lib/bitcoind" = {
      depends = [
        "/"
        "/nix"
      ];
      device = "/nix";
      fsType = "none";
      options = [
        "bind"
      ];
    };
    "/mnt/sdCard" = {
      device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
      fsType = "ext4";
      options = ["defaults"];
    };
    "/mnt/nvme" = {
      device = "/dev/disk/by-uuid/c26b49bd-a64b-4ad5-b762-b613730d7931";
      fsType = "ext4";
      options = ["noatime"];
    };
  };
}
