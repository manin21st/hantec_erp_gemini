$PBExportHeader$w_pik1001.srw
$PBExportComments$** 달력 생성_공통, 사업장별 생성
forward
global type w_pik1001 from w_inherite_standard
end type
type st_31 from statictext within w_pik1001
end type
type dw_saup from datawindow within w_pik1001
end type
type st_30 from statictext within w_pik1001
end type
type st_2 from statictext within w_pik1001
end type
type st_3 from statictext within w_pik1001
end type
type uo_1 from u_progress_bar within w_pik1001
end type
type em_syear from editmask within w_pik1001
end type
type st_11 from statictext within w_pik1001
end type
type em_eyear from editmask within w_pik1001
end type
type p_1 from uo_picture within w_pik1001
end type
type dw_list from u_d_select_sort within w_pik1001
end type
type dw_save from u_d_select_sort within w_pik1001
end type
type dw_ip from datawindow within w_pik1001
end type
type rr_1 from roundrectangle within w_pik1001
end type
type ln_1 from line within w_pik1001
end type
type ln_2 from line within w_pik1001
end type
type rr_2 from roundrectangle within w_pik1001
end type
end forward

global type w_pik1001 from w_inherite_standard
string title = "달력 생성"
st_31 st_31
dw_saup dw_saup
st_30 st_30
st_2 st_2
st_3 st_3
uo_1 uo_1
em_syear em_syear
st_11 st_11
em_eyear em_eyear
p_1 p_1
dw_list dw_list
dw_save dw_save
dw_ip dw_ip
rr_1 rr_1
ln_1 ln_1
ln_2 ln_2
rr_2 rr_2
end type
global w_pik1001 w_pik1001

type variables
dec ic_timer_interval

int  ii_pct_complete

end variables

forward prototypes
public function character f_daynumbercheck (integer day_nbr)
public subroutine wf_calculatejulian ()
public function integer wf_comm_calendar (string as_saup)
public function integer wf_saup_calendar (string as_saup)
end prototypes

public function character f_daynumbercheck (integer day_nbr);char	work_day
dw_ip.Accepttext()

	CHOOSE CASE day_nbr
		CASE 1            // 일요일
//			IF rb_17.Checked = True THEN
//				work_day = '0'
//			ELSE
//				work_day = '1'
//			END IF
         work_day = dw_ip.GetitemString(1,'sun')
			
		CASE 2
//			IF rb_11.Checked = True THEN
//				work_day = '0'
//			ELSE
//				work_day = '1'
//			END IF
			 work_day = dw_ip.GetitemString(1,'mon')
		CASE 3
//			IF rb_12.Checked = True THEN
//				work_day = '0'
//			ELSE
//				work_day = '1'
//			END IF
			 work_day = dw_ip.GetitemString(1,'tue') 
		CASE 4
//			IF rb_13.Checked = True THEN
//				work_day = '0'
//			ELSE
//				work_day = '1'
//			END IF
			 work_day = dw_ip.GetitemString(1,'wed') 
		CASE 5
//			IF rb_14.Checked = True THEN
//				work_day = '0'
//			ELSE
//				work_day = '1'
//			END IF
			  work_day = dw_ip.GetitemString(1,'thu')
		CASE 6
//			IF rb_15.Checked = True THEN
//				work_day = '0'
//			ELSE
//				work_day = '1'
//			END IF
			  work_day = dw_ip.GetitemString(1,'fri')
		CASE 7
//			IF rb_16.Checked = True THEN
//				work_day = '0'
//			ELSE
//				work_day = '1'
//			END IF
			  work_day = dw_ip.GetitemString(1,'sat')
	END CHOOSE

RETURN work_day
end function

