module Morpheus

  class ReferenceNode < Node
    def initialize(node_url)
      super()
      update_rest!({ 'self' => node_url })
    end
  end

end
