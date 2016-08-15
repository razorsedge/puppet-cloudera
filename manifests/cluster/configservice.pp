# == Class: cloudera::cluster::configservice
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
#   cloudera::cluster::configservice{'HBASE':
#     cm_api_host => $cloudera::params::cm_api_host,
#     cm_api_port => $cloudera::params::cm_api_port
#   }
#
# === Authors:
#
#
# === Copyright:
#
#

define cloudera::cluster::configservice (
  $cdh_cluster_name  = $cloudera::params::cdh_cluster_name,
  $cm_api_host       = $cloudera::params::cm_api_host,
  $cm_api_port       = $cloudera::params::cm_api_port,
  $cm_api_user       = $cloudera::params::cm_api_user,
  $cm_api_password   = $cloudera::params::cm_api_password,
  $hadoop_service_config = $title,
  $cdh_service_config = $cloudera::params::cdh_service_config
) {

  file { "$hadoop_service_config-config.json":
    ensure  => $file_ensure,
    path    => "/tmp/$hadoop_service_config-config.json",
    content => template("${module_name}/service-config.json.erb")
  }

  exec { "add config for service $hadoop_service_config":
    command => "/usr/bin/curl -H 'Content-Type: application/json' -u $cloudera::params::cm_api_user:$cloudera::params::cm_api_password -XPUT \"http://$cm_api_host:$cm_api_port/api/v1/clusters/$cdh_cluster_name/services/$hadoop_service_config/config\" -d @$hadoop_service_config-config.json > /tmp/log 2>&1 && touch /var/tmp/$hadoop_service_config-config.lock",
    cwd     => "/tmp",
    creates => "/var/tmp/$hadoop_service_config-config.lock",
    require => File["$hadoop_service_config-config.json"],
    tries   => 3,
    try_sleep => 60
  }

}
