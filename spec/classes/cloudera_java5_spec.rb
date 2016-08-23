#!/usr/bin/env rspec

require 'spec_helper'

describe 'cloudera::java5', :type => 'class' do

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
    describe 'RedHat/SuSe' do
      let :facts do {
        :osfamily               => 'RedHat',
        :operatingsystem        => 'CentOS',
        :operatingsystemrelease => '6.0'
      }
      end
      it { should compile.with_all_deps }
      it { should contain_package('jdk').with_ensure('present').with_name('oracle-j2sdk1.7') }
      it { should contain_file('java-profile.d').with(
        :ensure => 'present',
        :path   => '/etc/profile.d/java.sh',
        :mode   => '0755',
        :owner  => 'root',
        :group  => 'root'
      )}
      it { should contain_file('/usr/java/_mklinks.sh').with(
        :ensure => 'present',
        :path   => '/usr/java/_mklinks.sh',
        :mode   => '0744',
        :owner  => 'root',
        :group  => 'root'
      )}
      it { should contain_exec('/usr/java/_mklinks.sh').with(
        :command     => '/usr/java/_mklinks.sh',
        :refreshonly => 'true',
        :path        => '/bin:/usr/bin:/sbin:/usr/sbin',
        :require     => [ 'Anchor[cloudera::java5::begin]', 'File[/usr/java/_mklinks.sh]', ],
        :subscribe   => 'Package[jdk]'
      )}
      it { should contain_exec('java-alternatives').with(
        :command => 'update-alternatives --install /usr/bin/java java /usr/java/default/bin/java 1601 \
--slave /usr/bin/keytool keytool /usr/java/default/bin/keytool \
--slave /usr/bin/orbd orbd /usr/java/default/bin/orbd \
--slave /usr/bin/pack200 pack200 /usr/java/default/bin/pack200 \
--slave /usr/bin/rmid rmid /usr/java/default/bin/rmid \
--slave /usr/bin/rmiregistry rmiregistry /usr/java/default/bin/rmiregistry \
--slave /usr/bin/servertool servertool /usr/java/default/bin/servertool \
--slave /usr/bin/tnameserv tnameserv /usr/java/default/bin/tnameserv \
--slave /usr/bin/unpack200 unpack200 /usr/java/default/bin/unpack200 \
--slave /usr/bin/ControlPanel ControlPanel /usr/java/default/bin/ControlPanel \
--slave /usr/bin/jcontrol jcontrol /usr/java/default/bin/jcontrol \
--slave /usr/share/man/man1/java.1 java.1.gz /usr/java/default/man/man1/java.1 \
--slave /usr/share/man/man1/keytool.1 keytool.1.gz /usr/java/default/man/man1/keytool.1 \
--slave /usr/share/man/man1/orbd.1 orbd.1.gz /usr/java/default/man/man1/orbd.1 \
--slave /usr/share/man/man1/pack200.1 pack200.1.gz /usr/java/default/man/man1/pack200.1 \
--slave /usr/share/man/man1/rmid.1 rmid.1.gz /usr/java/default/man/man1/rmid.1 \
--slave /usr/share/man/man1/rmiregistry.1 rmiregistry.1.gz /usr/java/default/man/man1/rmiregistry.1 \
--slave /usr/share/man/man1/servertool.1 servertool.1.gz /usr/java/default/man/man1/servertool.1 \
--slave /usr/share/man/man1/tnameserv.1 tnameserv.1.gz /usr/java/default/man/man1/tnameserv.1 \
--slave /usr/share/man/man1/unpack200.1 unpack200.1.gz /usr/java/default/man/man1/unpack200.1',
        :unless  => 'update-alternatives --display java | grep -q /usr/java/default/bin/java',
        :path    => '/bin:/usr/bin:/sbin:/usr/sbin',
        :require => 'Package[jdk]'
      )}
      it { should contain_exec('javac-alternatives').with(
        :command => 'update-alternatives --install /usr/bin/javac javac /usr/java/default/bin/javac 1601 \
--slave /usr/bin/appletviewer appletviewer /usr/java/default/bin/appletviewer \
--slave /usr/bin/apt apt /usr/java/default/bin/apt \
--slave /usr/bin/extcheck extcheck /usr/java/default/bin/extcheck \
--slave /usr/bin/idlj idlj /usr/java/default/bin/idlj \
--slave /usr/bin/jar jar /usr/java/default/bin/jar \
--slave /usr/bin/jarsigner jarsigner /usr/java/default/bin/jarsigner \
--slave /usr/bin/javadoc javadoc /usr/java/default/bin/javadoc \
--slave /usr/bin/javah javah /usr/java/default/bin/javah \
--slave /usr/bin/javap javap /usr/java/default/bin/javap \
--slave /usr/bin/jconsole jconsole /usr/java/default/bin/jconsole \
--slave /usr/bin/jdb jdb /usr/java/default/bin/jdb \
--slave /usr/bin/jhat jhat /usr/java/default/bin/jhat \
--slave /usr/bin/jinfo jinfo /usr/java/default/bin/jinfo \
--slave /usr/bin/jmap jmap /usr/java/default/bin/jmap \
--slave /usr/bin/jps jps /usr/java/default/bin/jps \
--slave /usr/bin/jrunscript jrunscript /usr/java/default/bin/jrunscript \
--slave /usr/bin/jsadebugd jsadebugd /usr/java/default/bin/jsadebugd \
--slave /usr/bin/jstack jstack /usr/java/default/bin/jstack \
--slave /usr/bin/jstat jstat /usr/java/default/bin/jstat \
--slave /usr/bin/jstatd jstatd /usr/java/default/bin/jstatd \
--slave /usr/bin/native2ascii native2ascii /usr/java/default/bin/native2ascii \
--slave /usr/bin/policytool policytool /usr/java/default/bin/policytool \
--slave /usr/bin/rmic rmic /usr/java/default/bin/rmic \
--slave /usr/bin/schemagen schemagen /usr/java/default/bin/schemagen \
--slave /usr/bin/serialver serialver /usr/java/default/bin/serialver \
--slave /usr/bin/wsgen wsgen /usr/java/default/bin/wsgen \
--slave /usr/bin/wsimport wsimport /usr/java/default/bin/wsimport \
--slave /usr/bin/xjc xjc /usr/java/default/bin/xjc \
--slave /usr/bin/jvisualvm jvisualvm /usr/java/default/bin/jvisualvm \
--slave /usr/share/man/man1/appletviewer.1 appletviewer.1.gz /usr/java/default/man/man1/appletviewer.1 \
--slave /usr/share/man/man1/apt.1 apt.1.gz /usr/java/default/man/man1/apt.1 \
--slave /usr/share/man/man1/extcheck.1 extcheck.1.gz /usr/java/default/man/man1/extcheck.1 \
--slave /usr/share/man/man1/idlj.1 idlj.1.gz /usr/java/default/man/man1/idlj.1 \
--slave /usr/share/man/man1/jar.1 jar.1.gz /usr/java/default/man/man1/jar.1 \
--slave /usr/share/man/man1/jarsigner.1 jarsigner.1.gz /usr/java/default/man/man1/jarsigner.1 \
--slave /usr/share/man/man1/javac.1 javac.1.gz /usr/java/default/man/man1/javac.1 \
--slave /usr/share/man/man1/javadoc.1 javadoc.1.gz /usr/java/default/man/man1/javadoc.1 \
--slave /usr/share/man/man1/javah.1 javah.1.gz /usr/java/default/man/man1/javah.1 \
--slave /usr/share/man/man1/javap.1 javap.1.gz /usr/java/default/man/man1/javap.1 \
--slave /usr/share/man/man1/jconsole.1 jconsole.1.gz /usr/java/default/man/man1/jconsole.1 \
--slave /usr/share/man/man1/jdb.1 jdb.1.gz /usr/java/default/man/man1/jdb.1 \
--slave /usr/share/man/man1/jhat.1 jhat.1.gz /usr/java/default/man/man1/jhat.1 \
--slave /usr/share/man/man1/jinfo.1 jinfo.1.gz /usr/java/default/man/man1/jinfo.1 \
--slave /usr/share/man/man1/jmap.1 jmap.1.gz /usr/java/default/man/man1/jmap.1 \
--slave /usr/share/man/man1/jps.1 jps.1.gz /usr/java/default/man/man1/jps.1 \
--slave /usr/share/man/man1/jrunscript.1 jrunscript.1.gz /usr/java/default/man/man1/jrunscript.1 \
--slave /usr/share/man/man1/jsadebugd.1 jsadebugd.1.gz /usr/java/default/man/man1/jsadebugd.1 \
--slave /usr/share/man/man1/jstack.1 jstack.1.gz /usr/java/default/man/man1/jstack.1 \
--slave /usr/share/man/man1/jstat.1 jstat.1.gz /usr/java/default/man/man1/jstat.1 \
--slave /usr/share/man/man1/jstatd.1 jstatd.1.gz /usr/java/default/man/man1/jstatd.1 \
--slave /usr/share/man/man1/native2ascii.1 native2ascii.1.gz /usr/java/default/man/man1/native2ascii.1 \
--slave /usr/share/man/man1/policytool.1 policytool.1.gz /usr/java/default/man/man1/policytool.1 \
--slave /usr/share/man/man1/rmic.1 rmic.1.gz /usr/java/default/man/man1/rmic.1 \
--slave /usr/share/man/man1/schemagen.1 schemagen.1.gz /usr/java/default/man/man1/schemagen.1 \
--slave /usr/share/man/man1/serialver.1 serialver.1.gz /usr/java/default/man/man1/serialver.1 \
--slave /usr/share/man/man1/wsgen.1 wsgen.1.gz /usr/java/default/man/man1/wsgen.1 \
--slave /usr/share/man/man1/wsimport.1 wsimport.1.gz /usr/java/default/man/man1/wsimport.1 \
--slave /usr/share/man/man1/xjc.1 xjc.1.gz /usr/java/default/man/man1/xjc.1 \
--slave /usr/share/man/man1/jvisualvm.1 jvisualvm.1.gz /usr/java/default/man/man1/jvisualvm.1',
        :unless  => 'update-alternatives --display javac | grep -q /usr/java/default/bin/javac',
        :path    => '/bin:/usr/bin:/sbin:/usr/sbin',
        :require => 'Package[jdk]'
      )}
      it { should contain_exec('javaplugin-alternatives').with(
        :command => 'mkdir -p /usr/lib64/mozilla/plugins; update-alternatives --install /usr/lib64/mozilla/plugins/libjavaplugin.so libjavaplugin.so.x86_64 /usr/java/default/jre/lib/amd64/libnpjp2.so 1601 \
--slave /usr/bin/javaws javaws /usr/java/default/bin/javaws \
--slave /usr/share/man/man1/javaws.1 javaws.1.gz /usr/java/default/man/man1/javaws.1',
        :unless  => 'update-alternatives --display libjavaplugin.so.x86_64 | grep -q /usr/java/default/jre/lib/amd64/libnpjp2.so',
        :path    => '/bin:/usr/bin:/sbin:/usr/sbin',
        :require => 'Package[jdk]'
      )}
      it { should contain_exec('java-alternatives-old').with(
        :command => 'update-alternatives --remove java /usr/java/default/jre/bin/java',
        :onlyif  => 'update-alternatives --display java | grep -q /usr/java/default/jre/bin/java',
        :path    => '/bin:/usr/bin:/sbin:/usr/sbin',
        :require => 'Package[jdk]'
      )}
    end

    describe 'Debian' do
      let :facts do {
        :osfamily               => 'Debian',
        :operatingsystem        => 'Debian',
        :operatingsystemrelease => '7'
      }
      end
      it { should compile.with_all_deps }
      it { should contain_package('jdk').with_ensure('present').with_name('oracle-j2sdk1.7') }
      it { should contain_file('java-profile.d').with(
        :ensure => 'present',
        :path   => '/etc/profile.d/java.sh',
        :mode   => '0755',
        :owner  => 'root',
        :group  => 'root'
      )}
      it { should_not contain_exec('java-alternatives-old') }
      it { should_not contain_exec('java-alternatives') }
      it { should_not contain_exec('javac-alternatives') }
      it { should_not contain_exec('javaplugin-alternatives') }
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
      it { should contain_package('jdk').with_ensure('absent') }
      it { should contain_file('java-profile.d').with_ensure('absent') }
      it { should contain_exec('java-alternatives').with(
        :command => 'update-alternatives --remove java /usr/java/default/bin/java',
        :onlyif  => 'update-alternatives --display java | grep -q /usr/java/default/bin/java',
        :path    => '/bin:/usr/bin:/sbin:/usr/sbin',
        :before  => 'Package[jdk]'
      )}
      it { should contain_exec('javac-alternatives').with(
        :command => 'update-alternatives --remove javac /usr/java/default/bin/javac',
        :onlyif  => 'update-alternatives --display javac | grep -q /usr/java/default/bin/javac',
        :path    => '/bin:/usr/bin:/sbin:/usr/sbin',
        :before  => 'Package[jdk]'
      )}
      it { should contain_exec('javaplugin-alternatives').with(
        :command => 'update-alternatives --remove libjavaplugin.so.x86_64 /usr/java/default/jre/lib/amd64/libnpjp2.so',
        :onlyif  => 'update-alternatives --display libjavaplugin.so.x86_64 | grep -q /usr/java/default/jre/lib/amd64/libnpjp2.so',
        :path    => '/bin:/usr/bin:/sbin:/usr/sbin',
        :before  => 'Package[jdk]'
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
      it { should contain_package('jdk').with_ensure('latest') }
      it { should contain_file('java-profile.d').with_ensure('present') }
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

  end
end
