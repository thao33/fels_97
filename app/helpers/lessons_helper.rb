module LessonsHelper
  def progress_tag value, total
    "#{value}/#{total}"
  end

  def date_format_month_name
    Date::MONTHNAMES[Time.now.month]
  end
end
