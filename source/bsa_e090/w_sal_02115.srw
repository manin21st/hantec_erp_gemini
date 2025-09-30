$PBExportHeader$w_sal_02115.srw
$PBExportComments$ 거래처 제품단가 등록(VNDDAN)- 관리품번
forward
global type w_sal_02115 from w_inherite
end type
type rr_1 from roundrectangle within w_sal_02115
end type
type gb_3 from groupbox within w_sal_02115
end type
type dw_1 from datawindow within w_sal_02115
end type
type dw_list from u_d_popup_sort within w_sal_02115
end type
type pb_1 from u_pb_cal within w_sal_02115
end type
type rr_2 from roundrectangle within w_sal_02115
end type
type rr_3 from roundrectangle within w_sal_02115
end type
end forward

global type w_sal_02115 from w_inherite
string title = " 거래처 제품단가 등록(관리품번)"
rr_1 rr_1
gb_3 gb_3
dw_1 dw_1
dw_list dw_list
pb_1 pb_1
rr_2 rr_2
rr_3 rr_3
end type
global w_sal_02115 w_sal_02115

type variables

string is_itnbr


end variables

forward prototypes
public function integer wf_chk ()
public function integer wf_init ()
end prototypes

public function integer wf_chk ();String  sSdate, sEdate, sCurren, sNull
Long   ix
Decimal {3} dPrice

SetNull(sNull)

////필수입력 항목 체크/////////////////////////////////////////////////
For ix = 1 To dw_insert.RowCount()

	sSdate	= Trim(dw_insert.GetItemString(ix,'start_date'))
	sEdate	= Trim(dw_insert.GetItemString(ix,'end_date'))
	sCurren	= Trim(dw_insert.GetItemString(ix,'curr'))
	dPrice		= dw_insert.GetItemDecimal(ix,'sales_price')



	If 	IsNull(sCurren) or sCurren = "" then
		f_message_chk(40,'[통화코드]')
		dw_insert.ScrollToRow(ix)
		dw_insert.SetColumn('curren')
		dw_insert.SetFocus()
		Return -1
	End If
	
	If 	f_datechk(sSdate) <> 1 Then
		f_message_chk(40,'[시작일자]')
		dw_insert.ScrollToRow(ix)
		dw_insert.SetColumn('sdate')
		dw_insert.SetFocus()
		Return -1
	End If

	If 	Not(isnull(sEdate))  Then
		If 	f_datechk(sEdate) <> 1  Then
			f_message_chk(40,'[종료일자]')
			dw_insert.ScrollToRow(ix)
			dw_insert.SetColumn('edate')
			dw_insert.SetFocus()
			Return -1
		ElseIf	sSdate > sEdate Then
			f_message_chk(200,'[시작일자]')
			dw_insert.ScrollToRow(ix)
			dw_insert.SetColumn('sdate')
			dw_insert.SetFocus()
			Return -1
		End If
	End If
	
Next
//--------------------------------------------------------------------//



Return 1

end function

public function integer wf_init ();
dw_insert.reset()
dw_list.reset()

// 부가세 사업장 설정
f_mod_saupj(dw_1, 'saupj')

dw_1.SetItem(1,"sdatef", f_today())

dw_1.SetFocus()
dw_1.SetColumn("custcode")

p_addrow.enabled 	= false
p_delrow.enabled 	= false

p_addrow.PictureName  	= "C:\erpman\image\행추가_d.gif"
p_delrow.PictureName  	= "C:\erpman\image\행삭제_d.gif"

return 1
end function

on w_sal_02115.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.gb_3=create gb_3
this.dw_1=create dw_1
this.dw_list=create dw_list
this.pb_1=create pb_1
this.rr_2=create rr_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.gb_3
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.dw_list
this.Control[iCurrent+5]=this.pb_1
this.Control[iCurrent+6]=this.rr_2
this.Control[iCurrent+7]=this.rr_3
end on

on w_sal_02115.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.gb_3)
destroy(this.dw_1)
destroy(this.dw_list)
destroy(this.pb_1)
destroy(this.rr_2)
destroy(this.rr_3)
end on

event open;call super::open;PostEvent("ue_open")
end event

event ue_open;call super::ue_open;dw_insert.settransobject(sqlca)
dw_list.settransobject(sqlca)
dw_1.settransobject(sqlca)

