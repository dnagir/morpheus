require 'spec_helper'

describe Morpheus::Database do
  let(:db)        { Morpheus::Database.new }
  subject         { db }

  its(:protocol)  { should == 'http://' }
  its(:server)    { should == 'localhost' }
  its(:port)      { should == 7474 }


  describe "#discover!" do
    let(:result) { Object.new }
    let(:api) do
      api = double('root API')
      api.stub(:get).and_return result
      api
    end
    before { Morpheus::API::Root.stub(:new).and_return api }

    it "should chain" do
      subject.discover!.should == subject
    end

    it "should assign result" do
      subject.discover!
      subject.service_root.should == result
    end

    it "should GET with the from options" do
      api.should_receive(:get).with "http://localhost:7474/db/data/"
      subject.discover!
    end
  end
end

