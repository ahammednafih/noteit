# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_noteit_session',
  :secret      => '6ef54a2fd1c422f9fca48ed385823653b779f98fee33dc7ec3c9e934d3f2711d63bb6b15ad86d912bc5df6a3d526f3bb964af62e69c6373cd56e970ed425214b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
