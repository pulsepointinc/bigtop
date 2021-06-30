# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

class bigtop_pp {
  require bigtop_pp::jdk

  $bigtop_services = [
    'livy-server',
    'elasticsearch',
    'spark-master',
    'spark-worker',
    'spark-history-server',
    'zeppelin',
    'hcatalog-server',
    'webhcat-server',
    'kafka-server',
    'oozie',
    'solr-server',
    'zookeeper-server',
    'hadoop-hdfs-datanode',
    'hadoop-httpfs',
    'hadoop-kms',
    'hadoop-hdfs-namenode',
    'hadoop-hdfs-zkfc',
    'hadoop-hdfs-secondarynamenode',
    'hadoop-hdfs-journalnode',
    'hadoop-yarn-resourcemanager',
    'hadoop-yarn-proxyserver',
    'hadoop-mapreduce-historyserver',
    'hadoop-yarn-nodemanager',
    'ambari-server',
    'ambari-agent',
    'alluxio-master',
    'alluxio-job-master',
    'alluxio-worker',
    'alluxio-job-worker',
    'hbase-thrift',
    'hbase-regionserver',
    'hbase-master',
    'hive-server2',
    'hive-metastore',
    'flink-jobmanager',
    'flink-taskmanager',
  ]

  $bigtop_services.each |$service_name| {
    Class['bigtop_pp::jdk'] -> Service[$service_name]
  }

  $provision_repo = hiera("bigtop::provision_repo", true)
  if ($provision_repo) {
    require bigtop_pp::bigtop_repo
  }

  $roles_enabled = hiera("bigtop::roles_enabled", false)

  if (!is_bool($roles_enabled)) {
    fail("bigtop::roles hiera conf is not of type boolean. It should be set to either true or false")
  }

  if ($roles_enabled) {
    include bigtop_pp::node_with_roles
  } else {
    include bigtop_pp::node_with_components
  }

  if versioncmp($::puppetversion,'3.6.1') >= 0 {
    $allow_virtual_packages = hiera('bigtop::allow_virtual_packages',false)
    Package {
      allow_virtual => $allow_virtual_packages,
    }
  }
}
