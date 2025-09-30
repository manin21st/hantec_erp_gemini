$PBExportHeader$w_pdm_t_00010.srw
$PBExportComments$ECO MASTER 등록
forward
global type w_pdm_t_00010 from w_inherite
end type
type dw_list from datawindow within w_pdm_t_00010
end type
type pb_1 from u_pb_cal within w_pdm_t_00010
end type
type pb_2 from u_pb_cal within w_pdm_t_00010
end type
type pb_3 from u_pb_cal within w_pdm_t_00010
end type
type pb_4 from u_pb_cal within w_pdm_t_00010
end type
type pb_5 from u_pb_cal within w_pdm_t_00010
end type
type pb_6 from u_pb_cal within w_pdm_t_00010
end type
type pb_7 from u_pb_cal within w_pdm_t_00010
end type
type pb_8 from u_pb_cal within w_pdm_t_00010
end type
type pb_9 from u_pb_cal within w_pdm_t_00010
end type
type pb_10 from u_pb_cal within w_pdm_t_00010
end type
type pb_11 from u_pb_cal within w_pdm_t_00010
end type
type pb_12 from u_pb_cal within w_pdm_t_00010
end type
type rr_1 from roundrectangle within w_pdm_t_00010
end type
end forward

global type w_pdm_t_00010 from w_inherite
string title = "ECO MASTER"
dw_list dw_list
pb_1 pb_1
pb_2 pb_2
pb_3 pb_3
pb_4 pb_4
pb_5 pb_5
pb_6 pb_6
pb_7 pb_7
pb_8 pb_8
pb_9 pb_9
pb_10 pb_10
pb_11 pb_11
pb_12 pb_12
rr_1 rr_1
end type
global w_pdm_t_00010 w_pdm_t_00010

type variables
char  ic_Status

// 자료변경여부 검사
string     is_key1, is_key2, is_pitem
end variables

forward prototypes
public subroutine wf_query ()
public function integer wf_confirm_key ()
public function integer wf_required_chk ()
public subroutine wf_initial ()
public function integer wf_delete_chk (string sitnbr, string seco_no)
end prototypes

public subroutine wf_query ();w_mdi_frame.sle_msg.text = "조회"
ic_Status = '2'

dw_insert.SetFocus()
	
p_ins.enabled = false						
p_del.enabled = true

p_ins.PictureName = 'C:\erpman\image\추가_d.gif'
p_del.PictureName = 'C:\erpman\image\삭제_up.gif'

end subroutine

public function integer wf_confirm_key ();/*=====================================================================
		1.	등록 mode : Key 검색
		2. 사용순서 중복여부 확인
		2. Argument : None
		3.	Return Value
			( -1 ) : 등록된 코드 
			(  1 ) : 신  규 코드
=====================================================================*/
string	sConfirm
int		iCount			

is_Key1 = dw_insert.GetItemString(1, "itnbr")
is_Key2 = dw_insert.GetItemString(1, "eco_no")

  SELECT "ECO_NO"  
    INTO :sConfirm  
    FROM "ECOMST"  
   WHERE ( "ITNBR" = :is_key1 ) AND  
         ( "ECO_NO" = :is_key2 )   ;
			
IF sqlca.sqlcode = 0 	then
	messagebox("확인","등록된 코드입니다.~r등록할 수 없습니다.", 		&
						stopsign!)
	dw_insert.setcolumn('itnbr')
	dw_insert.SetFocus()
	RETURN  -1 
END IF

RETURN  1


end function

public function integer wf_required_chk ();String ls_itnbr, s_itdsc, s_ispec, sDate

ls_itnbr 	= dw_insert.GetItemString(1,'itnbr')

if 	f_get_name2('품번', 'Y', ls_itnbr, s_itdsc, s_ispec) <> 0 then
	dw_insert.setcolumn('itnbr')
	dw_insert.setfocus()
	return -1
end if

