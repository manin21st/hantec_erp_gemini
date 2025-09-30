$PBExportHeader$w_sal_02110.srw
$PBExportComments$ 거래처 제품단가 등록(VNDDAN)
forward
global type w_sal_02110 from w_inherite
end type
type rr_2 from roundrectangle within w_sal_02110
end type
type rr_3 from roundrectangle within w_sal_02110
end type
type dw_list1 from datawindow within w_sal_02110
end type
type gb_3 from groupbox within w_sal_02110
end type
type dw_1 from datawindow within w_sal_02110
end type
type dw_detail from datawindow within w_sal_02110
end type
type dw_list from u_d_popup_sort within w_sal_02110
end type
type pb_1 from u_pb_cal within w_sal_02110
end type
type pb_2 from u_pb_cal within w_sal_02110
end type
type rr_1 from roundrectangle within w_sal_02110
end type
end forward

global type w_sal_02110 from w_inherite
integer height = 3256
string title = " 거래처 제품단가 등록"
rr_2 rr_2
rr_3 rr_3
dw_list1 dw_list1
gb_3 gb_3
dw_1 dw_1
dw_detail dw_detail
dw_list dw_list
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_sal_02110 w_sal_02110

type variables
str_itnct lstr_sitnct
string is_itnbr
end variables

forward prototypes
public function integer wf_key_protect (string gb)
public function integer wf_chk ()
end prototypes

public function integer wf_key_protect (string gb);Choose Case gb
	Case '조회'
		dw_insert.Modify('cvcod.protect = 1')
		dw_insert.Modify('itnbr.protect = 1')
		dw_insert.Modify('itdsc.protect = 1')
		dw_insert.Modify('ispec.protect = 1')
		dw_insert.Modify('jijil.protect = 1')
		dw_insert.Modify('ispec_code.protect = 1')
		dw_insert.Modify('start_date.protect = 1')
//		dw_insert.Modify("cvcod.background.color = 80859087") 
//		dw_insert.Modify("itnbr.background.color = 80859087")  
//		dw_insert.Modify("itdsc.background.color = 80859087")
//		dw_insert.Modify("ispec.background.color = 80859087")
//		dw_insert.Modify("jijil.background.color = 80859087")
//		dw_insert.Modify("ispec_code.background.color = 80859087")
//		dw_insert.Modify("start_date.background.color = 80859087")
	Case '신규'
		dw_insert.Modify('cvcod.protect = 0')
		dw_insert.Modify('itnbr.protect = 0')
		dw_insert.Modify('itdsc.protect = 0')
		dw_insert.Modify('ispec.protect = 0')
		dw_insert.Modify('jijil.protect = 0')
		dw_insert.Modify('ispec_code.protect = 0')
		dw_insert.Modify('start_date.protect = 0')
//		dw_insert.Modify("cvcod.background.color = 65535")  //yellow
//		dw_insert.Modify("itnbr.background.color = 65535")  //yellow
//		dw_insert.Modify("itdsc.background.color = '" + String(Rgb(255,255,255))+"'") //white
//		dw_insert.Modify("ispec.background.color = '" + String(Rgb(255,255,255))+"'") //white
//		dw_insert.Modify("jijil.background.color = '" + String(Rgb(255,255,255))+"'") //white
//		dw_insert.Modify("ispec_code.background.color = '" + String(Rgb(255,255,255))+"'") //white
//		dw_insert.Modify("start_date.background.color = '"+String(Rgb(190,225,184))+"'")
End Choose

p_addrow.enabled 	= false
p_delrow.enabled 	= false

p_addrow.PictureName  	= "C:\erpman\image\행추가_d.gif"
p_delrow.PictureName  	= "C:\erpman\image\행삭제_d.gif"

return 1
end function

public function integer wf_chk ();String  sSdate, sEdate, sPspec, sCurren, sNull
Long   ix
Int  	lReturnRow
Decimal {3} dPrice, dPackamt

SetNull(sNull)

If 	dw_detail.AcceptText() <> 1 Then Return -1

dw_detail.AcceptText()

dw_detail.SetFocus()

