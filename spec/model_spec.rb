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

      it "should assign and retrieve incommig" do
        subject.likes :in, other
        subject.likes(:in).should include other
      end

      it "should assign and retrieve outgoing" do
        subject.likes :out, other
        subject.likes(:out).should include other
      end

      it "should defualt to outgoing" do
        subject.likes other
        subject.likes(:out).should include other
        subject.likes(:in).should be_empty
      end

      it "should retrieve both incomming and outgoing if none specified" do
        yet_another = Person.new
        subject.likes :in, other
        subject.likes :out, yet_another
        subject.likes.should include other
        subject.likes.should include yet_another
      end

    end

    describe "relations objects", :wip => true do
      it "should retrieve the relation object" do
        subject.likes(other)
        rel = subject.likes!.first
        rel.starting.should == subject
        rel.ending.should == other
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


