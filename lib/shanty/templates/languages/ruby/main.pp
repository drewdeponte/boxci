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

<% @project_config.rbenv.each do |ruby_version| -%>

rbenv::compile { "$vagrant_user/<%= ruby_version -%>":
  user => $vagrant_user,
  home => $vagrant_home,
  ruby => '<%= ruby_version -%>',
  require => Rbenv::Install["$vagrant_user"],
}
<% end -%>
