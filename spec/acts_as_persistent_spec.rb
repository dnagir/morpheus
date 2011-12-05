require 'spec_helper'

describe Morpheus::ActsAsPersistent do
  let(:person_class) do
    Class.new do
      include Morpheus::ActsAsPersistent
      include Morpheus::HasProperties
      def self.api_endpoint; :relationships; end

      def valid?; true; end
    end
  end

  subject { person_class.new }
  let(:session) { double('session').as_null_object }
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

  its(:id) { should be_nil }
  its(:persisted?) { should be_false }

  describe "#save_without_validation" do
    it "should not validate" do
      subject.should_not_receive :valid?
      subject.save_without_validation
    end

    it "should queue the CREATE operation with properties" do
      session.should_receive(:create).with(:relationships, {:name => 'Dima'})
      subject.set_property(:name, 'Dima')
      subject.save_without_validation
    end

    context "when object exists" do
      before { subject.mark_as_persisted 123 }
      its(:id) { should == 123 }
      its(:persisted?) { should be_true }

      it "should queue the UPDATE operation" do
        subject.set_property(:name, 'Dima')
        session.should_receive(:update).with(:relationships, 123, {:name => 'Dima'})
        subject.save_without_validation    end

      it "should queue the DELETE operation" do
        session.should_receive(:delete).with(:relationships, 123)
        subject.destroy!
      end

      it "should handle cascades"
    end
  end

  describe "#destroy and #destroy!" do
    it "should be ignored for new object" do
      session.should_not_receive(:delete)
      subject.destroy!
      subject.destroy
    end

    context "when object exists" do
      before { subject.mark_as_persisted 123 }
      its(:destroy)  { should == true }
      its(:destroy!) { should == true }

      it "should queue the DELETE operation" do
        session.should_receive(:delete).with(:relationships, 123)
        subject.destroy!
      end

      it "should queue the DELETE operation (non-bang)" do
        session.should_receive(:delete).with(:relationships, 123)
        subject.destroy
      end

      it "should handle cascades"
    end
  end

  describe "#save" do
    context "when valid" do
      before { subject.stub(:valid?).and_return true }
      its(:save)  { should be_true }
    end
    context "when invalid" do
      before { subject.stub(:valid?).and_return false }
      its(:save)  { should be_false }
    end
  end

  describe "#save!" do
    context "when valid" do
      before { subject.stub(:valid?).and_return true }
      its(:save!)  { should be_true }
    end
    context "when invalid" do
      before { subject.stub(:valid?).and_return false }
      it "should raise error" do
        lambda { subject.save! }.should raise_error Morpheus::ValidationError
      end
    end
  end

  describe ".get" do
    subject { person_class }
    it "should queue GET" do
      session.should_receive(:get).with(person_class, :relationships, 123)
      subject.get(123)
    end
  end

  describe "#udpate_attributes" do
    it "should assign properties from hash" do
      result = subject.update_attributes :name => 'Dima', 'twitter' => '@dnagir'
      result.should be_true
      subject.get_property(:name).should == 'Dima'
      subject.get_property('twitter').should == '@dnagir'
    end

    it "should return true when validation is successful" do
      subject.stub(:valid?).and_return true
      subject.update_attributes(:name => 'Dima').should be_true
    end

    it "should return false when validation fails" do
      subject.stub(:valid?).and_return false
      subject.update_attributes(:name => 'Dima').should be_false
    end
  end

  describe "#update_attributes!" do
    it "should throw if validation fails" do
      subject.stub(:valid?).and_return false
      lambda { subject.update_attributes!(:name => 'Dima') }.should raise_error Morpheus::ValidationError
    end
  end
end
