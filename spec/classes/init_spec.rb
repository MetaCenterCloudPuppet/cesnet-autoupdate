require 'spec_helper'

describe 'autoupdate' do

  $test_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'without and parameters' do
        it { should compile.with_all_deps }
        it { should contain_class('autoupdate') }
      end
    end
  end

  context 'on unsupported operating system' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it {
        expect {
         should contain_class('autoupdate')
        }.to raise_error(Puppet::Error, /Solaris\/Nexenta not supported/)
      }
  end
end
