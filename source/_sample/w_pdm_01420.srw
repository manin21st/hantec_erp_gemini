$PBExportHeader$w_pdm_01420.srw
$PBExportComments$** 작업장 등록
forward
global type w_pdm_01420 from w_inherite
end type
type dw_list from u_d_popup_sort within w_pdm_01420
end type
type rb_1 from radiobutton within w_pdm_01420
end type
type dw_1 from datawindow within w_pdm_01420
end type
type dw_2 from datawindow within w_pdm_01420
end type
type cb_1 from commandbutton within w_pdm_01420
end type
type dw_boyu from u_d_select_sort within w_pdm_01420
end type
type st_2 from statictext within w_pdm_01420
end type
type dw_mon from datawindow within w_pdm_01420
end type
type cb_2 from commandbutton within w_pdm_01420
end type
type rr_1 from roundrectangle within w_pdm_01420
end type
type rr_2 from roundrectangle within w_pdm_01420
end type
type rr_3 from roundrectangle within w_pdm_01420
end type
end forward

global type w_pdm_01420 from w_inherite
integer width = 4686
integer height = 3064
string title = "작업장 등록"
dw_list dw_list
rb_1 rb_1
dw_1 dw_1
dw_2 dw_2
cb_1 cb_1
dw_boyu dw_boyu
st_2 st_2
dw_mon dw_mon
cb_2 cb_2
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
end type
global w_pdm_01420 w_pdm_01420

type variables
char  ic_Status

// 자료변경여부 검사
boolean  ib_itemerror

// 작업장인원
integer iInwon

end variables

forward prototypes
public subroutine wf_insert ()
public subroutine wf_taborder ()
public subroutine wf_taborderzero ()
public function integer wf_delete_chk (string swkctr)
public function integer wf_confirm_key ()
public subroutine wf_new ()
public subroutine wf_query ()
end prototypes

public subroutine wf_insert ();//long		lRow, lcnt
//string	sCode, sName
//
//dw_1.Reset()
//
//datastore ds
//ds = create datastore
//ds.dataobject = "dd_reffpf_25"
//ds.settransobject(sqlca)
//ds.retrieve()
//
//For Lcnt = 1 to ds.rowcount()
//	
//	 scode = ds.getitemstring(Lcnt, "rfgub")
//	 sName = ds.getitemstring(Lcnt, "rfna1")	 
//	
//	 lRow = dw_1.InsertRow(0)
//	
//	 dw_1.SetItem(lRow, "ccode", 	sCode)
//	 dw_1.SetItem(lRow, "reffpf_rfna1", sName)
//	
//Next
//
//destroy ds
end subroutine

public subroutine wf_taborder ();
dw_insert.SetTabOrder("wkctr", 10)
dw_insert.SetColumn(1)



end subroutine

public subroutine wf_taborderzero ();
dw_insert.SetTabOrder("wkctr", 0)
end subroutine

public function integer wf_delete_chk (string swkctr);long  l_cnt

l_cnt = 0
SELECT COUNT(*)
  INTO :l_cnt
  FROM ROUTNG  
 WHERE WKCTR = :swkctr ;

if sqlca.sqlcode <> 0 or l_cnt >= 1 then
	f_message_chk(38,'[표준공정]')
	return -1
end if

l_cnt = 0
SELECT COUNT(*)
  INTO :l_cnt
  FROM COST_WRKDTL  
 WHERE WKCTR = :swkctr ;

if sqlca.sqlcode <> 0 or l_cnt >= 1 then
	f_message_chk(38,'[작업장 원가자료]')
	return -1
end if

l_cnt = 0
SELECT COUNT(*)
  INTO :l_cnt
  FROM MOROUT 
 WHERE SABU = :gs_sabu And WKCTR = :swkctr ;

if sqlca.sqlcode <> 0 or l_cnt >= 1 then
	f_message_chk(38,'[작업지시-공정]')
	return -1
end if

return 1
end function

public function integer wf_confirm_key ();/*=====================================================================
		1.	등록 mode : Key 검색
		2. Argument : None
		3.	Return Value
			- ( -1 ) : 등록된 코드 
			- (  1 ) : 신  규 코드
=====================================================================*/
string	sConfirm,is_key1

is_Key1 = dw_insert.GetItemString(1, "wkctr")

