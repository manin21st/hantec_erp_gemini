$PBExportHeader$w_date_select.srw
$PBExportComments$일자선택(달력)
forward
global type w_date_select from window
end type
type cb_1 from commandbutton within w_date_select
end type
type pb_next from picturebutton within w_date_select
end type
type pb_prev from picturebutton within w_date_select
end type
type dw_cal from datawindow within w_date_select
end type
end forward

global type w_date_select from window
integer x = 5
integer y = 4
integer width = 1262
integer height = 1256
boolean titlebar = true
string title = "Calendar"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 134217729
string icon = "C:\erpman\icon\erpman.ico"
boolean center = true
cb_1 cb_1
pb_next pb_next
pb_prev pb_prev
dw_cal dw_cal
end type
global w_date_select w_date_select

type variables
editmask em_date
Int ii_Day, ii_Month, ii_Year
String is_old_column, is_date
String ls_DateFormat
Date id_date_selected
end variables

forward prototypes
public subroutine draw_month (integer year, integer month)
public subroutine enter_day_numbers (integer ai_start_day_num, integer ai_days_in_month)
public function int get_month_number (string as_month)
public function string get_month_string (integer as_month)
public subroutine init_cal (date ad_start_date)
public subroutine set_date_format (string as_date_format)
public function integer unhighlight_column (string as_column)
public function integer highlight_column (string as_column)
public function integer days_in_month (integer month, integer year)
end prototypes

public subroutine draw_month (integer year, integer month);Int  li_FirstDayNum, li_cell, li_daysinmonth
Date ld_firstday
String ls_month, ls_cell, ls_return

//Set Pointer to an Hourglass and turn off redrawing of Calendar
SetPointer(Hourglass!)
SetRedraw(dw_cal,FALSE)

//Set Instance variables to arguments
ii_month = month
ii_year = year

//check in the instance day is valid for month/year 
//back the day down one if invalid for month ie 31 will become 30
Do While Date(ii_year,ii_month,ii_day) = Date(00,1,1)
	ii_day --
Loop

//Work out how many days in the month
li_daysinmonth = days_in_month(ii_month,ii_year)

//Find the date of the first day in the month
ld_firstday = Date(ii_year,ii_month,1)

//Find what day of the week this is
li_FirstDayNum = DayNumber(ld_firstday)

//Set the first cell
li_cell = li_FirstDayNum + ii_day - 1

//If there was an old column turn off the highlight
unhighlight_column (is_old_column)

//Set the Title
ls_month = get_month_string(ii_month) + " " + string(ii_year)
dw_cal.Object.st_month.text = ls_month

//Enter the day numbers into the datawindow
enter_day_numbers(li_FirstDayNum,li_daysinmonth)

//Define the current cell name
ls_cell = 'cell'+string(li_cell)

//Highlight the current date
highlight_column (ls_cell)

//Set the old column for next time
is_old_column = ls_cell

//Reset the pointer and Redraw
SetPointer(Arrow!)
dw_cal.SetRedraw(TRUE)

end subroutine

public subroutine enter_day_numbers (integer ai_start_day_num, integer ai_days_in_month);Int li_count, li_daycount

//Blank the columns before the first day of the month
For li_count = 1 to ai_start_day_num
	dw_cal.SetItem(1,li_count,"")
Next

//Set the columns for the days to the String of their Day number
For li_count = 1 to ai_days_in_month
	//Use li_daycount to find which column needs to be set
	li_daycount = ai_start_day_num + li_count - 1
	dw_cal.SetItem(1,li_daycount,String(li_count))
Next

//Move to next column
li_daycount = li_daycount + 1

//Blank remainder of columns
For li_count = li_daycount to 42
	dw_cal.SetItem(1,li_count,"")
Next

//If there was an old column turn off the highlight
unhighlight_column (is_old_column)

is_old_column = ''


end subroutine

public function int get_month_number (string as_month);Int li_month_number

