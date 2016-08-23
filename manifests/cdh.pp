# == Class: cloudera::cdh
#
# This class handles installing the Cloudera Distribution, including Apache
# Hadoop.
#
# === Parameters:
#
# [*ensure*]
#   Ensure if present or absent.
#   Default: present
#
# [*autoupgrade*]
#   Upgrade package automatically, if there is a newer version.
#   Default: false
#
# [*service_ensure*]
#   Ensure if service is running or stopped.
#   Default: running
#
# === Actions:
#
# Installs Bigtop, Hadoop, Hue-plugins, HBase, Hive, Oozie, Pig, ZooKeeper,
# and Flume-NG.
#
# === Requires:
#
# Nothing.
#
# === Sample Usage:
#
#   class { 'cloudera::cdh': }
#
# === Authors:
#
# Mike Arnold <mike@razorsedge.org>
#
# === Copyright:
#
# Copyright (C) 2013 Mike Arnold, unless otherwise noted.
#  Copyright (c) 2011, Cloudera, Inc. All Rights Reserved.
#
#  Cloudera, Inc. licenses this file to you under the Apache License,
#  Version 2.0 (the "License"). You may not use this file except in
#  compliance with the License. You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  This software is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
#  CONDITIONS OF ANY KIND, either express or implied. See the License for
#  the specific language governing permissions and limitations under the
#  License.
#
class cloudera::cdh (
  $ensure         = $cloudera::params::ensure,
  $autoupgrade    = $cloudera::params::safe_autoupgrade,
  $service_ensure = $cloudera::params::service_ensure
) inherits cloudera::params {
  # Validate our booleans
  validate_bool($autoupgrade)

  anchor { 'cloudera::cdh::begin': }
  anchor { 'cloudera::cdh::end': }

  class { 'cloudera::cdh::bigtop':
#    ensure      => $ensure,
#    autoupgrade => $autoupgrade,
    require => Anchor['cloudera::cdh::begin'],
    before  => Anchor['cloudera::cdh::end'],
  }
  class { 'cloudera::cdh::hadoop':
#    ensure      => $ensure,
#    autoupgrade => $autoupgrade,
    require => Anchor['cloudera::cdh::begin'],
    before  => Anchor['cloudera::cdh::end'],
  }
#  class { 'cloudera::cdh::hue':
##    ensure      => $ensure,
##    autoupgrade => $autoupgrade,
#    require => Anchor['cloudera::cdh::begin'],
#    before  => Anchor['cloudera::cdh::end'],
#  }
  class { 'cloudera::cdh::hue::plugins':
#    ensure      => $ensure,
#    autoupgrade => $autoupgrade,
    require => Anchor['cloudera::cdh::begin'],
    before  => Anchor['cloudera::cdh::end'],
  }
  class { 'cloudera::cdh::hbase':
#    ensure      => $ensure,
#    autoupgrade => $autoupgrade,
    require => Anchor['cloudera::cdh::begin'],
    before  => Anchor['cloudera::cdh::end'],
  }
  class { 'cloudera::cdh::hive':
#    ensure      => $ensure,
#    autoupgrade => $autoupgrade,
    require => Anchor['cloudera::cdh::begin'],
    before  => Anchor['cloudera::cdh::end'],
  }
  class { 'cloudera::cdh::oozie':
#    ensure         => $ensure,
#    autoupgrade    => $autoupgrade,
#    service_ensure => $service_ensure,
    require => Anchor['cloudera::cdh::begin'],
    before  => Anchor['cloudera::cdh::end'],
  }
  class { 'cloudera::cdh::pig':
#    ensure      => $ensure,
#    autoupgrade => $autoupgrade,
    require => Anchor['cloudera::cdh::begin'],
    before  => Anchor['cloudera::cdh::end'],
  }
  class { 'cloudera::cdh::zookeeper':
#    ensure      => $ensure,
#    autoupgrade => $autoupgrade,
    require => Anchor['cloudera::cdh::begin'],
    before  => Anchor['cloudera::cdh::end'],
  }
  class { 'cloudera::cdh::flume':
#    ensure      => $ensure,
#    autoupgrade => $autoupgrade,
    require => Anchor['cloudera::cdh::begin'],
    before  => Anchor['cloudera::cdh::end'],
  }
}
