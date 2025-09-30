$PBExportHeader$w_pdm_t_00040.srw
$PBExportComments$원가계산서입력 (사출)
forward
global type w_pdm_t_00040 from w_inherite
end type
type dw_list from datawindow within w_pdm_t_00040
end type
type dw_list2 from datawindow within w_pdm_t_00040
end type
type st_2 from statictext within w_pdm_t_00040
end type
type st_3 from statictext within w_pdm_t_00040
end type
type dw_1 from datawindow within w_pdm_t_00040
end type
type p_1 from uo_picture within w_pdm_t_00040
end type
type p_2 from uo_picture within w_pdm_t_00040
end type
type p_3 from uo_picture within w_pdm_t_00040
end type
type p_4 from uo_picture within w_pdm_t_00040
end type
type rb_insert from radiobutton within w_pdm_t_00040
end type
type rb_delete from radiobutton within w_pdm_t_00040
end type
type rr_3 from roundrectangle within w_pdm_t_00040
end type
type rr_2 from roundrectangle within w_pdm_t_00040
end type
type rr_1 from roundrectangle within w_pdm_t_00040
end type
type rr_4 from roundrectangle within w_pdm_t_00040
end type
type rr_5 from roundrectangle within w_pdm_t_00040
end type
type rr_6 from roundrectangle within w_pdm_t_00040
end type
end forward

global type w_pdm_t_00040 from w_inherite
string title = "설계원가계산서 (사출)"
dw_list dw_list
dw_list2 dw_list2
st_2 st_2
st_3 st_3
dw_1 dw_1
p_1 p_1
p_2 p_2
p_3 p_3
p_4 p_4
rb_insert rb_insert
rb_delete rb_delete
rr_3 rr_3
rr_2 rr_2
rr_1 rr_1
rr_4 rr_4
rr_5 rr_5
rr_6 rr_6
end type
global w_pdm_t_00040 w_pdm_t_00040

type variables
string  ls_gub ='Y'
//str_itnct lstr_sitnct

end variables

forward prototypes
public function integer wf_common ()
public subroutine wf_reset ()
public function integer wf_init ()
public function integer wf_chk ()
public subroutine wf_delete_chk (string seco_no, string sitnbr)
public subroutine wf_all_retrieve (string s_code, string s_code2)
end prototypes

public function integer wf_common ();/*
string	seco_no, sitnbr

seco_no = dw_1.GetItemString(1, "eco_no")
sitnbr = dw_1.GetItemString(1, "itnbr")


dw_insert.SetItem(1, "eco_no", seco_no)
dw_insert.SetItem(1, "itnbr", sitnbr)

*/

RETURN 1
end function

public subroutine wf_reset ();dw_insert.setredraw(false)
dw_insert.reset()
dw_insert.setredraw(true)

dw_list.setredraw(false)
dw_list.reset()
dw_list.setredraw(true)

dw_list2.setredraw(false)
dw_list2.reset()
dw_list2.setredraw(true)

end subroutine

public function integer wf_init ();dw_1.SetRedraw(false)
dw_insert.SetRedraw(false)
dw_list.SetRedraw(false)
dw_list2.SetRedraw(false)

ib_any_typing = FALSE

p_del.enabled = false
p_del.picturename = "C:\erpman\image\삭제_d.gif"
dw_1.enabled = TRUE

//
dw_1.Reset()
dw_insert.Reset()
dw_list.reset()
dw_list2.reset()

dw_1.insertRow(0)
dw_insert.insertRow(0)
//


////////////////////////////////////////////////////////////////////////

IF ls_gub = 'Y'	then

	// 등록시
	p_inq.enabled = false
	p_inq.picturename = "C:\erpman\image\조회_d.gif"
	w_mdi_frame.sle_msg.text = "등록"

ELSE
	p_inq.enabled = true
	p_inq.picturename = "C:\erpman\image\조회_up.gif"
	w_mdi_frame.sle_msg.text = "삭제"
	
END IF

//
dw_insert.Object.cvcod_1.text = ''
dw_1.SetColumn('eco_no')
dw_1.SetFocus()

//
dw_list.SetRedraw(true)
dw_list2.SetRedraw(true)

dw_insert.SetRedraw(true)
dw_1.SetRedraw(true)

return 1



end function

public function integer wf_chk ();String  ls_cvcod, ls_sub1, ls_sub2
Long   ix
Decimal {3} d_calc , d_sum1 , d_sum2 , d_sum3

If dw_insert.AcceptText() <> 1 Then Return -1
dw_1.AcceptText()
dw_list.AcceptText()
dw_list2.AcceptText()

