#!/usr/bin/env rspec

require 'spec_helper'

describe 'cloudera::lzo', :type => 'class' do

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
      it { should contain_package('lzo').with_ensure('present').with_name('lzo') }
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
      it { should contain_package('lzo').with_ensure('present').with_name('lzo') }
    end

    context 'Ubuntu 10.04' do
      let(:params) {{}}
      let :facts do {
        :osfamily               => 'Debian',
        :operatingsystem        => 'Ubuntu',
        :operatingsystemrelease => '10.04'
      }
      end
      it { should_not contain_class('epel') }
      it { should contain_package('lzo').with_ensure('present').with_name('liblzo2-2') }
    end

    context 'Debian 6.0.7' do
      let(:params) {{}}
      let :facts do {
        :osfamily               => 'Debian',
        :operatingsystem        => 'Debian',
        :operatingsystemrelease => '6.0.7'
      }
      end
      it { should_not contain_class('epel') }
      it { should contain_package('lzo').with_ensure('present').with_name('liblzo2-2') }
    end

    context 'SLES 11SP1' do
      let(:params) {{}}
      let :facts do {
        :osfamily               => 'Suse',
        :operatingsystem        => 'SLES',
        :operatingsystemrelease => '11.1'
      }
      end
      it { should_not contain_class('epel') }
      it { should contain_package('lzo').with_ensure('present').with_name('liblzo2-2') }
    end

  end
end
