class UserMailer < ApplicationMailer
  def welcome_email(user = nil)
    @user = user || params[:user]
    mail(to: @user.email, subject: "Welcome to Employee Leave Portal")
  end
end
