#!/bin/bash
Facter.add('zookeeper_id') do
  setcode do
    Facter::Core::Execution.exec("grep name /var/tmp/.clouderacluster/ZOOKEEPER-roles.json.output | awk '{ print $3 }' | sed -e 's/\"//g' -e 's/,//g'")
  end
end
