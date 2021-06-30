class bigtop_utils::client {
  require bigtop_utils

  package { "bigtop-utils":
    ensure => latest,
  }
}