public subroutine wf_calculatejulian ();//
//sle_msg.text   = '작업중입니다'
//
//
//char		cWork_day
//string 	sFetchDay
//int	 	iTotalCount, Julian_except
//
//iTotalCount = 1		
//julian_except = 1
//
//
// DECLARE c_temp CURSOR FOR  
//  SELECT "CALNDR"."CLKEY",   
//  	      "CALNDR"."CHKCD"  
//    FROM "CALNDR" 
//	 ORDER BY "CALNDR"."CLKEY" ASC  ;
//
//OPEN c_temp ;
//
//DO 
//
//	FETCH		c_temp
//		INTO	:sFetchDay,	
//				:cWork_day;
//
//	IF sqlca.sqlcode <> 0		THEN		EXIT
//	
//   UPDATE "CALNDR"  
//     SET "JLDAT2" = :julian_except  
//	WHERE ( "CALNDR"."SABU" = :gsSabu ) AND
//			( "CALNDR"."CLKEY" = :sFetchDay ) ;
//			
//	IF cWork_day = 'Y'		THEN		julian_except++
//	
//	decimal{2} 	meter_position
//	meter_position = truncate( ( iTotalCount / (365*5) * 100 ) , 0 )
//	uo_1.uf_set_position ( meter_position )    
//	iTotalCount++	
//
//LOOP UNTIL ( sqlca.sqlcode <> 0 )
//
//COMMIT;
//
//CLOSE c_temp;
//
//cb_start.enabled  = true
//cb_exit.enabled  = true
//sle_msg.text   = ''	
//uo_1.visible  = false    
//
//SetPointer(ARROW!)
//
//dw_list.Retrieve()
//
//
end subroutine

public function integer wf_comm_calendar (string as_saup);
char		work_day 	
string	temp_date,workgub	,	&
			sOldMonth,     &
			sThisMonth,    &
			sStartYear,    &
			sEndYear

date		dtStart_date

int		day_nbr, 			&
			Julian_all   = 1,	&
			iTotalCount = 1,	&
			iHCount,				&
			iCount = 0

long		lRow,        cnt,     &
			iStartYear,			&
			iYear,			   &
			iEndYear

String sStartdate, sEnddate

iHCount = 0														//토요 휴무 선택 count
sOldMonth   = '01'											//토요 휴무 선택 시작월
cnt = 1

dtStart_date = date( em_syear.text+ '/01/01')

sStartYear   = em_syear.text
sEndYear     = em_eyear.text

sStartdate = sStartYear + '0101'
sEnddate = sEndYear + '1231'

iStartYear   = Long(sStartYear)
iEndYear     = Long(sEndYear)

SELECT COUNT("P4_CALENDAR"."CLDATE")  
	INTO :iCount  
   FROM "P4_CALENDAR"  
   WHERE ( "P4_CALENDAR"."COMPANYCODE" = :gs_company ) AND  
         ( SUBSTR("P4_CALENDAR"."CLDATE",1,4) >= :sStartYear ) AND  
         ( SUBSTR("P4_CALENDAR"."CLDATE",1,4) <= :sEndYear )   ;

IF iCount > 0 AND Not IsNull(iCount) THEN
	IF MessageBox("확 인","이전 달력자료를 삭제한 후 다시 생성합니다!!",Question!,YesNo!) = 1 THEN
		
		w_mdi_frame.sle_msg.text = '달력 자료 생성 중.....'
		// 달력 공통
		DELETE FROM "P4_CALENDAR" 
			WHERE ( "P4_CALENDAR"."COMPANYCODE" = :gs_company ) AND  
         		( SUBSTR("P4_CALENDAR"."CLDATE",1,4) >= :sStartYear ) AND  
         		( SUBSTR("P4_CALENDAR"."CLDATE",1,4) <= :sEndYear )   ;
			
		// 본사 사업장 달력 
		DELETE FROM "P4_CALENDAR_SAUP" 
			WHERE ( "P4_CALENDAR_SAUP"."SAUPCD" = '10' ) AND  
         		( SUBSTR("P4_CALENDAR_SAUP"."CLDATE",1,4) >= :sStartYear ) AND  
         		( SUBSTR("P4_CALENDAR_SAUP"."CLDATE",1,4) <= :sEndYear )   ;
					
//		COMMIT;
	ELSE
		Return -1
	END IF
END IF

dw_list.Reset()

