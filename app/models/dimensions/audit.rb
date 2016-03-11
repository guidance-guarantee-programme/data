module Dimensions
  class Audit < ActiveRecord::Base
    validates :fact_table, :source, :source_type, presence: true
  end
end
