{
  nf.ai.pi = {
    homeManager =
      {
        config,
        pkgs,
        ...
      }:
      let
        themeName = "stylix";
        c = config.lib.stylix.colors;
        piTheme = {
          "$schema" =
            "https://raw.githubusercontent.com/earendil-works/pi-mono/main/packages/coding-agent/src/modes/interactive/theme/theme-schema.json";
          name = themeName;
          vars = with c.withHashtag; {
            inherit base00;
            inherit base01;
            inherit base02;
            inherit base03;
            inherit base04;
            inherit base05;
            inherit base06;
            inherit base07;
            inherit base08;
            inherit base09;
            inherit base0A;
            inherit base0B;
            inherit base0C;
            inherit base0D;
            inherit base0E;
            inherit base0F;
          };
          colors = {
            accent = "base0A";
            border = "base0D";
            borderAccent = "base0C";
            borderMuted = "base02";
            success = "base0B";
            error = "base08";
            warning = "base09";
            muted = "base04";
            dim = "base03";
            text = "";
            thinkingText = "base04";

            selectedBg = "base02";
            userMessageBg = "base01";
            userMessageText = "base05";
            customMessageBg = "base01";
            customMessageText = "base05";
            customMessageLabel = "base0E";
            toolPendingBg = "base00";
            toolSuccessBg = "base01";
            toolErrorBg = "base01";
            toolTitle = "base06";
            toolOutput = "base04";

            mdHeading = "base0A";
            mdLink = "base0D";
            mdLinkUrl = "base0C";
            mdCode = "base0C";
            mdCodeBlock = "base0B";
            mdCodeBlockBorder = "base03";
            mdQuote = "base04";
            mdQuoteBorder = "base03";
            mdHr = "base03";
            mdListBullet = "base09";

            toolDiffAdded = "base0B";
            toolDiffRemoved = "base08";
            toolDiffContext = "base04";

            syntaxComment = "base03";
            syntaxKeyword = "base0E";
            syntaxFunction = "base0D";
            syntaxVariable = "base08";
            syntaxString = "base0B";
            syntaxNumber = "base09";
            syntaxType = "base0A";
            syntaxOperator = "base05";
            syntaxPunctuation = "base04";

            thinkingOff = "base02";
            thinkingMinimal = "base0D";
            thinkingLow = "base0C";
            thinkingMedium = "base0B";
            thinkingHigh = "base0A";
            thinkingXhigh = "base08";

            bashMode = "base09";
          };
          export = {
            pageBg = c.withHashtag.base00;
            cardBg = c.withHashtag.base01;
            infoBg = c.withHashtag.base02;
          };
        };
      in
      {
        home.packages = with pkgs.llm-agents; [
          pi
        ];

        home.file = {
          ".pi/agent/themes/${themeName}.json".text = builtins.toJSON piTheme;
        };
      };
  };
}
