#!/usr/bin/env rspec

require 'spec_helper'

describe 'cloudera::cdh5::repo', :type => 'class' do

  context 'on a non-supported operatingsystem' do
    let :facts do {
      :osfamily        => 'foo',
      :operatingsystem => 'bar'
    }
    end
    it do
      expect {
        should compile
      }.to raise_error(Puppet::Error, /Module cloudera is not supported on bar/)
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
      it { should contain_yumrepo('cloudera-cdh5').with(
        :descr          => 'Cloudera\'s Distribution for Hadoop, Version 5',
        :enabled        => '1',
        :gpgcheck       => '1',
        :gpgkey         => 'http://archive.cloudera.com/cdh5/redhat/6/x86_64/cdh/RPM-GPG-KEY-cloudera',
        :baseurl        => 'http://archive.cloudera.com/cdh5/redhat/6/x86_64/cdh/5/',
        :priority       => '50',
        :protect        => '0',
        :proxy          => 'absent',
        :proxy_username => 'absent',
        :proxy_password => 'absent'
      )}
      it { should contain_file('/etc/yum.repos.d/cloudera-cdh5.repo').with(
        :ensure => 'file',
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0644'
      )}
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
      it { should contain_zypprepo('cloudera-cdh5').with(
        :descr          => 'Cloudera\'s Distribution for Hadoop, Version 5',
        :enabled        => '1',
        :gpgcheck       => '1',
        :gpgkey         => 'http://archive.cloudera.com/cdh5/sles/11/x86_64/cdh/RPM-GPG-KEY-cloudera',
        :baseurl        => 'http://archive.cloudera.com/cdh5/sles/11/x86_64/cdh/5/',
        :priority       => '50'
      )}
      it { should contain_file('/etc/zypp/repos.d/cloudera-cdh5.repo').with(
        :ensure => 'file',
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0644'
      )}
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
      it { should contain_apt__source('cloudera-cdh5').with(
        :location     => 'http://archive.cloudera.com/cdh5/debian/squeeze/amd64/cdh/',
        :release      => 'squeeze-cdh5',
        :repos        => 'contrib',
        :key          => 'false',
        :key_source   => 'http://archive.cloudera.com/cdh5/debian/squeeze/amd64/cdh/archive.key',
        :architecture => nil
      )}
    end

    describe 'Ubuntu 12.04' do
        let :facts do {
            :osfamily               => 'Debian',
            :operatingsystem        => 'Ubuntu',
            :operatingsystemrelease => '12.04',
            :architecture           => 'amd64',
            :lsbdistid              => 'Ubuntu',
            :lsbdistcodename        => 'precise'
        }
    end
    it { should compile.with_all_deps }
    it { should contain_class('apt') }
    it { should contain_apt__source('cloudera-cdh5').with(
        :location     => 'http://archive.cloudera.com/cdh5/ubuntu/precise/amd64/cdh/',
        :release      => 'precise-cdh5',
        :repos        => 'contrib',
        :key          => 'false',
        :key_source   => 'http://archive.cloudera.com/cdh5/ubuntu/precise/amd64/cdh/archive.key',
        :architecture => 'amd64'
        )}
    end

    describe 'Ubuntu 14.04' do
        let :facts do {
            :osfamily               => 'Debian',
            :operatingsystem        => 'Ubuntu',
            :operatingsystemrelease => '14.04',
            :architecture           => 'amd64',
            :lsbdistid              => 'Ubuntu',
            :lsbdistcodename        => 'trusty'
        }
    end
    it { should compile.with_all_deps }
    it { should contain_class('apt') }
    it { should contain_apt__source('cloudera-cdh5').with(
        :location     => 'http://archive.cloudera.com/cdh5/ubuntu/trusty/amd64/cdh/',
        :release      => 'trusty-cdh5',
        :repos        => 'contrib',
        :key          => 'false',
        :key_source   => 'http://archive.cloudera.com/cdh5/ubuntu/trusty/amd64/cdh/archive.key',
        :architecture => 'amd64',
        :pin          => '501'
        ) }
    end
  end

  context 'on a supported operatingsystem, custom parameters' do
    let :facts do {
      :osfamily        => 'RedHat',
      :operatingsystem => 'OracleLinux'
    }
    end

    describe 'ensure => absent' do
      let :params do {
        :ensure => 'absent'
      }
      end
      it { should contain_yumrepo('cloudera-cdh5').with_enabled('0') }
      it { should contain_file('/etc/yum.repos.d/cloudera-cdh5.repo').with_ensure('file') }
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
      it { should contain_yumrepo('cloudera-cdh5').with(
        :gpgkey         => 'http://localhost/somepath/RPM-GPG-KEY-cloudera',
        :baseurl        => 'http://localhost/somepath/999/',
        :proxy          => 'http://proxy:3128/',
        :proxy_username => 'myUser',
        :proxy_password => 'myPass'
      )}
      it { should contain_file('/etc/yum.repos.d/cloudera-cdh5.repo').with_ensure('file') }
    end
  end
end