sDate 	= dw_insert.GetItemString(1,'eco_date')
If	isNull(sDate) or sDate = "" 	then 
	f_message_chk(33,'[ ECO 일자 ]')
	return -1    // Skip.....
End If

IF f_datechk(sDate) = -1 THEN
	f_message_chk(35,'[ECO 일자 ]')
	Return -1
End If		

//if	dw_insert.object.t_cvcod1.visible 	= 1 then
	ls_itnbr = dw_insert.GetItemString(1,'cvcod_1')
	
If	isNull(ls_itnbr) or ls_itnbr = "" 	then 
	f_message_chk(33,'[ 요구업체 ]')
	return -1    // Skip.....
End If
	
if f_get_name2('V1', 'Y', ls_itnbr, s_itdsc, s_ispec) <> 0 then
	dw_insert.setcolumn('cvcod_1')
	dw_insert.setfocus()
	return -1
end if
//End If

return 1
end function

public subroutine wf_initial ();ib_any_typing = false

string	sName, sItem
//sItem = dw_insert.GetItemString(1, "itnbr")
//sName	= dw_insert.GetItemString(1, "itdsc")

p_can.TriggerEvent("clicked")

//dw_insert.SetItem(1, "itnbr", sitem)
//dw_insert.SetItem(1, "itdsc", sName)

//dw_list.Retrieve(sitem)

dw_insert.SetColumn("itnbr")
dw_insert.SetFocus()

end subroutine

public function integer wf_delete_chk (string sitnbr, string seco_no);long  l_cnt

SELECT COUNT(*)
  INTO :l_cnt
  FROM "ECOMST"  
 WHERE ( "ECOMST"."ITNBR" = :sItnbr ) AND ( "ECOMST"."ECO_NO" = :seco_no );

if sqlca.sqlcode <> 0 or l_cnt >= 1 then
	f_message_chk(38,'[ECO MASTER]')
	return -1
end if

return 1
end function

on w_pdm_t_00010.create
int iCurrent
call super::create
this.dw_list=create dw_list
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_3=create pb_3
this.pb_4=create pb_4
this.pb_5=create pb_5
this.pb_6=create pb_6
this.pb_7=create pb_7
this.pb_8=create pb_8
this.pb_9=create pb_9
this.pb_10=create pb_10
this.pb_11=create pb_11
this.pb_12=create pb_12
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.pb_2
this.Control[iCurrent+4]=this.pb_3
this.Control[iCurrent+5]=this.pb_4
this.Control[iCurrent+6]=this.pb_5
this.Control[iCurrent+7]=this.pb_6
this.Control[iCurrent+8]=this.pb_7
this.Control[iCurrent+9]=this.pb_8
this.Control[iCurrent+10]=this.pb_9
this.Control[iCurrent+11]=this.pb_10
this.Control[iCurrent+12]=this.pb_11
this.Control[iCurrent+13]=this.pb_12
this.Control[iCurrent+14]=this.rr_1
end on

on w_pdm_t_00010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_list)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.pb_4)
destroy(this.pb_5)
destroy(this.pb_6)
destroy(this.pb_7)
destroy(this.pb_8)
destroy(this.pb_9)
destroy(this.pb_10)
destroy(this.pb_11)
destroy(this.pb_12)
destroy(this.rr_1)
end on

event open;call super::open;dw_insert.SetTransObject(sqlca)
dw_list.SetTransObject(sqlca)

dw_insert.insertrow(0)
//
dw_insert.setcolumn("itnbr")
dw_insert.setfocus()
//// 등록
//p_ins.TriggerEvent("clicked")

