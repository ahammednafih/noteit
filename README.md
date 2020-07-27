# Note It

A simple note taking app using Rails and twitter bootstrap

## Setup

Ruby version : `1.8.7p-374`

Gem version :

rubygems-update (1.4.2)

rails (2.3.5)

actionmailer (2.3.5)

actionpack (2.3.5)

activerecord (2.3.5)

activeresource (2.3.5)

activesupport (2.3.5)

bcrypt (3.1.11)

bundler-unload (1.0.2)

daemons (1.0.10)

executable-hooks (1.6.0)

gem-wrappers (1.4.0)

mysql (2.9.1)

popper_js (1.16.0)

rack (1.0.1)

rake (0.8.7) 

delayed_job 2.0.4 as plugin: `script/plugin install git://github.com/collectiveidea/delayed_job.git -r v2.0`
 
 Now from project directory

`rake db:create`

`rake db:migrate`

## Assignment tasks

Use twitter bootstrap for the UI and make the layout responsive while accessing with mobile phones.
New users can Sign Up for the app (registration)
Validate username (existing or available)
Send confirmation email (use delayed_job  '2.0.4' for queuing)
Existing users can login
Forgot password
Create Notes (Use an editor like http://imperavi.com/redactor/)
Edit notes
Delete notes
Advanced - Create public notes with url which can be read by anyone with the url
