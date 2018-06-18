#
# = Class: geoip::update
#
# This module manages GeoIP update script
#
class geoip::update (
  $package            = $::geoip::params::package_update,
  $package_ensure     = $::geoip::params::package_ensure,
  $geoipconf_path     = $::geoip::params::geoipconf_path,
  $geoipconf_template = $::geoip::params::geoipconf_template,
  $geoipupdate_cron   = 'geoip/geoipupdate.cron.erb',
  $geoipupdate_time   = '6 5 * * 4',
  $userid             = '999999',
  $license_key        = '000000000000',
  $product_ids        = 'GeoLite2-Country',
) inherits geoip::params {

  package { 'GeoIP-update':
    ensure => $package_ensure,
    name   => $package,
  }

  File {
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    require => Package['GeoIP-update'],
  }

  file { '/etc/GeoIP.conf':
    path    => $geoipconf_path,
    content => template($geoipconf_template),
    notify  => Exec['geoip_update_initial'],
  }

  file { '/etc/cron.d/geoipupdate':
    content => template($geoipupdate_cron),
  }

  exec { 'geoip_update_initial':
    command     => '/usr/bin/geoipupdate',
    refreshonly => true,
  }

}
