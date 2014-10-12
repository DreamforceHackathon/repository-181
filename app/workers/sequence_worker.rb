class SequenceWorker
  include Sidekiq::Worker

  def perform(sequence_id, date, repeat)
    @sequence_id = sequence_id
    date = Time.parse(date)

    if sequence.processor
      processor_klass = sequence.processor.constantize
      processor = processor_klass.new(sequence.user, date)
      processor.call!

      if repeat
        next_date = Time.now.end_of_day + 1.second
        SequenceWorker.perform_at(next_date, sequence_id, next_date, true)
      end
    end
  end

  private

  def sequence
    @sequence ||= Sequence.find(@sequence_id)
  end
end
