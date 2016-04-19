module Facts
  class Call < ActiveRecord::Base
    belongs_to :audit_dimension,
               class_name: Dimensions::Audit,
               foreign_key: 'dimensions_audit_id'
    belongs_to :date_dimension,
               class_name: Dimensions::Date,
               foreign_key: 'dimensions_date_id'
    belongs_to :time_dimension,
               class_name: Dimensions::Time,
               foreign_key: 'dimensions_time_id'
    belongs_to :outcome_dimension,
               class_name: Dimensions::Outcome,
               foreign_key: 'dimensions_outcome_id'
  end
end
