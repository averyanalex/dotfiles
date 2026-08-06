{
  inputs,
  pkgs,
  ...
}:
let
  llmAgents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  hm.home.packages = [ llmAgents.omp ];
}
