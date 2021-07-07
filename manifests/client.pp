class hadoop_zookeeper::client (
) inherits hadoop_zookeeper {
  require hadoop_zookeeper
  require hadoop_zookeeper::common

  $kerberos_realm = $hadoop_zookeeper::kerberos_realm

  if ($kerberos_realm and $kerberos_realm != "") {
    file { '/etc/zookeeper/conf/client-jaas.conf':
      content => template('hadoop_zookeeper/client-jaas.conf')
    }
  }
}
