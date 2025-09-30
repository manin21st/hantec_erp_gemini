$PBExportHeader$w_tht_4553p.srw
$PBExportComments$초중종물 현황판
forward
global type w_tht_4553p from w_standard_print
end type
type st_1 from statictext within w_tht_4553p
end type
type dw_ymd from datawindow within w_tht_4553p
end type
type dw_time from datawindow within w_tht_4553p
end type
type rr_1 from roundrectangle within w_tht_4553p
end type
type st_2 from statictext within w_tht_4553p
end type
type uo_message from u_message_board within w_tht_4553p
end type
end forward

global type w_tht_4553p from w_standard_print
integer width = 5198
integer height = 3600
string title = "초중종물 실적 현황"
boolean maxbox = true
long backcolor = 0
st_1 st_1
dw_ymd dw_ymd
dw_time dw_time
rr_1 rr_1
st_2 st_2
uo_message uo_message
end type
global w_tht_4553p w_tht_4553p

type variables
integer is_row, ii_curtime
Long    ii_pageCnt, ii_curPage, is_timer
end variables
forward prototypes
public function integer wf_retrieve ()
public subroutine wf_priorpage ()
public subroutine wf_nextpage ()
public subroutine wf_message ()
end prototypes

public function integer wf_retrieve ();//-----------------------------------------------------------------
// SPEC : 조회
//-----------------------------------------------------------------
// 작성일자 : 2015-12-01  작성자 : 전상현
// 작성내용 : 조회
//-----------------------------------------------------------------

string	sSidat1, sSidat2, sPdtgu, sJocod, sWkctr, sItnbr, sRqcgu, sChk, sAutoyn, sTodayck

if dw_ip.accepttext( ) = -1 then return -1

SetPointer ( HourGlass! )

sSidat1	=	dw_ip.getitemstring(1, 'sidat1')
sSidat2	=	dw_ip.getitemstring(1, 'sidat2')
sPdtgu	=	dw_ip.getitemstring(1, 'pdtgu')
sJocod	=	dw_ip.getitemstring(1, 'jocod')
sWkctr	=	dw_ip.getitemstring(1, 'wkctr')
sItnbr	=	dw_ip.getitemstring(1, 'itnbr')
sChk		=	dw_ip.getitemstring(1, 'send_chk')
sAutoyn    =	dw_ip.getitemstring(1, 'autoyn')
sTodayck    =	dw_ip.getitemstring(1, 'todayck')


if sPdtgu = '' or isnull(sPdtgu) then	sPdtgu = '%'
if sJocod = '' or isnull(sJocod) then	sJocod = '%'
if sWkctr = '' or isnull(sWkctr)	then	sWkctr = '%'
if sItnbr = '' or isnull(sItnbr)	then	sItnbr = '%'

String ls_befday

SELECT TO_CHAR(SYSDATE - 1,'YYYYMMDD'), TO_CHAR(SYSDATE,'YYYYMMDD')
INTO    :ls_befday, :is_today
FROM   DUAL;

if sSidat1 < ls_befday and sTodayck = 'Y' then
	dw_ip.SetItem(1, 'sidat1', ls_befday)
	sSidat1 = ls_befday
end if

dw_list.retrieve( sSidat1, sSidat2, sItnbr, sChk, sPdtgu, sJocod, sWkctr )
wf_message()
ii_pageCnt = Long(dw_list.Describe("evaluate('pagecount()',0)"))
ii_curPage = 1
SetPointer ( Arrow! )
return 1
end function

public subroutine wf_priorpage ();/////////////////////////////////////////
///// PRIOR SCROLL
/////////////////////////////////////////

dw_list.scrollpriorpage()
	
RETURN
end subroutine

public subroutine wf_nextpage ();/////////////////////////////////////////
///// NEXT SCROLL
/////////////////////////////////////////

dw_list.scrollnextpage()
ii_curPage ++

RETURN
end subroutine

public subroutine wf_message ();string sMess
long	 nCount
//if dw_2.accepttext( ) = -1 then return -1
//nCount = dw_2.rowcount( )
//
//if nCount < 1 then return -1
//
//if nMessRow < nCount then
//	nMessRow = nMessRow + 1
//elseif nMessRow = nCount then
//	nMessRow = 1
//elseif nMessRow > nCount then
//	nMessRow = 1
//end if
//
//sMess = dw_2.getitemstring(nMessRow, 'mess_data')

