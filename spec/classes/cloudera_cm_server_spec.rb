#!/usr/bin/env rspec

require 'spec_helper'

describe 'cloudera::cm::server', :type => 'class' do

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
      :osfamily               => 'RedHat',
      :operatingsystem        => 'CentOS',
      :operatingsystemrelease => '6.0'
    }
    end
    it { should compile.with_all_deps }
    it { should contain_package('cloudera-manager-server').with_ensure('present') }
    it { should contain_file('/etc/cloudera-scm-server/db.properties').with(
      :ensure => 'present',
      :path   => '/etc/cloudera-scm-server/db.properties'
    )}
    it { should contain_service('cloudera-scm-server').with(
      :ensure     => 'running',
      :enable     => true,
      :hasrestart => true,
      :hasstatus  => true
    )}
    it { should contain_package('cloudera-manager-server-db').with_ensure('present') }
    it { should contain_exec('cloudera-manager-server-db').with(
      :command => 'service cloudera-scm-server-db initdb',
      :path    => '/bin:/usr/bin:/sbin:/usr/sbin',
      :creates => '/etc/cloudera-scm-server/db.mgmt.properties'
    )}
    it { should contain_service('cloudera-scm-server-db').with(
      :ensure     => 'running',
      :enable     => true,
      :hasrestart => true,
      :hasstatus  => true
    )}
    it { should_not contain_java_ks('cmca:/etc/cloudera-scm-server/keystore') }
    it { should_not contain_java_ks('jetty:/etc/cloudera-scm-server/keystore') }
    it { should_not contain_file('/etc/cloudera-scm-server/keystore') }
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
      it { should contain_package('cloudera-manager-server').with_ensure('absent') }
      it { should contain_file('/etc/cloudera-scm-server/db.properties').with_ensure('absent') }
      it { should contain_service('cloudera-scm-server').with(
        :ensure => 'stopped',
        :enable => false
      )}
      it { should contain_package('cloudera-manager-server-db').with_ensure('absent') }
      it { should contain_service('cloudera-scm-server-db').with(
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
      it { should contain_package('cloudera-manager-server').with_ensure('latest') }
      it { should contain_file('/etc/cloudera-scm-server/db.properties').with_ensure('present') }
      it { should contain_service('cloudera-scm-server').with(
        :ensure => 'running',
        :enable => true
      )}
      it { should contain_package('cloudera-manager-server-db').with_ensure('latest') }
      it { should contain_service('cloudera-scm-server-db').with(
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
  end

#  context 'on a supported operatingsystem, custom parameters, db_type => embedded' do
#    let :facts do {
#      :osfamily        => 'RedHat',
#      :operatingsystem => 'OracleLinux'
#    }
#    end
#
#    describe 'server_host => some.other.host' do
#      let :params do {
#        :db_type       => 'embedded',
#        :database_name => 'scm',
#        :username      => 'scm',
#        :password      => 'scm'
#      }
#      end
#      it { should contain_file('/etc/cloudera-scm-server/db.properties').with_ensure('present') }
#      it 'should contain File[/etc/cloudera-scm-server/db.properties] with correct contents' do
#        verify_contents(catalogue, '/etc/cloudera-scm-server/db.properties', [
#          '9000',
#        ])
#      end
#   end
#  end

  context 'on a supported operatingsystem, custom parameters, db_type => mysql' do
    let :facts do {
      :fqdn                   => 'myhost.example.com',
      :osfamily               => 'RedHat',
      :operatingsystem        => 'OracleLinux',
      :operatingsystemrelease => '6.0'
    }
    end

    describe 'with defaults' do
      let(:pre_condition) { 'class {"mysql::server":}' }
      let :params do {
        :db_type => 'mysql'
      }
      end
      it { should contain_file('/etc/cloudera-scm-server/db.properties').with_ensure('present') }
      it 'should contain File[/etc/cloudera-scm-server/db.properties] with correct contents' do
        verify_contents(catalogue, '/etc/cloudera-scm-server/db.properties', [
          'com.cloudera.cmf.db.type=mysql',
          'com.cloudera.cmf.db.host=localhost:3306',
          'com.cloudera.cmf.db.name=scm',
          'com.cloudera.cmf.db.user=scm',
          'com.cloudera.cmf.db.password=scm',
        ])
      end
      it { should contain_class('mysql::bindings') }
      it { should contain_class('mysql::bindings::java') }
      it { should contain_exec('scm_prepare_database').with(
        :command => '/usr/share/cmf/schema/scm_prepare_database.sh mysql  --user=root --password= scm scm scm && touch /etc/cloudera-scm-server/.scm_prepare_database',
        :creates => '/etc/cloudera-scm-server/.scm_prepare_database',
        :require => [ 'Package[cloudera-manager-server]', 'Class[Mysql::Server]' ],
        :before  => 'Service[cloudera-scm-server]'
      )}
    end

    describe 'with custom parameters' do
      let(:pre_condition) { 'class {"mysql::server":}' }
      let :params do {
        :db_type       => 'mysql',
        :database_name => 'clouderaDB',
        :username      => 'dbuser',
        :password      => 'myDbPass',
        :db_host       => 'dbhost.example.com',
        :db_port       => '9000',
        :db_user       => 'dbadmin',
        :db_pass       => 'myPass'
      }
      end
      it { should contain_file('/etc/cloudera-scm-server/db.properties').with_ensure('present') }
      it 'should contain File[/etc/cloudera-scm-server/db.properties] with correct contents' do
        verify_contents(catalogue, '/etc/cloudera-scm-server/db.properties', [
          'com.cloudera.cmf.db.type=mysql',
          'com.cloudera.cmf.db.host=dbhost.example.com:9000',
          'com.cloudera.cmf.db.name=clouderaDB',
          'com.cloudera.cmf.db.user=dbuser',
          'com.cloudera.cmf.db.password=myDbPass',
        ])
      end
      it { should contain_class('mysql::bindings') }
      it { should contain_class('mysql::bindings::java') }
      it { should contain_exec('scm_prepare_database').with(
        :command => '/usr/share/cmf/schema/scm_prepare_database.sh mysql --host=dbhost.example.com --port=9000 --scm-host=myhost.example.com --user=dbadmin --password=myPass clouderaDB dbuser myDbPass && touch /etc/cloudera-scm-server/.scm_prepare_database',
        :creates => '/etc/cloudera-scm-server/.scm_prepare_database',
        :require => 'Package[cloudera-manager-server]',
        :before  => 'Service[cloudera-scm-server]'
      )}
    end
  end

  context 'on a supported operatingsystem, custom parameters, db_type => oracle' do
    let :facts do {
      :fqdn                   => 'myhost.example.com',
      :osfamily               => 'RedHat',
      :operatingsystem        => 'OracleLinux',
      :operatingsystemrelease => '6.0'
    }
    end

    describe 'with defaults' do
#      let(:pre_condition) { 'class {"oraclerdbms::server":}' }
      let :params do {
        :db_type => 'oracle'
      }
      end
      it { should contain_file('/etc/cloudera-scm-server/db.properties').with_ensure('present') }
      it 'should contain File[/etc/cloudera-scm-server/db.properties] with correct contents' do
        verify_contents(catalogue, '/etc/cloudera-scm-server/db.properties', [
          'com.cloudera.cmf.db.type=oracle',
          'com.cloudera.cmf.db.host=localhost:3306',
          'com.cloudera.cmf.db.name=scm',
          'com.cloudera.cmf.db.user=scm',
          'com.cloudera.cmf.db.password=scm',
        ])
      end
#      it { should contain_class('oraclerdbms::java') }
      it { should contain_exec('scm_prepare_database').with(
        :command => '/usr/share/cmf/schema/scm_prepare_database.sh oracle  --user=root --password= scm scm scm && touch /etc/cloudera-scm-server/.scm_prepare_database',
        :creates => '/etc/cloudera-scm-server/.scm_prepare_database',
        :require => 'Package[cloudera-manager-server]',
        :before  => 'Service[cloudera-scm-server]'
      )}
    end

    describe 'with custom parameters' do
#      let(:pre_condition) { 'class {"oraclerdbms::server":}' }
      let :params do {
        :db_type       => 'oracle',
        :database_name => 'clouderaDB',
        :username      => 'dbuser',
        :password      => 'myDbPass',
        :db_host       => 'dbhost.example.com',
        :db_port       => '9000',
        :db_user       => 'dbadmin',
        :db_pass       => 'myPass'
      }
      end
      it { should contain_file('/etc/cloudera-scm-server/db.properties').with_ensure('present') }
      it 'should contain File[/etc/cloudera-scm-server/db.properties] with correct contents' do
        verify_contents(catalogue, '/etc/cloudera-scm-server/db.properties', [
          'com.cloudera.cmf.db.type=oracle',
          'com.cloudera.cmf.db.host=dbhost.example.com:9000',
          'com.cloudera.cmf.db.name=clouderaDB',
          'com.cloudera.cmf.db.user=dbuser',
          'com.cloudera.cmf.db.password=myDbPass',
        ])
      end
#      it { should contain_class('oraclerdbms::java') }
      it { should contain_exec('scm_prepare_database').with(
        :command => '/usr/share/cmf/schema/scm_prepare_database.sh oracle --host=dbhost.example.com --port=9000 --scm-host=myhost.example.com --user=dbadmin --password=myPass clouderaDB dbuser myDbPass && touch /etc/cloudera-scm-server/.scm_prepare_database',
        :creates => '/etc/cloudera-scm-server/.scm_prepare_database',
        :require => 'Package[cloudera-manager-server]',
        :before  => 'Service[cloudera-scm-server]'
      )}
    end
  end

  context 'on a supported operatingsystem, custom parameters, db_type => postgresql' do
    let :facts do {
      :concat_basedir         => '/var/lib/puppet/concat',
      :fqdn                   => 'myhost.example.com',
      :osfamily               => 'RedHat',
      :operatingsystem        => 'OracleLinux',
      :operatingsystemrelease => '6.4'
    }
    end

    describe 'with defaults' do
      let(:pre_condition) { 'class {"postgresql::server":}' }
      let :params do {
        :db_type => 'postgresql'
      }
      end
      it { should contain_file('/etc/cloudera-scm-server/db.properties').with_ensure('present') }
      it 'should contain File[/etc/cloudera-scm-server/db.properties] with correct contents' do
        verify_contents(catalogue, '/etc/cloudera-scm-server/db.properties', [
          'com.cloudera.cmf.db.type=postgresql',
          'com.cloudera.cmf.db.host=localhost:3306',
          'com.cloudera.cmf.db.name=scm',
          'com.cloudera.cmf.db.user=scm',
          'com.cloudera.cmf.db.password=scm',
        ])
      end
      it { should contain_class('postgresql::lib::java') }
      it { should contain_exec('scm_prepare_database').with(
        :command => '/usr/share/cmf/schema/scm_prepare_database.sh postgresql  --user=root --password= scm scm scm && touch /etc/cloudera-scm-server/.scm_prepare_database',
        :creates => '/etc/cloudera-scm-server/.scm_prepare_database',
        :require => [ 'Package[cloudera-manager-server]', 'Class[Postgresql::Server]' ],
        :before  => 'Service[cloudera-scm-server]'
      )}
    end

    describe 'with custom parameters' do
      let :params do {
        :db_type       => 'postgresql',
        :database_name => 'clouderaDB',
        :username      => 'dbuser',
        :password      => 'myDbPass',
        :db_host       => 'dbhost.example.com',
        :db_port       => '9000',
        :db_user       => 'dbadmin',
        :db_pass       => 'myPass'
      }
      end
      it { should contain_file('/etc/cloudera-scm-server/db.properties').with_ensure('present') }
      it 'should contain File[/etc/cloudera-scm-server/db.properties] with correct contents' do
        verify_contents(catalogue, '/etc/cloudera-scm-server/db.properties', [
          'com.cloudera.cmf.db.type=postgresql',
          'com.cloudera.cmf.db.host=dbhost.example.com:9000',
          'com.cloudera.cmf.db.name=clouderaDB',
          'com.cloudera.cmf.db.user=dbuser',
          'com.cloudera.cmf.db.password=myDbPass',
        ])
      end
      it { should contain_class('postgresql::lib::java') }
      it { should contain_exec('scm_prepare_database').with(
        :command => '/usr/share/cmf/schema/scm_prepare_database.sh postgresql --host=dbhost.example.com --port=9000 --scm-host=myhost.example.com --user=dbadmin --password=myPass clouderaDB dbuser myDbPass && touch /etc/cloudera-scm-server/.scm_prepare_database',
        :creates => '/etc/cloudera-scm-server/.scm_prepare_database',
        :require => 'Package[cloudera-manager-server]',
        :before  => 'Service[cloudera-scm-server]'
      )}
    end
  end

  context 'on a supported operatingsystem, custom parameters, use_tls => true' do
    describe 'RedHat' do
      let :facts do {
        :fqdn                   => 'localhost.localdomain',
        :osfamily               => 'RedHat',
        :operatingsystem        => 'OracleLinux',
        :operatingsystemrelease => '6.0'
      }
      end

      describe 'use_tls => true' do
        let :params do {
          :use_tls => true
        }
        end
        it { should contain_java_ks('cmca:/etc/cloudera-scm-server/keystore').with(
          :ensure       => 'latest',
          :certificate  => '/etc/pki/tls/certs/cloudera_manager-ca.crt',
          :password     => nil,
          :trustcacerts => true,
          :require      => 'Package[cloudera-manager-server]',
          :notify       => 'Service[cloudera-scm-server]'
        )}
        it { should contain_java_ks('jetty:/etc/cloudera-scm-server/keystore').with(
          :ensure       => 'latest',
          :certificate  => '/etc/pki/tls/certs/localhost.localdomain-cloudera_manager.crt',
          :private_key  => '/etc/pki/tls/private/localhost.localdomain-cloudera_manager.key',
          :chain        => nil,
          :password     => nil,
          :require      => 'Package[cloudera-manager-server]',
          :notify       => 'Service[cloudera-scm-server]'
        )}
        it { should contain_file('/etc/cloudera-scm-server/keystore').with(
          :ensure  => 'present',
          :owner   => 'cloudera-scm',
          :group   => 'cloudera-scm',
          :mode    => '0640',
          :require => 'Java_ks[cmca:/etc/cloudera-scm-server/keystore]'
        )}
      end
    end

    describe 'SLES' do
      let :facts do {
        :fqdn                   => 'localhost.localdomain',
        :osfamily               => 'Suse',
        :operatingsystem        => 'SLES',
        :operatingsystemrelease => '11.0'
      }
      end

      describe 'use_tls => true' do
        let :params do {
          :use_tls => true
        }
        end
        it { should contain_java_ks('cmca:/etc/cloudera-scm-server/keystore').with(
          :ensure       => 'latest',
          :certificate  => '/etc/ssl/certs/cloudera_manager-ca.crt',
          :password     => nil,
          :trustcacerts => true,
          :require      => 'Package[cloudera-manager-server]',
          :notify       => 'Service[cloudera-scm-server]'
        )}
        it { should contain_java_ks('jetty:/etc/cloudera-scm-server/keystore').with(
          :ensure       => 'latest',
          :certificate  => '/etc/ssl/certs/localhost.localdomain-cloudera_manager.crt',
          :private_key  => '/etc/ssl/private/localhost.localdomain-cloudera_manager.key',
          :chain        => nil,
          :password     => nil,
          :require      => 'Package[cloudera-manager-server]',
          :notify       => 'Service[cloudera-scm-server]'
        )}
        it { should contain_file('/etc/cloudera-scm-server/keystore').with(
          :ensure  => 'present',
          :owner   => 'cloudera-scm',
          :group   => 'cloudera-scm',
          :mode    => '0640',
          :require => 'Java_ks[cmca:/etc/cloudera-scm-server/keystore]'
        )}
      end
    end

    describe 'Debian' do
      let :facts do {
        :fqdn                   => 'localhost.localdomain',
        :osfamily               => 'Debian',
        :operatingsystem        => 'Debian',
        :operatingsystemrelease => '7'
      }
      end

      describe 'use_tls => true' do
        let :params do {
          :use_tls => true
        }
        end
        it { should contain_java_ks('cmca:/etc/cloudera-scm-server/keystore').with(
          :ensure       => 'latest',
          :certificate  => '/etc/ssl/certs/cloudera_manager-ca.crt',
          :password     => nil,
          :trustcacerts => true,
          :require      => 'Package[cloudera-manager-server]',
          :notify       => 'Service[cloudera-scm-server]'
        )}
        it { should contain_java_ks('jetty:/etc/cloudera-scm-server/keystore').with(
          :ensure       => 'latest',
          :certificate  => '/etc/ssl/certs/localhost.localdomain-cloudera_manager.crt',
          :private_key  => '/etc/ssl/private/localhost.localdomain-cloudera_manager.key',
          :chain        => nil,
          :password     => nil,
          :require      => 'Package[cloudera-manager-server]',
          :notify       => 'Service[cloudera-scm-server]'
        )}
        it { should contain_file('/etc/cloudera-scm-server/keystore').with(
          :ensure  => 'present',
          :owner   => 'cloudera-scm',
          :group   => 'cloudera-scm',
          :mode    => '0640',
          :require => 'Java_ks[cmca:/etc/cloudera-scm-server/keystore]'
        )}
      end
    end

    let :facts do {
      :fqdn                   => 'localhost.localdomain',
      :osfamily               => 'RedHat',
      :operatingsystem        => 'OracleLinux',
      :operatingsystemrelease => '6.0'
    }
    end

    describe 'use_tls => badvalue' do
      let :params do {
        :use_tls => 'badvalue'
      }
      end
      it 'should fail' do
        expect {
          should raise_error(Puppet::Error, /"badvalue" is not a boolean./)
        }
      end
    end

    describe 'server_keypw => somePass; server_chain_file => /etc/pki/tls/certs/intermediateCA.pem' do
      let :params do {
        :use_tls           => true,
        :server_keypw      => 'somePass',
        :server_chain_file => '/etc/pki/tls/certs/intermediateCA.pem'
      }
      end
      it { should contain_java_ks('cmca:/etc/cloudera-scm-server/keystore').with(
        :password => 'somePass'
      )}
      it { should contain_java_ks('jetty:/etc/cloudera-scm-server/keystore').with(
        :chain    => '/etc/pki/tls/certs/intermediateCA.pem',
        :password => 'somePass'
      )}
      it { should contain_file('/etc/cloudera-scm-server/keystore') }
    end
  end
end
