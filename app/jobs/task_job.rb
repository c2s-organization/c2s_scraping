class TaskJob < ApplicationJob
  queue_as :scrape_task

  retry_on StandardError, wait: 30.seconds, attempts: 5

  def perform(task_id, status, scraped_data = nil)
    TaskService.call(task_id, status, scraped_data)
  end
end
