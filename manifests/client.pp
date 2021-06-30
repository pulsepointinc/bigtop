class hadoop::client {
  package { "bigtop-utils":
    ensure => latest,
  }
}
