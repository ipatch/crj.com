class User < ActiveRecord::Base

	before_create { generate_token(:confirmation_token) }

	has_secure_password


	## source = http://railscasts.com/episodes/274-remember-me-reset-password
	# the below line was causing an error in rails 4.2.0
	# before_create { generate_token(:auth_token) }
 
	# the below line won't work with rails 4.x
	
	# attr_accessible :email, :password, :password_confirmation

	validates_uniqueness_of :email

	has_many :articles, dependent: :destroy

	has_many :attachments



	def generate_token(column)
    	begin
      		self[column] = SecureRandom.urlsafe_base64
    	end while User.exists?(column => self[column])
  	end

	def send_password_reset
		generate_token(:password_reset_token)
		self.password_reset_sent_at = Time.zone.now
		save!
		UserMailer.password_reset(self).deliver_now
	end

	def send_confirmation
		generate_token(:confirmation_token)
		self.confirmation_sent_at = Time.zone.now
		save!
		UserMailer.confirmation(self).deliver_now
	end
end
