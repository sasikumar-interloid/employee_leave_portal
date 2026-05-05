class User < ApplicationRecord
  # -- Constants -------------------------------------------------------------
  PASSWORD_FORMAT = /\A
    (?=.*[a-z])          # lowercase
    (?=.*[A-Z])          # uppercase
    (?=.*\d)             # digit
    (?=.*[^A-Za-z0-9])   # special character
    .+
  \z/x

  # -- Devise ----------------------------------------------------------------
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :lockable,
         :confirmable

  # -- Validations -----------------------------------------------------------
  validates :email, presence: true, uniqueness: { case_sensitive: false }

  validates :password,
            format: {
              with: PASSWORD_FORMAT,
              message: "must include at least one uppercase letter, one lowercase letter, one number, and one special character"
            },
            allow_blank: true

  # -- Callbacks -------------------------------------------------------------
  after_commit :send_welcome_email, on: :create

  # -- Public Methods --------------------------------------------------------
  def initials
    email.first.upcase
  end

  private

  def send_welcome_email
    UserMailer.with(user: self).welcome_email.deliver_later
  end
end
