{...}: {
  disko.devices = {
    disk.nix-bitcoin = {
      device = "/dev/nvme0";
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
