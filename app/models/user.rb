class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :lockable, :confirmable

  validates :email, presence: true, uniqueness: { conditions: -> { where(deleted_at: nil) } }
  validates :encrypted_password, presence: true

  after_create_commit :send_welcome_email

  def self.find_for_authentication(warden_conditions)
    super(warden_conditions)&.then { |user| user.deleted_at? ? nil : user }
  end

  def soft_delete!
    update_columns(
      deleted_at: Time.current,
      confirmation_token: nil,
      reset_password_token: nil,
      unlock_token: nil,
      updated_at: Time.current
    )
  end

  private

  def send_welcome_email
    UserMailer.welcome_email(self).deliver_now
  end
end
