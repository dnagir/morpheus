require 'spec_helper'

describe Morpheus::Base do

  describe "Validations" do
    it { should respond_to :valid? }
    it { should respond_to :errors }
  end

  describe "Conversions" do
    it { should respond_to :to_model }
    it { should respond_to :to_param }
    it { should respond_to :to_key }
    it { should respond_to :persisted? }
  end

  it "should behave properly with respond_to"

  class Person < Morpheus::Base
    relation :likes, :hates
  end

  describe Person do

    subject { Person.new }
    let(:other) { Person.new }

    describe "properties" do
      its(:anything) { should be_nil }
      it "should assign and retrieve" do
        subject.name = 'Dima'
        subject.name.should == 'Dima'
      end
    end

    describe "relations on nodes" do
      its(:likes) { should be_empty }
      its(:hates) { should be_empty }
      its(:name)  { should be_nil }

      it "should return the relationship" do
        subject.likes(other)      .should be_a Morpheus::Relationship
        subject.likes(other, :in) .should be_a Morpheus::Relationship
        subject.likes(other, :out).should be_a Morpheus::Relationship
      end

      it "should assign and retrieve incommig" do
        subject.likes(other, :in)
        subject.likes(:in).should include subject
      end

      it "should assign and retrieve outgoing" do
        subject.likes(other, :out)
        subject.likes(:out).should include other
      end

      it "should defualt to outgoing" do
        subject.likes other
        subject.likes(:out).should == subject.likes
        subject.likes(:in).should be_empty
      end

      it "should retrieve both incomming and outgoing nodes" do
        yet_another = Person.new
        subject.likes(other)
        subject.likes(yet_another)
        all = subject.likes(:both)
        all.should include other
        all.should include yet_another
      end

      it "should replace existing relation" do
        4.times { subject.likes other }
        subject.likes.length.should == 1
      end

    end

    describe "relations objects" do
      it "should retrieve the relation object" do
        subject.likes(other)
        rel = subject.likes!.first
        rel.from.should == subject
        rel.to.should == other
      end

      it "should retrieve the incomming relation" do
        subject.likes(other, :in)
        rel = subject.likes!(:in).first
        rel.from.should == other
        rel.to.should == subject
      end

      it "should retrieve the outgoing relation" do
        subject.likes(other, :out)
        rel = subject.likes!(:out).first
        rel.from.should == subject
        rel.to.should == other
      end

      it "should set properties on relation" do
        subject.likes(other)
        rel = subject.likes!.first
        rel.since = 'yesterday'
        rel.since.should == 'yesterday'
      end
    end

  end

end

describe Morpheus::Relationship do
  let(:from)  { Morpheus::Base.new }
  let(:to)    { Morpheus::Base.new }
  let(:type)  { :likes }
  subject     { Morpheus::Relationship.new(type, from, to) }

  its(:from) { should == from }
  its(:to)   { should == to }
  its(:type) { should == :likes }

  it "should behave properly with respond_to"

  describe ".new_with_direction" do
    subject { Morpheus::Relationship.new_with_direction(type, from, to, direction) }

    context "no direction given" do
      let(:direction) { nil }
      its(:from) { should == from }
      its(:to)   { should == to }
    end

    context "with outgoing direction" do
      let(:direction) { :out }
      its(:from) { should == from }
      its(:to)   { should == to }
    end

    context "with incomming direction" do
      let(:direction) { :in }
      its(:from) { should == to }
      its(:to)   { should == from }
    end

  end

  describe "properties" do
    its(:anything) { should == nil }
    it "should set and retrieve property" do
      subject.how_much = 'strongly'
      subject.how_much.should == 'strongly'
    end
  end

  describe "equality" do
    let(:node1) { double('first') }
    let(:node2) { double('secnd') }
    def rel(type, n1, n2)
      Morpheus::Relationship.new type, n1, n2
    end

    it "should be equal with same from, to and type attributes" do
      rel(:likes, node1, node2).should == rel(:likes, node1, node2)
    end

    it "should not be equal when type is different" do
      rel(:likes, node1, node2).should_not == rel(:liked, node1, node2)
    end

    it "should not be equal to nil" do
      rel(:likes, node1, node2).should_not == nil
    end

    it "should behave well in array" do
      r1 = rel(:likes, node1, node2)
      r2 = rel(:likes, node1, node2)
      r3 = rel(:liked, node1, node2)
      [r1].should == [r2]
      [r1].should include r2
      [r1].should_not == [r3]
      [r1].should_not include r3
    end
  end
end
