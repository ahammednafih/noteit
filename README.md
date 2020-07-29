# Note It

A simple note taking app using Rails and twitter bootstrap. Db used is mariaDB 10.1

## Setup

Ruby version : `1.8.7p-374`

Gem version :

rubygems-update (1.4.2)

rails (2.3.5)

bcrypt (3.1.11)

bundler-unload (1.0.2)

carrierwave (0.4.10)

daemons (1.0.10)

executable-hooks (1.6.0)

gem-wrappers (1.4.0)

mysql (2.9.1)

popper_js (1.16.0)

rack (1.0.1)

rails (2.3.5)

rake (0.8.7)

rmagick (2.13.3)

rvm (1.11.3.9)

will_paginate (2.3.16) 

delayed_job 2.0.4 as plugin: `script/plugin install git://github.com/collectiveidea/delayed_job.git -r v2.0`
 
`script/generate delayed_job`

`rake db:create`

`rake db:migrate`

Start delayed_job: `script/delayed_job start`
