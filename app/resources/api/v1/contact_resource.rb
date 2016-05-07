module API
  module V1
    class ContactResource < SubscriberResource
      model_name 'Subscriber'

      before_save do
        @model.tag_ids = merge_tags
      end

      private

      def merge_tags
        tag_ids = current_account.tags.where(slug: context[:tag]).pluck(:id)
        @model.tag_ids | tag_ids
      end
    end
  end
end
