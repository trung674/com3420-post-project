# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Data for editable content
EditableContent.where(name: 'about').first_or_create(content:
"<h2>Test About Page</h2>
<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
<ul>
<li>Some</li>
<li>Interesting</li>
<li>Facts</li>
<li>About</li>
<li>Us</li>
</ul>
<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>"
)

EditableContent.where(name: 'contact_address').first_or_create(content:"23 Edward Street, Sheffield, UK, S3 7SF")
EditableContent.where(name: 'contact_phone').first_or_create(content:"(+44) 111111111111")
EditableContent.where(name: 'working_hour').first_or_create(content:"Monday - Friday: 9:00 AM to 5:00 PM")
EditableContent.where(name: 'homepage_description').first_or_create(content:"
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
Sample data ! Change me please"
)
# Data for mod
Mod.where(email:
 'asacook1@sheffield.ac.uk').first_or_create(password:
 'password123', password_confirmation: 'password123', isActive: true, isAdmin: true)
