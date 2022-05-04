define kerberos::host_keytab (
  $princs = [ $title ],
  $spnego = disabled,
  $owner = $title,
  $group = "",
  $mode = "0400",
  Optional[String] $keytab = "/etc/${title}.keytab"
) {
  $internal_princs = $spnego ? {
    true      => [ 'HTTP' ],
    'enabled' => [ 'HTTP' ],
    default   => [ ],
  }
  realize(Kerberos::Principal[$internal_princs])

  $includes = inline_template("<%=
    [@princs, @internal_princs].flatten.map { |x|
      \"rkt $kerberos::krb_site::keytab_export_dir/#{x}.keytab\"
    }.join(\"\n\")
  %>")

  $princs.each |$curr_princ| {
    unless defined(Kerberos::Principal[$curr_princ]) {
      kerberos::principal { $curr_princ:
      }
    }
  }

  exec { "ktinject.$title":
    path     => $kerberos::krb_site::exec_path,
    command  => "ktutil <<EOF
      $includes
      wkt $keytab
EOF
      chown ${owner}:${group} ${keytab}
      chmod ${mode} ${keytab}",
    creates => $keytab,
    require => [ Kerberos::Principal[$princs],
                 Kerberos::Principal[$internal_princs] ],
  }

  exec { "aquire $title keytab":
      path    => $kerberos::krb_site::exec_path,
      user    => $owner,
      command => "bash -c 'kinit -kt $keytab ${title}/$::fqdn ; kinit -R'",
      require => Exec["ktinject.$title"],
  }
}
