class hadoop_hive::client (
  $hbase_master = '',
  $hbase_zookeeper_quorum = '',
  $hive_execution_engine = 'mr'
) {
  include hadoop_hive::common_config
}
