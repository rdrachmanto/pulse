{
  description = "Learning Janet Dev Shell";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      name = "pulse";
    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          janet
          jpm
        ];

        buildInputs = with pkgs; [
          janet
        ];

        shellHook = ''
          echo "Welcome to Janet Dev Shell"

          export JANET_PATH="$HOME/.janet-dev/${name}"

          export JANET_TREE="$JANET_PATH/jpm_tree"
          export JANET_LIBPATH="${pkgs.janet}/lib"
          export JANET_HEADERPATH="${pkgs.janet}/include/janet"
          export JANET_BUILDPATH="$JANET_PATH/build"

          export PATH="$PATH:$JANET_TREE/bin"

          mkdir -p "$JANET_TREE"
          mkdir -p "$JANET_BUILDPATH"

          echo "Using external JPM store at: $JANET_PATH"

          find $JANET_PATH/. -maxdepth 1 -type l -delete
          for d in "$JANET_TREE/lib"/*; do
            ln -s "$d" "$JANET_ROOT/$(basename "$d")"
          done
        '';
      };
    };
}
