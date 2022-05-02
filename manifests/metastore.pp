class hadoop_hive::metastore {
  include hadoop_hive::common_config

  package { 'hive-metastore':
    ensure => latest
  }

  service { 'hive-metastore':
    ensure     => running,
    require    => Package['hive-metastore'],
    subscribe  => File['/etc/hive/conf/hive-site.xml'],
    hasrestart => true,
    hasstatus  => true
  }

  Kerberos::Host_keytab <| title == 'hive' |> -> Service['hive-metastore']
  File <| title == '/etc/hadoop/conf/core-site.xml' |> -> Service['hive-metastore']
}
