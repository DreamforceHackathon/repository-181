class EntriesController < ApiController
  before_filter :authenticate_user!

  def index
    respond_with sequence, entries.order(point_time: :asc)
  end

  def show
    respond_with sequence, entry
  end

  def create
    respond_with sequence, entries.create(entry_params.merge(point_time: compute_time))
  end

  def destroy
    respond_with sequence, entry.destroy
  end

  def ignore
    time = Time.parse(params[:time])
    entries = sequence.entries.where(point_time: time.beginning_of_day..time.end_of_day)
    entries.update_all(ignored: true)

    render json: entries
  end

  private

  def sequence
    @sequence ||= current_user.sequences.find(params[:sequence_id])
  end

  def entries
    @entries ||= sequence.entries.all
  end

  def entry
    @entry ||= entries.find(params[:id])
  end

  def entry_params
    params.permit(:point_value)
  end

  # If time is "eod", return end of day if before midnight, or end of previous day if after midnight
  # If not, then take the current time or time given
  def compute_time
    if params[:point_time] == "eod"
      hour = Time.current.hour
      if hour < 6
        Time.current.beginning_of_day - 1.second
      else
        Time.current.end_of_day
      end
    elsif params[:point_time]
      params[:point_time]
    else
      Time.current
    end
  end
end