//IF gs_gubun = 'ATTENTION' AND gs_code > '.' THEN 
//	string sitdsc, seco_no
//
//   SELECT ECO_NO
//	  INTO :seco_no
//	  FROM ECOMST
//	 WHERE ITNBR = :gs_code ;
//
//   if sqlca.sqlcode = 0 then 
//		dw_insert.setitem(1, "itnbr", gs_code)	
////		dw_insert.setitem(1, "itdsc", sitdsc)	
//		dw_insert.setitem(1, "eco_no", seco_no)
//		dw_list.Retrieve(gs_code)
//	END IF
//	gs_gubun = ''
//	gs_code  = ''
//END IF
//

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

type dw_insert from w_inherite`dw_insert within w_pdm_t_00010
integer x = 69
integer y = 192
integer width = 4434
integer height = 1308
string dataobject = "d_pdm_t_00010_1"
boolean border = false
end type

event dw_insert::rbuttondown;call super::rbuttondown;Long	ll_row

setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)
setnull(gsbom)

ll_row = getrow()

IF 	this.GetColumnName() = "itnbr"	THEN   //품번에서 rButton
	gs_code = this.GetText()
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then return
	this.SetItem(1, "itnbr", gs_code)
   	this.triggerevent(itemchanged!)

ELSEIF 	this.GetColumnName() = "eco_no"	THEN   //Eco No
     SetNull(gs_code)
	SetNull(gs_codename)
	
	Open(W_Ecomst_PopUp)
	IF 	IsNull(gs_code) or gs_code = "" THEN Return

	this.SetItem(1,"eco_no",gs_code)
	this.SetItem(1,"itnbr",     gs_codename)
	this.TriggerEvent(ItemChanged!)

ELSEIF this.GetColumnName() = "itnbr_2"	THEN //이전 품번에서 rButton
//	gs_codename = this.GetText()
	gs_code = this.GetText()
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then return
	this.SetItem(1, "itnbr_2", gs_code)

ELSEIF this.GetColumnName() = "develop_user"	THEN //개발 담당에서 rButton
//	gs_codename = this.GetText()
	open(w_sawon_popup)
	if isnull(gs_code) or gs_code = "" then return
	this.SetItem(1, "develop_user", gs_code)
	this.SetItem(1, "dev_name", gs_codename)

ELSEIF this.GetColumnName() = "insemp"	THEN  //품질 담당에서 rButton
//	gs_codename = this.GetText()
	open(w_sawon_popup)
	if isnull(gs_code) or gs_code = "" then return
	this.SetItem(1, "insemp", gs_code)
	this.SetItem(1, "emp_name", gs_codename)

ELSEIF this.GetColumnName() = "cvcod_1"	THEN  //요구업체1에서 rButton
	open(w_vndmst_popup)
	if isnull(gs_codename) or gs_codename = "" then return
	this.SetItem(1, "cvcod_1", gs_code)
	this.SetItem(1, "cvc_name1", gs_codename)

ELSEIF this.GetColumnName() = "cvcod_2"	THEN  //요구업체2에서 rButton
	open(w_vndmst_popup)
	if isnull(gs_code) or gs_code = "" then return
	this.SetItem(1, "cvcod_2", gs_code)
	this.SetItem(1, "cvc_name2", gs_codename)

END IF




end event

event dw_insert::itemchanged;call super::itemchanged;w_mdi_frame.sle_msg.text = ''

string		sNull, sOpseq, s_ispec, s_itdsc, s_jijil, s_ispec_code, sroslt, sname, sitem, sname2, ls_mdljijil, ls_vhmodel, ls_rfgub
String		sDate
integer  	ireturn 
Long		nRow

SetNull(sNull)

nRow = Getrow()
If 	nRow <= 0 Then Return

Choose Case this.GetColumnName()
	Case	"itnbr"	
		is_pItem = this.GetText()
		
		SELECT i.itdsc, R.RFNA1 || ' / ' || R1.RFNA1 VHMODEL, i.gritu
		INTO  :sname, :ls_vhmodel, :ls_rfgub
		FROM  itemas i,
				( SELECT RFNA1, RFGUB FROM REFFPF WHERE RFCOD = '01' ) R,
				( SELECT RFNA1, RFGUB FROM REFFPF WHERE RFCOD = '1F' ) R1
		WHERE i.GRITU = R.RFGUB (+)
		AND   i.GRITU = R1.RFGUB (+)
		AND	i.itnbr = :is_pitem;
	
		if 	sqlca.sqlcode <> 0 then            // 0 : 정상 , -1 : Error , 100 : Not found
			messageBox('확인','등록되지 않은 품번입니다.')
			this.setitem(1, "itnbr", '')	
			dw_insert.setfocus()
			dw_insert.setcolumn(1)
			return 1
		end if
	
		this.setitem(1, "itnbr", is_pitem)
		this.setitem(1, "itnbr_name", sname)
		this.setitem(1, "rfgub", ls_rfgub)
		this.setitem(1, "vhmodel", ls_vhmodel)
		
		dw_list.retrieve(is_pitem)
		dw_insert.setfocus()
		dw_insert.setcolumn(2)
	Case	"eco_no"
		is_pItem = this.GetText()
			Select   a.itnbr 
			Into		:s_itdsc
		    		From  ecomst a 
    				Where a.eco_no =  :is_pItem;
		
			IF 	sqlca.SqlCode <> 0 THEN
				MessageBox('확인', '등록되지 않은 ECO NO. 입니다.~r신규 입력이 가능합니다.')
//				SetItem(1, 'eco_no','')
//				Return 1
			END IF
		
//			SetITem(1, 'itnbr', s_itdsc)
//	 	-- 일자 입력  확인.	
	Case	"receipt_date" , "eco_date", "apply_rdate", "apply_cdate", "draw_rdate", "draw_sdate", "other_sdate", "other_rdate", "isir_pdate", "isir_rdate", "tech_rdate", "tech_sdate"
		sDate 	= this.GetText()
		If	isNull(sDate) or sDate = "" 	then return    // Skip.....
		IF 	f_datechk(sDate) = -1 THEN
			f_message_chk(35,'[ ' + GetColumnName ( ) + ' ]')
			Return 1
		End If		
	Case	"ekind"
		sDate	= this.GetText()
		dw_insert.object.t_cvcod1.visible 	= false
		If 	sDate = '0' 	then	dw_insert.object.t_cvcod1.visible = true

	Case	"develop_user"
		is_pitem	= this.GetText()
		if 	f_get_name2('사번', 'Y', is_pitem, s_itdsc, s_ispec) <> 0 then
			dw_insert.setcolumn('cvcod_1')
			dw_insert.setfocus()
			return -1
		end if
		SetItem(1,"dev_name",   s_itdsc)
	Case	"insemp"
		is_pitem	= this.GetText()
		if 	f_get_name2('사번', 'Y', is_pitem, s_itdsc, s_ispec) <> 0 then
			dw_insert.setcolumn('cvcod_1')
			dw_insert.setfocus()
			return -1
		end if
		SetItem(1,"epm_name",   s_itdsc)
	Case	"cvcod_1"
		is_pitem	= this.GetText()
		if f_get_name2('V1', 'Y', is_pitem, s_itdsc, s_ispec) <> 0 then
			dw_insert.setcolumn('cvcod_1')
			dw_insert.setfocus()
			return -1
		end if
		SetItem(1,"cvc_name1",   s_itdsc)
	Case	"cvcod_2"
		is_pitem	= this.GetText()
		if f_get_name2('V1', 'Y', is_pitem, s_itdsc, s_ispec) <> 0 then
			dw_insert.setcolumn('cvcod_2')
			dw_insert.setfocus()
			return -1
		end if
		SetItem(1,"cvc_name2",   s_itdsc)
End Choose
end event

event dw_insert::itemerror;call super::itemerror;return 1
end event

type p_delrow from w_inherite`p_delrow within w_pdm_t_00010
boolean visible = false
integer x = 5463
integer y = 268
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_pdm_t_00010
boolean visible = false
integer x = 5289
integer y = 268
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_pdm_t_00010
boolean visible = false
integer x = 4928
integer y = 268
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_pdm_t_00010
boolean visible = false
integer x = 4677
integer y = 464
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_pdm_t_00010
integer x = 4448
end type

