class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :votable, presence: true
  validates :user_id, uniqueness: { scope: %i[votable_type votable_id] }
end