// -------------------------------------------------------------------
// Key Value 확인.
ls_sub1 = dw_1.GetItemString(1,"eco_no")
ls_sub2      = dw_1.GetItemString(1,"itnbr")

IF (IsNull(ls_sub1) OR ls_sub1 = "" ) and   (IsNull(ls_sub2)    OR ls_sub2 = "" )    THEN
	f_message_chk(30,'[ECO NO.]')
     dw_1.SetColumn("eco_no")
	dw_1.SetFocus()
	Return -1
END IF
// 거래처 코드 확인....
ls_cvcod = dw_insert.GetItemString(1, 'cvcod')
f_get_name2("V1", "Y", ls_cvcod, ls_sub1, ls_sub2)

IF (ls_cvcod = '' Or IsNull(ls_cvcod)) and (ls_sub1 = '' Or IsNull(ls_sub1))  THEN
	f_message_chk(40,'[거래처코드]')
	dw_insert.SetColumn('cvcod')
	dw_insert.SetFocus()
	Return -1
END IF





//--------------------------------------------------------------------//
d_calc = 0 ; d_sum1 = 0 ; d_sum2 =0 ;

// -- Master 계산 값 및 금액 구하기.(재료비)
For ix = 1 To dw_list.RowCount()
	d_calc  = dw_list.GetItemDecimal(ix, 'wonfac_1')
     d_sum1  = d_sum1 + d_calc
	  
	IF dw_insert.GetItemString(1,'bill_gu') = '0' then
		d_calc = dw_list.GetItemDecimal(ix, "netamt_1")	
		dw_list.setitem(ix, 'netamt', d_calc)
		d_calc = dw_list.GetItemDecimal(ix, "scrap_1")	
		dw_list.setitem(ix, 'scrap', d_calc)
		d_calc = dw_list.GetItemDecimal(ix, "wonfac_1")	
		dw_list.setitem(ix, 'wonfac', d_calc)
		d_calc = dw_list.GetItemDecimal(ix, "minqt_1")	
		dw_list.setitem(ix, 'minqt', d_calc)
		d_calc = dw_list.GetItemDecimal(ix, "h_dvalue_1")	
		dw_list.setitem(ix, 'h_dvalue', d_calc)
	ELSE
		d_calc = dw_list.GetItemDecimal(ix, "wonfac_1")	
		dw_list.setitem(ix, 'wonfac', d_calc)
	END IF
Next
//
dw_insert.SetItem(1, 'material_amount1', d_sum1)

d_calc = 0 ; d_sum1 = 0 ; d_sum2 =0 ; d_sum3 =0 ;

// -- Master 계산 값 및 금액 구하기.(노무비,경비)
For ix = 1 To dw_list2.RowCount()
	d_calc  = dw_list2.GetItemDecimal(ix, 'labor_cost_1')   //노무비
     d_sum1  = d_sum1 + d_calc
	d_calc  = dw_list2.GetItemDecimal(ix, 'amount_cost_1')   // 경비
     d_sum2  = d_sum2 + d_calc

	IF dw_insert.GetItemString(1,'bill_gu') = '0' then
		d_calc = dw_list2.GetItemDecimal(ix, "cytime_1")	
		dw_list2.setitem(ix, 'cytime', d_calc)
	END IF
	
	d_calc = dw_list2.GetItemDecimal(ix, "labor_cost_1")	
	dw_list2.setitem(ix, 'labor_cost', d_calc)
	d_calc = dw_list2.GetItemDecimal(ix, "amount_cost_1")	
	dw_list2.setitem(ix, 'amount_cost', d_calc)
	d_calc = dw_list2.GetItemDecimal(ix, "l_ct_1")	
	dw_list2.setitem(ix, 'l_ct', d_calc)
Next
//
dw_insert.SetItem(1, 'manage_cost1', d_sum1)
dw_insert.SetItem(1, 'manage_cost2', d_sum2)


// Key Value Move
dw_insert.SetItem(1, 'sabu', gs_sabu)
dw_insert.SetItem(1, 'itnbr', dw_1.GetItemString(1,'itnbr'))
dw_insert.SetItem(1, 'eco_no', dw_1.GetItemString(1,'eco_no'))

// 차종/모델
dw_insert.SetItem(1, 'gritu', dw_1.GetItemString(1, 'gritu') )   


Return 1

end function

public subroutine wf_delete_chk (string seco_no, string sitnbr);
end subroutine

