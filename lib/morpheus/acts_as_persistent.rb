module Morpheus
  module ActsAsPersistent
    extend ActiveSupport::Concern
    included do
      attr_reader :id
    end

    module InstanceMethods
      def _session
        Morpheus.current_session
      end

      def persisted?
        !!@id
      end

      def mark_as_persisted(new_id)
        @id = new_id
      end

      def save
        raise 'TODO'
      end

      def save!
        if persisted?
          _session.update(self.class.api_endpoint, id, get_properties)
        else
          _session.create(self.class.api_endpoint, get_properties)
        end
      end

      def destroy
        raise 'TODO'
      end

      def destroy!
        _session.delete(self.class.api_endpoint, id)
      end

      def update_attributes
        raise 'TODO'
      end

      def update_attributes!
        raise 'TODO'
      end
    end

    module ClassMethods
      def get(id)
        Morpheus.current_session.get(self, self.api_endpoint, id)
      end
    end

  end
end

