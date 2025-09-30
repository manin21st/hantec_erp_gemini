$PBExportHeader$w_sm20_p020.srw
$PBExportComments$ 거래처 제품단가 등록(VNDDAN)
forward
global type w_sm20_p020 from w_inherite
end type
type gb_3 from groupbox within w_sm20_p020
end type
type dw_list from u_d_popup_sort within w_sm20_p020
end type
type dw_print from datawindow within w_sm20_p020
end type
type p_preview from picture within w_sm20_p020
end type
type p_xls from picture within w_sm20_p020
end type
type rb_1 from radiobutton within w_sm20_p020
end type
type rb_2 from radiobutton within w_sm20_p020
end type
type rr_1 from roundrectangle within w_sm20_p020
end type
end forward

global type w_sm20_p020 from w_inherite
integer width = 4640
integer height = 2536
string title = "거래처 제품단가  조회 및 출력"
gb_3 gb_3
dw_list dw_list
dw_print dw_print
p_preview p_preview
p_xls p_xls
rb_1 rb_1
rb_2 rb_2
rr_1 rr_1
end type
global w_sm20_p020 w_sm20_p020

type variables
str_itnct lstr_sitnct
string is_itnbr
end variables

forward prototypes
public function integer wf_key_protect (string gb)
public subroutine wf_change ()
end prototypes

public function integer wf_key_protect (string gb);Choose Case gb
	Case '조회'
		dw_insert.Modify('cvcod.protect = 1')
		dw_insert.Modify('itnbr.protect = 1')
		dw_insert.Modify('start_date.protect = 1')

	Case '신규'
		
		dw_insert.Modify('cvcod.protect = 0')
		dw_insert.Modify('itnbr.protect = 0')
		dw_insert.Modify('start_date.protect = 0')

End Choose

p_addrow.enabled 	= false
p_delrow.enabled 	= false

p_addrow.PictureName  	= "C:\erpman\image\행추가_d.gif"
p_delrow.PictureName  	= "C:\erpman\image\행삭제_d.gif"

return 1
end function

public subroutine wf_change ();/*
String ls_cvcod , ls_cvnas
String ls_itnbr , ls_itdsc ,ls_ispec ,ls_jijil
Long   ll_r
dw_insert.AcceptText()

ls_cvcod = Trim(dw_insert.GetItemString(1,'cvcod'))
ls_cvnas = Trim(dw_insert.GetItemString(1,'cvnas'))

ls_itnbr = Trim(dw_insert.GetItemString(1,'itnbr'))
ls_itdsc = Trim(dw_insert.GetItemString(1,'itdsc'))
ls_ispec = Trim(dw_insert.GetItemString(1,'ispec'))
ls_jijil = Trim(dw_insert.GetItemString(1,'jijil'))

dw_insert.Reset()
ll_r=	dw_insert.InsertRow(0)
*/
/*	
If rb_1.checked Then
	dw_list.DataObject = "d_sal_02110_02"
	dw_list.SetTransObject(sqlca)

	dw_insert.Object.itnbr_t.y = 28
	dw_insert.Object.itnbr.y = 28
	dw_insert.Object.itdsc.y = 28
	
	dw_insert.Object.t_1.y = 112
	dw_insert.Object.cvcod.y = 112
	dw_insert.Object.cvnas.y = 112
	
	dw_insert.SetColumn("itnbr")
	dw_insert.SetFocus()
	
	dw_insert.SetTabOrder("itnbr",10)
	dw_insert.SetTabOrder("cvcod",30)
	dw_insert.Object.start_date[ll_r] = is_today
	wf_key_protect("신규")
	If isNull(ls_itnbr) = false and len(ls_itnbr) > 0 Then
			
		dw_insert.Object.itnbr[ll_r] = ls_itnbr
		dw_insert.Object.itdsc[ll_r] = ls_itdsc
		dw_insert.Object.ispec[ll_r] = ls_ispec
		dw_insert.Object.jijil[ll_r] = ls_jijil
		
		p_inq.TriggerEvent(Clicked!)
	End IF
Else
	dw_list.DataObject = "d_sal_02110_04"
	dw_list.SetTransObject(sqlca)
	
	dw_insert.Object.itnbr_t.y = 112
	dw_insert.Object.itnbr.y = 112
	dw_insert.Object.itdsc.y = 112
	
	dw_insert.Object.t_1.y = 28
	dw_insert.Object.cvcod.y = 28
	dw_insert.Object.cvnas.y = 28
	
	dw_insert.SetColumn("cvcod")
	dw_insert.SetFocus()
	
	dw_insert.SetTabOrder("cvcod",10)
	dw_insert.SetTabOrder("itnbr",30)
	dw_insert.Object.start_date[ll_r] = is_today
	wf_key_protect("신규")
	If isNull(ls_cvcod) = false and len(ls_cvcod) > 0  Then
			
		dw_insert.Object.cvcod[ll_r] = ls_cvcod
		dw_insert.Object.cvnas[ll_r] = ls_cvnas
		
		p_inq.TriggerEvent(Clicked!)
	End IF
	
End IF
*/

	
end subroutine

