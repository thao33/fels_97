class Identity < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, scope: :provider

  class << self
    def find_for_oauth auth
      find_or_create_by uid: auth.uid, provider: auth.provider
    end
  end
end
