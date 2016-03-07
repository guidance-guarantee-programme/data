class Import < ActiveRecord::Base
  validates :importer, presence: true
  validates :inserted_records, presence: true
end