public subroutine wf_all_retrieve (string s_code, string s_code2);Integer   ix
String     ls_cvcod , ls_sub1 , ls_sub2 , sNull
Decimal {3} d_calc

dw_list.retrieve(gs_sabu, s_code,s_code2)
dw_list2.retrieve(gs_sabu,s_code,s_code2)

//
For ix = 1 To dw_list2.RowCount()
  	d_calc = dw_list2.GetItemDecimal(ix, 'minqt')	
Next
//
setNull(sNull)

IF dw_insert.retrieve(gs_sabu, s_code,s_code2) <= 0 THEN
	dw_insert.InsertRow(0)
END IF

p_del.enabled = true

p_del.PictureName  = "C:\erpman\image\삭제_up.gif"

ls_gub = 'N'    //'N'이면 수정모드

ls_cvcod = dw_insert.GetItemString(1,'cvcod' )
	
IF ls_cvcod = '' Or IsNull(ls_cvcod) THEN
      dw_insert.SetItem(1, 'cvcod',sNull)
      dw_insert.Object.cvcod_1.text = ''
	 Return
END IF

f_get_name2("V1", "Y", ls_cvcod, ls_sub1, ls_sub2)
dw_insert.setitem(1, 'cvcod', ls_cvcod)
dw_insert.Object.cvcod_1.text = ls_sub1

dw_insert.SetColumn('cvcod')
dw_insert.SetFocus()

//


end subroutine

on w_pdm_t_00040.create
int iCurrent
call super::create
this.dw_list=create dw_list
this.dw_list2=create dw_list2
this.st_2=create st_2
this.st_3=create st_3
this.dw_1=create dw_1
this.p_1=create p_1
this.p_2=create p_2
this.p_3=create p_3
this.p_4=create p_4
this.rb_insert=create rb_insert
this.rb_delete=create rb_delete
this.rr_3=create rr_3
this.rr_2=create rr_2
this.rr_1=create rr_1
this.rr_4=create rr_4
this.rr_5=create rr_5
this.rr_6=create rr_6
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
this.Control[iCurrent+2]=this.dw_list2
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.dw_1
this.Control[iCurrent+6]=this.p_1
this.Control[iCurrent+7]=this.p_2
this.Control[iCurrent+8]=this.p_3
this.Control[iCurrent+9]=this.p_4
this.Control[iCurrent+10]=this.rb_insert
this.Control[iCurrent+11]=this.rb_delete
this.Control[iCurrent+12]=this.rr_3
this.Control[iCurrent+13]=this.rr_2
this.Control[iCurrent+14]=this.rr_1
this.Control[iCurrent+15]=this.rr_4
this.Control[iCurrent+16]=this.rr_5
this.Control[iCurrent+17]=this.rr_6
end on

on w_pdm_t_00040.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_list)
destroy(this.dw_list2)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.dw_1)
destroy(this.p_1)
destroy(this.p_2)
destroy(this.p_3)
destroy(this.p_4)
destroy(this.rb_insert)
destroy(this.rb_delete)
destroy(this.rr_3)
destroy(this.rr_2)
destroy(this.rr_1)
destroy(this.rr_4)
destroy(this.rr_5)
destroy(this.rr_6)
end on

event open;call super::open;dw_insert.SetTransObject(sqlca)
dw_list.SetTransObject(sqlca)
dw_list2.SetTransObject(sqlca)

dw_insert.setredraw(false)
dw_insert.reset()
dw_insert.insertrow(0)
dw_insert.setredraw(true)

dw_1.SetTransObject(sqlca)

Wf_init()


end event

event key;// Page Up & Page Down & Home & End Key 사용 정의
choose case key
	case keypageup!
		dw_list.scrollpriorpage()
	case keypagedown!
		dw_list.scrollnextpage()
	case keyhome!
		dw_list.scrolltorow(1)
	case keyend!
		dw_list.scrolltorow(dw_list.rowcount())
	case KeyupArrow!
		dw_list.scrollpriorrow()
	case KeyDownArrow!
		dw_list.scrollnextrow()		
end choose


end event

