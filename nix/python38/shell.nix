# shell to drop into with python38 that has a few dependencies i need.

{ pkgs ? import <nixpkgs> {} }:
let
  py38 = pkgs.python38.withPackages (packages: with packages; [
    pandas
    requests
    psycopg2
    boto3
  ]);
in
# replacement for pkgs.mkShell
py38.env
