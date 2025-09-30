$PBExportHeader$wr_pip5015.srw
$PBExportComments$** 퇴직금 추계액 명세서
forward
global type wr_pip5015 from w_standard_print
end type
type rr_2 from roundrectangle within wr_pip5015
end type
type rb_1 from radiobutton within wr_pip5015
end type
type rb_2 from radiobutton within wr_pip5015
end type
type rb_3 from radiobutton within wr_pip5015
end type
type st_1 from statictext within wr_pip5015
end type
type rr_1 from roundrectangle within wr_pip5015
end type
type rr_3 from roundrectangle within wr_pip5015
end type
end forward

global type wr_pip5015 from w_standard_print
integer x = 0
integer y = 0
string title = "퇴직금 추계액 명세서"
rr_2 rr_2
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
st_1 st_1
rr_1 rr_1
rr_3 rr_3
end type
global wr_pip5015 wr_pip5015

type variables
long ll_year, ll_month, ll_day
end variables

forward prototypes
public subroutine wf_calc_year (string ar_date)
public function integer wf_retrieve ()
end prototypes

public subroutine wf_calc_year (string ar_date);////////////////////////////////////////////////////////////////////////////////////
//           근무일수 Return....                                                  //  
//           Error 시   -1  Return...........................                     //
////////////////////////////////////////////////////////////////////////////////////
Integer a_year, a_month, a_day, b_year, b_month, b_day, over_year
Long term, years, days, rtDays = 1
Date init_date
String  branch, s_temp , s_lastday, s_empno , s_entdate
long dd 
INTEGER il_year, il_month, il_day , il_addyear, il_addmonth, il_addday
datetime arg_enterDate,arg_retireDate

DELETE FROM "P3_RETIREYEAR_TEMP"  
WHERE "P3_RETIREYEAR_TEMP"."COMPANYCODE" = :gs_company   ;
commit ;

DECLARE cur_master CURSOR FOR  
 SELECT "P1_MASTER"."EMPNO",   
        DECODE(FUN_GET_RETCALCDATE( "P1_MASTER"."COMPANYCODE","P1_MASTER"."EMPNO",:ar_date),'00000000', 
				   "P1_MASTER"."ENTERDATE",
					to_char(to_date(FUN_GET_RETCALCDATE("P1_MASTER"."COMPANYCODE","P1_MASTER"."EMPNO",:ar_date),'YYYYMMDD' ) +1 ,'YYYYMMDD')) AS STRDATE 
   FROM "P1_MASTER" 
	where ( "P1_MASTER"."ENTERDATE" <= :ar_date) and
         ( "P1_MASTER"."SERVICEKINDCODE" <> '3' )	;


OPEN cur_master;
	DO WHILE TRUE
		FETCH cur_master INTO :s_empno, :s_entdate;
		IF SQLCA.SQLCODE <> 0 THEN EXIT
		
		il_year = 0
		il_month = 0
		il_day = 0
		
		il_addyear = 0
		il_addmonth = 0
		il_addday = 0

		arg_enterDate = datetime(date(left(s_entdate, 4) + '.' + mid(s_entdate, 5, 2) + '.' + &
                           right(s_entdate, 2)))

		arg_retireDate = datetime(date(left(ar_date, 4) + '.' + mid(ar_date, 5, 2) + '.' + &
                           right(ar_date, 2)))

							
		a_year  = Year(Date(arg_enterDate))
		a_month = Month(Date(arg_enterDate))
		a_day   = Day(Date(arg_enterDate))
		b_year  = Year(Date(arg_retireDate))
		b_month = Month(Date(arg_retireDate))
		b_day   = Day(Date(arg_retireDate))
		
		s_lastday = right(f_last_date(left(string(arg_retireDate,'yyyymmdd'),6)),2)
		
		IF  arg_enterdate <= arg_retiredate  Then

				il_day = b_day - a_day + 1 
				if il_day < 0 then
					s_temp =	f_lastday_month(string(b_year) + string(b_month) + "01")
					il_day = integer(right(s_temp,2)) + b_day - a_day
					b_month = b_month - 1
				else
					if il_day = integer(s_lastday) then
						il_day = il_day - (integer(s_lastday))
						b_month = b_month + 1
					end if
				end if
				
//				if il_day >= 1 then
//					b_month = b_month + 1
//					il_day = 0
//				end if	
				
				il_month = il_month + (b_month - a_month)
				if il_month < 0 then
					il_month = (b_month + 12) - a_month
					b_year = b_year - 1
				end if
				il_year = b_year - a_year
				
				//자사기준 근속년수
				long retireyear,addyear
				
