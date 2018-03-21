class MessagesController < ApplicationController
    before_action :set_user, only: [:index, :new, :create]
    before_action :set_message, only: [:show, :edit, :update, :destroy]
  
    def index
      @users = User.where.not(id: current_user.id)
    end
  
    def show
    end
  
    def new
      @message = @user.messages.build
    end
  
    def create
      @message = @user.messages.build(message_params)
      if @message.save
        flash[:success] = 'メッセージが作成されました'
        redirect_to user_receiver_room_path(@user, @message.receiver_id)
      else
        flash.now[:danger] = 'メッセージが作成されませんでした'
        render user_receiver_room_path(@user, @message.receiver_id)
      end
    end
  
    def edit
    end
  
    def update
      if @message.update(message_params)
        flash[:success] = 'メッセージが更新されました'
        redirect_to user_receiver_room_path(@user, @message.receiver_id)
      else
        flash.now[:danger] = 'メッセージが更新されませんでした'
        render :edit
      end
    end
  
    def destroy
      @message.destroy
      flash[:success] = 'メッセージが削除されました'
      redirect_to user_receiver_room_path(@user, @message.receiver_id)
    end
  
    private
  
    def set_user
      @user = User.find(params[:user_id])
      @messages =  @user.interviews
    end
  
    def set_message
      @message = Message.find(params[:id])
      @user = @message.user
      @messages =  @user.messages
    end
  
    def message_params
      params.fetch(:message, {}).permit(:content, :user_id, :receiver_id)
    end
end
