class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def chart
    @sequence = Sequence.first
    analyzer = Analyzer::Mamr.new(@sequence.daily_data)
    @mamr = Charter::IndividualMamr.new(analyzer)
  end
end
