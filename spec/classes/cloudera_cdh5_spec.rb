#!/usr/bin/env rspec

require 'spec_helper'

describe 'cloudera::cdh5', :type => 'class' do

  context 'on a non-supported operatingsystem' do
    let :facts do {
      :osfamily        => 'foo',
      :operatingsystem => 'bar'
    }
    end
    it 'should fail' do
      expect {
        should raise_error(Puppet::Error, /Module cloudera is not supported on bar/)
      }
    end
  end

  context 'on a supported operatingsystem, default parameters' do
    let(:params) {{}}
    let :facts do {
      :osfamily               => 'RedHat',
      :operatingsystem        => 'CentOS',
      :operatingsystemrelease => '6.0'
    }
    end
    it { should contain_class('cloudera::cdh5::bigtop') }
    it { should contain_class('cloudera::cdh5::hadoop') }
    it { should contain_class('cloudera::cdh5::hue') }
    it { should contain_class('cloudera::cdh5::hue::plugins') }
    it { should contain_class('cloudera::cdh5::hbase') }
    it { should contain_class('cloudera::cdh5::hive') }
    it { should contain_class('cloudera::cdh5::oozie') }
    it { should contain_class('cloudera::cdh5::pig') }
    it { should contain_class('cloudera::cdh5::zookeeper') }
    it { should contain_class('cloudera::cdh5::flume') }
    it { should contain_class('cloudera::cdh5::impala') }
    it { should contain_class('cloudera::cdh5::search') }
    it { should contain_class('cloudera::cdh5::search::lilyhbase') }
    it { should contain_class('cloudera::cdh5::crunch') }
    it { should contain_class('cloudera::cdh5::hcatalog') }
    it { should contain_class('cloudera::cdh5::llama') }
    it { should contain_class('cloudera::cdh5::sqoop') }
    it { should contain_class('cloudera::cdh5::sqoop2') }
  end

end
