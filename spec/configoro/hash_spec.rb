require 'spec_helper'

describe Configoro::Hash do
  subject { Configoro::Hash.new(:string => 'value', :fixnum => 123, :hash => { :foo => 'bar' }, :array => [ 1, 2, 3 ], :nilval => nil) }

  context "[getters]" do
    it "should allow access by symbol" do
      expect(subject[:string]).to eql('value')
    end

    it "should allow access by string" do
      expect(subject['fixnum']).to eql(123)
    end

    it "should allow access by method" do
      expect(subject.array).to eql([ 1, 2, 3 ])
      expect(subject.array).to eql([ 1, 2, 3 ])
    end
    
    it "should allow access by predicate method" do
      expect(subject.string?).to eql(true)
      expect(subject.string?).to eql(true)
      expect(subject.nilval?).to eql(false)
      expect(subject.nilval?).to eql(false)
    end
    
    # We try the above methods twice: Once for creating the method, the other
    # for accessing it
  end

  context "[accessor methods]" do
    it "should define an accessor method upon first access" do
      expect(subject.methods).not_to include(:string)
      expect(subject.methods).not_to include(:string?)
      subject.string
      expect(subject.methods).to include(:string)
      expect(subject.methods).to include(:string?)
    end

    it "should remove the accessor method if the key is removed from the hash" do
      subject.string
      expect(subject.methods).to include(:string)
      expect(subject.methods).to include(:string?)
      subject.delete 'string'
      expect { subject.string }.to raise_error(NameError)
      expect(subject.methods).not_to include(:string)
      expect(subject.methods).not_to include(:string?)
    end

    it "should not override existing methods" do
      subject['inspect'] = 'wrong!'
      expect(subject.inspect).not_to eql('wrong!')
      expect(subject.methods).not_to include(:inspect?)
    end
  end

  describe "#include?" do
    it "should accept symbols" do
      expect(subject).to include(:string)
      expect(subject).not_to include(:string2)
    end

    it "should accept strings" do
      expect(subject).to include('fixnum')
      expect(subject).not_to include('fixnum2')
    end
  end

  describe "#<<" do
    subject { Configoro::Hash.new }

    it "should deep-merge entries from a hash" do
      subject << { :a => 'b', :b => { :c => 'd' } }
      subject << { :a => 'b', :b => { :d => 'e' } }

      expect(subject.a).to eql('b')
      expect(subject.b.c).to eql('d')
      expect(subject.b.d).to eql('e')
    end

    it "should load a YAML file and deep-merge its entries" do
      subject << "#{File.dirname __FILE__}/../data/config/environments/common/hash_test.yml"
      subject << "#{File.dirname __FILE__}/../data/config/environments/development/hash_test.yml"

      expect(subject.hash_test.akey).to eql('value')
      expect(subject.hash_test.subhash.key1).to eql('val1')
      expect(subject.hash_test.subhash.key2).to eql('newval')
    end

    it "should raise an error if the file is not a YAML file" do
      expect { subject << "example.txt" }.to raise_error(ArgumentError)
    end

    it "should not change the receiver if the file doesn't exist" do
      subject << "example.yml"
      expect(subject).to be_empty
    end

    it "should preprocess YAML file as ERB" do
      subject << "#{File.dirname __FILE__}/../data/config/environments/common/erb_test.yml"
      expect(subject.erb_test.sum_test).to eql(2)
    end
  end

  describe "#deep_merge!" do
    subject { Configoro::Hash.new }

    it "should merge in keys and values" do
      subject['a'] = 'old'
      subject.deep_merge! :a => 'new'
      expect(subject.a).to eql('new')
    end

    it "should deep-merge sub-hashes and convert them to Configoro::Hashes" do
      subject['hsh'] = { 'key1' => 'val1', 'key2' => 'val2' }
      subject.deep_merge! :hsh => { 'key2' => 'newval' }

      expect(subject.hsh.key1).to eql('val1')
      expect(subject.hsh.key2).to eql('newval')
    end
  end

  describe "#to_symbolized_hash" do
    subject { Configoro::Hash.new(foo: {bar: 'baz'}) }

    its(:to_symbolized_hash) { should eql(foo: {bar: 'baz'}) }
  end
end
