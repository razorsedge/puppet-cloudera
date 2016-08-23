#!/usr/bin/env rspec

require 'spec_helper'

describe 'cloudera::cm', :type => 'class' do

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
    let :facts do {
      :fqdn                   => 'myhost',
      :osfamily               => 'RedHat',
      :operatingsystem        => 'CentOS',
      :operatingsystemrelease => '6.0'
    }
    end
    it { should compile.with_all_deps }
    it { should contain_package('cloudera-manager-agent').with_ensure('present') }
    it { should contain_package('cloudera-manager-daemons').with_ensure('present') }
    it { should contain_file('scm-config.ini').with(
      :ensure => 'present',
      :path   => '/etc/cloudera-scm-agent/config.ini'
    )}
    it 'should contain File[scm-config.ini] with correct contents' do
      verify_contents(catalogue, 'scm-config.ini', [
        'server_host=localhost',
        'server_port=7182',
        'listening_hostname=myhost',
        'parcel_dir=/opt/cloudera/parcels',
        'use_tls=0',
        '# verify_cert_file=',
      ])
    end
    it { should contain_service('cloudera-scm-agent').with(
      :ensure     => 'running',
      :enable     => true,
      :hasrestart => true,
      :hasstatus  => true
    )}
  end

  context 'on a supported operatingsystem, custom parameters' do
    let :facts do {
      :fqdn                   => 'myhost',
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
      it { should contain_package('cloudera-manager-agent').with_ensure('absent') }
      it { should contain_package('cloudera-manager-daemons').with_ensure('absent') }
      it { should contain_file('scm-config.ini').with_ensure('absent') }
      it { should contain_service('cloudera-scm-agent').with(
        :ensure => 'stopped',
        :enable => false
      )}
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

    describe 'autoupgrade => true' do
      let :params do {
        :autoupgrade   => true
      }
      end
      it { should contain_package('cloudera-manager-agent').with_ensure('latest') }
      it { should contain_package('cloudera-manager-daemons').with_ensure('latest') }
      it { should contain_file('scm-config.ini').with_ensure('present') }
      it { should contain_service('cloudera-scm-agent').with(
        :ensure => 'running',
        :enable => true
      )}  
    end

    describe 'autoupgrade => badvalue' do
      let :params do {
        :autoupgrade => 'badvalue'
      }
      end
      it 'should fail' do
        expect {
          should raise_error(Puppet::Error, /"badvalue" is not a boolean./)
        }
      end
    end

    describe 'service_ensure => badvalue' do
      let :params do {
        :service_ensure => 'badvalue'
      }
      end
      it 'should fail' do
        expect {
          should raise_error(Puppet::Error, /service_ensure parameter must be running or stopped/)
        }
      end
    end

    describe 'server_host => some.other.host' do
      let :params do {
        :server_host => 'some.other.host',
        :server_port => '9000'
      }
      end
      it { should contain_file('scm-config.ini').with_ensure('present') }
      it 'should contain File[scm-config.ini] with correct contents' do
        verify_contents(catalogue, 'scm-config.ini', [
          'server_host=some.other.host',
          'server_port=9000',
          'listening_hostname=myhost',
          'use_tls=0',
        ])
      end
    end

    describe 'use_tls => true' do
      let :params do {
        :use_tls => true
      }
      end

      describe 'RedHat' do
        let :facts do {
          :osfamily               => 'RedHat',
          :operatingsystem        => 'CentOS',
          :operatingsystemrelease => '6.0'
        }
        end
        it { should contain_file('scm-config.ini').with_ensure('present') }
        it 'should contain File[scm-config.ini] with correct contents' do
          verify_contents(catalogue, 'scm-config.ini', [
            'use_tls=1',
            'verify_cert_file=/etc/pki/tls/certs/cloudera_manager.crt',
          ])
        end
      end

      describe 'SLES' do
        let :facts do {
          :osfamily               => 'Suse',
          :operatingsystem        => 'SLES',
          :operatingsystemrelease => '11.0'
        }
        end
        it { should contain_file('scm-config.ini').with_ensure('present') }
        it 'should contain File[scm-config.ini] with correct contents' do
          verify_contents(catalogue, 'scm-config.ini', [
            'use_tls=1',
            'verify_cert_file=/etc/ssl/certs/cloudera_manager.crt',
          ])
        end
      end

      describe 'Ubuntu' do
        let :facts do {
          :osfamily               => 'Debian',
          :operatingsystem        => 'Ubuntu',
          :operatingsystemrelease => '12.04'
        }
        end
        it { should contain_file('scm-config.ini').with_ensure('present') }
        it 'should contain File[scm-config.ini] with correct contents' do
          verify_contents(catalogue, 'scm-config.ini', [
            'use_tls=1',
            'verify_cert_file=/etc/ssl/certs/cloudera_manager.crt',
          ])
        end
      end
    end
  end
end
