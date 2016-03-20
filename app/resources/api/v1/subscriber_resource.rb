module API
  module V1
    class SubscriberResource < JSONAPI::Resource
      attributes :name, :email, :tags

      def self.records(options = {})
        context = options[:context]
        context[:current_account].subscribers
      end

      def tags
        @model.tags.pluck(:name)
      end

      def tags=(new_tags)
        tag_ids = @model.account.tags.where(name: new_tags).pluck(:id)
        @model.tag_ids = @model.tag_ids | tag_ids
      end
    end
  end
end
