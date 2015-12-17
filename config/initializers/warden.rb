Warden::Manager.after_set_user do |user, auth, opts|
  CUSTOM_LOGGER.info I18n.t("logging.admin.logged_in", username: user.name) if user.admin?
end

Warden::Manager.before_logout do |user,auth,opts|
  CUSTOM_LOGGER.info I18n.t("logging.admin.logged_out", username: user.name) if user.admin?
end