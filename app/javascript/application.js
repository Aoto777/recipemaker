// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// ← rails-ujs は importmap では require できないので基本は使わない（後述）
import * as ActiveStorage from "@rails/activestorage"
ActiveStorage.start()

import "./preview"
