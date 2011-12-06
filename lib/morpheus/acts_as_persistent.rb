module Morpheus
  class ValidationError < Exception
  end

  module ActsAsPersistent
    extend ActiveSupport::Concern

    module InstanceMethods
      def persisted?
        !!id
      end

      def api
        self.class.api
      end

      def save_without_validation
        if persisted?
          api.update(id, get_properties)
        else
          api.create(get_properties)
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
          api.delete(id)
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
      def api
        Morpheus::API.const_get(self.api_endpoint.to_s.camelize).new
      end

      def get(id)
        api.get(self, id)
      end
    end

  end
end