For ix = 1 To dw_detail.RowCount()
	sSdate	= Trim(dw_detail.GetItemString(ix,'sdate'))
	sEdate	= Trim(dw_detail.GetItemString(ix,'edate'))
	sPspec	= Trim(dw_detail.GetItemString(ix,'pspec'))
	sCurren	= Trim(dw_detail.GetItemString(ix,'curren'))
	dPrice		= dw_detail.GetItemDecimal(ix,'price')
	dPackamt	= dw_detail.GetItemDecimal(ix,'packamt')

	If 	IsNull(sPspec) or sPspec = "" then
		f_message_chk(40,'[사 양]')
		dw_detail.ScrollToRow(ix)
		dw_detail.SetColumn('pspec')
		dw_detail.SetFocus()
		Return -1
	End If

	If 	IsNull(sCurren) or sCurren = "" then
		f_message_chk(40,'[통화코드]')
		dw_detail.ScrollToRow(ix)
		dw_detail.SetColumn('curren')
		dw_detail.SetFocus()
		Return -1
	End If
	
	If 	f_datechk(sSdate) <> 1 Then
		f_message_chk(40,'[시작일자]')
		dw_detail.ScrollToRow(ix)
		dw_detail.SetColumn('sdate')
		dw_detail.SetFocus()
		Return -1
	End If

	If 	Not(isnull(sEdate))  Then
		If 	f_datechk(sEdate) <> 1  Then
			f_message_chk(40,'[종료일자]')
			dw_detail.ScrollToRow(ix)
			dw_detail.SetColumn('edate')
			dw_detail.SetFocus()
			Return -1
		ElseIf	sSdate > sEdate Then
			f_message_chk(200,'[시작일자]')
			dw_detail.ScrollToRow(ix)
			dw_detail.SetColumn('sdate')
			dw_detail.SetFocus()
			Return -1
		End If
	End If
	
	lReturnRow = dw_detail.Find("pspec = '"+ spspec +"' ", 1, ix)
		IF (ix <> lReturnRow) and (lReturnRow <> 0)		THEN
			sEdate	= Trim(dw_detail.GetItemString(lReturnRow,'edate'))
			If 	f_datechk(sEdate) <> 1  Then
				f_message_chk(40,'[종료일자]')
				dw_detail.ScrollToRow(lReturnRow)
				dw_detail.SetColumn('edate')
				dw_detail.SetFocus()
				Return -1
			ElseIf	sSdate < sEdate Then
				MessageBox("확인", "동일사양의 종료일자와 시작일자를 확인하여 주시기 바랍니다.!!!")
				dw_detail.ScrollToRow(ix)
				dw_detail.SetColumn('sdate')
				dw_detail.SetFocus()
				Return -1
			End If
		END IF
	if 	dPrice <= dPackamt then 
		MessageBox("확인", "포장비가 단가보다 큰 금액 처리는 불가 !!!")
		dw_detail.ScrollToRow(ix)
		dw_detail.SetColumn('packamt')
		dw_detail.SetFocus()
		Return -1
	End If
Next

//--------------------------------------------------------------------//



Return 1

end function

on w_sal_02110.create
int iCurrent
call super::create
this.rr_2=create rr_2
this.rr_3=create rr_3
this.dw_list1=create dw_list1
this.gb_3=create gb_3
this.dw_1=create dw_1
this.dw_detail=create dw_detail
this.dw_list=create dw_list
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
this.Control[iCurrent+2]=this.rr_3
this.Control[iCurrent+3]=this.dw_list1
this.Control[iCurrent+4]=this.gb_3
this.Control[iCurrent+5]=this.dw_1
this.Control[iCurrent+6]=this.dw_detail
this.Control[iCurrent+7]=this.dw_list
this.Control[iCurrent+8]=this.pb_1
this.Control[iCurrent+9]=this.pb_2
this.Control[iCurrent+10]=this.rr_1
end on

on w_sal_02110.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
destroy(this.rr_3)
destroy(this.dw_list1)
destroy(this.gb_3)
destroy(this.dw_1)
destroy(this.dw_detail)
destroy(this.dw_list)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_insert.settransobject(sqlca)
dw_list.settransobject(sqlca)
dw_1.settransobject(sqlca)
dw_Detail.settransobject(sqlca)

dw_1.InsertRow(0)
p_can.TriggerEvent(Clicked!)
end event

