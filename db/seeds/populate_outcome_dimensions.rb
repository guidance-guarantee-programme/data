['Forwarded'].each do |state_name|
  Dimensions::Outcome.find_or_create_by!(name: state_name, successful: true)
end

['Abandoned'].each do |state_name|
  Dimensions::Outcome.find_or_create_by!(name: state_name, successful: false)
end
