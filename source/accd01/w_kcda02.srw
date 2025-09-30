$PBExportHeader$w_kcda02.srw
$PBExportComments$거래처등록
forward
global type w_kcda02 from w_inherite
end type
type cbx_1 from checkbox within w_kcda02
end type
type gb_1 from groupbox within w_kcda02
end type
type dw_1 from datawindow within w_kcda02
end type
type dw_list from datawindow within w_kcda02
end type
type dw_gyul from datawindow within w_kcda02
end type
type dw_gubun from u_key_enter within w_kcda02
end type
type rr_1 from roundrectangle within w_kcda02
end type
end forward

global type w_kcda02 from w_inherite
string title = "거래처 등록"
cbx_1 cbx_1
gb_1 gb_1
dw_1 dw_1
dw_list dw_list
dw_gyul dw_gyul
dw_gubun dw_gubun
rr_1 rr_1
end type
global w_kcda02 w_kcda02

type variables
w_preview  iw_preview
end variables

forward prototypes
public function integer wf_delete_chk (string scust)
public subroutine wf_init ()
public function integer wf_maxcustcode ()
public function integer wf_requiredchk (integer ll_row)
public subroutine wf_find_row (string scvcod)
public subroutine wf_setting_retrievemode (string mode)
end prototypes

public function integer wf_delete_chk (string scust);Long icnt = 0

select count(*) into :icnt
  from vnddan
 where cvcod = :scust;
if sqlca.sqlcode = 0 and icnt >= 1 then
	f_messagechk(20017,'[거래처제품단가]')
	return -1
end if

select count(*) into :icnt
  from vndsisang
 where cvcod = :scust;
if sqlca.sqlcode = 0 and icnt >= 1 then
	f_messagechk(20017,'[거래처평가시상]')
	return -1
end if

select count(*) into :icnt
  from vnddc
 where cvcod = :scust;
if sqlca.sqlcode = 0 and icnt >= 1 then
	f_messagechk(20017,'[거래처할인]')
	return -1
end if

select count(*) into :icnt
  from taxmisu
 where cvcod = :scust;
if sqlca.sqlcode = 0 and icnt >= 1 then
	f_messagechk(20017,'[계산서발행월미수]')
	return -1
end if

select count(*) into :icnt
  from danmst
 where cvcod = :scust;
if sqlca.sqlcode = 0 and icnt >= 1 then
	f_messagechk(20017,'[단가마스타]')
	return -1
end if

select count(*) into :icnt
  from estima
 where cvcod = :scust;
if sqlca.sqlcode = 0 and icnt >= 1 then
	f_messagechk(20017,'[발주예정_구매의뢰]')
	return -1
end if

select count(*) into :icnt
  from pomast
 where cvcod = :scust;
if sqlca.sqlcode = 0 and icnt >= 1 then
	f_messagechk(20017,'[발주일반정보]')
	return -1
end if

select count(*) into :icnt
  from sorder
 where cvcod = :scust;
if sqlca.sqlcode = 0 and icnt >= 1 then
	f_messagechk(20017,'[수주]')
	return -1
end if

select count(*) into :icnt
  from exppih
 where cvcod = :scust;
if sqlca.sqlcode = 0 and icnt >= 1 then
	f_messagechk(20017,'[수출PI Head]')
	return -1
end if

select count(*) into :icnt
  from imhist
 where cvcod = :scust;
if sqlca.sqlcode = 0 and icnt >= 1 then
	f_messagechk(20017,'[입출고이력]')
	return -1
end if

return 1
end function

public subroutine wf_init ();String sNullValue

sModStatus ="I"

w_mdi_frame.sle_msg.text =""

dw_list.Retrieve(dw_gubun.GetItemString(1,"rfgub"))
dw_list.SelectRow(0,False)
//dw_list.ScrollToRow(1)

SetNull(sNullValue)

dw_1.SetRedraw(False)
dw_1.Reset()
dw_1.InsertRow(0)
dw_1.SetItem(dw_1.GetRow(),"vndmst_cvgu", dw_gubun.GetItemString(1,"rfgub"))

