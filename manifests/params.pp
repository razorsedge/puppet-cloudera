# == Class: cloudera::params
#
# This class handles OS-specific configuration of the cloudera module.  It
# looks for variables in top scope (probably from an ENC such as Dashboard).  If
# the variable doesn't exist in top scope, it falls back to a hard coded default
# value.
#
# === Authors:
#
# Mike Arnold <mike@razorsedge.org>
#
# === Copyright:
#
# Copyright (C) 2013 Mike Arnold, unless otherwise noted.
#
class cloudera::params {
  # Customize these values if you (for example) mirror public YUM repos to your
  # internal network.
  $yum_priority = '50'
  $yum_protect = '0'

  # If we have a top scope variable defined, use it, otherwise fall back to a
  # hardcoded value.
  $cloudera_cdh_reposerver = getvar('::cloudera_cdh_reposerver')
  if $cloudera_cdh_reposerver {
    $cdh_reposerver = $::cloudera_cdh_reposerver
  } else {
    $cdh_reposerver = 'http://archive.cloudera.com'
  }

  $cloudera_cm_reposerver = getvar('::cloudera_cm_reposerver')
  if $cloudera_cm_reposerver {
    $cm_reposerver = $::cloudera_cm_reposerver
  } else {
    $cm_reposerver = 'http://archive.cloudera.com'
  }

  $cloudera_ci_reposerver = getvar('::cloudera_ci_reposerver')
  if $cloudera_ci_reposerver {
    $ci_reposerver = $::cloudera_ci_reposerver
  } else {
    $ci_reposerver = 'http://archive.cloudera.com'
  }

  $cloudera_cs_reposerver = getvar('::cloudera_cs_reposerver')
  if $cloudera_cs_reposerver {
    $cs_reposerver = $::cloudera_cs_reposerver
  } else {
    $cs_reposerver = 'http://archive.cloudera.com'
  }

  $cloudera_cg_reposerver = getvar('::cloudera_cg_reposerver')
  if $cloudera_cg_reposerver {
    $cg_reposerver = $::cloudera_cg_reposerver
  } else {
    $cg_reposerver = 'http://archive.cloudera.com'
  }

  $cloudera_cm_server_host = getvar('::cloudera_cm_server_host')
  if $cloudera_cm_server_host {
    $cm_server_host = $::cloudera_cm_server_host
  } else {
    $cm_server_host = 'localhost'
  }

  $cloudera_cm_server_port = getvar('::cloudera_cm_server_port')
  if $cloudera_cm_server_port {
    $cm_server_port = $::cloudera_cm_server_port
  } else {
    $cm_server_port = '7182'
  }

  $cloudera_server_chain_file = getvar('::cloudera_server_chain_file')
  if $cloudera_server_chain_file {
    $server_chain_file = $::cloudera_server_chain_file
  } else {
    $server_chain_file = undef
  }

  $cloudera_server_keypw = getvar('::cloudera_server_keypw')
  if $cloudera_server_keypw {
    $server_keypw = $::cloudera_server_keypw
  } else {
    $server_keypw = undef
  }

  $cloudera_oozie_ext = getvar('::cloudera_oozie_ext')
  if $cloudera_oozie_ext {
    $oozie_ext = $::cloudera_oozie_ext
  } else {
    $oozie_ext = 'http://archive.cloudera.com/gplextras/misc/ext-2.2.zip'
  }

  $vm_swappiness = $::cloudera_vm_swappiness ? {
    undef => 0,
    default => $::cloudera_vm_swappiness,
  }

  ### The following parameters should not need to be changed.

  $cloudera_ensure = getvar('::cloudera_ensure')
  if $cloudera_ensure {
    $ensure = $::cloudera_ensure
  } else {
    $ensure = 'present'
  }

  $cloudera_service_ensure = getvar('::cloudera_service_ensure')
  if $cloudera_service_ensure {
    $service_ensure = $::cloudera_service_ensure
  } else {
    $service_ensure = 'running'
  }