type p_can from w_inherite`p_can within w_pdm_t_00010
integer x = 4261
end type

event p_can::clicked;call super::clicked;ic_status = '1'

///////////////////////////////////////////////
dw_insert.setredraw(false)

dw_insert.reset()

dw_insert.insertrow(0)

dw_insert.setcolumn("itnbr")
dw_insert.SetFocus()

dw_insert.setredraw(true)

dw_insert.Object.itnbr.Protect = False
dw_insert.Object.eco_no.Protect = False

///////////////////////////////////////////////

p_del.enabled = false

p_del.PictureName = 'C:\erpman\image\삭제_d.gif'

ib_any_typing = false


dw_list.ReSet()
//



end event

type p_print from w_inherite`p_print within w_pdm_t_00010
boolean visible = false
integer x = 5102
integer y = 268
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_pdm_t_00010
integer x = 3712
end type

event p_inq::clicked;String	ls_itnbr, ls_eco_no, ls_name, ls_mdljijil, sname, ls_vhmodel, ls_rfgub
String	s_itdsc, s_ispec

ib_any_typing = false	

IF dw_insert.AcceptText() = -1 THEN return -1

ls_itnbr  		= dw_insert.getitemstring(1,'itnbr')
ls_eco_no 	= dw_insert.getitemstring(1,'eco_no')

