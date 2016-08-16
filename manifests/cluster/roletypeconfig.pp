# == Class: cloudera::cluster::roletypeconfig
#
# This class handles installing and configuring the Cloudera Manager Server.
#
# === Parameters:
#
# [*ensure*]
#   Ensure if present or absent.
#   Default: present
#
# === Actions:
#
#
# === Requires:
#
# === Sample Usage:
#
#   cloudera::cluster::roletypeconfig{'HDFS':
#     cm_api_host => $cloudera::params::cm_api_host,
#     cm_api_port => $cloudera::params::cm_api_port,
#     cdh_service_roletype => $cloudera::params::cdh_service_roletype
#   }
#
# === Authors:
#
#
# === Copyright:
#
#

define cloudera::cluster::roletypeconfig (
  $cdh_cluster_name  = $cloudera::params::cdh_cluster_name,
  $cm_api_host       = $cloudera::params::cm_api_host,
  $cm_api_port       = $cloudera::params::cm_api_port,
  $cm_api_user       = $cloudera::params::cm_api_user,
  $cm_api_password   = $cloudera::params::cm_api_password,
  $cdh_service_config = $title,
  $cdh_service_roletype = $cloudera::params::cdh_service_roletype
) {

  file { "$cdh_service_config-roletype.json":
    ensure  => $file_ensure,
    path    => "/tmp/$cdh_service_config-config-roletype.json",
    content => template("${module_name}/service-roletype-config.json.erb")
  }

  exec { "add config for service $cdh_service_config":
    command => "/usr/bin/curl -H 'Content-Type: application/json' -u $cloudera::params::cm_api_user:$cloudera::params::cm_api_password -XPUT \"http://$cm_api_host:$cm_api_port/api/v1/clusters/$cdh_cluster_name/services/$cdh_service_config/config\" -d @$cdh_service_config-config-roletype.json > /tmp/log 2>&1 && touch /var/tmp/$cdh_service_config-config-roletype.lock",
    cwd     => "/tmp",
    creates => "/var/tmp/$cdh_service_config-config-roletype.lock",
    require => File["$cdh_service_config-config-roletype.json"],
    tries   => 3,
    try_sleep => 60
  }

}
