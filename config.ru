# frozen_string_literal: true
require_relative 'middleware/runtime'
require_relative 'middleware/logger'
require_relative 'lib/simpler'
require_relative 'config/environment'

Simpler.application.bootstrap!

use AppLogger, logdev: File.expand_path('log/app.log', __dir__)

run Simpler.application
