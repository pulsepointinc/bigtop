class hadoop_hive::deploy ($roles) {
  if ("hive-client" in $roles) {
    include hadoop_hive::client
  }
  if ("hive-metastore" in $roles) {
    include hadoop_hive::metastore
  }

  if ("hive-server2" in $roles) {
    include hadoop_hive::server2
    # include hadoop::init_hdfs
    # Class['Hadoop::Init_hdfs'] -> Class['Hadoop_hive::Server2']
    # if ("mapred-app" in $roles) {
    #  Class['Hadoop::Mapred_app'] -> Class['Hadoop_hive::Server2']
    # }
  }

  if ('hive-hbase' in $roles) {
    include hadoop_hive::hbase
  }
}
