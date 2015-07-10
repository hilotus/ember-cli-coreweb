`import Ember from 'ember'`
`import calGenerate from 'ember-cli-coreweb/utils/cal-generate'`

CWCalendarComponent = Ember.Component.extend
  classNames: ['cw-cal']

  __cache: {}
  weekOptions: ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN']
  monthOptions: ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC']
  monthNames: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']

  content: Ember.computed
    get: ->
      debugger
      today = new Date()
      [today.getFullYear(), today.getMonth() + 1, today.getDate()]

    set: (key, newValue) ->
      newValue = new Date() unless newValue
      if newValue instanceof Date
        newValue = [newValue.getFullYear(), newValue.getMonth() + 1, newValue.getDate()]
      newValue

  monthName: Ember.computed 'month', ->
    @monthNames[@month - 1]

  init: ->
    @_super()

    today = new Date()
    @set 'currentYear', today.getFullYear()
    @set 'currentMonth', today.getMonth() + 1
    @set 'currentDate', today.getDate()

    content = @get('content')
    @set 'year', content[0]
    @set 'month', content[1]
    @set 'date', content[2]

  weekDates: Ember.computed 'year', 'month', ->
    dates = @get("__cache.#{@year}-#{@month}")
    return dates if dates

    dates = calGenerate @year, @month
    @set "__cache.#{@year}-#{@month}", dates
    dates

  selectedDay: Ember.computed 'year', 'month', 'date', ->
    [@year, @month, @date]

  today: Ember.computed 'currentYear', 'currentMonth', 'currentDate', ->
    [@currentYear, @currentMonth, @currentDate]

  # Chinese Date
  cnCalendar: Ember.computed 'year', 'month', 'date', ->
    CW.Calendar.generate @year, @month, @date

  actions:
    selectMonth: (month) ->
      @set 'month', month + 1

    selectDate: (date) ->
      @set 'year', date.get('gregorianYear')
      @set 'month', date.get('gregorianMonth')
      @set 'date', date.get('gregorianDate')
      @set 'content', [@year, @month, @date]


`export default CWCalendarComponent`