IF	f_get_name2('품번', 'Y', ls_itnbr, s_itdsc, s_ispec) <> 0 then
	dw_insert.setcolumn('itnbr')
	dw_insert.setfocus()
	return 
end if

if dw_insert.retrieve(ls_itnbr, ls_eco_no) <  1 Then 
	dw_insert.insertRow(0)
	dw_insert.SetItem(1, 'itnbr', ls_itnbr)
	dw_insert.SetItem(1, 'eco_no', ls_eco_no)
	f_message_chk(50,'[Eco 마스타]')
	return 1
End If

dw_list.Retrieve(ls_itnbr)

IF dw_list.rowCount() <= 0 THEN
	MessageBox("확인", "등록된 ECO No가 없습니다.")
	dw_insert.setcolumn('itnbr')
	dw_insert.SetFocus()
	return 
END IF

p_del.PictureName = 'C:\erpman\image\삭제_up.gif'
p_del.enabled = true
end event

type p_del from w_inherite`p_del within w_pdm_t_00010
integer x = 4078
boolean enabled = false
string picturename = "C:\erpman\image\삭제_d.gif"
end type

event p_del::clicked;call super::clicked;string	sName, sItem, sEcono

sItem  = dw_insert.GetItemString(1, "itnbr")
sEcono = dw_insert.GetItemString(1, "eco_no")

IF dw_insert.AcceptText() = -1	THEN	RETURN

Beep (1)

//wf_delete_chk(sitem, sEcono)

IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", &
						         question!, yesno!, 2)  = 1		THEN

    SetPointer(HourGlass!)

    dw_insert.DeleteRow(0)

   IF dw_insert.Update() <= 0	 THEN
		ROLLBACK;
		f_rollback()
	END IF
	Commit;

END IF

p_can.TriggerEvent("clicked")

///////////////////////////////////////////////////////////
dw_insert.SetItem(1, "itnbr", sitem)
dw_list.Retrieve(sitem)

dw_insert.SetColumn("eco_no")
dw_insert.SetFocus()


end event

type p_mod from w_inherite`p_mod within w_pdm_t_00010
integer x = 3895
end type

event p_mod::clicked;call super::clicked;String	ls_econo, ls_itnbr, ls_data

