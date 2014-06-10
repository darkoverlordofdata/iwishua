#+--------------------------------------------------------------------+
#| filters.coffee
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
# iwishua filters
#
angular.module('iwishua.filters', [])
.filter 'capitalise', (str) -> str.charAt(0).toUpperCase() + str[1..]