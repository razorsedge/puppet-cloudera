# == Class: cloudera::cluster
class cloudera::cluster (
  $ensure           = $cloudera::params::ensure,
  $service_ensure   = $cloudera::params::service_ensure,
  $service_enable   = $cloudera::params::safe_service_enable,
  $cdh_cluster_name = $cloudera::params::cdh_cluster_name,
  $cm_api_host      = $cloudera::params::cm_api_host,
  $cm_api_port      = $cloudera::params::cm_api_port
) inherits cloudera::params {
}
