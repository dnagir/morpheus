module Morpheus
  module Validators

    class UniqueNodeValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        return if value.blank?

        start_node = Morpheus.root
        path = options[:path]
        raise "Please provide :path => Proc.new { path.to.node } in the options" unless path.respond_to?(:to_proc)
        query = start_node.query.instance_eval &path.to_proc

        record.errors[attribute] << "is already taken" if query.any?
      end
    end

  end
end

