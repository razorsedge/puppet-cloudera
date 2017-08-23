# == Class: cloudera
#
# This class handles installing the Cloudera software with the intention
# of the CDH stack being managed by Cloudera Manager.
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
# [*service_enable*]
#   Start service at boot.
#   Default: true
#
# [*cdh_reposerver*]
#   URI of the YUM server.
#   Default: http://archive.cloudera.com
#
# [*cdh_repopath*]
#   The path to add to the $cdh_reposerver URI.
#   Only set this if your platform is not supported or you know what you are
#   doing.
#   Default: auto-set, platform specific
#
# [*cdh_version*]
#   The version of Cloudera's Distribution, including Apache Hadoop to install.
#   Default: 5
#
# [*cm_reposerver*]
#   URI of the YUM server.
#   Default: http://archive.cloudera.com
#
# [*cm_repopath*]
#   The path to add to the $cm_reposerver URI.
#   Only set this if your platform is not supported or you know what you are
#   doing.
#   Default: auto-set, platform specific
#
# [*cm_version*]
#   The version of Cloudera Manager to install.
#   Default: 5
#
# [*cm5_repopath*]
#   The path to add to the $cm_reposerver URI.
#   Only set this if your platform is not supported or you know what you are
#   doing.
#   Default: auto-set, platform specific
#
# [*ci_reposerver*]
#   URI of the YUM server.
#   Default: http://archive.cloudera.com
#
# [*ci_repopath*]
#   The path to add to the $ci_reposerver URI.
#   Only set this if your platform is not supported or you know what you are
#   doing.
#   Default: auto-set, platform specific
#
# [*ci_version*]
#   The version of Cloudera Impala to install.
#   Default: 1
#
# [*cs_reposerver*]
#   URI of the YUM server.
#   Default: http://archive.cloudera.com
#
# [*cs_repopath*]
#   The path to add to the $cs_reposerver URI.
#   Only set this if your platform is not supported or you know what you are
#   doing.
#   Default: auto-set, platform specific
#
# [*cs_version*]
#   The version of Cloudera Search to install.
#   Default: 1
#
# [*cg_reposerver*]
#   URI of the YUM server.
#   Default: http://archive.cloudera.com
#
# [*cg_repopath*]
#   The path to add to the $cg_reposerver URI.
#   Only set this if your platform is not supported or you know what you are
#   doing.
#   Default: auto-set, platform specific
#
# [*cg_version*]
#   The version of Cloudera Search to install.
#   Default: 5
#
# [*cm_server_host*]
#   Hostname of the Cloudera Manager server.
#   Default: localhost
#
# [*cm_server_port*]
#   Port to which the Cloudera Manager server is listening.
#   Default: 7182
#
# [*use_tls*]
#   Whether to enable TLS on the Cloudera Manager server and agent.
#   Default: false
#
# [*verify_cert_file*]
#   The file holding the public key of the Cloudera Manager server as well as
#   the chain of signing certificate authorities. PEM format.
#   Default: /etc/pki/tls/certs/cloudera_manager.crt or
#            /etc/ssl/certs/cloudera_manager.crt
#
# [*use_parcels*]
#   Whether to install CDH software via parcels or packages.
#   Default: true
#
# [*install_lzo*]
#   Whether to install the native LZO compression library packages.  If
#   *use_parcels* is false, then also install the Hadoop-specific LZO
#   compression library packages.  You must configure and deploy the GPLextras
#   parcel repository if *use_parcels* is true.
#   Default: false
#
# [*install_java*]
#   Whether to install the Cloudera supplied Oracle Java Development Kit.  If
#   this is set to false, then an Oracle JDK will have to be installed prior to
#   applying this module.
#   Default: true
#
# [*install_jce*]
#   Whether to install the Oracle Java Cryptography Extension unlimited
#   strength jurisdiction policy files.  This requires manual download of the
#   zip file.  See files/README_JCE.md for download instructions.
#   Default: false
#
# [*install_cmserver*]
#   Whether to install the Cloudera Manager Server.  This should only be set to
#   true on one host in your environment.
#   Default: false
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
# [*proxy*]
#   The URL to the proxy server for the YUM repositories.
#   Default: absent
#
# [*proxy_username*]
#   The username for the YUM proxy.
#   Default: absent
#
# [*proxy_password*]
#   The password for the YUM proxy.
#   Default: absent
#
# [*parcel_dir*]
#   The directory where parcels are downloaded and distributed.
#   Default: /opt/cloudera/parcels
#
# [*vm_swappiness*]
#   The sysctl value for vm.swappiness.
#   Default: 0
#
# === Actions:
#
# Installs YUM repository configuration files.
# Tunes the kernel parameter vm.swappiness to be 0.
#
# === Requires:
#
# Package['jdk'] which is provided by Class['cloudera::java'].  If parameter
# "$install_java => false", then an external Puppet module will have to install
# the Sun/Oracle JDK and provide a Package['jdk'] resource.
#
# === Sample Usage:
#
#   class { 'cloudera':
#     cdh_version    => '4.1',
#     cm_version     => '4.1',
#     cm_server_host => 'smhost.example.com',
#   }
#
# === Authors:
#
# Mike Arnold <mike@razorsedge.org>
#
# === Copyright:
#
# Copyright (C) 2013 Mike Arnold, unless otherwise noted.
#  Copyright (c) 2011, Cloudera, Inc. All Rights Reserved.
#
#  Cloudera, Inc. licenses this file to you under the Apache License,
#  Version 2.0 (the "License"). You may not use this file except in
#  compliance with the License. You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  This software is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
#  CONDITIONS OF ANY KIND, either express or implied. See the License for
#  the specific language governing permissions and limitations under the
#  License.
#
class cloudera (
  $ensure           = $cloudera::params::ensure,
  $autoupgrade      = $cloudera::params::safe_autoupgrade,
  $service_ensure   = $cloudera::params::service_ensure,
  $service_enable   = $cloudera::params::safe_service_enable,
  $cdh_reposerver   = $cloudera::params::cdh_reposerver,
  $cdh_repopath     = $cloudera::params::cdh_repopath,
  $cdh_version      = $cloudera::params::cdh_version,
  $cdh5_repopath    = $cloudera::params::cdh5_repopath,
  $cm_reposerver    = $cloudera::params::cm_reposerver,
  $cm_repopath      = $cloudera::params::cm_repopath,
  $cm_version       = $cloudera::params::cm_version,
  $cm5_repopath     = $cloudera::params::cm5_repopath,
  $ci_reposerver    = $cloudera::params::ci_reposerver,
  $ci_repopath      = $cloudera::params::ci_repopath,
  $ci_version       = $cloudera::params::ci_version,
  $cs_reposerver    = $cloudera::params::cs_reposerver,
  $cs_repopath      = $cloudera::params::cs_repopath,
  $cs_version       = $cloudera::params::cs_version,
  $cg_reposerver    = $cloudera::params::cg_reposerver,
  $cg_repopath      = $cloudera::params::cg_repopath,
  $cg_version       = $cloudera::params::cg_version,
  $cg5_repopath     = $cloudera::params::cg5_repopath,
  $cm_server_host   = $cloudera::params::cm_server_host,
  $cm_server_port   = $cloudera::params::cm_server_port,
  $use_tls          = $cloudera::params::safe_cm_use_tls,
  $verify_cert_file = $cloudera::params::verify_cert_file,
  $use_parcels      = $cloudera::params::safe_use_parcels,
  $install_lzo      = $cloudera::params::safe_install_lzo,
  $install_java     = $cloudera::params::safe_install_java,
  $install_jce      = $cloudera::params::safe_install_jce,
  $install_cmserver  = $cloudera::params::safe_install_cmserver,
  $database_name     = $cloudera::params::database_name,
  $username          = $cloudera::params::username,
  $password          = $cloudera::params::password,
  $db_host           = $cloudera::params::db_host,
  $db_port           = $cloudera::params::db_port,
  $db_user           = $cloudera::params::db_user,
  $db_pass           = $cloudera::params::db_pass,
  $db_type           = $cloudera::params::db_type,
  $server_ca_file    = $cloudera::params::server_ca_file,
  $server_cert_file  = $cloudera::params::server_cert_file,
  $server_key_file   = $cloudera::params::server_key_file,
  $server_chain_file = $cloudera::params::server_chain_file,
  $server_keypw      = $cloudera::params::server_keypw,
  $proxy            = $cloudera::params::proxy,
  $proxy_username   = $cloudera::params::proxy_username,
  $proxy_password   = $cloudera::params::proxy_password,
  $parcel_dir       = $cloudera::params::parcel_dir,
  $vm_swappiness    = $cloudera::params::vm_swappiness
) inherits cloudera::params {
  # Validate our booleans
  validate_bool($autoupgrade)
  validate_bool($service_enable)
  validate_bool($use_tls)
  validate_bool($use_parcels)
  validate_bool($install_lzo)
  validate_bool($install_java)
  validate_bool($install_jce)
  validate_bool($install_cmserver)
  validate_integer($vm_swappiness, 100, 0)

  anchor { 'cloudera::begin': }
  anchor { 'cloudera::end': }

  sysctl { 'vm.swappiness':
    ensure  => $ensure,
    value   => "${vm_swappiness}",
    apply   => true,
    comment => 'Cloudera recommended setting.',
    require => Anchor['cloudera::begin'],
    before  => Anchor['cloudera::end'],
  }

  exec { 'disable_transparent_hugepage_defrag':
    command  => 'if [ -f /sys/kernel/mm/transparent_hugepage/defrag ]; then echo never > /sys/kernel/mm/transparent_hugepage/defrag; fi',
    unless   => 'if [ -f /sys/kernel/mm/transparent_hugepage/defrag ]; then grep -q "\[never\]" /sys/kernel/mm/transparent_hugepage/defrag; fi',
    path     => '/usr/bin:/usr/sbin:/bin:/sbin',
    provider => 'shell',
  }
  exec { 'disable_redhat_transparent_hugepage_defrag':
    command  => 'if [ -f /sys/kernel/mm/redhat_transparent_hugepage/defrag ]; then echo never > /sys/kernel/mm/redhat_transparent_hugepage/defrag; fi',
    unless   => 'if [ -f /sys/kernel/mm/redhat_transparent_hugepage/defrag ]; then grep -q "\[never\]" /sys/kernel/mm/redhat_transparent_hugepage/defrag; fi',
    path     => '/usr/bin:/usr/sbin:/bin:/sbin',
    provider => 'shell',
  }

  if $install_lzo {
    class { 'cloudera::lzo':
      require => Anchor['cloudera::begin'],
      before  => Anchor['cloudera::end'],
    }
  }

  if $cm_version =~ /^5/ {
    if $install_java {
      Class['cloudera::cm5::repo'] -> Class['cloudera::java5']
      class { 'cloudera::java5':
        ensure      => $ensure,
        autoupgrade => $autoupgrade,
        require     => Anchor['cloudera::begin'],
        before      => Anchor['cloudera::end'],
      }
      if $install_jce {
        class { 'cloudera::java5::jce':
          ensure  => $ensure,
          require => [ Anchor['cloudera::begin'], Class['cloudera::java5'], ],
          before  => Anchor['cloudera::end'],
        }
      }
      $cloudera_cm_require = [ Anchor['cloudera::begin'], Class['cloudera::java5'], ]
    } else {
      $cloudera_cm_require = Anchor['cloudera::begin']
    }
#    Package<|tag == 'jdk' and (tag == 'sun' or tag == 'oracle')|> -> Package<|tag == 'cloudera-manager'|>
#    Package<|tag == 'jdk' and (tag == 'sun' or tag == 'oracle')|> -> Package<|tag == 'cloudera-gplextras'|>
#    Package<|tag == 'jdk' and (tag == 'sun' or tag == 'oracle')|> -> Package<|tag == 'cloudera-search'|>
#    Package<|tag == 'jdk' and (tag == 'sun' or tag == 'oracle')|> -> Package<|tag == 'cloudera-cdh4'|>
#    Package<|tag == 'jdk' and (tag == 'sun' or tag == 'oracle')|> -> Package<|tag == 'cloudera-impala'|>

    class { 'cloudera::cm5':
      ensure           => $ensure,
      autoupgrade      => $autoupgrade,
      service_ensure   => $service_ensure,
#      service_enable   => $service_enable,
      server_host      => $cm_server_host,
      server_port      => $cm_server_port,
      use_tls          => $use_tls,
      verify_cert_file => $verify_cert_file,
      require          => $cloudera_cm_require,
      parcel_dir       => $parcel_dir,
      before           => Anchor['cloudera::end'],
    }
    class { 'cloudera::cm5::repo':
      ensure         => $ensure,
      reposerver     => $cm_reposerver,
      repopath       => $cm5_repopath,
      version        => $cm_version,
      proxy          => $proxy,
      proxy_username => $proxy_username,
      proxy_password => $proxy_password,
      require        => Anchor['cloudera::begin'],
      before         => Anchor['cloudera::end'],
    }
    if $install_cmserver {
      class { 'cloudera::cm5::server':
        ensure            => $ensure,
        autoupgrade       => $autoupgrade,
        service_ensure    => $service_ensure,
        database_name     => $database_name,
        username          => $username,
        password          => $password,
        db_host           => $db_host,
        db_port           => $db_port,
        db_user           => $db_user,
        db_pass           => $db_pass,
        db_type           => $db_type,
        use_tls           => $use_tls,
        server_ca_file    => $server_ca_file,
        server_cert_file  => $server_cert_file,
        server_key_file   => $server_key_file,
        server_chain_file => $server_chain_file,
        server_keypw      => $server_keypw,
        require           => $cloudera_cm_require,
        before            => Anchor['cloudera::end'],
      }
    }
    # Skip installing the CDH RPMs if we are going to use parcels.
    if ! $use_parcels {
      if $cdh_version =~ /^5/ {
        class { 'cloudera::cdh5::repo':
          ensure         => $ensure,
          reposerver     => $cdh_reposerver,
          repopath       => $cdh5_repopath,
          version        => $cdh_version,
          proxy          => $proxy,
          proxy_username => $proxy_username,
          proxy_password => $proxy_password,
          require        => Anchor['cloudera::begin'],
          before         => Anchor['cloudera::end'],
        }
        class { 'cloudera::cdh5':
          ensure         => $ensure,
          autoupgrade    => $autoupgrade,
          service_ensure => $service_ensure,
#          service_enable => $service_enable,
          require        => Anchor['cloudera::begin'],
          before         => Anchor['cloudera::end'],
        }
        if $install_lzo {
          if $cg_version !~ /^5/ {
            fail('Parameter $cg_version must be 5 if $cdh_version is 5.')
          }
          class { 'cloudera::gplextras5::repo':
            ensure         => $ensure,
            reposerver     => $cg_reposerver,
            repopath       => $cg5_repopath,
            version        => $cg_version,
            proxy          => $proxy,
            proxy_username => $proxy_username,
            proxy_password => $proxy_password,
            require        => Anchor['cloudera::begin'],
            before         => Anchor['cloudera::end'],
          }
          class { 'cloudera::gplextras5':
            ensure      => $ensure,
            autoupgrade => $autoupgrade,
            require     => Anchor['cloudera::begin'],
            before      => Anchor['cloudera::end'],
          }
        }
      } elsif $cdh_version =~ /^4/ {
        class { 'cloudera::cdh::repo':
          ensure         => $ensure,
          reposerver     => $cdh_reposerver,
          repopath       => $cdh_repopath,
          version        => $cdh_version,
          proxy          => $proxy,
          proxy_username => $proxy_username,
          proxy_password => $proxy_password,
          require        => Anchor['cloudera::begin'],
          before         => Anchor['cloudera::end'],
        }
        class { 'cloudera::impala::repo':
          ensure         => $ensure,
          reposerver     => $ci_reposerver,
          repopath       => $ci_repopath,
          version        => $ci_version,
          proxy          => $proxy,
          proxy_username => $proxy_username,
          proxy_password => $proxy_password,
          require        => Anchor['cloudera::begin'],
          before         => Anchor['cloudera::end'],
        }
        class { 'cloudera::search::repo':
          ensure         => $ensure,
          reposerver     => $cs_reposerver,
          repopath       => $cs_repopath,
          version        => $cs_version,
          proxy          => $proxy,
          proxy_username => $proxy_username,
          proxy_password => $proxy_password,
          require        => Anchor['cloudera::begin'],
          before         => Anchor['cloudera::end'],
        }
        class { 'cloudera::cdh':
          ensure         => $ensure,
          autoupgrade    => $autoupgrade,
          service_ensure => $service_ensure,
#          service_enable => $service_enable,
          require        => Anchor['cloudera::begin'],
          before         => Anchor['cloudera::end'],
        }
        class { 'cloudera::impala':
          ensure         => $ensure,
          autoupgrade    => $autoupgrade,
          service_ensure => $service_ensure,
#          service_enable => $service_enable,
          require        => Anchor['cloudera::begin'],
          before         => Anchor['cloudera::end'],
        }
        class { 'cloudera::search':
          ensure         => $ensure,
          autoupgrade    => $autoupgrade,
          service_ensure => $service_ensure,
#          service_enable => $service_enable,
          require        => Anchor['cloudera::begin'],
          before         => Anchor['cloudera::end'],
        }
        if $install_lzo {
          if $cg_version !~ /^4/ {
            fail('Parameter $cg_version must be 4 if $cdh_version is 4.')
          }
          class { 'cloudera::gplextras::repo':
            ensure         => $ensure,
            reposerver     => $cg_reposerver,
            repopath       => $cg_repopath,
            version        => $cg_version,
            proxy          => $proxy,
            proxy_username => $proxy_username,
            proxy_password => $proxy_password,
            require        => Anchor['cloudera::begin'],
            before         => Anchor['cloudera::end'],
          }
          class { 'cloudera::gplextras':
            ensure      => $ensure,
            autoupgrade => $autoupgrade,
            require     => Anchor['cloudera::begin'],
            before      => Anchor['cloudera::end'],
          }
        }
      } else {
        fail('Parameter $cdh_version must start with either 4 or 5.')
      }
    }
  } elsif $cm_version =~ /^4/ {
    if $install_java {
      Class['cloudera::cm::repo'] -> Class['cloudera::java']
      class { 'cloudera::java':
        ensure      => $ensure,
        autoupgrade => $autoupgrade,
        require     => Anchor['cloudera::begin'],
        before      => Anchor['cloudera::end'],
      }
      if $install_jce {
        class { 'cloudera::java::jce':
          ensure  => $ensure,
          require => [ Anchor['cloudera::begin'], Class['cloudera::java'], ],
          before  => Anchor['cloudera::end'],
        }
      }
      $cloudera_cm_require = [ Anchor['cloudera::begin'], Class['cloudera::java'], ]
    } else {
      $cloudera_cm_require = Anchor['cloudera::begin']
    }
#    Package<|tag == 'jdk' and (tag == 'sun' or tag == 'oracle')|> -> Package<|tag == 'cloudera-manager'|>
#    Package<|tag == 'jdk' and (tag == 'sun' or tag == 'oracle')|> -> Package<|tag == 'cloudera-gplextras'|>
#    Package<|tag == 'jdk' and (tag == 'sun' or tag == 'oracle')|> -> Package<|tag == 'cloudera-search'|>
#    Package<|tag == 'jdk' and (tag == 'sun' or tag == 'oracle')|> -> Package<|tag == 'cloudera-cdh4'|>
#    Package<|tag == 'jdk' and (tag == 'sun' or tag == 'oracle')|> -> Package<|tag == 'cloudera-impala'|>

    class { 'cloudera::cm':
      ensure           => $ensure,
      autoupgrade      => $autoupgrade,
      service_ensure   => $service_ensure,
#      service_enable   => $service_enable,
      server_host      => $cm_server_host,
      server_port      => $cm_server_port,
      use_tls          => $use_tls,
      verify_cert_file => $verify_cert_file,
      require          => $cloudera_cm_require,
      parcel_dir       => $parcel_dir,
      before           => Anchor['cloudera::end'],
    }
    class { 'cloudera::cm::repo':
      ensure         => $ensure,
      reposerver     => $cm_reposerver,
      repopath       => $cm_repopath,
      version        => $cm_version,
      proxy          => $proxy,
      proxy_username => $proxy_username,
      proxy_password => $proxy_password,
      require        => Anchor['cloudera::begin'],
      before         => Anchor['cloudera::end'],
    }
    if $install_cmserver {
      class { 'cloudera::cm::server':
        ensure            => $ensure,
        autoupgrade       => $autoupgrade,
        service_ensure    => $service_ensure,
        database_name     => $database_name,
        username          => $username,
        password          => $password,
        db_host           => $db_host,
        db_port           => $db_port,
        db_user           => $db_user,
        db_pass           => $db_pass,
        db_type           => $db_type,
        use_tls           => $use_tls,
        server_ca_file    => $server_ca_file,
        server_cert_file  => $server_cert_file,
        server_key_file   => $server_key_file,
        server_chain_file => $server_chain_file,
        server_keypw      => $server_keypw,
        require           => $cloudera_cm_require,
        before            => Anchor['cloudera::end'],
      }
    }
    # Skip installing the CDH RPMs if we are going to use parcels.
    if ! $use_parcels {
      class { 'cloudera::cdh::repo':
        ensure         => $ensure,
        reposerver     => $cdh_reposerver,
        repopath       => $cdh_repopath,
        version        => $cdh_version,
        proxy          => $proxy,
        proxy_username => $proxy_username,
        proxy_password => $proxy_password,
        require        => Anchor['cloudera::begin'],
        before         => Anchor['cloudera::end'],
      }
      class { 'cloudera::impala::repo':
        ensure         => $ensure,
        reposerver     => $ci_reposerver,
        repopath       => $ci_repopath,
        version        => $ci_version,
        proxy          => $proxy,
        proxy_username => $proxy_username,
        proxy_password => $proxy_password,
        require        => Anchor['cloudera::begin'],
        before         => Anchor['cloudera::end'],
      }
      class { 'cloudera::search::repo':
        ensure         => $ensure,
        reposerver     => $cs_reposerver,
        repopath       => $cs_repopath,
        version        => $cs_version,
        proxy          => $proxy,
        proxy_username => $proxy_username,
        proxy_password => $proxy_password,
        require        => Anchor['cloudera::begin'],
        before         => Anchor['cloudera::end'],
      }
      class { 'cloudera::cdh':
        ensure         => $ensure,
        autoupgrade    => $autoupgrade,
        service_ensure => $service_ensure,
#        service_enable => $service_enable,
        require        => Anchor['cloudera::begin'],
        before         => Anchor['cloudera::end'],
      }
      class { 'cloudera::impala':
        ensure         => $ensure,
        autoupgrade    => $autoupgrade,
        service_ensure => $service_ensure,
#        service_enable => $service_enable,
        require        => Anchor['cloudera::begin'],
        before         => Anchor['cloudera::end'],
      }
      class { 'cloudera::search':
        ensure         => $ensure,
        autoupgrade    => $autoupgrade,
        service_ensure => $service_ensure,
#        service_enable => $service_enable,
        require        => Anchor['cloudera::begin'],
        before         => Anchor['cloudera::end'],
      }
      if $install_lzo {
        if $cg_version !~ /^4/ {
          fail('Parameter $cg_version must be 4 if $cdh_version is 4.')
        }
        class { 'cloudera::gplextras::repo':
          ensure         => $ensure,
          reposerver     => $cg_reposerver,
          repopath       => $cg_repopath,
          version        => $cg_version,
          proxy          => $proxy,
          proxy_username => $proxy_username,
          proxy_password => $proxy_password,
          require        => Anchor['cloudera::begin'],
          before         => Anchor['cloudera::end'],
        }
        class { 'cloudera::gplextras':
          ensure      => $ensure,
          autoupgrade => $autoupgrade,
          require     => Anchor['cloudera::begin'],
          before      => Anchor['cloudera::end'],
        }
      }
    }
  } else {
    fail('Parameter $cm_version must start with either 4 or 5.')
  }
}
