# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  email                  :string(255)
#  password_digest        :string(255)
#  remember_me_token      :string(255)
#  password_reset_token   :string(255)
#  password_reset_sent_at :datetime
#  profile_id             :integer
#  status                 :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class User < ActiveRecord::Base
  STATUS = { New: 1, Active: 2, Disabled: 3 }.freeze
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  attr_accessible :email, :name, :password, :password_confirmation, :profile_id
  has_secure_password

  belongs_to :profile

  before_create :default_values
  before_create { generate_token(:remember_me_token) }
  before_save { self.email.downcase! }

  validates :name, :presence => true, :length => { maximum: 100 }
  validates :email, :presence   => true,
                    :format     => { with: VALID_EMAIL_REGEX },
                    :uniqueness => { case_sensitive: false }
  validates :password, :presence => true, :on => :create, :length => { minimum: 6 }
  validates :password_confirmation, :presence => true
  validates :profile_id, :presence => true
  validates :status, :presence => true, :inclusion => { in: STATUS }

  def status
    STATUS.key(read_attribute(:status))
  end
  
  def status= (value)
    write_attribute(:status, STATUS[value])
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    # UserMailer.password_reset(self).deliver
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  private

    def default_values
      self.status = :New
    end
  
  # def self.authenticate(email, password)
  #   find_by_email(email).try(:authenticate, password)
  # end
end
