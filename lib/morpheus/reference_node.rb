module Morpheus

  class ReferenceNode < Node
    def initialize(id)
      super()
      self.mark_as_persisted id
    end
  end

end