//				SELECT "P3_RETIRERATE"."RETIREYEAR",   
//						 "P3_RETIRERATE"."ADDYEAR"  
//				 INTO  :retireyear , :addyear 		 
//				 FROM "P3_RETIRERATE"  
//				WHERE ( "P3_RETIRERATE"."COMPANYCODE" = :gs_company ) AND  
//						( "P3_RETIRERATE"."YEAR" = :il_year )   ;
				
//				IF sqlca.sqlcode <> 0 then
					retireyear = il_year
					addyear = 1
//				end if		
				
				if isnull(retireyear) then retireyear = il_year
				if isnull(addyear) then addyear = 1
				
				il_addyear = retireyear
				il_addmonth =  il_month * addyear
				il_addday   = il_day	
			END IF
			
			INSERT INTO "P3_RETIREYEAR_TEMP"  
         				( "COMPANYCODE", "EMPNO",  "YEAR1",  "MONTH1",  "DAY1", 
							  "YEAR2",      "MONTH2",  "DAY2" )  
         VALUES (  :gs_company,      :s_empno,    :il_year,  :il_month,   :il_day,   
                   :il_addyear,     :il_addmonth,  :il_addday )  ;

LOOP
CLOSE cur_master;
commit;
end subroutine

public function integer wf_retrieve ();string s_date, ls_date, sJikjong, sKunmu, sSaup, ArgBuf

setpointer(hourglass!)

if dw_ip.Accepttext() = -1 then return -1

s_date = dw_ip.GetitemString(1,'kdate')
sJikjong = trim(dw_ip.GetitemString(1,'jikjong'))
sSaup = trim(dw_ip.GetItemString(1,"saup"))
sKunmu = trim(dw_ip.GetitemString(1,'kunmu'))

IF sJikjong = '' or isnull(sJikjong) THEN
	sJikjong = '%'
	dw_print.modify("t_jikjong.text = '"+'전체'+"'")
ELSE
	SELECT "CODENM"
     INTO :ArgBuf
     FROM "P0_REF"
    WHERE ( "CODEGBN" = 'JJ') AND
          ( "CODE" <> '00' ) AND
			 ( "CODE" = :sJikjong);
	IF SQLCA.SQLCode = 0 THEN dw_print.modify("t_jikjong.text = '" + ArgBuf + "'")
END IF

IF sSaup = '' OR IsNull(sSaup) THEN
	sSaup = '%'
	dw_print.modify("t_saup.text = '"+'전체'+"'")
ELSE
	SELECT "SAUPNAME"
     INTO :ArgBuf
     FROM "P0_SAUPCD"
    WHERE ( "SAUPCODE" = :sSaup);
	IF SQLCA.SQLCode = 0 THEN dw_print.modify("t_saup.text = '" + ArgBuf + "'")
END IF

IF sKunmu = '' OR IsNull(sKunmu) THEN
	sKunmu = '%'
	dw_print.modify("t_kunmu.text = '"+'전체'+"'")
ELSE
	SELECT "KUNMUNAME"
     INTO :ArgBuf
     FROM "P0_KUNMU"
    WHERE ( "KUNMUGUBN" = :sKunmu);
	IF SQLCA.SQLCode = 0 THEN dw_print.modify("t_kunmu.text = '" + ArgBuf + "'")
END IF

if isnull(s_date) or s_date = '' then
	messagebox("확 인","근속기준일을 확인하세요.!!", information!)
	dw_ip.setfocus()
	return -1
end if

ls_date = dw_ip.GetitemString(1,'pdate')

if isnull(ls_date) or ls_date = '' then
	messagebox("확 인","급여기준일을 확인하세요.!!", information!)
	dw_ip.setfocus()
	return -1
end if

wf_calc_year(s_date)

if dw_print.retrieve(gs_company,ls_date,s_date, sSaup, sJikjong, sKunmu) < 1 then
	messagebox("확 인", "조회자료가 없습니다.!!", stopsign!)
	dw_ip.setfocus()
	return -1
end if
   dw_print.sharedata(dw_list)

setpointer(arrow!)
return 1
end function

on wr_pip5015.create
int iCurrent
call super::create
this.rr_2=create rr_2
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.st_1=create st_1
this.rr_1=create rr_1
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.rb_3
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.rr_1
this.Control[iCurrent+7]=this.rr_3
end on