dw_1.SetColumn("vndmst_cvcod")
dw_1.SetFocus()

dw_1.SetRedraw(True)

dw_gyul.SetRedraw(False)
dw_gyul.Reset()
dw_gyul.InsertRow(0)
dw_gyul.SetRedraw(True)


end subroutine

public function integer wf_maxcustcode ();//////////////////////////////////////////////////////////////
// 	1. 거래처구분 -> 거래처코드 자동채번 
//		2. 국내,해외,기타거래처만 자동채번 (창고,부서,은행은 제외)
//       단 기타거래처에서 999999는 자동채번에서 제외
//////////////////////////////////////////////////////////////
String 	sGubunCode,		&
			sFetched_Id = '', sext_code
real		rMaxCode

dw_gubun.AcceptText()
sGubunCode = dw_gubun.GetItemString(1, "rfgub")					

IF sGubunCode = '1'	OR	sGubunCode = '2' THEN

	SELECT Max("VNDMST"."CVCOD")
     INTO :sFetched_Id
     FROM "VNDMST"  
    WHERE "VNDMST"."CVGU" = :sGubunCode AND 
	       SUBSTR("VNDMST"."CVCOD", 1, 1)  = :sGubunCode ;
	
	IF IsNull(sFetched_Id) or  sFetched_id = ''   THEN
		sFetched_Id = sGubunCode + "00000"
	ELSE
		DO 
			SELECT "VNDMST"."CVCOD"
   		  INTO :sext_code
			  FROM "VNDMST"  
	   	 WHERE "VNDMST"."CVCOD" = :sFetched_Id    ;
			IF SQLCA.SQLCODE = 0 THEN
				sFetched_Id = String(real(sFetched_id) + 1)
			END IF
			
		LOOP UNTIL SQLCA.SQLCODE = 100
	END IF
	
	rMaxCode = real(sFetched_id) 
	
	IF rMaxCode >= 1  then //and len(string(rmaxcode)) = 6 THEN
		dw_1.SetItem(1, "vndmst_cvcod" , string(rMaxCode) )
	ELSE
		MessageBox("거래처구분 확인", "거래처코드를 채번할 수 없습니다.")
		dw_1.SetFocus()
		RETURN -1
	END IF
ELSEIF sGubunCode = '9'	THEN

	SELECT Max("VNDMST"."CVCOD")
     INTO :sFetched_Id
     FROM "VNDMST"  
    WHERE "VNDMST"."CVGU" = :sGubunCode AND 
	       SUBSTR("VNDMST"."CVCOD", 1, 1)  = :sGubunCode AND
          "VNDMST"."CVCOD" <> '999999'   ;
	
	IF IsNull(sFetched_Id) or  sFetched_id = ''   THEN
		sFetched_Id = sGubunCode + "00000"
	ELSE
		DO 
			SELECT "VNDMST"."CVCOD"
   		  INTO :sext_code
			  FROM "VNDMST"  
	   	 WHERE "VNDMST"."CVCOD" = :sFetched_Id    ;
			IF SQLCA.SQLCODE = 0 THEN
				sFetched_Id = String(real(sFetched_id) + 1)
			END IF
			
		LOOP UNTIL SQLCA.SQLCODE = 100
	END IF
	
	rMaxCode = real(sFetched_id) 
	
	IF rMaxCode >= 1 AND len(string(rmaxcode)) = 6 AND string(rmaxcode) <> '999999' THEN
		dw_1.SetItem(1, "vndmst_cvcod" , string(rMaxCode) )
	ELSE
		MessageBox("거래처구분 확인", "거래처코드를 채번할 수 없습니다.")
		dw_1.SetFocus()
		RETURN -1
	END IF
END IF
	
RETURN	1

end function

public function integer wf_requiredchk (integer ll_row);String sAutoFlag,sCvcod

sAutoFlag = dw_1.GetItemString(ll_row,"autoflag")
sCvcod    = dw_1.GetItemString(ll_row,"vndmst_cvcod")

