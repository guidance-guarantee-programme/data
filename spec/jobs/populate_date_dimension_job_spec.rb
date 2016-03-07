require 'rails_helper'

RSpec.describe PopulateDateDimensionJob, type: :job do
  include ActiveJob::TestHelper

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end

  subject(:job) do
    described_class.perform_later(begin_date: serialized_begin_date, end_date: serialized_end_date)
  end

  let(:service) { instance_double('PopulateDateDimension', call: true) }

  let(:serialized_begin_date) { '2015-1-1' }
  let(:deserialized_begin_date) { Date.new(2015, 1, 1) }

  let(:serialized_end_date) { '2016-1-1' }
  let(:deserialized_end_date) { Date.new(2016, 1, 1) }

  it 'queues the job' do
    expect { job }
      .to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
  end

  it 'calls the service' do
    expect(PopulateDateDimension)
      .to receive(:new)
      .with(begin_date: deserialized_begin_date, end_date: deserialized_end_date)
      .and_return(service)

    perform_enqueued_jobs { job }
  end

  describe '.queue_name' do
    subject(:queue_name) { job.queue_name }

    it { is_expected.to eq('dimension') }
  end
end
