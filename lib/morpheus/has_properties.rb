module Morpheus
  module HasProperties
    extend ActiveSupport::Concern

    module InstanceMethods
      def set_property(name, value)
        name = name.to_s
        name = name[0..name.length-2] if name[-1] == '='
        @properties ||= {}
        @properties[name.to_sym] = value
      end

      def get_property(name)
        return nil unless @properties
        @properties[name.to_sym]
      end

      def get_properties
        @properties || {}
      end

      def is_a_property_getter?(name, *args)
        args.length == 0 && (name.to_s =~ /^\w+$/)
      end

      def is_a_property_setter?(name, *args)
        name.to_s[-1] == '='
      end
    end
  end
end
