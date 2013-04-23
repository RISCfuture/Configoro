require 'spec_helper'

module MyApp; end

describe Configoro do
  subject { MyApp::Configuration }

  describe "#initialize" do
    it "should make the configuration available to MyApp::Configuration" do
      subject.should be_kind_of(Configoro::Hash)
    end

    it "should load data from the config files" do
      subject.basic.common_only.should eql('common')
    end

    it "should give priority to environment-specific files" do
      subject.basic.env_name.should eql('development')
    end

    it "should not load data from other environments" do
      subject.basic['should_not_exist'].should be_nil
    end

    it "should convert hashes recursively" do
      subject.hash_test.akey.should eql('value')
    end

    it "should deep-merge hashes" do
      subject.hash_test.subhash.key1.should eql('val1')
      subject.hash_test.subhash.key2.should eql('newval')
    end

    it "should not complain when there is no directory for the current environment" do
      Rails.stub!(:env).and_return('unknown')
      Configoro.initialize
      MyApp::Configuration.should eql({"basic"=>{"common_only"=>"common", "env_name"=>"common"}, "erb_test" => {"sum" => 2}, "hash_test"=>{"akey"=>"value", "subhash"=>{"key1"=>"val1", "key2"=>"val2"}}})
    end

    context "[custom search paths]" do
      before(:each) { Configoro.instance_variable_set :@paths, nil }

      it "should use common configuration under a custom search path" do
        Rails.stub!(:env).and_return('unknown')
        Configoro.paths << File.join(File.dirname(__FILE__), 'data', 'other')
        Configoro.initialize
        MyApp::Configuration.basic.env_name.should eql('other_common')
      end

      it "should use environment-specific configuration under a custom search path" do
        Rails.stub!(:env).and_return('development')
        Configoro.paths << File.join(File.dirname(__FILE__), 'data', 'other')
        Configoro.initialize
        MyApp::Configuration.basic.env_name.should eql('other_development')
      end
    end
  end
end
