require 'rails_helper'

RSpec.describe TagScope do
  describe '#call' do
    it 'fetches subscribers that has specified tags' do
      campaign = Fabricate.build :campaign
      scope = described_class.new Subscriber.where(nil), campaign

      expect(scope).to receive(:pluck_tag_ids).with(nil).twice
        .and_return([1, 2])

      expect(scope.call.to_sql).to include <<-SQL.squish!
        SELECT "subscribers".* FROM "subscribers"
        LEFT OUTER JOIN "taggings"
        ON "taggings"."subscriber_id" = "subscribers"."id"
        WHERE "taggings"."tag_id" IN (1, 2)
          AND ("taggings"."tag_id" NOT IN (1, 2)
          OR "taggings"."tag_id" IS NULL)
      SQL
    end
  end
end
