#+--------------------------------------------------------------------+
#| prologue.coffee
#+--------------------------------------------------------------------+
#| Copyright fivetwofivetwo, LLC (c) 2014
#+--------------------------------------------------------------------+
#|
#| This file is a part of iwishua
#|
#| This file is subject to the terms and conditions defined in
#| file 'license.md', which is part of this source code package.
#|
#| Yu Mo Gui Gwai Fai Di Zao
#|
#+--------------------------------------------------------------------+
#
# meta programming
#
# ----------------------------
# get the class of a CoffeeScript object
# ----------------------------

Object.getClass = (object) ->
  Object.getPrototypeOf(object).constructor