SELECT "WKCTR"
  INTO :sConfirm
  FROM "WRKCTR"  
 WHERE ( "WKCTR" = :is_key1 )  ;
			
IF sqlca.sqlcode = 0 	then	
	f_message_chk(1, "")
	dw_insert.setcolumn(1)
	dw_insert.SetFocus()
	RETURN  -1 
END IF
RETURN  1

end function

public subroutine wf_new ();ic_status = '1'
w_mdi_frame.sle_msg.text = "등록"

///////////////////////////////////////////////
dw_insert.setredraw(false)

dw_insert.reset()
dw_insert.insertrow(0)

dw_2.reset()

//wf_Insert()
wf_TabOrder()

dw_insert.SetFocus()


dw_insert.setredraw(true)
///////////////////////////////////////////////


p_ins.enabled = true							
p_del.enabled = false

p_ins.PictureName = 'C:\erpman\image\추가_up.gif'
p_del.PictureName = 'C:\erpman\image\삭제_d.gif'

ib_ItemError  = true
ib_any_typing = false
iInwon = 0






end subroutine

public subroutine wf_query ();
w_mdi_frame.sle_msg.text = "조회"
ic_Status = '2'

wf_TabOrderZero()

dw_insert.SetFocus()
	
p_ins.enabled = false						
p_del.enabled = true
p_ins.PictureName = 'C:\erpman\image\추가_d.gif'
p_del.PictureName = 'C:\erpman\image\삭제_up.gif'
rb_1.enabled = true
iInwon = dw_insert.getitemdecimal(1, "wrkctr_inwon")

end subroutine

on w_pdm_01420.create
int iCurrent
call super::create
this.dw_list=create dw_list
this.rb_1=create rb_1
this.dw_1=create dw_1
this.dw_2=create dw_2
this.cb_1=create cb_1
this.dw_boyu=create dw_boyu
this.st_2=create st_2
this.dw_mon=create dw_mon
this.cb_2=create cb_2
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.dw_2
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.dw_boyu
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.dw_mon
this.Control[iCurrent+9]=this.cb_2
this.Control[iCurrent+10]=this.rr_1
this.Control[iCurrent+11]=this.rr_2
this.Control[iCurrent+12]=this.rr_3
end on

on w_pdm_01420.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_list)
destroy(this.rb_1)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.cb_1)
destroy(this.dw_boyu)
destroy(this.st_2)
destroy(this.dw_mon)
destroy(this.cb_2)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
end on

event open;call super::open;String lsPdtgu

//w_frame.hide()

dw_1.SetTransObject(sqlca)
dw_2.SetTransObject(sqlca)
dw_list.settransobject(sqlca)
dw_insert.settransobject(sqlca)
dw_boyu.settransobject(sqlca)

dw_2.SetTabOrder('wrkchange_change',0)

dw_1.InsertRow(0)

If gs_saupj = '10' Then
	lsPdtgu = '1'
ElseIf gs_saupj = '20' Then
	lsPdtgu = '2'
End If

dw_1.SetItem(1, 'pdtgu', lsPdtgu)
dw_1.TriggerEvent(ItemChanged!)

// 등록
p_can.TriggerEvent("clicked")

// boolean 초기화
ib_itemerror = false
iInwon = 0
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
//	Case KeyW!
//		p_print.TriggerEvent(Clicked!)
	Case KeyQ!
		p_inq.TriggerEvent(Clicked!)
	Case KeyT!
		p_ins.TriggerEvent(Clicked!)
//	Case KeyA!
//		p_addrow.TriggerEvent(Clicked!)
//	Case KeyE!
//		p_delrow.TriggerEvent(Clicked!)
	Case KeyS!
		p_mod.TriggerEvent(Clicked!)
	Case KeyD!
		p_del.TriggerEvent(Clicked!)
	Case KeyC!
		p_can.TriggerEvent(Clicked!)
	Case KeyX!
		p_exit.TriggerEvent(Clicked!)
End Choose
end event

