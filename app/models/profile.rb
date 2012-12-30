# == Schema Information
#
# Table name: profiles
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Profile < ActiveRecord::Base
  attr_accessible :description, :name

  #has_many   :users

  def readonly?
  	new_record? ? false : true
  end
end