type dw_insert from w_inherite`dw_insert within w_sal_02110
integer x = 23
integer y = 32
integer width = 3685
integer height = 200
integer taborder = 10
string dataobject = "d_sal_02110_01"
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
		steamcd = Trim(GetItemString(1,'steamcd'))
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

event dw_insert::rbuttondown;Long nRow

setnull(gs_code)
setnull(gs_codename)
setnull(gs_codename2)
setnull(gs_gubun)

nRow = GetRow()
If nRow <= 0 Then Return
Choose Case GetColumnName() 
	Case 'itnbr'
		gs_code = Trim(this.GetText())
		gs_codename2 = this.GetItemString(1, 'cvcod')
		gs_gubun = '1'
		open(w_itemas_popup)
		if gs_code = "" or isnull(gs_code) then return 
		this.setitem(1, 'itnbr', gs_code)
		this.setitem(1, 'itdsc', gs_codename)
		this.setitem(1, 'ispec', gs_gubun)
		this.setcolumn("end_date")
		this.setfocus()
	/* 거래처 */
	Case "cvcod", "cvnas"
		If GetColumnName() = "cvnas" then
			gs_codename = Trim(GetText())
		End If
		Open(w_vndmst_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		SetColumn("cvcod")
		TriggerEvent(ItemChanged!)
end Choose

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

type p_delrow from w_inherite`p_delrow within w_sal_02110
integer x = 4334
integer y = 292
boolean enabled = false
string picturename = "C:\erpman\image\행삭제_d.gif"
end type

event p_delrow::clicked;call super::clicked;
dw_Detail.AcceptText()

IF dw_Detail.GetRow() <=0 THEN
	f_message_chk(36,'')
	Return
END IF

dw_Detail.DeleteRow(0)

dw_Detail.ScrollToRow(dw_Detail.RowCount())
dw_Detail.Setfocus()

end event

type p_addrow from w_inherite`p_addrow within w_sal_02110
integer x = 4059
integer y = 292
boolean enabled = false
string picturename = "C:\erpman\image\행추가_d.gif"
end type

event p_addrow::clicked;call super::clicked;Int    	il_currow,il_RowCount, k
string 	ls_cvcod

IF 	dw_Detail.RowCount() <=0 THEN
	il_currow = 0
	il_rowCount = 0
ELSE
	il_currow 		= dw_Detail.GetRow()
	il_RowCount 	= dw_Detail.RowCount()
	
	IF 	il_currow <=0 THEN
		il_currow = il_rowCount
	END IF
END IF

il_currow 	= il_rowCount + 1
ls_cvcod 	= dw_insert.GetItemString(1, "cvcod")       //거래처.

dw_Detail.InsertRow(il_currow)
dw_Detail.SetItem(il_currow, "itnbr", is_itnbr)
dw_Detail.SetItem(il_currow, "opseq", '9999')
dw_Detail.SetItem(il_currow, "cvcod", ls_cvcod)
dw_Detail.SetItem(il_currow, "gubun",'3')   				// 3 : 거래처별 판매단가

dw_Detail.ScrollToRow(il_currow)
dw_Detail.SetColumn("pspec")
dw_Detail.SetFocus()


end event

type p_search from w_inherite`p_search within w_sal_02110
boolean visible = false
integer x = 1701
integer y = 2560
end type

type p_ins from w_inherite`p_ins within w_sal_02110
boolean visible = false
integer x = 2222
integer y = 2560
end type

type p_exit from w_inherite`p_exit within w_sal_02110
integer x = 4439
integer y = 28
end type

type p_can from w_inherite`p_can within w_sal_02110
integer x = 4261
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

dw_insert.setredraw(false)	 

dw_list.reset()
dw_insert.reset()
dw_detail.reset()
nRow = dw_insert.insertrow(0)
dw_insert.SetItem(nRow, "cvcod", scvcod)
dw_insert.SetItem(nRow, "cvnas2", scvnas)
dw_insert.SetItem(nRow, "start_date", f_today())
dw_insert.SetFocus()
dw_insert.SetRow(nRow)
dw_insert.SetColumn("cvcod")
wf_key_protect('신규')
dw_insert.setredraw(true)


end event

type p_print from w_inherite`p_print within w_sal_02110
boolean visible = false
integer x = 1874
integer y = 2560
end type

