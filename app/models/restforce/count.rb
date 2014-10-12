class Restforce::Count
  def initialize(user)
    @user = user
  end

  def count_on_day(time)
    query = @user.restforce.query("SELECT COUNT() FROM #{collection_name} " + time_filter(time))
    Rails.logger.info query
    query.size
  end

  def collection_name
    raise "Not implemented"
  end

  private

  def time_filter(time)
    "WHERE Demo_CreatedAt__c > #{time.beginning_of_day.iso8601} AND Demo_CreatedAt__c < #{time.end_of_day.iso8601}"
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