on w_sm20_p020.create
int iCurrent
call super::create
this.gb_3=create gb_3
this.dw_list=create dw_list
this.dw_print=create dw_print
this.p_preview=create p_preview
this.p_xls=create p_xls
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_3
this.Control[iCurrent+2]=this.dw_list
this.Control[iCurrent+3]=this.dw_print
this.Control[iCurrent+4]=this.p_preview
this.Control[iCurrent+5]=this.p_xls
this.Control[iCurrent+6]=this.rb_1
this.Control[iCurrent+7]=this.rb_2
this.Control[iCurrent+8]=this.rr_1
end on

on w_sm20_p020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_3)
destroy(this.dw_list)
destroy(this.dw_print)
destroy(this.p_preview)
destroy(this.p_xls)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_insert.settransobject(sqlca)
dw_list.settransobject(sqlca)

p_can.TriggerEvent(Clicked!)
end event

type dw_insert from w_inherite`dw_insert within w_sm20_p020
integer x = 9
integer y = 16
integer width = 3538
integer height = 224
integer taborder = 10
string dataobject = "d_sm20_p020_1"
boolean border = false
end type

event dw_insert::itemchanged;//String sarea, steam, sCvcod, scvnas, sSaupj, sName1
//String sNull, sTodate, sFrdate, sName, sGet_name, steamcd
//String sItdsc, sIspec, sJijil, sIspeccode
//long   lcount, l_data, inull,nRtn, ireturn
string sitnbr, sItdsc, sCvcod, scvnas, snull

SetNull(snull)
SetNull(gs_code)
SetNull(gs_codename)

Choose Case GetColumnName() 
	/* 거래처 */
	Case "cvcod"
		sCvcod = Trim(GetText())
		
		Select cvcod, cvnas
		  Into :scvcod, :scvnas
		  From vndmst
		 where cvcod = :scvcod ;		
		
		If sqlca.sqlcode = 0 Then
			setitem(1, "cvcod", scvcod)	
			setitem(1, "cvnas", scvnas)	
		Else
			setitem(1, "cvcod", snull)	
			setitem(1, "cvnas", snull)	
			Return 1
		End IF
	/* 품번 */
	Case "itnbr"
		sItnbr = trim(GetText())

		Select itnbr , itdsc
		  Into :sitnbr, :sitdsc
		  From itemas 
		 where itnbr = :sItnbr ;
		 
		If sqlca.sqlcode = 0 Then
			setitem(1, "itnbr", sitnbr)	
			setitem(1, "itdsc", sitdsc)	
		Else
			setitem(1, "itnbr", snull)	
			setitem(1, "itdsc", snull)	
			Return 1
		End IF
end Choose

//ib_any_typing = false

/*
String sarea, steam, sCvcod, scvnas, sSaupj, sName1
String sNull, sTodate, sFrdate, sName, sGet_name, steamcd
String sItdsc, sIspec, sJijil, sIspeccode
long   lcount, l_data, inull,nRtn, ireturn
string sitnbr,scurr,spricegbn
double dc_rate , ld_price

SetNull(snull)
setnull(inull)
SetNull(gs_code)
SetNull(gs_codename)

Choose Case GetColumnName() 
	/* 거래처 */
	Case "cvcod"
		sCvcod = Trim(GetText())
		IF 	sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"cvnas",snull)
			Return
		END IF

		If 	f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, "cvcod", sNull)
			SetItem(1, "cvnas", snull)
			Return 1
		ELSE
			SetItem(1,"cvnas",	scvnas)
			p_inq.TriggerEvent(Clicked!)
		END IF
	/* 품번 */
	Case "itnbr"
		sItnbr = trim(GetText())
	
		//ireturn = f_get_name4_sale('품번', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		Select itnbr , itdsc , ispec , jijil
		  Into :sitnbr, :sitdsc, :sispec, :sjijil
		  From itemas 
		 where itnbr = :sItnbr ;
		 
		If sqlca.sqlcode = 0 Then
			setitem(1, "itnbr", sitnbr)	
			setitem(1, "itdsc", sitdsc)	
			setitem(1, "ispec", sispec)
			setitem(1, "jijil", sjijil)
			
			p_inq.TriggerEvent(Clicked!)
		Else
			setitem(1, "itnbr", snull)	
			setitem(1, "itdsc", snull)	
			setitem(1, "ispec", snull)
			setitem(1, "jijil", snull)
			f_message_chk(33,'[품번]')
			Return 1
		End IF
		
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
		ld_price = Double(GetText())
		If ld_price <= 0 Then
			f_message_chk(80,'')
			Return 1
		End If
		
		
end Choose

ib_any_typing = false
*/
end event

event dw_insert::itemerror;return 1
end event

event dw_insert::rbuttondown;Long nRow

setnull(gs_code)
setnull(gs_codename)

nRow = GetRow()
If nRow <= 0 Then Return
Choose Case GetColumnName() 
	Case 'itnbr'
		gs_code = Trim(this.GetText())
		open(w_itemas_popup)
		if gs_code = "" or isnull(gs_code) then return 
		this.setitem(1, 'itnbr', gs_code)
		this.setitem(1, 'itdsc', gs_codename)
		this.setfocus()
	/* 거래처 */
	Case "cvcod"
		gs_code = Trim(this.GetText())		
		Open(w_vndmst_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		this.SetItem(1, "cvcod",gs_code)
		this.setitem(1, 'cvnas', gs_codename)		
		this.setfocus()		
end Choose

end event

event dw_insert::ue_key;call super::ue_key;/*
str_itnct str_sitnct
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
*/
end event

type p_delrow from w_inherite`p_delrow within w_sm20_p020
boolean visible = false
integer x = 4430
integer y = 284
integer taborder = 70
boolean enabled = false
string picturename = "C:\erpman\image\행삭제_d.gif"
end type

