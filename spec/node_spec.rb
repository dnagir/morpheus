require 'spec_helper'

describe Morpheus::Node do
  let(:person_class) do
    Class.new(Morpheus::Node) do
      relation :likes, :hates
    end
  end

  subject           { person_class.new }
  let(:other)       { person_class.new }
  let(:yet_another) { person_class.new }

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

