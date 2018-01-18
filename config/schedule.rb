set :environment, "development"
set :output, error: "log/cron_error_log.log", standard: "log/cron_log.log"

every "0 0 27 * *" do
  rake "send_notification_remind_report_month"
end

every "0 0 27 3,6,9,12 *" do
  rake "send_notification_remind_report_quarter"
end