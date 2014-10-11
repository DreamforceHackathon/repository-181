class EntriesController < ApiController
  def index
    respond_with sequence, entries
  end

  def show
    respond_with sequence, entry
  end

  def create
    respond_with sequence, entries.create(entry_params.merge(point_time: compute_time))
  end

  private

  def sequence
    @sequence ||= Sequence.find(params[:sequence_id])
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
