require 'digest/sha1'

class User < ApplicationRecord
	self.table_name = "user"

	before_create :encrypt_password
	after_create :clear_password
	validates :user_name, :presence => {message: "is required" }, :length => { in: 4..20, message: "from 4 to 20 charters"}, uniqueness: true
	validates :password, :presence => true, length: { in: 6..20, message: "from 6 to 20 charters"}, :on => :create


	def encrypt_password
	  if password.present?
	    self.salt = Digest::SHA1.hexdigest("abcdefghk#{Time.now}")	   
	    self.password = Digest::SHA1.hexdigest("#{salt}#{password}")
	  end
	end
	def clear_password
	  self.password = nil
	end

	def self.authenticate(username="", login_password="")
	  user = User.find_by_user_name(username)	  
	  if user && user.match_password(login_password)
	    return user
	  else
	    return false
	  end
	end  

	def match_password(login_password="")
		return password == Digest::SHA1.hexdigest("#{salt}#{login_password}")
	end

	def self.koala(auth)
    access_token = auth['token']
    Koala.config.api_version = "v2.10"
    facebook = Koala::Facebook::API.new(access_token)
    facebook.get_object("me?fields=name,picture,birthday,email")   
  end
end
