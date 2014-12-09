exec { "apt-update":
  command => "/usr/bin/apt-get update"
}

Exec["apt-update"] -> Package <| |>

package {
  "rbenv":
  ensure => present,
  require => Exec['apt-update'],
}

rbenv::install { $vagrant_user:
  home => $vagrant_home,
  require => [Package['rbenv']],
}


rbenv::compile { "$vagrant_user/2.1.5":
  user => $vagrant_user,
  home => $vagrant_home,
  ruby => '2.1.5',
  require => Rbenv::Install["$vagrant_user"],
}

