# Be sure to restart your server when you modify this file.

#MarkItNow::Application.config.session_store :cookie_store, key: '_mark_it_now_session'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
MarkItNow::Application.config.session_store :cookie_store,  session_domain: "mark_it_now.ssig33.com", expire_after: 6.weeks