type p_inq from w_inherite`p_inq within w_sal_02110
integer x = 3726
integer y = 28
end type

event p_inq::clicked;call super::clicked;string  s_cvcod,s_ittyp, s_itcls, ls_itnbr

If dw_1.AcceptText() 		= -1 Then Return
If dw_insert.AcceptText() 	= -1 Then Return
If dw_insert.RowCount() 	<= 0 Then Return
If dw_1.Rowcount() 			<= 0 Then Return

s_cvcod  	= dw_insert.getitemstring(1, "cvcod")
s_ittyp  	= dw_1.getitemstring(1, "ittyp") + '%'
s_itcls  	= dw_1.getitemstring(1, "itcls") +'%'
ls_itnbr  	= dw_insert.getitemstring(1, "itnbr") + '%'

If IsNull(ls_itnbr) or ls_itnbr = '' Then
	ls_itnbr = '%'
End If

////필수입력항목을 입력하지 않고 [조회]를 click한 경우///////////////////
if 	s_cvcod = "" or isnull(s_cvcod) then 
	f_message_chk(30,'[거래처]')
	dw_insert.setcolumn("cvcod")
	dw_insert.setfocus()
   	return 
end if	

if 	s_ittyp = "" or isnull(s_ittyp) then 
	f_message_chk(30,'[품목구분]')
	dw_1.setcolumn("ittyp")
	dw_1.setfocus()
     return 
end if	

If 	IsNull(s_itcls) Then s_itcls = ''
////////////////////////////////////////////////////////////////////////////////
dw_insert.setredraw(false)	 // 화면이 껌벅거리는 것을 막기 위해... (false ~ true)

if 	dw_list.retrieve(s_cvcod, s_ittyp, s_itcls+'%', ls_itnbr+'%', gs_saupj) <= 0 then
  	f_message_chk(50,'[거래처 단가 등록]')
	dw_1.setfocus()
	dw_1.SetRow(1)
	dw_1.setcolumn("itcls")
   	dw_insert.setredraw(true)	
	return
	
end if

dw_insert.setredraw(true)	

ib_any_typing = false
end event

type p_del from w_inherite`p_del within w_sal_02110
integer x = 4082
integer y = 28
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

p_can.PostEvent(Clicked!)
end event

type p_mod from w_inherite`p_mod within w_sal_02110
integer x = 3904
integer y = 28
end type

event p_mod::clicked;call super::clicked;string s_itnbr, s_itdsc, s_ispec, s_cvcod, snull,sfrdate, stodate, sCurr
Long   l_row, ll_row, inull,nRow
Double dSalesPrc,dDcRate, dgitaprc

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
dgitaprc  = dw_insert.GetItemNumber(1, "gita_price")

////필수입력 항목 체크/////////////////////////////////////////////////
IF	IsNull(s_cvcod) or trim(s_cvcod) = '' THEN
	f_message_chk(30,'[거래처]')
	dw_insert.SetColumn("cvcod")
	dw_insert.SetFocus()
	RETURN 
END IF

IF	IsNull(s_itnbr) or trim(s_itnbr) = '' THEN
	f_message_chk(30,'[품번]')
	dw_insert.SetColumn("itnbr")
	dw_insert.SetFocus()
	RETURN 
END IF

IF	IsNull(sfrdate) or trim(sfrdate) = '' THEN
	f_message_chk(30,'[적용시작일]')
	dw_insert.SetColumn("start_date")
	dw_insert.SetFocus()
	RETURN 
END IF

/// ====================================   [ Detail 자료 확인 ]
IF 	wf_chk() = -1 	THEN	RETURN  -1
// --------------------------------------

////기존의 입력된 data와 중복되는 것을 피하기 위해 (primary key)///////////////////////////////////
SELECT COUNT(ITNBR)                     
  INTO :ll_row                               
  FROM VNDDAN
 WHERE CVCOD = :s_cvcod AND
		 ITNBR = :s_itnbr and                  
		 START_DATE = :sfrdate ;

If 	ll_row > 0 then
	update vnddan
	   set end_date = :sTodate,
		    sales_price = :dSalesPrc,
			 gita_price = :dgitaprc,
			 curr = :sCurr,
			 dc_rate = :dDcRate
    WHERE CVCOD = :s_cvcod AND
	    	 ITNBR = :s_itnbr and                  
		    START_DATE = :sfrdate ;
Else
	Insert into vnddan ( cvcod, itnbr, start_date, end_date, sales_price, curr, dc_rate, gita_price )
	 values ( :s_cvcod, :s_itnbr, :sfrdate, :sToDate, :dSalesPrc, :sCurr, :dDcRate, :dgitaprc );
End If

//+++++++++++++++++++
if Sqlca.sqlcode = 0 then
	commit using sqlca;
else
	MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
	rollback using sqlca ;
	return
end if

//--- Detail 사항 저장.
if 	dw_detail.update() = 1 then
	w_mdi_frame.sle_msg.text = "자료가 저장되었습니다!!"
	ib_any_typing= FALSE
	commit ;
else
	rollback ;
	messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
	return 
end if	


//cb_inq.TriggerEvent(Clicked!)

dw_insert.setredraw(false)	 

//dw_insert.reset()
//nRow = dw_insert.insertrow(0)
//dw_insert.SetItem(nRow, "start_date", f_today())

wf_key_protect('신규')
dw_insert.setredraw(true)

dw_insert.SetFocus()
dw_insert.SetRow(nRow)
dw_insert.SetColumn("cvcod")

sle_msg.text = "저장하였습니다!!"

//dw_Detail.Modify("DataWindow.HorizontalScrollPosition = '0'")

p_inq.triggerevent(Clicked!)

end event

type cb_exit from w_inherite`cb_exit within w_sal_02110
end type

