{ luajit }:
(luajit.withPackages (ps: with ps; [
          fennel
          readline
          luacheck
          lyaml
      ]))
