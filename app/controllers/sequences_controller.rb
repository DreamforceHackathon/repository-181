class SequencesController < ApiController
  def show
    respond_with sequence, serializer: SequenceDataSerializer
  end

  private

  def sequences
    @sequences ||= Sequence.all
  end

  def sequence
    @sequence ||= sequences.find(params[:id])
  end
end