DO WHILE ( iYear <= iEndYear )

	temp_date  = string(dtStart_date, "yyyymmdd")

	day_nbr  = daynumber( dtStart_date )												//sunday = 1, saturday = 7
	
	work_day = f_DayNumberCheck( day_nbr )

	lRow = dw_list.InsertRow(0)

	dw_list.SetItem(lRow, "companycode",   gs_company)
	dw_list.SetItem(lRow, "cldate",        String(temp_date,"@@@@@@@@"))
	dw_list.SetItem(lRow, "jdate",         julian_all)
	dw_list.SetItem(lRow, "daygubn",       String(day_nbr))
	dw_list.SetItem(lRow, "hdaygubn",      work_day)
	if day_nbr = 7 then
		workgub = '2' 		
	elseif day_nbr = 1 then
		workgub = '9'		
	else
		workgub = '1'	
	end if
	dw_list.SetItem(lRow, "workgub",   workgub)
	dw_list.SetItem(lRow, "nightyn",   'N')
	dw_list.SetItem(lRow, "alnight",   'N')
	dw_list.SetItem(lRow, "extra",     'N')
	
	dw_list.SetItem(lRow, "rate2",     0)
	dw_list.SetItem(lRow, "rate3",     0)
	dw_list.SetItem(lRow, "rate4",     0)
	dw_list.SetItem(lRow, "jdate2", cnt)
	IF work_day = '0' THEN
		dw_list.SetItem(lRow, "salehdaygu",      'Y')
		dw_list.SetItem(lRow, "overyn",    'Y')
		dw_list.SetItem(lRow, "rate1",     100)
		cnt = cnt + 1
	ELSE
		dw_list.SetItem(lRow, "salehdaygu",      'N')
		dw_list.SetItem(lRow, "overyn",    'N')
		dw_list.SetItem(lRow, "rate1",     0)
	END IF			
	
	dw_list.SetItem(lRow, "yyyymm",        left(String(temp_date,"@@@@@@@@"),6))

	decimal{2} 	meter_position
	meter_position = truncate( ( iTotalCount / (365 * ((iEndYear - iStartYear) + 1)) * 100 ) , 0 )

	uo_1.uf_set_position ( meter_position )    
	
	IF day_nbr = 7 THEN

		sThisMonth = mid( temp_date, 5, 2 )

		sOldMonth = sThisMonth
	
	END IF
	
	dtStart_date = RelativeDate(dtStart_date, 1)

	iYear = Long( string(dtStart_date, "yyyy") )

	julian_all++
	iTotalCount++

LOOP

Long ll_rcnt2, i, ll_index2
Integer li_return

ll_rcnt2 = dw_save.retrieve(as_saup, sStartdate, sEnddate)
for i = 1 to ll_rcnt2
	dw_save.deleterow(1)
next 

if dw_save.rowcount() = 0 then
	li_return = dw_list.RowsCopy(1, dw_list.rowcount(), Primary!, dw_save, 1, Primary!)
	if li_return = -1 then
		messagebox("달력생성오류", "사업장별 달력을 생성하는 중 오류가 발생하였습니다.") 
		Return -1
	end if
		
	for ll_index2 = 1 to dw_list.RowCount()
		dw_save.setitem(ll_index2, 'saupcd', as_saup)
	next	
	
end if

if dw_list.update() = 1 then
	if dw_save.update() = 1 then 
		Return 1
	else
		Return -1
	end if
else
	Return -1
end if

Return 1
end function

public function integer wf_saup_calendar (string as_saup);
char		work_day 	
string	temp_date,workgub	,	&
			sOldMonth,     &
			sThisMonth,    &
			sStartYear,    &
			sEndYear

date		dtStart_date

int		day_nbr, 			&
			Julian_all   = 1,	&
			iTotalCount = 1,	&
			iHCount,				&
			iCount = 0

long		lRow,        cnt,     &
			iStartYear,			&
			iYear,			   &
			iEndYear


String sStartdate, sEnddate
Long ll_rcnt2, i

iHCount = 0														//토요 휴무 선택 count
sOldMonth   = '01'											//토요 휴무 선택 시작월
cnt = 1

dtStart_date = date( em_syear.text+ '/01/01')

sStartYear   = em_syear.text
sEndYear     = em_eyear.text

sStartdate = sStartYear + '0101'
sEnddate = sEndYear + '1231'

iStartYear   = Long(sStartYear)
iEndYear     = Long(sEndYear)

ll_rcnt2 = dw_save.retrieve(as_saup, sStartdate, sEnddate)
for i = 1 to ll_rcnt2
	dw_save.deleterow(1)
next 

