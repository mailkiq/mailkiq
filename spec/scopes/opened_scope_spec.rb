require 'rails_helper'

describe OpenedScope do
  describe '#call' do
    it 'fetches subscribers that opened a given campaign' do
      campaign = Fabricate.build :campaign
      scope = described_class.new Subscriber.where(nil), campaign

      expect(scope).to receive(:pluck_campaign_ids).with(nil)
        .at_least(:once)
        .and_return([1, 2])

      expect(scope.call.to_sql).to include <<-SQL.squish!
        SELECT DISTINCT "subscribers".* FROM "subscribers"
        LEFT OUTER JOIN "messages"
        ON "messages"."subscriber_id" = "subscribers"."id"
        WHERE ("messages"."campaign_id" IN (1, 2)
          AND "messages"."opened_at" IS NOT NULL)
          AND ("messages"."campaign_id" IN (1, 2)
          AND "messages"."opened_at" IS NULL)
      SQL
    end
  end
end
