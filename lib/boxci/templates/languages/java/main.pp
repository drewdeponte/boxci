exec { "apt-update":
  command => "/usr/bin/apt-get update"
}

Exec["apt-update"] -> Package <| |>

<% if @project_config.jvm -%>
<% @project_config.jvm.each do |jvm_version| -%>
package { "openjdk-<%= jvm_version-%>-jdk":
  ensure => 'present',
  require => Exec['apt-update'],
}
<% end %>  

exec{ "update-java-alternatives -s java-1.<%= @project_config.jvm.first -%>.0-openjdk-amd64":
  path    => ["/usr/bin", "/usr/sbin"],
  require => Package["openjdk-<%= @project_config.jvm.first -%>-jdk"],
}

<% end %>