dw_1.InsertRow(0)
p_can.TriggerEvent(Clicked!)
end event

type dw_insert from w_inherite`dw_insert within w_sal_02115
integer x = 2862
integer y = 484
integer width = 1751
integer height = 1828
integer taborder = 10
string dataobject = "d_sal_02115_02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemchanged;String sarea, steam, sCvcod, scvnas, sSaupj, sName1
String sNull, sTodate, sFrdate, sName, sGet_name, steamcd
String sItdsc, sIspec, sJijil, sIspeccode
long   lcount, l_data, inull,nRtn, ireturn
string sitnbr,scurr,spricegbn
double dc_rate

SetNull(snull)
setnull(inull)
SetNull(gs_code)
SetNull(gs_codename)

Choose Case GetColumnName() 
	/* 거래처 */
	Case "cvcod"
		sCvcod = Trim(GetText())
		IF 	sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"cvnas2",snull)
			Return
		END IF

		If 	f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, "cvcod", sNull)
			SetItem(1, "cvnas2", snull)
			Return 1
		ELSE
			SetItem(1,"cvnas2",	scvnas)
		END IF
	/* 품번 */
	Case "itnbr"
		sItnbr = trim(GetText())
	
		ireturn = f_get_name4_sale('품번', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		setitem(1, "itnbr", sitnbr)	
		setitem(1, "itdsc", sitdsc)	
		setitem(1, "ispec", sispec)
		setitem(1, "ispec_code", sispeccode)
		setitem(1, "jijil", sjijil)
		RETURN ireturn
	/* 품명 */
	Case "itdsc"
		sItdsc = trim(GetText())
	
		ireturn = f_get_name4_sale('품명', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		setitem(1, "itnbr", sitnbr)	
		setitem(1, "itdsc", sitdsc)	
		setitem(1, "ispec", sispec)
		setitem(1, "ispec_code", sispeccode)
		setitem(1, "jijil", sjijil)
		RETURN ireturn
	/* 규격 */
	Case "ispec"
		sIspec = trim(GetText())
	
		ireturn = f_get_name4_sale('규격', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		setitem(1, "itnbr", sitnbr)	
		setitem(1, "itdsc", sitdsc)	
		setitem(1, "ispec", sispec)
		setitem(1, "ispec_code", sispeccode)
		setitem(1, "jijil", sjijil)
		RETURN ireturn
	/* 재질 */
	Case "jijil"
		sJijil = trim(GetText())
	
		ireturn = f_get_name4_sale('재질', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		setitem(1, "itnbr", sitnbr)	
		setitem(1, "itdsc", sitdsc)	
		setitem(1, "ispec", sispec)
		setitem(1, "ispec_code", sispeccode)
		setitem(1, "jijil", sjijil)
		RETURN ireturn
	/* 규격코드 */
	Case "ispec_code"
		sIspecCode = trim(GetText())
	
		ireturn = f_get_name4_sale('규격코드', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		setitem(1, "itnbr", sitnbr)	
		setitem(1, "itdsc", sitdsc)	
		setitem(1, "ispec", sispec)
		setitem(1, "ispec_code", sispeccode)
		setitem(1, "jijil", sjijil)
		RETURN ireturn
	Case "start_date"
		IF 	f_datechk(trim(gettext())) = -1	then
      		f_message_chk(35,'[적용시작일]')
			setitem(1, "start_date", sNull)
		return 1
		END IF
	Case "end_date"
		stodate = trim(gettext())
		IF 	f_datechk(stodate) = -1	then
			f_message_chk(35,'[적용마감일]')
			setitem(1, "end_date", sNull)
			return 1
		END IF
	
   		sfrdate = dw_insert.GetItemString(1,"start_date")
   		If 	sfrdate > stodate then
	   		f_message_chk(200,'[마감일자]')
	   		return 1
   		End if
 	Case 'sales_price'
		sitnbr  = Trim(GetItemString(1,'itnbr'))
		sToDate = Trim(GetItemString(1,'start_date'))
		sCurr   = Trim(GetItemString(1,'curr'))
//		steamcd = Trim(GetItemString(1,'steamcd'))
		If 	Left(steamcd,1) = '0' Then
 	   		sPricegbn = '1'        // 원화
		Else
			sPricegbn = '2'        // 외화
		End If
	 	/* 할인율이 마이너스이면 0 */
   		nRtn = sqlca.fun_erp100000014(sitnbr, '.' ,Double(GetText()),sToDate,sCurr,sPricegbn,dc_rate) //할인율
		If 	nRtn = 0 And dc_rate > 0 Then
			setitem(1,"dc_rate",dc_rate)
		Else
			setitem(1,"dc_rate",0)
		End If
end Choose

ib_any_typing = false

end event

event dw_insert::itemerror;return 1
end event

event dw_insert::ue_key;call super::ue_key;str_itnct str_sitnct
string snull

setnull(gs_code)
setnull(snull)

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	IF This.GetColumnName() = "itnbr" Then
		open(w_itemas_popup2)
		if isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(1,"itnbr",gs_code)
//		cb_inq.TriggerEvent(Clicked!)
		RETURN 1
	End if	
END IF		
end event

event dw_insert::updatestart;call super::updatestart;Long ix

For ix = 1 To This.RowCount()
	Choose Case GetItemStatus(ix,0,Primary!)
		Case NewModified!
			This.SetItem(ix,'crt_user',gs_userid)
		Case DataModified!
			This.SetItem(ix,'upd_user',gs_userid)
	End Choose
Next
end event

type p_delrow from w_inherite`p_delrow within w_sal_02115
integer x = 4133
integer y = 308
string picturename = "C:\erpman\image\행삭제_d.gif"
end type

