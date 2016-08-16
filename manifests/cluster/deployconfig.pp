# == Class: cloudera::cluster::deployconfig
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
#   cloudera::cluster::deployconfig{'HBASE':
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

define cloudera::cluster::deployconfig (
  $cdh_cluster_name  = $cloudera::params::cdh_cluster_name,
  $cdh_role_name     = $title,
  $cm_api_host       = $cloudera::params::cm_api_host,
  $cm_api_port       = $cloudera::params::cm_api_port,
  $cm_api_user       = $cloudera::params::cm_api_user,
  $cm_api_password   = $cloudera::params::cm_api_password,
  $hadoop_service_deploy_config = $hadoop_service_deploy_config
) {

  exec { "deploy config service $cdh_role_name":
    command => "/usr/bin/curl -H 'Content-Type: application/json' -u $cloudera::params::cm_api_user:$cloudera::params::cm_api_password -XPOST \"http://$cm_api_host:$cm_api_port/api/v1/clusters/$cdh_cluster_name/services/$hadoop_service_deploy_config/commands/deployClientConfig\" -d '{ \"items\": [\"$cdh_role_name\"] }' && touch /var/tmp/$cdh_role_name-client-configured.lock",
    cwd     => "/tmp",
    creates => "/var/tmp/$cdh_role_name-client-configured.lock",
    tries   => 3,
    try_sleep => 60
  }

}