  $cloudera_proxy = getvar('::cloudera_proxy')
  if $cloudera_proxy {
    $proxy = $::cloudera_proxy
  } else {
    $proxy = 'absent'
  }

  $cloudera_proxy_username = getvar('::cloudera_proxy_username')
  if $cloudera_proxy_username {
    $proxy_username = $::cloudera_proxy_username
  } else {
    $proxy_username = 'absent'
  }

  $cloudera_proxy_password = getvar('::cloudera_proxy_password')
  if $cloudera_proxy_password {
    $proxy_password = $::cloudera_proxy_password
  } else {
    $proxy_password = 'absent'
  }

  # Since the top scope variable could be a string (if from an ENC), we might
  # need to convert it to a boolean.
  $cloudera_autoupgrade = getvar('::cloudera_autoupgrade')
  if $cloudera_autoupgrade {
    $autoupgrade = $::cloudera_autoupgrade
  } else {
    $autoupgrade = false
  }
  if is_string($autoupgrade) {
    $safe_autoupgrade = str2bool($autoupgrade)
  } else {
    $safe_autoupgrade = $autoupgrade
  }

  $cloudera_service_enable = getvar('::cloudera_service_enable')
  if $cloudera_service_enable {
    $service_enable = $::cloudera_service_enable
  } else {
    $service_enable = true
  }
  if is_string($service_enable) {
    $safe_service_enable = str2bool($service_enable)
  } else {
    $safe_service_enable = $service_enable
  }

  $cloudera_cm_use_tls = getvar('::cloudera_cm_use_tls')
  if $cloudera_cm_use_tls {
    $cm_use_tls = $::cloudera_cm_use_tls
  } else {
    $cm_use_tls = false
  }
  if is_string($cm_use_tls) {
    $safe_cm_use_tls = str2bool($cm_use_tls)
  } else {
    $safe_cm_use_tls = $cm_use_tls
  }

  $cloudera_use_parcels = getvar('::cloudera_use_parcels')
  if $cloudera_use_parcels {
    $use_parcels = $::cloudera_use_parcels
  } else {
    $use_parcels = true
  }
  if is_string($use_parcels) {
    $safe_use_parcels = str2bool($use_parcels)
  } else {
    $safe_use_parcels = $use_parcels
  }

  $cloudera_install_lzo = getvar('::cloudera_install_lzo')
  if $cloudera_install_lzo {
    $install_lzo = $::cloudera_install_lzo
  } else {
    $install_lzo = false
  }
  if is_string($install_lzo) {
    $safe_install_lzo = str2bool($install_lzo)
  } else {
    $safe_install_lzo = $install_lzo
  }

  $cloudera_install_java = getvar('::cloudera_install_java')
  if $cloudera_install_java {
    $install_java = $::cloudera_install_java
  } else {
    $install_java = true
  }
  if is_string($install_java) {
    $safe_install_java = str2bool($install_java)
  } else {
    $safe_install_java = $install_java
  }

  $cloudera_install_jce = getvar('::cloudera_install_jce')
  if $cloudera_install_jce {
    $install_jce = $::cloudera_install_jce
  } else {
    $install_jce = false
  }
  if is_string($install_jce) {
    $safe_install_jce = str2bool($install_jce)
  } else {
    $safe_install_jce = $install_jce
  }

  $cloudera_install_cmserver = getvar('::cloudera_install_cmserver')
  if $cloudera_install_cmserver {
    $install_cmserver = $::cloudera_install_cmserver
  } else {
    $install_cmserver = false
  }
  if is_string($install_cmserver) {
    $safe_install_cmserver = str2bool($install_cmserver)
  } else {
    $safe_install_cmserver = $install_cmserver
  }

