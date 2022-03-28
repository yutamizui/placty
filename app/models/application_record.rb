class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def translated_name
    if I18n.locale == :ja
      "#{ja_name}"
    elsif I18n.locale == :en
      "#{en_name}"
    end
  end

  def localize(time, zone)
    I18n.l time.in_time_zone(zone)
  end
end
