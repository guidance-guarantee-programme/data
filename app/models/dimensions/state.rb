module Dimensions
  class State < ActiveRecord::Base
    validates :name, presence: true
    validates :default, uniqueness: { if: :default? }
  end
end
