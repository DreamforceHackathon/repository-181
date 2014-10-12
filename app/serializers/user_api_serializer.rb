class UserApiSerializer < ActiveModel::Serializer
  attributes :id, :name, :organization, :email, :sfdc_config, :sfdc_setup, :sfdc_keys

  def sfdc_keys
    object.sfdc_oauth_token.present?
  end

  def sfdc_config
    object.normalized_sfdc_config
  end
end