type dw_insert from w_inherite`dw_insert within w_pdm_t_00040
event ue_key pbm_dwnkey
integer x = 59
integer y = 292
integer width = 1577
integer height = 1992
string dataobject = "d_dpm_t_00040_1"
boolean border = false
end type

event dw_insert::ue_key;call super::ue_key;IF keydown(keyF1!)  THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event dw_insert::editchanged;RETURN 1
end event

event dw_insert::itemerror;call super::itemerror;return 1
end event

event dw_insert::updatestart;call super::updatestart;/* Update() function 호출시 user 설정 */
long k, lRowCount

lRowCount = this.RowCount()

FOR k = 1 TO lRowCount
   IF NewModified! = this.GetItemStatus(k, 0, Primary!) THEN
 	   This.SetItem(k,'crt_user',gs_userid)
   ELSEIF DataModified! = this.GetItemStatus(k, 0, Primary!) THEN 		
	   This.SetItem(k,'upd_user',gs_userid)
   END IF	  
NEXT


end event

event dw_insert::getfocus;call super::getfocus;this.AcceptText()
end event

event dw_insert::rbuttondown;call super::rbuttondown;
IF	this.Getcolumnname() = "cvcod"	THEN		
     SetNull(gs_CodeName)
	gs_code = this.GetText()
	IF IsNull(gs_code) THEN gs_code =""
	
	gs_gubun = '1'
	Open(w_vndmst_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then  return

	this.SetItem(1, "cvcod", gs_Code)
	dw_insert	.Object.cvcod_1.text = gs_CodeName
     this.triggerevent(itemchanged!)	
end if



end event

event dw_insert::itemchanged;call super::itemchanged;String	 sNull, ls_cvcod,  ls_sub1, ls_sub2

SetNull(sNull)

//------------------------------------------
IF this.GetColumnName() = 'cvcod' THEN
	
	ls_cvcod = this.GetText()
	
	IF ls_cvcod = '' Or IsNull(ls_cvcod) THEN
		this.SetItem(1, 'cvcod',sNull)
          dw_insert.Object.cvcod_1.text = ''
		Return
	END IF
	
   	f_get_name2("V1", "Y", ls_cvcod, ls_sub1, ls_sub2)
	this.setitem(1, "cvcod", ls_cvcod)
     dw_insert.Object.cvcod_1.text = ls_sub1
END IF

//------------------------------------------
//ls_sub1 = Trim(dw_1.getitemstring(1,'eco_no'))
//ls_sub2 =  Trim(dw_1.getitemstring(1,'itnbr'))

IF this.GetColumnName() = 'bill_gu' THEN
	
	ls_cvcod = trim(this.GetText())
	
	IF ls_cvcod = '0'  THEN
		dw_List.dataobject     	= 'd_dpm_t_00040_2'
		dw_List2.dataobject    	= 'd_dpm_t_00040_3'
	Else
		dw_List.dataobject   	= 'd_dpm_t_00040_22'
		dw_List2.dataobject    	= 'd_dpm_t_00040_32'
	END IF
	dw_list.settransobject(sqlca)
	dw_list2.settransobject(sqlca)
//	wf_all_retrieve(ls_sub1 ,ls_sub2 )
END IF

end event

type p_delrow from w_inherite`p_delrow within w_pdm_t_00040
boolean visible = false
integer x = 5051
integer y = 172
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_pdm_t_00040
boolean visible = false
integer x = 4878
integer y = 172
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_pdm_t_00040
boolean visible = false
integer x = 4873
integer y = 316
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_pdm_t_00040
boolean visible = false
integer x = 4704
integer y = 172
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_pdm_t_00040
end type

type p_can from w_inherite`p_can within w_pdm_t_00040
integer x = 4261
end type

event p_can::clicked;call super::clicked;wf_init()


end event

type p_print from w_inherite`p_print within w_pdm_t_00040
boolean visible = false
integer x = 5047
integer y = 316
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_pdm_t_00040
integer x = 3712
end type

event p_inq::clicked;call super::clicked;String seco_no, sitnbr

dw_1.AcceptText()
seco_no = dw_1.object.eco_no[1]
sitnbr      = dw_1.object.itnbr[1]
IF IsNull(seco_no)	 or  seco_no = ''	THEN
	MessageBox("확 인", "ECO NO. 를 먼저 입력하세요.")
	dw_1.SetColumn("eco_no")
	dw_1.SetFocus()
	RETURN
END IF

dw_1.enabled = false
p_del.enabled = true
p_del.picturename = "C:\erpman\image\삭제_up.gif"

dw_insert.SetColumn("bill_gu")
dw_insert.SetFocus()




end event

