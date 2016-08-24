class Relationship < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: :follower, recipient: :followed
  belongs_to :follower, class_name: User.name
  belongs_to :followed, class_name: User.name
  validates :follower_id, presence: true
  validates :followed_id, presence: true
  validates_uniqueness_of :follower_id, scope: :followed_id
  validates_uniqueness_of :followed_id, scope: :follower_id
end
