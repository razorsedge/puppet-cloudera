#!/usr/bin/env rspec

require 'spec_helper'

describe 'cloudera::cdh5::hive::mysql', :type => 'class' do

#  context 'on a non-supported operatingsystem' do
#    let :facts do {
#      :osfamily        => 'foo',
#      :operatingsystem => 'bar'
#    }
#    end
#    it 'should fail' do
#      expect {
#        should raise_error(Puppet::Error, /Module cloudera is not supported on bar/)
#      }
#    end
#  end

  context 'on a supported operatingsystem, default parameters' do
    let(:pre_condition) { 'class {"mysql::server":}' }
    let(:params) {{ :password => 'myPass' }}
    let :facts do {
      :osfamily               => 'RedHat',
      :operatingsystem        => 'CentOS',
      :operatingsystemrelease => '6.0'
    }
    end
    it { should contain_class('mysql::bindings') }
    it { should contain_class('mysql::bindings::java') }
    it { should contain_file('/usr/lib/hive/lib/mysql-connector-java.jar').with(
      :ensure => 'link',
      :target => '/usr/share/java/mysql-connector-java.jar'
    )}
    it { should contain_mysql__db('metastore_db').with(
      :user     => 'hive',
      :password => 'myPass',
      :host     => '%',
      :grant    => [ 'select_priv', 'insert_priv', 'update_priv', 'delete_priv' ],
      :sql      => '/usr/lib/hive/scripts/metastore/upgrade/mysql/hive-schema-0.9.0.mysql.sql'
    )}
  end
end
