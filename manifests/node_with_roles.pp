class bigtop_pp::node_with_roles ($roles = hiera("bigtop::roles")) inherits bigtop_pp::hadoop_cluster_node {
  require bigtop_pp::common
  $roles_map = $bigtop_pp::common::roles_map
  $modules = $bigtop_pp::common::modules

  define deploy_module($roles) {
    class { "${name}::deploy":
    roles => $roles,
    }
  }

  bigtop_pp::node_with_roles::deploy_module { $modules:
    roles => $roles,
  }
}
