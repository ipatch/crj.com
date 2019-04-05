class ContactController < ApplicationController
  def index
  end

  def contact
  end

  def new
  	@message = Message.new
  end

  def create
  	@message = Message.new(params[:message])
  	if @message.valid?
  		# TODO send message here
      UserMailer.new_message(@message).deliver_now
  		redirect_to root_url, notice: "Message sent. Thanks for contacting us."
  	else
      flash.now.alert = "Please fill all fields."
  		render "contact"
  	end
  end
end
