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
  $cdh_cluster_name  = $cloudera::params::cdh_cluster_name,
  $cm_api_host       = $cloudera::params::cm_api_host,
  $cm_api_port       = $cloudera::params::cm_api_port,
  $cm_api_user       = $cloudera::params::cm_api_user,
  $cm_api_password   = $cloudera::params::cm_api_password,
  $hadoop_service_name = $title
) {

  file { "$hadoop_service_name.json":
    ensure  => $file_ensure,
    path    => "/tmp/$hadoop_service_name.json",
    content => template("${module_name}/service.json.erb")
  }

  exec { "add service $hadoop_service_name":
    command => "/usr/bin/curl -H 'Content-Type: application/json' -u $cloudera::params::cm_api_user:$cloudera::params::cm_api_password -XPOST \"http://$cm_api_host:$cm_api_port/api/v1/clusters/$cdh_cluster_name/services\" -d @$hadoop_service_name.json && touch /var/tmp/$hadoop_service_name.lock",
    cwd     => "/tmp",
    creates => "/var/tmp/$hadoop_service_name.lock",
    require => File["$hadoop_service_name.json"]
  }

  file { "$hadoop_service_name-roles.json":
    ensure  => $file_ensure,
    path    => "/tmp/$hadoop_service_name-roles.json",
    content => template("${module_name}/$hadoop_service_name-roles.json.erb")
  }

  exec { "add role for service $hadoop_service_name":
    command => "/usr/bin/curl -H 'Content-Type: application/json' -u $cloudera::params::cm_api_user:$cloudera::params::cm_api_password -XPOST \"http://$cm_api_host:$cm_api_port/api/v1/clusters/$cdh_cluster_name/services/$hadoop_service_name/roles\" -d @$hadoop_service_name-roles.json && touch /var/tmp/$hadoop_service_name-roles.lock",
    cwd     => "/tmp",
    creates => "/var/tmp/$hadoop_service_name-roles.lock",
    require => [File["$hadoop_service_name-roles.json"],Exec["add service $hadoop_service_name"]]
  }
}