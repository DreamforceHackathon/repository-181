class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def chart
    @sequence = Sequence.first
    analyzer = Analyzer::Flat.new(@sequence.daily_data)
    @sbar = Charter::Sbar.new(analyzer)
    @xbar = Charter::Xbar.new(analyzer)
  end
end
