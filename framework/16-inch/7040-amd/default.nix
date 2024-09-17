{ config, lib, pkgs, ... }:

{
  imports = [
    ../common
    ../common/amd.nix
    ../../../common/cpu/amd/raphael/igpu.nix
  ];

  config.hardware.framework.sensorConfigName = "Framework16-AMD.conf";

}
