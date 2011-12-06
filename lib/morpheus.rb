require 'morpheus/version'
require 'active_model'
require 'morpheus/has_properties'
require 'morpheus/acts_as_persistent'
require 'morpheus/acts_as_restful'
require 'morpheus/validators'
require 'morpheus/relationship'
require 'morpheus/node'
require 'morpheus/reference_node'

require 'recursive_open_struct'

require 'net/http'
require 'multi_json'
require 'morpheus/api'
require 'morpheus/database'
require 'morpheus/sessions'
require 'morpheus/query'
require 'morpheus/railtie' if defined?(Rails)

module Morpheus


  def self.root
    current_session.reference_node
  end

  def self.current_session
    #TODO: Make it thread-safe
    @current_session ||= create_session
  end

  def self.create_session
    Sessions::SyncSession.new database
  end

  def self.configure_and_discover_database!(options={})
    #TODO: Make it extra-thread-safe
    Morpheus.database = Database.new(options).discover!
  end

  def self.database
    raise "The database isn't configured. Call Morpheus.configure_and_discover!(options)." unless @database
    @database
  end

  def self.database=(db)
    #TODO: Make it extra-thread-safe
    @database = db
  end
end
