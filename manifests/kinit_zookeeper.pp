class hadoop::kinit_zookeeper {
  include hadoop::common_hdfs

  exec { "Zookeeper kinit":
    command => "/usr/bin/kinit -kt /etc/zookeeper.keytab zookeeper/$fqdn && /usr/bin/kinit -R",
    user    => "zookeeper",
    require => Kerberos::Host_keytab["zookeeper"],
  }
}