type p_addrow from w_inherite`p_addrow within w_sm20_p020
boolean visible = false
integer x = 4256
integer y = 288
integer taborder = 50
boolean enabled = false
string picturename = "C:\erpman\image\행추가_d.gif"
end type

type p_search from w_inherite`p_search within w_sm20_p020
integer x = 1701
integer y = 2560
integer taborder = 120
end type

type p_ins from w_inherite`p_ins within w_sm20_p020
boolean visible = false
integer x = 4864
integer y = 544
integer taborder = 40
end type

event p_ins::clicked;call super::clicked;string scvcod,scvnas , ls_itnbr, ls_itdsc , ls_ispec , ls_jijil
int nRow

nRow = dw_insert.GetRow()
If nRow > 0 Then 
   scvcod = Trim(dw_insert.GetItemString(nRow,'cvcod'))
   scvnas = Trim(dw_insert.GetItemString(nRow,'cvnas'))
	
	ls_itnbr = Trim(dw_insert.GetItemString(nRow,'itnbr'))
	ls_itdsc = Trim(dw_insert.GetItemString(nRow,'itdsc'))
	ls_ispec = Trim(dw_insert.GetItemString(nRow,'ispec'))
	ls_jijil = Trim(dw_insert.GetItemString(nRow,'jijil'))
	
Else
	SetNull(scvcod)
End If

dw_insert.setredraw(false)	 

dw_insert.reset()

nRow = dw_insert.insertrow(0)
/*
If rb_1.checked Then
	If ls_itnbr = '' or isNull(ls_itnbr) Then
		dw_insert.SetFocus()
		dw_insert.SetRow(nRow)
		dw_insert.SetColumn("itnbr")
	Else
		dw_insert.SetItem(nRow, "itnbr", ls_itnbr)
		dw_insert.SetItem(nRow, "itdsc", ls_itdsc)
		dw_insert.SetItem(nRow, "ispec", ls_ispec)
		dw_insert.SetItem(nRow, "jijil", ls_jijil)
		dw_insert.SetItem(nRow, "start_date", f_today())
		dw_insert.SetFocus()
		dw_insert.SetRow(nRow)
		dw_insert.SetColumn("cvcod")
	End If
Else
	IF scvcod = '' or isNull(scvcod) then
		dw_insert.SetFocus()
		dw_insert.SetRow(nRow)
		dw_insert.SetColumn("cvcod")
	Else
		dw_insert.SetItem(nRow, "cvcod", scvcod)
		dw_insert.SetItem(nRow, "cvnas", scvnas)
		dw_insert.SetItem(nRow, "start_date", f_today())
		
		dw_insert.SetFocus()
		dw_insert.SetRow(nRow)
		dw_insert.SetColumn("itnbr")
	End If
End If
*/
wf_key_protect('신규')
dw_insert.setredraw(true)
end event

type p_exit from w_inherite`p_exit within w_sm20_p020
integer x = 4434
integer y = 28
integer taborder = 110
end type

