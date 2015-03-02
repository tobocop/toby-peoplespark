class Office < ActiveRecord::Base

  def self.all_office_id
    where('location = ?', 'All Offices').first.id
  end
end
