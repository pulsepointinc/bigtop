define hadoop::create_storage_dir {
  exec { "mkdir $name":
    command => "/bin/mkdir -p $name",
    creates => $name,
    user =>"root",
  }
}
