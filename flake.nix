{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: let 
    pkgs = import nixpkgs { system = "x86_64-linux"; config = { allowUnfree = true;}; };
  in{
    devShell.x86_64-linux = pkgs.mkShell {
      buildInputs = with pkgs; [
        cc65
        famistudio
        (pkgs.appimageTools.wrapType2 {
          name = "neslightbox";
          src = pkgs.fetchurl {
            url = "https://famicom.party/neslightbox/releases/1.0.0/NES%20Lightbox-1.0.0.AppImage";
            sha256 = "sha256-EgDVs5gYz+pTXJtOyPcPimtMDLh6N/nBcIYvuGE3t5o=";
          };
        })
        (fceux.overrideAttrs (finalAttrs: previousAttrs: { 
          version = "2.6.5";  
            src = fetchFromGitHub {
              owner = "TASEmulators";
              repo = "fceux";
              rev = "v2.6.5";
              hash = "sha256-sY7UyslRPeLw8IDDhx0VObNCUTy3k16Xx3aGBJjxNAk=";
            };
          }))
        just
        butler
      ];
    };
  };
}
