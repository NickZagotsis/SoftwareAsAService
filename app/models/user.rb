class User < ApplicationRecord
  has_many :posts
  has_many :friendships
  has_many :friends, through: :friendships, source: :friend
  has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id"
  has_many :inverse_friends, through: :inverse_friendships, source: :user
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  def friends
  # Friends where the current user is the initiator
  sent_requests = friendships.where(status: "accepted").map(&:friend)

  # Friends where the current user is the recipient
  received_requests = inverse_friendships.where(status: "accepted").map(&:user)

  # Combine both lists and ensure no duplicates
  (sent_requests + received_requests).uniq
  end
end
