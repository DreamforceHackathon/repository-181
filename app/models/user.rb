class User < ActiveRecord::Base
  has_many :sequences
  has_many :chart_instances

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :omniauthable, omniauth_providers: [:salesforce]

  SFDC_FIELDS = { "leads" => "Lead", "contacts" => "Contact",
                  "accounts" => "Account", "activities" => "Task",
                  "opportunities" => "Opportunity" }

  validates_presence_of :name
  validates_presence_of :organization

  def sfdc_config
    super || Hash.new
  end

  def normalized_sfdc_config
    Hash.new.tap do |h|
      SFDC_FIELDS.keys.each do |field|
        if sfdc_config.has_key?(field)
          h[field] = sfdc_config[field]
        else
          h[field] = false
        end
      end
    end
  end

  def restforce
    if sfdc_oauth_token && sfdc_instance_url && sfdc_refresh_token
      @restforce ||= Restforce.new oauth_token: sfdc_oauth_token,
                                   refresh_token: sfdc_refresh_token,
                                   instance_url: sfdc_instance_url,
                                   client_id: ENV["SALESFORCE_KEY"],
                                   client_secret: ENV["SALESFORCE_SECRET"]
    end
  end
end
