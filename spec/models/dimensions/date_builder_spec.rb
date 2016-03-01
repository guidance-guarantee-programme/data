require 'rails_helper'

RSpec.describe Dimensions::DateBuilder do
  subject(:date_dimension_builder) { described_class.new(year, month, day) }

  let(:day) { 29 }
  let(:month) { 2 }
  let(:year) { 2016 }

  describe '#date_dimension' do
    subject(:date_dimension) { date_dimension_builder.date_dimension }

    it "maps the `date' attribute" do
      expect(date_dimension.date).to eq(Date.new(year, month, day))
    end

    it "maps the `date_name' attribute" do
      expect(date_dimension.date_name).to eq('29 February 2016')
    end

    it "maps the `date_name_abbreviated' attribute" do
      expect(date_dimension.date_name_abbreviated).to eq('29 Feb 2016')
    end

    it "maps the `year' attribute" do
      expect(date_dimension.year).to eq(2016)
    end

    it "maps the `quarter' attribute" do
      expect(date_dimension.quarter).to eq(1)
    end

    it "maps the `month' attribute" do
      expect(date_dimension.month).to eq(2)
    end

    it "maps the `month_name' attribute" do
      expect(date_dimension.month_name).to eq('February')
    end

    it "maps the `month_name_abbreviated' attribute" do
      expect(date_dimension.month_name_abbreviated).to eq('Feb')
    end

    it "maps the `week' attribute" do
      expect(date_dimension.week).to eq(9)
    end

    it "maps the `day_of_year' attribute" do
      expect(date_dimension.day_of_year).to eq(60)
    end

    it "maps the `day_of_quarter' attribute" do
      expect(date_dimension.day_of_quarter).to eq(60)
    end

    it "maps the `day_of_month' attribute" do
      expect(date_dimension.day_of_month).to eq(29)
    end

    it "maps the `day_of_week' attribute" do
      expect(date_dimension.day_of_week).to eq(1)
    end

    it "maps the `day_name' attribute" do
      expect(date_dimension.day_name).to eq('Monday')
    end

    it "maps the `day_name_abbreviated' attribute" do
      expect(date_dimension.day_name_abbreviated).to eq('Mon')
    end

    it "maps the `weekday_weekend' attribute" do
      expect(date_dimension.weekday_weekend).to eq('Weekday')
    end
  end
end
