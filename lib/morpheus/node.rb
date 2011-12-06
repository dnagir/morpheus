module Morpheus

  module ActsAsNode
    extend ActiveSupport::Concern

    included do
      include ActiveModel::Validations
      include ActiveModel::Conversion
      include HasProperties
      include ActsAsPersistent
      include ActsAsRestful
      include Validators # To allow using as `validates :whatever`
    end

    module InstanceMethods
      def method_missing(method, *args, &block)
        #TODO: Redefine respond_to? and respond_to_missing?
        name = method.to_s
        bang = name[-1] == '!'

        if bang
          # person.likes! # All relations for :likes
          # person.likes!(:in) # All incomming relations for :likes
          get_relations(name, args[0])
        elsif args.length == 0
          # person.name # Property
          # person.likes # Related nodes
          if self.class.has_relation?(name)
            get_relation_nodes(name)
          else
            get_property(name)
          end
        elsif args.length == 1
          # person.name = 'abc' # Set the property
          # person.likes(her) # Set relation to her
          # person.likes(:in) # Get incomming :likes relations
          if is_a_property_setter?(name, *args)
            set_property(name, args[0])
          else
            arg = args[0]
            arg.respond_to?(:to_sym) ? get_relation_nodes(name, arg) : set_relation(name, arg)
          end
        elsif args.length == 2
          # person.likes(her, :in)
          set_relation(name, *args)
        else
          super
        end
      end

      def set_relation_node(name, node, direction=nil)
        set_relation(name, node, direction)
      end

      def get_relation_nodes(name, direction=nil)
        get_relations(name, direction).map{|r| r.to }
      end

      def set_relation(name, node, direction=nil)
        name = name.to_s.sub(/!/, '')
        key = name.to_sym
        direction ||= :out

        rel = Relationship.new_with_direction(key, self, node, direction)
        existing = get_relations(name, direction).select{|r| r == rel}.first
        return existing if existing
        @relations[key] ||= []
        @relations[key] << rel
        rel
      end

      def get_relations(name, direction=nil)
        name = name.to_s.sub(/!/, '')
        key = name.to_sym
        @relations ||= {}
        all = @relations[name.to_sym] || []
        if direction == :in
          all.select{|r| r.to == self}
        elsif direction == :out
          all.select{|r| r.from == self}
        else
          all
        end
      end

      def query
        Query.new(self)
      end

    end

    module ClassMethods
      def relation(*names)
        @relations = names
        def relations
          @relations
        end
      end

      def has_relation?(name)
        respond_to?(:relations) && (relations || []).include?(name.to_sym)
      end
    end
  end


  class Node
    include ActsAsNode
  end


end
