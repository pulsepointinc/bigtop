class kerberos::kdc (
  $slave_initially = false
) inherits kerberos::krb_site {
  Class['kerberos::kdc'] -> Class['bigtop_pp::hadoop_cluster_node']

  package { $package_name_kdc:
    ensure => installed,
  }

  file { $kdc_etc_path:
  	ensure => directory,
      owner => root,
      group => root,
      mode => "0700",
      require => Package["$package_name_kdc"],
  }
  file { "${kdc_etc_path}/kdc.conf":
    content => template('kerberos/kdc.conf'),
    require => Package["$package_name_kdc"],
    owner => "root",
    group => "root",
    mode => "0644",
  }
  file { "${kdc_etc_path}/kadm5.acl":
    content => template('kerberos/kadm5.acl'),
    require => Package["$package_name_kdc"],
    owner => "root",
    group => "root",
    mode => "0644",
  }
  file { "${kdc_etc_path}/kpropd.acl":
    content => $kpropd_acl_contents,
    require => Package["$package_name_kdc"],
    owner => "root",
    group => "root",
    mode => "0644",
  }

  if $slave_initially == false { 
    exec { 'kdb5_util':
      path => $exec_path,
      command => "rm -f /etc/kadm5.keytab ; kdb5_util -P cthulhu -r ${realm} create -s && kadmin.local -q 'cpw -pw secure kadmin/admin'",
      creates => "${kdc_etc_path}/stash",
      subscribe => File["${kdc_etc_path}/kdc.conf"],
      require => [
        Package["$package_name_kdc"],
        File["${kdc_etc_path}/kdc.conf"],
        File['/etc/krb5.conf']
      ]
    }
  }

  service { $service_name_kdc:
    ensure => running,
    require => [Package["$package_name_kdc"], File["${kdc_etc_path}/kdc.conf"], Exec["kdb5_util"]],
    subscribe => [File["${kdc_etc_path}/kadm5.acl"], File["${kdc_etc_path}/kdc.conf"]],
    hasrestart => true,
  }

  # TODO: fix params
  service { $service_name_kprop:
    ensure     => running,
    require    => [
      Package["$package_name_kdc"],
      File["${kdc_etc_path}/kdc.conf"],
      Exec["kdb5_util"],
      File["${kdc_etc_path}/kpropd.acl"]
    ],
    subscribe  => [
      File["${kdc_etc_path}/kadm5.acl"],
      File["${kdc_etc_path}/kdc.conf"],
      File["${kdc_etc_path}/kpropd.acl"]
    ],
    hasrestart => true
  }
}