event p_delrow::clicked;call super::clicked;
dw_insert.AcceptText()

IF 	dw_insert.GetRow() <=0 THEN
	f_message_chk(36,'')
	Return
END IF

dw_insert.DeleteRow(0)

dw_insert.ScrollToRow(dw_insert.RowCount())
dw_insert.Setfocus()

end event

type p_addrow from w_inherite`p_addrow within w_sal_02115
integer x = 3835
integer y = 308
string picturename = "C:\erpman\image\행추가_d.gif"
end type

event p_addrow::clicked;call super::clicked;Int    	il_currow,il_RowCount
string	ls_cvcod

IF 	dw_insert.RowCount() <=0 THEN
	il_currow = 0
	il_rowCount = 0
ELSE
	il_currow 		= dw_insert.GetRow()
	il_RowCount 	= dw_insert.RowCount()
	
	IF 	il_currow <=0 THEN
		il_currow = il_rowCount
	END IF
END IF

il_currow 	= il_rowCount + 1

ls_cvcod	= dw_1.GetItemString(1,"custcode")
dw_insert.InsertRow(il_currow)
dw_insert.SetItem(il_currow, "itnbr", is_itnbr)
dw_insert.SetItem(il_currow, "cvcod", ls_cvcod)

dw_insert.SetFocus()

//dw_insert.Modify("DataWindow.HorizontalScrollPosition = '0'")

end event

type p_search from w_inherite`p_search within w_sal_02115
integer x = 1701
integer y = 2560
end type

type p_ins from w_inherite`p_ins within w_sal_02115
integer x = 2222
integer y = 2560
end type

type p_exit from w_inherite`p_exit within w_sal_02115
integer x = 4439
integer y = 28
end type

type p_can from w_inherite`p_can within w_sal_02115
integer x = 4256
integer y = 28
end type

event p_can::clicked;call super::clicked;string scvcod,scvnas
int nRow

nRow = dw_insert.GetRow()
If nRow > 0 Then 
   scvcod = Trim(dw_insert.GetItemString(nRow,'cvcod'))
   scvnas = Trim(dw_insert.GetItemString(nRow,'cvnas2'))
Else
	SetNull(scvcod)
End If

dw_list.setredraw(false)	 

wf_init()

dw_list.setredraw(true)


end event

type p_print from w_inherite`p_print within w_sal_02115
integer x = 1874
integer y = 2560
end type

