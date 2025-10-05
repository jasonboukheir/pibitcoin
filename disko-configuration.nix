{...}: {
  disko.devices = {
    disk.nix-bitcoin = {
      device = "/dev/disk/by-uuid/c26b49bd-a64b-4ad5-b762-b613730d7931";
      type = "disk";
      content = {
        type = "gpt";
        partitions.root = {
          size = "100%";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/nix-bitcoin";
          };
        };
      };
    };
  };
}
