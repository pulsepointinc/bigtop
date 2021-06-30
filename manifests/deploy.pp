class hadoop_zookeeper::deploy ($roles) {
  require hadoop_zookeeper

  if ("zookeeper-client" in $roles) {
    include hadoop_zookeeper::client
  }

  if ("zookeeper-server" in $roles) {
    include hadoop_zookeeper::server
  }
}
