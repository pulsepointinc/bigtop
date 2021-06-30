class bigtop_utils::deploy ($roles) {
  require bigtop_utils

  if ("bigtop-utils" in $roles) {
     include bigtop_utils::client
  }
}
