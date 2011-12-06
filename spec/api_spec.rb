require 'spec_helper'

describe Morpheus::API::Root do
  let(:api)     { Morpheus::API::Root.new }
  let(:uri)     { 'http://localhost:7474/db/data/' }
  let(:result)  { api.get(uri) }
  let(:body) do
    <<-JSON
      {
        "relationship_index" : "http://localhost:7474/db/data/index/relationship",
        "node" : "http://localhost:7474/db/data/node",
        "relationship_types" : "http://localhost:7474/db/data/relationship/types",
        "neo4j_version" : "1.5.M02",
        "batch" : "http://localhost:7474/db/data/batch",
        "extensions_info" : "http://localhost:7474/db/data/ext",
        "node_index" : "http://localhost:7474/db/data/index/node",
        "reference_node" : "http://localhost:7474/db/data/node/0",
        "extensions" : {
          "CypherPlugin" : {
            "execute_query" : "http://localhost:7474/db/data/ext/CypherPlugin/graphdb/execute_query"
          },
          "GremlinPlugin" : {
            "execute_script" : "http://localhost:7474/db/data/ext/GremlinPlugin/graphdb/execute_script"
          }
        }
      }
    JSON
  end

  subject { result } 
  before  { FakeWeb.register_uri(:get, uri, :body => body) }


  its(:relationship_index)  { should == "http://localhost:7474/db/data/index/relationship" }
  its(:node)                { should == "http://localhost:7474/db/data/node" }
  its(:relationship_types)  { should == "http://localhost:7474/db/data/relationship/types" }
  its(:neo4j_version)       { should_not be_empty }
  its(:batch)               { should == "http://localhost:7474/db/data/batch" }
  its(:extensions_info)     { should == "http://localhost:7474/db/data/ext" }
  its(:node_index)          { should == "http://localhost:7474/db/data/index/node" }
  its(:reference_node)      { should == "http://localhost:7474/db/data/node/0" }

  describe "#extensions - CypherPlugin" do
    subject             { result.extensions.CypherPlugin }
    its(:execute_query) { should == "http://localhost:7474/db/data/ext/CypherPlugin/graphdb/execute_query" }
  end

  describe "#extensions - GremlinPlugin" do
    subject              { result.extensions.GremlinPlugin }
    its(:execute_script) { should == "http://localhost:7474/db/data/ext/GremlinPlugin/graphdb/execute_script" }
  end
end

describe Morpheus::API::Nodes do
  pending
end

describe Morpheus::API::Relationships do
  pending
end

describe Morpheus::API::RelationshipTypes do
  pending
end

describe Morpheus::API::RelationshipProperties do
end

describe Morpheus::API::Indexes do
  pending
end

describe Morpheus::API::AutoIndexes do
  pending
end

describe Morpheus::API::ConfigurableAutoIndexes do
  pending
end

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

describe Morpheus::API::Algorithms do
  pending
end

describe Morpheus::API::Batching do
  pending
end

describe Morpheus::API::Cypher do
  pending
end

describe Morpheus::API::Gremlin do
  pending
end