  if getvar('::operatingsystemmajrelease') { # facter 1.7+
    $majdistrelease = $::operatingsystemmajrelease
  } elsif getvar('::lsbmajdistrelease') {    # requires LSB to already be installed
    $majdistrelease = $::lsbmajdistrelease
  } elsif getvar('::os_maj_version') {       # requires stahnma/epel
    $majdistrelease = $::os_maj_version
  } else {
    $majdistrelease = regsubst($::operatingsystemrelease,'^(\d+)\.(\d+)','\1')
  }

  $cdh_version = '5'
  $cm_version  = '5'
  $ci_version  = '1'
  $cs_version  = '1'
  $cg_version  = '5'

  $database_name = 'scm'
  $username      = 'scm'
  $password      = 'scm'
  $db_host       = 'localhost'
  $db_port       = '3306'
  $db_user       = 'root'
  $db_pass       = undef
  $db_type       = 'embedded'

  case $::operatingsystem {
    'CentOS', 'RedHat', 'OEL', 'OracleLinux': {
      $java_package_name = 'jdk'
      $cdh_repopath = "/cdh4/redhat/${majdistrelease}/${::architecture}/cdh/"
      $cm_repopath = "/cm4/redhat/${majdistrelease}/${::architecture}/cm/"
      $ci_repopath = "/impala/redhat/${majdistrelease}/${::architecture}/impala/"
      $cs_repopath = "/search/redhat/${majdistrelease}/${::architecture}/search/"
      $cg_repopath = "/gplextras/redhat/${majdistrelease}/${::architecture}/gplextras/"
      $java5_package_name = 'oracle-j2sdk1.7'
      $cm5_repopath = "/cm5/redhat/${majdistrelease}/${::architecture}/cm/"
      $cdh5_repopath = "/cdh5/redhat/${majdistrelease}/${::architecture}/cdh/"
      $cg5_repopath = "/gplextras5/redhat/${majdistrelease}/${::architecture}/gplextras/"
      $tls_dir = '/etc/pki/tls'
      $lzo_package_name = 'lzo'
      $cdh_aptkey = undef
      $cm_aptkey = undef
      $ci_aptkey = undef
      $cs_aptkey = undef
      $cg_aptkey = undef
    }
    'SLES': {
      $java_package_name = 'jdk'
      #$package_provider = 'zypper'
      $cdh_repopath = "/cdh4/sles/${majdistrelease}/${::architecture}/cdh/"
      $cm_repopath = "/cm4/sles/${majdistrelease}/${::architecture}/cm/"
      $ci_repopath = "/impala/sles/${majdistrelease}/${::architecture}/impala/"
      $cs_repopath = "/search/sles/${majdistrelease}/${::architecture}/search/"
      $cg_repopath = "/gplextras/sles/${majdistrelease}/${::architecture}/gplextras/"
      $java5_package_name = 'oracle-j2sdk1.7'
      $cm5_repopath = "/cm5/sles/${majdistrelease}/${::architecture}/cm/"
      $cdh5_repopath = "/cdh5/sles/${majdistrelease}/${::architecture}/cdh/"
      $cg5_repopath = "/gplextras5/sles/${majdistrelease}/${::architecture}/gplextras/"
      $tls_dir = '/etc/ssl'
      $lzo_package_name = 'liblzo2-2'
      $cdh_aptkey = undef
      $cm_aptkey = undef
      $ci_aptkey = undef
      $cs_aptkey = undef
      $cg_aptkey = undef
    }
    'Debian': {
      $java_package_name = 'oracle-j2sdk1.6'
      $cdh_repopath = "/cdh4/debian/${::lsbdistcodename}/${::architecture}/cdh/"
      $cm_repopath = "/cm4/debian/${::lsbdistcodename}/${::architecture}/cm/"
      $ci_repopath = "/impala/debian/${::lsbdistcodename}/${::architecture}/impala/"
      $cs_repopath = "/search/debian/${::lsbdistcodename}/${::architecture}/search/"
      $cg_repopath = "/gplextras/debian/${::lsbdistcodename}/${::architecture}/gplextras/"
      $java5_package_name = 'oracle-j2sdk1.7'
      $cm5_repopath = "/cm5/debian/${::lsbdistcodename}/${::architecture}/cm/"
      $cdh5_repopath = "/cdh5/debian/${::lsbdistcodename}/${::architecture}/cdh/"
      $cg5_repopath = "/gplextras5/debian/${::lsbdistcodename}/${::architecture}/gplextras/"
      $cdh_aptkey = false
      $cm_aptkey = '327574EE02A818DD'
      $ci_aptkey = false
      $cs_aptkey = false
      $cg_aptkey = false
      $architecture = undef
      $tls_dir = '/etc/ssl'
      $lzo_package_name = 'liblzo2-2'
    }
    'Ubuntu': {
      $java_package_name = 'oracle-j2sdk1.6'
      $cdh_repopath = "/cdh4/ubuntu/${::lsbdistcodename}/${::architecture}/cdh/"
      $cm_repopath = "/cm4/ubuntu/${::lsbdistcodename}/${::architecture}/cm/"
      $ci_repopath = "/impala/ubuntu/${::lsbdistcodename}/${::architecture}/impala/"
      $cs_repopath = "/search/ubuntu/${::lsbdistcodename}/${::architecture}/search/"
      $cg_repopath = "/gplextras/ubuntu/${::lsbdistcodename}/${::architecture}/gplextras/"
      $java5_package_name = 'oracle-j2sdk1.7'
      $cm5_repopath = "/cm5/ubuntu/${::lsbdistcodename}/${::architecture}/cm/"
      $cdh5_repopath = "/cdh5/ubuntu/${::lsbdistcodename}/${::architecture}/cdh/"
      $cg5_repopath = "/gplextras5/ubuntu/${::lsbdistcodename}/${::architecture}/gplextras/"
      $cdh_aptkey = false
      $cm_aptkey = '327574EE02A818DD'
      $ci_aptkey = false
      $cs_aptkey = false
      $cg_aptkey = false
      case $::lsbdistcodename {
        'lucid': { $architecture = undef }
        default: { $architecture = $::architecture }
      }
      $tls_dir = '/etc/ssl'
      $lzo_package_name = 'liblzo2-2'
    }
    default: {
      fail("Module ${module_name} is not supported on ${::operatingsystem}")
    }
  }

