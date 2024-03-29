module Morpheus
  class Query
    def initialize(start)
      @start = start
      @target_class = nil
      @paths = []
    end

    def to_query
      ::OpenStruct.new({
        :type => :cypher,
        :query => "START s=node(#{@start.id}) MATCH s#{assemble_paths}last RETURN last"
      })
    end

    def as(target_class)
      @target_class = target_class
      self
    end

    def execute!
      q = self.to_query
      api = Morpheus::API.const_get(q.type.to_s.camelize).new
      api.execute @target_class, q.query, {}
    end

    protected

    def method_missing(method, *args, &block)
      add_path(method)
    end


    def assemble_paths
      Kernel.raise "Nothing is defined for the query." if @paths.empty?
      @paths.map{|p| "-[:#{p}]->"}.join("()")
    end

    def add_path(relation_name)
      @paths << relation_name
      self
    end

  end
end

