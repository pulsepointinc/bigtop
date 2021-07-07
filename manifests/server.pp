class hadoop_zookeeper::server($myid,
              $port = "2181",
              $datadir = "/var/lib/zookeeper",
              $ensemble = [$myid, "localhost:2888:3888"],
              $client_bind_addr = "",
              $autopurge_purge_interval = "24",
              $autopurge_snap_retain_count = "3",
) inherits hadoop_zookeeper {
  require hadoop_zookeeper
  include hadoop_zookeeper::common

  $kerberos_realm = $hadoop_zookeeper::kerberos_realm

  package { "zookeeper-server":
    ensure => latest,
    require => Package["jdk"],
  }

  service { "zookeeper-server":
    ensure => running,
    require => [
      Package["zookeeper-server"],
      Exec["zookeeper-server-initialize"],
      Class['bigtop_pp::jdk']
    ],
    subscribe => [ File["/etc/zookeeper/conf/zoo.cfg"],
                   File["/var/lib/zookeeper/myid"] ],
    hasrestart => true,
    hasstatus => true,
  }

  file { "/etc/zookeeper/conf/zoo.cfg":
    content => template("hadoop_zookeeper/zoo.cfg"),
    require => Package["zookeeper-server"],
  }

  file { "/var/lib/zookeeper/myid":
    content => inline_template("<%= @myid %>"),
    require => Package["zookeeper-server"],
  }

  exec { "zookeeper-server-initialize":
    command => "/usr/bin/zookeeper-server-initialize",
    user    => "zookeeper",
    creates => "/var/lib/zookeeper/version-2",
    require => Package["zookeeper-server"],
  }

  if ($kerberos_realm and $kerberos_realm != "") {
    require kerberos::client

    kerberos::host_keytab { "zookeeper":
      spnego  => true,
      require => Package["zookeeper-server"],
      before  => Service["zookeeper-server"],
    }

    file { "/etc/zookeeper/conf/server-jaas.conf":
      content => template("hadoop_zookeeper/server-jaas.conf"),
      require => Package["zookeeper-server"],
      notify  => Service["zookeeper-server"],
    }
  }
}