type dw_insert from w_inherite`dw_insert within w_pdm_01420
integer x = 1664
integer y = 176
integer width = 1285
integer height = 1112
integer taborder = 80
string dataobject = "d_pdm_01420_2"
boolean border = false
end type

event dw_insert::itemerror;RETURN 1
	
end event

event dw_insert::itemfocuschanged;Long wnd

wnd =Handle(this)

IF dwo.name ="wcdsc" THEN
	f_toggle_kor(wnd)
ELSE
	f_toggle_eng(wnd)
END IF
end event

event dw_insert::editchanged;if ic_status = '1'   then

	ib_any_typing = true

end if

end event

event dw_insert::itemchanged;String sNull, swkctr, get_nm, get_nm2
Dec {2} drate

w_mdi_frame.sle_msg.text = ''
SetNull(sNull)

IF	this.getcolumnname() = "wkctr"	THEN		// 작업장코드 확인
   swkctr = THIS.GetText()
	IF sWkctr = "" OR IsNull(sWkctr) THEN RETURN
	
  SELECT "WRKCTR"."WKCTR"  
    INTO :get_nm  
    FROM "WRKCTR"  
   WHERE "WRKCTR"."WKCTR" = :sWkctr   ;
	IF SQLCA.SQLCODE = 0 THEN
		p_inq.TriggerEvent(Clicked!)
		RETURN 1
	END IF

ELSEIF this.GetColumnName() ="jocod" THEN
	
	String sdptno
	
	sdptno = this.GetText()
	
	IF sdptno ="" OR IsNull(sdptno) THEN 
		this.SetItem(1,"jomast_jonam",snull)
		this.SetItem(1,"pdtgu",snull)
		RETURN
	END IF
	
	SELECT "JONAM", "PDTGU"  INTO :get_nm, :get_nm2  
     FROM "JOMAST"  
  	 WHERE "JOCOD" = :sdptno   ;

	IF SQLCA.SQLCODE = 0 THEN
		this.SetItem(1,"jomast_jonam",get_nm)
		this.SetItem(1,"pdtgu",get_nm2)
	ELSE
		this.TriggerEvent(RbuttonDown!)
		IF gs_code ="" OR IsNull(gs_code) THEN 
			this.SetItem(1,"jocod",snull)
			this.SetItem(1,"jomast_jonam",snull)
			this.SetItem(1,"pdtgu",snull)
		END IF
		
		Return 1	
	END IF

ELSEIF this.GetColumnName() ="mchno" THEN
	
   swkctr = THIS.GetText()
	IF sWkctr = "" OR IsNull(sWkctr) THEN 
		this.SetItem(1,"mchnam",snull)
		RETURN
	END IF
	
  SELECT "MCHMST"."MCHNAM"  
    INTO :get_nm  
    FROM "MCHMST"  
   WHERE "MCHMST"."MCHNO" = :sWkctr   ;
	IF SQLCA.SQLCODE <> 0 THEN
		this.SetItem(1,"mchno",snull)
		this.SetItem(1,"mchnam",snull)
		RETURN 1
	END IF
	
	this.SetItem(1,"mchnam",get_nm)
	

ELSEIF this.GetColumnName() ="wrkctr_wkgub" THEN
   swkctr = THIS.GetText()
	IF sWkctr = "2"  THEN 
		this.SetItem(1,"wrkctr_chargeqty", 0)
	END IF
ELSEIF this.GetColumnName() ="wrkctr_sf1mcsa" OR this.GetColumnName() ="wrkctr_sf1mhsa" THEN
   this.accepttext()
	this.setitem(1, 'wrkctr_sf1sa', this.getitemdecimal(1, 'avg_tot1'))
ELSEIF this.GetColumnName() ="wrkctr_sf2mcsa" OR this.GetColumnName() ="wrkctr_sf2mhsa" THEN
   this.accepttext()
	this.setitem(1, 'wrkctr_sf2sa', this.getitemdecimal(1, 'avg_tot2'))
ELSEIF this.GetColumnName() ="wrkctr_sf3mcsa" OR this.GetColumnName() ="wrkctr_sf3mhsa" THEN
   this.accepttext()
	this.setitem(1, 'wrkctr_sf3sa', this.getitemdecimal(1, 'avg_tot3'))
ELSEIF this.GetColumnName() ="wrkctr_sf4mcsa" OR this.GetColumnName() ="wrkctr_sf4mhsa" THEN
   this.accepttext()
	this.setitem(1, 'wrkctr_sf4sa', this.getitemdecimal(1, 'avg_tot4'))
ELSEIF this.GetColumnName() ="wrkctr_sf1mcsm" OR this.GetColumnName() ="wrkctr_sf1mhsm" THEN
   this.accepttext()
	this.setitem(1, 'wrkctr_sf1sm', this.getitemdecimal(1, 'max_tot1'))
ELSEIF this.GetColumnName() ="wrkctr_sf2mcsm" OR this.GetColumnName() ="wrkctr_sf2mhsm" THEN
   this.accepttext()
	this.setitem(1, 'wrkctr_sf2sm', this.getitemdecimal(1, 'max_tot2'))
ELSEIF this.GetColumnName() ="wrkctr_sf3mcsm" OR this.GetColumnName() ="wrkctr_sf3mhsm" THEN
   this.accepttext()
	this.setitem(1, 'wrkctr_sf3sm', this.getitemdecimal(1, 'max_tot3'))
ELSEIF this.GetColumnName() ="wrkctr_sf4mcsm" OR this.GetColumnName() ="wrkctr_sf4mhsm" THEN
   this.accepttext()
	this.setitem(1, 'wrkctr_sf4sm', this.getitemdecimal(1, 'max_tot4'))

END IF

end event

event dw_insert::rbuttondown;///////////////////////////////////////////////////////////////////////////
setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

IF this.GetColumnName() = "wkctr"	THEN
	
   gs_code = this.GetText()
	open(w_workplace_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1, "wkctr", 	 gs_Code)
	p_inq.TriggerEvent(Clicked!)
	RETURN 1
	
ELSEIF this.GetColumnName() = "jocod"	THEN
	
	open(w_jomas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1, "jocod", 	 gs_Code)
	this.SetItem(1, "jomast_jonam", 	 gs_codename)
	this.SetItem(1, "pdtgu", 	 gs_gubun)
	RETURN 1
	
ELSEIF this.GetColumnName() = "mchno"	THEN
	
	gs_gubun = 'ALL'
	open(w_mchno_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1, "mchno", 	 gs_Code)
	this.SetItem(1, "mchnam", 	 gs_codename)
	RETURN 1

END IF
end event

event dw_insert::updatestart;/* Update() function 호출시 user 설정 */
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

type p_delrow from w_inherite`p_delrow within w_pdm_01420
boolean visible = false
integer x = 1627
integer y = 2116
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_pdm_01420
boolean visible = false
integer x = 1440
integer y = 2116
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_pdm_01420
boolean visible = false
integer x = 1065
integer y = 2116
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_pdm_01420
integer x = 3698
integer y = 0
integer taborder = 30
end type

