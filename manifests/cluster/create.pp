# == Class: cloudera::cluster::create
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
#
# === Sample Usage:
#
#
# === Authors:
#
#
# === Copyright:
#
#
class cloudera::cluster::create (
  $file_ensure       = $cloudera::params::file_ensure,
  $cdh_cluster_name  = $cloudera::params::cdh_cluster_name,
  $cm_api_host       = $cloudera::params::cm_api_host,
  $cm_api_port       = $cloudera::params::cm_api_port,
  $cm_api_user       = $cloudera::params::cm_api_user,
  $cm_api_password   = $cloudera::params::cm_api_password
) inherits cloudera::params {

  file { 'cluster.json':
    ensure  => $file_ensure,
    path    => '/tmp/cluster.json',
    content => template("${module_name}/cluster.json.erb"),
    require => Package['cloudera-manager-server']
  }

  exec { 'create_cluster':
    command => "/usr/bin/curl -H 'Content-Type: application/json' -u $cloudera::params::cm_api_user:$cloudera::params::cm_api_password -XPOST \"http://$cm_api_host:$cm_api_port/api/v1/clusters\" -d @cluster.json && touch /var/tmp/cluster_created.lock",
    cwd     => "/tmp",
    creates => '/var/tmp/cluster_created.lock',
    require => File['cluster.json'],
    tries   => 3,
    try_sleep => 60
  }

}
