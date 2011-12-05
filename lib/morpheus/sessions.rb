module Morpheus
  module Sessions
    class BaseSession
      def reference_node
        ReferenceNode.new reference_node_id
      end

      def reference_node_id
        # TODO: Review this
        node_url = Morpheus.database.service_root.reference_node
        node_url.match(/(\d+)\/?$/)[1].to_i
      end

    end

    class SyncSession
    end

    class EmSynchronySession
    end
  end
end
