class hadoop_hive::server2 {
  include hadoop_hive::common_config

  package { 'hive-server2':
    ensure => latest
  }

  service { 'hive-server2':
    ensure     => running,
    require    => Package['hive-server2'],
    subscribe  => File['/etc/hive/conf/hive-site.xml'],
    hasrestart => true,
    hasstatus  => true
  }

  Kerberos::Host_keytab <| title == 'hive' |> -> Service['hive-server2']
  Service <| title == 'hive-metastore' |> -> Service['hive-server2']
}
