# Preview all emails at http://localhost:3000/rails/mailers/user_invite_mailer
class UserInviteMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_invite_mailer/invite
  def invite
    UserInviteMailer.invite
  end

end
