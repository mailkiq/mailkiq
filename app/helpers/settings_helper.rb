module SettingsHelper
  def simple_form_for_aws(html_options = {}, &block)
    simple_form_for current_user,
                    url: aws_settings_path,
                    html: { method: :put }.merge(html_options),
                    &block
  end
end