//sMess = '2016년은 품질 확립의 해!'
sMess = dw_ip.getitemstring(1, 'message')

uo_message.uf_SetMessage( sMess )
uo_message.uf_SetFont( '-윤고딕330' )
uo_message.uf_SetFontSize( 65 )
uo_message.uf_SetColor( 255, 0 )
end subroutine

on w_tht_4553p.create
int iCurrent
call super::create
this.st_1=create st_1
this.dw_ymd=create dw_ymd
this.dw_time=create dw_time
this.rr_1=create rr_1
this.st_2=create st_2
this.uo_message=create uo_message
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.dw_ymd
this.Control[iCurrent+3]=this.dw_time
this.Control[iCurrent+4]=this.rr_1
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.uo_message
end on

on w_tht_4553p.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.dw_ymd)
destroy(this.dw_time)
destroy(this.rr_1)
destroy(this.st_2)
destroy(this.uo_message)
end on

event open;/*현장용으로 인해 상속 받지 않음*/

//-----------------------------------------------------------------
// SPEC : 초기 셋팅
//-----------------------------------------------------------------
// 작성일자 : 2015-08-31  작성자 : 전상현
// 작성내용 : 초기 셋팅
//            DATAWINDOW 정의 및 초기값 처리
//-----------------------------------------------------------------
this.SetPosition(TopMost!)
//this.width	=	4685
//this.height	=	3050
//dw_ip.Visible = False

is_window_id = this.ClassName()
//is_today	=	f_today()

String ls_befday

SELECT TO_CHAR(SYSDATE - 1,'YYYYMMDD'), TO_CHAR(SYSDATE,'YYYYMMDD')
INTO    :ls_befday, :is_today
FROM   DUAL;

dw_ip.SetTransObject(SQLCA)
dw_ip.Reset()
dw_ip.InsertRow(0)
dw_ip.SetItem(1, 'message',  left(is_today,4)+'년은 품질 확립의 해!')

dw_ymd.SetTransObject(SQLCA)
dw_ymd.InsertRow(0)

dw_time.SetTransObject(SQLCA)
dw_time.InsertRow(0)

//if dw_ip.GetChild("wkctr", Dw_Child2) = 1 then
//	dw_child2.settransobject(sqlca)
//end if
//
dw_ip.setitem(1, 'sidat1', ls_befday)
dw_ip.setitem(1, 'sidat2', '29991231')

dw_list.settransobject(sqlca)

dw_ip.SetFocus()
is_row = 0
is_timer = 5
ii_pageCnt = 0
ii_curPage = 0
timer(is_timer)

//wf_retrieve()

end event

event closequery;call super::closequery;timer(0)
end event

event timer;call super::timer;if is_timer <> 0 then
	if ii_curPage = ii_pageCnt then
		wf_retrieve()
	else
		wf_nextpage()
	end if
end if
end event

event resize;call super::resize;
dw_list.width = newwidth - 110
dw_list.height = newheight - 840
//dw_list.height = newheight - 600

rr_1.width = newwidth - 85
rr_1.height = newheight - 820
//rr_1.height = newheight - 580

st_2.x = newwidth - 500

st_1.width = newwidth - 110  // TITLE
dw_time.x = newwidth - 800  // 시간

uo_message.width = newwidth - 110
uo_message.y =  newheight - 270

end event

type p_xls from w_standard_print`p_xls within w_tht_4553p
integer x = 3067
integer y = 6824
boolean enabled = false
end type

type p_sort from w_standard_print`p_sort within w_tht_4553p
integer x = 2889
integer y = 6832
boolean enabled = false
end type

type p_preview from w_standard_print`p_preview within w_tht_4553p
boolean visible = false
integer x = 3493
integer y = 6824
end type

type p_exit from w_standard_print`p_exit within w_tht_4553p
boolean visible = false
integer x = 3840
integer y = 6824
boolean enabled = false
end type

type p_print from w_standard_print`p_print within w_tht_4553p
boolean visible = false
integer x = 3666
integer y = 6824
end type

type p_retrieve from w_standard_print`p_retrieve within w_tht_4553p
boolean visible = false
integer x = 3319
integer y = 6824
boolean enabled = false
end type

type st_window from w_standard_print`st_window within w_tht_4553p
integer x = 2414
integer y = 6780
end type

type sle_msg from w_standard_print`sle_msg within w_tht_4553p
integer x = 439
integer y = 6780
end type

