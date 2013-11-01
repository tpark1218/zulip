class zulip-internal::loadbalancer {
  include zulip-internal::base
  include zulip::nginx

  file { "/etc/nginx/zulip-include/":
    require => Package[nginx],
    recurse => true,
    owner  => "root",
    group  => "root",
    mode => 644,
    source => "puppet:///modules/zulip-orig/nginx/zulip-include/",
    notify => Service["nginx"],
  }

  file { "/etc/nginx/sites-available/loadbalancer":
    require => Package[nginx],
    ensure => file,
    owner  => "root",
    group  => "root",
    mode => 644,
    source => "puppet:///modules/zulip-internal/nginx/sites-available/loadbalancer",
  }

  file { "/etc/motd":
    ensure => file,
    owner  => "root",
    group  => "root",
    mode => 644,
    source => "puppet:///modules/zulip-internal/motd.lb0",
  }

  file { '/etc/nginx/sites-enabled/loadbalancer':
    ensure => 'link',
    target => '/etc/nginx/sites-available/loadbalancer',
  }

  # Config for Camo
  $camo_packages = [ "camo",]
  package { $camo_packages: ensure => "installed" }

  file { "/etc/default/camo":
    require => Package[camo],
    ensure => file,
    owner  => "root",
    group  => "root",
    mode => 644,
    source => "puppet:///modules/zulip-internal/camo_defaults",
  }
}
