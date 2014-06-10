#+--------------------------------------------------------------------+
#| Products.coffee
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
# Entity manager
#
class Products
  #
  # constructor
  #
  # @param  breeze  breezejs root object
  # @param  logger  logger utility object
  #
  constructor: (@breeze, @logger)->

    serviceName     = "https://iwishuadata.azure-mobile.net/"
    modelNamespace  = "Iwishua.Models"
    @modelName      = "iwishuaproducts"

    metadataStore = new @breeze.MetadataStore(namingConvention: @breeze.NamingConvention.camelCase)
    metadataHelper = new @breeze.config.MetadataHelper(modelNamespace)

    #
    # Define the iwishuaproducts table
    #
    metadataHelper.addTypeToStore metadataStore,
      namespace:            modelNamespace
      shortName:            @modelName
      defaultResourceName:  @modelName
      dataProperties:       # iwishuaproducts
        id:                 { maxLength: 36 }
        productId:          { maxLength: 36 }
        productTitle:       { maxLength: 4000 }
        productDescription: { maxLength: 4000 }
        productImageUrl:    { maxLength: 4000 }
        productBuyUrl:      { maxLength: 4000 }
        productKeywords:    { maxLength: 4000 }
        impressionUrl:      { maxLength: 4000 }
        isPublished:        { dataType: @breeze.DataType.Boolean }

    metadataHelper.addDataService(metadataStore, serviceName)

    @entityManager = new @breeze.EntityManager(metadataStore: metadataStore, serviceName: serviceName)

  #
  # getProducts
  #
  # @param  skip  count of records to skip over
  # @param  take  the number of records to grab
  #
  getProducts: (skip = 0, take = 5) ->
    query = @breeze.EntityQuery
    .from("tables/#{@modelName}")
    .skip(parseInt(skip, 10))
    .take(parseInt(take, 10))
    .where('isPublished', 'eq', true)
    .inlineCount(true)

    @entityManager.executeQuery(query)
    .catch (error)=>
      @logger.error(error.message, "Query failed")
      throw error # so downstream promise users know it failed


  #
  # parseProducts
  #
  # parse out the data and assign to $scope variables
  #
  # @param  $scope
  # @param  data
  #
  parseProducts: ($scope, data) ->
    $scope.count = data.results[0].count
    $scope.products = data.results[0].results

    for attrs in $scope.products

      title = attrs.productTitle
      # strip off wrapping quotes
      if title[0...1] is '"' then title = title[1...-1]
      words = title.replace(/[-,.©®™]/g, ' ').replace(/([a-z])([A-Z])/g, "$1 $2").split(/\s+/)
      title = words.join(' ')
      attrs.productTitle = title
      name = ''
      until name.length > 20 or words.length is 0
        name = words.pop() + ' ' + name.substr(0, 1).toUpperCase() + name.substr(1)
      attrs.productName = name


      attrs.className = 'ww2'
      for word in name.split(/\s+/)
        if word.length > 7 then attrs.className = 'hh2'

      if attrs.className is 'ww2'
        if (Math.floor(Math.random() * new Date().getTime())) & 1
          attrs.aligned = 'alignleft'
        else
          attrs.aligned = 'alignright'

module.exports = Products
