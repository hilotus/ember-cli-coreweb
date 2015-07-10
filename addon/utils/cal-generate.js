var __daysInGregorianMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

var isGregorianLeapYear = function(year) {
  var isLeap;
  isLeap = false;
  if (year % 4 === 0) {
    isLeap = true;
  }
  if (year % 100 === 0) {
    isLeap = false;
  }
  if (year % 400 === 0) {
    isLeap = true;
  }
  return isLeap;
};

var dayOfYear = function(year, month, day) {
  var count, i, j, ref;
  count = 0;
  for (i = j = 1, ref = month; 1 <= ref ? j < ref : j > ref; i = 1 <= ref ? ++j : --j) {
    count = count + daysInGregorianMonth(year, i);
  }
  return count + day;
};

var daysInGregorianMonth = function(year, month) {
  var days;
  days = __daysInGregorianMonth[month - 1];
  if (month === 2 && isGregorianLeapYear(year)) {
    days = days + 1;
  }
  return days;
};

var dayOfWeek = function(year, month, day) {
  var commonYear, leapYear, weak;
  weak = 1;
  year = (year - 1) % 400 + 1;
  leapYear = parseInt((year - 1) / 4);
  leapYear = parseInt(leapYear - (year - 1) / 100);
  leapYear = parseInt(leapYear + (year - 1) / 400);
  commonYear = year - 1 - leapYear;
  weak = weak + commonYear;
  weak = weak + 2 * leapYear;
  weak = weak + dayOfYear(year, month, day);
  return (weak - 1) % 7 + 1;
};

var generateWeekTemplate = function() {
  return [null, null, null, null, null, null, null];
};

// Generate dates of month for calendar
export default function(year, month) {
  var rows = [], day, weeks = generateWeekTemplate();
  var days = daysInGregorianMonth(year, month);

  var pastYear, pastMonth;
  if (month === 1) {
    pastYear = year - 1;
    pastMonth = 12;
  } else {
    pastYear = year;
    pastMonth = month - 1;
  }
  var pastMonthDays = daysInGregorianMonth(pastYear, pastMonth);

  var nextYear, nextMonth;
  if (month === 12) {
    nextYear = year + 1;
    nextMonth = 1;
  } else {
    nextYear = year;
    nextMonth = month + 1;
  }

  for (var i = 1; i <= days; i++) {
    day = dayOfWeek(year, month, i);

    if (i === 1) {
      pastMonthDays = pastMonthDays - day + 2;
      for (var j = 1; j < day; j++, pastMonthDays++) {
        weeks[j - 1] = CW.Calendar.generate(pastYear, pastMonth, pastMonthDays);
      }
    }

    weeks[day - 1] = CW.Calendar.generate(year, month, i);
    if (day === 7 || i === days) {
      if (i === days) {
        for (var z = day, d = 1; z < 7; z++, d++) {
          weeks[z] = CW.Calendar.generate(nextYear, nextMonth, d);
        }
      }

      rows.push(weeks);
      weeks = generateWeekTemplate();
    }
  }

  return rows;
}
