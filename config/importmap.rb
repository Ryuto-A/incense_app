# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

pin "bootstrap" # @5.3.3
pin "@popperjs/core", to: "@popperjs--core.js" # @2.11.8

# mportmap を使っている現在、Rails 7 の推奨は @rails/ujs ではなく Turbo + data-method を Turbo がサポートする形 です。しかし、Turbo だけでは method: :delete はサポートされないため、JavaScriptの対応が必要
pin "@rails/ujs", to: "rails-ujs.js"
