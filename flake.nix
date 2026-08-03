{
  description = "cyb3r-kernel — patched Asahi Linux kernel";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: {
    packages.aarch64-linux.default =
      let
        pkgs = nixpkgs.legacyPackages.aarch64-linux;
      in
      pkgs.buildLinux {
        src = ./.;
        version = "7.1.5-cyb3r";
        modDirVersion = "7.1.5";
        kernelPatches = [
          { name = "nightlight"; patch = ./patches/asahi-nightlight.patch; }
          { name = "agx-fdinfo";  patch = ./patches/0001-agx-show-fdinfo-memory-stats.patch; }
        ];
        structuredExtraConfig = with pkgs.lib.kernel; {
          ARM64_16K_PAGES = yes;
          DRM_ASAHI = module;
          RUST_DRM_SCHED = yes;
          RUST_FW_LOADER_ABSTRACTIONS = yes;
          RUST_DRM_GEM_SHMEM_HELPER = yes;
          RUST_APPLE_MAILBOX = yes;
          RUST_APPLE_RTKIT = yes;
        };
        features.rust = true;
      };
  };
}
