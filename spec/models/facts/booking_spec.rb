require 'rails_helper'

RSpec.describe Facts::Booking, type: :model do
  it do
    is_expected.to belong_to(:date_dimension)
      .class_name('Dimensions::Date')
      .with_foreign_key(:dimensions_date_id)
  end

  it { is_expected.to validate_presence_of(:date_dimension) }

  it { is_expected.to validate_presence_of(:reference_number) }
  it { is_expected.to validate_uniqueness_of(:reference_number) }
end