IF 	dw_insert.Accepttext() = -1 THEN 	
	dw_insert.setfocus()
	RETURN
END IF

// 등록시 PK 확인, 사용순서중복여부 확인
if 	wf_required_chk() = -1 then return
// REQUIRED FIELD 확인
//IF f_CheckRequired(dw_insert) = -1 THEN 	RETURN

IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN
SetPointer(HourGlass!)

dw_insert.SetItem(1, "sabu", gs_sabu)

ls_itnbr = dw_insert.getItemString(1 , "itnbr")
ls_econo = dw_insert.getItemString(1 , "eco_no")

  SELECT "ECO_NO"  
    INTO :ls_data
	 FROM "ECOMST"  
   WHERE ( "ITNBR" = :ls_itnbr ) AND  
         ( "ECO_NO" = :ls_econo )   ;
			
IF sqlca.sqlcode = 0 	then
	dw_insert.setItem(1,"upd_user", gs_userid)
Else
	dw_insert.setItem(1,"crt_user", gs_userid)
	dw_insert.setItem(1,"upd_user", '')
END IF

dw_insert.AcceptText()

IF dw_insert.Update() <> 1	THEN
	MessageBox("SQL error", SQLCA.SQLErrText)
	ROLLBACK USING sqlca;
	f_rollback()
Else
	Commit Using Sqlca;
	MessageBox("확인", "저장이 완료되었습니다.")
END IF

dw_list.reset()
dw_list.retrieve(ls_itnbr)
// wf_Initial()


end event

type cb_exit from w_inherite`cb_exit within w_pdm_t_00010
end type

type cb_mod from w_inherite`cb_mod within w_pdm_t_00010
end type

type cb_ins from w_inherite`cb_ins within w_pdm_t_00010
end type

type cb_del from w_inherite`cb_del within w_pdm_t_00010
end type

type cb_inq from w_inherite`cb_inq within w_pdm_t_00010
end type

type cb_print from w_inherite`cb_print within w_pdm_t_00010
end type

type st_1 from w_inherite`st_1 within w_pdm_t_00010
end type

type cb_can from w_inherite`cb_can within w_pdm_t_00010
end type

type cb_search from w_inherite`cb_search within w_pdm_t_00010
end type







type gb_button1 from w_inherite`gb_button1 within w_pdm_t_00010
end type

