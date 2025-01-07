class Record < ApplicationRecord
	belongs_to :user
	scope :for_month, ->(date) {
		where(fecha: date.beginning_of_month..date.end_of_month)
	}

end

