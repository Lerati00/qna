class Services::DailyDigest
  def send_digest
    User.all.find_each do |user|
      DailyDigestMailer.digest(user).deliver_later
    end
  end
end