CHOOSE CASE as_month
	CASE "Jan"
		li_month_number = 1
	CASE "Feb"
		li_month_number = 2
	CASE "Mar"
		li_month_number = 3
	CASE "Apr"
		li_month_number = 4
	CASE "May"
		li_month_number = 5
	CASE "Jun"
		li_month_number = 6
	CASE "Jul"
		li_month_number = 7
	CASE "Aug"
		li_month_number = 8
	CASE "Sep"
		li_month_number = 9
	CASE "Oct"
		li_month_number = 10
	CASE "Nov"
		li_month_number = 11
	CASE "Dec"
		li_month_number = 12
END CHOOSE

return li_month_number
end function

public function string get_month_string (integer as_month);String ls_month

If gsbom = 'KOR' then
	CHOOSE CASE as_month
		CASE 1
			ls_month = "1월"
		CASE 2
			ls_month = "2월"
		CASE 3
			ls_month = "3월"
		CASE 4
			ls_month = "4월"
		CASE 5
			ls_month = "5월"
		CASE 6
			ls_month = "6월"
		CASE 7
			ls_month = "7월"
		CASE 8
			ls_month = "8월"
		CASE 9
			ls_month = "9월"
		CASE 10
			ls_month = "10월"
		CASE 11
			ls_month = "11월"
		CASE 12
			ls_month = "12월"
	End Choose

Else
	CHOOSE CASE as_month
		CASE 1
			ls_month = "Jan"
		CASE 2
			ls_month = "Feb"
		CASE 3
			ls_month = "Mar"
		CASE 4
			ls_month = "Apr"
		CASE 5
			ls_month = "May"
		CASE 6
			ls_month = "June"
		CASE 7
			ls_month = "July"
		CASE 8
			ls_month = "Aug"
		CASE 9
			ls_month = "Sep"
		CASE 10
			ls_month = "Oct"
		CASE 11
			ls_month = "Nov"
		CASE 12
			ls_month = "Dec"
	
	END CHOOSE
End If

return ls_month
end function

public subroutine init_cal (date ad_start_date);Int li_FirstDayNum, li_Cell, li_DaysInMonth
String ls_Year, ls_Month, ls_Return, ls_Cell
Date ld_FirstDay

//Insert a row into the script datawindow
dw_cal.InsertRow(0)

//Set the variables for Day, Month and Year from the date passed to
//the function
ii_Month = Month(ad_start_date)
ii_Year = Year(ad_start_date)
ii_Day = Day(ad_start_date)

//Find how many days in the relevant month
li_daysinmonth = days_in_month(ii_month, ii_year)

//Find the date of the first day of this month
ld_FirstDay = Date(ii_Year, ii_month, 1)

//What day of the week is the first day of the month
li_FirstDayNum = DayNumber(ld_FirstDay)

//Set the starting "cell" in the datawindow. i.e the column in which
//the first day of the month will be displayed
li_Cell = li_FirstDayNum + ii_Day - 1

//Set the Title of the calendar with the Month and Year
ls_Month = get_month_string(ii_Month) + " " + string(ii_Year)
dw_cal.Object.st_month.text = ls_month

//Enter the numbers of the days
enter_day_numbers(li_FirstDayNum, li_DaysInMonth)

dw_cal.SetItem(1,li_cell,String(Day(ad_start_date)))

//Define the first Cell as a string
ls_cell = 'cell'+string(li_cell)

//Display the first day in bold (or 3D)
highlight_column (ls_cell)

//Set the instance variable i_old_column to hold the current cell, so
//when we change it, we know the old setting
is_old_column = ls_Cell

end subroutine

public subroutine set_date_format (string as_date_format);ls_DateFormat = as_date_format

If Not isnull(id_date_selected) then 
	em_date.Text = string(id_date_selected,ls_dateformat)
End If
end subroutine

public function integer unhighlight_column (string as_column);//If the highlight is on the column set the border of the column back to normal

string ls_return

