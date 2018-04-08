class TargetDate < ApplicationRecord

  def date
    "#{year}/#{month}/#{day}"
  end

  def date_for_query
    sprintf('%04d%02d%02d', year, month, day)
  end
end