DO WHILE ( iYear <= iEndYear )

	temp_date  = string(dtStart_date, "yyyymmdd")

	day_nbr  = daynumber( dtStart_date )												//sunday = 1, saturday = 7
	
	work_day = f_DayNumberCheck( day_nbr )

	lRow = dw_save.InsertRow(0)

	dw_save.SetItem(lRow, "saupcd",   as_saup)
	dw_save.SetItem(lRow, "cldate",        String(temp_date,"@@@@@@@@"))
	dw_save.SetItem(lRow, "jdate",         julian_all)
	dw_save.SetItem(lRow, "daygubn",       String(day_nbr))
	dw_save.SetItem(lRow, "hdaygubn",      work_day)
	if day_nbr = 7 then
		workgub = '2' 		
	elseif day_nbr = 1 then
		workgub = '9'		
	else
		workgub = '1'	
	end if
	dw_save.SetItem(lRow, "workgub",   workgub)
	dw_save.SetItem(lRow, "nightyn",   'N')
	dw_save.SetItem(lRow, "alnight",   'N')
	dw_save.SetItem(lRow, "extra",     'N')
	
	dw_save.SetItem(lRow, "rate2",     0)
	dw_save.SetItem(lRow, "rate3",     0)
	dw_save.SetItem(lRow, "rate4",     0)
	dw_save.SetItem(lRow, "jdate2", cnt)
	IF work_day = '0' THEN
		dw_save.SetItem(lRow, "salehdaygu",      'Y')
		dw_save.SetItem(lRow, "overyn",    'Y')
		dw_save.SetItem(lRow, "rate1",     100)
		cnt = cnt + 1
	ELSE
		dw_save.SetItem(lRow, "salehdaygu",      'N')
		dw_save.SetItem(lRow, "overyn",    'N')
		dw_save.SetItem(lRow, "rate1",     0)
	END IF			
	
	dw_save.SetItem(lRow, "yyyymm", left(String(temp_date,"@@@@@@@@"),6))
	
	decimal{2} 	meter_position
	meter_position = truncate( ( iTotalCount / (365 * ((iEndYear - iStartYear) + 1)) * 100 ) , 0 )

	uo_1.uf_set_position ( meter_position )    
	
	IF day_nbr = 7 THEN

		sThisMonth = mid( temp_date, 5, 2 )

		sOldMonth = sThisMonth
	
	END IF
	
	dtStart_date = RelativeDate(dtStart_date, 1)

	iYear = Long( string(dtStart_date, "yyyy") )

	julian_all++
	iTotalCount++

LOOP
	
if dw_save.update() <> 1 then Return -1
				
Return 1
end function

event open;call super::open;//w_frame.hide()

dw_list.settransobject(sqlca)
dw_list.Retrieve()

dw_ip.settransobject(sqlca)
dw_ip.insertrow(0)

dw_saup.settransobject(sqlca)
dw_save.settransobject(sqlca)

dw_saup.Retrieve()

em_syear.text = mid(string(today(),"yyyymmdd"), 1, 4)
em_eyear.text = String(Long(em_syear.text) + 10)

em_eyear.SetFocus()
end event

on w_pik1001.create
int iCurrent
call super::create
this.st_31=create st_31
this.dw_saup=create dw_saup
this.st_30=create st_30
this.st_2=create st_2
this.st_3=create st_3
this.uo_1=create uo_1
this.em_syear=create em_syear
this.st_11=create st_11
this.em_eyear=create em_eyear
this.p_1=create p_1
this.dw_list=create dw_list
this.dw_save=create dw_save
this.dw_ip=create dw_ip
this.rr_1=create rr_1
this.ln_1=create ln_1
this.ln_2=create ln_2
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_31
this.Control[iCurrent+2]=this.dw_saup
this.Control[iCurrent+3]=this.st_30
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.uo_1
this.Control[iCurrent+7]=this.em_syear
this.Control[iCurrent+8]=this.st_11
this.Control[iCurrent+9]=this.em_eyear
this.Control[iCurrent+10]=this.p_1
this.Control[iCurrent+11]=this.dw_list
this.Control[iCurrent+12]=this.dw_save
this.Control[iCurrent+13]=this.dw_ip
this.Control[iCurrent+14]=this.rr_1
this.Control[iCurrent+15]=this.ln_1
this.Control[iCurrent+16]=this.ln_2
this.Control[iCurrent+17]=this.rr_2
end on

on w_pik1001.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_31)
destroy(this.dw_saup)
destroy(this.st_30)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.uo_1)
destroy(this.em_syear)
destroy(this.st_11)
destroy(this.em_eyear)
destroy(this.p_1)
destroy(this.dw_list)
destroy(this.dw_save)
destroy(this.dw_ip)
destroy(this.rr_1)
destroy(this.ln_1)
destroy(this.ln_2)
destroy(this.rr_2)
end on

