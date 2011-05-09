require 'spec_helper'

describe Configoro::Hash do
  subject { Configoro::Hash.new(:string => 'value', :fixnum => 123, :hash => { :foo => 'bar' }, :array => [ 1, 2, 3 ], :nilval => nil) }

  context "[getters]" do
    it "should allow access by symbol" do
      subject[:string].should eql('value')
    end

    it "should allow access by string" do
      subject['fixnum'].should eql(123)
    end

    it "should allow access by method" do
      subject.array.should eql([ 1, 2, 3 ])
      subject.array.should eql([ 1, 2, 3 ])
    end
    
    it "should allow access by predicate method" do
      subject.string?.should eql(true)
      subject.string?.should eql(true)
      subject.nilval?.should eql(false)
      subject.nilval?.should eql(false)
    end
    
    # We try the above methods twice: Once for creating the method, the other
    # for accessing it
  end

  context "[accessor methods]" do
    it "should define an accessor method upon first access" do
      subject.methods.should_not include(:string)
      subject.methods.should_not include(:string?)
      subject.string
      subject.methods.should include(:string)
      subject.methods.should include(:string?)
    end

    it "should remove the accessor method if the key is removed from the hash" do
      subject.string
      subject.methods.should include(:string)
      subject.methods.should include(:string?)
      subject.delete 'string'
      proc { subject.string }.should raise_error(NameError)
      subject.methods.should_not include(:string)
      subject.methods.should_not include(:string?)
    end

    it "should not override existing methods" do
      subject['inspect'] = 'wrong!'
      subject.inspect.should_not eql('wrong!')
      subject.methods.should_not include(:inspect?)
    end
  end

  describe "#include?" do
    it "should accept symbols" do
      subject.should include(:string)
      subject.should_not include(:string2)
    end

    it "should accept strings" do
      subject.should include('fixnum')
      subject.should_not include('fixnum2')
    end
  end

  describe "#<<" do
    subject { Configoro::Hash.new }

    it "should deep-merge entries from a hash" do
      subject << { :a => 'b', :b => { :c => 'd' } }
      subject << { :a => 'b', :b => { :d => 'e' } }

      subject.a.should eql('b')
      subject.b.c.should eql('d')
      subject.b.d.should eql('e')
    end

    it "should load a YAML file and deep-merge its entries" do
      subject << "#{File.dirname __FILE__}/../data/config/environments/common/hash_test.yml"
      subject << "#{File.dirname __FILE__}/../data/config/environments/development/hash_test.yml"

      subject.hash_test.akey.should eql('value')
      subject.hash_test.subhash.key1.should eql('val1')
      subject.hash_test.subhash.key2.should eql('newval')
    end

    it "should raise an error if the file is not a YAML file" do
      lambda { subject << "example.txt" }.should raise_error(ArgumentError)
    end

    it "should not change the receiver if the file doesn't exist" do
      subject << "example.yml"
      subject.should be_empty
    end
  end

  describe "#deep_merge!" do
    subject { Configoro::Hash.new }

    it "should merge in keys and values" do
      subject['a'] = 'old'
      subject.deep_merge! :a => 'new'
      subject.a.should eql('new')
    end

    it "should deep-merge sub-hashes and convert them to Configoro::Hashes" do
      subject['hsh'] = { 'key1' => 'val1', 'key2' => 'val2' }
      subject.deep_merge! :hsh => { 'key2' => 'newval' }

      subject.hsh.key1.should eql('val1')
      subject.hsh.key2.should eql('newval')
    end
  end
end
