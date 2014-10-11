class UsersController < ApiController
  def create
    user = User.create(user_params)
    sign_in(user) if user.persisted?
    respond_with user, serializer: UserApiSerializer
  end

  def show
    if current_user
      respond_with current_user, serializer: UserApiSerializer
    else
      render json: {}, status: 404
    end
  end

  def logout
    sign_out

    render json: true
  end

  private

  def user_params
    @user_params ||= params.permit(:name, :organization, :email, :password)
  end
end
