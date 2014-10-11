class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def salesforce
    user = from_omniauth(env["omniauth.auth"])

    sign_in(user) if user.persisted?

    redirect_to root_path
  end

  private

  def from_omniauth(auth)
    user = User.first_or_initialize(email: auth.info.email)
    user.provider = auth.provider
    user.uid = auth.uid
    user.name = auth.info.name if user.name.blank?
    user.save
    user
  end
end
