require 'spec_helper'

describe Morpheus::API::Traversals do
  before { pending }

  describe "query" do
    let(:user_class) do
      scoped = options
      Class.new(Morpheus::Node) do
        validates :email, :unique_node => scoped
      end
    end
    let(:user) { user_class.new }
    # Assuming graph:
    # [Ref] -users-> [USERS-CONTAINER-NODE] -current->[USER-NODE]
    before do
      user.email = 'email@here.there'
      api.stub(:traverse) do |options|
        @query_options = options
        [] # return something Enumerable
      end
      user.valid?
    end

    subject { OpenStruct.new @query_options }

    context "with given path" do
      let(:options) { {:path => lambda { users.current }} }

      its(:return_type) { should == :node }
      its(:order)       { should be_nil }
      its(:direction)   { should == :out }
      its(:uniquness)   { should == :node_global }
      its(:prune_evaluator) { should == '' }
      its(:return_filter)   { should == '??' }
      its(:max_depth)       { should be_nil }
    end

  end
end

