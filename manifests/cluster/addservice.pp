# == Class: cloudera::cluster::addservice
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
#   cloudera::cluster::addservice{'HBASE':
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

define cloudera::cluster::addservice (
  $cdh_metadata_dir  = $cloudera::params::cdh_metadata_dir,
  $cdh_cluster_name  = $cloudera::params::cdh_cluster_name,
  $cm_api_host       = $cloudera::params::cm_api_host,
  $cm_api_port       = $cloudera::params::cm_api_port,
  $cm_api_user       = $cloudera::params::cm_api_user,
  $cm_api_password   = $cloudera::params::cm_api_password,
  $hadoop_service_name = $title,
  $cdh_service_roles = $cloudera::params::cdh_service_roles
) {

  file { "$hadoop_service_name.json":
    ensure  => $file_ensure,
    path    => "/tmp/$hadoop_service_name.json",
    content => template("${module_name}/service.json.erb")
  }

  exec { "add service $hadoop_service_name":
    command => "/usr/bin/curl -H 'Content-Type: application/json' -u $cloudera::params::cm_api_user:$cloudera::params::cm_api_password -XPOST \"http://$cm_api_host:$cm_api_port/api/v1/clusters/$cdh_cluster_name/services\" -d @$hadoop_service_name.json > $cdh_metadata_dir/$hadoop_service_name.json.output",
    cwd     => "/tmp",
    creates => "$cdh_metadata_dir/$hadoop_service_name.json.output",
    require => File["$hadoop_service_name.json"],
    tries   => 3,
    try_sleep => 60
  }

  file { "$hadoop_service_name-roles.json":
    ensure  => $file_ensure,
    path    => "/tmp/$hadoop_service_name-roles.json",
    content => template("${module_name}/roles.json.erb")
  }

  exec { "add role for service $hadoop_service_name":
    command => "/usr/bin/curl -H 'Content-Type: application/json' -u $cloudera::params::cm_api_user:$cloudera::params::cm_api_password -XPOST \"http://$cm_api_host:$cm_api_port/api/v1/clusters/$cdh_cluster_name/services/$hadoop_service_name/roles\" -d @$hadoop_service_name-roles.json > $cdh_metadata_dir/$hadoop_service_name-roles.json.output",
    cwd     => "/tmp",
    creates => "$cdh_metadata_dir/$hadoop_service_name-roles.json.output",
    require => [File["$hadoop_service_name-roles.json"],Exec["add service $hadoop_service_name"]],
    tries   => 3,
    try_sleep => 60
  }
}
