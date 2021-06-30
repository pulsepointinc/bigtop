class kerberos::client inherits kerberos::krb_site {
  package { $package_name_client:
    ensure => installed,
  }
}
