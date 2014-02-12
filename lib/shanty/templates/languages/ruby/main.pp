exec { "apt-update":
  command => "/usr/bin/apt-get update"
}

Exec["apt-update"] -> Package <| |>

user { 'shanty':
  ensure      => 'present',
  managehome  => true,
  name        => 'shanty',
  provider    => 'useradd',
  system      => true,
  comment     => 'shanty user',
}

package {
  "rbenv":
  ensure => present,
  require => Exec['apt-update'],
}

rbenv::install { 'shanty':
  home => '/home/shanty',
  require => [Package['rbenv'], User['shanty']],
}
<% @project_config.rbenv.each do |ruby_version| -%>

rbenv::compile { 'shanty/<%= ruby_version -%>':
  user => 'shanty',
  home => '/home/shanty',
  ruby => '<%= ruby_version -%>',
  require => Rbenv::Install['shanty'],
}
<% end -%>
