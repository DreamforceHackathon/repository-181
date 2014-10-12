class Restforce::Count
  def initialize(user)
    @user = user
  end

  def count_on_day(time)
    query = "SELECT COUNT() FROM #{collection_name} "
    if collection_name == "Lead"
      query = query + time_filter_lead(time)
    else
      query = query + time_filter(time)
    end

    query = @user.restforce.query(query)
    Rails.logger.info query
    query.size
  end

  def collection_name
    raise "Not implemented"
  end

  private

  def time_filter_lead(time)
    "WHERE Demo_CreatedAt__c > #{time.beginning_of_day.iso8601} AND Demo_CreatedAt__c < #{time.end_of_day.iso8601}"
  end

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