event p_exit::clicked;//
close(parent)
end event

type p_can from w_inherite`p_can within w_sm20_p020
integer x = 4261
integer y = 28
integer taborder = 100
end type

event p_can::clicked;call super::clicked;//dw_insert.setredraw(false)
dw_insert.reset()
dw_insert.insertrow(0)
//dw_insert.setredraw(true)

//dw_list.setredraw(false)
dw_list.reset()
dw_list.insertrow(0)
//dw_list.setredraw(true)

//string scvcod,scvnas
//int nRow

//dw_insert.GetRow()
//dw_list.GetRow()

//nRow = dw_insert.GetRow()
//If nRow > 0 Then 
//   scvcod = Trim(dw_insert.GetItemString(nRow,'cvcod'))
//Else
//	SetNull(scvcod)
//	SetNull(ls_itnbr)
//End If

//dw_insert.setredraw(false)	 

//dw_list.Reset()
//dw_insert.reset()

/*
//rb_1.Checked = True
dw_list.DataObject = "d_pd90_0040_a"
dw_list.SetTransObject(sqlca)

dw_insert.Object.itnbr_t.y = 28
dw_insert.Object.itnbr.y = 28
dw_insert.Object.itdsc.y = 28

dw_insert.Object.t_1.y = 112
dw_insert.Object.cvcod.y = 112
dw_insert.Object.cvnas.y = 112

//nRow = dw_insert.insertrow(0)
//dw_insert.SetItem(nRow, "cvcod", '')
//dw_insert.SetItem(nRow, "cvnas", '')
//dw_insert.SetItem(nRow, "itnbr", '')
//dw_insert.SetItem(nRow, "itdsc", '')
//dw_insert.SetItem(nRow, "start_date", f_today())
//dw_insert.SetRow(nRow)

//dw_insert.SetColumn("itnbr")
//dw_insert.SetFocus()

//dw_insert.SetTabOrder("itnbr",10)
//dw_insert.SetTabOrder("cvcod",30)

//wf_key_protect('신규')
dw_insert.setredraw(true)
*/

end event

type p_print from w_inherite`p_print within w_sm20_p020
boolean visible = false
integer x = 4137
integer y = 196
integer taborder = 130
boolean enabled = false
string picturename = "C:\erpman\image\인쇄_d.gif"
end type

type p_inq from w_inherite`p_inq within w_sm20_p020
integer x = 3739
integer y = 28
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;string  ls_carcod, ls_itnbr, ls_cvcod, ls_sdate, ls_edate, ls_dangu

dw_insert.AcceptText()

ls_carcod	= Trim(dw_insert.getitemstring(1, "carcode"))
ls_itnbr  	= Trim(dw_insert.getitemstring(1, "itnbr"))
ls_cvcod  	= Trim(dw_insert.getitemstring(1, "cvcod"))
ls_sdate  	= Trim(dw_insert.getitemstring(1, "sdate"))
ls_edate  	= Trim(dw_insert.getitemstring(1, "edate"))
ls_dangu    = Trim(dw_insert.getitemstring(1, "dangu"))

if Isnull(ls_carcod) or ls_carcod = '' then ls_carcod = '%'
if Isnull(ls_itnbr) or ls_itnbr = '' then ls_itnbr = '%'
if Isnull(ls_cvcod) or ls_cvcod = '' then ls_cvcod = '%'
if Isnull(ls_sdate) or ls_sdate = '' then ls_sdate = '19000101'
if Isnull(ls_edate) or ls_edate = '' then	ls_edate = '29991231'

dw_list.retrieve(ls_carcod, ls_itnbr, ls_cvcod, ls_sdate, ls_edate, ls_dangu)

dw_list.ShareData(dw_print)

IF dw_list.retrieve(ls_carcod, ls_itnbr, ls_cvcod, ls_sdate, ls_edate, ls_dangu) = -1 THEN
	p_xls.Enabled =False
	p_xls.PictureName = 'C:\erpman\image\엑셀변환_d.gif'

	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
	SetPointer(Arrow!)
	Return
Else
	p_xls.Enabled =True
	p_xls.PictureName =  'C:\erpman\image\엑셀변환_up.gif'
	p_preview.enabled = true
	p_preview.PictureName = 'C:\erpman\image\미리보기_up.gif'
END IF

ib_any_typing = false
end event

type p_del from w_inherite`p_del within w_sm20_p020
boolean visible = false
integer x = 4827
integer y = 1024
integer taborder = 90
end type

