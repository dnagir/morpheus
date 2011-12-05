
module Morpheus
  class Relationship
    include HasProperties
    attr_reader :type, :from, :to

    def initialize(type, from, to)
      @type, @from, @to = type.to_sym, from, to
    end

    def self.new_with_direction(type, from, to, direction=nil)
      from, to = to, from if direction == :in
      new(type, from, to)
    end

    def ==(other)
      return false unless other
      type == other.type and from == other.from and to == other.to
    end

    def method_missing(method, *args, &block)
      #TODO: Redefine respond_to? and respond_to_missing?
      if is_a_property_getter?(method, *args)
        get_property(method)
      elsif is_a_property_setter?(method, *args)
        set_property(method, args[0])
      else
        super
      end
    end
  end
end
