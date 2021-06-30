define hadoop::namedir_copy ($source, $ssh_identity) {
  exec { "copy namedir $title from first namenode":
    command => "/usr/bin/rsync -avz -e '/usr/bin/ssh -oStrictHostKeyChecking=no -i $ssh_identity' '${source}:$title/' '$title/'",
    user    => "hdfs",
    tag     => "namenode-format",
    creates => "$title/current/VERSION",
  }
}
