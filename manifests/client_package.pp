class hadoop_hive::client_package {
package { 'hive':
    ensure => latest
  }
}