event p_ins::clicked;call super::clicked;wf_New()
end event

type p_exit from w_inherite`p_exit within w_pdm_01420
integer x = 4398
integer y = 0
integer taborder = 70
end type

type p_can from w_inherite`p_can within w_pdm_01420
integer x = 4224
integer y = 0
integer taborder = 60
end type

event p_can::clicked;call super::clicked;
wf_New()

w_mdi_frame.sle_msg.text = ''

//rb_1.enabled = false
iInwon = 0
end event

type p_print from w_inherite`p_print within w_pdm_01420
boolean visible = false
integer x = 1253
integer y = 2116
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_pdm_01420
integer x = 3525
integer y = 0
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;
w_mdi_frame.sle_msg.text = ''
ib_any_typing = false	

IF dw_insert.AcceptText() = -1	THEN
	dw_insert.SetFocus()
	return
END IF

if dw_insert.GetRow() <=0 then Return

string	sCode1
sCode1 = dw_insert.GetItemString(1, "wkctr")

IF IsNull(sCode1)	 or  sCode1 = ''	THEN
	f_message_chk(1400,'[작업장코드]')
	dw_insert.Setcolumn('wkctr')
	dw_insert.SetFocus()
	RETURN
END IF

dw_insert.SetRedraw(false)

IF dw_insert.Retrieve(sCode1) > 0		THEN
	wf_Query()
ELSE	
	f_message_chk(33,'')
	dw_insert.ReSet()
	dw_insert.InsertRow(0)
	dw_insert.SetFocus()
	rb_1.enabled = false

END IF

dw_2.Retrieve(sCode1)
dw_insert.SetRedraw(true)
end event

type p_del from w_inherite`p_del within w_pdm_01420
integer x = 4050
integer y = 0
integer taborder = 50
end type

event p_del::clicked;call super::clicked;string sWkctr

