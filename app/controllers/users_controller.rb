class UsersController < ApplicationController
  # def create
  #   User.create(name: params[:name])
  # end

  def index
    if current_user
      @user = current_user
      @users = User.all
    else
      flash[:notice] = "Please sign in to continue!"
      redirect_to root_path
    end
  end

  def live_notifications
    @user = User.find(params[:id])
    respond_to do |format|
      format.js { }
    end
  end

  def user_lacquers
    @transaction = Transaction.new
    @user_lacquer = UserLacquer.find(params[:id])
    @user = User.find(params[:user_id])
    @favorite = Favorite.find_by(lacquer_id: @user_lacquer.lacquer_id, user_id: @user.id)
    respond_to do |format|
      format.js { }
    end
  end

  def show
    if current_user
      [{"OPI" => [@new_opi_lacquer, @opi_lacquers]}, {"Essie" => [@new_essie_lacquer, @essie_lacquers]}, {"Butter London" => [@new_butter_lacquer, @butter_lacquers]}, {"Deborah Lippmann" => [@new_deborah_lacquer, @deborah_lacquers]}].each do |brand_hash|
        brand_hash.each do |brand, variables|
          if !Brand.where(name: brand).empty?
            variables[0] = Brand.where(name: brand).first.lacquers.new
            variables[1] = Brand.where(name: brand).first.lacquers        
          end
        end
      end
      @new_user_lacquer = UserLacquer.new
      @user = User.find(params[:id])
      @transactions = @user.transactions
      @friends = @user.friends
      @friendship = current_user.friendships.new(friend: @user)
      @transaction = Transaction.new

      @user_lacquers = @user.user_lacquers.order("updated_at desc")
      
      respond_to do |format|
        format.js
        format.html
        format.json
      end
    else
      # temporary for testing purposes!
      @user = User.find(params[:id])
      respond_to do |format|
        format.json
        format.html do
          flash[:notice] = "Please sign in to continue!"
          redirect_to root_path
        end
      end
    end
  end

  def update
    @user = current_user
    if @user.update(user_params)
      flash[:notice] = "Thanks! Your info has been saved."
    else
      flash[:notice] = "Uh oh, something went wrong."
    end
    redirect_to :back
  end

  def search
    if !current_user
      flash[:notice] = "Please sign in to search for lacquer lovers!"
      redirect_to root_path
    else
      @search_term = params[:search_term]
      @results = User.where("lower(name) = ?", params[:search_term].downcase)
      if @results.empty?
        @results = User.where("lower(email) = ?", params[:search_term].downcase)
      end
      render :search_results
    end
  end

  def new_invite
    if !current_user
      flash[:alert] = "Sign in to start inviting friends!"
      redirect_to root_path
    end
  end

  def invite_friends
    @user = current_user
    @emails = params[:emails][0].split(/[\W\s]{2,}/).uniq
    UserMailer.invite_email(@user, @emails).deliver
    if @emails.count > 1
      flash[:success] = "You've successfully sent invitations to #{@emails.to_sentence}!"
    else
      flash[:success] = "You've successfully sent an invitation to #{@emails[0]}!"
    end
    redirect_to user_path(@user)
  end

  private
  def user_params
    params.require(:user).permit(:email)
  end

end
