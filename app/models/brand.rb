# == Schema Information
#
# Table name: brands
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Brand < ActiveRecord::Base
  has_many :lacquers
  has_many :user_lacquers, through: :lacquers
  validates :name, presence: true
  validates :name, uniqueness: true
  accepts_nested_attributes_for :user_lacquers

  def abbreviation
    name.split.first.downcase
  end
end

