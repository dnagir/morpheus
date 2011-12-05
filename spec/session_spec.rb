require 'spec_helper'
module Morpheus

  class Database
    attr_accessor :protocol, :server, :port
    def initialize
      @protocol, @server, @port = 'http://', 'localhost', 7474
    end
  end

  module Sessions
    class BaseSession
    end

    class SyncSession
    end

    class EmSynchronySession
    end
  end
end

describe Morpheus::Database do
  its(:protocol)  { should == 'http://' }
  its(:server)    { should == 'localhost' }
  its(:port)      { should == 7474 }

  describe "#prepare_api!" do
    it "should fetch the API data"
  end
end

describe Morpheus::Sessions::BaseSession do
end

describe Morpheus::Sessions::SyncSession do
end

describe Morpheus::Sessions::EmSynchronySession do
end
