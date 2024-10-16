class CreateScrapeCars < ActiveRecord::Migration[7.0]
  def change
    create_table :scrape_cars do |t|
      t.integer :task_id
      t.string :url

      t.timestamps
    end
  end
end
