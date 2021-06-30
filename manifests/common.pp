class bigtop_pp::common {
  $roles_map = {
    hdfs-non-ha => {
      master => ["namenode"],
      worker => ["datanode"],
      standby => ["secondarynamenode"],
    },
    hdfs-ha => {
      master => ["namenode"],
      worker => ["datanode"],
      standby => ["standby-namenode"],
    },
    yarn => {
      master => ["resourcemanager"],
      worker => ["nodemanager"],
      client => ["hadoop-client"],
      # mapred is the default app which runs on yarn.
      library => ["mapred-app"],
    },
    mapreduce => {
      library => ["mapred-app"],
    },
    kms => {
      master => ["kms"],
    },
    hbase => {
      master => ["hbase-master"],
      worker => ["hbase-server"],
      client => ["hbase-client"],
    },
    solrcloud => {
      worker => ["solr-server"],
    },
    spark => {
      worker => ["spark-on-yarn"],
      client => ["spark-client"],
      library => ["spark-yarn-slave"],
    },
    spark-standalone => {
      master => ["spark-master"],
      worker => ["spark-worker"],
    },
    alluxio => {
      master => ["alluxio-master"],
      worker => ["alluxio-worker"],
    },
    flink => {
      master => ["flink-jobmanager"],
      worker => ["flink-taskmanager"],
    },
    kerberos => {
      master => ["kerberos-server"],
    },
    oozie => {
      master => ["oozie-server"],
      client => ["oozie-client"],
    },
    hcat => {
      master => ["hcatalog-server"],
      gateway_server => ["webhcat-server"],
    },
    sqoop => {
      gateway_server => ["sqoop-server"],
      client => ["sqoop-client"],
    },
    httpfs => {
      gateway_server => ["httpfs-server"],
    },
    hive => {
      master => ["hive-server2", "hive-metastore"],
      client => ["hive-client"],
    },
    tez => {
      client => ["tez-client"],
    },
    zookeeper => {
      worker => ["zookeeper-server"],
      client => ["zookeeper-client"],
    },
    ycsb => {
      client => ["ycsb-client"],
    },
    zeppelin => {
      master => ["zeppelin-server"],
    },
    gpdb => {
      master => ["gpdb-master"],
      worker => ["gpdb-segment"],
    },
    kafka => {
      worker => ["kafka-server"],
    },
    ambari => {
      master => ["ambari-server"],
      worker => ["ambari-agent"],
    },
    bigtop-utils => {
      client => ["bigtop-utils"],
    },
    livy => {
      master => ["livy-server"],
    },
    elasticsearch => {
      master => ["elasticsearch-server"],
      worker => ["elasticsearch-server"],
    },
    logstash => {
      client => ["logstash-client"],
    },
    kibana => {
      client => ["kibana-client"],
    },
  }

#  $modules = [
#    "alluxio",
#    "flink",
#    "hadoop",
#    "hadoop_hbase",
#    "hadoop_hive",
#    "hadoop_oozie",
#    "hadoop_zookeeper",
#    "hcatalog",
#    "livy",
#    "solr",
#    "spark",
#    "tez",
#    "ycsb",
#    "kerberos",
#    "zeppelin",
#    "kafka",
#    "gpdb",
#    "ambari",
#    "bigtop_utils",
#    "elasticsearch",
#    "logstash",
#    "kibana",
#  ]

  $modules = [
    "hadoop",
    "hadoop_zookeeper",
    "kerberos",
    "bigtop_utils"
  ]
}
