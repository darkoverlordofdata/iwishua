#+--------------------------------------------------------------------+
#| services.coffee
#+--------------------------------------------------------------------+
#| Copyright fivetwofivetwo, LLC (c) 2014
#+--------------------------------------------------------------------+
#|
#| This file is a part of iwishua
#|
#| This file is subject to the terms and conditions defined in
#| file 'license.md', which is part of this source code package.
#|
#+--------------------------------------------------------------------+
#
# iwishua services
#
define './services', (require, exports, module) ->

  angular.module('iwishua.services', [])
  #
  # Version: the application version
  #
  .value('version', '0.1.0')
  #
  # Logger: display color-coded messages in "toasts" and to console
  # relies on Angular injector to provide:
  #     $log - Angular's console logging facility
  #
  .service('logger', ['$log', require('./services/Logger')])
  #
  # Products Entity Manager:
  #     breeze -
  #     logger -
  #
  .service('entityManager', ['breeze', 'logger', require('./services/Products')])
