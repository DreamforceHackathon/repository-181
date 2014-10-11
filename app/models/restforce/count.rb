class Restforce::Count
  def initialize(user)
    @user = user
  end

  def count_on_day(time)
    @user.restforce.query("SELECT COUNT() FROM #{collection_name} " + time_filter(time)).size
  end

  def collection_name
    raise "Not implemented"
  end

  private

  def time_filter(time)
    "WHERE CreatedDate > #{time.beginning_of_day.iso8601} AND CreatedDate < #{time.end_of_day.iso8601}"
  end

  # For all of the basic collections that use this count interface, define their classes
  User::SFDC_FIELDS.values.each do |type|
    class_string =
      """
      class Restforce::Count::#{type} < Restforce::Count
        def collection_name
          '#{type}'
        end
      end
      """
    eval(class_string)
  end
end