event p_del::clicked;call super::clicked;String ls_cvcod , ls_cvnas
String ls_itnbr , ls_itdsc ,ls_ispec ,ls_jijil
Long   ll_r ,l_row
dw_insert.AcceptText()
l_row = dw_insert.getrow()
ls_cvcod = Trim(dw_insert.GetItemString(1,'cvcod'))
ls_cvnas = Trim(dw_insert.GetItemString(1,'cvnas'))

ls_itnbr = Trim(dw_insert.GetItemString(1,'itnbr'))
ls_itdsc = Trim(dw_insert.GetItemString(1,'itdsc'))
ls_ispec = Trim(dw_insert.GetItemString(1,'ispec'))
ls_jijil = Trim(dw_insert.GetItemString(1,'jijil'))

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

p_can.TriggerEvent(Clicked!)

////필수입력항목을 입력하지 않고 [조회]를 click한 경우///////////////////
/*
IF rb_1.Checked = True THEN
	dw_insert.Object.itnbr[1] = ls_itnbr
	dw_insert.Object.itdsc[1] = ls_itdsc
	dw_insert.Object.ispec[1] = ls_ispec
	dw_insert.Object.jijil[1] = ls_jijil
	ls_cvcod = '%'
	dw_insert.SetFocus()
	dw_insert.SetRow(1)
	dw_insert.SetColumn("cvcod")
ELSE
	dw_insert.Object.cvcod[1] = ls_cvcod
	dw_insert.Object.cvnas[1] = ls_cvnas
	ls_itnbr = '%'
	dw_insert.SetFocus()
	dw_insert.SetRow(1)
	dw_insert.SetColumn("itnbr")
END IF	
////////////////////////////////////////////////////////////////////////////////
*/
dw_insert.setredraw(false)	 // 화면이 껌벅거리는 것을 막기 위해... (false ~ true)

if dw_list.retrieve(ls_cvcod,  ls_itnbr) <= 0 then
  	f_message_chk(50,'[거래처 단가 등록]')	
   dw_insert.setredraw(true)	
	return	
end if
dw_insert.setredraw(true)



end event

