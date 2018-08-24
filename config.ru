#! usr/bin/env ruby
require 'rack'
load 'filters/authentication.rb'
load 'app.rb'

use Authentication
run App.new
