###
# scripts/directives/dropdown.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
###
'use strict'

angular.module 'hMediaApp'
.constant 'dropdownConfig', openClass: 'open'

.service 'dropdownService', ($document) ->
  self = @
  openScope = null

  @open = (dropdownScope) ->
    unless openScope
      $document.bind 'click', closeDropdown
      $document.bind 'keydown', escapeKeyBind

    if openScope and openScope isnt dropdownScope
        openScope.isOpen = false

    openScope = dropdownScope
    return

  @close = (dropdownScope) ->
    if openScope is dropdownScope
      openScope = null
      $document.unbind 'click', closeDropdown
      $document.unbind 'keydown', escapeKeyBind
    return

  closeDropdown = ->
    openScope.$apply ->
      openScope.isOpen = false
    return

  escapeKeyBind = (evt) ->
    if evt.which is 27
      openScope.focusToggleElement()
      closeDropdown()
    return

  return

.controller 'dropdownController', ($scope, $attrs, $parse, dropdownConfig, dropdownService, $animate) ->
  self = @
  scope = $scope.$new()
  openClass = dropdownConfig.openClass
  getIsOpen = undefined
  setIsOpen = angular.noop
  toggleInvoker = if $attrs.onToggle then $parse($attrs.onToggle) else angular.noop

  @init = (element) ->
    self.$element = element

    if $attrs.isOpen
      getIsOpen = $parse $attrs.isOpen
      setIsOpen = getIsOpen.assign

      $scope.$watch getIsOpen, (value) ->
        scope.isOpen = !!value
        return

    return

  @toggle = (open) ->
    scope.isOpen = if arguments.length then !!open else !scope.isOpen

  @isOpen = ->
    scope.isOpen

  scope.focusToggleElement = ->
    self.toggleElement[0].focus() if self.toggleElement
    return

  scope.$watch 'isOpen', (isOpen) ->
    $animate[if isOpen then 'addClass' else 'removeClass'] self.$element, openClass

    if isOpen
      scope.focusToggleElement()
      dropdownService.open scope
    else
      dropdownService.close scope

    setIsOpen $scope, isOpen
    toggleInvoker $scope, open: !!isOpen
    return

  $scope.$on '$locationChangeSuccess', ->
    scope.isOpen = false
    return

  $scope.$on '$destroy', ->
    scope.$destroy()
    return

  return

.directive 'dropdown', ->
  restrict: 'CA'
  controller: 'dropdownController'
  link: (scope, element, attrs, dropdownCtrl) ->
    dropdownCtrl.init element
    return

.directive 'dropdownToggle', ->
  restrict: 'CA'
  require: '?^dropdown'
  link: (scope, element, attrs, dropdownCtrl) ->
    return unless dropdownCtrl

    dropdownCtrl.toggleElement = element

    toggleDropdown = (event) ->
      event.preventDefault()
      event.stopPropagation()

      if not element.hasClass('disabled') and not attrs.disabled
        scope.$apply ->
          dropdownCtrl.toggle()
          return

      return

    element.bind 'click', toggleDropdown

    # WAI-ARIA
    element.attr 'aria-haspopup': true, 'aria-expanded': false
    scope.$watch dropdownCtrl.isOpen, (isOpen) ->
      element.attr 'aria-expanded', !!isOpen
      return

    scope.$on '$destroy', ->
      element.unbind 'click', toggleDropdown
      return

    return
