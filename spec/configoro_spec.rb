require 'spec_helper'

module MyApp; end

describe Configoro do
  subject { MyApp::Configuration }

  describe "#initialize" do
    it "should make the configuration available to MyApp::Configuration" do
      expect(subject).to be_kind_of(Configoro::Hash)
    end

    it "should load data from the config files" do
      expect(subject.basic.common_only).to eql('common')
    end

    it "should give priority to environment-specific files" do
      expect(subject.basic.env_name).to eql('development')
    end

    it "should not load data from other environments" do
      expect(subject.basic['should_not_exist']).to be_nil
    end

    it "should convert hashes recursively" do
      expect(subject.hash_test.akey).to eql('value')
    end

    it "should deep-merge hashes" do
      expect(subject.hash_test.subhash.key1).to eql('val1')
      expect(subject.hash_test.subhash.key2).to eql('newval')
    end

    it "should not complain when there is no directory for the current environment" do
      allow(Rails).to receive(:env).and_return('unknown')
      Configoro.initialize
      expect(MyApp::Configuration).to eql({"basic"=>{"common_only"=>"common", "env_name"=>"common"}, "erb_test" => {"sum_test" => 2}, "hash_test"=>{"akey"=>"value", "subhash"=>{"key1"=>"val1", "key2"=>"val2"}}})
    end

    context "[custom search paths]" do
      before(:each) { Configoro.instance_variable_set :@paths, nil }

      it "should use common configuration under a custom search path" do
        allow(Rails).to receive(:env).and_return('unknown')
        Configoro.paths << File.join(File.dirname(__FILE__), 'data', 'other')
        Configoro.initialize
        expect(MyApp::Configuration.basic.env_name).to eql('other_common')
      end

      it "should use environment-specific configuration under a custom search path" do
        allow(Rails).to receive(:env).and_return('development')
        Configoro.paths << File.join(File.dirname(__FILE__), 'data', 'other')
        Configoro.initialize
        expect(MyApp::Configuration.basic.env_name).to eql('other_development')
      end
    end
  end
end