type gb_button2 from w_inherite`gb_button2 within w_pdm_t_00010
end type

type dw_list from datawindow within w_pdm_t_00010
integer x = 123
integer y = 1592
integer width = 4288
integer height = 600
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_pdm_t_00010_2"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;String		ls_itnbr, ls_econo
Integer	nRow

nRow = dw_insert.GetRow()
If nRow <= 0 Then Return

dw_list.selectrow(0, false)
dw_list.selectrow(Row, true)

ls_itnbr 	= this.getItemString(Row, "itnbr")
ls_econo = this.getItemString(Row, "eco_no")

dw_insert.Retrieve(ls_itnbr, ls_econo)


dw_insert.Object.itnbr.Protect = True
dw_insert.Object.eco_no.Protect = True

dw_insert.setcolumn("receipt_date")
dw_insert.setfocus()

p_del.PictureName = 'C:\erpman\image\삭제_up.gif'
p_del.enabled = true

end event

event doubleclicked;//long		ll_current_row
//String	ls_itnbr, ls_econo
//
//ll_current_row = this.getRow()
//
//ls_itnbr = this.getItemString(ll_current_row, "itnbr")
//ls_econo = this.getItemString(ll_current_row, "eco_no")
//
//dw_insert.reset()
//dw_insert.insertRow(0)
//dw_insert.Retrieve(ls_itnbr, ls_econo)
//
//dw_insert.Object.itnbr.Protect = True
//dw_insert.Object.eco_no.Protect = True
//
//dw_insert.setfocus()
//dw_insert.setcolumn("receipt_date")
//
//p_del.PictureName = 'C:\erpman\image\삭제_up.gif'
//p_del.enabled = true
end event

type pb_1 from u_pb_cal within w_pdm_t_00010
integer x = 873
integer y = 428
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_insert.SetColumn('receipt_date')
IF Isnull(gs_code) THEN Return
dw_insert.SetItem(dw_insert.getrow(), 'receipt_date', gs_code)

end event

type pb_2 from u_pb_cal within w_pdm_t_00010
integer x = 873
integer y = 900
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_insert.SetColumn('eco_date')
IF Isnull(gs_code) THEN Return
dw_insert.SetItem(dw_insert.getrow(), 'eco_date', gs_code)

end event

type pb_3 from u_pb_cal within w_pdm_t_00010
integer x = 873
integer y = 1036
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_insert.SetColumn('apply_rdate')
IF Isnull(gs_code) THEN Return
dw_insert.SetItem(dw_insert.getrow(), 'apply_rdate', gs_code)

end event

type pb_4 from u_pb_cal within w_pdm_t_00010
integer x = 873
integer y = 1188
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_insert.SetColumn('apply_cdate')
IF Isnull(gs_code) THEN Return
dw_insert.SetItem(dw_insert.getrow(), 'apply_cdate', gs_code)

end event

type pb_5 from u_pb_cal within w_pdm_t_00010
integer x = 3310
integer y = 440
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_insert.SetColumn('draw_rdate')
IF Isnull(gs_code) THEN Return
dw_insert.SetItem(dw_insert.getrow(), 'draw_rdate', gs_code)

end event

type pb_6 from u_pb_cal within w_pdm_t_00010
integer x = 3310
integer y = 604
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_insert.SetColumn('draw_sdate')
IF Isnull(gs_code) THEN Return
dw_insert.SetItem(dw_insert.getrow(), 'draw_sdate', gs_code)

end event

type pb_7 from u_pb_cal within w_pdm_t_00010
integer x = 3310
integer y = 740
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_insert.SetColumn('other_sdate')
IF Isnull(gs_code) THEN Return
dw_insert.SetItem(dw_insert.getrow(), 'other_sdate', gs_code)

end event

type pb_8 from u_pb_cal within w_pdm_t_00010
integer x = 3310
integer y = 884
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_insert.SetColumn('other_rdate')
IF Isnull(gs_code) THEN Return
dw_insert.SetItem(dw_insert.getrow(), 'other_rdate', gs_code)

end event

type pb_9 from u_pb_cal within w_pdm_t_00010
integer x = 4384
integer y = 440
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_insert.SetColumn('isir_pdate')
IF Isnull(gs_code) THEN Return
dw_insert.SetItem(dw_insert.getrow(), 'isir_pdate', gs_code)

end event

type pb_10 from u_pb_cal within w_pdm_t_00010
integer x = 4384
integer y = 596
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_insert.SetColumn('isir_rdate')
IF Isnull(gs_code) THEN Return
dw_insert.SetItem(dw_insert.getrow(), 'isir_rdate', gs_code)

end event

type pb_11 from u_pb_cal within w_pdm_t_00010
integer x = 4384
integer y = 744
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_insert.SetColumn('tech_rdate')
IF Isnull(gs_code) THEN Return
dw_insert.SetItem(dw_insert.getrow(), 'tech_rdate', gs_code)

end event

type pb_12 from u_pb_cal within w_pdm_t_00010
integer x = 4384
integer y = 888
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_insert.SetColumn('tech_sdate')
IF Isnull(gs_code) THEN Return
dw_insert.SetItem(dw_insert.getrow(), 'tech_sdate', gs_code)

end event

type rr_1 from roundrectangle within w_pdm_t_00010
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 105
integer y = 1572
integer width = 4352
integer height = 648
integer cornerheight = 40
integer cornerwidth = 55
end type

