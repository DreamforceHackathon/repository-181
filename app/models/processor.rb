class Processor
  attr_reader :user, :date

  def initialize(user, date)
    @user, @date = user, date
  end

  def call!
    if user.restforce && sequence.try!(:active?)
      sequence.entries.where(source: "processor", point_time: date.beginning_of_day..date.end_of_day).destroy_all
      sequence.entries.create!(point_time: date.beginning_of_day + 1.minute, point_value: count, source: "processor")
    end
  end

  private

  def sequence
    @sequence ||= user.sequences.find_by(processor: self.class.name)
  end

  def impl
    raise "not implemented"
  end

  def count
    @count ||= impl.new(user).count_on_day(date)
  end

  # For all of the basic collections that use this count interface, define their classes
  User::SFDC_FIELDS.values.each do |type|
    class_string =
      """
      class Processor::#{type} < Processor
        def impl
          Restforce::Count::#{type}
        end
      end
      """
    eval(class_string)
  end
end
