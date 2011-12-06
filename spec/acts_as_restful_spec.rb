require 'spec_helper'

describe Morpheus::ActsAsRestful do
  let(:person_class) do
    Class.new(Morpheus::Node) do
    end
  end

  subject { person_class.new }

  its(:rest) { should == {} }

  it "should update rest info" do
    subject.update_rest!( {'whatever' => {'that' => 123}} )
    subject.rest["whatever"]["that"].should == 123
  end

  describe "side effects" do
    let(:data) do
      {
        "data"=>{"name"=>"Dima"},
        "self"=>"http://localhost:7474/db/data/node/1234"
      } 
    end
    before { subject.update_rest!(data) }

    its(:name)      { should == "Dima" }
    its(:id)        { should == 1234   }
  end
end
