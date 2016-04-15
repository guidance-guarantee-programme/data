Dimensions::State.find_or_create_by!(name: 'Awaiting Status', default: true)
['No show', 'Incomplete', 'Ineligible', 'Complete'].each do |state_name|
  Dimensions::State.find_or_create_by!(name: state_name)
end
