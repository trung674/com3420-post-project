# http://stackoverflow.com/questions/31915921/rails-validates-associated-with-models-error-message/31916721#31916721

module ActiveRecord
  module Validations
    class AssociatedBubblingValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        ((value.kind_of?(Enumerable) || value.kind_of?(ActiveRecord::Relation)) ? value : [value]).each do |v|
          unless v.nil? || v.valid?
            v.errors.full_messages.each do |msg|

              # Seems to stop multiple errors being shown twice
              unless record.errors.full_messages.any?{ |s| s.casecmp(msg)<5 }
                record.errors.add(attribute, msg, options.merge(:value => value))
              end

            end
          end
        end
      end
    end

    module ClassMethods
      def validates_associated_bubbling(*attr_names)
        validates_with AssociatedBubblingValidator, _merge_attributes(attr_names)
      end
    end
  end
end