Beep (1)

IF dw_insert.accepttext() = -1 THEN RETURN 

sWkctr = dw_insert.getitemstring(1, 'wkctr')

if wf_delete_chk(sWkctr) = -1 then return 

if f_msg_delete() = -1 then return

dw_insert.SetRedraw(false)

dw_insert.DeleteRow(0)

IF dw_insert.Update() > 0	 THEN
   COMMIT;
	w_mdi_frame.sle_msg.text =	"자료를 삭제하였습니다!!"	
ELSE
	ROLLBACK;
   messagebox("삭제실패", "자료에 대한 갱신이 실패하였읍니다")
END IF
/////////////////////////////////////////////////////////////////////////////////////   

dw_insert.SetRedraw(true)

p_can.TriggerEvent(clicked!)   

end event

type p_mod from w_inherite`p_mod within w_pdm_01420
integer x = 3877
integer y = 0
integer taborder = 40
end type

event p_mod::clicked;call super::clicked;
IF dw_insert.Accepttext() = -1 THEN 	
	dw_insert.setfocus()
	RETURN
END IF

// 등록시 PK 확인
IF ic_status = '1'		THEN
	IF  wf_Confirm_key( ) = -1   THEN 	RETURN
END IF

string swkctr, swcdsc, sjocod, sWkgub, sMchno
dec{2} dqty
Integer iUpinwon

swkctr = dw_insert.getitemstring(1, "wkctr")
swcdsc = dw_insert.getitemstring(1, "wcdsc")
sjocod = dw_insert.getitemstring(1, "jocod")
sWkgub = dw_insert.getitemstring(1, "wrkctr_wkgub")
dQty   = dw_insert.getitemDecimal(1, "wrkctr_chargeqty")
sMchno = dw_insert.getitemstring(1, "mchno")

if isnull(swkctr) or swkctr = "" then
	f_message_chk(1400,'[작업장코드]')
	dw_insert.SetColumn('wkctr')
	dw_insert.SetFocus()
	return 		
end if	
if isnull(swcdsc) or swcdsc = "" then
	f_message_chk(1400,'[작업장명]')
	dw_insert.SetColumn('wcdsc')
	dw_insert.SetFocus()
	return 		
end if	
if isnull(sjocod) or sjocod = "" then
	f_message_chk(1400,'[조코드]')
	dw_insert.SetColumn('jocod')
	dw_insert.SetFocus()
	return 		
end if
if isnull(sMchno) or sMchno = "" then /* 설비코드 필수입력으로 변경 - 2024.02.02 by dykim */
	f_message_chk(1400,'[설비코드]')
	dw_insert.SetColumn('mchno')
	dw_insert.SetFocus()
	return 		
end if
//if sWkgub = "1" then
//	if isnull(dqty) or dqty <= 0 then
//		f_message_chk(1400,'[대당 CHARGE 량]')
//		dw_insert.SetColumn('wrkctr_chargeqty')
//		dw_insert.SetFocus()
//		return 		
//	end if	
//end if	

IF ic_status = '2' THEN
   if f_msg_update() = -1 then return
END IF

//////////////////////////////////////////////////////////////////////////////
IF dw_insert.Update() > 0	THEN
	
//	// 작업장의 인원을 표준공정에 적용
//	iupinwon = dw_insert.getitemdecimal(1, "wrkctr_inwon")		
//	if iInwon <> iUpinwon then
//		if Messagebox("공정인원", "해당작업장의 인원을 표준공정에 적용하시겠읍니까?", question!, yesno!) = 1 then
//			Update routng 
//				Set stdmc = :iUpinwon, upd_user = :gs_userid  
//			 Where wkctr = :sWkctr;
//			 
//			if sqlca.sqlcode <> 0 then 
//				ROLLBACK;
//				messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
//			END IF
//		end if
//	end if
	
	if dw_boyu.Update() > 0 then
		COMMIT;
		w_mdi_frame.sle_msg.text = "자료가 저장되었습니다!!"
	else
		ROLLBACK;
		messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
	end if
ELSE
	ROLLBACK;
   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
END IF
		
p_can.TriggerEvent("clicked")


end event

type cb_exit from w_inherite`cb_exit within w_pdm_01420
integer x = 3904
integer y = 2416
integer textsize = -9
end type

