module Morpheus
  module ActsAsPersistent
    extend ActiveSupport::Concern
    included do
      attr_reader :id
    end

    module InstanceMethods
      def persisted?
        !!@id
      end

      def mark_as_persisted(new_id)
        @id = new_id
      end

      def save
      end

      def save!
      end

      def destroy
      end

      def destroy!
      end

      def update_attributes
      end

      def update_attributes!
      end
    end
  end
end

