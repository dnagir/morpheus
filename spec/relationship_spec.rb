require 'spec_helper'

describe Morpheus::Relationship do
  let(:from)  { double('first') }
  let(:to)    { double('secnd') }
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
    def rel(type, n1, n2)
      Morpheus::Relationship.new type, n1, n2
    end

    it "should be equal with same from, to and type attributes" do
      rel(:likes, from, to).should == rel(:likes, from, to)
    end

    it "should not be equal when type is different" do
      rel(:likes, from, to).should_not == rel(:liked, from, to)
    end

    it "should not be equal to nil" do
      rel(:likes, from, to).should_not == nil
    end

    it "should behave well in array" do
      r1 = rel(:likes, from, to)
      r2 = rel(:likes, from, to)
      r3 = rel(:liked, from, to)
      [r1].should == [r2]
      [r1].should include r2
      [r1].should_not == [r3]
      [r1].should_not include r3
    end
  end
end
