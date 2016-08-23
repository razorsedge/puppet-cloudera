# == Class: cloudera::cm5::server
#
# This class handles installing and configuring the Cloudera Manager Server.
#
# === Parameters:
#
# [*ensure*]
#   Ensure if present or absent.
#   Default: present
#
# [*autoupgrade*]
#   Upgrade package automatically, if there is a newer version.
#   Default: false
#
# [*service_ensure*]
#   Ensure if service is running or stopped.
#   Default: running
#
# [*database_name*]
#   Name of the database to use for Cloudera Manager.
#   Default: scm
#
# [*username*]
#   Name of the user to use to connect to *database_name*.
#   Default: scm
#
# [*password*]
#   Password to use to connect to *database_name*.
#   Default: scm
#
# [*db_host*]
#   Host to connect to for *database_name*.
#   Default: localhost
#
# [*db_port*]
#   Port on *db_host* to connect to for *database_name*.
#   Default: 3306
#
# [*db_user*]
#   Administrative database user on *db_host*.
#   Default: root
#
# [*db_pass*]
#   Administrative database user *db_user* password.
#   Default:
#
# [*db_type*]
#   Which type of database to use for Cloudera Manager.  Valid options are
#   embedded, mysql, oracle, or postgresql.
#   Default: embedded
#
# [*use_tls*]
#   Whether to enable TLS on the Cloudera Manager server.
#   Default: false
#
# [*server_ca_file*]
#   The file holding the PEM public key of the Cloudera Manager server
#   certificate authority.
#   Default: /etc/pki/tls/certs/cloudera_manager-ca.crt or
#            /etc/ssl/certs/cloudera_manager-ca.crt
#
# [*server_cert_file*]
#   The file holding the PEM public key of the Cloudera Manager server.
#   Default: /etc/pki/tls/certs/${::fqdn}-cloudera_manager.crt or
#            /etc/ssl/certs/${::fqdn}-cloudera_manager.crt
#
# [*server_key_file*]
#   The file holding the PEM private key of the Cloudera Manager server.
#   Default: /etc/pki/tls/private/${::fqdn}-cloudera_manager.key or
#            /etc/ssl/private/${::fqdn}-cloudera_manager.key
#
# [*server_chain_file*]
#   The file holding the PEM public key(s) of the Cloudera Manager server
#   intermediary certificate authority.
#   Default: none
#
# [*server_keypw*]
#   The password used to protect the keystore.
#   Default: none
#
# === Actions:
#
# Installs the packages.
# Configures the database connection.
# If using TLS, configures any SSL certificate keystores.
# Starts the service.
#
# === Requires:
#
#   Class['::mysql::bindings::java']
#   Class['::mysql::server']
#   Class['::oraclerdbms::java']
#   Class['::oraclerdbms::server']
#   Class['::postgresql::lib::java']
#   Class['::postgresql::server']
#   Package['jdk']
#   java_ks
#
# === Sample Usage:
#
#   class { 'cloudera::cm5::server':
#     $database_name = 'cm',
#     $username      = 'clouderaman',
#     $password      = 'mySecretPass',
#     $db_host       = 'dbhost.example.com',
#     $db_user       = 'root',
#     $db_pass       = 'myOtherSecretPass',
#     $db_type       = 'mysql',
#   }
#
# === Authors:
#
# Mike Arnold <mike@razorsedge.org>
#
# === Copyright:
#
# Copyright (C) 2013 Mike Arnold, unless otherwise noted.
#
class cloudera::cm5::server (
  $ensure            = $cloudera::params::ensure,
  $autoupgrade       = $cloudera::params::safe_autoupgrade,
  $service_ensure    = $cloudera::params::service_ensure,
  $database_name     = 'scm',
  $username          = 'scm',
  $password          = 'scm',
  $db_host           = 'localhost',
  $db_port           = '3306',
  $db_user           = 'root',
  $db_pass           = undef,
  $db_type           = 'embedded',
  $use_tls           = $cloudera::params::safe_cm_use_tls,
  $server_ca_file    = $cloudera::params::server_ca_file,
  $server_cert_file  = $cloudera::params::server_cert_file,
  $server_key_file   = $cloudera::params::server_key_file,
  $server_chain_file = $cloudera::params::server_chain_file,
  $server_keypw      = $cloudera::params::server_keypw
) inherits cloudera::params {
  # Validate our booleans
  validate_bool($autoupgrade)
  validate_bool($use_tls)
  # Validate our regular expressions
  $states = [ '^embedded$', '^mysql$','^oracle$','^postgresql$' ]
  validate_re($db_type, $states, '$db_type must be either embedded, mysql, oracle, or postgresql.')

  case $ensure {
    /(present)/: {
      if $autoupgrade == true {
        $package_ensure = 'latest'
      } else {
        $package_ensure = 'present'
      }

      if $service_ensure in [ running, stopped ] {
        $service_ensure_real = $service_ensure
        $service_enable = true
      } else {
        fail('service_ensure parameter must be running or stopped')
      }
      $file_ensure = 'present'
    }
    /(absent)/: {
      $package_ensure = 'absent'
      $service_ensure_real = 'stopped'
      $service_enable = false
      $file_ensure = 'absent'
    }
    default: {
      fail('ensure parameter must be present or absent')
    }
  }

  if $db_type != 'embedded' {
    $file_content = template("${module_name}/db.properties.erb")
  }

  package { 'cloudera-manager-server':
    ensure => $package_ensure,
    tag    => 'cloudera-manager',
  }

  if ! defined(Package['cloudera-manager-daemons']) {
    package { 'cloudera-manager-daemons':
      ensure => $package_ensure,
      tag    => 'cloudera-manager',
    }
  }

  file { '/etc/cloudera-scm-server/db.properties':
    ensure  => $file_ensure,
    path    => '/etc/cloudera-scm-server/db.properties',
    content => $file_content,
    require => Package['cloudera-manager-server'],
    notify  => Service['cloudera-scm-server'],
  }

  service { 'cloudera-scm-server':
    ensure     => $service_ensure_real,
    enable     => $service_enable,
    hasrestart => true,
    hasstatus  => true,
    require    => Package['cloudera-manager-server'],
  }

  case $db_type {
    'embedded': {
      package { 'cloudera-manager-server-db':
        ensure => $package_ensure,
        name   => 'cloudera-manager-server-db-2',
        tag    => 'cloudera-manager',
      }

      service { 'cloudera-scm-server-db':
        ensure     => $service_ensure_real,
        enable     => $service_enable,
        hasrestart => true,
        hasstatus  => true,
        require    => Package['cloudera-manager-server-db'],
        before     => Service['cloudera-scm-server'],
      }
    }
    'mysql': {
      if ( $db_host != 'localhost' ) and ( $db_host != $::fqdn ) {
        # Set the commandline options to connect to a remote database.
        $scmopts = "--host=${db_host} --port=${db_port} --scm-host=${::fqdn}"
        $scm_prepare_database_require = Package['cloudera-manager-server']
      } else {
        #require '::mysql::server'
        Class['::mysql::server'] -> Exec['scm_prepare_database']
        $scm_prepare_database_require = [ Package['cloudera-manager-server'], Class['::mysql::server'], ]
      }

      if ! defined(Class['::mysql::bindings::java']) {
        include '::mysql::bindings'
        include '::mysql::bindings::java'
      }
      realize Exec['scm_prepare_database']
      Class['::mysql::bindings::java'] -> Exec['scm_prepare_database']
    }
    'oracle': {
      if ( $db_host != 'localhost' ) and ( $db_host != $::fqdn ) {
        # Set the commandline options to connect to a remote database.
        $scmopts = "--host=${db_host} --port=${db_port} --scm-host=${::fqdn}"
        $scm_prepare_database_require = Package['cloudera-manager-server']
      } else {
        #require '::oraclerdbms::server'
        #Class['::oraclerdbms::server'] -> Service['cloudera-scm-server']
        #$scm_prepare_database_require = [ Package['cloudera-manager-server'], Service['oracle'], ]
        $scm_prepare_database_require = Package['cloudera-manager-server']
      }

      # TODO: find a Class['::oraclerdbms::java']
      notice('$db_type oracle is not yet fully supported in Class["cloudera::sm::server"].')
      #if ! defined(Class['::oraclerdbms::java']) {
      #  include '::oraclerdbms::java'
      #}
      realize Exec['scm_prepare_database']
      #Class['::oraclerdbms::java'] -> Exec['scm_prepare_database']
    }
    'postgresql': {
      if ( $db_host != 'localhost' ) and ( $db_host != $::fqdn ) {
        # Set the commandline options to connect to a remote database.
        $scmopts = "--host=${db_host} --port=${db_port} --scm-host=${::fqdn}"
        $scm_prepare_database_require = Package['cloudera-manager-server']
      } else {
        #require '::postgresql::server'
        Class['::postgresql::server'] -> Service['cloudera-scm-server']
        $scm_prepare_database_require = [ Package['cloudera-manager-server'], Class['::postgresql::server'], ]
      }

      if ! defined(Class['::postgresql::lib::java']) {
        include '::postgresql::lib::java'
      }
      # TODO: Figure out postgresql auth to make Exec['scm_prepare_database'] work.
      realize Exec['scm_prepare_database']
      Class['::postgresql::lib::java'] -> Exec['scm_prepare_database']
    }
    default: { }
  }

  @exec { 'scm_prepare_database':
    command => "/usr/share/cmf/schema/scm_prepare_database.sh ${db_type} ${scmopts} --user=${db_user} --password=${db_pass} ${database_name} ${username} ${password} && touch /etc/cloudera-scm-server/.scm_prepare_database",
    creates => '/etc/cloudera-scm-server/.scm_prepare_database',
    require => $scm_prepare_database_require,
    before  => Service['cloudera-scm-server'],
  }

  if $use_tls {
    file { '/etc/cloudera-scm-server/keystore':
      ensure  => present,
      mode    => '0640',
      owner   => 'cloudera-scm',
      group   => 'cloudera-scm',
      require => Java_ks['cmca:/etc/cloudera-scm-server/keystore'],
    }

    java_ks { 'cmca:/etc/cloudera-scm-server/keystore':
      ensure       => latest,
      certificate  => $server_ca_file,
      password     => $server_keypw,
      trustcacerts => true,
      require      => Package['cloudera-manager-server'],
      notify       => Service['cloudera-scm-server'],
    }

    java_ks { 'jetty:/etc/cloudera-scm-server/keystore':
      ensure      => latest,
      certificate => $server_cert_file,
      private_key => $server_key_file,
      chain       => $server_chain_file,
      password    => $server_keypw,
      require     => Package['cloudera-manager-server'],
      notify      => Service['cloudera-scm-server'],
    }
  }
}
