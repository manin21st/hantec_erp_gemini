$PBExportHeader$w_mas_p_010_02.srw
$PBExportComments$제품 가격 등록
forward
global type w_mas_p_010_02 from w_inherite
end type
type rr_1 from roundrectangle within w_mas_p_010_02
end type
type rr_2 from roundrectangle within w_mas_p_010_02
end type
type dw_1 from datawindow within w_mas_p_010_02
end type
type rr_3 from roundrectangle within w_mas_p_010_02
end type
type dw_list from u_key_enter within w_mas_p_010_02
end type
type p_6 from picture within w_mas_p_010_02
end type
type dw_search from datawindow within w_mas_p_010_02
end type
end forward

global type w_mas_p_010_02 from w_inherite
integer height = 2712
string title = "제품 가격 등록"
rr_1 rr_1
rr_2 rr_2
dw_1 dw_1
rr_3 rr_3
dw_list dw_list
p_6 p_6
dw_search dw_search
end type
global w_mas_p_010_02 w_mas_p_010_02

type variables
str_itnct str_sitnct
string is_itnbr
end variables

forward prototypes
public subroutine wf_all_retrieve (string s_code)
public function integer wf_chk ()
end prototypes

public subroutine wf_all_retrieve (string s_code);
end subroutine

public function integer wf_chk ();String  sSdate, sEdate, sPspec, sCurren, sNull
Long   ix
Int  	lReturnRow
Decimal {3} dPrice, dPackamt

SetNull(sNull)

If 	dw_list.AcceptText() <> 1 Then Return -1

dw_list.AcceptText()

dw_list.SetFocus()

For ix = 1 To dw_list.RowCount()
	sSdate	= Trim(dw_list.GetItemString(ix,'sdate'))
	sEdate	= Trim(dw_list.GetItemString(ix,'edate'))
	sPspec	= Trim(dw_list.GetItemString(ix,'pspec'))
	sCurren	= Trim(dw_list.GetItemString(ix,'curren'))
	dPrice		= dw_list.GetItemDecimal(ix,'price')
	dPackamt	= dw_list.GetItemDecimal(ix,'packamt')

	If 	IsNull(sPspec) or sPspec = "" then
		f_message_chk(40,'[사 양]')
		dw_list.ScrollToRow(ix)
		dw_list.SetColumn('pspec')
		dw_list.SetFocus()
		Return -1
	End If

	If 	IsNull(sCurren) or sCurren = "" then
		f_message_chk(40,'[통화코드]')
		dw_list.ScrollToRow(ix)
		dw_list.SetColumn('curren')
		dw_list.SetFocus()
		Return -1
	End If
	
	If 	f_datechk(sSdate) <> 1 Then
		f_message_chk(40,'[시작일자]')
		dw_list.ScrollToRow(ix)
		dw_list.SetColumn('sdate')
		dw_list.SetFocus()
		Return -1
	End If

	If 	Not(isnull(sEdate))  Then
		If 	f_datechk(sEdate) <> 1  Then
			f_message_chk(40,'[종료일자]')
			dw_list.ScrollToRow(ix)
			dw_list.SetColumn('edate')
			dw_list.SetFocus()
			Return -1
		ElseIf	sSdate > sEdate Then
			f_message_chk(200,'[시작일자]')
			dw_list.ScrollToRow(ix)
			dw_list.SetColumn('sdate')
			dw_list.SetFocus()
			Return -1
		End If
	End If
	
	lReturnRow = dw_list.Find("pspec = '"+ spspec +"' ", 1, ix)
		IF (ix <> lReturnRow) and (lReturnRow <> 0)		THEN
			sEdate	= Trim(dw_list.GetItemString(lReturnRow,'edate'))
			If 	f_datechk(sEdate) <> 1  Then
				f_message_chk(40,'[종료일자]')
				dw_list.ScrollToRow(lReturnRow)
				dw_list.SetColumn('edate')
				dw_list.SetFocus()
				Return -1
			ElseIf	sSdate < sEdate Then
				MessageBox("확인", "동일사양의 종료일자와 시작일자를 확인하여 주시기 바랍니다.!!!")
				dw_list.ScrollToRow(ix)
				dw_list.SetColumn('sdate')
				dw_list.SetFocus()
				Return -1
			End If
		END IF
	if 	dPrice <= dPackamt then 
		MessageBox("확인", "포장비가 단가보다 큰 금액 처리는 불가 !!!")
		dw_list.ScrollToRow(ix)
		dw_list.SetColumn('packamt')
		dw_list.SetFocus()
		Return -1
	End If
