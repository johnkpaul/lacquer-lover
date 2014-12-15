class User < ActiveRecord::Base
  has_many :user_lacquers
  has_many :lacquers, through: :user_lacquers
  has_many :friendships
  has_many :friends, through: :friendships
  has_many :transactions, :foreign_key => "requester_id"
  has_many :swatches

  validates :name, presence: true, uniqueness: true
  #accepts_nested_attributes_for :user_lacquers


  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end

  def first_name
    name.split.first
  end

  def last_name
    name.split.last
  end

  def accepted_friends_json
    friends_array = []
    accepted_friends.each do |friend|
      hash = {}
      hash[:name] = friend.name
      hash[:link] = "#{friend.id}"
      friends_array << hash
    end
    friends_array
  end

  def accepted_friends
    accepted_friends = []
    Friendship.where(user_id: self.id, state: 'accepted').each do |friendship|
      accepted_friends << User.find(friendship.friend_id)
    end
    Friendship.where(friend_id: self.id, state: 'accepted').each do |friendship|
      accepted_friends << User.find(friendship.user_id)
    end
    accepted_friends
  end

  def requested_friends_awaiting_approval
    pending_friends = []
    Friendship.where(user_id: self.id, state: 'pending').each do |friendship|
      pending_friends << User.find(friendship.friend_id)
    end
    pending_friends
  end

  def rejected_friend_requests
    Friendship.where(user_id: self.id, state: 'rejected')
  end

  def friendships_for_your_approval
    pending_friendships = []
    Friendship.where(friend_id: self.id, state: 'pending').each do |friendship|
      pending_friendships << friendship
    end
    pending_friendships
  end

  def friends_for_your_approval
    pending_friends = []
    Friendship.where(friend_id: self.id, state: 'pending').each do |friendship|
      friend = User.find(friendship.user_id)
      pending_friends << friend
    end
    pending_friends
  end

  def all_friends
    accepted_friends + requested_friends_awaiting_approval + friends_for_your_approval
  end

  def has_blocked?(other_user)
    blocked_friends.include?(other_user)
  end

  def requested_transactions
    Transaction.where(requester_id: self.id)
  end

  def pending_requested_transactions
    requested_transactions.where(state: 'pending')
  end

  def rejected_requested_transactions
    requested_transactions.where(state: 'rejected')
  end

  def accepted_requested_transactions
    requested_transactions.where(state: 'accepted')
  end

  def active_requested_transactions
    requested_transactions.where(state: 'active')
  end

  def concluded_requested_transactions
    requested_transactions.where(state: 'completed')
  end

  def owned_transactions
    Transaction.where(owner_id: self.id)
  end

  def transactions_for_your_approval
    owned_transactions.where(state: 'pending')
  end

  def transactions_you_accepted
    owned_transactions.where(state: 'accepted')
  end

  def active_owned_transactions
    owned_transactions.where(state: 'active')
  end

  def concluded_owned_transactions
    owned_transactions.where(state: 'completed')
  end

  def lacquers_added_by
    Lacquer.where(user_added_by_id: self.id)
  end


end