  $cloudera_verify_cert_file = getvar('::cloudera_verify_cert_file')
  if $cloudera_verify_cert_file {
    $verify_cert_file = $::cloudera_verify_cert_file
  } else {
    $verify_cert_file = "${tls_dir}/certs/cloudera_manager.crt"
  }

  $cloudera_server_ca_file = getvar('::cloudera_server_ca_file')
  if $cloudera_server_ca_file {
    $server_ca_file = $::cloudera_server_ca_file
  } else {
    $server_ca_file = "${tls_dir}/certs/cloudera_manager-ca.crt"
  }

  $cloudera_server_cert_file = getvar('::cloudera_server_cert_file')
  if $cloudera_server_cert_file {
    $server_cert_file = $::cloudera_server_cert_file
  } else {
    $server_cert_file = "${tls_dir}/certs/${::fqdn}-cloudera_manager.crt"
  }

  $cloudera_server_key_file = getvar('::cloudera_server_key_file')
  if $cloudera_server_key_file {
    $server_key_file = $::cloudera_server_key_file
  } else {
    $server_key_file = "${tls_dir}/private/${::fqdn}-cloudera_manager.key"
  }

  $cloudera_parcel_dir = getvar('::cloudera_parcel_dir')
  if $cloudera_parcel_dir {
    $parcel_dir = $::cloudera_parcel_dir
  } else {
    $parcel_dir = '/opt/cloudera/parcels'
  }

}
