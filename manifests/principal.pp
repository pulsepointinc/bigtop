define kerberos::principal {
  require "kerberos::client"

  realize(File[$kerberos::krb_site::keytab_export_dir])

  $principal = "$title/$::fqdn"
  $keytab    = "$kerberos::krb_site::keytab_export_dir/$title.keytab"

  exec { "addprinc.$title":
    path => $kerberos::krb_site::exec_path,
    command => "kadmin -w secure -p kadmin/admin -q 'addprinc -randkey $principal'",
    unless => "kadmin -w secure -p kadmin/admin -q listprincs | grep -q $principal",
    require => Package[$kerberos::krb_site::package_name_client],
    tries => 180,
    try_sleep => 1,
  } 
  ->
  exec { "xst.$title":
    path    => $kerberos::krb_site::exec_path,
    command => "kadmin -w secure -p kadmin/admin -q 'xst -k $keytab $principal'",
    unless  => "klist -kt $keytab 2>/dev/null | grep -q $principal",
    require => File[$kerberos::krb_site::keytab_export_dir],
  }
}
