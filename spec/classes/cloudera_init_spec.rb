#!/usr/bin/env rspec

require 'spec_helper'

describe 'cloudera', :type => 'class' do

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
    let(:params) {{}}
    let :facts do {
      :osfamily               => 'RedHat',
      :operatingsystem        => 'CentOS',
      :operatingsystemrelease => '6.0'
    }
    end
    it { should compile.with_all_deps }
    it { should contain_sysctl('vm.swappiness').with(
      :ensure => 'present',
      :value  => '0',
      :apply  => 'true'
    )}
    it { should contain_exec('disable_transparent_hugepage_defrag') }
    it { should contain_exec('disable_redhat_transparent_hugepage_defrag') }
    it { should contain_class('cloudera::java5').with_ensure('present') }
    it { should_not contain_class('cloudera::java5::jce') }
    it { should contain_class('cloudera::cm5::repo').with_ensure('present') }
    it { should contain_class('cloudera::cm5').with_ensure('present') }
    it { should_not contain_class('cloudera::cdh5::repo') }
    it { should_not contain_class('cloudera::cdh5') }
    it { should_not contain_class('cloudera::cm5::server') }
    it { should_not contain_class('cloudera::lzo') }

    it { should_not contain_class('cloudera::java') }
    it { should_not contain_class('cloudera::java::jce') }
    it { should_not contain_class('cloudera::cm::repo') }
    it { should_not contain_class('cloudera::cm') }
    it { should_not contain_class('cloudera::cdh::repo') }
    it { should_not contain_class('cloudera::cdh') }
    it { should_not contain_class('cloudera::cm::server') }
    it { should_not contain_class('cloudera::gplextras5::repo') }
    it { should_not contain_class('cloudera::gplextras5') }
  end

  context 'on a supported operatingsystem, custom parameters, cm_version => 5' do
    let :facts do {
      :osfamily               => 'RedHat',
      :operatingsystem        => 'CentOS',
      :operatingsystemrelease => '6.0'
    }
    end

    describe 'ensure => absent' do
      let(:params) {{ :ensure => 'absent' }}
      it { should contain_sysctl('vm.swappiness').with_ensure('absent') }
      it { should contain_class('cloudera::java5').with_ensure('absent') }
      it { should_not contain_class('cloudera::java5::jce') }
      it { should contain_class('cloudera::cm5').with_ensure('absent') }
      it { should contain_class('cloudera::cm5::repo').with_ensure('absent') }
    end

    describe 'use_parcels => false' do
      let(:params) {{ :use_parcels => false }}
      it { should contain_class('cloudera::java5').with_ensure('present') }
      it { should_not contain_class('cloudera::java5::jce') }
      it { should contain_class('cloudera::cm5').with_ensure('present') }
      it { should contain_class('cloudera::cm5::repo').with_ensure('present') }
      it { should contain_class('cloudera::cdh5::repo').with_ensure('present') }
      it { should contain_class('cloudera::cdh5').with_ensure('present') }
      it { should_not contain_class('cloudera::cdh::repo') }
      it { should_not contain_class('cloudera::cdh') }
      it { should_not contain_class('cloudera::impala::repo') }
      it { should_not contain_class('cloudera::impala') }
      it { should_not contain_class('cloudera::search::repo') }
      it { should_not contain_class('cloudera::search') }
      it { should_not contain_class('cloudera::gplextras::repo') }
      it { should_not contain_class('cloudera::gplextras') }
      it { should_not contain_class('cloudera::gplextras5::repo') }
      it { should_not contain_class('cloudera::gplextras5') }
      it { should_not contain_class('cloudera::lzo') }
    end

    describe 'use_parcels => false, cdh_version => 4' do
      let(:params) {{ :use_parcels => false, :cdh_version => '4' }}
      it { should contain_class('cloudera::java5').with_ensure('present') }
      it { should_not contain_class('cloudera::java5::jce') }
      it { should contain_class('cloudera::cm5').with_ensure('present') }
      it { should contain_class('cloudera::cm5::repo').with_ensure('present') }
      it { should contain_class('cloudera::cdh::repo').with_ensure('present') }
      it { should contain_class('cloudera::cdh').with_ensure('present') }
      it { should contain_class('cloudera::impala::repo').with_ensure('present') }
      it { should contain_class('cloudera::impala').with_ensure('present') }
      it { should contain_class('cloudera::search::repo').with_ensure('present') }
      it { should contain_class('cloudera::search').with_ensure('present') }
      it { should_not contain_class('cloudera::cdh5::repo') }
      it { should_not contain_class('cloudera::cdh5') }
      it { should_not contain_class('cloudera::gplextras::repo') }
      it { should_not contain_class('cloudera::gplextras') }
      it { should_not contain_class('cloudera::gplextras5::repo') }
      it { should_not contain_class('cloudera::gplextras5') }
      it { should_not contain_class('cloudera::lzo') }
    end

    describe 'use_parcels => false, install_lzo => true' do
      let(:params) {{ :use_parcels => false, :install_lzo => true }}
      it { should contain_class('cloudera::gplextras5::repo') }
      it { should contain_class('cloudera::gplextras5') }
      it { should contain_class('cloudera::lzo') }
    end

    describe 'install_lzo => true' do
      let(:params) {{ :install_lzo => true }}
      it { should contain_class('cloudera::lzo') }
      it { should_not contain_class('cloudera::gplextras5::repo') }
      it { should_not contain_class('cloudera::gplextras5') }
    end

    describe 'use_parcels => false, install_lzo => true, cdh_version => 5, cg_version => 4' do
      let :params do {
        :use_parcels => false,
        :install_lzo => true,
        :cm_version  => '5',
        :cdh_version => '5',
        :cg_version  => '4'
      }
      end
      it do
        expect {
          should raise_error(Puppet::Error, /Parameter \$cg_version must be 5 if \$cdh_version is 5./)
        }
      end
    end

    describe 'install_java => false' do
      let(:params) {{ :install_java => false }}
      it { should_not contain_class('cloudera::java5') }
      it { should_not contain_class('cloudera::java5::jce') }
    end

    describe 'install_jce => true' do
      let(:params) {{ :install_jce => true }}
      it { should contain_class('cloudera::java5').with_ensure('present') }
      it { should contain_class('cloudera::java5::jce').with_ensure('present') }
    end

    describe 'install_cmserver => true' do
      let(:params) {{ :install_cmserver => true }}
      it { should contain_class('cloudera::cm5::server').with_ensure('present') }
    end
  end

  context 'on a supported operatingsystem, custom parameters, cm_version => 4' do
    let :facts do {
      :osfamily               => 'RedHat',
      :operatingsystem        => 'CentOS',
      :operatingsystemrelease => '6.0'
    }
    end

    describe 'ensure => absent' do
      let(:params) {{ :ensure => 'absent', :cm_version => '4' }}
      it { should contain_class('cloudera::java').with_ensure('absent') }
      it { should contain_class('cloudera::cm').with_ensure('absent') }
      it { should contain_class('cloudera::cm::repo').with_ensure('absent') }
    end

    describe 'use_parcels => false' do
      let(:params) {{ :use_parcels => false, :cm_version => '4' }}
      it { should contain_class('cloudera::java').with_ensure('present') }
      it { should contain_class('cloudera::cm').with_ensure('present') }
      it { should contain_class('cloudera::cm::repo').with_ensure('present') }
      it { should contain_class('cloudera::cdh::repo').with_ensure('present') }
      it { should contain_class('cloudera::cdh').with_ensure('present') }
      it { should contain_class('cloudera::impala::repo').with_ensure('present') }
      it { should contain_class('cloudera::impala').with_ensure('present') }
      it { should contain_class('cloudera::search::repo').with_ensure('present') }
      it { should contain_class('cloudera::search').with_ensure('present') }
      it { should_not contain_class('cloudera::gplextras::repo') }
      it { should_not contain_class('cloudera::gplextras') }
      it { should_not contain_class('cloudera::gplextras5::repo') }
      it { should_not contain_class('cloudera::gplextras5') }
      it { should_not contain_class('cloudera::lzo') }
    end

    describe 'use_parcels => false, install_lzo => true' do
      let :params do {
        :use_parcels => false,
        :install_lzo => true,
        :cm_version  => '4',
        :cg_version  => '4'
      }
      end
      it { should contain_class('cloudera::gplextras::repo') }
      it { should contain_class('cloudera::gplextras') }
      it { should contain_class('cloudera::lzo') }
    end

    describe 'install_lzo => true' do
      let(:params) {{ :install_lzo => true, :cm_version => '4' }}
      it { should contain_class('cloudera::lzo') }
      it { should_not contain_class('cloudera::gplextras::repo') }
      it { should_not contain_class('cloudera::gplextras') }
    end

    describe 'use_parcels => false, install_lzo => true, cdh_version => 4, cg_version => 5' do
      let :params do {
        :use_parcels => false,
        :install_lzo => true,
        :cm_version  => '4',
        :cdh_version => '4',
        :cg_version  => '5'
      }
      end
      it do
        expect {
          should raise_error(Puppet::Error, /Parameter \$cg_version must be 4 if \$cdh_version is 4./)
        }
      end
    end

    describe 'install_java => false' do
      let(:params) {{ :install_java => false, :cm_version => '4' }}
      it { should_not contain_class('cloudera::java') }
      it { should_not contain_class('cloudera::java::jce') }
    end

    describe 'install_jce => true' do
      let(:params) {{ :install_jce => true, :cm_version => '4' }}
      it { should contain_class('cloudera::java').with_ensure('present') }
      it { should contain_class('cloudera::java::jce').with_ensure('present') }
    end

    describe 'install_cmserver => true' do
      let(:params) {{ :install_cmserver => true, :cm_version => '4' }}
      it { should contain_class('cloudera::cm::server').with_ensure('present') }
    end
  end

  context 'on a supported operatingsystem, custom parameters, cm_version => blah' do
    let(:params) {{ :cm_version => 'blah' }}
    let :facts do {
      :osfamily               => 'RedHat',
      :operatingsystem        => 'CentOS',
      :operatingsystemrelease => '6.0'
    }
    end
    it do
      expect {
        should raise_error(Puppet::Error, /Parameter \$cm_version must start with either 4 or 5./)
      }
    end
  end

end
