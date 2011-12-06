require 'spec_helper'

describe Morpheus::Query do

  subject { Morpheus::Query.new(0) }

  it "should return type of query" do
    subject.bla.to_query.type.should_not be_nil
  end

  it "should raise if no path exists" do
    lambda{ subject.to_query.query }.should raise_error
  end

  it "should produce Cypher query from simple path" do
    q = subject.users.current.to_query.query
    q.should == "START s=node(0) MATCH s-[:users]->()-[:current]->last RETURN last"
  end

  describe "execution" do
    it "should pass the query to the Cypher API" do
      cypher = double('Cypher')
      Morpheus::API::Cypher.stub(:new).and_return cypher
      q = subject.users.me.to_query
      cypher.should_receive(:execute).with q.query, {}
      subject.execute!
    end
  end
end
