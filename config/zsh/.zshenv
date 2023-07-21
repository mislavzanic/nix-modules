function _source {
  for file in "$@"; do
    [ -r $file ] && source $file
  done
}
