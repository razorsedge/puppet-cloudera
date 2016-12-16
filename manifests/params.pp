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
  $cdh_reposerver = $::cloudera_cdh_reposerver ? {
    undef   => 'http://archive.cloudera.com',
    default => $::cloudera_cdh_reposerver,
  }

  $cm_reposerver = $::cloudera_cm_reposerver ? {
    undef   => 'http://archive.cloudera.com',
    default => $::cloudera_cm_reposerver,
  }

  $ci_reposerver = $::cloudera_ci_reposerver ? {
    undef   => 'http://archive.cloudera.com',
    default => $::cloudera_ci_reposerver,
  }

  $cs_reposerver = $::cloudera_cs_reposerver ? {
    undef   => 'http://archive.cloudera.com',
    default => $::cloudera_cs_reposerver,
  }

  $cg_reposerver = $::cloudera_cg_reposerver ? {
    undef   => 'http://archive.cloudera.com',
    default => $::cloudera_cg_reposerver,
  }

  $cm_server_host = $::cloudera_cm_server_host ? {
    undef   => 'localhost',
    default => $::cloudera_cm_server_host,
  }

  $cm_server_port = $::cloudera_cm_server_port ? {
    undef   => '7182',
    default => $::cloudera_cm_server_port,
  }

  $server_chain_file = $::cloudera_server_chain_file ? {
    undef   => undef,
    default => $::cloudera_server_chain_file,
  }

  $server_keypw = $::cloudera_server_keypw ? {
    undef   => undef,
    default => $::cloudera_server_keypw,
  }

  $oozie_ext = $::cloudera_oozie_ext ? {
    undef   => 'http://archive.cloudera.com/gplextras/misc/ext-2.2.zip',
    default => $::cloudera_oozie_ext,
  }

### The following parameters should not need to be changed.

  $ensure = $::cloudera_ensure ? {
    undef => 'present',
    default => $::cloudera_ensure,
  }

  $service_ensure = $::cloudera_service_ensure ? {
    undef => 'running',
    default => $::cloudera_service_ensure,
  }

  $proxy = $::cloudera_proxy ? {
    undef => 'absent',
    default => $::cloudera_proxy,
  }

  $proxy_username = $::cloudera_proxy_username ? {
    undef => 'absent',
    default => $::cloudera_proxy_username,
  }

  $proxy_password = $::cloudera_proxy_password ? {
    undef => 'absent',
    default => $::cloudera_proxy_password,
  }

  # Since the top scope variable could be a string (if from an ENC), we might
  # need to convert it to a boolean.
  $autoupgrade = $::cloudera_autoupgrade ? {
    undef => false,
    default => $::cloudera_autoupgrade,
  }
  if is_string($autoupgrade) {
    $safe_autoupgrade = str2bool($autoupgrade)
  } else {
    $safe_autoupgrade = $autoupgrade
  }

  $service_enable = $::cloudera_service_enable ? {
    undef => true,
    default => $::cloudera_service_enable,
  }
  if is_string($service_enable) {
    $safe_service_enable = str2bool($service_enable)
  } else {
    $safe_service_enable = $service_enable
  }

  $cm_use_tls = $::cloudera_cm_use_tls ? {
    undef => false,
    default => $::cloudera_cm_use_tls,
  }
  if is_string($cm_use_tls) {
    $safe_cm_use_tls = str2bool($cm_use_tls)
  } else {
    $safe_cm_use_tls = $cm_use_tls
  }

  $use_parcels = $::cloudera_use_parcels ? {
    undef => true,
    default => $::cloudera_use_parcels,
  }
  if is_string($use_parcels) {
    $safe_use_parcels = str2bool($use_parcels)
  } else {
    $safe_use_parcels = $use_parcels
  }

  $install_lzo = $::cloudera_install_lzo ? {
    undef => false,
    default => $::cloudera_install_lzo,
  }
  if is_string($install_lzo) {
    $safe_install_lzo = str2bool($install_lzo)
  } else {
    $safe_install_lzo = $install_lzo
  }

  $install_java = $::cloudera_install_java ? {
    undef => true,
    default => $::cloudera_install_java,
  }
  if is_string($install_java) {
    $safe_install_java = str2bool($install_java)
  } else {
    $safe_install_java = $install_java
  }

  $install_jce = $::cloudera_install_jce ? {
    undef => false,
    default => $::cloudera_install_jce,
  }
  if is_string($install_jce) {
    $safe_install_jce = str2bool($install_jce)
  } else {
    $safe_install_jce = $install_jce
  }

  $install_cmserver = $::cloudera_install_cmserver ? {
    undef => false,
    default => $::cloudera_install_cmserver,
  }
  if is_string($install_cmserver) {
    $safe_install_cmserver = str2bool($install_cmserver)
  } else {
    $safe_install_cmserver = $install_cmserver
  }

  $manage_db_props = $::cloudera_manage_db_props ? {
    undef => true,
    default => $::cloudera_manage_db_props,
  }
  if is_string($manage_db_props) {
    $safe_manage_db_props = str2bool($manage_db_props)
  } else {
    $safe_manage_db_props = $manage_db_props
  }

  if $::operatingsystemmajrelease { # facter 1.7+
    $majdistrelease = $::operatingsystemmajrelease
  } elsif $::lsbmajdistrelease {    # requires LSB to already be installed
    $majdistrelease = $::lsbmajdistrelease
  } elsif $::os_maj_version {       # requires stahnma/epel
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
  $db_pass       = ''
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

  $verify_cert_file = $::cloudera_verify_cert_file ? {
    undef   => "${tls_dir}/certs/cloudera_manager.crt",
    default => $::cloudera_verify_cert_file,
  }

  $server_ca_file = $::cloudera_server_ca_file ? {
    undef   => "${tls_dir}/certs/cloudera_manager-ca.crt",
    default => $::cloudera_server_ca_file,
  }

  $server_cert_file = $::cloudera_server_cert_file ? {
    undef   => "${tls_dir}/certs/${::fqdn}-cloudera_manager.crt",
    default => $::cloudera_server_cert_file,
  }

  $server_key_file = $::cloudera_server_key_file ? {
    undef   => "${tls_dir}/private/${::fqdn}-cloudera_manager.key",
    default => $::cloudera_server_key_file,
  }

  $parcel_dir = $::cloudera_parcel_dir ? {
    undef => '/opt/cloudera/parcels',
    default => $::cloudera_parcel_dir,
  }

}