IF sAutoFlag = 'N' and (sCvcod = "" OR IsNull(sCvcod)) THEN
	F_MessageChk(1,'[거래처코드]')
	dw_1.SetColumn("vndmst_cvcod")
	dw_1.SetFocus()
	Return -1
END IF
IF dw_1.GetItemString(ll_row,"vndmst_cvgu") = "" OR IsNull(dw_1.GetItemString(ll_row,"vndmst_cvgu")) THEN
	F_MessageChk(1,'[거래처구분]')
	dw_1.SetColumn("vndmst_cvgu")
	dw_1.SetFocus()
	Return -1
END IF

IF dw_1.GetItemString(ll_row,"vndmst_cvnas") = "" OR IsNull(dw_1.GetItemString(ll_row,"vndmst_cvnas")) THEN
	F_MessageChk(1,'[거래처명]')
	dw_1.SetColumn("vndmst_cvnas")
	dw_1.SetFocus()
	Return -1
END IF

String ls_saleyn , ls_gumaeyn , ls_oyjuyn , ls_yongyn
String ls_sale_dept , ls_gu_dept

ls_saleyn  = Trim(dw_1.Object.saleyn[1])
ls_gumaeyn = Trim(dw_1.Object.gumaeyn[1])
ls_oyjuyn  = Trim(dw_1.Object.oyjuyn[1])
ls_yongyn  = Trim(dw_1.Object.yongyn[1])

If ls_saleyn = 'N' And ls_gumaeyn = 'N' And  ls_oyjuyn = 'N' And ls_yongyn = 'N'Then
	F_MessageChk(1,'[거래처구분]')
	dw_1.SetColumn("yongyn")
	dw_1.SetFocus()
	Return -1
End If

Return 1
end function

public subroutine wf_find_row (string scvcod);Integer iRow

iRow = dw_list.GetSelectedRow(0)
if iRow > 0 then Return

dw_list.SetRedraw(False)
dw_list.Retrieve(dw_gubun.GetItemString(1,"rfgub"))
dw_list.SetRedraw(True)

iRow = dw_list.Find("cvcod = '"+sCvcod + "'",1,dw_list.RowCount())
if iRow > 0 then
	dw_list.ScrollToRow(iRow)
	dw_list.SelectRow(iRow,True)
end if

end subroutine

public subroutine wf_setting_retrievemode (string mode);//************************************************************************************//
// **** FUNCTION NAME :WF_SETTING_RETRIEVEMODE(DATAWINDOW 제어)      					  //
//      * ARGUMENT : String mode(수정mode 인지 입력 mode 인지 구분)						  //
//		  * RETURN VALUE : 없슴 																		  //
//************************************************************************************//

dw_1.SetRedraw(False)
p_ins.Enabled =True
p_ins.PictureName = "C:\erpman\image\추가_up.gif"

p_mod.Enabled =True
p_mod.PictureName = "C:\erpman\image\저장_up.gif"

IF mode ="M" THEN							//수정
	dw_1.SetTabOrder("vndmst_cvcod",0)
	
	p_del.Enabled = True
	p_del.PictureName = "C:\erpman\image\삭제_up.gif"
	
	dw_1.Modify("autoflag.visible = 0")
	
	dw_1.SetColumn("vndmst_cvgu")
ELSEIF mode ="I" THEN					//입력
	dw_1.SetTabOrder("vndmst_cvcod",10)
	
	p_del.Enabled = False
	p_del.PictureName = "C:\erpman\image\삭제_d.gif"
	
	if dw_1.GetItemString(1,"vndmst_cvgu") = '3' then
		dw_1.SetItem(1,"autoflag",'N')
		dw_1.Modify("autoflag.visible = 0")
	else
		dw_1.SetItem(1,"autoflag",'Y')
		dw_1.Modify("autoflag.visible = 1")
	end if
	dw_1.SetColumn("vndmst_cvcod")
END IF
dw_1.SetFocus()
dw_1.SetRedraw(True)
end subroutine

event open;call super::open;dw_1.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)
dw_gyul.SetTransObject(Sqlca)
dw_gubun.SetTransObject(Sqlca)

