class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :omniauthable, omniauth_providers: [:salesforce]

  validates_presence_of :name
  validates_presence_of :organization
end
