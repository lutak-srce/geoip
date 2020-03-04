#
# = Class: geoip::update
#
# This module manages GeoIP update script
#
class geoip::update (
  $package            = 'geoipupdate',
  $package_ensure     = 'present',
  $geoipconf_template = 'geoip/GeoIP.conf.erb',
  $account_id         = '0',
  $license_key        = '000000000000',
  $edition_ids        = 'GeoLite2-Country GeoLite2-City',
) {

  package { 'geoipupdate':
    ensure => $package_ensure,
    name   => $package,
  }

  file { '/etc/GeoIP.conf':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template($geoipconf_template),
    require => Package['geoipupdate'],
    notify  => Exec['geoipupdate_initial'],
  }

  exec { 'geoipupdate_initial':
    command     => '/usr/bin/geoipupdate -v',
    refreshonly => true,
  }

}