dw_gubun.Reset()
dw_gubun.InsertRow(0)
dw_gubun.SetItem(1,"rfgub",'1')

ib_any_typing=False

Wf_Init()

sModStatus ="I"

WF_SETTING_RETRIEVEMODE(sModStatus)

dw_1.SetColumn("vndmst_cvcod")
dw_1.SetFocus()

open( iw_preview, this)


end event

on w_kcda02.create
int iCurrent
call super::create
this.cbx_1=create cbx_1
this.gb_1=create gb_1
this.dw_1=create dw_1
this.dw_list=create dw_list
this.dw_gyul=create dw_gyul
this.dw_gubun=create dw_gubun
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
this.Control[iCurrent+2]=this.gb_1
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.dw_list
this.Control[iCurrent+5]=this.dw_gyul
this.Control[iCurrent+6]=this.dw_gubun
this.Control[iCurrent+7]=this.rr_1
end on

on w_kcda02.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_1)
destroy(this.gb_1)
destroy(this.dw_1)
destroy(this.dw_list)
destroy(this.dw_gyul)
destroy(this.dw_gubun)
destroy(this.rr_1)
end on

type dw_insert from w_inherite`dw_insert within w_kcda02
boolean visible = false
integer x = 2025
integer y = 2492
integer height = 84
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kcda02
boolean visible = false
integer x = 3561
integer y = 3048
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kcda02
boolean visible = false
integer x = 3387
integer y = 3048
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kcda02
boolean visible = false
integer x = 2107
integer y = 4
integer width = 306
integer height = 132
integer taborder = 0
string pointer = "c:\erpman\cur\point.cur"
boolean originalsize = true
string picturename = "C:\erpm"
end type

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\계정배열조정_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\계정배열조정_up.gif"
end event

type p_ins from w_inherite`p_ins within w_kcda02
integer x = 3899
integer y = 8
string pointer = "C:\erpman\cur\new.cur"
end type

event p_ins::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

p_ins.Enabled =True

WF_INIT()

//dw_1.SetFocus()
sModStatus ="I"

ib_any_typing=False
WF_SETTING_RETRIEVEMODE(sModStatus)									//입력 MODE

end event

type p_exit from w_inherite`p_exit within w_kcda02
integer x = 4421
integer y = 8
integer taborder = 70
end type

type p_can from w_inherite`p_can within w_kcda02
boolean visible = false
integer x = 4352
integer y = 1896
integer taborder = 0
end type

event p_can::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

p_ins.Enabled =True

WF_INIT()

//dw_1.SetFocus()
sModStatus ="I"

ib_any_typing=False
WF_SETTING_RETRIEVEMODE(sModStatus)									//입력 MODE

end event

type p_print from w_inherite`p_print within w_kcda02
boolean visible = false
integer x = 3214
integer y = 3044
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kcda02
boolean visible = false
integer x = 1888
integer y = 8
integer taborder = 0
end type

event p_inq::clicked;String sCvcod
long   ll_row,iCount

w_mdi_frame.sle_msg.text =""

dw_1.AcceptText() 
sCvcod =dw_1.GetItemString(dw_1.GetRow(),"vndmst_cvcod")

IF sCvcod = "" OR IsNull(sCvcod) THEN
	f_messagechk(1,'[코드]')
	dw_1.SetColumn("vndmst_cvcod")
	dw_1.SetFocus()
	Return
END IF

IF dw_1.Retrieve(sCvcod) <= 0 THEN
	dw_1.Reset()
	dw_1.InsertRow(0)
	
	f_messagechk(14,"")
	
   dw_1.SetFocus()
	
	p_ins.Enabled =True
	p_ins.PictureName = "C:\erpman\image\추가_up.gif"
	
	Return

END IF
ib_any_typing=False

dw_gyul.SetRedraw(False)
if dw_gyul.Retrieve(sCvcod) <=0 then
	dw_gyul.InsertRow(0)
	
	dw_gyul.SetItem(1,"person_cd", sCvcod)
end if
dw_gyul.SetRedraw(True)

sModStatus="M"

WF_SETTING_RETRIEVEMODE(sModStatus)								//수정 mode 

//p_ins.Enabled =False
//p_ins.PictureName = "C:\erpman\image\추가_d.gif"

dw_list.SelectRow(0,False)
dw_list.SelectRow(dw_list.Find("cvcod = '"+sCvcod + "'",1,dw_list.RowCount()),True)
dw_list.ScrollToRow(dw_list.Find("cvcod = '"+sCvcod + "'",1,dw_list.RowCount()))
end event

type p_del from w_inherite`p_del within w_kcda02
integer x = 4247
integer y = 8
end type

