module Facts
  class Booking < ActiveRecord::Base
    belongs_to :audit_dimension,
               class_name: Dimensions::Audit,
               foreign_key: 'dimensions_audit_id'
    belongs_to :date_dimension,
               class_name: Dimensions::Date,
               foreign_key: 'dimensions_date_id'

    validates :date_dimension, presence: true
    validates :reference_number, presence: true, uniqueness: true
  end
end
