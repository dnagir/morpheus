require 'spec_helper'

describe Morpheus::ActsAsPersistent do
  let(:person_class) do
    Class.new do
      include Morpheus::ActsAsPersistent
      include Morpheus::HasProperties
      def self.api_endpoint; :relationships; end
    end
  end

  subject { person_class.new }
  let(:session) { double('session') }
  before { Morpheus.stub(:current_session).and_return session }

  describe "module interface" do
    it { should respond_to :id }
    it { should respond_to :persisted? }
    it { should respond_to :save }
    it { should respond_to :save! }
    it { should respond_to :destroy }
    it { should respond_to :destroy! }
    it { should respond_to :update_attributes }
    it { should respond_to :update_attributes! }
    it { should respond_to :mark_as_persisted }

    context "class methods" do
      subject { person_class }
      it { should respond_to :get }
      it { should respond_to :api_endpoint }
    end
  end

  describe "fetching an object" do
    subject { person_class }

    it "should queue GET" do
      session.should_receive(:get).with(person_class, :relationships, 123)
      subject.get(123)
    end
  end

  context "when the object is new" do
    its(:id) { should be_nil }
    its(:persisted?) { should be_false }

    it "should queue the CREATE operation with properties" do
      session.should_receive(:create).with(:relationships, {:name => 'Dima'})
      subject.set_property(:name, 'Dima')
      subject.save!
    end
  end


  context "when object exists" do
    before { subject.mark_as_persisted 123 }

    its(:id) { should == 123 }
    its(:persisted?) { should be_true }

    it "should queue the UPDATE operation" do
      subject.set_property(:name, 'Dima')
      session.should_receive(:update).with(:relationships, 123, {:name => 'Dima'})
      subject.save!
    end

    it "should queue the DELETE operation" do
      session.should_receive(:delete).with(:relationships, 123)
      subject.destroy!
    end

    it "should enque cascades"
  end
end
