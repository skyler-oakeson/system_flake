{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      devShells.data = pkgs.mkShell {
        packages = [
          (pkgs.python312.withPackages (
            python-pkgs: with python-pkgs; [
              numpy
              pandas

            ]
          ))
        ];
      };
      devShells.python = pkgs.mkShell {
        packages = [
          (pkgs.python3.withPackages (
            python-pkgs: with python-pkgs; [
              pip
            ]
          ))
        ];
        shellHook = ''
          if [ ! -d ".venv" ]; then
            python -m venv .venv
          fi
          source .venv/bin/activate
          if [ -e requirements.txt ]; then
              pip install -r requirements.txt
          fi
        '';
      };
    };
}
