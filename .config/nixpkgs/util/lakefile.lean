import Lake
open Lake DSL

package vimprep where

lean_lib util where

@[default_target]
lean_exe vimprep where
  root := `main
