class User < ApplicationRecord
  PASSWORD_FORMAT = /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).+\z/

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :lockable, :confirmable

  validates :email, presence: true, uniqueness: true
  validates :encrypted_password, presence: true
  validates :password,
    format: {
      with: PASSWORD_FORMAT,
      message: "must include at least one uppercase letter, one lowercase letter, one number, and one special character"
    },
    allow_blank: true

  after_create_commit :send_welcome_email

  private

  def send_welcome_email
    UserMailer.welcome_email(self).deliver_now
  end
end
