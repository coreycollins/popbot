require 'twilio-ruby'

module SendMessageJob
  @queue = :messages

  def self.perform(data)
    @message = data["message"]

    account_sid = 'ACf65427468b25e9bc500f57d5ce7b2c31' 
    auth_token = 'cf9c6d5f91d366bbd8f3f4fc87965e60' 
   
    # set up a client to talk to the Twilio REST API 
    @client = Twilio::REST::Client.new account_sid, auth_token 
     
    @client.account.messages.create({
      :from => @message["number"], 
      :to => '4024190769', 
      :body => @message["text"]
    })

    puts "Sent message: #{@message}"

  end

end