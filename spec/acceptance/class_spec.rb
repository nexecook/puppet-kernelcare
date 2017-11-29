require 'spec_helper_acceptance'

describe 'kernelcare class' do

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work idempotently with no errors' do
      pp = <<-EOS
      class { 'kernelcare': }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end


    describe "kernelcare::repo" do
      case fact('operatingsystem')
      when 'CentOS', 'RedHat'
        describe yumrepo('kernelcare') do
          it { is_expected.to exist }
          it { is_expected.to be_enabled }
        end
      end
    end

    describe "kernelcare::install" do
      describe package('kernelcare') do
        it { is_expected.to be_installed }
      end
    end

    describe "kernelcare::config" do
      describe file('/etc/sysconfig/kcare/kcare.conf') do
        it { is_expected.to exist }
        it { is_expected.to be_mode(640) }
        it { is_expected.to be_owned_by('root') }
        it { is_expected.to be_grouped_into('root') }
        it { is_expected.to contain('AUTO_UPDATE=True') }
      end
      describe file('/etc/sysconfig/kcare/freezer.modules.blacklist') do
        it { is_expected.to exist }
        it { is_expected.to be_mode(640) }
        it { is_expected.to be_owned_by('root') }
        it { is_expected.to be_grouped_into('root') }
        it { is_expected.to contain('vxodm') }
        it { is_expected.to contain('vxportal') }
        it { is_expected.to contain('vxfen') }
        it { is_expected.to contain('vxspec') }
        it { is_expected.to contain('vxio') }
      end
    end

    describe "kernelcare::cron" do
       #describe cron('kernelcare') do
       #  it { is_expected.to have_entry('PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin /usr/bin/kcarectl --auto-update >/dev/null 2>&1' ).with_user('root')}
       #end

      describe file('/etc/cron.d/kcare-cron') do
        it { is_expected.to_not exist }
      end
    end

    if ! ENV['KERNELCARE_LICENSE'].nil?
      context 'with a kernelcare license' do
        # Using puppet_apply as a helper
        it 'should work idempotently with no errors' do
          pp = <<-EOS
          class { 'kernelcare': config_accesskey=>#{ENV['KERNELCARE_LICENSE']}}
          EOS

          # Run it twice and test for idempotency
          apply_manifest(pp, :catch_failures => true)
          apply_manifest(pp, :catch_changes  => true)
        end

        it 'should upgrade the kernel' do
          shell('/usr/sbin/kcarectl --auto-update >/dev/null 2>&1')
          shell(%q{test "$(uname -r)" != "$(kcare-uname -r)"}, :acceptable_exit_codes => 0)
        end
      end
    end
  end
end