type p_inq from w_inherite`p_inq within w_sal_02115
integer x = 3890
integer y = 28
end type

event p_inq::clicked;call super::clicked;string  s_custcd,s_ittyp, s_itcls, ls_saupj
Long	LRow , ix

If 	dw_1.AcceptText() 		= -1 Then Return

s_custcd  	= dw_1.getitemstring(1, "custcode")
ls_saupj  		= dw_1.getitemstring(1, "saupj")

////필수입력항목을 입력하지 않고 [조회]를 click한 경우///////////////////
if 	s_custcd = "" or isnull(s_custcd) then 
	f_message_chk(30,'[거래처]')
	dw_1.setcolumn("custcode")
	dw_1.setfocus()
   	return 
end if	


////////////////////////////////////////////////////////////////////////////////
dw_insert.setredraw(false)	 // 화면이 껌벅거리는 것을 막기 위해... (false ~ true)

if 	dw_list.retrieve(gs_sabu, ls_saupj, s_custcd) <= 0 then
  	f_message_chk(50,'[거래처 단가 등록]')
	dw_1.setfocus()
	dw_1.SetRow(1)
	dw_1.setcolumn("custcode")
   	dw_insert.setredraw(true)	
	return
end if


//lRow 	=	dw_list.rowcount()
//
//For 	ix = 1 to lRow
//	if 	dw_list.GetItemNumber(ix, "ddanga") > 0	then
//		dw_list.object.itmbuy_bunbr.background.color = RGB(0,255,255)
//		dw_list.object.itmbuy_budsc.background.color = RGB(0,255,255)
//		dw_list.object.itmbuy_buspc.background.color = RGB(0,255,255)
//		dw_list.object.itmbuy_bujil.background.color = RGB(0,255,255)
//		dw_list.object.itnbr.background.color = RGB(0,255,255)
//	ELSE
//		dw_list.object.itmbuy_bunbr.background.color = RGB(255,255,255)
//		dw_list.object.itmbuy_budsc.background.color = RGB(255,255,255)
//		dw_list.object.itmbuy_buspc.background.color = RGB(255,255,255)
//		dw_list.object.itmbuy_bujil.background.color = RGB(255,255,255)
//		dw_list.object.itnbr.background.color = RGB(255,255,255)
//	End if
//Next

dw_List.TriggerEvent(Clicked!)
dw_insert.setredraw(true)	

ib_any_typing = false
end event

type p_del from w_inherite`p_del within w_sal_02115
boolean visible = false
integer x = 2542
integer y = 2536
boolean enabled = false
end type

event p_del::clicked;call super::clicked;long l_row

dw_insert.accepttext()

l_row = dw_insert.getrow()

IF l_row <=0 THEN
	messagebox("확 인","삭제할 행이 없습니다. ~n~n삭제할 행을 선택하고 [삭제]하세요!!")
	Return
END IF

/////////////////////////////////////////////////////////////////////////////////////////////
if messagebox("삭 제","삭제하시겠습니까?", question!, yesno!, 2) = 2 then
	return
else
	dw_insert.deleterow(l_row)
	
	if dw_insert.update() = 1 then
		commit ;
		sle_msg.text = "자료가 삭제되었습니다!!"
	else 
		rollback;
	end if		
end if

cb_can.TriggerEvent(Clicked!)
end event

type p_mod from w_inherite`p_mod within w_sal_02115
integer x = 4073
integer y = 28
end type

event p_mod::clicked;call super::clicked;string s_itnbr, s_itdsc, s_ispec, s_cvcod, snull,sfrdate, stodate, sCurr
Long   l_row, ll_row, inull,nRow
Double dSalesPrc,dDcRate

setnull(snull)
setnull(inull)

IF dw_insert.Accepttext() = -1 THEN 	RETURN

/// ====================================   [ Detail 자료 확인 ]
IF 	wf_chk() = -1 	THEN	RETURN  -1
// --------------------------------------

//--- Detail 사항 저장.
if dw_insert.update() = 1 then
	w_mdi_frame.sle_msg.text = "자료가 저장되었습니다!!"
	ib_any_typing= FALSE
	commit ;
else
	rollback ;
	messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
	return 
end if	


cb_inq.TriggerEvent(Clicked!)

dw_insert.setredraw(false)	 

//dw_insert.reset()
//nRow = dw_insert.insertrow(0)
//dw_insert.SetItem(nRow, "start_date", f_today())


dw_insert.setredraw(true)

dw_insert.SetFocus()
dw_insert.SetRow(nRow)
dw_insert.SetColumn("cvcod")

sle_msg.text = "저장하였습니다!!"

dw_insert.Modify("DataWindow.HorizontalScrollPosition = '0'")

p_inq.triggerevent(Clicked!)

end event

type cb_exit from w_inherite`cb_exit within w_sal_02115
end type

type cb_mod from w_inherite`cb_mod within w_sal_02115
end type

type cb_ins from w_inherite`cb_ins within w_sal_02115
integer x = 78
integer y = 2436
end type

