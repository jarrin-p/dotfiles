{ pkgs }:
(pkgs.python310Full.withPackages (ps: with ps; [
          sqlparse
          pip
          virtualenv
      ]))
