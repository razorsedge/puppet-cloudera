# == Class: cloudera::cluster::addcmrole
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
#   cloudera::cluster::addcmrole{'HBASE':
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

define cloudera::cluster::addcmrole (
  $cdh_cluster_name  = $cloudera::params::cdh_cluster_name,
  $cm_api_host       = $cloudera::params::cm_api_host,
  $cm_api_port       = $cloudera::params::cm_api_port,
  $cm_api_user       = $cloudera::params::cm_api_user,
  $cm_api_password   = $cloudera::params::cm_api_password,
  $cdh_service_roles = $cloudera::params::cdh_service_roles
) {

  exec { "add CM MGMT":
    command => "/usr/bin/curl -H 'Content-Type: application/json' -u $cloudera::params::cm_api_user:$cloudera::params::cm_api_password -XPUT \"http://$cm_api_host:$cm_api_port/api/v1/cm/service\" -d '{}' && touch /var/tmp/CM-MGMT.lock",
    cwd     => "/tmp",
    creates => "/var/tmp/CM-MGMT.lock",
    tries   => 3,
    try_sleep => 60
  }

  file { "CM-roles.json":
    ensure  => $file_ensure,
    path    => "/tmp/CM-roles.json",
    content => template("${module_name}/roles.json.erb")
  }

  exec { "add role for CM":
    command => "/usr/bin/curl -H 'Content-Type: application/json' -u $cloudera::params::cm_api_user:$cloudera::params::cm_api_password -XPOST \"http://$cm_api_host:$cm_api_port/api/v1/cm/service/roles\" -d @CM-roles.json && touch /var/tmp/CM-roles.lock",
    cwd     => "/tmp",
    creates => "/var/tmp/CM-roles.lock",
    require => [File["CM-roles.json"],Exec["add CM MGMT"]],
    tries   => 3,
    try_sleep => 60
  }
}
