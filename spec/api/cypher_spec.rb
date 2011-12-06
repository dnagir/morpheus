require 'spec_helper'

describe Morpheus::API::Cypher do
  let(:uri)   { "http://localhost:7474/db/data/ext/CypherPlugin/graphdb/execute_query" }
  let(:body) do
    <<-JSON
    {
      "data" : [ [ {
        "outgoing_relationships" : "http://localhost:7474/db/data/node/1234/relationships/out",
        "data" : {
          "name" : "Mr 4-1"
        },
        "traverse" : "http://localhost:7474/db/data/node/1234/traverse/{returnType}",
        "all_typed_relationships" : "http://localhost:7474/db/data/node/1234/relationships/all/{-list|&|types}",
        "property" : "http://localhost:7474/db/data/node/1234/properties/{key}",
        "self" : "http://localhost:7474/db/data/node/1234",
        "properties" : "http://localhost:7474/db/data/node/1234/properties",
        "outgoing_typed_relationships" : "http://localhost:7474/db/data/node/1234/relationships/out/{-list|&|types}",
        "incoming_relationships" : "http://localhost:7474/db/data/node/1234/relationships/in",
        "extensions" : {
        },
        "create_relationship" : "http://localhost:7474/db/data/node/1234/relationships",
        "paged_traverse" : "http://localhost:7474/db/data/node/1234/paged/traverse/{returnType}{?pageSize,leaseTime}",
        "all_relationships" : "http://localhost:7474/db/data/node/1234/relationships/all",
        "incoming_typed_relationships" : "http://localhost:7474/db/data/node/1234/relationships/in/{-list|&|types}"
      } ] ],
      "columns" : [ "s" ]
    }
    JSON
  end

  subject { Morpheus::API::Cypher.new }


  describe "results" do
    #before  { FakeWeb.register_uri(:get, uri, :body => body) }
    let(:user_class) do
      Class.new(Morpheus::Node) do
      end
    end

    it "should return nodes" do
      FakeWeb.allow_net_connect = true
      Morpheus.configure_and_discover_database!
      results = subject.execute(user_class, "start s=node(1234) return s")
      results.first.should be_a user_class
      results.first.name.should == "Mr 4-1"
    end

    it "should raise if no resulting cass provided" do
      lambda{ subject.execute(nil, "start s=node(1234) return s") }.should raise_error
    end
  end

end
