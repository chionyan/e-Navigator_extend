class UsersController < ApplicationController
    def index
        if current_user
            @users = current_user.other_users
        end
    end

    def show
        @user = current_user
        redirect_to(user_interviews_path(@user))
    end
end
