module Morpheus
  module Sessions

    class BaseSession
      attr_accessor :db

      def initialize(db)
        @db = db
      end

      def reference_node
        node_url = db.service_root.reference_node
        ReferenceNode.new node_url
      end
    end

    class SyncSession < BaseSession
    end

    class EmSynchronySession
    end
  end
end
