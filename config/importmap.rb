# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

pin "bootstrap" # @5.3.3
pin "@popperjs/core", to: "@popperjs--core.js" # @2.11.8

# importmapを使っている現在Rails7の推奨は@rails/ujsではなくTurbo + data-method を Turbo がサポートする形
# しかしTurbo だけでは method: :delete はサポートされないため、JavaScriptの対応が必要
pin "@rails/ujs", to: "rails-ujs.js"
