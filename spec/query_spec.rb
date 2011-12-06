require 'spec_helper'

module Morpheus
  class Query
    def initialize(start_id)
      @start_id = start_id
      @paths = []
    end

    def to_query
      ::OpenStruct.new({
        :type => :cypher,
        :query => "START s=node(#{@start_id}) MATCH s#{assemble_paths}last RETURN last"
      })
    end

    def execute!
      q = self.to_query
      api = Morpheus::API.const_get(q.type.to_s.camelize).new
      api.execute q.query, {}
    end

    protected

    def method_missing(method, *args, &block)
      add_path(method)
    end


    def assemble_paths
      Kernel.raise "Nothing is defined for the query." if @paths.empty?
      @paths.map{|p| "-[:#{p}]->"}.join("()")
    end

    def add_path(relation_name)
      @paths << relation_name
      self
    end

  end
end

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
