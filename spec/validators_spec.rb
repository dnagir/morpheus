require 'spec_helper'

describe Morpheus::Validators::UniqueNodeValidator do
  let(:record)  {
    me = double('Nodish')
    me.stub(:errors).and_return({:email => []})
    me
  }
  let(:value)  { 'dima@example.com' }
  subject      { Morpheus::Validators::UniqueNodeValidator.new({:attributes => [:email]}.merge(options)) }


  let(:dsl)   { double("DSL").as_null_object }
  let(:query) { double('Query') }
  let(:root)  {
    ref = double('Reference Node')
    ref.stub(:query).and_return query
    ref
  }
  before      { Morpheus.stub(:root).and_return root }

  def validate
    subject.validate_each(record, :email, value)
    record
  end

  context "no path given" do
    let(:options){ {} }
    it "should raise" do

    end
  end

  describe "path option = users.current" do
    let(:options) { {:path => Proc.new { users.current } } }

    context "when DSL returns anything" do
      before {
        query.stub_chain(:users, :current).and_return [1,2,3]
      }
      it "should have the message" do
        validate.errors[:email].should include "is already taken"
      end
    end

    context "when the value is blank" do
      let(:value) { ' ' }
      it "should not call DSL" do
        root.should_not_receive(:query)
        validate
      end
      it "should be valid" do
        validate.errors[:email].should be_empty
      end
    end

    describe "when DSL returns no results" do
      before {
        query.stub_chain(:users, :current).and_return []
      }
      it "should not have any messages" do
        validate.errors[:email].should be_empty
      end
    end
  end

end