event p_del::clicked;call super::clicked;string  sCvcod

dw_1.AcceptText()
sCvcod = dw_1.GetItemString(dw_1.GetRow(),"vndmst_cvcod")

if Wf_Delete_Chk(sCvcod) = -1 then
	wf_setting_retrievemode("M")
	dw_1.SetFocus()
	Return
end if

IF f_dbconfirm("삭제") = 2 THEN Return

dw_1.SetRedraw(False)

dw_1.deleterow(0)
IF dw_1.Update() = 1 THEN	
	
	dw_gyul.SetRedraw(False)
	dw_gyul.DeleteRow(0)
	dw_gyul.Update()
	dw_gyul.SetRedraw(True)
	COMMIT;
	WF_INIT()
	w_mdi_frame.sle_msg.text =" 자료가 삭제되었습니다.!!!"
	p_ins.Enabled =True
	ib_any_typing=False
ELSE
	F_MESSAGECHK(12,"")
	dw_1.SetRedraw(True)
	dw_1.SetFocus()
	ROLLBACK;	
END IF	

sModStatus ="I"

WF_SETTING_RETRIEVEMODE(sModStatus)									//입력 MODE

end event

type p_mod from w_inherite`p_mod within w_kcda02
integer x = 4073
integer y = 8
end type

event p_mod::clicked;String sAutoFlag

IF dw_1.AcceptText() = -1 THEN RETURN 

IF Wf_RequiredChk(1) = -1 THEN RETURN

sAutoFlag = dw_1.GetItemString(dw_1.GetRow(),"autoflag")

IF f_dbconfirm("등록") = 2 THEN RETURN

IF sModStatus = 'I' THEN
   If sAutoFlag = 'Y' THEN
   	IF wf_MaxCustCode() = -1	THEN	
			RETURN
		END IF
	END IF
END IF

IF	dw_1.Update() = 1 THEN
	
	dw_gyul.SetItem(1,"person_cd", dw_1.GetItemString(1,"vndmst_cvcod"))
	if dw_gyul.Update() <> 1 then
		F_MessageChk(13,'')
		Rollback;
		Return
	end if
	
	COMMIT;
	
	Wf_Find_Row(dw_1.GetItemString(1,"vndmst_cvcod"))
	
	w_mdi_frame.sle_msg.text =" 자료가 저장되었습니다.!!!"
	ib_any_typing=False
ELSE
	f_messagechk(13,"")
	dw_1.SetColumn("vndmst_cvcod")
	dw_1.SetFocus()
	ROLLBACK;	
END IF

sModStatus ="M"
WF_SETTING_RETRIEVEMODE(sModStatus)								//수정 mode

end event

type cb_exit from w_inherite`cb_exit within w_kcda02
integer x = 3319
integer y = 3296
end type

type cb_mod from w_inherite`cb_mod within w_kcda02
integer x = 2153
integer y = 3076
end type

type cb_ins from w_inherite`cb_ins within w_kcda02
integer x = 1298
integer y = 3076
end type

type cb_del from w_inherite`cb_del within w_kcda02
integer x = 2510
integer y = 3076
end type

type cb_inq from w_inherite`cb_inq within w_kcda02
integer x = 946
integer y = 3076
end type

type cb_print from w_inherite`cb_print within w_kcda02
integer x = 2949
integer y = 3284
end type

type st_1 from w_inherite`st_1 within w_kcda02
end type

type cb_can from w_inherite`cb_can within w_kcda02
integer x = 2866
integer y = 3076
end type

type cb_search from w_inherite`cb_search within w_kcda02
integer x = 1650
integer y = 3080
integer width = 489
string text = "계정배열조정"
end type

