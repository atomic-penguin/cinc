# frozen_string_literal: true
#
# Copyright:: Copyright (c) Chef Software Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require "spec_helper"
require "fauxhai"

def platform_reports_true_for(*args)
  args.each do |method|
    if method.match?("centos_stream_platform")
      it "reports true for #{method} on the module given a node" do
        expect(described_class.send(method)).to be true
      end
      it "reports true for #{method} when mixed into a class with a node" do
        expect(thing_with_a_node.send(method)).to be true
      end
      it "reports true for #{method} when mixed into a class with a run_context" do
        expect(thing_with_a_run_context.send(method)).to be true
      end
      it "reports true for #{method} when mixed into a class with the dsl" do
        expect(thing_with_the_dsl.send(method)).to be true
      end
      it "reports true for #{method} on the main class give a node" do
        expect(ChefUtils.send(method)).to be true
      end
    else
      it "reports true for #{method} on the module given a node" do
        expect(described_class.send(method, node)).to be true
      end
      it "reports true for #{method} when mixed into a class with a node" do
        expect(thing_with_a_node.send(method, node)).to be true
      end
      it "reports true for #{method} when mixed into a class with a run_context" do
        expect(thing_with_a_run_context.send(method, node)).to be true
      end
      it "reports true for #{method} when mixed into a class with the dsl" do
        expect(thing_with_the_dsl.send(method, node)).to be true
      end
      it "reports true for #{method} on the main class give a node" do
        expect(ChefUtils.send(method, node)).to be true
      end
    end
  end
  (PLATFORM_HELPERS - ChefUtils::DSL::TrainHelpers.methods - args).each do |method|
    if method.match?("centos_stream_platform")
      it "reports false for #{method} on the module given a node" do
        expect(described_class.send(method)).to be false
      end
      it "reports false for #{method} when mixed into a class with a node" do
        expect(thing_with_a_node.send(method)).to be false
      end
      it "reports false for #{method} when mixed into a class with the dsl" do
        expect(thing_with_the_dsl.send(method)).to be false
      end
      it "reports false for #{method} on the main class give a node" do
        expect(ChefUtils.send(method)).to be false
      end
    else
      it "reports false for #{method} on the module given a node" do
        expect(described_class.send(method, node)).to be false
      end
      it "reports false for #{method} when mixed into a class with a node" do
        expect(thing_with_a_node.send(method, node)).to be false
      end
      it "reports false for #{method} when mixed into a class with the dsl" do
        expect(thing_with_the_dsl.send(method, node)).to be false
      end
      it "reports false for #{method} on the main class give a node" do
        expect(ChefUtils.send(method, node)).to be false
      end
    end
  end
end

