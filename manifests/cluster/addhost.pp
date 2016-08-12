# == Class: cloudera::cluster::addhost
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
#  class { '::cloudera::cluster::addhost': }
#
# === Authors:
#
#
# === Copyright:
#
#

class cloudera::cluster::addhost (
  $cdh_cluster_name  = $cloudera::params::cdh_cluster_name,
  $cm_api_host       = $cloudera::params::cm_api_host,
  $cm_api_port       = $cloudera::params::cm_api_port,
  $cm_api_user       = $cloudera::params::cm_api_user,
  $cm_api_password   = $cloudera::params::cm_api_password
) inherits cloudera::params {

  file { 'host.json':
    ensure  => $file_ensure,
    path    => '/tmp/host.json',
    content => template("${module_name}/host.json.erb")
  }

  exec { 'add_host':
    command => "/usr/bin/curl -H 'Content-Type: application/json' -u $cloudera::params::cm_api_user:$cloudera::params::cm_api_password -XPOST \"http://$cm_api_host:$cm_api_port/api/v13/clusters/$cdh_cluster_name/hosts\" -d @host.json && touch /var/tmp/host_added.lock",
    cwd     => "/tmp",
    creates => '/var/tmp/host_added.lock',
    require => File['host.json'],
    tries   => 3,
    try_sleep => 60
  }

}