type p_mod from w_inherite_standard`p_mod within w_pik1001
boolean visible = false
integer x = 1522
integer y = 2248
end type

type p_del from w_inherite_standard`p_del within w_pik1001
boolean visible = false
integer x = 1696
integer y = 2248
end type

type p_inq from w_inherite_standard`p_inq within w_pik1001
boolean visible = false
integer x = 827
integer y = 2248
end type

type p_print from w_inherite_standard`p_print within w_pik1001
boolean visible = false
integer x = 654
integer y = 2248
end type

type p_can from w_inherite_standard`p_can within w_pik1001
boolean visible = false
integer x = 1870
integer y = 2248
end type

type p_exit from w_inherite_standard`p_exit within w_pik1001
integer x = 4416
end type

type p_ins from w_inherite_standard`p_ins within w_pik1001
boolean visible = false
integer x = 1001
integer y = 2248
end type

type p_search from w_inherite_standard`p_search within w_pik1001
boolean visible = false
integer x = 475
integer y = 2248
end type

type p_addrow from w_inherite_standard`p_addrow within w_pik1001
boolean visible = false
integer x = 1175
integer y = 2248
end type

type p_delrow from w_inherite_standard`p_delrow within w_pik1001
boolean visible = false
integer x = 1349
integer y = 2248
end type

type dw_insert from w_inherite_standard`dw_insert within w_pik1001
boolean visible = false
integer x = 215
integer y = 2252
end type

type st_window from w_inherite_standard`st_window within w_pik1001
boolean visible = false
end type

type cb_exit from w_inherite_standard`cb_exit within w_pik1001
boolean visible = false
end type

type cb_update from w_inherite_standard`cb_update within w_pik1001
boolean visible = false
end type

type cb_insert from w_inherite_standard`cb_insert within w_pik1001
boolean visible = false
end type

type cb_delete from w_inherite_standard`cb_delete within w_pik1001
boolean visible = false
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pik1001
boolean visible = false
end type

type st_1 from w_inherite_standard`st_1 within w_pik1001
boolean visible = false
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pik1001
boolean visible = false
end type

type dw_datetime from w_inherite_standard`dw_datetime within w_pik1001
boolean visible = false
end type

type sle_msg from w_inherite_standard`sle_msg within w_pik1001
boolean visible = false
end type

type gb_2 from w_inherite_standard`gb_2 within w_pik1001
boolean visible = false
end type

type gb_1 from w_inherite_standard`gb_1 within w_pik1001
boolean visible = false
end type

type gb_10 from w_inherite_standard`gb_10 within w_pik1001
boolean visible = false
end type

type st_31 from statictext within w_pik1001
integer x = 827
integer y = 612
integer width = 311
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
boolean enabled = false
string text = "사업장선택"
boolean focusrectangle = false
end type

type dw_saup from datawindow within w_pik1001
integer x = 782
integer y = 696
integer width = 1202
integer height = 296
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_pik10011_saup"
boolean vscrollbar = true
boolean livescroll = true
end type

type st_30 from statictext within w_pik1001
integer x = 827
integer y = 316
integer width = 242
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
boolean enabled = false
string text = "처리조건"
boolean focusrectangle = false
end type

type st_2 from statictext within w_pik1001
integer x = 919
integer y = 500
integer width = 265
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "종료년도"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_3 from statictext within w_pik1001
integer x = 827
integer y = 1064
integer width = 681
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
boolean enabled = false
string text = "주간 근무(휴무)일 선택"
boolean focusrectangle = false
end type

type uo_1 from u_progress_bar within w_pik1001
event destroy ( )
boolean visible = false
integer x = 887
integer y = 2024
integer width = 1006
integer height = 72
integer taborder = 20
boolean bringtotop = true
end type

on uo_1.destroy
call u_progress_bar::destroy
end on

type em_syear from editmask within w_pik1001
event ue_enter pbm_keydown
integer x = 1189
integer y = 424
integer width = 219
integer height = 52
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33554431
boolean border = false
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "0000"
double increment = 1
string minmax = "0~~"
end type

