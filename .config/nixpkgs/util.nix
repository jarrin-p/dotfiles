{
  # helper for wrapping commands while preserving script input arguments.
  # `bash` automatically splits strings into lists, i.e. ./script "hello world" is
  # processed as a script with two arguments. this function works around that.
  wrapcmd = cmd: ''eval "${cmd} ''${*@Q}"'';
}
