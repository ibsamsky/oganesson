{ config, ... }:

{
  age.secrets.pbx-gha-pat.rekeyFile = ../secrets/pbx-gha-pat.age;

  services.github-runners = {
    pbx = {
      enable = true;
      name = "pbx";
      tokenFile = config.age.secrets.pbx-gha-pat.path;
      url = "https://github.com/sadneo/cse356-pbx";
    };
  };
}
