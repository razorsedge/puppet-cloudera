# == Class: cloudera::cdh5
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
#   class { 'cloudera::cdh5': }
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
class cloudera::cdh5 (
  $ensure         = $cloudera::params::ensure,
  $autoupgrade    = $cloudera::params::safe_autoupgrade,
  $service_ensure = $cloudera::params::service_ensure
) inherits cloudera::params {
  # Validate our booleans
  validate_bool($autoupgrade)

  anchor { 'cloudera::cdh5::begin': }
  anchor { 'cloudera::cdh5::end': }

  class { 'cloudera::cdh5::bigtop':
#    ensure      => $ensure,
#    autoupgrade => $autoupgrade,
    require => Anchor['cloudera::cdh5::begin'],
    before  => Anchor['cloudera::cdh5::end'],
  }
  class { 'cloudera::cdh5::hadoop':
#    ensure      => $ensure,
#    autoupgrade => $autoupgrade,
    require => Anchor['cloudera::cdh5::begin'],
    before  => Anchor['cloudera::cdh5::end'],
  }
  class { 'cloudera::cdh5::hue':
#    ensure      => $ensure,
#    autoupgrade => $autoupgrade,
    require => Anchor['cloudera::cdh5::begin'],
    before  => Anchor['cloudera::cdh5::end'],
  }
  class { 'cloudera::cdh5::hue::plugins':
#    ensure      => $ensure,
#    autoupgrade => $autoupgrade,
    require => Anchor['cloudera::cdh5::begin'],
    before  => Anchor['cloudera::cdh5::end'],
  }
  class { 'cloudera::cdh5::hbase':
#    ensure      => $ensure,
#    autoupgrade => $autoupgrade,
    require => Anchor['cloudera::cdh5::begin'],
    before  => Anchor['cloudera::cdh5::end'],
  }
  class { 'cloudera::cdh5::hive':
#    ensure      => $ensure,
#    autoupgrade => $autoupgrade,
    require => Anchor['cloudera::cdh5::begin'],
    before  => Anchor['cloudera::cdh5::end'],
  }
  class { 'cloudera::cdh5::oozie':
#    ensure         => $ensure,
#    autoupgrade    => $autoupgrade,
#    service_ensure => $service_ensure,
    require => Anchor['cloudera::cdh5::begin'],
    before  => Anchor['cloudera::cdh5::end'],
  }
  class { 'cloudera::cdh5::pig':
#    ensure      => $ensure,
#    autoupgrade => $autoupgrade,
    require => Anchor['cloudera::cdh5::begin'],
    before  => Anchor['cloudera::cdh5::end'],
  }
  class { 'cloudera::cdh5::zookeeper':
#    ensure      => $ensure,
#    autoupgrade => $autoupgrade,
    require => Anchor['cloudera::cdh5::begin'],
    before  => Anchor['cloudera::cdh5::end'],
  }
  class { 'cloudera::cdh5::flume':
#    ensure      => $ensure,
#    autoupgrade => $autoupgrade,
    require => Anchor['cloudera::cdh5::begin'],
    before  => Anchor['cloudera::cdh5::end'],
  }
  class { 'cloudera::cdh5::impala':
#    ensure      => $ensure,
#    autoupgrade => $autoupgrade,
    require => Anchor['cloudera::cdh5::begin'],
    before  => Anchor['cloudera::cdh5::end'],
  }
  class { 'cloudera::cdh5::search':
#    ensure      => $ensure,
#    autoupgrade => $autoupgrade,
    require => Anchor['cloudera::cdh5::begin'],
    before  => Anchor['cloudera::cdh5::end'],
  }
  class { 'cloudera::cdh5::search::lilyhbase':
#    ensure      => $ensure,
#    autoupgrade => $autoupgrade,
    require => Anchor['cloudera::cdh5::begin'],
    before  => Anchor['cloudera::cdh5::end'],
  }
  class { 'cloudera::cdh5::crunch':
#    ensure      => $ensure,
#    autoupgrade => $autoupgrade,
    require => Anchor['cloudera::cdh5::begin'],
    before  => Anchor['cloudera::cdh5::end'],
  }
  class { 'cloudera::cdh5::hcatalog':
#    ensure      => $ensure,
#    autoupgrade => $autoupgrade,
    require => Anchor['cloudera::cdh5::begin'],
    before  => Anchor['cloudera::cdh5::end'],
  }
  class { 'cloudera::cdh5::llama':
#    ensure      => $ensure,
#    autoupgrade => $autoupgrade,
    require => Anchor['cloudera::cdh5::begin'],
    before  => Anchor['cloudera::cdh5::end'],
  }
  class { 'cloudera::cdh5::sqoop':
#    ensure      => $ensure,
#    autoupgrade => $autoupgrade,
    require => Anchor['cloudera::cdh5::begin'],
    before  => Anchor['cloudera::cdh5::end'],
  }
  class { 'cloudera::cdh5::sqoop2':
#    ensure      => $ensure,
#    autoupgrade => $autoupgrade,
    require => Anchor['cloudera::cdh5::begin'],
    before  => Anchor['cloudera::cdh5::end'],
  }
  class { 'cloudera::cdh5::spark':
#    ensure      => $ensure,
#    autoupgrade => $autoupgrade,
    require => Anchor['cloudera::cdh5::begin'],
    before  => Anchor['cloudera::cdh5::end'],
  }
}
