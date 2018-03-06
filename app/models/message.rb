class Message < ApplicationRecord
  belongs_to :user
  belongs_to :receiver, :class_name => 'User'

  validates :user_id, presence: true
  validates :receiver_id, presence: true
  validates :content, presence: true, length: { maximum: 255 }
end
