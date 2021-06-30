class hadoop::deploy ($roles) {
  if ("bigtop-utils" in $roles) {
     include bigtop_utils::client
  }
}