type p_mod from w_inherite`p_mod within w_sm20_p020
boolean visible = false
integer x = 4864
integer y = 768
integer taborder = 80
end type

event p_mod::clicked;call super::clicked;string s_itnbr, s_itdsc, s_ispec, s_cvcod, snull,sfrdate, stodate, sCurr
Long   l_row, ll_row, inull,nRow
Double dSalesPrc,dDcRate , ld_mprice ,ld_bprice

String ls_dangu , ls_crt_date ,ls_crt_time ,ls_upd_date ,ls_upd_time , ls_bigo ,ls_bcurr ,ls_cvnas ,ls_jijil

setnull(snull)
setnull(inull)

IF dw_insert.Accepttext() = -1 THEN 	RETURN

s_cvcod 	= dw_insert.GetItemString(1, "cvcod")       //직판점
s_itnbr 	= dw_insert.GetItemString(1, "itnbr")       //품번
s_itdsc 	= dw_insert.GetItemString(1, "itdsc")       //품명
s_ispec 	= dw_insert.GetItemString(1, "ispec")       //규격
sfrdate 	= dw_insert.GetItemString(1, "start_date")     
stodate 	= dw_insert.GetItemString(1, "end_date")
sCurr   	= dw_insert.GetItemString(1, "curr")
dSalesPrc = dw_insert.GetItemNumber(1, "sales_price")
dDcRate  	= dw_insert.GetItemNumber(1, "dc_rate")

ld_mprice = dw_insert.Object.sales_price2[1]
ld_bprice = dw_insert.Object.broad_price[1]
ls_dangu  = Trim(dw_insert.Object.dangu[1])
ls_bcurr  =  Trim(dw_insert.Object.broad_curr[1])
ls_bigo   = Trim(dw_insert.Object.bigo[1])

ls_cvnas 	= dw_insert.GetItemString(1, "cvnas")      
ls_jijil 	= dw_insert.GetItemString(1, "jijil") 

////필수입력 항목 체크/////////////////////////////////////////////////
IF 	IsNull(s_cvcod) or trim(s_cvcod) = '' THEN
	f_message_chk(30,'[거래처]')
	dw_insert.SetColumn("cvcod")
	dw_insert.SetFocus()
	RETURN 
END IF

IF 	IsNull(s_itnbr) or trim(s_itnbr) = '' THEN
	f_message_chk(30,'[품번]')
	dw_insert.SetColumn("itnbr")
	dw_insert.SetFocus()
	RETURN 
END IF

IF 	IsNull(sfrdate) or trim(sfrdate) = '' THEN
	f_message_chk(30,'[적용시작일]')
	dw_insert.SetColumn("start_date")
	dw_insert.SetFocus()
	RETURN 
END IF

If dSalesPrc <= 0 Then
	f_message_chk(1400,'[단가]')
	dw_insert.SetColumn("sales_price")
	dw_insert.SetFocus()
	RETURN 
END IF

////기존의 입력된 data와 중복되는 것을 피하기 위해 (primary key)///////////////////////////////////
SELECT COUNT(ITNBR)                     
  INTO :ll_row                               
  FROM VNDDAN
 WHERE CVCOD = :s_cvcod AND
		 ITNBR = :s_itnbr and                  
		 START_DATE = :sfrdate ;

If 	ll_row > 0 then  
	
	ls_upd_date = is_today 
	ls_upd_time = is_totime 
	
	update vnddan
	   set end_date = :sTodate,
		    sales_price = :dSalesPrc,
			 sales_price2 = :ld_mprice,
			 broad_price = :ld_bprice,
			 curr = :sCurr,
			 broad_curr = :ls_bcurr,
			 dangu = :ls_dangu ,
			 bigo = :ls_bigo ,
			 upd_date = :ls_upd_date ,
			 upd_time = :ls_upd_time ,
			 upd_user = :gs_userid
    WHERE CVCOD = :s_cvcod AND
	    	 ITNBR = :s_itnbr and                  
		    START_DATE = :sfrdate ;
Else
	ls_crt_date = is_today 
	ls_crt_time = is_totime 
	
	Insert into vnddan (    CVCOD,
									ITNBR,
									START_DATE,   
									END_DATE,  
									SALES_PRICE2,  
									SALES_PRICE,   
									CURR,   
									BROAD_PRICE,   
									BROAD_CURR , 
									DANGU,   
									BIGO, 
									CRT_DATE,   
									CRT_TIME,   
									CRT_USER )
	               values ( :s_cvcod, 
						         :s_itnbr, 
									:sfrdate, 
									:sToDate, 
									:ld_mprice,
									:dSalesPrc ,
									:sCurr ,
									:ld_bprice,
									:ls_bcurr ,
									:ls_dangu,
									:ls_bigo ,
									:ls_crt_date ,
									:ls_crt_time ,
									:gs_userid );
End If

//+++++++++++++++++++
if Sqlca.sqlcode = 0 then
	commit using sqlca;
else
	MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
	rollback using sqlca ;
	return
end if


dw_insert.setredraw(false)	 
p_inq.triggerevent(Clicked!)

dw_insert.reset()
nRow = dw_insert.insertrow(0)

dw_insert.SetItem(nRow, "cvcod", s_cvcod)
dw_insert.SetItem(nRow, "cvnas", ls_cvnas)
dw_insert.SetItem(nRow, "start_date", f_today())
dw_insert.SetItem(nRow, "itnbr", s_itnbr)
dw_insert.SetItem(nRow, "itdsc", s_itdsc)
dw_insert.SetItem(nRow, "ispec", s_ispec)
dw_insert.SetItem(nRow, "jijil", ls_jijil)
dw_insert.SetFocus()
dw_insert.SetRow(nRow)
dw_insert.SetColumn("itnbr")

wf_key_protect('신규')
dw_insert.setredraw(true)


sle_msg.text = "저장하였습니다!!"



end event

type cb_exit from w_inherite`cb_exit within w_sm20_p020
end type

