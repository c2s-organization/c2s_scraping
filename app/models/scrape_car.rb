class ScrapeCar < ApplicationRecord

  validates_presence_of :task_id, :url
end
