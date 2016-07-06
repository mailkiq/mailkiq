require 'rails_helper'

RSpec.describe Prospect, type: :model do
  subject do
    described_class.new email: 'teste@teste.com', account_id: 10, tag: 'slug'
  end

  describe '#save!' do
    before do
      expect_any_instance_of(Subscriber).to receive(:save!)
    end

    it 'merges tag with given name' do
      relation = double('relation')

      expect(relation).to receive(:pluck).with(:id).and_return([])
      expect(Tag).to receive(:where)
        .with(slug: 'slug', account_id: subject.model.account_id)
        .and_return(relation)
      expect(subject).to receive(:send_confirmation_instructions)
      expect(subject.model).to receive(:tag_ids=).and_return(nil)

      subject.save!
    end

    it 'delivers confirmation email' do
      automation = Fabricate.build :automation
      relation = double('relation')

      expect(relation).to receive(:where)
        .with(account_id: subject.model.account_id)
        .and_return(relation)
      expect(relation).to receive(:first).and_return(automation)

      expect(Automation).to receive(:confirmation).and_return(relation)
      expect(CampaignJob).to receive(:enqueue)
        .with(automation.id, subject.model.id)
      expect(subject).to receive(:merge_tags)

      subject.save!
    end
  end
end
