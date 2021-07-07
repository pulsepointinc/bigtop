# Public Puppet class to deploy a Kerberos keytab for Zookeeper to the host.
class hadoop_zookeeper::keytab () {
  require hadoop_zookeeper
  require hadoop_zookeeper::common

  $kerberos_realm = $hadoop_zookeeper::kerberos_realm

  kerberos::host_keytab { 'zookeeper':
    spnego  => true
  }
}
