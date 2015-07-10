`import Ember from 'ember'`
`import calendar from 'ember-cli-coreweb/utils/calendar'`

Calendar = Ember.Object.extend
  stemNames: ["甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸"]
  branchNames: ["子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥"]
  animalNames: ["鼠", "牛", "虎", "兔", "龙", "蛇", "马", "羊", "猴", "鸡", "狗", "猪"]

  chineseMonthNames: ["正", "二", "三", "四", "五", "六", "七", "八", "九", "十", "冬", "腊"]
  chineseDateNames: ['初一', '初二', '初三', '初四', '初五', '初六', '初七', '初八', '初九', '初十', '十一', '十二', '十三', '十四', '十五', '十六', '十七', '十八', '十九', '二十', '廿一', '廿二', '廿三', '廿四', '廿五', '廿六', '廿七', '廿八', '廿九', '三十', '卅一']
  principleTermNames: ["大寒", "雨水", "春分", "谷雨", "夏满", "夏至", "大暑", "处暑", "秋分", "霜降", "小雪", "冬至"]
  sectionalTermNames: ["小寒", "立春", "惊蛰", "清明", "立夏", "芒种", "小暑", "立秋", "白露", "寒露", "立冬", "大雪"]

  gregorianYear: 0
  gregorianMonth: 0
  gregorianDate: 0
  isGregorianLeap: false
  dayOfYear: 0 # 周日一星期的第一天
  dayOfWeek: 0
  chineseYear: 0
  chineseMonth: 0 # 负数表示闰月
  chineseDate: 0
  sectionalTerm: 0
  principleTerm: 0

  cnDate: Ember.computed 'chineseMonth', 'chineseDate', 'sectionalTerm', 'principleTerm', ->
    chineseMonth = Math.abs(@chineseMonth)

    if @gregorianDate is @sectionalTerm
      @sectionalTermNames[@gregorianMonth - 1]
    else if @gregorianDate is @principleTerm
      @principleTermNames[@gregorianMonth - 1]
    else
      "#{if @chineseMonth < 0 then "闰" else ""}#{@chineseMonthNames[chineseMonth - 1]}月#{@chineseDateNames[@chineseDate - 1]}"

  # 天干地支
  stemBranch: Ember.computed 'chineseYear', ->
    "#{@stemNames[(@chineseYear - 1) % 10]}#{@branchNames[(@chineseYear - 1) % 12]}"

  # 生肖
  animal: Ember.computed 'chineseYear', ->
    @animalNames[(@chineseYear - 1) % 12]

  # [year, month, date]
  dateArray: Ember.computed 'gregorianYear', 'gregorianMonth', 'gregorianDate', ->
    [@gregorianYear, @gregorianMonth, @gregorianDate]

Calendar.reopenClass
  generate: (year, month, date) ->
    @.create calendar year, month, date

`export default Calendar`
