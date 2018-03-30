class MessagesController < ApplicationController
    before_action :set_users, only: [:index, :new, :create]
    before_action :set_message, only: [:edit, :update, :destroy]
    before_action :set_messages, only: [:room]
  
    def index
      @receivers = @sender.other_users
    end
  
    def new
      @message = @sender.messages.build
    end
  
    def create
      @message = @sender.messages.build(message_params)
      if @message.save
        flash[:success] = 'メッセージが作成されました'
        redirect_to room_user_message_path(@sender, @receiver)
      else
        flash.now[:danger] = 'メッセージが作成されませんでした'
        render room_user_message_path(@sender, @receiver)
      end
    end
  
    def edit
    end
  
    def update
      if @message.update(message_params)
        flash[:success] = 'メッセージが更新されました'
        redirect_to room_user_message_path(@sender, @receiver)
      else
        flash.now[:danger] = 'メッセージが更新されませんでした'
        render :edit
      end
    end
  
    def destroy
      @message.destroy
      flash[:success] = 'メッセージが削除されました'
      redirect_to room_user_message_path(@sender, @receiver)
    end

    def room
      @messages = @sender_messages.or(@receiver_messages).order("created_at ASC")
      @message = @sender.messages.build
    end
  
    private
  
    def set_users
      @sender = User.find(params[:user_id])
      if params[:receiver_id]  
        @receiver = Receiver.find(params[:receiver_id])
      elsif params[:message]
        @receiver = Receiver.find(params[:message][:receiver_id])
      end
    end

    def set_message
      set_users
      @message = Message.find(params[:id])
    end

    def set_messages
      set_users
      @sender_messages = @sender.conversations(@receiver)
      @receiver_messages = @receiver.conversations(@sender)
    end
  
    def message_params
      params.fetch(:message, {}).permit(:content, :user_id, :receiver_id)
    end
end
