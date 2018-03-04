class InterviewsController < ApplicationController
  before_action :set_user, only: [:index, :new, :create, :order, :cancel]
  before_action :set_interview, only: [:show, :edit, :update, :destroy]
  around_action :update_branch, only: [:update]

  def index
    @users = User.where.not(id: current_user.id)
    if @user == current_user
      @interviews = @user.interviews.order('interview_date DESC')
    else
      @interviews = @user.interviews.where.not(interview_status:"承認").order('interview_date DESC')
    end
  end

  def show
  end

  def new
    @interview = @user.interviews.build
  end

  def create
    @interview = @user.interviews.build(interview_params)
    if @interview.save
      flash[:success] = '面接が作成されました'
      redirect_to user_interview_path(@user, @interview)
    else
      flash.now[:danger] = '面接が作成されませんでした'
      render :new
    end
  end

  def edit
  end

  def update
    if @interview.update(interview_params)
      flash[:success] = '面接が更新されました'
      redirect_to user_interview_path(@user, @interview)
    else
      flash.now[:danger] = '面接が更新されませんでした'
      render :edit
    end
  end

  def destroy
    @interview.destroy
    flash[:success] = '面接が削除されました'
    redirect_to user_interviews_path(@user)
  end

  def order
    interviewer = User.find(params[:interviewer_id])
    if InterviewMailer.order(interviewee: @user, interviewer: interviewer).deliver
      flash[:success] = '申請が完了しました'
      redirect_to user_interviews_path(@user)
    else
      flash.now[:danger] = '申請に失敗しました'
      render :index
    end
  end

  def cancel
    if @interviews.update_all("interview_status='保留'")
      flash[:success] = '承認状態を解除しました'
      redirect_to user_interviews_path(@user)
    else
      flash.now[:danger] = '承認状態を解除できませんでした'
      render :index
    end
  end

  private

  def update_branch
    if @user == current_user
      yield
    else
      @interviews.update_all("interview_status='却下'")
      yield
      InterviewMailer.apply(interviewee: @user, interviewer: current_user).deliver
    end
  end

  def set_user
    @user = User.find(params[:user_id])
    @interviews =  @user.interviews
  end

  def set_interview  
    @interview = Interview.find(params[:id])
    @user = @interview.user
    @interviews =  @user.interviews
  end

  def interview_params
    params.fetch(:interview, {}).permit(:interview_date, :interview_status)
  end

end
