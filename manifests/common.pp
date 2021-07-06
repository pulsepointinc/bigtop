class hadoop_zookeeper::common (
) inherits hadoop_zookeeper {
  require hadoop_zookeeper

  $kerberos_realm = $hadoop_zookeeper::kerberos_realm

  if ($kerberos_realm and $kerberos_realm != "") {
    file { '/etc/zookeeper/conf/java.env':
      source => 'puppet:///modules/hadoop_zookeeper/java.env',
    }
    Package<| title == 'zookeeper' |> -> File['/etc/zookeeper/conf/java.env']
    Package<| title == 'zookeeper-server' |> -> File['/etc/zookeeper/conf/java.env']
    File['/etc/zookeeper/conf/java.env'] ~> Service<| title == 'zookeeper-server' |>
  }
}