type p_del from w_inherite`p_del within w_pdm_t_00040
integer x = 4078
boolean enabled = false
string picturename = "C:\erpman\image\삭제_d.gif"
end type

event p_del::ue_lbuttondown;call super::ue_lbuttondown;pictureName = "C:\erpman\image\삭제_dn.gif"
end event

event p_del::ue_lbuttonup;call super::ue_lbuttonup;pictureName = "C:\erpman\image\삭제_up.gif"
end event

event p_del::clicked;call super::clicked;String sEco_no , sItnbr

sEco_no	= Trim(dw_1.GetItemString(1,'eco_no'))
sItnbr  	= Trim(dw_1.GetItemString(1,'itnbr'))

If f_msg_delete() = -1 then return


// 노무비
DELETE FROM ESTILIST_LABOR 
    WHERE SABU = :gs_sabu AND ECO_NO = :sEco_no AND ITNBR = :sItnbr;
If sqlca.sqlcode <> 0 Then
	RollBack;
	f_message_chk(31,'ESTILIST_LABOR')
	wf_init()
	Return
End If

// 재료비
DELETE FROM ESTILIST_MATERIAL
    WHERE SABU = :gs_sabu AND ECO_NO = :sEco_no AND ITNBR = :sItnbr;
If sqlca.sqlcode <> 0 Then
	RollBack;
	f_message_chk(31,'ESTILIST_MATERIAL')
	wf_init()
	Return
End If

//MASTER
DELETE FROM ESTILIST 
    WHERE SABU = :gs_sabu AND ECO_NO = :sEco_no AND ITNBR = :sItnbr;
If sqlca.sqlcode <> 0 Then
	RollBack;
	f_message_chk(31,'ESTILIST')
	wf_init()
	Return
End If


COMMIT;
wf_init()

w_mdi_frame.sle_msg.text = '자료를 삭제하였습니다!!'
end event

type p_mod from w_inherite`p_mod within w_pdm_t_00040
integer x = 3895
end type

event p_mod::clicked;call super::clicked;
string sValue

//----- DATA 입력부분  확인....

If wf_chk() <> 1 Then Return 

IF MessageBox("확인", "저장 하시겠습니까?", question!, yesno!) = 2	THEN	RETURN

// key 값 Move

IF dw_list.update() <= 0 	THEN
	ROLLBACK;
	RETURN
END IF
		
IF dw_list2.update() <= 0	THEN
	ROLLBACK;
	RETURN
END IF


// 원가계산서 Master 저장	
IF dw_insert.update() > 0 	THEN
	COMMIT USING sqlca;
	p_inq.triggerevent(clicked!)
	w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
ELSE
	ROLLBACK USING sqlca;
	f_message_chk(32,'')
	Return
END IF

p_inq.triggerevent(clicked!)
p_del.enabled = false
p_del.picturename = "C:\erpman\image\삭제_d.gif"

ib_any_typing = FALSE

end event

type cb_exit from w_inherite`cb_exit within w_pdm_t_00040
end type

type cb_mod from w_inherite`cb_mod within w_pdm_t_00040
end type

type cb_ins from w_inherite`cb_ins within w_pdm_t_00040
end type

type cb_del from w_inherite`cb_del within w_pdm_t_00040
end type

type cb_inq from w_inherite`cb_inq within w_pdm_t_00040
end type

type cb_print from w_inherite`cb_print within w_pdm_t_00040
end type

type st_1 from w_inherite`st_1 within w_pdm_t_00040
end type

type cb_can from w_inherite`cb_can within w_pdm_t_00040
end type

type cb_search from w_inherite`cb_search within w_pdm_t_00040
end type







type gb_button1 from w_inherite`gb_button1 within w_pdm_t_00040
end type

