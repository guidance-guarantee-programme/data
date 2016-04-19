module Dimensions
  class Outcome < ActiveRecord::Base
    validates :name, presence: true, uniqueness: true

    def self.forwarded
      @forwarded ||= find_by!(name: 'Forwarded')
    end

    def self.abandoned
      @abandoned ||= find_by!(name: 'Abandoned')
    end
  end
end