type cb_del from w_inherite`cb_del within w_sal_02115
end type

type cb_inq from w_inherite`cb_inq within w_sal_02115
end type

type cb_print from w_inherite`cb_print within w_sal_02115
integer x = 416
integer y = 2436
end type

type st_1 from w_inherite`st_1 within w_sal_02115
end type

type cb_can from w_inherite`cb_can within w_sal_02115
end type

type cb_search from w_inherite`cb_search within w_sal_02115
integer x = 754
integer y = 2436
end type







type gb_button1 from w_inherite`gb_button1 within w_sal_02115
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_02115
end type

type rr_1 from roundrectangle within w_sal_02115
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2789
integer y = 256
integer width = 1833
integer height = 2076
integer cornerheight = 40
integer cornerwidth = 55
end type

type gb_3 from groupbox within w_sal_02115
integer x = 2080
integer y = 2772
integer width = 1536
integer height = 208
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type dw_1 from datawindow within w_sal_02115
event ue_key pbm_dwnkey
event ue_enter pbm_dwnprocessenter
integer x = 32
integer y = 92
integer width = 3141
integer height = 144
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_sal_02115_01"
boolean border = false
boolean livescroll = true
end type

event ue_key;
IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF		

end event

event ue_enter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;string 		sitnbr, sitdsc, sispec, sDate, sNull
Integer   	ireturn

if 	this.accepttext() = -1 then return 

SetNull(sNull)

Choose Case  GetColumnName() 
	Case "custcode"
		sItnbr = this.GetText()
		ireturn = f_get_name2('V1', 'Y', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
		
		this.setitem(1, "custcode", sitnbr)	
		this.setitem(1, "custname", sitdsc)
		return ireturn
	Case "sdatet"
		sDate 	= Trim(this.gettext())
		IF 	f_datechk(sDate) = -1	then
			f_message_chk(35, '[기준적용일자]')
			this.setitem(1, "sdatef", sNull)
			return 1
		END IF
End Choose

end event

event itemerror;RETURN 1
end event

event rbuttondown;
setnull(gs_code)
setnull(gs_gubun)
setnull(gs_codename)

Choose Case this.GetColumnName() 
/* 거래처 */
 Case 	"custcode"
	gs_gubun = '1'
	Open(w_vndmst_popup)
	
	IF 	gs_code ="" OR IsNull(gs_code) THEN RETURN
	
	this.SetItem(1,"custcode",gs_code)
	this.TriggerEvent(ItemChanged!)

END Choose
 
end event

type dw_list from u_d_popup_sort within w_sal_02115
integer x = 59
integer y = 272
integer width = 2505
integer height = 2012
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_sal_02115_03"
boolean vscrollbar = true
boolean border = false
end type

event clicked;call super::clicked;String    ls_cvcod	
Integer  nRow, lRow

if	this.accepttext() = -1 THEN RETURN 

nRow = this.getRow()


if 	Row <= 0 	then REturn



///-----------------------------------------<>----------------------------------
is_itnbr 	= dw_list.getitemstring(Row, "itnbr")
ls_cvcod 	= dw_1.getitemstring(1, "custcode")
dw_insert.retrieve(ls_cvcod, is_itnbr)
p_addrow.PictureName  	= "C:\erpman\image\행추가_up.gif"
p_delrow.PictureName  	= "C:\erpman\image\행삭제_up.gif"
p_addrow.enabled 	= true
p_delrow.enabled 	= true



selectrow(0, False)
selectrow(row, True)	


CALL SUPER ::CLICKED 

end event

event rowfocuschanged;call super::rowfocuschanged;//Long Lrow
//
//
//Lrow = currentrow
//if 	Lrow > 0 then
//	selectrow(0, False)
//	selectrow(Lrow, True)	
//end if
end event

type pb_1 from u_pb_cal within w_sal_02115
integer x = 3026
integer y = 116
integer width = 78
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_1.SetColumn('sdatef')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_1.SetItem(1, 'sdatef', gs_code)

end event

type rr_2 from roundrectangle within w_sal_02115
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 256
integer width = 2601
integer height = 2076
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_sal_02115
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 3799
integer y = 296
integer width = 539
integer height = 168
integer cornerheight = 40
integer cornerwidth = 55
end type

