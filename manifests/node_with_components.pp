class bigtop_pp::node_with_components inherits bigtop_pp::hadoop_cluster_node {
  require bigtop_pp::common
  $roles_map = $bigtop_pp::common::roles_map

  # Ensure (even if a single value) that the type is an array.
  if (is_array($cluster_components)) {
    $components_array = $cluster_components
  } else {
    if ($cluster_components == undef) {
      $components_array = ["all"]
    } else {
      $components_array = [$cluster_components]
    }
  }

  $given_components = $components_array[0] ? {
    "all"   => delete(keys($roles_map), ["hdfs-non-ha", "hdfs-ha"]) << "hdfs",
    default => $components_array,
  }
  $ha_dependent_components = $ha_enabled ? {
    true    => "hdfs-ha",
    default => "hdfs-non-ha",
  }
  $components = member($given_components, "hdfs") ? {
    true    => delete($given_components, "hdfs") << $ha_dependent_components,
    default => $given_components
  }

  $master_role_types = ["master", "worker", "library"]
  $standby_role_types = ["standby", "library"]
  $worker_role_types = ["worker", "library"]
  $gateway_role_types = ["client", "gateway_server"]

  if ($::fqdn == $hadoop_head_node or $::fqdn == $hadoop_gateway_node) {
    if ($hadoop_gateway_node == $hadoop_head_node) {
      $role_types = concat($master_role_types, $gateway_role_types)
    } elsif ($::fqdn == $hadoop_head_node) {
      $role_types = $master_role_types
    } else {
      $role_types = $gateway_role_types
    }
  } elsif ($::fqdn == $standby_head_node) {
    $role_types = $standby_role_types
  } else {
    $role_types = $worker_role_types
  }

  $roles = get_roles($components, $role_types, $roles_map)

  class { 'node_with_roles':
    roles => $roles,
  }

  notice("Roles to deploy: ${roles}")
}