type dw_datetime from w_standard_print`dw_datetime within w_tht_4553p
boolean visible = false
integer x = 5554
integer y = 4000
integer width = 837
integer height = 80
boolean enabled = false
end type

type st_10 from w_standard_print`st_10 within w_tht_4553p
integer x = 78
integer y = 6780
end type

type gb_10 from w_standard_print`gb_10 within w_tht_4553p
integer x = 64
integer y = 6744
end type

type dw_print from w_standard_print`dw_print within w_tht_4553p
integer x = 2711
integer y = 6856
string dataobject = "d_tht_4552_p"
end type

type dw_ip from w_standard_print`dw_ip within w_tht_4553p
integer x = 146
integer y = 636
integer width = 4133
integer height = 724
boolean titlebar = true
string title = "조회 세팅"
string dataobject = "d_tht_4553p_c"
boolean controlmenu = true
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String  sNull,sPdtgu, sIttyp, sItcls, sItnbr, sItdsc, sIspec, sjijil, sispeccode, sText
String  sItemCls, sItemGbn, sItemClsName, ls_wkctr
Long    nRow, nTimer

SetNull(snull)

nRow = GetRow()
If nRow <= 0 Then Return

if this.GetColumnName( ) = 'itnbr' then
		sItnbr = Trim(GetText())
		IF sItnbr ="" OR IsNull(sItnbr) THEN
			SetItem(nRow,'itdsc',sNull)
			SetItem(nRow,'itnbr',sNull)
			Return
		END IF
		
		SELECT "ITEMAS"."ITTYP", "ITEMAS"."ITCLS", "ITEMAS"."ITDSC",
				 "ITEMAS"."ISPEC","ITNCT"."TITNM", "ITNCT"."PDTGU"
		  INTO :sIttyp, :sItcls, :sItdsc, :sIspec ,:sItemClsName,:sPdtgu
		  FROM "ITEMAS","ITNCT"
		 WHERE "ITEMAS"."ITTYP" = "ITNCT"."ITTYP" AND
				 "ITEMAS"."ITCLS" = "ITNCT"."ITCLS" AND
				 "ITEMAS"."ITNBR" = :sItnbr ;
		
		IF SQLCA.SQLCODE <> 0 THEN
			PostEvent(RbuttonDown!)
			Return 2
		END IF
		
		SetItem(nRow,"itdsc", sItdsc)
		
		// 표준공정의 검사구분이 자주검사 인 자료 중 최종공정
		SELECT A.WKCTR 
		INTO    :ls_wkctr
		FROM ROUTNG A
		WHERE A.ITNBR = :sItnbr
		AND A.QCGUB = '1' 
		AND A.OPSEQ =  (SELECT MAX(OPSEQ) FROM ROUTNG WHERE ITNBR = A.ITNBR)
		GROUP BY A.WKCTR;
				
		SetItem(nRow,"wkctr", ls_wkctr)
elseif this.GetColumnName( ) = 'itdsc' then
	sItdsc = trim(GetText())	
		IF sItdsc ="" OR IsNull(sItdsc) THEN
			SetItem(nRow,'itnbr',sNull)
			SetItem(nRow,'itdsc',sNull)
			Return
		END IF
		
		/* 품명으로 품번찾기 */
		f_get_name4('품명', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)
		If IsNull(sItnbr ) Then
			Return 1
		ElseIf sItnbr <> '' Then
			SetItem(nRow,"itnbr",sItnbr)
			SetColumn("itnbr")
			SetFocus()
			TriggerEvent(ItemChanged!)
			Return 1
		ELSE
			SetItem(nRow,'itnbr',sNull)
			SetItem(nRow,'itdsc',sNull)
			SetColumn("itdsc")
			Return 1
		End If	
elseif this.GetColumnName( ) = 'autoyn' then
	sText	=	this.gettext( )
	
	if sText = 'Y' then
		nTimer = Long(This.GetItemString(row, 'stimer'))
		timer(nTimer)
//		timer(5)
		is_timer = nTimer
            ii_curtime =  0
		st_2.text = '자동 : '+This.GetItemString(row, 'stimer')+' 초'			
	else
		st_2.text = '수동'
		is_timer = 0
            ii_curtime =  0
//		timer(5)
		timer(0)
	end if
	
elseif this.GetColumnName( ) = 'stimer' then
	sText	=	this.gettext( )
	nTimer = Long(sText)
	timer(nTimer)
//	timer(5)
	is_timer = nTimer
	ii_curtime =  0
		
	st_2.text = '자동 : '+sText+' 초'
			
elseif this.GetColumnName( ) = 'todayck' then
	sText	=	this.gettext( )
	
	String ls_befday
	
	SELECT TO_CHAR(SYSDATE - 1,'YYYYMMDD'), TO_CHAR(SYSDATE,'YYYYMMDD')
	INTO    :ls_befday, :is_today
	FROM   DUAL;
	
	if sText = 'Y' then
		
		setitem(1, 'sidat1', is_today)
		setitem(1, 'sidat2', is_today)

	else
		
		setitem(1, 'sidat1', ls_befday)
		setitem(1, 'sidat2', '29991231')

	end if
	
end if



end event

event dw_ip::rbuttondown;if row < 1 then
	return
end if
string sItdsc

if this.GetColumnName( ) = 'empno' or  this.GetColumnName( ) = 'empname' then
	open(w_sawon_popup)
	
	if gs_code = '' or isnull(gs_code) then
		return
	end if
	
	this.setitem(1, 'empno', gs_code)
	this.setitem(1, 'empname', gs_codename)	
elseif this.GetColumnName( ) = 'itnbr' or  this.GetColumnName( ) = 'itdsc' then
	gs_code	=	'1'			/*품목구분*/
	open(w_itemas_popup)
	
	if gs_code = '' or isnull(gs_code) then
		return
	end if
	
	SELECT	FUN_GET_ITDSC(:gs_code)
	  INTO	:sItdsc
	  FROM	DUAL;
	
	this.setitem(1, 'itnbr', gs_code)
	this.setitem(1, 'itdsc', sitdsc)	
end if

SetNull(gs_code)
SetNull(gs_codename)

end event

event dw_ip::buttonclicked;call super::buttonclicked;wf_retrieve()
end event

type dw_list from w_standard_print`dw_list within w_tht_4553p
integer x = 50
integer y = 532
integer width = 5024
integer height = 2396
string dataobject = "d_tht_4553p_l"
boolean vscrollbar = false
boolean border = false
boolean livescroll = false
end type

