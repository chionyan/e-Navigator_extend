class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  enum sex: { male: 1, female: 2 , other: 3 }

  has_many :interviews
  has_many :messages

  def other_users
    User.where.not(id: id)
  end

  def conversations(receiver)
    messages.where(receiver_id: receiver)
  end

  def age
    return unless birthdate

    date_format = "%Y%m%d"
    today = Date.today
    (today.strftime(date_format).to_i - birthdate.strftime(date_format).to_i) / 10000
  end

  def approvaldate
    approval_interview = interviews.find_by(interview_status: "承認")
    if approval_interview
      approval_interview.interview_date_format
    else
      nil
    end
  end

  def interviews_url
    root = "https://e-navigator-chionyan.herokuapp.com/"
    user_interviews_url = Rails.application.routes.url_helpers.user_interviews_path(self)
    root + user_interviews_url.slice(1..user_interviews_url.length)
  end
  
end
