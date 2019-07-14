class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @questions = Question.last_day

    mail to: user.email
  end
end