Next

//--------------------------------------------------------------------//



Return 1

end function

on w_mas_p_010_02.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.rr_2=create rr_2
this.dw_1=create dw_1
this.rr_3=create rr_3
this.dw_list=create dw_list
this.p_6=create p_6
this.dw_search=create dw_search
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.rr_2
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.rr_3
this.Control[iCurrent+5]=this.dw_list
this.Control[iCurrent+6]=this.p_6
this.Control[iCurrent+7]=this.dw_search
end on

on w_mas_p_010_02.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.dw_1)
destroy(this.rr_3)
destroy(this.dw_list)
destroy(this.p_6)
destroy(this.dw_search)
end on

event open;call super::open;PostEvent("ue_open")
end event

event ue_open;call super::ue_open;string s_date

dw_1.settransobject(sqlca)
dw_insert.settransobject(sqlca)
dw_list.settransobject(sqlca)
dw_insert.Reset()
dw_search.Reset()

dw_1.insertrow(0)
dw_1.setcolumn("salegb")
dw_1.setfocus()
dw_search.insertRow(0)

ib_any_typing = false


// 부가세 사업장 설정
f_mod_saupj(dw_1, 'saupj')

end event

type dw_insert from w_inherite`dw_insert within w_mas_p_010_02
integer x = 41
integer y = 392
integer width = 4521
integer height = 2044
integer taborder = 20
string dataobject = "d_mas_p_010_02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::clicked;

////선택한 행 반전//////////////////////////////////////////////////////////
If 	Row <= 0 then
	dw_1.SelectRow(0,False)
	dw_1.setfocus()
	return
ELSE
	this.SelectRow(0, FALSE)
	this.SelectRow(Row,TRUE)
	this.ScrollToRow(Row)
END IF

SetPointer(HourGlass!)

this.SetRedraw(FALSE)

SetNull(is_itnbr)

is_itnbr = dw_insert.GetItemString(Row,"itnbr")
	
// 품번 세부 사양별 단가 현황.
if 	dw_list.Retrieve(is_itnbr,'9999', '.', '2')  <= 0 then
	ib_any_typing 	= FALSE	
	p_addrow.Enabled =True
	p_addrow.PictureName =  'C:\erpman\image\행추가_up.gif'
	p_delrow.enabled = true
	p_delrow.PictureName = 'C:\erpman\image\행삭제_up.gif'
else
	dw_list.SetTaborder('pspec',0)
end if

this.SetRedraw(true)

end event

event dw_insert::itemerror;Return 1
end event

event dw_insert::rowfocuschanged;//if currentrow < 1 then return 
//if this.rowcount() < 1 then return 
//
//this.setredraw(false)
//
//this.SelectRow(0,False)
//this.SelectRow(currentrow,True)
//
//this.ScrollToRow(currentrow)
//
//is_itnbr = dw_insert.GetItemString(currentrow,"itnbr")
//dw_list.Retrieve(is_itnbr,'9999', '.', '2')
//
//this.setredraw(true)

	
end event

type p_delrow from w_inherite`p_delrow within w_mas_p_010_02
boolean visible = false
integer x = 4347
integer y = 440
boolean enabled = false
string picturename = "C:\erpman\image\행삭제_d.gif"
end type

event p_delrow::clicked;call super::clicked;dw_list.AcceptText()

IF dw_list.GetRow() <=0 THEN
	f_message_chk(36,'')
	Return
END IF

dw_list.DeleteRow(0)

dw_list.ScrollToRow(dw_insert.RowCount())
dw_list.Setfocus()

end event

