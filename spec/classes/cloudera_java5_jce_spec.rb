#!/usr/bin/env rspec

require 'spec_helper'

describe 'cloudera::java5::jce', :type => 'class' do

  context 'on a non-supported operatingsystem' do
    let :facts do {
      :osfamily        => 'foo',
      :operatingsystem => 'bar'
    }
    end
    it do
      expect {
        should raise_error(Puppet::Error, /Module cloudera is not supported on bar/)
      }
    end
  end

  context 'on a supported operatingsystem, default parameters' do
    let(:pre_condition) { 'class {"cloudera::java5":}' }
    let :facts do {
      :osfamily               => 'RedHat',
      :operatingsystem        => 'CentOS',
      :operatingsystemrelease => '6.0'
    }
    end
    it { should compile.with_all_deps }
    it { should contain_file('/usr/java/default/jre/lib/security/README.txt').with(
      :ensure  => 'present',
      :source  => 'puppet:///modules/cloudera/UnlimitedJCEPolicy/README.txt',
      :mode    => '0644',
      :owner   => 'root',
      :group   => 'root',
      :require => 'Class[Cloudera::Java5]'
    )}
    it { should contain_file('/usr/java/default/jre/lib/security/local_policy.jar').with(
      :ensure  => 'present',
      :source  => 'puppet:///modules/cloudera/UnlimitedJCEPolicy/local_policy.jar',
      :mode    => '0644',
      :owner   => 'root',
      :group   => 'root',
      :require => 'Class[Cloudera::Java5]'
    )}
    it { should contain_file('/usr/java/default/jre/lib/security/US_export_policy.jar').with(
      :ensure  => 'present',
      :source  => 'puppet:///modules/cloudera/UnlimitedJCEPolicy/US_export_policy.jar',
      :mode    => '0644',
      :owner   => 'root',
      :group   => 'root',
      :require => 'Class[Cloudera::Java5]'
    )}
  end

  context 'on a supported operatingsystem, custom parameters' do
    let :facts do {
      :osfamily               => 'RedHat',
      :operatingsystem        => 'OracleLinux',
      :operatingsystemrelease => '6.0'
    }
    end

    describe 'ensure => absent' do
      let :params do {
        :ensure => 'absent'
      }
      end
      it { should contain_file('/usr/java/default/jre/lib/security/README.txt').with_ensure('absent') }
      it { should contain_file('/usr/java/default/jre/lib/security/local_policy.jar').with_ensure('absent') }
      it { should contain_file('/usr/java/default/jre/lib/security/US_export_policy.jar').with_ensure('absent') }
    end

    describe 'ensure => badvalue' do
      let :params do {
        :ensure => 'badvalue'
      }
      end
      it 'should fail' do
        expect {
          should raise_error(Puppet::Error, /ensure parameter must be present or absent/)
        }
      end
    end

  end
end
