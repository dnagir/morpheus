module Morpheus
  class Database
    attr_accessor :protocol, :server, :port, :service_root

    def initialize(options={})
      @protocol = options.fetch :protocol,  'http://'
      @server   = options.fetch :server,    'localhost'
      @port     = options.fetch :port,      7474
    end

    def discover!
      api = Morpheus::API::Root.new
      @service_root = api.get "#{protocol}#{server}:#{port}/db/data/"
      self
    end

  end
end