event dw_list::clicked;//if row < 1 then
//	return
//end if
//
//this.SetRedraw(false)
//this.SelectRow(0, false)
//this.SelectRow(row, true)
//this.SetRow(row)
//this.SetRedraw(true)
end event

event dw_list::rowfocuschanged;//
end event

event dw_list::retrieveend;call super::retrieveend;
	String ls_befday
	
	SELECT TO_CHAR(SYSDATE - 1,'YYYYMMDD'), TO_CHAR(SYSDATE,'YYYYMMDD')
	INTO    :ls_befday, :is_today
	FROM   DUAL;
	
	if dw_ip.GetItemString(1, 'todayck') = 'Y' then
		
		dw_ip.setitem(1, 'sidat1', is_today)
		dw_ip.setitem(1, 'sidat2', is_today)

	end if
end event

type st_1 from statictext within w_tht_4553p
integer x = 50
integer y = 40
integer width = 5024
integer height = 452
boolean bringtotop = true
integer textsize = -72
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = roman!
string facename = "-윤고딕360"
long textcolor = 16777215
long backcolor = 0
string text = "초중종물 관리"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_ymd from datawindow within w_tht_4553p
integer x = 50
integer y = 336
integer width = 1440
integer height = 168
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_todate_pop"
boolean border = false
boolean livescroll = true
end type

type dw_time from datawindow within w_tht_4553p
integer x = 4311
integer y = 336
integer width = 777
integer height = 168
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_totime_pop"
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_tht_4553p
long linecolor = 28144969
integer linethickness = 1
integer x = 37
integer y = 524
integer width = 5065
integer height = 2420
integer cornerheight = 40
integer cornerwidth = 55
end type

type st_2 from statictext within w_tht_4553p
integer x = 4590
integer y = 20
integer width = 453
integer height = 56
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string pointer = "HyperLink!"
long textcolor = 16777215
long backcolor = 0
string text = "단위 : 5 초"
alignment alignment = right!
boolean focusrectangle = false
end type

event clicked;dw_ip.Visible = True
end event

type uo_message from u_message_board within w_tht_4553p
integer x = 32
integer y = 2960
integer width = 5074
integer height = 252
integer taborder = 20
boolean bringtotop = true
end type

on uo_message.destroy
call u_message_board::destroy
end on