RSpec.describe ChefUtils::DSL::Platform do
  let(:node) { Fauxhai.mock(options).data }

  class ThingWithANode
    include ChefUtils::DSL::Platform
    attr_accessor :node

    def initialize(node)
      @node = node
    end
  end

  class ThingWithARunContext
    include ChefUtils::DSL::Platform
    class RunContext
      attr_accessor :node
    end
    attr_accessor :run_context

    def initialize(node)
      @run_context = RunContext.new
      run_context.node = node
    end
  end

  class ThingWithTheDSL
    include ChefUtils
    attr_accessor :node

    def initialize(node)
      @node = node
    end
  end

  let(:thing_with_a_node) { ThingWithANode.new(node) }
  let(:thing_with_a_run_context) { ThingWithARunContext.new(node) }
  let(:thing_with_the_dsl) { ThingWithTheDSL.new(node) }

  ( HELPER_MODULES - [ described_class ] ).each do |klass|
    it "does not have methods that collide with #{klass}" do
      expect((klass.methods - Module.methods - ChefUtils::DSL::TrainHelpers.methods ) & PLATFORM_HELPERS).to be_empty
    end
  end

  context "on ubuntu" do
    let(:options) { { platform: "ubuntu" } }

    platform_reports_true_for(:ubuntu?, :ubuntu_platform?)
  end

  context "on raspbian" do
    let(:options) { { platform: "raspbian" } }

    platform_reports_true_for(:raspbian?, :raspbian_platform?)
  end

  context "on linuxmint" do
    let(:options) { { platform: "linuxmint" } }

    platform_reports_true_for(:mint?, :linux_mint?, :linuxmint?, :linuxmint_platform?)
  end

  context "on debian" do
    let(:options) { { platform: "debian" } }

    platform_reports_true_for(:debian_platform?)
  end

  context "on aix" do
    let(:options) { { platform: "aix" } }

    platform_reports_true_for(:aix_platform?)
  end

  context "on amazon" do
    let(:options) { { platform: "amazon" } }

    platform_reports_true_for(:amazon_platform?)
  end

  context "on arch" do
    let(:options) { { platform: "arch" } }

    platform_reports_true_for(:arch_platform?)
  end

  context "on centos" do
    let(:options) { { platform: "centos" } }

    platform_reports_true_for(:centos?, :centos_platform?)
  end

  context "on clearos" do
    let(:options) { { platform: "clearos" } }

    platform_reports_true_for(:clearos?, :clearos_platform?)
  end

  context "on dragonfly4" do
    let(:options) { { platform: "dragonfly4" } }

    platform_reports_true_for(:dragonfly_platform?)
  end

  context "on fedora" do
    let(:options) { { platform: "fedora" } }

    platform_reports_true_for(:fedora_platform?)
  end

  context "on freebsd" do
    let(:options) { { platform: "freebsd" } }

    platform_reports_true_for(:freebsd_platform?)
  end

  context "on gentoo" do
    let(:options) { { platform: "gentoo" } }

    platform_reports_true_for(:gentoo_platform?)
  end

  context "on mac_os_x" do
    let(:options) { { platform: "mac_os_x" } }

    platform_reports_true_for(:mac_os_x_platform?, :macos_platform?)
  end

  context "on openbsd" do
    let(:options) { { platform: "openbsd" } }

    platform_reports_true_for(:openbsd_platform?)
  end

  context "on oracle" do
    let(:options) { { platform: "oracle" } }

    platform_reports_true_for(:oracle?, :oracle_linux?, :oracle_platform?)
  end

  context "on redhat" do
    let(:options) { { platform: "redhat" } }

    platform_reports_true_for(:redhat?, :redhat_enterprise_linux?, :redhat_enterprise?, :redhat_platform?)
  end

  context "on smartos" do
    let(:options) { { platform: "smartos" } }

    platform_reports_true_for(:smartos_platform?)
  end

  context "on solaris2" do
    let(:options) { { platform: "solaris2" } }

    platform_reports_true_for(:solaris2_platform?)
  end

  context "on suse" do
    let(:options) { { platform: "suse" } }

    platform_reports_true_for(:suse_platform?)
  end

  context "on windows" do
    let(:options) { { platform: "windows" } }

    platform_reports_true_for(:windows_platform?)
  end

  context "on opensuseleap" do
    let(:node) { { "platform" => "opensuseleap", "platform_version" => "15.1", "platform_family" => "suse", "os" => "linux" } }

    platform_reports_true_for(:opensuse_platform?, :opensuseleap_platform?, :opensuse?, :leap_platform?)
  end

  context "on opensuse" do
    let(:node) { { "platform" => "opensuse", "platform_version" => "11.0", "platform_family" => "suse", "os" => "linux" } }

    platform_reports_true_for(:opensuse_platform?, :opensuseleap_platform?, :opensuse?, :leap_platform?)
  end

end

RSpec.describe ChefUtils::DSL::Platform do
  class PlatformTestClass
    include ChefUtils::DSL::Platform
  end

  let(:test_instance) { PlatformTestClass.new }

  let(:os_release_stream) do
    <<~OS_RELEASE
      NAME="CentOS Stream"
      VERSION="8"
      ID="centos"
      ID_LIKE="rhel fedora"
      VERSION_ID="8"
      PRETTY_NAME="CentOS Stream 8"
    OS_RELEASE
  end

  let(:os_release_centos) do
    <<~OS_RELEASE
      NAME="CentOS Linux"
      VERSION="8"
      ID="centos"
      ID_LIKE="rhel fedora"
      VERSION_ID="8"
      PRETTY_NAME="CentOS Linux 8"
    OS_RELEASE
  end

  context "on centos stream" do
    it "returns true if on centos_stream_platform?" do
      expect(File).to receive(:exist?).with("/etc/os-release").and_return(true)
      expect(File).to receive(:open).with("/etc/os-release").and_return(StringIO.new(os_release_stream))
      expect(test_instance.centos_stream_platform?).to be true
    end
  end

  context "on centos linux" do
    it "returns false if on centos_stream_platform?" do
      expect(File).to receive(:exist?).with("/etc/os-release").and_return(true)
      expect(File).to receive(:open).with("/etc/os-release").and_return(StringIO.new(os_release_centos))
      expect(test_instance.centos_stream_platform?).to be false
    end
  end
end
