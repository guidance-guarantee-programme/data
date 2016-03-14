# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'date'

PopulateDateDimension.new(begin_date: Date.new(2015, 1, 1), end_date: Date.today).call

Dimensions::State.find_or_create_by!(name: 'Awaiting Status', default: true)
['No show', 'Incomplete', 'Ineligible', 'Complete'].each do |state_name|
  Dimensions::State.find_or_create_by!(name: state_name)
end