If as_column <> '' then
	ls_return = dw_cal.Modify(as_column + ".border=0")
	If ls_return <> "" then 
		MessageBox("Modify",ls_return)
		Return -1
	End if
End If

Return 1
end function

public function integer highlight_column (string as_column);//Highlight the current column/date

string ls_return

ls_return = dw_cal.Modify(as_column + ".border=5")
If ls_return <> "" then 
	MessageBox("Modify",ls_return)
	Return -1
End if

Return 1
end function

public function integer days_in_month (integer month, integer year);//Most cases are straight forward in that there are a fixed number of 
//days in 11 of the 12 months.  February is, of course, the problem.
//In a leap year February has 29 days, otherwise 28.

Int nDaysInMonth
Boolean bLeapYear

CHOOSE CASE month
	CASE 1, 3, 5, 7, 8, 10, 12
		nDaysInMonth = 31
	CASE 4, 6, 9, 11
		nDaysInMonth = 30
	CASE 2
	//If a year is divisible by 100 without a remainder, then it is
	//NOT a leap year

	//	If Mod(year,100) = 0 then
	//		bLeapYear = False

	//If the year is not divisible by 100, but is by 4 then it is a
	//leap year

		If Mod(year,4) = 0 or Mod(year,100) = 0 then 
			bLeapYear = True

	//If neither case is true then it is not a leap year

		Else 
			bLeapYear = False
		End If

	//If it is a leap year, February has 29 days, otherwise 28

		If bLeapYear then
			nDaysInMonth = 29
		Else
			nDaysInMonth = 28
		End If

END CHOOSE

//Return the number of days in the relevant month
return nDaysInMonth
end function

on w_date_select.create
this.cb_1=create cb_1
this.pb_next=create pb_next
this.pb_prev=create pb_prev
this.dw_cal=create dw_cal
this.Control[]={this.cb_1,&
this.pb_next,&
this.pb_prev,&
this.dw_cal}
end on

on w_date_select.destroy
destroy(this.cb_1)
destroy(this.pb_next)
destroy(this.pb_prev)
destroy(this.dw_cal)
end on

event open;/*=================================================================================*/
/* Window ID : w_date_select                                                       */
/* 기     능 : 일자 선택용 윈도우                                                  */
/*---------------------------------------------------------------------------------*/
/* 처리 내역 : 일자입력시 선택된 일자를 넘겨준다.                                  */
/*=================================================================================*/
/* 변경이력                                                                        */
/*---------------------------------------------------------------------------------*/
/*  VERSION   작성자   소속          일자         내용                 요청자      */
/*---------------------------------------------------------------------------------*/
/*  1.0       김봉주   업무조정팀    1999.11.29   최초작성                         */
/*=================================================================================*/
/* 사용변수                                                                        */
/*---------------------------------------------------------------------------------*/
/* Instance 변수: editmask em_date                                                 */
/*                Int      ii_Day, ii_Month, ii_Year                               */
/*                String   is_old_column                                           */
/*                String   ls_DateFormat                                           */
/*                Date     id_date_selected                                        */
/*=================================================================================*/
/* 공통모듈                                                                        */
/*---------------------------------------------------------------------------------*/
/* 없음                                                                            */
/*=================================================================================*/
/* 호출하는 서비스                                                                 */
/*---------------------------------------------------------------------------------*/
/* 없음                                                                            */
/*=================================================================================*/
This.x = Pointerx()
This.y = Pointery()
em_date = message.powerObjectParm
em_date.GetData(id_date_selected)

//MessAgeBox("일자확인",String(id_date_selected, "yyyy.mm.dd"))

IF String(id_date_selected, "yyyy.mm.dd") = "1900.01.01" THEN
//	SELECT SYSDATE
//     INTO :id_date_selected 
//     FROM DUAL;
	id_date_selected = today() 
END IF

ii_day = integer(String(id_date_selected, "dd"))
ii_month = integer(String(id_date_selected, "mm"))
ii_year = integer(String(id_date_selected, "yyyy"))

