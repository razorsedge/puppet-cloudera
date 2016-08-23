#!/usr/bin/env rspec

require 'spec_helper'

describe 'cloudera::cdh::repo', :type => 'class' do

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
    let(:params) {{ :version => '4' }}
    describe 'RedHat 6' do
      let :facts do {
        :osfamily               => 'RedHat',
        :operatingsystem        => 'CentOS',
        :operatingsystemrelease => '6.3',
        :architecture           => 'x86_64'
      }
      end
      it { should compile.with_all_deps }
      it { should contain_yumrepo('cloudera-cdh4').with(
        :descr          => 'Cloudera\'s Distribution for Hadoop, Version 4',
        :enabled        => '1',
        :gpgcheck       => '1',
        :gpgkey         => 'http://archive.cloudera.com/cdh4/redhat/6/x86_64/cdh/RPM-GPG-KEY-cloudera',
        :baseurl        => 'http://archive.cloudera.com/cdh4/redhat/6/x86_64/cdh/4/',
        :priority       => '50',
        :protect        => '0',
        :proxy          => 'absent',
        :proxy_username => 'absent',
        :proxy_password => 'absent'
      )}
      it { should contain_file('/etc/yum.repos.d/cloudera-cdh4.repo').with(
        :ensure => 'file',
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0644'
      )}
      it { should_not contain_yumrepo('cloudera-impala') }
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
      it { should contain_zypprepo('cloudera-cdh4').with(
        :descr          => 'Cloudera\'s Distribution for Hadoop, Version 4',
        :enabled        => '1',
        :gpgcheck       => '1',
        :gpgkey         => 'http://archive.cloudera.com/cdh4/sles/11/x86_64/cdh/RPM-GPG-KEY-cloudera',
        :baseurl        => 'http://archive.cloudera.com/cdh4/sles/11/x86_64/cdh/4/',
        :priority       => '50'
      )}
      it { should contain_file('/etc/zypp/repos.d/cloudera-cdh4.repo').with(
        :ensure => 'file',
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0644'
      )}
      it { should_not contain_zypprepo('cloudera-impala') }
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
      it { should contain_apt__source('cloudera-cdh4').with(
        :location     => 'http://archive.cloudera.com/cdh4/debian/squeeze/amd64/cdh/',
        :release      => 'squeeze-cdh4',
        :repos        => 'contrib',
        :key          => 'false',
        :key_source   => 'http://archive.cloudera.com/cdh4/debian/squeeze/amd64/cdh/archive.key',
        :architecture => nil
      )}
      it { should_not contain_apt__source('cloudera-impala') }
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
      it { should contain_yumrepo('cloudera-cdh4').with_enabled('0') }
      it { should contain_file('/etc/yum.repos.d/cloudera-cdh4.repo').with_ensure('file') }
    end

    describe 'all other parameters' do
      let :params do {
        :reposerver     => 'http://localhost',
        :repopath       => '/somepath/',
        :version        => '999',
        :proxy          => 'http://proxy:3128/',
        :proxy_username => 'myUser',
        :proxy_password => 'myPass'
      }
      end
      it { should contain_yumrepo('cloudera-cdh4').with(
        :gpgkey         => 'http://localhost/somepath/RPM-GPG-KEY-cloudera',
        :baseurl        => 'http://localhost/somepath/999/',
        :proxy          => 'http://proxy:3128/',
        :proxy_username => 'myUser',
        :proxy_password => 'myPass'
      )}
      it { should contain_file('/etc/yum.repos.d/cloudera-cdh4.repo').with_ensure('file') }
    end
  end
end
