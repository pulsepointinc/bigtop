class hadoop::deploy ($roles) {
  require hadoop

  if ("datanode" in $roles) {
    include hadoop::datanode
  }

  if ("namenode" in $roles) {
    include hadoop::init_hdfs
    include hadoop::namenode

    if ("datanode" in $roles) {
      Class['Hadoop::Namenode'] -> Class['Hadoop::Datanode'] -> Class['Hadoop::Init_hdfs']
    } else {
      Class['Hadoop::Namenode'] -> Class['Hadoop::Init_hdfs']
    }
  }

  if ("standby-namenode" in $roles and $hadoop::common_hdfs::ha != "disabled") {
    include hadoop::namenode
  }

  if ("mapred-app" in $roles) {
    include hadoop::mapred_app
  }

  if ("nodemanager" in $roles) {
    include hadoop::nodemanager
  }

  if ("resourcemanager" in $roles) {
    include hadoop::resourcemanager
    include hadoop::historyserver
    include hadoop::proxyserver

    if ("nodemanager" in $roles) {
      Class['Hadoop::Resourcemanager'] -> Class['Hadoop::Nodemanager']
    }
  }

  if ("secondarynamenode" in $roles and $hadoop::common_hdfs::ha == "disabled") {
    include hadoop::secondarynamenode
  }

  if ("httpfs-server" in $roles) {
    include hadoop::httpfs
  }

  if ("kms" in $roles) {
    include hadoop::kms
  }

  if ("hadoop-client" in $roles) {
    include hadoop::client
  }

  if ("journalnode" in $roles) {
    include hadoop::journalnode
  }
}
