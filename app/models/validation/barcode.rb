module Validation 
  module Barcode
    def self.included(base)
      base.class_eval do
        include ActiveModel::Validations
        attr_accessor :ids
        validate :check_ids

        def check_ids
          if @ids.detect{|id| !is_number?(id) }
            errors.add(:ids, 'errors: id should be legal ')
          end
        end

        def is_number?(id)
          if id.is_a?(Integer) or id.is_a?(Fixnum)
            true
          elsif id.is_a?(String)
            id.to_i.to_s == id
          else
            false
          end
        end
      end
    end
  end
end
