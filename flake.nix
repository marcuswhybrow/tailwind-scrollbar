{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }: let 
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
    package-json = builtins.fromJSON (builtins.readFile ./package.json);
  in {
    packages.x86_64-linux."${package-json.name}" = pkgs.buildNpmPackage {
      pname = "${package-json.name}";
      version = "${package-json.version}";
      src = ./.;

      npmDepsHash = "sha256-5U2lKosJ5/zZQ6OMDIkgd6YXZ8UcrpHtFLKGXhRVT1w=";
      dontNpmBuild = true;
      NODE_OPTIONS = "";

      meta = {
        inherit (package-json) description homepage;
        license = pkgs.lib.licenses.mit;
        maintainers = [ 
          "Marcus Whybrow <marcus@whybrow.uk>" 
        ];
      };
    };
    packages.x86_64-linux.default = self.outputs.packages.x86_64-linux."${package-json.name}";
  };
}
