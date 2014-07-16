#+--------------------------------------------------------------------+
#| shuffle.coffee
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
# Shuffle
#
# Fisher-Yates shuffle algorithm
#
angular.module('iwishua')
.factory 'shuffle', ->
  (a) ->
    i = a.length
    while --i > 0
      j = ~~(Math.random() * (i + 1))
      t = a[j]
      a[j] = a[i]
      a[i] = t
    a

