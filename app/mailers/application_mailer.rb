class ApplicationMailer < ActionMailer::Base
  add_template_helper LessonsHelper
  default from: "thao778051@gmail.com"
  layout "mailer"
end
