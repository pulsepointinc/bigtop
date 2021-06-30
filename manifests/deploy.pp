class kerberos::deploy ($roles) {
  if ("kerberos-server" in $roles) {
    include kerberos::server
    include kerberos::kdc
    include kerberos::kdc::admin_server
  }
}
