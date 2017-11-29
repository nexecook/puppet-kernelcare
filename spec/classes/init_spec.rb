require 'spec_helper'

describe 'kernelcare' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end
        it { should contain_anchor('kernelcare::begin') }
        it { should contain_class('kernelcare') }
        it { should contain_class('kernelcare::params') }
        it { should contain_class('kernelcare::repo') }
        it { should contain_class('kernelcare::install') }
        it { should contain_class('kernelcare::config') }
        it { should contain_class('kernelcare::service') }
        it { should contain_class('kernelcare::cron') }
        it { should contain_anchor('kernelcare::end') }

        describe "kernelcare::repo" do
          case facts[:osfamily]
          when 'RedHat'
            it { should contain_yumrepo('kernelcare').with_descr('kernelcare') }
            it { should contain_yumrepo('kernelcare').with_enabled(1) }
            it { should contain_yumrepo('kernelcare').with_gpgcheck(1) }
            it { should contain_yumrepo('kernelcare').with_gpgkey('https://repo.cloudlinux.com/kernelcare/RPM-GPG-KEY-KernelCare') }
            it { should contain_yumrepo('kernelcare').with_baseurl("https://repo.cloudlinux.com/kernelcare/$releasever/$basearch/") }

            describe 'allow custom name' do
              let(:params) { {:repo_name => 'kcare' } }
              it { should contain_yumrepo('kcare') }
            end
            describe 'allow custom repo_yum_baseurl_prefix' do
              let(:params) { {:repo_yum_baseurl_prefix => 'http://mirror.example.com/kernelcare/' } }
              it { should contain_yumrepo('kernelcare').with_basurl =~ %r{^http://mirror.example.com/kernelcare/} }
            end

            describe 'allow custom description' do
              let(:params) { {:repo_descr => 'kcare' } }
              it { should contain_yumrepo('kernelcare').with_descr('kcare') }
            end

            describe 'allow custom enabled' do
              let(:params) { {:repo_enabled => false } }
              it { should contain_yumrepo('kernelcare').with_enabled(0) }
            end

            describe 'allow custom gpgcheck' do
              let(:params) { {:repo_gpgcheck => false } }
              it { should contain_yumrepo('kernelcare').with_gpgcheck(0) }
            end

            describe 'allow custom gpgkey' do
              let(:params) { {:repo_gpgkey => 'https://mirror.example.com/kernelcare/yum/RPM-GPG-KEY-kernelcare' } }
              it { should contain_yumrepo('kernelcare').with_gpgkey('https://mirror.example.com/kernelcare/yum/RPM-GPG-KEY-kernelcare') }
            end

            describe 'allow repo_install = false' do
              let(:params) { {:repo_install => false } }
              it { should_not contain_yumrepo('kernelcare') }
            end
          when 'Debian'
            it { should contain_apt__source('kernelcare').with_location('https://repo.cloudlinux.com/kernelcare-debian/8') }
            it { should contain_apt__source('kernelcare').with_release('stable') }
            it { should contain_apt__source('kernelcare').with_repos('main') }
            it { should contain_apt__source('kernelcare').with_key('id' => '6DC3D600CDEF74BB', 'source' => 'https://repo.cloudlinux.com/kernelcare-debian/8/conf/kcaredsa_pub.gpg') }

            describe 'allow custom name' do
              let(:params) { {:repo_name => 'kcare' } }
              it { should contain_apt__source('kcare') }
            end
            describe 'allow custom key id and source' do
              let(:params) { {:repo_key_id => 'ABCD1234', :repo_key_source => 'https://example.com/key.asc' } }
              it { should contain_apt__source('kernelcare').with_key('id' => 'ABCD1234', 'source' => 'https://example.com/key.asc') }
            end
            describe 'allow repo_install = false' do
              let(:params) { {:repo_install => false } }
              it { should_not contain_apt__source('kernelcare') }
            end
            describe 'allow custom release' do
              let(:params) { {:repo_apt_release => 'unstable' } }
              it { should contain_apt__source('kernelcare').with_release('unstable') }
            end
            describe 'allow custom repos' do
              let(:params) { {:repo_apt_repos => 'foo bar baz' } }
              it { should contain_apt__source('kernelcare').with_repos('foo bar baz') }
            end
          end
        end

        describe "kernelcare::install" do
          it { should contain_package('kernelcare') }
          describe 'allow custom version' do
            let(:params) { {:package_ensure => '1.2.3' } }
            it { should contain_package('kernelcare').with_ensure('1.2.3') }
          end
        end

        describe "kernelcare::cron" do
          it { should contain_file('/etc/cron.d/kcare-cron').with_ensure('absent') }
          it { should contain_cron('kernelcare').with_command('PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin /usr/bin/kcarectl --auto-update >/dev/null 2>&1' ) }
          it { should contain_cron('kernelcare').with_hour('*') }
          it { should contain_cron('kernelcare').with_month('*') }
          it { should contain_cron('kernelcare').with_monthday('*') }
          it { should contain_cron('kernelcare').with_weekday('*') }

          describe 'allow custom cron minute' do
            let(:params) { {:cron_minute => '0,15,30,45' } }
            it { should contain_cron('kernelcare').with_minute('0,15,30,45') }
          end

          describe 'allow custom cron hour' do
            let(:params) { {:cron_hour => '3' } }
            it { should contain_cron('kernelcare').with_hour('3') }
          end

          describe 'allow custom cron month' do
            let(:params) { {:cron_month => '14' } }
            it { should contain_cron('kernelcare').with_month('14') }
          end

          describe 'allow custom cron monthday' do
            let(:params) { {:cron_monthday => '15' } }
            it { should contain_cron('kernelcare').with_monthday('15') }
          end

          describe 'allow custom cron weekday' do
            let(:params) { {:cron_weekday => '4' } }
            it { should contain_cron('kernelcare').with_weekday('4') }
          end

          describe 'allow cron_manage = false' do
            let(:params) { {:cron_manage => false } }
            it { should_not contain_cron('kernelcare') }
          end

          describe 'allow cron_ensure = absent' do
            let(:params) { {:cron_ensure => 'absent' } }
            it { should contain_cron('kernelcare').with_ensure('absent') }
          end

        end

        describe "kernelcare::config" do
          it { should contain_file('/etc/sysconfig/kcare/kcare.conf').with_owner('root') }
          it { should contain_file('/etc/sysconfig/kcare/kcare.conf').with_group('root') }
          it { should contain_file('/etc/sysconfig/kcare/kcare.conf').with_mode('0640') }
          it { should contain_file('/etc/sysconfig/kcare/kcare.conf').with_content(/AUTO_UPDATE=True/) }
          it { should contain_file('/etc/sysconfig/kcare/freezer.modules.blacklist').with_owner('root') }
          it { should contain_file('/etc/sysconfig/kcare/freezer.modules.blacklist').with_group('root') }
          it { should contain_file('/etc/sysconfig/kcare/freezer.modules.blacklist').with_mode('0640') }
          ['vxodm', 'vxportal', 'vxfen', 'vxspec', 'vxio'].each do |kmod|
            it { should contain_file('/etc/sysconfig/kcare/freezer.modules.blacklist').with_content(/#{kmod}/) }
          end

          describe 'allow custom template for kcare.conf' do
            let(:params) { {:config_template_kcare => 'custom_templates/kcare.conf.erb' } }
            it { should contain_file('/etc/sysconfig/kcare/kcare.conf').with_content(/herp-a-derp/) }
          end

          describe 'allow custom template for kcare.conf' do
            let(:params) { {:config_template_kmod_blacklist => 'custom_templates/kcare.conf.erb' } }
            it { should contain_file('/etc/sysconfig/kcare/freezer.modules.blacklist').with_content(/herp-a-derp/) }
          end

          describe 'disable auto updating' do
            let(:params) { {:config_autoupdate => false } }
            it { should contain_file('/etc/sysconfig/kcare/kcare.conf').with_content(/AUTO_UPDATE=False/) }
          end

          describe 'set freezer module blacklist' do
            [['foo','bar','baz']].each do |ary|
            let(:params) { {:config_kmod_blacklist => ary } }
              ary.each do |kmod|
                it { should contain_file('/etc/sysconfig/kcare/freezer.modules.blacklist').with_content(/#{kmod}/) }
              end
            end
          end

          describe 'set accesskey' do
            let(:params) { {:config_accesskey => 'deadbeef', :config_managekey => true} }
            it { should contain_kernelcare_register('deadbeef') }
          end
        end

        describe "kernelcare::service" do
          it { should contain_service('kcare') }
          it { should contain_service('kcare').with_ensure('running') }

          describe 'allow custom service name' do
            let(:params) { {:service_name => 'carebear'} }
            it { should contain_service('carebear') }
            it { should contain_service('carebear').with_ensure('running') }
          end

          describe 'allow stopping the service' do
            let(:params) { {:service_ensure => 'stopped'} }
            it { should contain_service('kcare').with_ensure('stopped') }
          end
        end
      end
    end
  end
end

