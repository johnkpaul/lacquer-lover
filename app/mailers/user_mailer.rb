class UserMailer < ActionMailer::Base
  default from: "Lacquer Love&Lend <lacquerloveandlend@gmail.com>"

  # welcome on first login
  def welcome_email(user)
    @user = user
    @signin_url = "http://lacquer-love-and-lend.herokuapp.com/auth/facebook"
    
    mail(to: @user.email, subject: 'Welcome to Lacquer Love&Lend!', bcc: "lacquerloveandlend@gmail.com")

    headers['X-MC-Track'] = "opens, clicks_all"
  end

  # email to invite other people who are not yet users
  def invite_email(user, emails)
    @user = user
    @friend_url = "http://lacquer-love-and-lend.herokuapp.com/friendships/new?friend_id=#{@user.id}"

    mail(to: emails, subject: "#{user.name} wants to share with you on Lacquer Love&Lend!", bcc: "lacquerloveandlend@gmail.com")

    headers['X-MC-Track'] = "opens, clicks_all"
  end

  # notif of friend request
  def friend_request_notification(user, friend)
    @user = user
    @friend = friend
    @friend_url = "http://lacquer-love-and-lend.herokuapp.com/friendships/new?friend_id=#{@user.id}"

    mail(to: @friend.email, subject: "#{@user.name} wants to be friends with you on Lacquer Love&Lend!")

    headers['X-MC-Track'] = "opens, clicks_all"
  end

  # notif of friend request accepted
  def friend_request_accepted_notification(user, friend)
    @user = user
    @friend = friend
    @friend_url = "http://lacquer-love-and-lend.herokuapp.com/users/#{@friend.id}"

    mail(to: @user.email, subject: "#{@friend.name} accepted your friendship on Lacquer Love&Lend!")

    headers['X-MC-Track'] = "opens, clicks_all"
  end

  # notif of loan request
  def loan_request_notification(owner, requester, user_lacquer)
    @owner = owner
    @requester = requester
    @user_lacquer = user_lacquer
    @user_url = "http://lacquer-love-and-lend.herokuapp.com/users/#{@owner.id}"

    mail(to: @owner.email, subject: "#{@requester.name} wants to borrow #{@user_lacquer.lacquer.name}")

    headers['X-MC-Track'] = "opens, clicks_all"
  end

  # notif of loan request accepted
  def loan_request_accepted_notification(transaction)
    @owner = transaction.owner
    @requester = transaction.requester
    @user_lacquer = transaction.user_lacquer

    mail(to: @requester.email, subject: "#{@owner.name} has agreed to loan you #{@user_lacquer.lacquer.name}!")

    headers['X-MC-Track'] = "opens, clicks_all"
  end

  # notif of loan due date
  def loan_due_date_notification(transaction)
    @owner = transaction.owner
    @requester = transaction.requester
    @user_lacquer = transaction.user_lacquer
    @lacquer_name = @user_lacquer.lacquer.name
    @transaction = transaction
    @days_left = (transaction.due_date.to_date - Date.today).to_i

    mail(to: @requester.email, subject: "#{@lacquer_name} is due back to #{@owner.name} on #{@transaction.due_date.strftime("%m/%d/%Y")}.")

    headers['X-MC-Track'] = "opens, clicks_all"
  end

  def transactional_message(bcc_email, reply_address, to_address, subject, body, transaction_id)
    @reply_url = "http://lacquer-love-and-lend.herokuapp.com/new_transactional_message?transaction_id=#{transaction_id}"
    @body = body
    mail(:from => reply_address, :to => to_address, :subject => subject, :bcc => bcc_email)
    
    headers['X-MC-Track'] = "opens, clicks_all"
  end

  # notif of loan turned into gift?
  

end
