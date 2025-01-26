class Room < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_and_belongs_to_many :users
  validates :room_type, inclusion: { in: [ "private", "public" ] }
end
