#+--------------------------------------------------------------------+
#| controllers.coffee
#+--------------------------------------------------------------------+
#| Copyright FiftyTwoFiftyTwo, LLC (c) 2014
#+--------------------------------------------------------------------+
#|
#| This file is a part of iwishua
#|
#| This file is subject to the terms and conditions defined in
#| file 'license.md', which is part of this source code package.
#|
#+--------------------------------------------------------------------+
'use strict'
#
# iwishua controllers
#
angular.module('iwishua.controllers', [])

.controller('FBController',       ['$scope', 'logger', '$facebook',
                                   require('./controllers/FBController')])

.controller('AboutController',    ['$scope', 'logger',
                                   require('./controllers/AboutController')])

.controller('PrivacyController',  ['$scope', 'logger',
                                   require('./controllers/PrivacyController')])

.controller('ListController',     ['$scope', 'logger',
                                   require('./controllers/ListController')])

.controller('WishController',     ['$scope', 'logger', 'entityManager', '$routeParams', '$location',
                                   require('./controllers/WishController')])