reset(dw_cal)

IF ii_day = 0 THEN ii_day = 1
init_cal(date(ii_year, ii_month, ii_day))
dw_cal.setfocus()

end event

type cb_1 from commandbutton within w_date_select
boolean visible = false
integer x = 1312
integer y = 196
integer width = 265
integer height = 112
integer taborder = 13
integer textsize = -12
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "Input"
end type

event clicked;If IsNull( is_date ) or is_date = '' then
	return
End If

ii_day = Integer(is_date)

id_date_selected = date(ii_year, ii_month, ii_Day)
em_date.Text = String( id_date_selected, ls_dateFormat )

//선택된 일자를 돌려줌.
CloseWithReturn(Parent, "1")

end event

type pb_next from picturebutton within w_date_select
integer x = 1047
integer y = 32
integer width = 123
integer height = 112
integer taborder = 3
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\erpman\image\13_NEXT.BMP"
alignment htextalign = left!
end type

event clicked;//Increment the month number, but if its 13, set back to 1 (January)
ii_month = ii_month + 1
If ii_month = 13 then
	ii_month = 1
	ii_year = ii_year + 1
End If

//check if selected day is no longer valid for new month
If not(isdate(string(ii_month) + "/" + string(ii_day) + "/"+ string(ii_year))) Then ii_day = 1
	
//Draw the month
draw_month ( ii_year, ii_month )

//Return the chosen date into the SingleLineEdit in the chosen format
id_date_selected = date(ii_year,ii_month,ii_Day)
em_date.Text = String( id_date_selected, ls_dateFormat )

end event

type pb_prev from picturebutton within w_date_select
integer x = 73
integer y = 32
integer width = 123
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\erpman\image\13_PRIOR.BMP"
alignment htextalign = left!
end type

event clicked;//Decrement the month, if 0, set to 12 (December)
ii_month = ii_month - 1
If ii_month = 0 then
	ii_month = 12
	ii_year = ii_year - 1
End If

//check if selected day is no longer valid for new month
If not(isdate(string(ii_month) + "/" + string(ii_day) + "/"+ string(ii_year))) Then ii_day = 1

//Darw the month
draw_month ( ii_year, ii_month )




//Return the chosen date into the SingleLineEdit in the chosen format
id_date_selected = date(ii_year,ii_month,ii_Day)
em_date.Text = String( id_date_selected, ls_dateFormat )

end event

type dw_cal from datawindow within w_date_select
event ue_dwnkey pbm_dwnkey
integer x = 23
integer y = 24
integer width = 1198
integer height = 1116
integer taborder = 10
string dataobject = "d_dateselect_01"
boolean border = false
boolean livescroll = true
end type

event ue_dwnkey;Choose case key
	case keyenter!
		cb_1.TriggerEvent( Clicked! )
End Choose

If keydown(keyRightArrow!) and keydown(keyControl!) then
	pb_next.triggerevent(clicked!)
Elseif keydown(keyLeftArrow!) and keydown(keyControl!) then
	pb_prev.triggerevent(clicked!)
End If
end event

event clicked;String ls_clickedcolumn, ls_clickedcolumnID
String ls_day, ls_return
string ls_col_name

If IsNull(dwo) Then Return
If left(dwo.name, 4) <> "cell" Then Return

ls_clickedcolumn = dwo.name
ls_clickedcolumnID = dwo.id
If ls_clickedcolumn = '' Then Return


ls_day = dwo.primary[1]
is_date = ls_day
If ls_day = "" then Return

ii_day = Integer(ls_day)

unhighlight_column (is_old_column)

dwo.border = 5

is_old_column = ls_clickedcolumn

id_date_selected = date(ii_year, ii_month, ii_Day)
em_date.Text = String( id_date_selected, ls_dateFormat )

//선택된 일자를 돌려줌.
CloseWithReturn(Parent, "1")
end event

