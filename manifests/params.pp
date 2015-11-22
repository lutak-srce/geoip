# Class: geoip::params
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
      $geoip_version  = '1.4.8'
      $package_ensure = '1.4.8-1.1.el6.art'
    }
  }
}
