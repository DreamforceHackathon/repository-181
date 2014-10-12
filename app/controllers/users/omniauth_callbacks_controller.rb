class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def salesforce
    user = from_omniauth(env["omniauth.auth"])

    sign_in(user) if user.persisted?

    redirect_to root_path
  end

  private

  def from_omniauth(auth)
    User.first_or_initialize(email: auth.info.email).tap do |user|
      user.sfdc_instance_url = auth.credentials.instance_url
      user.sfdc_oauth_token = auth.credentials.token
      user.sfdc_refresh_token = auth.credentials.refresh_token
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email if user.email.blank?
      user.name = auth.info.name if user.name.blank?
      user.save
    end
  end
end
