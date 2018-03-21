class ReceiversController < ApplicationController
    def index
        @receivers = current_user.other_users
    end

    def show  
    end

    def room
        @user = User.find(params[:user_id])
        @receiver = Receiver.find(params[:receiver_id])
        user_messages = current_user.conversations(@receiver)
        receiver_messages = @receiver.conversations(current_user)
        @messages = user_messages.or(receiver_messages).order("created_at ASC")
        @message = @user.messages.build
    end
end
