require_relative '../../lib/utils'

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true


  def self.random_uid(salt = '')
    uid = ''
    begin    	
      uid = Utils.sample_uids.to_s
      uid = salt + '_' + uid if salt.present?
    end while self.exists?(:uid => uid) || uid.blank?
    uid
  end
end
