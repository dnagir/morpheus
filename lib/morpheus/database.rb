module Morpheus
  class Database
    attr_accessor :protocol, :server, :port, :service_root

    def initialize
      @protocol, @server, @port = 'http://', 'localhost', 7474
    end

    def discover!
      api = Morpheus::API::Root.new
      @service_root = api.get "#{protocol}#{server}:#{port}/db/data/"
      self
    end

  end
end

