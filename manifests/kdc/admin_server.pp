class kerberos::kdc::admin_server inherits kerberos::kdc {

  package { "$package_name_admin":
    ensure => installed,
    require => Package["$package_name_kdc"],
  }

  exec { '/usr/bin/setsebool -P kadmind_disable_trans 1':
    onlyif => '/usr/bin/test -f /usr/bin/setsebook'
  } ->
  exec { '/usr/bin/setsebool -P krb5kdc_disable_trans 1':
    onlyif => '/usr/bin/test -f /usr/bin/setsebook'
  } ->
  service { "$service_name_admin":
    ensure => running,
    require => [Package["$package_name_admin"], Service["$service_name_kdc"]],
    subscribe => [File["${kdc_etc_path}/kadm5.acl"], File["${kdc_etc_path}/kdc.conf"]],
    hasrestart => true,
  }
}