on wr_pip5015.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.st_1)
destroy(this.rr_1)
destroy(this.rr_3)
end on

event open;call super::open;string sdate

dw_ip.Setitem(1,'yymm', left(f_today(),6))
dw_ip.Setitem(1,'kdate', f_today())
dw_ip.Setitem(1,'pdate', f_today())

f_set_saupcd(dw_ip, 'saup', '1')
is_saupcd = gs_saupcd

end event

type p_preview from w_standard_print`p_preview within wr_pip5015
integer x = 4087
integer y = 20
end type

type p_exit from w_standard_print`p_exit within wr_pip5015
integer x = 4434
integer y = 20
end type

type p_print from w_standard_print`p_print within wr_pip5015
integer x = 4261
integer y = 20
end type

type p_retrieve from w_standard_print`p_retrieve within wr_pip5015
integer x = 3913
integer y = 20
end type

type st_window from w_standard_print`st_window within wr_pip5015
boolean visible = false
integer y = 2900
end type

type sle_msg from w_standard_print`sle_msg within wr_pip5015
boolean visible = false
integer y = 2900
end type

type dw_datetime from w_standard_print`dw_datetime within wr_pip5015
boolean visible = false
integer x = 2866
integer y = 2892
end type

type st_10 from w_standard_print`st_10 within wr_pip5015
boolean visible = false
integer y = 2900
end type

type gb_10 from w_standard_print`gb_10 within wr_pip5015
boolean visible = false
integer y = 2848
end type

type dw_print from w_standard_print`dw_print within wr_pip5015
integer x = 3749
integer y = 40
string dataobject = "d_pip5015_p"
end type

type dw_ip from w_standard_print`dw_ip within wr_pip5015
integer x = 421
integer y = 76
integer width = 2496
integer height = 184
integer taborder = 20
string dataobject = "d_pip5015_4"
end type

event dw_ip::itemchanged;call super::itemchanged;this.AcceptText()

IF this.GetColumnName() = 'saup' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF
end event

type dw_list from w_standard_print`dw_list within wr_pip5015
integer x = 416
integer y = 344
integer width = 3726
integer height = 1960
string dataobject = "d_pip5015"
boolean hscrollbar = false
boolean border = false
boolean hsplitscroll = false
end type

type rr_2 from roundrectangle within wr_pip5015
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 402
integer y = 52
integer width = 2569
integer height = 236
integer cornerheight = 40
integer cornerwidth = 55
end type

type rb_1 from radiobutton within wr_pip5015
event clicked pbm_bnclicked
integer x = 3296
integer y = 60
integer width = 293
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "전   체"
boolean checked = true
end type

event clicked;dw_list.SetReDraw(false)
dw_list.dataobject = 'd_pip5015'
dw_list.SetTransObject(sqlca)
dw_list.SetReDraw(true)

dw_print.SetReDraw(false)
dw_print.dataobject = 'd_pip5015_p'
dw_print.SetTransObject(sqlca)
dw_print.SetReDraw(true)
end event

type rb_2 from radiobutton within wr_pip5015
event clicked pbm_bnclicked
integer x = 3296
integer y = 132
integer width = 293
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "1년이상"
end type

event clicked;dw_list.SetReDraw(false)
dw_list.dataobject = 'd_pip5015_1'
dw_list.SetTransObject(sqlca)
dw_list.SetReDraw(true)

dw_print.SetReDraw(false)
dw_print.dataobject = 'd_pip5015_1_p'
dw_print.SetTransObject(sqlca)
dw_print.SetReDraw(true)
end event

type rb_3 from radiobutton within wr_pip5015
event clicked pbm_bnclicked
integer x = 3296
integer y = 204
integer width = 293
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "1년미만"
end type

event clicked;dw_list.SetReDraw(false)

dw_list.dataobject = 'd_pip5015_2'
dw_list.SetTransObject(sqlca)

dw_list.SetReDraw(true)


dw_print.SetReDraw(false)
dw_print.dataobject = 'd_pip5015_2_p'
dw_print.SetTransObject(sqlca)
dw_print.SetReDraw(true)
end event

type st_1 from statictext within wr_pip5015
integer x = 3031
integer y = 68
integer width = 261
integer height = 44
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "근속년수"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within wr_pip5015
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 2981
integer y = 28
integer width = 649
integer height = 260
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within wr_pip5015
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 402
integer y = 336
integer width = 3753
integer height = 1996
integer cornerheight = 40
integer cornerwidth = 55
end type

