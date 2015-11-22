# Class: pyqt4
#
# This module manages PyQt4 toolkit
#
class geoip (
  $package_ensure = $geoip::params::package_ensure,
  $geoip_version  = $geoip::params::geoip_version,
) inherits geoip::params {
  require perl::mod::libwww

  # install specific version
  package { 'GeoIP':
    ensure => $package_ensure,
  }

  File {
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    require => Package['GeoIP'],
  }

  # package brings directory, but we decide to purge it
  file { '/usr/share/GeoIP':
    ensure  => directory,
    purge   => true,
    mode    => '0755',
  }

  # fetch and manage GeoIP.dat
  exec { 'fetch_geoip':
    command => '/bin/touch /usr/share/GeoIP/GeoIP.dat && /usr/bin/perl /usr/share/doc/GeoIP-*/fetch-geoipdata.pl > /dev/null 2>&1',
    unless  => '/usr/bin/test -s /usr/share/GeoIP/GeoIP.dat',
    require => File['/usr/share/GeoIP'],
  }
  file { '/usr/share/GeoIP/GeoIP.dat':
    require => Exec['fetch_geoip'],
  }

  # fetch and manage GeoLiteCity.dat
  exec { 'fetch_geolitecity':
    command => '/bin/touch /usr/share/GeoIP/GeoLiteCity.dat && /usr/bin/perl /usr/share/doc/GeoIP-*/fetch-geoipdata-city.pl > /dev/null 2>&1',
    unless  => '/usr/bin/test -s /usr/share/GeoIP/GeoLiteCity.dat',
    require => File['/usr/share/GeoIP'],
  }
  file { '/usr/share/GeoIP/GeoLiteCity.dat':
    require => Exec['fetch_geolitecity'],
  }

  file { '/usr/share/GeoIP/GeoIPCity.dat':
    ensure  => symlink,
    target  => 'GeoLiteCity.dat',
    require => File['/usr/share/GeoIP/GeoLiteCity.dat'],
  }

  # files are fetched via cron every month
  file { '/etc/cron.monthly/fetch-geodata':
    mode    => '0755',
    content => template('geoip/fetch-geodata.erb'),
  }
}
