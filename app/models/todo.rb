class Todo < ApplicationRecord
  has_many :todo_items
  belongs_to :user
end
