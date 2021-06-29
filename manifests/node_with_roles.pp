class bigtop_pp::node_with_roles ($roles = hiera("bigtop::roles")) inherits bigtop_pp::hadoop_cluster_node {
  require bigtop_pp::common
  $roles_map = $bigtop_pp::common::roles_map

  define deploy_module($roles) {
    class { "${name}::deploy":
    roles => $roles,
    }
  }

  $modules = [
    "alluxio",
    "flink",
    "hadoop",
    "hadoop_hbase",
    "hadoop_hive",
    "hadoop_oozie",
    "hadoop_zookeeper",
    "hcatalog",
    "livy",
    "solr",
    "spark",
    "tez",
    "ycsb",
    "kerberos",
    "zeppelin",
    "kafka",
    "gpdb",
    "ambari",
    "bigtop_utils",
    "elasticsearch",
    "logstash",
    "kibana",
  ]

  bigtop_pp::node_with_roles::deploy_module { $modules:
    roles => $roles,
  }
}
