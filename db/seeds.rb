# Clear existing data to ensure idempotency
Note.destroy_all
User.destroy_all

puts "== Seeding Users =="

# Create user 1
user1 = User.create!(
  user_name: "johndoe",
  first_name: "John",
  last_name: "Doe",
  email: "demo@example.com",
  password: "password",
  password_confirmation: "password"
)
user1.confirm # Devise confirmable helper
puts "Created User: #{user1.user_name} (#{user1.email})"

# Create user 2
user2 = User.create!(
  user_name: "janesmith",
  first_name: "Jane",
  last_name: "Smith",
  email: "jane@example.com",
  password: "password123",
  password_confirmation: "password123"
)
user2.confirm
puts "Created User: #{user2.user_name} (#{user2.email})"

puts "\n== Seeding Notes =="

# Notes for John Doe
note1 = user1.notes.create!(
  title: "My First Private Note",
  content: "<div>This is a private note. Only <strong>John Doe</strong> can see this in their dashboard.</div>",
  public: false
)
puts "Created private note for John: '#{note1.title}'"

note2 = user1.notes.create!(
  title: "Ruby on Rails 8 Features",
  content: "<div>Rails 8 introduces a lot of cool features like <em>Solid Cache</em>, <em>Solid Queue</em>, and out-of-the-box support for modern PWAs. It's super fast!</div>",
  public: true
)
puts "Created public note for John: '#{note2.title}'"

# Notes for Jane Smith
note3 = user2.notes.create!(
  title: "Jane's Secret Ideas",
  content: "<div>A list of secret ideas:<ul><li>Build a note-taking application.</li><li>Upgrade it to Rails 8.</li><li>Use Tailwind CSS v4.</li></ul></div>",
  public: false
)
puts "Created private note for Jane: '#{note3.title}'"

note4 = user2.notes.create!(
  title: "Tailwind CSS v4 is Amazing",
  content: "<div>Tailwind CSS v4 has a brand new Rust-based compiler which is up to 10x faster! It also moves configuration into the CSS file itself using <code>@theme</code> directives.</div>",
  public: true
)
puts "Created public note for Jane: '#{note4.title}'"

puts "\n== Seeding Completed successfully! =="
