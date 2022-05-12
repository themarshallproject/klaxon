# Be sure to restart your server when you modify this file.

Rails.application.config.session_store(
  :cookie_store,
  key: '_klaxon_session',
  same_site: Rails.configuration.force_ssl ? :none : :lax,
  secure: Rails.configuration.force_ssl
)
