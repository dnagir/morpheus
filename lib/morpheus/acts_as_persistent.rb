module Morpheus
  class ValidationError < Exception
  end

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

      def save_without_validation
        if persisted?
          _session.update(self.class.api_endpoint, id, get_properties)
        else
          _session.create(self.class.api_endpoint, get_properties)
        end
      end

      def save
        if respond_to?(:valid?)
          if valid?
            save_without_validation
            true
          else
            false
          end
        else
          save_without_validation
          true
        end
      end

      def save!
        if respond_to?(:valid?)
          if valid?
            save_without_validation
            true
          else
            raise ValidationError #TODO: Add the errors
          end
        else
          save_without_validation
          true
        end
      end

      def destroy
        destroy!
      end

      def destroy!
        if persisted?
          _session.delete(self.class.api_endpoint, id)
          true
        else
          false
        end
      end

      def assign_attributes(new_attributes, options={})
        #TODO: This doesn't realy belong to persistence. It's much closer to the properties
        #TODO: This is overly trustfull, need to support mass_assignment options
        new_attributes.each_pair do |k, v|
          set_property(k, v)
        end
      end

      def update_attributes(new_attributes)
        assign_attributes(new_attributes)
        save
      end

      def update_attributes!(new_attributes)
        assign_attributes(new_attributes)
        save!
      end

    end

    module ClassMethods
      def get(id)
        Morpheus.current_session.get(self, self.api_endpoint, id)
      end
    end

  end
end

