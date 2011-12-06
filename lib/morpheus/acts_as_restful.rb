module Morpheus
  module ActsAsRestful
    extend ActiveSupport::Concern

    module InstanceMethods

      def id
        return nil unless rest
        url = rest["self"]
        return nil if url.blank?
        url.match(/(\d+)\/?$/)[1].to_i
      end

      def rest
        @rest ||= {}
      end

      def update_rest!(data)
        @rest = data.to_hash

        props = rest["data"]
        assign_attributes(props) if props && respond_to?(:assign_attributes)
        self
      end
    end
  end
end