type p_addrow from w_inherite`p_addrow within w_mas_p_010_02
boolean visible = false
integer x = 4110
integer y = 440
boolean enabled = false
string picturename = "C:\erpman\image\행추가_d.gif"
end type

event p_addrow::clicked;call super::clicked;Int    il_currow,il_RowCount, k

IF 	dw_list.RowCount() <=0 THEN
	il_currow = 0
	il_rowCount = 0
ELSE
	il_currow 		= dw_list.GetRow()
	il_RowCount 	= dw_list.RowCount()
	
	IF 	il_currow <=0 THEN
		il_currow = il_rowCount
	END IF
END IF

il_currow = il_rowCount + 1
dw_list.InsertRow(il_currow)
dw_list.SetItem(il_currow, "itnbr", is_itnbr)
dw_list.SetItem(il_currow, "opseq", '9999')
dw_list.SetItem(il_currow, "cvcod",'.')
dw_list.SetItem(il_currow, "gubun",'2')   // 2 : 품목별 판매단가

dw_list.ScrollToRow(il_currow)
dw_list.SetColumn("pspec")
dw_list.SetFocus()

//dw_list.Modify("DataWindow.HorizontalScrollPosition = '0'")

end event

type p_search from w_inherite`p_search within w_mas_p_010_02
boolean visible = false
integer x = 1029
integer y = 2392
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_mas_p_010_02
boolean visible = false
integer x = 1550
integer y = 2392
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_mas_p_010_02
end type

type p_can from w_inherite`p_can within w_mas_p_010_02
end type

event p_can::clicked;call super::clicked;int row

dw_1.Reset()
row = dw_1.InsertRow(0)
dw_1.SetFocus()
dw_1.SetRow(row)
dw_1.setcolumn("salegb")

dw_insert.Reset()
dw_list.Reset()
ib_any_typing = false

p_addrow.Enabled =False
p_addrow.PictureName =  'C:\erpman\image\행추가_d.gif'
p_delrow.enabled = False
p_delrow.PictureName = 'C:\erpman\image\행삭제_d.gif'


// 부가세 사업장 설정
f_mod_saupj(dw_1, 'saupj')

end event

type p_print from w_inherite`p_print within w_mas_p_010_02
boolean visible = false
integer x = 1202
integer y = 2392
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_mas_p_010_02
integer x = 3922
end type

event p_inq::clicked;call super::clicked;string sPdtgu, s_ittyp, s_itcls, s_useyn ,ls_pangbn, ls_saupj

if dw_1.accepttext() <> 1 then return 

sPdtgu  		= Trim(dw_1.getitemstring(1, "pdtgu"))
s_ittyp 		= Trim(dw_1.getitemstring(1, "ittyp"))
s_itcls 		= Trim(dw_1.getitemstring(1, "itcls"))
s_useyn 		= Trim(dw_1.getitemstring(1, "useyn"))
ls_pangbn 	= dw_1.getitemstring(1,'pangbn')
ls_saupj		= dw_1.getitemstring(1,'saupj')

////품목구분과 품목분류를 입력하지 않고 [조회]를 click한 경우///////////////////////////////////
if 	s_ittyp = "" or isnull(s_ittyp) then 
	f_message_chk(30,'[품목구분]')
	dw_1.setcolumn("ittyp")
	dw_1.setfocus()
   	return 
end if	

If IsNull(s_itcls) Then s_itcls = ''

dw_1.setredraw(false)
dw_insert.setredraw(false)
dw_list.setredraw(false)

/* 전체조회 */
If 	IsNull(sPdtgu) Then sPdtgu = ''
If 	IsNull(s_useyn) or s_useyn = '' or s_useyn = '3' then s_useyn = ''

if 	dw_insert.retrieve(gs_sabu, ls_saupj, sPdtgu+'%',s_ittyp, s_itcls+'%', s_useyn+'%',ls_pangbn) <= 0 then
  	f_message_chk(50,'')
	dw_1.setcolumn("ittyp")
	dw_1.setfocus()
   	dw_1.setredraw(true)	
	dw_insert.setredraw(true)
	dw_list.setredraw(true)
   	return
end if

dw_1.setredraw(true)	
dw_insert.setredraw(true)
dw_list.setredraw(true)	

ib_any_typing = false




end event

type p_del from w_inherite`p_del within w_mas_p_010_02
boolean visible = false
integer x = 2062
integer y = 2400
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_mas_p_010_02
integer x = 4096
end type

event p_mod::clicked;call super::clicked;String  snull

setnull(snull)

if 	dw_1.accepttext() = -1 then return
IF 	dw_insert.Accepttext() = -1 THEN RETURN

////////////////////////////////////////////////////////////////////////////////////////////
if MessageBox("확 인", "저장하시겠습니까?", question!, yesno!) = 2 THEN	RETURN

////필수입력 항목 체크/////////////////////////////////////////////////
IF 	wf_chk() = -1 	THEN	RETURN  -1


IF 	dw_insert.Update() > 0 THEN			
     if 	dw_list.Update() > 0	 then
		COMMIT;
		ib_any_typing =False
		sle_msg.text ="자료를 저장하였습니다!!"
	Else
		ROLLBACK;
		ib_any_typing = True
		Return
	End If
ELSE
	ROLLBACK;
	ib_any_typing = True
	Return
END IF

dw_list.Modify("DataWindow.HorizontalScrollPosition = '0'")
end event

type cb_exit from w_inherite`cb_exit within w_mas_p_010_02
end type

