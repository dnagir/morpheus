require "morpheus/version"
require 'active_model'
require 'morpheus/has_properties'
require 'morpheus/acts_as_persistent'
require "morpheus/relationship"
require "morpheus/node"
require "morpheus/railtie" if defined?(Rails)

module Morpheus
  def self.root
    @root ||= Node.new.tap do |n|
      n.mark_as_persisted 0
    end
  end
end
