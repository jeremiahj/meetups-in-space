class Meetup < ActiveRecord::Base
  has_many :usermeetups
  has_many :users, through: :usermeetups

  validates :name, presence: true, uniqueness: true
  validates :detail, presence: true
  validates :location, presence: true
end
