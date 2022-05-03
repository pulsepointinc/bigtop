class kerberos::krb_site ($domain = inline_template('<%= @domain %>'),
    $realm = inline_template('<%= @domain.upcase %>'),
    $kdc_server = 'localhost',
    $kdc_port = '88',
    $admin_port = 749,
    $keytab_export_dir = "/var/lib/bigtop_keytabs",
    String $msad_realm = Undef,
    String $msad_server = Undef,
    String $msad_def_domain = Undef,
    String $kpropd_acl_contents = ''
) {

  case $operatingsystem {
      'ubuntu','debian': {
          $package_name_kdc    = 'krb5-kdc'
          $service_name_kdc    = 'krb5-kdc'
          $package_name_admin  = 'krb5-admin-server'
          $service_name_admin  = 'krb5-admin-server'
          $service_name_kprop  = 'krb5-kpropd'
          $package_name_client = 'krb5-user'
          $exec_path           = '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
          $kdc_etc_path        = '/etc/krb5kdc'
          $kdc_db_path         = '/var/lib/krb5kdc'
      }
      # default assumes CentOS, Redhat 5 series (just look at how random it all looks :-()
      default: {
          $package_name_kdc    = 'krb5-server'
          $service_name_kdc    = 'krb5kdc'
          $service_name_kprop  = 'kprop'
          $package_name_admin  = 'krb5-libs'
          $service_name_admin  = 'kadmin'
          $package_name_client = 'krb5-workstation'
          $exec_path           = '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/kerberos/sbin:/usr/kerberos/bin'
          $kdc_etc_path        = '/var/kerberos/krb5kdc'
          $kdc_db_path         = '/var/kerberos/krb5kdc'
      }
  }

  file { "/etc/krb5.conf":
    content => template('kerberos/krb5.conf'),
    owner => "root",
    group => "root",
    mode => "0644",
  }

  @file { $keytab_export_dir:
    ensure => directory,
    owner  => "root",
    group  => "root",
  }

  # Required for SPNEGO
  @kerberos::principal { "HTTP":

  }
}
