class kerberos::server {
  include kerberos::client

  class { "kerberos::kdc": } 
  ->
  Class["kerberos::client"] 

  class { "kerberos::kdc::admin_server": }
  -> 
  Class["kerberos::client"]
}
