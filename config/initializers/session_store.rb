# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_fbauth_session',
  :secret      => '5f443d8914faa94ac5d89d0db2f603aee432a7e1a7c206bfc51a03c08ba81008d3e5a69c87191f9cbe6fdb435a9f9ec3259f1873e8cc59c0c0d90df454b14c99'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
