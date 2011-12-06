require 'spec_helper'

describe Morpheus::Sessions::BaseSession do
  let(:db) { double('DB').as_null_object }

  before   { db.stub_chain(:service_root, :reference_node).and_return 'http://localhost:7474/db/data/node/123' }

  subject { Morpheus::Sessions::BaseSession.new(db) }

  its(:reference_node)    { should be_a Morpheus::ReferenceNode }
end

describe Morpheus::Sessions::SyncSession do
end

describe Morpheus::Sessions::EmSynchronySession do
end
