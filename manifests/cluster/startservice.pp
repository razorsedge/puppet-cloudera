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
  $cdh_cluster_name  = $cloudera::params::cdh_cluster_name,
  $cm_api_host       = $cloudera::params::cm_api_host,
  $cm_api_port       = $cloudera::params::cm_api_port,
  $cm_api_user       = $cloudera::params::cm_api_user,
  $cm_api_password   = $cloudera::params::cm_api_password,
  $hadoop_service_start = $title,
) {

  exec { "start service $hadoop_service_start":
    command => "/usr/bin/curl -H 'Content-Type: application/json' -u $cloudera::params::cm_api_user:$cloudera::params::cm_api_password -XPOST \"http://$cm_api_host:$cm_api_port/api/v1/clusters/$cdh_cluster_name/services/$hadoop_service_start/command/start\" && touch /var/tmp/$hadoop_service_start-started.lock",
    cwd     => "/tmp",
    creates => "/var/tmp/$hadoop_service_start-started.lock",
    tries   => 3,
    try_sleep => 60
  }

}
