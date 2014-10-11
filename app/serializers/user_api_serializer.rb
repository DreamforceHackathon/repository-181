class UserApiSerializer < ActiveModel::Serializer
  attributes :id, :name, :organization, :email, :sfdc_config, :sfdc_setup

  def sfdc_config
    object.normalized_sfdc_config
  end
end
