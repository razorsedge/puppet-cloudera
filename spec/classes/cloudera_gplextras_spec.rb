#!/usr/bin/env rspec

require 'spec_helper'

describe 'cloudera::gplextras', :type => 'class' do

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
    context 'CentOS 5.10' do
      let(:pre_condition) { 'class {"epel":}' }
      let(:params) {{}}
      let :facts do {
        :osfamily               => 'RedHat',
        :operatingsystem        => 'CentOS',
        :operatingsystemrelease => '5.10'
      }
      end
      it { should contain_class('epel') }
      it { should contain_package('hadoop-lzo-cdh4').with_ensure('present') }
      it { should contain_package('hadoop-lzo-cdh4-mr1').with_ensure('present') }
      it { should contain_package('impala-lzo').with_ensure('present') }
    end

    context 'OracleLinux 6.5' do
      let(:params) {{}}
      let :facts do {
        :osfamily               => 'RedHat',
        :operatingsystem        => 'OracleLinux',
        :operatingsystemrelease => '6.5'
      }
      end
      it { should_not contain_class('epel') }
      it { should contain_package('hadoop-lzo-cdh4').with_ensure('present') }
      it { should contain_package('hadoop-lzo-cdh4-mr1').with_ensure('present') }
      it { should contain_package('impala-lzo').with_ensure('present') }
    end

    context 'Ubuntu 10.04.4' do
      let(:params) {{}}
      let :facts do {
        :osfamily               => 'Debian',
        :operatingsystem        => 'Ubuntu',
        :operatingsystemrelease => '10.04.4'
      }
      end
      it { should_not contain_class('epel') }
      it { should contain_package('hadoop-lzo-cdh4').with_ensure('present') }
      it { should contain_package('hadoop-lzo-cdh4-mr1').with_ensure('present') }
      it { should contain_package('impala-lzo').with_ensure('present') }
    end

  end
end
