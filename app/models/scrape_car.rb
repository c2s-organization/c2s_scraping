class ScrapeCar < ApplicationRecord

  validates :task_id, presence: true
  validates :url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: "must be a valid Url" }

end
