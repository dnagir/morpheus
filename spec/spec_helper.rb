require 'morpheus'
require 'pry'
require 'fakeweb'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true

  config.before(:suite) do
     FakeWeb.allow_net_connect = false
  end

  config.after(:each) do
    FakeWeb.clean_registry
  end

end
