require 'rails_helper'

describe DomainWorker, type: :worker do
  it { is_expected.to save_backtrace }
  it { is_expected.to be_processed_in :platform }
end
