module API
  module V1
    class SubscriberResource < BaseResource
      attributes :name, :email, :tags

      before_save do
        @model.account_id = current_account.id
      end

      def tags
        @model.tags.pluck(:name)
      end

      def tags=(new_tags)
        tag_ids = current_account.tags.where(name: new_tags).pluck(:id)
        @model.tag_ids = @model.tag_ids | tag_ids
      end

      def replace_fields(data)
        redefine_model data.dig(:attributes, :email) if @model.new_record?
        super(data)
      end

      private

      def redefine_model(email)
        @model = current_account.subscribers.find_or_initialize_by email: email
      end
    end
  end
end
