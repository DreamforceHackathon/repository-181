class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout "angular", only: [:index]

  def index
    puts flash.inspect
  end

  def new_session_path(scope)
    abort "failure " + env["omniauth.auth"].inspect
  end
end
