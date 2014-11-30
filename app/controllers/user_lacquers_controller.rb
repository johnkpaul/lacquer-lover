class UserLacquersController < ApplicationController

  def create
    lacquer = Lacquer.find(params[:user_lacquer][:lacquer_id])
    UserLacquer.create(user_lacquer_params)
    flash[:notice] = "#{lacquer.name} has been added to your collection!"
    redirect_to(:back)
  end

  def update
    @user_lacquer = UserLacquer.find(params[:id])
    @user_lacquer.update(user_lacquer_params)
    redirect_to(:back)
  end

  def destroy
    user_lacquer = UserLacquer.where(user_id: params['user_id'], lacquer_id: params['lacquer_id']).first
    if params['user_id'].to_i == current_user.id
      user_lacquer.destroy
      redirect_to(:back)
    else
      flash[:notice] = "You can't delete another user's lacquer!"
      redirect_to(:back)
    end
  end

  private
    def user_lacquer_params
      params.require(:user_lacquer).permit(:user_id, :lacquer_id, :loanable, :on_loan)
    end
end
