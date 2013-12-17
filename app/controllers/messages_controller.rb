class MessagesController < ApplicationController

  def create
    @message = Message.new(number: params[:number], text: params[:text], when: params[:when])
    if(@message.save)
      Resque.enqueue_at(@message.when, SendMessageJob, :message => @message)
      render json: @message.as_json
    else
      render json: @message.errors.full_messages, status: 400
    end
  end

end
