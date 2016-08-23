#!/usr/bin/env rspec

require 'spec_helper'

describe 'cloudera::cm::repo', :type => 'class' do

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
      it { should contain_yumrepo('cloudera-manager').with(
        :descr          => 'Cloudera Manager',
        :enabled        => '1',
        :gpgcheck       => '1',
        :gpgkey         => 'http://archive.cloudera.com/cm4/redhat/6/x86_64/cm/RPM-GPG-KEY-cloudera',
        :baseurl        => 'http://archive.cloudera.com/cm4/redhat/6/x86_64/cm/4/',
        :priority       => '50',
        :protect        => '0',
        :proxy          => 'absent',
        :proxy_username => 'absent',
        :proxy_password => 'absent'
      )}
      it { should contain_file('/etc/yum.repos.d/cloudera-manager.repo').with(
        :ensure => 'file',
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0644'
      )}
      it { should_not contain_yumrepo('cloudera-cdh4') }
      it { should_not contain_yumrepo('cloudera-impala') }
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
      it { should contain_zypprepo('cloudera-manager').with(
        :descr          => 'Cloudera Manager',
        :enabled        => '1',
        :gpgcheck       => '1',
        :gpgkey         => 'http://archive.cloudera.com/cm4/sles/11/x86_64/cm/RPM-GPG-KEY-cloudera',
        :baseurl        => 'http://archive.cloudera.com/cm4/sles/11/x86_64/cm/4/',
        :priority       => '50',
        :notify         => 'Exec[cloudera-import-gpgkey]'
      )}
      it { should contain_file('/etc/zypp/repos.d/cloudera-manager.repo').with(
        :ensure => 'file',
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0644'
      )}
      it { should_not contain_zypprepo('cloudera-cdh4') }
      it { should_not contain_zypprepo('cloudera-impala') }
      it { should contain_exec('cloudera-import-gpgkey').with(
        :path        => '/bin:/usr/bin:/sbin:/usr/sbin',
        :command     => 'rpm --import http://archive.cloudera.com/cm4/sles/11/x86_64/cm/RPM-GPG-KEY-cloudera',
        :refreshonly => 'true'
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
      it { should contain_apt__source('cloudera-manager').with(
        :location     => 'http://archive.cloudera.com/cm4/debian/squeeze/amd64/cm/',
        :release      => 'squeeze-cm4',
        :repos        => 'contrib',
        :key          => '327574EE02A818DD',
        :key_source   => 'http://archive.cloudera.com/cm4/debian/squeeze/amd64/cm/archive.key',
        :architecture => nil
      )}
      it { should_not contain_apt__source('cloudera-cdh4') }
      it { should_not contain_apt__source('cloudera-impala') }
    end

    describe 'Ubuntu 12.04.2' do
      let :facts do {
        :osfamily               => 'Debian',
        :operatingsystem        => 'Ubuntu',
        :operatingsystemrelease => '12.04.2',
        :architecture           => 'amd64',
        :lsbdistid              => 'Ubuntu',
        :lsbdistcodename        => 'precise'
      }
      end
      it { should compile.with_all_deps }
      it { should contain_class('apt') }
      it { should contain_apt__source('cloudera-manager').with(
        :location     => 'http://archive.cloudera.com/cm4/ubuntu/precise/amd64/cm/',
        :release      => 'precise-cm4',
        :repos        => 'contrib',
        :key          => '327574EE02A818DD',
        :key_source   => 'http://archive.cloudera.com/cm4/ubuntu/precise/amd64/cm/archive.key',
        :architecture => 'amd64'
      )}
      it { should_not contain_apt__source('cloudera-cdh4') }
      it { should_not contain_apt__source('cloudera-impala') }
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
      it { should contain_yumrepo('cloudera-manager').with_enabled('0') }
      it { should contain_file('/etc/yum.repos.d/cloudera-manager.repo').with_ensure('file') }
    end

    describe 'all other parameters' do
      let :params do {
        :reposerver     => 'http://localhost',
        :repopath       => '/somepath/3/',
        :version        => '888',
        :proxy          => 'http://proxy:3128/',
        :proxy_username => 'myUser',
        :proxy_password => 'myPass'
      }
      end
      it { should contain_yumrepo('cloudera-manager').with(
        :gpgkey         => 'http://localhost/somepath/3/RPM-GPG-KEY-cloudera',
        :baseurl        => 'http://localhost/somepath/3/888/',
        :proxy          => 'http://proxy:3128/',
        :proxy_username => 'myUser',
        :proxy_password => 'myPass'
      )}
      it { should contain_file('/etc/yum.repos.d/cloudera-manager.repo').with_ensure('file') }
    end
  end
end
