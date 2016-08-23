#!/usr/bin/env rspec

require 'spec_helper'

describe 'cloudera::cdh::oozie::ext', :type => 'class' do

#  context 'on a non-supported operatingsystem' do
#    let :facts do {
#      :osfamily        => 'foo',
#      :operatingsystem => 'bar'
#    }
#    end
#    it 'should fail' do
#      expect {
#        should raise_error(Puppet::Error, /Module cloudera is not supported on bar/)
#      }
#    end
#  end

  context 'on a supported operatingsystem, default parameters' do
    let(:params) {{}}
    let :facts do {
      :osfamily               => 'RedHat',
      :operatingsystem        => 'CentOS',
      :operatingsystemrelease => '6.0'
    }
    end
    it { should contain_staging__deploy('ext-2.2.zip').with(
      :source => 'http://archive.cloudera.com/gplextras/misc/ext-2.2.zip',
      :target => '/usr/lib/oozie/libext'
    )}
  end
end
