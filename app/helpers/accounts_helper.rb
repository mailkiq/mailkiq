module AccountsHelper
  def mixpanel_properties(account)
    {
      :$first_name => account.first_name,
      :$last_name  => account.last_name,
      :$created    => account.created_at,
      :$email      => account.email
    }
  end
end
