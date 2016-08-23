#!/usr/bin/env rspec

require 'spec_helper'

describe 'cloudera::cdh', :type => 'class' do

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
    it { should contain_class('cloudera::cdh::bigtop') }
    it { should contain_class('cloudera::cdh::hadoop') }
#    it { should contain_class('cloudera::cdh::hue') }
    it { should contain_class('cloudera::cdh::hue::plugins') }
    it { should contain_class('cloudera::cdh::hbase') }
    it { should contain_class('cloudera::cdh::hive') }
    it { should contain_class('cloudera::cdh::oozie') }
    it { should contain_class('cloudera::cdh::pig') }
    it { should contain_class('cloudera::cdh::zookeeper') }
    it { should contain_class('cloudera::cdh::flume') }
    it { should_not contain_class('cloudera::impala') }
  end

end