type gb_button2 from w_inherite`gb_button2 within w_pdm_t_00040
end type

type dw_list from datawindow within w_pdm_t_00040
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 1714
integer y = 492
integer width = 2875
integer height = 724
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_dpm_t_00040_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_key;if keydown(KeyEnter!) AND this.getcolumnname() = "h_height" then
//   if this.rowcount() = this.getrow() then
//      postevent(clicked!)
//      return 1
//   end if
end if


end event

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event editchanged;ib_any_typing =True
end event

event itemchanged;Int lRow, lReturnRow
string s_citdsc, sNull, get_itdsc, get_jijil, get_ispec, get_unmsr, get_wonprc, get_itgu
decimal {3} d_wonfac , d_calc

SetNull(snull)
dw_list.AcceptText()
lRow  = this.GetRow()	
IF this.GetColumnName() = "citdsc" THEN
	s_citdsc = this.GetText()								
	
	lReturnRow = This.Find("citdsc = '"+s_citdsc+"' ", 1, This.RowCount())
	IF (lRow <> lReturnRow) and (lReturnRow <> 0) THEN
		messagebox('확 인','등록된 부품명입니다.') 
		RETURN  1
	END IF
END IF


//Choose Case GetColumnName()
//	Case	"netamt_1" 
//		d_wonfac = this.GetItemDecimal(lrow, "netamt_1")	
//		this.setitem(lrow, 'netamt', d_wonfac)
//	Case	"scrap_1" 
//		d_wonfac = this.GetItemDecimal(lrow, "scrap_1")	
//		this.setitem(lrow, 'scrap', d_wonfac)
//	Case	"wonfac_1" 
//		d_wonfac = this.GetItemDecimal(lrow, "wonfac_1")	
//		this.setitem(lrow, 'wonfac', d_wonfac)
//	Case	"minqt_1" 
//		d_wonfac = this.GetItemDecimal(lrow, "minqt_1")	
//		this.setitem(lrow, 'minqt', d_wonfac)
//	Case	"h_dvalue_1" 
//		d_wonfac = this.GetItemDecimal(lrow, "h_dvalue_1")	
//		this.setitem(lrow, 'h_dvalue', d_wonfac)
//End Choose
//


end event

event itemerror;return 1
end event

event getfocus;this.AcceptText()
end event

type dw_list2 from datawindow within w_pdm_t_00040
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 1714
integer y = 1540
integer width = 2875
integer height = 732
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_dpm_t_00040_3"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_key;if keydown(KeyEnter!) AND this.getcolumnname() = "work_cost" then
   if this.rowcount() = this.getrow() then
      postevent(clicked!)
      return 1
   end if
end if


end event

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemchanged;Int lRow, lReturnRow
string s_name, sNull, get_rfna1
decimal {3} d_decimal

SetNull(snull)

IF this.GetColumnName() = "citdsc" THEN
	lRow  = this.GetRow()	
	s_name = this.GetText()								
    
	if s_name = "" or isnull(s_name) then 
		f_message_chk(30,'[citdsc]')
	     dw_insert.SetColumn("citdsc")
		dw_insert.SetFocus()
		Return 1	
	end if
	 
	lReturnRow = This.Find("citdsc = '"+s_name+"' ", 1, This.RowCount())

	IF (lRow <> lReturnRow) and (lReturnRow <> 0) THEN
		messagebox('확 인','등록된 부품명 입니다. ') 
		RETURN  1
	END IF
END IF


end event

event dberror;Beep(1)
IF f_message_chk(sqldbcode,'['+String(row)+'라인 ]') = -1 THEN
	Return
ELSE
	Return -1
END IF
end event

event editchanged;ib_any_typing =True
end event

event itemerror;return 1
end event

event getfocus;this.AcceptText()
end event

type st_2 from statictext within w_pdm_t_00040
integer x = 1714
integer y = 292
integer width = 402
integer height = 48
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 32106727
string text = "1) 재료비"
long bordercolor = 16711680
boolean focusrectangle = false
end type

type st_3 from statictext within w_pdm_t_00040
integer x = 1714
integer y = 1344
integer width = 402
integer height = 48
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 32106727
string text = "2) 노무비"
long bordercolor = 16711680
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_pdm_t_00040
event ue_key pbm_dwnkey
integer x = 37
integer y = 28
integer width = 2098
integer height = 208
integer taborder = 90
boolean bringtotop = true
string title = "none"
string dataobject = "d_dpm_t_00040_0"
boolean border = false
boolean livescroll = true
boolean righttoleft = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;
String	ls_eco_no, ls_itnbr, ls_sub1, ls_sub2, ls_nm
this.AcceptText()
//------------------------------------------Eco No
IF GetColumnName() = 'eco_no' THEN
	
	ls_eco_no = this.GetText()
	
	IF ls_eco_no = '' Or IsNull(ls_eco_no) THEN
		SetItem(1, 'itdsc','')
		SetItem(1, 'rfna1','')
		SetITem(1, 'gritu', '')	
		SetItem(1, 'itnbr','')
		Return
	END IF
	
	ls_itnbr =  Trim(dw_1.getitemstring(1,'itnbr'))
	

	Select	     b.itdsc  ,    b.gritu , c.rfna1      
	Into		:ls_sub1,  :ls_sub2, :ls_nm
	From		ecomst a , itemas b, reffpf c
	Where		a.eco_no =  :ls_eco_no
	and		a.itnbr =  :ls_itnbr
	and		a.itnbr = b.itnbr
	and		b.useyn = '0'	
	and		b.gritu = c.rfgub
	and		c.rfcod = '01' ;

	IF sqlca.SqlCode <> 0 THEN
		MessageBox('확인', '등록되지 않은 ECO NO. 입니다.')
		SetItem(1, 'itdsc','')
		SetItem(1, 'rfna1','')
		SetITem(1, 'gritu', '')	
		SetItem(1, 'itnbr','')
		SetItem(1, 'eco_no','')
		Return 1
	END IF

	SetITem(1, 'itdsc', ls_sub1)
	SetITem(1, 'gritu',  ls_sub2)	
	SetITem(1, 'rfna1',  ls_nm)	
	
	wf_all_retrieve(ls_eco_no ,ls_itnbr )
END IF

end event

event itemerror;return 1
end event

event rbuttondown;String seco_no, snull

SetNull(snull)

this.AcceptText()

//++ ECO NO  +++++++++++++++++++++++++++++++++++++++++++++++++++
IF this.GetColumnName() = "eco_no" THEN
	
     SetNull(gs_code)
	SetNull(gs_codename)
	
	Open(W_Ecomst_PopUp)
	
	IF IsNull(gs_code) THEN Return
	
	this.SetItem(1,"eco_no",gs_code)
	this.SetItem(1,"itnbr",     gs_codename)
	
	this.TriggerEvent(ItemChanged!)
ELSEIF this.GetColumnName() = "itnbr" THEN

     SetNull(gs_code)
	SetNull(gs_codename)
	
	Open(w_itemas_popup)
	
	this.SetItem(this.GetRow(),"itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)
END IF

ib_any_typing = True
end event

event losefocus;if this.accepttext() = -1 then return 
end event

type p_1 from uo_picture within w_pdm_t_00040
integer x = 4064
integer y = 308
integer width = 178
integer taborder = 10
boolean bringtotop = true
string pointer = "C:\erpman\cur\retrieve.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\행추가2_up.gif"
end type

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\행추가2_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\행추가2_dn.gif'
end event

event clicked;call super::clicked;Int    il_currow,il_RowCount  
String s_code, s_nm, s_Itnbr, s_Eco_no

dw_1.accepttext()

s_Eco_no = dw_1.GetItemString(1,"eco_no")
s_Itnbr      = dw_1.GetItemString(1,"itnbr")
s_nm        =  dw_1.GetItemString(1,"itdsc")

IF (IsNull(s_Eco_no) OR s_Eco_no = "" ) and   (IsNull(s_nm)    OR s_nm = "" )    THEN
	f_message_chk(30,'[ECO NO.]')
     dw_1.SetColumn("eco_no")
	dw_1.SetFocus()
	Return
END IF

IF dw_list.RowCount() <=0 THEN
	il_currow = 0
	il_rowCount = 0
ELSE
	il_currow = dw_list.GetRow()
	il_RowCount = dw_list.RowCount()
	
	IF il_currow <=0 THEN
		il_currow = il_rowCount
	END IF

END IF

il_currow = il_rowCount + 1

s_code = string(il_currow)

dw_list.InsertRow(il_currow)
dw_list.SetItem(il_currow,"dtlseq",s_code)
// Key Value Move
dw_list.SetItem(1, 'sabu', gs_sabu)
dw_list.SetItem(1, 'itnbr', s_Itnbr)
dw_list.SetItem(1, 'eco_no', s_Eco_no)

dw_list.ScrollToRow(il_currow)
dw_list.SetColumn("citdsc")
dw_list.SetFocus()

end event

type p_2 from uo_picture within w_pdm_t_00040
integer x = 4261
integer y = 308
integer width = 178
integer taborder = 10
boolean bringtotop = true
string pointer = "C:\erpman\cur\retrieve.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\행삭제2_up.gif"
end type

event ue_lbuttonup;call super::ue_lbuttonup;pictureName = "C:\erpman\image\행삭제2_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\행삭제2_dn.gif'
end event

event clicked;call super::clicked;dw_list.AcceptText()

IF dw_list.GetRow() <=0 THEN
	f_message_chk(36,'')
	Return
END IF

dw_list.DeleteRow(0)

dw_list.ScrollToRow(dw_list.RowCount())
dw_list.Setfocus()

end event

type p_3 from uo_picture within w_pdm_t_00040
integer x = 4064
integer y = 1356
integer width = 178
integer taborder = 10
boolean bringtotop = true
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\행추가2_up.gif"
end type

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\행추가2_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\행추가2_dn.gif'
end event

event clicked;call super::clicked;Int    il_currow,il_RowCount  , ix , il_no
String s_code, s_nm, s_Eco_no, s_Itnbr
Decimal {3} d_Calc 

dw_1.accepttext()

s_Eco_no = dw_1.GetItemString(1,"eco_no")
s_Itnbr      = dw_1.GetItemString(1,"itnbr")

IF (IsNull(s_Eco_no) OR s_Eco_no = "" ) and   (IsNull(s_nm)    OR s_nm = "" )    THEN
	f_message_chk(30,'[ECO NO.]')
     dw_1.SetColumn("eco_no")
	dw_1.SetFocus()
	Return
END IF



//--- 노부비 관련 순번 확인...
dw_list.SetFocus()
For ix = 1 To dw_list.RowCount()
	s_Code  = Trim(dw_list.GetItemString(ix, 'dtlseq2'))
	
	If IsNull(s_code) or s_code = '' Then
		f_message_chk(40,'[노무비번호]')
		dw_list.ScrollToRow(ix)
		dw_list.SetColumn('dtlseq2')
		dw_list.SetFocus()
		Return -1
	End If
Next


IF dw_list2.RowCount() <=0 THEN
	il_currow = 0
	il_rowCount = 0
ELSE
	il_currow = dw_list2.GetRow()
	il_RowCount = dw_list2.RowCount()
	
	IF il_currow <=0 THEN
		il_currow = il_rowCount
	END IF

END IF


il_currow = il_rowCount + 1
s_code = string(il_currow)

dw_list2.InsertRow(il_currow)
dw_list2.SetItem(il_currow,"dtlseq2",s_code)

// Key Value Move
dw_list2.SetItem(1, 'sabu', gs_sabu)
dw_list2.SetItem(1, 'itnbr', s_Itnbr)
dw_list2.SetItem(1, 'eco_no', s_Eco_no)

//--------------------------------------------------------------------------//
IF  dw_insert.GetItemString(1,'bill_gu') = '0' Then
	// Shot 중량 , Cavity Data Move
	d_Calc = 0 ; il_no = 0
	For ix = 1 To dw_list.RowCount()
		if string(il_currow) = trim(dw_list.GetItemString(ix, 'dtlseq2')) then
			d_Calc  = d_Calc + dw_list.GetItemDecimal(ix, 'minqt')
			il_no     = dw_list.GetItemDecimal(ix, 'cavity')
		End if
	Next
	dw_list2.SetItem(il_currow, 'MINQT', d_calc)
	dw_list2.SetItem(il_currow, 'l_cavity', il_no)
ELSE	
	dw_list2.SetItem(il_currow, 'l_cavity', 1)
END IF
//--------------------------------------------------------------------------//
dw_list2.ScrollToRow(il_currow)
dw_list2.SetColumn("citdsc")
dw_list2.SetFocus()

end event

type p_4 from uo_picture within w_pdm_t_00040
integer x = 4261
integer y = 1356
integer width = 178
integer taborder = 10
boolean bringtotop = true
string pointer = "C:\erpman\cur\retrieve.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\행삭제2_up.gif"
end type

event clicked;call super::clicked;dw_list2.AcceptText()

IF dw_list2.GetRow() <=0 THEN
	f_message_chk(36,'')
	Return
END IF

dw_list2.DeleteRow(0)

dw_list2.ScrollToRow(dw_list2.RowCount())
dw_list2.Setfocus()

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\행삭제2_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;pictureName = "C:\erpman\image\행삭제2_up.gif"
end event

type rb_insert from radiobutton within w_pdm_t_00040
boolean visible = false
integer x = 2203
integer y = 136
integer width = 251
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "등록"
boolean checked = true
end type

event clicked;
ls_gub = 'Y'	// 등록

wf_Init()
end event

type rb_delete from radiobutton within w_pdm_t_00040
boolean visible = false
integer x = 2478
integer y = 136
integer width = 251
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "수정"
end type

event clicked;ls_gub = 'N'	// 수정

wf_Init()
end event

type rr_3 from roundrectangle within w_pdm_t_00040
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 264
integer width = 1623
integer height = 2044
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdm_t_00040
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1701
integer y = 284
integer width = 2903
integer height = 972
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_pdm_t_00040
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1701
integer y = 1332
integer width = 2903
integer height = 972
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_4 from roundrectangle within w_pdm_t_00040
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 4027
integer y = 296
integer width = 439
integer height = 176
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_5 from roundrectangle within w_pdm_t_00040
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 4027
integer y = 1344
integer width = 439
integer height = 176
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_6 from roundrectangle within w_pdm_t_00040
boolean visible = false
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 2176
integer y = 104
integer width = 567
integer height = 116
integer cornerheight = 40
integer cornerwidth = 55
end type

