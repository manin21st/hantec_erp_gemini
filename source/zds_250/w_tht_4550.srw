$PBExportHeader$w_tht_4550.srw
$PBExportComments$추중종물 기준등록
forward
global type w_tht_4550 from w_inherite
end type
type dw_ret from datawindow within w_tht_4550
end type
type st_2 from statictext within w_tht_4550
end type
type dw_list from datawindow within w_tht_4550
end type
end forward

global type w_tht_4550 from w_inherite
integer width = 4695
integer height = 2452
string title = "중종물 검사기준 등록"
dw_ret dw_ret
st_2 st_2
dw_list dw_list
end type
global w_tht_4550 w_tht_4550

event open;call super::open;This.TriggerEvent('ue_open')
end event

event ue_open;call super::ue_open;dw_ret.SetTransObject(SQLCA)
dw_ret.InsertRow(0)

dw_list.SetTransObject(sqlca)
dw_insert.SetTransObject(SQLCA)

p_inq.TriggerEvent(Clicked!)

end event

on w_tht_4550.create
int iCurrent
call super::create
this.dw_ret=create dw_ret
this.st_2=create st_2
this.dw_list=create dw_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_ret
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.dw_list
end on

on w_tht_4550.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_ret)
destroy(this.st_2)
destroy(this.dw_list)
end on

type dw_insert from w_inherite`dw_insert within w_tht_4550
integer x = 2139
integer y = 280
integer width = 2491
integer height = 1972
string dataobject = "d_tht_4550_e"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event dw_insert::itemchanged;call super::itemchanged;string	sText,  sText2, sGub
int		nReturn

if row < 1 then
	return
end if

if this.GetColumnName( ) = 'gubun' then
	sText	=	this.gettext( )
	
	if sText = '1' then
	
		this.setitem(1, 'spec_min', 0)
		this.setitem(1, 'spec_max', 0)
		
	end if
	
end if
end event

event dw_insert::itemerror;call super::itemerror;return 1
end event

type p_delrow from w_inherite`p_delrow within w_tht_4550
boolean visible = false
integer x = 3753
integer y = 272
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_tht_4550
boolean visible = false
integer x = 3579
integer y = 272
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_tht_4550
boolean visible = false
integer x = 3566
integer y = 428
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_tht_4550
integer x = 3749
end type

event p_ins::clicked;call super::clicked;if dw_list.accepttext( ) = -1 then return

long		nRow, nRow2
string	sItnbr

nRow = dw_list.getrow( )

if nRow < 1 then
	messagebox('품번 선택', '등록할 품번을 선택하세요!')
	return
end if

sItnbr = dw_list.getitemstring(nRow, 'itnbr')

nRow2 = dw_insert.insertrow(0)

dw_insert.setitem(nRow2, 'itnbr', sItnbr)

end event

type p_exit from w_inherite`p_exit within w_tht_4550
end type

type p_can from w_inherite`p_can within w_tht_4550
end type

type p_print from w_inherite`p_print within w_tht_4550
boolean visible = false
integer x = 3739
integer y = 428
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_tht_4550
integer x = 3575
end type

event p_inq::clicked;call super::clicked;string	sSidat1, sSidat2, sPdtgu, sJocod, sWkctr, sItnbr, sRqcgu, sChk, sIttyp

if dw_ret.accepttext( ) = -1 then return -1

sItnbr	=	dw_ret.getitemstring(1, 'itnbr')
sIttyp	    =	dw_ret.getitemstring(1, 'ittyp')

if sItnbr = '' or isnull(sItnbr)	then	sItnbr = '%'
if sIttyp = '' or isnull(sIttyp)	then	sIttyp = '%'

dw_list.retrieve(sItnbr, sIttyp)

dw_insert.SetRedraw(False)
dw_list.retrieve(sItnbr, sIttyp)
dw_insert.SetRedraw(True)
end event

type p_del from w_inherite`p_del within w_tht_4550
end type

event p_del::clicked;call super::clicked;if dw_list.accepttext( ) = -1 then return
if dw_insert.accepttext( ) = -1 then return

long		nRow, nCnt
String    sItnbr, sGucod, sInspdt

nRow = dw_insert.getrow( )

if nRow < 1 then
	messagebox('삭제 선택', '삭제할 자료를 선택하세요!')
	return
end if

sItnbr = dw_insert.GetItemString(nRow, 'itnbr')
sGucod = dw_insert.GetItemString(nRow, 'gucod')

// 체크로직 추가 BY SHJEON 20150825
SELECT COUNT(JPNO), MIN(INSP_DATE)
INTO    :nCnt, :sInspdt
FROM POP_INSPECTION_SELF
WHERE ITNBR = :sItnbr
AND     GUCOD = :sGucod;

IF nCnt > 0 THEN
	MessageBox('오류','최초 검사일자['+sInspdt+'] 부터 검사코드가 사용되어 삭제 할 수 없습니다.')
	return
END IF


DELETE POP_INSPECTION
WHERE ITNBR = :sItnbr
AND     GUCOD = :sGucod;
  
if sqlca.sqlcode <> 0 then 
	rollback ;
	messagebox("삭제실패", "자료에 대한 삭제를 실패하였읍니다")
	return
end if

commit;

dw_insert.deleterow(nRow)
end event

