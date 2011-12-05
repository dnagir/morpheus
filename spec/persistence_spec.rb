require 'spec_helper'

describe Morpheus::ActsAsPersistent do
  let(:any_class) do
    Class.new do
      include Morpheus::ActsAsPersistent
    end
  end

  subject { any_class.new }

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
  end

  describe "required implementation for the interface" do
    pending
  end

  before do
    stub(Morpheus::root)
  end

  context "when the object is new" do
    its(:id) { should be_nil }
    its(:persisted?) { should be_false }

    it "should queue the save operation" do
      pending
      subject.save!
    end
  end


  context "when object exists" do
    before { subject.mark_as_persisted 123 }

    its(:id) { should == 123 }
    its(:persisted?) { should be_true }

    it "should queue the update operation" do
      pending
    end
  end
end


describe Morpheus, ".root" do
  subject { Morpheus::root }

  describe "quacks like a node" do
    its(:id)          { should == 0 }
    its(:persisted?)  { should be_true }
    its(:valid?)      { should be_true }
  end
end
