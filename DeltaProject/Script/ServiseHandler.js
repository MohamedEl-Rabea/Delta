function GetDate() {
    var CurrentDate = new Date();

    var DayNumber = CurrentDate.getDate();
    var MonthNumber = CurrentDate.getMonth();
    var YearNumber = CurrentDate.getFullYear();

    document.getElementById('txtDay').value = DayNumber;
    document.getElementById('txtMonth').value = MonthNumber + 1;
    document.getElementById('txtYear').value = YearNumber;

    return false; // to prevent postback
}

function GetDate2(day, month, year) {
    var CurrentDate = new Date();

    var DayNumber = CurrentDate.getDate();
    var MonthNumber = CurrentDate.getMonth();
    var YearNumber = CurrentDate.getFullYear();

    document.getElementById(day).value = DayNumber;
    document.getElementById(month).value = MonthNumber + 1;
    document.getElementById(year).value = YearNumber;

    return false; // to prevent postback
}
