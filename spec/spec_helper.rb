require 'morpheus'
require 'pry'
require 'fakeweb'

RSpec.configure do |config|

  config.before(:suite) do
     FakeWeb.allow_net_connect = false
  end

  config.after(:each) do
    FakeWeb.clean_registry
  end

end
