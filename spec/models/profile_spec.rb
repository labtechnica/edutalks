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

require 'spec_helper'

describe Profile do
  
  let(:existing_profile) { FactoryGirl.create(:profile) }

  before do
    @new_profile = Profile.new(name: "Example profile", description: "Profile description")
  end

  subject { @new_profile }

  it { should respond_to(:name) }
  it { should respond_to(:description) }

  it { should be_valid }

  describe "should allow creating new profiles" do
    before { @new_profile.save }
    it { should be_valid }
  end

  it "should prevent updating existing profiles" do
  	expect do
  	  existing_profile.save
  	end.to raise_error(ActiveRecord::ReadOnlyRecord)
  end
end