type cb_mod from w_inherite`cb_mod within w_sm20_p020
end type

type cb_ins from w_inherite`cb_ins within w_sm20_p020
integer x = 78
integer y = 2436
end type

type cb_del from w_inherite`cb_del within w_sm20_p020
end type

type cb_inq from w_inherite`cb_inq within w_sm20_p020
end type

type cb_print from w_inherite`cb_print within w_sm20_p020
integer x = 416
integer y = 2436
end type

type st_1 from w_inherite`st_1 within w_sm20_p020
end type

type cb_can from w_inherite`cb_can within w_sm20_p020
end type

type cb_search from w_inherite`cb_search within w_sm20_p020
integer x = 754
integer y = 2436
end type







type gb_button1 from w_inherite`gb_button1 within w_sm20_p020
end type

type gb_button2 from w_inherite`gb_button2 within w_sm20_p020
end type

type gb_3 from groupbox within w_sm20_p020
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

type dw_list from u_d_popup_sort within w_sm20_p020
integer x = 27
integer y = 256
integer width = 4562
integer height = 2044
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_sm20_p020_a"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event clicked;call super::clicked;IF row <= 0  THEN RETURN

IF IsSelected(row) THEN
	Selectrow(0,False)
ELSE
	Selectrow(0,False)
	Selectrow(row,True)
END IF
end event

type dw_print from datawindow within w_sm20_p020
boolean visible = false
integer x = 3630
integer y = 44
integer width = 87
integer height = 72
integer taborder = 90
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm20_p020_p"
boolean border = false
boolean livescroll = true
end type

type p_preview from picture within w_sm20_p020
integer x = 3913
integer y = 28
integer width = 178
integer height = 144
boolean bringtotop = true
string picturename = "C:\erpman\image\미리보기_d.gif"
boolean focusrectangle = false
end type

event clicked;OpenWithParm(w_print_preview, dw_print)	
end event

type p_xls from picture within w_sm20_p020
integer x = 4087
integer y = 28
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "HyperLink!"
boolean enabled = false
string picturename = "C:\erpman\image\엑셀변환_d.gif"
boolean focusrectangle = false
end type

event clicked;String	ls_quota_no
integer	li_rc
string	ls_filepath, ls_filename
boolean	lb_fileexist

li_rc = GetFileSaveName("저장할 파일명을 선택하세요." , ls_filepath , &
											  ls_filename , "XLS" , "Excel Files (*.xls),*.xls")												
IF li_rc = 1 THEN
	IF lb_fileexist THEN
		li_rc = MessageBox("파일저장" , ls_filepath + " 파일이 이미 존재합니다.~r~n" + &
												 "기존의 파일을 덮어쓰시겠습니까?" , Question! , YesNo! , 1)
		IF li_rc = 2 THEN 
			w_mdi_frame.sle_msg.text = "자료다운취소!!!"			
			RETURN
		END IF
	END IF
	
	Setpointer(HourGlass!)
	
 	If uf_save_dw_as_excel(dw_list,ls_filepath) <> 1 Then
		w_mdi_frame.sle_msg.text = "자료다운실패!!!"
		return
	End If

END IF

w_mdi_frame.sle_msg.text = "자료다운완료!!!"
end event

type rb_1 from radiobutton within w_sm20_p020
integer x = 3040
integer y = 68
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "변동내역"
boolean checked = true
end type

event clicked;If This.Checked = True Then
	dw_list.DataObject = 'd_sm20_p020_a'
	dw_print.DataObject = 'd_sm20_p020_p'
End If

dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
end event

type rb_2 from radiobutton within w_sm20_p020
integer x = 3040
integer y = 132
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "최종내역"
end type

event clicked;If This.Checked = True Then
	dw_list.DataObject = 'd_sm20_p020_a_max'
	dw_print.DataObject = 'd_sm20_p020_p_max'
End If

dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
end event

type rr_1 from roundrectangle within w_sm20_p020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 248
integer width = 4590
integer height = 2064
integer cornerheight = 40
integer cornerwidth = 55
end type

