# == Class: cloudera::cluster::startservice
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
#   cloudera::cluster::startservice{'HBASE':
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

define cloudera::cluster::startservice (
  $cdh_metadata_dir  = $cloudera::params::cdh_metadata_dir,
  $cdh_cluster_name  = $cloudera::params::cdh_cluster_name,
  $cm_api_host       = $cloudera::params::cm_api_host,
  $cm_api_port       = $cloudera::params::cm_api_port,
  $cm_api_user       = $cloudera::params::cm_api_user,
  $cm_api_password   = $cloudera::params::cm_api_password,
  $cdh_cluster_service = $title,
) {

  exec { "start service $cdh_cluster_service":
    command => "/usr/bin/curl -H 'Content-Type: application/json' -u $cloudera::params::cm_api_user:$cloudera::params::cm_api_password -XPOST \"http://$cm_api_host:$cm_api_port/api/v13/clusters/$cdh_cluster_name/services/$cdh_cluster_service/commands/firstRun\" > $cdh_metadata_dir/$cdh_cluster_service-started.lock",
    cwd     => "/tmp",
    creates => "$cdh_metadata_dir/$cdh_cluster_service-started.lock",
    tries   => 3,
    try_sleep => 60
  }

}