type dw_datetime from w_inherite`dw_datetime within w_kcda02
integer x = 2857
integer height = 88
end type

type sle_msg from w_inherite`sle_msg within w_kcda02
integer width = 2482
end type



type gb_button1 from w_inherite`gb_button1 within w_kcda02
integer x = 320
integer y = 2732
end type

type gb_button2 from w_inherite`gb_button2 within w_kcda02
integer x = 1125
integer y = 2724
end type

type cbx_1 from checkbox within w_kcda02
integer x = 3081
integer y = 64
integer width = 567
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "거래처 미리보기"
end type

event clicked;cbx_1.Checked = False

iw_preview.title = '거래처 미리보기'
iw_preview.dw_preview.dataobject = 'dw_kcda02_p'
iw_preview.dw_preview.settransobject(sqlca)
iw_preview.dw_preview.modify( 'datawindow.print.preview=yes &
					datawindow.print.preview.zoom=100 datawindow.print.orientation=1 &
					datawindow.print.margin.left=280 datawindow.zoom=100' )

iw_preview.dw_preview.reset()	
IF iw_preview.dw_preview.retrieve() <=0 THEN
	f_messagechk(14,'')
	iw_preview.Visible = False
	Return	
END IF
iw_preview.Visible =True
end event

type gb_1 from groupbox within w_kcda02
integer x = 3017
integer width = 677
integer height = 152
integer textsize = -12
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 32106727
end type

type dw_1 from datawindow within w_kcda02
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 1385
integer y = 156
integer width = 3214
integer height = 1580
integer taborder = 30
string dataobject = "dw_kcda02_detail"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;
Send(Handle(this),256,9,0)

Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;
Return 1
end event

event editchanged;ib_any_typing =True
end event

event rbuttondown;
this.AcceptText()
IF this.GetColumnName() = "vndmst_cvcod" THEN
	SetNull(lstr_custom.code)
	SetNull(lstr_custom.name)

	OpenWithParm(w_kfz04om0_popup_cvba,'1')

	IF isnull(lstr_custom.code)  or  lstr_custom.code = ''	then  return

	this.SetItem(1, "vndmst_cvcod", lstr_custom.code)
	this.TriggerEvent(ItemChanged!)
END IF


IF this.GetColumnName() ="vndmst_posno" THEN
	SetNull(Gs_code)
	SetNull(Gs_codename)

	Gs_Code = Trim(this.GetItemString(1,"vndmst_posno"))
	
	Open(w_zip_popup)
	
	IF IsNull(Gs_Code) THEN RETURN
	
	this.SetItem(this.GetRow(),"vndmst_posno",Gs_code)
	this.SetItem(this.GetRow(),"vndmst_addr1",Gs_codename)
	
	this.SetColumn("vndmst_addr2")
	this.SetFocus()
	
ELSEIF this.GetColumnName() = "deptcode" THEN
	Open(w_vndmst_4_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then  return

	this.SetItem(1, "deptcode", gs_Code)
	this.SetItem(1, "deptname", gs_Codename)
	
ELSEIF this.GetColumnName() = "sale_emp" THEN
	Open(w_vndmst_4_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then  return

	this.SetItem(1, "sale_emp", gs_Code)
	this.SetItem(1, "sale_name", gs_Codename)

END IF

end event

event itemfocuschanged;Long wnd

wnd =Handle(this)

IF dwo.name ="vndmst_cvnas" OR dwo.name ="cvnas2"       OR dwo.name ="vndmst_uptae" OR &
	dwo.name ="vndmst_jongk" OR dwo.name ="vndmst_ownam" OR dwo.name ="vndmst_addr1" OR &
	dwo.name ="vndmst_addr2" OR dwo.name ="vndmst_addr3" OR dwo.name ="vndmst_addr4" OR &
	dwo.name ="vndmst_rcvmg" OR dwo.name ="vndmst_cvpln" OR dwo.name ="vndmst_cremark" OR &
	dwo.name ="cvbank" OR dwo.name ="dpname" THEN
	f_toggle_kor(wnd)
ELSE
	f_toggle_eng(wnd)
END IF
end event

event getfocus;this.AcceptText()
end event

event itemchanged;int    iExPrice
Double dNull
string sNull,sres_no,sCustCode,ls_cvcod

w_mdi_frame.sle_msg.text = ''

SetNull(dNull)
SetNull(sNull)

IF this.GetColumnName() = 'vndmst_cvcod' THEN
	sCustCode = this.GetText()
	IF sCustCode = "" OR IsNull(sCustcode) THEN RETURN
	
   select cvcod	into :ls_cvcod		from vndmst 	where cvcod = :sCustCode ;
   if sqlca.sqlcode = 0 then
	   p_inq.TriggerEvent(Clicked!)	
   end if
END IF

IF this.GetColumnName() = "vndmst_cvnas" THEN
	IF this.GetText() = "" OR IsNull(this.GetText()) THEN
		this.SetItem(this.GetRow(),"cvnas2",sNull)
	END IF
END IF

IF	this.getcolumnname() = "vndmst_sano"	THEN

	string	SaupNo, DupCheck, DupName
	
	SaupNo = this.GETTEXT()				
	
	IF IsNull(saupno) OR saupno ="" THEN RETURN 
	
	select cvcod, cvnas	into :DupCheck, :DupName
	  from vndmst
	 where sano = :SaupNo
	   and rownum = 1;
	IF sqlca.sqlcode = 0 THEN
		messagebox("사업자등록번호 확인", "등록된 사업자등록번호입니다.~n~r" 	&
						+ "거래처번호 : " + DupCheck + "~n~r거래처   명 : " + DupName )
		this.setitem(1, "vndmst_sano", sNull)
		return 1
	END IF
	IF f_vendcode_check(saupno) = False THEN
		F_MessageChk(20,'[사업자등록번호]')
//		this.SetItem(this.GetRow(),"vndmst_sano",sNull)
//		Return 1
	END IF
END IF

IF this.GetColumnName() = "resident" THEN
	sres_no = this.GetText()
	
	IF sres_no = "" OR IsNull(sres_no) THEN RETURN
	
	IF f_vendcode_check(sres_no) = False THEN
		IF MessageBox("확 인","주민등록번호가 틀렸습니다. 계속하시겠습니까?",Question!,YesNo!) = 2 then
			this.SetItem(this.GetRow(),"resident",sNull)
			Return 1
		END IF
	END IF
END IF

String sdptno ,sget_name , ls_cod

IF this.GetColumnName() ="sale_emp" THEN
	
	sdptno = this.GetText()
	
	IF sdptno ="" OR IsNull(sdptno) THEN 
		this.SetItem(1,"sale_name",sNull)
		RETURN
	END IF
	
	SELECT "VNDMST"."CVNAS2"  INTO :sget_name  
     FROM "VNDMST"  
    WHERE "VNDMST"."CVCOD" = :sdptno  AND "VNDMST"."CVGU" = '4' ;
	  
	IF SQLCA.SQLCODE = 0 THEN
		this.SetItem(1,"sale_name",sget_name)
	ELSE
		this.TriggerEvent(RbuttonDown!)
		IF gs_code ="" OR IsNull(gs_code) THEN 
			this.SetItem(1,"sale_emp",sNull)
			this.SetItem(1,"sale_name",sNull)
		END IF
		
		Return 1	
	END IF
ELSEIF this.GetColumnName() ="deptcode" THEN
	
	sdptno = this.GetText()
	
	IF sdptno ="" OR IsNull(sdptno) THEN 
		this.SetItem(1,"p0_dept_deptname2",sNull)
		RETURN
	END IF
	
	SELECT "VNDMST"."CVNAS2"  INTO :sget_name  
     FROM "VNDMST"  
    WHERE "VNDMST"."CVCOD" = :sdptno  AND "VNDMST"."CVGU" = '4' ;
	  
	IF SQLCA.SQLCODE = 0 THEN
		this.SetItem(1,"deptname",sget_name)
	ELSE
		this.TriggerEvent(RbuttonDown!)
		IF gs_code ="" OR IsNull(gs_code) THEN 
			this.SetItem(1,"deptcode",sNull)
			this.SetItem(1,"deptname",sNull)
		END IF
		
		Return 1	
	END IF
ElseIf this.GetColumnName() ="valid_yn" THEN 
	
	ls_cod = Trim(GetText())
	
	If ls_cod = 'Y' Then
		This.Object.sdate[1] = is_today
		This.Object.edate[1] = f_afterday(is_today , 730 )
	Else
		This.Object.sdate[1] = is_today
		This.Object.edate[1] = '99999999'
	End If
ElseIf this.GetColumnName() ="exprice" THEN 
	iExPrice = Integer(this.GetText())
	
	IF iExPrice = 0 OR IsNull(iExPrice) THEN RETURN
	
	IF iExPrice <> 1 And iExPrice <> 2 And iExPrice <> 3 And iExPrice <> 4 THEN
		MessageBox("확 인","구분을 확인하십시오.")
		this.SetItem(1,"exprice",dNull)
		Return 1
	END IF
End If
end event

type dw_list from datawindow within w_kcda02
integer x = 119
integer y = 276
integer width = 1221
integer height = 1888
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "dw_kcda02_list"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;
if row <=0 then Return

this.SelectRow(0,False)
this.SelectRow(Row,True)

dw_1.SetItem(1,"vndmst_cvcod", this.GetItemString(row,"cvcod"))

p_inq.TriggerEvent(Clicked!)

this.SetFocus()
end event

event rowfocuschanged;//If currentrow > 0 then
//	this.SelectRow(0,False)
//	this.SelectRow(currentrow,True)
//	
//	dw_1.SetItem(1,"acc1_cd", this.GetItemString(currentrow,"acc1_cd"))
//	dw_1.SetItem(1,"acc2_cd", this.GetItemString(currentrow,"acc2_cd"))
//	
//	p_inq.TriggerEvent(Clicked!)
//	
//	this.SetFocus()
//End if
end event

type dw_gyul from datawindow within w_kcda02
event ue_pressenter pbm_dwnprocessenter
integer x = 1390
integer y = 1744
integer width = 3209
integer height = 416
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "dw_kcda02_gyul"
boolean border = false
end type

event ue_pressenter;Send(Handle(this),256,9,0)

Return 1
end event

event itemfocuschanged;Long wnd

wnd =Handle(this)

IF dwo.name ="autobank" OR dwo.name ="dpname" OR dwo.name ="cvtype" THEN
	f_toggle_kor(wnd)
ELSE
	f_toggle_eng(wnd)
END IF
end event

type dw_gubun from u_key_enter within w_kcda02
integer x = 114
integer y = 116
integer width = 1216
integer height = 144
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_kcda02_gubun"
boolean border = false
end type

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;

if this.GetColumnName() = "rfgub" then
	w_mdi_frame.sle_msg.text =""
	
	dw_list.Retrieve(this.GetText())
	dw_list.SelectRow(0,False)
	
	dw_1.SetRedraw(False)
	dw_1.Reset()
	dw_1.InsertRow(0)
	dw_1.SetItem(dw_1.GetRow(),"vndmst_cvgu", this.GetText())
	
	if this.GetText() = '3' then
		dw_1.SetItem(1,"autoflag",'N')
		dw_1.Modify("autoflag.visible = 0")
	else
		dw_1.SetItem(1,"autoflag",'Y')
		dw_1.Modify("autoflag.visible = 1")
	end if
	dw_1.SetColumn("vndmst_cvcod")
	dw_1.SetFocus()
	
	dw_1.SetRedraw(True)
	
	dw_gyul.SetRedraw(False)
	dw_gyul.Reset()
	dw_gyul.InsertRow(0)
	dw_gyul.SetRedraw(True)	
end if
end event

type rr_1 from roundrectangle within w_kcda02
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 110
integer y = 268
integer width = 1248
integer height = 1904
integer cornerheight = 40
integer cornerwidth = 55
end type

