class hadoop_zookeeper::client (
) inherits hadoop_zookeeper {
  require hadoop_zookeeper
  include hadoop_zookeeper::common

  $kerberos_realm = $hadoop_zookeeper::kerberos_realm

  package { "zookeeper":
    ensure => latest,
    require => Package["jdk"],
  }

  if ($kerberos_realm and $kerberos_realm != "") {
    file { '/etc/zookeeper/conf/client-jaas.conf':
      content => template('hadoop_zookeeper/client-jaas.conf'),
      require => Package['zookeeper'],
    }
  }
}
