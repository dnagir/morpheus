require 'active_model'

module Morpheus
  module NodeMixin
    extend ActiveSupport::Concern

    included do
      include ActiveModel::Validations
      include ActiveModel::Conversion
    end

    module InstanceMethods
      def persisted?
        raise NotImplementedError.new
      end

      def method_missing(method, *args, &block)
        #TODO: Redefine respond_to? and respond_to_missing?
        name = method.to_s
        assigning = name[-1] == '='
        if assigning
          set_property(name[0..name.length-2], args[0]) if assigning
        elsif args.length == 0
          # person.name
          # person.likes
          if self.class.has_relation?(name)
            get_relation(name)
          else
            get_property(name)
          end
        elsif args.length == 1
          # person.likes(:in)
          # person.likes(her)
          arg = args[0]
          arg.respond_to?(:to_sym) ? get_relation(name, arg) : set_relation(name, :out, arg)
        elsif args.length == 2
          # person.likes(:in, her)
          set_relation(name, *args)
        else
          super
        end
      end

      def set_property(name, value)
        @properties ||= {}
        @properties[name.to_sym] = value
      end

      def get_property(name)
        return nil unless @properties
        @properties[name.to_sym]
      end

      def set_relation(name, direction, node)
        @relations_in ||= {}
        @relations_out ||= {}
        relation = direction == :in ? @relations_in : @relations_out
        relation[name.to_sym] ||= []
        relation[name.to_sym] << node
      end

      def get_relation(name, direction=nil)
        @relations_in ||= {}
        @relations_out ||= {}
        default = []
        key = name.to_sym
        direction ||= :both
        relation = if direction == :in
          @relations_in[key] || default
        elsif direction == :out
          @relations_out[key] || default
        else
          get_relation(name, :in) | get_relation(name, :out)
        end
      end
    end

    module ClassMethods
      def relation(*names)
        @relations = names
        def relations
          @relations
        end

        def has_relation?(name)
          respond_to?(:relations) && relations.include?(name.to_sym)
        end
      end
    end
  end

  class Base
    include NodeMixin
  end


end
