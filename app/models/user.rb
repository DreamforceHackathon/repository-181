class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :omniauthable, omniauth_providers: [:salesforce]

  SFDC_FIELDS = ["leads", "contacts", "activities", "opportunities", "deals"]

  validates_presence_of :name
  validates_presence_of :organization

  def normalized_sfdc_config
    Hash.new.tap do |h|
      SFDC_FIELDS.each do |field|
        if sfdc_config.has_key?(field)
          h[field] = sfdc_config[field]
        else
          h[field] = false
        end
      end
    end
  end
end
