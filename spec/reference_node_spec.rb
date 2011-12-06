require 'spec_helper'

describe Morpheus::ReferenceNode do
  subject { Morpheus::ReferenceNode.new("http://abc/node/123") }


  describe "quacks like a node" do
    its(:id)          { should == 123 }
    its(:persisted?)  { should be_true }
    its(:valid?)      { should be_true }
  end

end
