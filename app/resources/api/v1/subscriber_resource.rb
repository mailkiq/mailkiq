module API
  module V1
    class SubscriberResource < JSONAPI::Resource
      attributes :name, :email, :tags

      before_save do
        @model.state = :active if @model.new_record?
        @model.account_id = context[:current_account].id
      end

      def tags
        @model.tags.pluck(:name)
      end

      def tags=(new_tags)
        account_id = context[:current_account].id
        tag_ids = Tag.where(name: new_tags, account_id: account_id).pluck(:id)
        @model.tag_ids = @model.tag_ids | tag_ids
      end
    end
  end
end
