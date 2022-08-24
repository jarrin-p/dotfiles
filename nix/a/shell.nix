{ pkgs ? import <nixpkgs> {} }:
let
  py38 = pkgs.python38.withPackages (packages: with packages; [
    pandas
    requests
    psycopg2
    boto3
    XlsxWriter
  ]);
in
pkgs.mkShell {
    buildInputs = with pkgs; [
        jdk11
        py38
        terraform
        wget
    ];

    AWS_ROLE_ARN = builtins.getEnv "AWS_ROLE_ARN";
    AWS_ACCESS_KEY_ID = builtins.getEnv "AWS_ACCESS_KEY_ID";
    AWS_SECRET_ACCESS_KEY = builtins.getEnv "AWS_SECRET_ACCESS_KEY";
    AWS_SESSION_TOKEN = builtins.getEnv "AWS_SESSION_TOKEN";
    AWS_SECURITY_TOKEN = builtins.getEnv "AWS_SECURITY_TOKEN";
    AWS_ROLE = builtins.getEnv "AWS_ROLE";
}
