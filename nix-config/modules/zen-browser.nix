{ inputs, ... }: {
  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  /*
   * The settings don't work right now. Use the following links for reference to play around with settings
   * https://github.com/0xc000022070/zen-browser-flake
   * https://github.com/Obscurely/NixObscurely/blob/398ac4e8f25ff4ccc321fd42c71628596acef9d1/modules/desktop/browsers/zen.nix
   */
  programs.zen-browser = {
    enable = true;
    # policies = let
    #   mkLockedAttrs = builtins.mapAttrs (_: value: {
    #     Value = value;
    #     Status = "locked";
    #   });
    # in {
    #   Preferences = mkLockedAttrs {
    #     "browser.tabs.warnOnClose" = true;
    #     "browser.tabs.warnOnOpen" = false;
    #     # and so on...
    #   };
    # };
    
    # policies = {
    #   AutofillAddressEnabled = true;
    #   AutofillCreditCardEnabled = false;
    #   DisableAppUpdate = true;
    #   DisableFeedbackCommands = true;
    # };
  };
}
