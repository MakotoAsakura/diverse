# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "popper", to: "popper.js", preload: true
pin "jquery", to: "jquery.min.js", preload: true
pin "jquery_ujs", to: "jquery_ujs.js", preload: true
pin "vanillajs-datepicker", to: "vanillajs-datepicker/dist/js/datepicker-full.js", preload: true
pin "vanillajs-datepicker-i18n-ja", to: "vanillajs-datepicker/js/i18n/locales/ja.js", preload: true
pin "jquery-timepicker", to: "jquery-timepicker/jquery.timepicker.js", preload: true
pin_all_from "app/javascript/employees", under: "employees"
pin "js-cookie", to: "js-cookie/dist/js.cookie.js", preload: true
pin_all_from "app/javascript/medicals", under: "medicals"
# pin "lightbox"
pin "trix"
pin "@rails/actiontext", to: "actiontext.js"
pin "admin", preload: true
pin "@nathanvda/cocoon", to: "https://ga.jspm.io/npm:@nathanvda/cocoon@1.2.14/cocoon.js"
