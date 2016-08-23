#!/usr/bin/env rspec

require 'spec_helper'

describe 'cloudera::impala::repo', :type => 'class' do

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
    describe 'RedHat 6' do
      let :facts do {
        :osfamily               => 'RedHat',
        :operatingsystem        => 'CentOS',
        :operatingsystemrelease => '6.3',
        :architecture           => 'x86_64'
      }
      end
      it { should compile.with_all_deps }
      it { should contain_yumrepo('cloudera-impala').with(
        :descr          => 'Impala',
        :enabled        => '1',
        :gpgcheck       => '1',
        :gpgkey         => 'http://archive.cloudera.com/impala/redhat/6/x86_64/impala/RPM-GPG-KEY-cloudera',
        :baseurl        => 'http://archive.cloudera.com/impala/redhat/6/x86_64/impala/1/',
        :priority       => '50',
        :protect        => '0',
        :proxy          => 'absent',
        :proxy_username => 'absent',
        :proxy_password => 'absent'
      )}
      it { should contain_file('/etc/yum.repos.d/cloudera-impala.repo').with(
        :ensure => 'file',
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0644'
      )}
      it { should_not contain_yumrepo('cloudera-manager') }
    end

    describe 'SLES 11' do
      let :facts do {
        :osfamily               => 'Suse',
        :operatingsystem        => 'SLES',
        :operatingsystemrelease => '11.1',
        :architecture           => 'x86_64'
      }
      end
      it { should compile.with_all_deps }
      it { should contain_zypprepo('cloudera-impala').with(
        :descr          => 'Impala',
        :enabled        => '1',
        :gpgcheck       => '1',
        :gpgkey         => 'http://archive.cloudera.com/impala/sles/11/x86_64/impala/RPM-GPG-KEY-cloudera',
        :baseurl        => 'http://archive.cloudera.com/impala/sles/11/x86_64/impala/1/',
        :priority       => '50'
      )}
      it { should contain_file('/etc/zypp/repos.d/cloudera-impala.repo').with(
        :ensure => 'file',
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0644'
      )}
      it { should_not contain_zypprepo('cloudera-manager') }
    end

    describe 'Debian 6' do
      let :facts do {
        :osfamily               => 'Debian',
        :operatingsystem        => 'Debian',
        :operatingsystemrelease => '6.0.7',
        :architecture           => 'amd64',
        :lsbdistid              => 'Debian',
        :lsbdistcodename        => 'squeeze'
      }
      end
      it { should compile.with_all_deps }
      it { should contain_class('apt') }
      it { should contain_apt__source('cloudera-impala').with(
        :location     => 'http://archive.cloudera.com/impala/debian/squeeze/amd64/impala/',
        :release      => 'squeeze-impala1',
        :repos        => 'contrib',
        :key          => 'false',
        :key_source   => 'http://archive.cloudera.com/impala/debian/squeeze/amd64/impala/archive.key',
        :architecture => nil
      )}
      it { should_not contain_apt__source('cloudera-manager') }
    end
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
      it { should contain_yumrepo('cloudera-impala').with_enabled('0') }
      it { should contain_file('/etc/yum.repos.d/cloudera-impala.repo').with_ensure('file') }
    end

    describe 'all other parameters' do
      let :params do {
        :reposerver     => 'http://localhost',
        :repopath       => '/somepath/2/',
        :version        => '777',
        :proxy          => 'http://proxy:3128/',
        :proxy_username => 'myUser',
        :proxy_password => 'myPass'
      }
      end
      it { should contain_yumrepo('cloudera-impala').with(
        :gpgkey         => 'http://localhost/somepath/2/RPM-GPG-KEY-cloudera',
        :baseurl        => 'http://localhost/somepath/2/777/',
        :proxy          => 'http://proxy:3128/',
        :proxy_username => 'myUser',
        :proxy_password => 'myPass'
      )}
      it { should contain_file('/etc/yum.repos.d/cloudera-impala.repo').with_ensure('file') }
    end
  end
end