type cb_mod from w_inherite`cb_mod within w_mas_p_010_02
end type

type cb_ins from w_inherite`cb_ins within w_mas_p_010_02
integer x = 46
integer y = 2580
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_mas_p_010_02
integer x = 379
integer y = 2580
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_mas_p_010_02
end type

type cb_print from w_inherite`cb_print within w_mas_p_010_02
integer x = 713
integer y = 2580
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_mas_p_010_02
end type

type cb_can from w_inherite`cb_can within w_mas_p_010_02
end type

type cb_search from w_inherite`cb_search within w_mas_p_010_02
integer x = 1047
integer y = 2580
boolean enabled = false
end type







type gb_button1 from w_inherite`gb_button1 within w_mas_p_010_02
end type

type gb_button2 from w_inherite`gb_button2 within w_mas_p_010_02
end type

type rr_1 from roundrectangle within w_mas_p_010_02
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 380
integer width = 4571
integer height = 2068
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_mas_p_010_02
boolean visible = false
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 3584
integer y = 380
integer width = 1029
integer height = 1944
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_1 from datawindow within w_mas_p_010_02
event ue_keydown pbm_dwnkey
event ue_enter pbm_dwnprocessenter
integer x = 18
integer y = 44
integer width = 2825
integer height = 320
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_mas_p_010_011"
boolean border = false
boolean livescroll = true
end type

event ue_keydown;string sCol

SetNull(gs_code)
SetNull(gs_codename)

IF KeyDown(KeyF2!) THEN
	Choose Case GetColumnName()
	   	Case  'itcls'
		    	open(w_ittyp_popup3) 
		 	str_sitnct = Message.PowerObjectParm
			if IsNull(str_sitnct.s_ittyp) or str_sitnct.s_ittyp = "" then return
		    	this.SetItem(1, "ittyp", str_sitnct.s_ittyp)
		    	this.SetItem(1, "itcls", str_sitnct.s_sumgub)
		    	this.SetItem(1, "itclsnm", str_sitnct.s_titnm)
	END Choose
End if	

end event

event ue_enter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;string itclsnm,s_itcls,s_itnbr, s_itdsc, s_ispec, sItemCls, sItemGbn, sItemClsName
string s_name,s_ittyp,snull,get_nm
int    nRow,rtn

nRow = GetRow()

Choose Case  GetColumnName() 
	Case 'salegb'
		
		dw_insert.SetRedraw(False)
		If 	Trim(data) = '1'  Then // 내수
		   	dw_insert.DataObject = 'd_mas_p_010_02'
	   	Else
		   	dw_insert.DataObject = 'd_mas_p_010_01'
     		End If
		dw_insert.SetTransObject(sqlca)
		dw_insert.SetRedraw(True)		
	/* 품목구분 */
	Case "ittyp"
		SetItem(nRow,'itcls',sNull)
		SetItem(nRow,'itclsnm',sNull)
	/* 품목분류 */
	Case "itcls"
		SetItem(nRow,'itclsnm',sNull)
	
		sItemCls = Trim(GetText())
		IF 	sItemCls = "" OR IsNull(sItemCls) THEN 		RETURN
		
		sItemGbn = '1'
		IF 	sItemGbn <> "" AND Not IsNull(sItemGbn) THEN 
			SELECT "ITNCT"."TITNM"  	INTO :sItemClsName  
			FROM "ITNCT"  
			WHERE ( "ITNCT"."ITTYP" = :sItemGbn ) AND ( "ITNCT"."ITCLS" = :sItemCls )   ;
			
			IF SQLCA.SQLCODE <> 0 THEN
				this.TriggerEvent(RButtonDown!)
				Return 2
			ELSE
				this.SetItem(1,"itclsnm",sItemClsName)
			END IF
		END IF
	/* 품목명 */
	Case "itclsnm"
		SetItem(1,"itcls",snull)
		
		sItemClsName = this.GetText()
		IF sItemClsName = "" OR IsNull(sItemClsName) THEN return
		
		sItemGbn = '1' //this.GetItemString(1,"ittyp")
		IF sItemGbn <> "" AND Not IsNull(sItemGbn) THEN 
			SELECT "ITNCT"."ITCLS"	INTO :sItemCls
			  FROM "ITNCT"  
			 WHERE ( "ITNCT"."ITTYP" = :sItemGbn ) AND ( "ITNCT"."TITNM" = :sItemClsName )   ;
			
			IF SQLCA.SQLCODE <> 0 THEN
				this.TriggerEvent(RButtonDown!)
				Return 2
			ELSE
				this.SetItem(1,"itcls",sItemCls)
			END IF
		END IF
End Choose
end event

event itemerror;return 1
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case GetcolumnName() 
	Case "itcls"
		OpenWithParm(w_ittyp_popup, this.GetItemString(1,"ittyp"))
		
		str_sitnct = Message.PowerObjectParm	
		
		IF str_sitnct.s_ittyp ="" OR IsNull(str_sitnct.s_ittyp) THEN RETURN
		
		this.SetItem(1,"itcls",str_sitnct.s_sumgub)
		this.SetItem(1,"itclsnm", str_sitnct.s_titnm)
		this.SetItem(1,"ittyp",  str_sitnct.s_ittyp)
	Case "itclsnm"
		OpenWithParm(w_ittyp_popup, this.GetItemString(1,"ittyp"))
		str_sitnct = Message.PowerObjectParm
		
		IF str_sitnct.s_ittyp ="" OR IsNull(str_sitnct.s_ittyp) THEN RETURN
		
		this.SetItem(1,"itcls",   str_sitnct.s_sumgub)
		this.SetItem(1,"itclsnm", str_sitnct.s_titnm)
		this.SetItem(1,"ittyp",   str_sitnct.s_ittyp)
END Choose
end event

type rr_3 from roundrectangle within w_mas_p_010_02
boolean visible = false
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 4059
integer y = 416
integer width = 507
integer height = 192
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_list from u_key_enter within w_mas_p_010_02
event ue_key pbm_dwnkey
boolean visible = false
integer x = 3593
integer y = 624
integer width = 1001
integer height = 1684
integer taborder = 30
string dataobject = "d_mas_p_010_03"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event editchanged;call super::editchanged;ib_any_typing =True
end event

event itemerror;call super::itemerror;Return 1
end event

type p_6 from picture within w_mas_p_010_02
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 4443
integer y = 180
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "C:\erpman\cur\point.cur"
string picturename = "C:\erpman\image\검색_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;PictureName = 'C:\erpman\image\검색_dn.gif'
end event

event ue_lbuttonup;PictureName = 'C:\erpman\image\검색_up.gif'
end event

event clicked;long lReturnRow, i
string sitdsc, sgub

if dw_search.accepttext() = -1 then return 

if dw_insert.rowcount() < 1 then return 

sitdsc = trim(dw_search.getitemstring(1, 'itdsc'))

if sitdsc = '' or isnull(sitdsc) then 
	dw_insert.selectrow(1, true)
	dw_insert.scrolltorow(1)
else
	sitdsc = sitdsc + '%'
	
	sgub = dw_search.getitemstring(1, 'gub')
	if sgub = '1' then 
		lReturnRow = dw_insert.Find("itnbr like '"+sitdsc+"' ", 1, dw_insert.RowCount())
	elseif sgub = '2' then 
		lReturnRow = dw_insert.Find("itdsc like '"+sitdsc+"' ", 1, dw_insert.RowCount())
	elseif sgub = '3' then 
		lReturnRow = dw_insert.Find("ispec like '"+sitdsc+"' ", 1, dw_insert.RowCount())
	else
		lReturnRow = dw_insert.Find("jijil like '"+sitdsc+"' ", 1, dw_insert.RowCount())
	end if

	if isnull(lreturnrow) or lreturnrow < 1 then return 
	
	For i = 1 To dw_insert.RowCount()
		dw_insert.selectrow(i, False)
	Next
	
	dw_insert.selectrow(lReturnRow, true)
	dw_insert.scrolltorow(lReturnRow)
end if

end event

type dw_search from datawindow within w_mas_p_010_02
integer x = 2843
integer y = 180
integer width = 1477
integer height = 176
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_mas_p_010_search"
boolean border = false
end type