type cb_mod from w_inherite`cb_mod within w_sal_02110
end type

type cb_ins from w_inherite`cb_ins within w_sal_02110
integer x = 78
integer y = 2436
end type

type cb_del from w_inherite`cb_del within w_sal_02110
end type

type cb_inq from w_inherite`cb_inq within w_sal_02110
end type

type cb_print from w_inherite`cb_print within w_sal_02110
integer x = 416
integer y = 2436
end type

type st_1 from w_inherite`st_1 within w_sal_02110
end type

type cb_can from w_inherite`cb_can within w_sal_02110
end type

type cb_search from w_inherite`cb_search within w_sal_02110
integer x = 754
integer y = 2436
end type







type gb_button1 from w_inherite`gb_button1 within w_sal_02110
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_02110
end type

type rr_2 from roundrectangle within w_sal_02110
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2985
integer y = 256
integer width = 1637
integer height = 2076
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_sal_02110
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 3954
integer y = 280
integer width = 645
integer height = 176
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_list1 from datawindow within w_sal_02110
integer x = 55
integer y = 364
integer width = 2647
integer height = 1948
boolean bringtotop = true
string dataobject = "d_sal_02110_02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;string s_cvcod,s_itnbr,s_sdate
string s_itdsc,s_ispec
int      nRow

////선택한 행 반전//////////////////////////////////////////////////////////
If 	Row <= 0 then
	dw_1.SelectRow(0,False)
	dw_1.setfocus()
	return
ELSE
	this.SelectRow(0, FALSE)
	this.SelectRow(Row,TRUE)
END IF

////  행을 선택하여 dw_insert로 retrieve             //////////////////////////
////  해당 행에서 키(품번, 적용시작일)를 retrieve    ////////////////////////// 

s_cvcod 	= trim(this.getitemstring(Row, "cvcod"))
s_itnbr 	= this.getitemstring(Row, "itnbr")
s_itdsc 	= this.getitemstring(Row, "itdsc")
s_ispec 	= this.getitemstring(Row, "ispec")
s_sdate 	= this.getitemstring(Row, "start_date")
If 	IsNull(s_itdsc) Then s_itdsc = ''
If 	IsNull(s_ispec) Then s_ispec = ''

If 	s_cvcod = '' Or IsNull(s_cvcod) Then
  	nRow = dw_insert.GetRow()
	If nRow <= 0 Then Return
	
	dw_insert.SetItem(nRow,'itnbr' , s_itnbr )
	dw_insert.SetItem(nRow,'itdsc' , s_itdsc )
	dw_insert.SetItem(nRow,'ispec' , s_ispec )
	dw_insert.Setitem(nRow,'sales_price',0)
	dw_insert.Setitem(nRow,'start_date', f_today())
	dw_insert.Setitem(nRow,'end_date','')
	dw_insert.Setitem(nRow,'dc_rate',0)	

  	wf_key_protect('조회')	
	dw_insert.Modify('start_date.protect = 0')
  	dw_insert.Modify("start_date.background.color = '"+String(Rgb(190,225,184))+"'")	
	dw_insert.SetItemStatus(nRow,0,Primary!, NewModified!)
  	dw_insert.setcolumn('start_date')
Else
	nRow = dw_insert.retrieve(s_cvcod,s_itnbr, s_sdate)        // 기존에 등록된 데이타이면..
  	wf_key_protect('조회')
  	dw_insert.setcolumn('end_date')
End If

dw_insert.setfocus()

SetNull(is_itnbr)

is_itnbr = dw_list.GetItemString(Row,"itnbr")
	
// 품번 세부 사양별 단가 현황.
if 	dw_detail.Retrieve(is_itnbr,'9999', s_cvcod, '3') <= 0 then
	ib_any_typing 	= FALSE	
end if
p_addrow.enabled 	= true
p_delrow.enabled 	= true

p_addrow.PictureName  	= "C:\erpman\image\행추가_up.gif"
p_delrow.PictureName  	= "C:\erpman\image\행삭제_up.gif"

this.SetRedraw(true)

CALL SUPER ::CLICKED 
end event

event rowfocuschanged;//string s_cvcod
//
//if currentrow < 1 then return 
//if this.rowcount() < 1 then return 
//
//this.setredraw(false)
//
//this.SelectRow(0,False)
//this.SelectRow(currentrow,True)
//
//this.ScrollToRow(currentrow)
//
//is_itnbr 	= dw_insert.GetItemString(currentrow,"itnbr")
//s_cvcod 	= trim(this.getitemstring(currentrow, "cvcod"))
//
//dw_list.Retrieve(is_itnbr,'9999', s_cvcod, '3') 
//
//this.setredraw(true)
//
	
end event

event itemerror;Return 1
end event

type gb_3 from groupbox within w_sal_02110
boolean visible = false
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

type dw_1 from datawindow within w_sal_02110
event ue_key pbm_dwnkey
event ue_enter pbm_dwnprocessenter
integer x = 59
integer y = 268
integer width = 2501
integer height = 92
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_sal_02060_02"
boolean border = false
boolean livescroll = true
end type

event ue_key;str_itnct str_sitnct
string snull

setnull(gs_code)
setnull(snull)

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	IF This.GetColumnName() = "itcls" Then
		open(w_ittyp_popup3)
		
		str_sitnct  = Message.PowerObjectParm
				
		if isnull(str_sitnct.s_sumgub) or str_sitnct.s_sumgub = "" then return
		this.SetItem(1,"ittyp", str_sitnct.s_ittyp )		
		this.SetItem(1,"itcls", str_sitnct.s_sumgub )
		this.SetItem(1,"itclsnm", str_sitnct.s_titnm )
//		cb_inq.TriggerEvent(Clicked!)
		RETURN 1
	End if	
END IF		

end event

event ue_enter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;string itclsnm,itcls,s_itnbr, s_itdsc, s_ispec
string s_name,s_itt,snull,get_nm,sDate
Long   nRow

nRow = GetRow()
If nRow <= 0 Then Return

SetNull(sNull)
Choose Case  GetColumnName() 
	Case 'ittyp'
		dw_list.reset()
		this.SetItem(nrow,'itcls','')
		this.SetItem(nrow,'itclsnm','')
	Case 'itcls'
		s_name = Trim(this.gettext())
		If s_name = '' Or IsNull(s_name) Then
			SetItem(nRow,'itclsnm',sNull)
			Return
		End If
		
      s_itt  = This.GetItemString(row,'ittyp')
      IF s_itt = "" OR IsNull(s_itt) THEN 	
         SetColumn('ittyp')
		   RETURN 2
	   END IF
	
      SELECT "ITNCT"."TITNM"  
        INTO :get_nm  
        FROM "ITNCT"  
       WHERE ( "ITNCT"."ITTYP" = :s_itt ) AND  
             ( "ITNCT"."ITCLS" = :s_name ) ;

	   This.setitem(1, 'itclsnm', get_nm)
		cb_inq.PostEvent(Clicked!)
End Choose

end event

event itemerror;RETURN 1
end event

event rbuttondown;String s_colname,	sIttyp
long nRow

setnull(gs_code)
setnull(gs_gubun)
setnull(gs_codename)

this.accepttext()
nRow = GetRow()

if this.GetColumnName() = 'itcls' then
	sIttyp = This.GetItemString(row,'ittyp')

	OpenWithParm(w_ittyp_popup8, sIttyp)
   lstr_sitnct = Message.PowerObjectParm
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"ittyp",lstr_sitnct.s_ittyp)
	this.SetItem(1,"itcls", lstr_sitnct.s_sumgub)
	this.SetItem(1,"itclsnm", lstr_sitnct.s_titnm)
	this.SetColumn('itcls')
   This.TriggerEvent(Itemchanged!)
end if
 
end event

type dw_detail from datawindow within w_sal_02110
event ue_pressenter pbm_dwnprocessenter
integer x = 3003
integer y = 472
integer width = 1595
integer height = 1852
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_sal_02110_03"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event editchanged;ib_any_typing =True
end event

event itemerror;Return 1
end event

type dw_list from u_d_popup_sort within w_sal_02110
integer x = 55
integer y = 364
integer width = 2880
integer height = 1948
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_sal_02110_02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event clicked;call super::clicked;string s_cvcod,s_itnbr,s_sdate
string s_itdsc,s_ispec
int      nRow

////선택한 행 반전//////////////////////////////////////////////////////////
If 	Row <= 0 then
	dw_1.SelectRow(0,False)
	dw_1.setfocus()
	return
ELSE
	this.SelectRow(0, FALSE)
	this.SelectRow(Row,TRUE)
END IF

////  행을 선택하여 dw_insert로 retrieve             //////////////////////////
////  해당 행에서 키(품번, 적용시작일)를 retrieve    ////////////////////////// 

s_cvcod 	= trim(this.getitemstring(Row, "cvcod"))
s_itnbr 	= this.getitemstring(Row, "itnbr")
s_itdsc 	= this.getitemstring(Row, "itdsc")
s_ispec 	= this.getitemstring(Row, "ispec")
s_sdate 	= this.getitemstring(Row, "start_date")
If 	IsNull(s_itdsc) Then s_itdsc = ''
If 	IsNull(s_ispec) Then s_ispec = ''

If 	s_cvcod = '' Or IsNull(s_cvcod) Then
  	nRow = dw_insert.GetRow()
	If nRow <= 0 Then Return
	
	dw_insert.SetItem(nRow,'itnbr' , s_itnbr )
	dw_insert.SetItem(nRow,'itdsc' , s_itdsc )
	dw_insert.SetItem(nRow,'ispec' , s_ispec )
	dw_insert.Setitem(nRow,'sales_price',0)
	dw_insert.Setitem(nRow,'start_date', f_today())
	dw_insert.Setitem(nRow,'end_date','')
	dw_insert.Setitem(nRow,'dc_rate',0)	

  	wf_key_protect('조회')	
	dw_insert.Modify('start_date.protect = 0')
  	dw_insert.Modify("start_date.background.color = '"+String(Rgb(190,225,184))+"'")	
	dw_insert.SetItemStatus(nRow,0,Primary!, NewModified!)
  	dw_insert.setcolumn('start_date')
Else
	nRow = dw_insert.retrieve(s_cvcod,s_itnbr, s_sdate)        // 기존에 등록된 데이타이면..
  	wf_key_protect('조회')
  	dw_insert.setcolumn('end_date')
End If

dw_insert.setfocus()

SetNull(is_itnbr)

is_itnbr = dw_list.GetItemString(Row,"itnbr")
	
// 품번 세부 사양별 단가 현황.
if 	dw_detail.Retrieve(is_itnbr,'9999', s_cvcod, '3') <= 0 then
	ib_any_typing 	= FALSE	
end if
p_addrow.enabled 	= true
p_delrow.enabled 	= true

p_addrow.PictureName  	= "C:\erpman\image\행추가_up.gif"
p_delrow.PictureName  	= "C:\erpman\image\행삭제_up.gif"

this.SetRedraw(true)

CALL SUPER ::CLICKED 
end event

type pb_1 from u_pb_cal within w_sal_02110
integer x = 2437
integer y = 48
integer width = 78
integer height = 80
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_insert.SetColumn('start_date')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_insert.SetItem(1, 'start_date', gs_code)

end event

type pb_2 from u_pb_cal within w_sal_02110
integer x = 2437
integer y = 132
integer width = 78
integer height = 80
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_insert.SetColumn('end_date')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_insert.SetItem(1, 'end_date', gs_code)
end event

type rr_1 from roundrectangle within w_sal_02110
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 252
integer width = 2930
integer height = 2076
integer cornerheight = 40
integer cornerwidth = 55
end type

