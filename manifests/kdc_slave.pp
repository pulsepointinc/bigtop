class kerberos::kdc_slave inherits kerberos::krb_site {
  Class['kerberos::kdc'] -> Class['bigtop_pp::hadoop_cluster_node']

  package { $package_name_kdc:
    ensure => installed,
  }

    kerberos::host_keytab { 'kdc_slave':
      # we don't actually need this package as long as we don't put the
      # keytab in a directory managed by it. But it creates user mapred whom we
      # wan't to give the keytab to.
      require => Package["hadoop-yarn"],
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

  exec { "kdb5_util":
    path => $exec_path,
    command => "rm -f /etc/kadm5.keytab ; kdb5_util -P cthulhu -r ${realm} create -s && kadmin.local -q 'cpw -pw secure kadmin/admin'",
    
    creates => "${kdc_etc_path}/stash",

    subscribe => File["${kdc_etc_path}/kdc.conf"],
    # refreshonly => true, 

    require => [Package["$package_name_kdc"], File["${kdc_etc_path}/kdc.conf"], File["/etc/krb5.conf"]],
  }

  service { $service_name_kdc:
    ensure => running,
    require => [Package["$package_name_kdc"], File["${kdc_etc_path}/kdc.conf"], Exec["kdb5_util"]],
    subscribe => [File["${kdc_etc_path}/kadm5.acl"], File["${kdc_etc_path}/kdc.conf"]],
    hasrestart => true,
  }
}
