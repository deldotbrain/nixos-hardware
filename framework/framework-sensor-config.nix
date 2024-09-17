{ lib, pkgs, config, ... }:
let
  cfg = config.hardware.framework;

  repo = pkgs.fetchFromGitHub {
    owner = "FrameworkComputer";
    repo = "lm-sensors";
    rev = "18e8ad54fc4b3f31e40745f3fe75d78eb7820695";
    sha256 = "sha256-J0E6W5vp2YiwvYaoyNw6Jr9LuD1EIPFjl/vCeepzIAA=";
  };

  configFile = pkgs.runCommandNoCC cfg.sensorConfigName { }
    "cp ${repo}/configs/Framework/${cfg.sensorConfigName} $out";
in
{
  options.hardware.framework = {
    configureLmSensors = lib.mkEnableOption
      "Whether to configure lm-sensors and compatible programs"
    // { default = true; };

    sensorConfigName = lib.mkOption {
      description = ''
        The name of the configuration file to use

        Configuration files are taken from Framework's fork of lm-sensors. See <link
        xlink:href="https://github.com/FrameworkComputer/lm-sensors/tree/framework/configs/Framework"
        /> for available files.
      '';
      type = with lib.types; nullOr str;
      default = null;
      example = "Framework16-AMD.conf";
    };
  };

  config = lib.mkIf cfg.configureLmSensors {
    assertions = [{
      assertion = cfg.sensorConfigName != null;
      message = "sensorConfigName must be set if configureLmSensors is enabled";
    }];

    environment.etc."sensors3.conf".source = configFile;
  };
}
