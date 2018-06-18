#
# = Class: geoip::params
#
# This module manages parameters for GeoIP
#
class geoip::params {
  case $::operatingsystemrelease {
    default: {
      $geoip_version  = '1.4.5'
      $package_ensure = 'present'
    }
    /^5.*/: {
      $geoip_version  = '1.4.8'
      $package_ensure = '1.4.8-1.el5'
    }
    /^6.*/: {
      $geoip_version  = '2.2.1'
      $package_ensure = '2.2.1-2.el6'
      $package        = 'GeoIP'
      $package_update = 'geoipupdate'
      $geoipconf_path     = '/etc/GeoIP.conf'
      $geoipconf_template = 'geoip/GeoIP.conf.erb'
    }
    /^7.*/: {
      $geoip_version  = '1.5.0'
      $package_ensure = 'present'
      $package        = 'GeoIP-GeoLite-data'
      $package_update = 'geoipupdate'
      $geoipconf_path     = '/etc/GeoIP.conf'
      $geoipconf_template = 'geoip/GeoIP.el7.conf.erb'
    }
  }
}