type st_11 from statictext within w_pik1001
integer x = 919
integer y = 416
integer width = 265
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "시작년도"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_eyear from editmask within w_pik1001
event ue_enter pbm_keydown
integer x = 1189
integer y = 504
integer width = 219
integer height = 52
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33554431
boolean border = false
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "0000"
double increment = 1
string minmax = "0~~"
end type

type p_1 from uo_picture within w_pik1001
integer x = 4242
integer y = 24
integer width = 178
integer taborder = 40
boolean bringtotop = true
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\생성_up.gif"
end type

event clicked;call super::clicked;
char		work_day 	
string	temp_date,workgub	,	&
			sOldMonth,     &
			sThisMonth,    &
			sStartYear,    &
			sEndYear, sStartdate, sEnddate

date		dtStart_date

int		day_nbr, 			&
			Julian_all   = 1,	&
			iTotalCount = 1,	&
			iHCount,				&
			iCount = 0

long		lRow,        cnt,     &
			iStartYear,			&
			iYear,			   &
			iEndYear

iHCount = 0														//토요 휴무 선택 count
sOldMonth   = '01'											//토요 휴무 선택 시작월
cnt = 1

Long ll_rcnt, ll_rcnt2, ll_index, ll_count
String ls_saup, ls_create

ll_count = 0

// 반드시 사업장을 선택하게 한다
ll_rcnt = dw_saup.rowcount()

For ll_index = 1 TO ll_rcnt
	IF dw_saup.GetItemString(ll_index, 'chk_tag') = 'Y' THEN
		ll_count ++
	END IF
NEXT

IF ll_count < 1 THEN
	MessageBox('확인','선택된 사업장이 없습니다!!')
	Return
END IF

w_mdi_frame.sle_msg.text = '달력 자료 생성 중.....'

SetPointer(HOURGLASS!)

uo_1.visible = true
p_exit.enabled = false

Boolean lb_commit = True
Integer li_return

// 사업장 달력 테이블에도 생성 한다
// 단 사업장이 1개일때는 공통달력의 내용을 그대로 복사하여 자동 생성하여 준다
for ll_index = 1 to ll_rcnt
	ls_saup = dw_saup.GetItemString(ll_index, 'saupcode')
	ls_create = dw_saup.GetItemString(ll_index, 'chk_tag')
	if ls_create = 'N' then continue
	
	if ls_create = 'Y' and ls_saup = '10' then
		// 공통달력과 사업장본사달력(  P4_CALENDAR, P4_CALENDAR_SAUP('10')  ) 을 생성한다
		li_return = wf_comm_calendar(ls_saup)
	else		
		// 선택된 사업장의 달력을 생성한다
		li_return = wf_saup_calendar(ls_saup)
	end if
	
	if li_return <> 1 then 
		lb_commit = False
		exit
	end if
	
next

if lb_commit then
	COMMIT;
	//	cb_1.TriggerEvent(Clicked!)
ELSE
	ROLLBACK;
end if

w_mdi_frame.sle_msg.text ='달력 자료 생성 완료!!'

SetPointer(Arrow!)

uo_1.visible    = false
p_exit.enabled = true


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\생성_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\생성_up.gif"
end event

type dw_list from u_d_select_sort within w_pik1001
integer x = 2158
integer y = 224
integer width = 1746
integer height = 1900
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_pik10011"
boolean border = false
boolean livescroll = false
end type

type dw_save from u_d_select_sort within w_pik1001
boolean visible = false
integer x = 3959
integer y = 208
integer width = 599
integer height = 1900
integer taborder = 21
boolean bringtotop = true
string dataobject = "d_pik10011_save"
boolean hscrollbar = false
boolean border = false
end type

type dw_ip from datawindow within w_pik1001
integer x = 741
integer y = 1132
integer width = 1115
integer height = 880
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "d_pik10011_1"
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_pik1001
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 690
integer y = 216
integer width = 1381
integer height = 1944
integer cornerheight = 40
integer cornerwidth = 55
end type

type ln_1 from line within w_pik1001
integer linethickness = 1
integer beginx = 1198
integer beginy = 476
integer endx = 1408
integer endy = 476
end type

type ln_2 from line within w_pik1001
integer linethickness = 1
integer beginx = 1198
integer beginy = 556
integer endx = 1408
integer endy = 556
end type

type rr_2 from roundrectangle within w_pik1001
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2149
integer y = 216
integer width = 1774
integer height = 1944
integer cornerheight = 40
integer cornerwidth = 55
end type

