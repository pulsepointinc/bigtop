define hadoop::create_storage_dir {
  require hadoop

  exec { "mkdir $name":
    command => "/bin/mkdir -p $name",
    creates => $name,
    user =>"root",
  }
}
