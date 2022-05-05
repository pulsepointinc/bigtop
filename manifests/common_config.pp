class hadoop_hive::common_config (
  $hbase_master = '',
  $hbase_zookeeper_quorum = '',
  $hive_zookeeper_quorum = '',
  $hive_support_concurrency = false,
  $kerberos_realm = '',
  $metastore_uris = '',
  $metastore_schema_verification = true,
  $server2_thrift_port = '10000',
  $server2_thrift_http_port = '10001',
  $hive_execution_engine = 'mr'
) {
  include hadoop_hive::client_package

  if ($kerberos_realm and $kerberos_realm != '') {
    require kerberos::client
    kerberos::host_keytab { 'hive':
      spnego  => true,
      require => Package['hive']
    }
  }

  file { '/etc/hive/conf/hive-site.xml':
    content => template('hadoop_hive/hive-site.xml'),
    require => Package['hive'],
  }

  file { '/etc/hive/conf/hive-env.sh':
    content => template('hadoop_hive/hive-env.sh'),
    require => Package['hive'],
  }

  file { '/etc/hive/conf/core-site.xml':
    ensure  =>  link,
    target  =>  '/etc/hadoop/conf/core-site.xml',
    require => Package['hive'],
  }
}