type p_mod from w_inherite`p_mod within w_tht_4550
end type

event p_mod::clicked;call super::clicked;if f_msg_update() = -1 then return

long		nCount,	ii
string	sGucod

if dw_insert.accepttext( ) = -1 then return -1

nCount	=	dw_insert.rowcount()

for ii = 1 to nCount
	sGucod = dw_insert.getitemstring(ii, 'gucod')
	
	if sGucod = '' or isnull(sGucod) then
		messagebox('검사코드 등록','검사코드를 등록하세요!')
		return -1
	end if
next

if dw_insert.update( ) <> 1 then
	rollback;
	messagebox('저장 실패', '저장에 실패하였습니다.')
	return -1
end if

dw_list.SetItem(dw_list.GetRow(), 'chk_count', nCount)

commit;

messagebox('저장 완료', '정상적으로 저장 되었습니다!!')

ib_any_typing = false
end event

type cb_exit from w_inherite`cb_exit within w_tht_4550
end type

type cb_mod from w_inherite`cb_mod within w_tht_4550
end type

type cb_ins from w_inherite`cb_ins within w_tht_4550
end type

type cb_del from w_inherite`cb_del within w_tht_4550
end type

type cb_inq from w_inherite`cb_inq within w_tht_4550
end type

type cb_print from w_inherite`cb_print within w_tht_4550
end type

type st_1 from w_inherite`st_1 within w_tht_4550
end type

type cb_can from w_inherite`cb_can within w_tht_4550
end type

type cb_search from w_inherite`cb_search within w_tht_4550
end type







type gb_button1 from w_inherite`gb_button1 within w_tht_4550
end type

type gb_button2 from w_inherite`gb_button2 within w_tht_4550
end type

type dw_ret from datawindow within w_tht_4550
integer x = 37
integer y = 24
integer width = 2510
integer height = 212
integer taborder = 120
string title = "none"
string dataobject = "d_tht_4550_c"
boolean border = false
boolean livescroll = true
end type

event rbuttondown;if row < 1 then
	return
end if
string sItdsc

if this.GetColumnName( ) = 'itnbr' or  this.GetColumnName( ) = 'itdsc' then
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

event itemchanged;String  sNull,sPdtgu, sIttyp, sItcls, sItnbr, sItdsc, sIspec, sjijil, sispeccode
String  sItemCls, sItemGbn, sItemClsName
Long    nRow

SetNull(snull)

nRow = GetRow()
If nRow <= 0 Then Return

SetPointer(HourGlass!)

Choose Case GetColumnName() 
	/* 품번 */
	Case	"itnbr" 
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
	/* 품명 */
	Case "itdsc"
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
END Choose

//string	sText,  sText2, sGub
//int		nReturn
//
//
//if row < 1 then
//	return
//end if
//
//if this.GetColumnName( ) = 'itnbr' then
//	sText	=	this.gettext( )
//	nReturn	=	f_popup_itnbr('1', sText, sText2)
//	
//	this.setitem(1, 'itnbr', sText)
//	this.setitem(1, 'itdsc', sText2)
//	
//	return nReturn
//	
//	sText = Trim(GetText())
//	
//	IF sItnbr ="" OR IsNull(sItnbr) THEN
//		SetItem(nRow,'itnbr',sNull)
//		SetItem(nRow,'itdsc',sNull)
//		Return
//	END IF
//	
//	SELECT "ITEMAS"."ITTYP", "ITEMAS"."ITCLS", "ITEMAS"."ITDSC",
//			 "ITEMAS"."ISPEC","ITNCT"."TITNM", "ITNCT"."PDTGU"
//	  INTO :sIttyp, :sItcls, :sItdsc, :sIspec ,:sItemClsName,:sPdtgu
//	  FROM "ITEMAS","ITNCT"
//	 WHERE "ITEMAS"."ITTYP" = "ITNCT"."ITTYP" AND
//			 "ITEMAS"."ITCLS" = "ITNCT"."ITCLS" AND
//			 "ITEMAS"."ITNBR" = :sItnbr ;
//	
//	IF SQLCA.SQLCODE <> 0 THEN
//		PostEvent(RbuttonDown!)
//		Return 2
//	END IF
//	
//	SetItem(nRow,"itdsc", sItdsc)
//	
//elseif this.GetColumnName( ) = 'itdsc' then
//	sText2	=	this.gettext( )
//	nReturn	=	f_popup_itnbr('1', sText, sText2)
//	
//	this.setitem(1, 'itnbr', sText)
//	this.setitem(1, 'itdsc', sText2)
//	
//	return nReturn
//end if

end event

event itemerror;return 1
end event

type st_2 from statictext within w_tht_4550
integer x = 59
integer y = 224
integer width = 1577
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 134217739
string text = "※ 표준공정에 자주검사로 등록되어 있는 품번만 표시됩니다."
boolean focusrectangle = false
end type

type dw_list from datawindow within w_tht_4550
integer x = 37
integer y = 280
integer width = 2085
integer height = 1972
integer taborder = 120
boolean bringtotop = true
string title = "none"
string dataobject = "d_tht_4550_l"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;if row < 1 then
	return
end if

this.SetRedraw(false)
this.SelectRow(0, false)
this.SelectRow(row, true)
this.SetRow(row)
this.SetRedraw(true)
end event

event itemerror;return 1
end event

event retrieveend;If rowcount > 0 Then Event RowFocusChanged(1)
end event

event rowfocuschanged;If currentrow < 1 Then
	dw_insert.reset( )
	return
end if

this.SetRedraw(false)
this.SelectRow(0, false)
this.SelectRow(currentrow, true)
this.SetRow(currentrow)
this.SetRedraw(true)


string	sItnbr

sItnbr = this.getitemstring(currentrow, 'itnbr')

dw_insert.retrieve( sItnbr )
end event