type cb_mod from w_inherite`cb_mod within w_pdm_01420
integer x = 2656
integer y = 2120
end type

type cb_ins from w_inherite`cb_ins within w_pdm_01420
integer x = 2318
integer y = 2128
end type

type cb_del from w_inherite`cb_del within w_pdm_01420
integer x = 3022
integer y = 2120
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_pdm_01420
integer x = 1957
integer y = 2128
end type

type cb_print from w_inherite`cb_print within w_pdm_01420
integer x = 1687
integer y = 2476
integer width = 439
boolean enabled = false
string text = "도면관리(&Q)"
end type

type st_1 from w_inherite`st_1 within w_pdm_01420
end type

type cb_can from w_inherite`cb_can within w_pdm_01420
integer x = 3378
integer y = 2120
end type

type cb_search from w_inherite`cb_search within w_pdm_01420
integer x = 1134
integer y = 2448
integer width = 439
boolean enabled = false
string text = "버전증가(&V)"
end type





type gb_10 from w_inherite`gb_10 within w_pdm_01420
integer y = 2424
integer height = 140
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_pdm_01420
end type

type gb_button2 from w_inherite`gb_button2 within w_pdm_01420
end type

type dw_list from u_d_popup_sort within w_pdm_01420
event ue_key pbm_dwnkey
integer x = 59
integer y = 184
integer width = 1563
integer height = 2096
integer taborder = 10
string dataobject = "d_pdm_01420_1"
boolean vscrollbar = true
boolean border = false
end type

event ue_key;// Page Up & Page Down & Home & End Key 사용 정의
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

event clicked;string	swkctr, syymm
																		
IF Row <= 0	then	RETURN									

dw_list.selectrow(0, false)
dw_list.selectrow(Row, true)

//syymm = left(f_today(), 6) + '%'
syymm = dw_mon.GetItemString(1, 'd_mon') + '%'
swkctr = dw_list.getitemstring(Row, "wkctr")

dw_2.retrieve(swkctr) 
dw_insert.retrieve(swkctr)
dw_boyu.retrieve(syymm, swkctr) 

wf_Query()
end event

event rowfocuschanged;call super::rowfocuschanged;if 	currentrow < 1 then return 
if 	this.rowcount() < 1 then return 

this.setredraw(false)

this.SelectRow(0,False)
this.SelectRow(currentrow,True)

this.ScrollToRow(currentrow)

this.setredraw(true)

end event

type rb_1 from radiobutton within w_pdm_01420
boolean visible = false
integer x = 2843
integer y = 40
integer width = 562
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "대체작업장 등록"
end type

event clicked;long  l_count
string	sWkctr

if dw_insert.Accepttext() = -1	then	return

sWkctr = dw_insert.GetItemString(1,"wkctr")

if isnull(sWkctr) or  sWkctr = ''	then	
	messagebox("확인", "작업장을 선택하세요.")
	return
end if

SELECT COUNT("WRKCHANGE"."CHANGE")
  INTO :l_count  
  FROM "WRKCHANGE"  
 WHERE "WRKCHANGE"."CHANGE" = :sWkctr   ;

IF l_count > 0 THEN
	Messagebox("확 인","대체작업장으로 등록된 자료는 대체작업장을 등록할 수 없습니다.!!") 
	RETURN  
END IF

OpenWithParm(w_pdm_01420_change, sWkctr)
end event

type dw_1 from datawindow within w_pdm_01420
integer x = 37
integer width = 1198
integer height = 152
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_pdm_01400_02"
boolean border = false
boolean livescroll = true
end type

event itemchanged;String lsPdtgu

If dw_1.AcceptText() <> 1 Then Return

lsPdtgu = Trim(dw_1.GetItemString(1, 'pdtgu'))

If isNull(lsPdtgu) Or lsPdtgu = '' Then
	lsPdtgu = '%'
End If

dw_list.Retrieve(lsPdtgu)
end event

type dw_2 from datawindow within w_pdm_01420
integer x = 1687
integer y = 1492
integer width = 1248
integer height = 772
integer taborder = 90
boolean bringtotop = true
string title = "none"
string dataobject = "d_pdm_01420_change_v"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
end type

type cb_1 from commandbutton within w_pdm_01420
integer x = 1696
integer y = 1360
integer width = 699
integer height = 104
integer taborder = 90
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "대체작업장 등록"
end type

event clicked;long  l_count
string	sWkctr

if dw_insert.Accepttext() = -1	then	return

sWkctr = dw_insert.GetItemString(1,"wkctr")

if isnull(sWkctr) or  sWkctr = ''	then	
	messagebox("확인", "작업장을 선택하세요.")
	return
end if

//SELECT COUNT("WRKCHANGE"."CHANGE")
//  INTO :l_count  
//  FROM "WRKCHANGE"  
// WHERE "WRKCHANGE"."CHANGE" = :sWkctr   ;
//
//IF l_count > 0 THEN
//	Messagebox("확 인","대체작업장으로 등록된 자료는 대체작업장을 등록할 수 없습니다.!!") 
//	RETURN  
//END IF

OpenWithParm(w_pdm_01420_change, sWkctr)
dw_2.retrieve(sWkctr) 

end event

type dw_boyu from u_d_select_sort within w_pdm_01420
integer x = 3086
integer y = 276
integer width = 1472
integer height = 2004
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_pdm_01420_2_w"
boolean hscrollbar = false
end type

event itemchanged;call super::itemchanged;If row < 1 Then Return

Double ldb_buha, day, night, lbl_day, lbl_night

Choose Case dwo.name
	Case 'rfcod'
		
		SELECT RFNA4, TO_NUMBER(RFNA5), RFNA6
		  INTO :ldb_buha, :lbl_day, :lbl_night
		  FROM REFFPF
		 WHERE RFCOD = '3X'
		   AND RFGUB = :data ;
		If SQLCA.SQLCODE <> 0 Then
			MessageBox(String(SQLCA.SQLCODE), SQLCA.SQLERRTEXT)
			Return
		End If
		
		This.SetItem(row, 'botime1', ldb_buha)
		This.SetItem(row, 'time_day', lbl_day)
		This.SetItem(row, 'time_night', lbl_night)

	Case 'time_day'
		
		day = double(data)
		night = This.GetItemDecimal(row, 'time_night');
		
		if isnull(day) then
			day = 0
		end if
		
		if isnull(night) then
			night = 0
		end if

		This.SetItem(row, 'botime1', day + night)
		
	Case 'time_night'

		day = This.GetItemDecimal(row, 'time_day')
		night = double(data)
		
		if isnull(day) then
			day = 0
		end if
		
		if isnull(night) then
			night = 0
		end if

		This.SetItem(row, 'botime1', day + night)

End Choose
end event

type st_2 from statictext within w_pdm_01420
integer x = 3003
integer y = 292
integer width = 82
integer height = 520
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "작업장 일자별 부하시간"
boolean focusrectangle = false
end type

type dw_mon from datawindow within w_pdm_01420
event ue_enter pbm_dwnprocessenter
integer x = 3241
integer y = 176
integer width = 599
integer height = 92
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_pdm_01420_mon"
boolean border = false
boolean livescroll = true
end type

event ue_enter;dw_mon.AcceptText()

String syymm, swkctr
syymm = dw_mon.GetItemString(1, 'd_mon') + '%'
swkctr = dw_list.getitemstring(dw_list.GetRow(), 'wkctr')
dw_boyu.retrieve(syymm, swkctr) 
end event

event constructor;This.SetTransObject(SQLCA)
This.InsertRow(0)

This.SetItem(1, 'd_mon', String(TODAY(), 'yyyymm'))
end event

type cb_2 from commandbutton within w_pdm_01420
integer x = 1243
integer y = 20
integer width = 576
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "부하시간 복사"
end type

event clicked;//dw_mon.AcceptText()
//
//String ls_mon
//String ls_wrk
//
//ls_mon = dw_mon.GetItemString(1, 'd_mon')
//ls_wrk = dw_insert.GetItemString(1, 'wkctr')
//
//SetNull(gs_code)
//SetNull(gs_codename)
//
//gs_code = ls_mon
//gs_codename = ls_wrk

Open(w_pdm_01420_copy)
end event

type rr_1 from roundrectangle within w_pdm_01420
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 160
integer width = 1595
integer height = 2144
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdm_01420
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1659
integer y = 160
integer width = 1312
integer height = 2144
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_pdm_01420
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2985
integer y = 160
integer width = 1582
integer height = 2144
integer cornerheight = 40
integer cornerwidth = 55
end type

