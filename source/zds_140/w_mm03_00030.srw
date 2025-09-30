$PBExportHeader$w_mm03_00030.srw
$PBExportComments$** 자재실사 등록/조정
forward
global type w_mm03_00030 from w_inherite
end type
type dw_1 from datawindow within w_mm03_00030
end type
type rr_1 from roundrectangle within w_mm03_00030
end type
end forward

global type w_mm03_00030 from w_inherite
string title = "재고 실사 등록"
dw_1 dw_1
rr_1 rr_1
end type
global w_mm03_00030 w_mm03_00030

type variables

end variables

forward prototypes
public subroutine wf_set ()
public subroutine wf_check (string arg_date, string arg_depot, integer seq)
public function integer wf_required_chk (integer i)
end prototypes

public subroutine wf_set ();string s_sicdate, s_depot, s_sisdate, s_siedate, s_wandate, s_cycsts, snull, sittyp
int     inull

setnull(snull)

dw_1.setredraw(false)
dw_1.reset()
dw_1.insertrow(0)

dw_1.setitem(1, 'depot', snull)
dw_1.setitem(1, 'ittyp', snull)
dw_1.setitem(1, 'seq',  inull)
dw_1.setitem(1, 'cr_date', snull)
dw_1.setitem(1, 'fr_date', snull)
dw_1.setitem(1, 'to_date', snull)
dw_1.setitem(1, 'wan_date', snull)
dw_1.setitem(1, 'cycsts', snull)

p_print.enabled = False
p_search.enabled = False
dw_1.setredraw(True)

end subroutine

public subroutine wf_check (string arg_date, string arg_depot, integer seq);string s_sisdate, s_siedate, s_wandate, s_cycsts, snull, get_date, s_gub

setnull(snull)

SELECT "ITMCYC"."SISDAT", "ITMCYC"."SIEDAT", "ITMCYC"."CYCSTS", "ITMCYC"."WANDAT", 
		 "ITMCYC"."JEGO_GUB"    
  INTO :s_sisdate,        :s_siedate,        :s_cycsts,          :s_wandate, 
		 :s_gub 
  FROM "ITMCYC"  
 WHERE ( "ITMCYC"."SABU"   = :gs_sabu ) AND  
		 ( "ITMCYC"."DEPOT"  = :arg_depot ) AND  
		 ( "ITMCYC"."SICDAT" = :arg_date ) AND  
		 ( "ITMCYC"."SISEQ"  = :seq ) AND ROWNUM = 1  ;
									
IF SQLCA.SQLCODE = 0 THEN 
	dw_1.setitem(1, 'cr_date', arg_date)
	dw_1.setitem(1, 'fr_date', s_sisdate)
	dw_1.setitem(1, 'to_date', s_siedate)
	dw_1.setitem(1, 'wan_date', s_wandate)
	dw_1.setitem(1, 'cycsts', s_cycsts)
	dw_1.setitem(1, 'jego_gub', s_gub)
	if s_cycsts = '1' then //상태가 생성이면
		p_print.enabled = true
		p_search.enabled = false
	else
		p_print.enabled = False
		p_search.enabled = True
	end if   
ELSE
	dw_1.setitem(1, 'fr_date', snull)
	dw_1.setitem(1, 'to_date', snull)
	dw_1.setitem(1, 'wan_date', snull)
	dw_1.setitem(1, 'cycsts', snull)
	p_print.enabled = False
	p_search.enabled = False
END IF



end subroutine

public function integer wf_required_chk (integer i);//if dw_insert.AcceptText() = -1 then return -1
//
//if isnull(dw_insert.GetItemNumber(i,'sijqty')) then
//	f_message_chk(1400,'[ '+string(i)+' 행 실사수량]')
//	dw_insert.ScrollToRow(i)
//	dw_insert.SetColumn('sijqty')
//	dw_insert.SetFocus()
//	return -1		
//end if	
//
return 1
end function

on w_mm03_00030.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_mm03_00030.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.rr_1)
end on

event open;call super::open;
dw_insert.SetTransObject(sqlca)
dw_1.SetTransObject(sqlca)

String is_ispec, is_jijil
IF f_change_name('1') = 'Y' then 
	is_ispec = f_change_name('2')
	is_jijil = f_change_name('3')
	dw_insert.object.ispec_t.text = is_ispec
	dw_insert.object.jijil_t.text = is_jijil
END IF

wf_set()


end event

event key;// Page Up & Page Down & Home & End Key 사용 정의
choose case key
	case keypageup!
		dw_insert.scrollpriorpage()
	case keypagedown!
		dw_insert.scrollnextpage()
	case keyhome!
		dw_insert.scrolltorow(1)
	case keyend!
		dw_insert.scrolltorow(dw_insert.rowcount())
	case KeyupArrow!
		dw_insert.scrollpriorrow()
	case KeyDownArrow!
		dw_insert.scrollnextrow()		
end choose


end event

type dw_insert from w_inherite`dw_insert within w_mm03_00030
integer x = 64
integer y = 456
integer width = 4535
integer height = 1840
integer taborder = 30
string dataobject = "d_mm03_00030_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::ue_pressenter;Send(Handle(this),256,9,0)
Return 1

end event

event dw_insert::itemerror;return 1
end event

event dw_insert::itemchanged;decimal{3}  dgap, dqty
string   snull, siogbn
long     lrow
str_itmcyc istr_itmcyc

setnull(snull)

lrow = this.getrow()
this.accepttext()

IF this.GetColumnName() ="sijqty" THEN
	dgap = this.getitemdecimal(lrow, 'dgap')
	dqty = this.getitemdecimal(lrow, 'itmcyc_cujqty')
	
   if dgap <> 0 then 
		IF dgap > 0 then
			siogbn    = 'I14'
		   gs_gubun  = siogbn
		ELSE	
		   siogbn    = 'O08'
		   gs_gubun  = siogbn
		END IF	
		istr_itmcyc.depot  = dw_insert.getitemstring(lrow, 'itmcyc_depot')
		istr_itmcyc.sicdat = dw_insert.getitemstring(lrow, 'itmcyc_sicdat')
		istr_itmcyc.siseq  = dw_insert.getitemnumber(lrow, 'itmcyc_siseq')
		istr_itmcyc.itnbr  = dw_insert.getitemstring(lrow, 'itmcyc_itnbr')
		istr_itmcyc.pspec  = dw_insert.getitemstring(lrow, 'itmcyc_pspec')
		
		OpenWithParm(w_mm03_00030_popup, istr_itmcyc)
		
		if gs_gubun = 'Y' then 
		   this.setitem(lrow, 'bigo', gs_code)
			this.setitem(lrow, 'crtgub', gs_codename)
			if gs_codename = 'Y' then 
				this.setitem(lrow, 'iogbn', siogbn)
			else
				this.setitem(lrow, 'iogbn', snull)
				this.setitem(lrow, 'sijqty', dqty)
				return 1
			end if
		else
			this.setitem(lrow, 'sijqty', dqty)
			return 1
		end if	
	else
	   this.setitem(lrow, 'bigo', snull)
	   this.setitem(lrow, 'crtgub', 'N')
	   this.setitem(lrow, 'iogbn', snull)
   end if
End if

end event

event dw_insert::losefocus;this.accepttext()
end event

type p_delrow from w_inherite`p_delrow within w_mm03_00030
boolean visible = false
integer x = 3415
integer y = 3276
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_mm03_00030
boolean visible = false
integer x = 3241
integer y = 3276
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_mm03_00030
integer x = 3383
integer taborder = 70
boolean enabled = false
string picturename = "C:\erpman\image\완료취소_up.gif"
end type

event p_search::clicked;call super::clicked;String  s_date, s_depot, s_crdate, s_cycsts
int     iseq, lRtnValue

IF dw_1.AcceptText() = -1 THEN RETURN 
s_cycsts = dw_1.GetItemString(1, 'cycsts')
s_depot  = dw_1.GetItemString(1, 'depot')
s_crdate = trim(dw_1.GetItemString(1, 'cr_date'))
s_date   = trim(dw_1.GetItemString(1, 'wan_date'))

iseq     = dw_1.GetItemNumber(1, 'seq')

if s_cycsts <> '2' then 
	messagebox("확인", "완료취소 처리를 할 수 없는 자료입니다.")
	return 
end if	

if isnull(s_depot) or s_depot = "" then
	f_message_chk(30,'[창고]')
	dw_1.SetColumn('depot')
	dw_1.SetFocus()
	return
end if	

if isnull(s_crdate) or s_crdate = "" then
	f_message_chk(30,'[생성일자]')
	dw_1.SetColumn('cr_date')
	dw_1.SetFocus()
	return
end if	

if isnull(s_date) or s_date = "" then
	f_message_chk(30,'[완료일자]')
	dw_1.SetColumn('wan_date')
	dw_1.SetFocus()
	return
end if	

IF Messagebox('확 인','취소 처리 하시겠습니까?',Question!,YesNo!,1) <> 1 THEN RETURN 

SetPointer(HourGlass!)

w_mdi_frame.sle_msg.text = "주기 실사 완료 취소 처리 中 ........."

lRtnValue = sqlca.erp000000210_1(gs_sabu, s_depot, s_crdate, iseq)

IF lRtnValue < 0 THEN	
	ROLLBACK;
	w_mdi_frame.sle_msg.text = ""
	f_message_chk(32,'[완료 취소실패] ' + string(lRtnValue) )
	Return
else
	commit;
	w_mdi_frame.sle_msg.text = "주기 실사 자료 완료취소 처리되었습니다."
end if	

SetPointer(Arrow!)
p_can.TriggerEvent(Clicked!)

end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\완료취소_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\완료취소_up.gif"
end event

type p_ins from w_inherite`p_ins within w_mm03_00030
integer x = 3730
integer taborder = 90
string pointer = "C:\erpman\cur\point.cur"
string picturename = "C:\erpman\image\사유조회_up.gif"
end type

event p_ins::clicked;call super::clicked;decimal  dgap, dqty
string   snull, siogbn, scycsts
long     lrow
str_itmcyc istr_itmcyc  

setnull(snull)

if dw_insert.accepttext() = -1 then return 

IF dw_insert.rowcount() < 1 then 
	messagebox("확 인", "조회 후 자료를 선택하세요!")
	return 
END IF	

lrow = dw_insert.GetRow()

IF lrow < 1 then 
	messagebox("확 인", "자료를 선택하세요!")
	return 
END IF	

dgap    = dw_insert.getitemdecimal(lrow, 'dgap')
dqty    = dw_insert.getitemdecimal(lrow, 'itmcyc_cujqty')
scycsts = dw_insert.getitemstring(lrow, 'cycsts')

if scycsts = '1' then 
	IF dgap > 0 then
		siogbn    = 'I14'
		gs_gubun  = siogbn
	ELSEIF dgap = 0 then 
		siogbn    = snull
		gs_gubun  = siogbn
	ELSE	
		siogbn    = 'O08'
		gs_gubun  = siogbn
	END IF	
else
	gs_gubun = 'Y'
end if

istr_itmcyc.depot  = dw_insert.getitemstring(lrow, 'itmcyc_depot')
istr_itmcyc.sicdat = dw_insert.getitemstring(lrow, 'itmcyc_sicdat')
istr_itmcyc.siseq  = dw_insert.getitemnumber(lrow, 'itmcyc_siseq')
istr_itmcyc.itnbr  = dw_insert.getitemstring(lrow, 'itmcyc_itnbr')
istr_itmcyc.pspec  = dw_insert.getitemstring(lrow, 'itmcyc_pspec')

OpenWithParm(w_mm03_00030_popup, istr_itmcyc)

if scycsts = '1' then 
	if gs_gubun = 'Y' then 
		dw_insert.setitem(lrow, 'bigo', gs_code)
		dw_insert.setitem(lrow, 'crtgub', gs_codename)
		if gs_codename = 'Y' then 
			dw_insert.setitem(lrow, 'iogbn', siogbn)
		else
			dw_insert.setitem(lrow, 'iogbn', snull)
			dw_insert.setitem(lrow, 'sijqty', dqty)
		end if
	else
		dw_insert.setitem(lrow, 'bigo', snull)
		dw_insert.setitem(lrow, 'crtgub', 'N')
		dw_insert.setitem(lrow, 'iogbn', snull)
		dw_insert.setitem(lrow, 'sijqty', dqty)
	end if	
end if

end event

event p_ins::ue_lbuttondown;PictureName = "C:\erpman\image\사유조회_dn.gif"
end event

event p_ins::ue_lbuttonup;PictureName = "C:\erpman\image\사유조회_up.gif"
end event

type p_exit from w_inherite`p_exit within w_mm03_00030
integer taborder = 60
end type

type p_can from w_inherite`p_can within w_mm03_00030
integer taborder = 50
end type

event p_can::clicked;call super::clicked;wf_set()

dw_insert.setredraw(false)
dw_insert.reset()
dw_insert.setredraw(True)

ib_any_typing = FALSE



end event

type p_print from w_inherite`p_print within w_mm03_00030
integer x = 3557
integer taborder = 80
string pointer = "C:\erpman\cur\point.cur"
boolean enabled = false
string picturename = "C:\erpman\image\실사완료_up.gif"
end type

event p_print::clicked;call super::clicked;String  s_date, s_depot, s_crdate, get_status, s_cycsts, sjpno
long    lrtnvalue
Integer iMaxOrderNo, iseq

IF dw_1.AcceptText() = -1 THEN RETURN 
s_cycsts = dw_1.GetItemString(1, 'cycsts')
s_depot  = dw_1.GetItemString(1, 'depot')
s_crdate = trim(dw_1.GetItemString(1, 'cr_date'))
s_date   = trim(dw_1.GetItemString(1, 'wan_date'))
iseq     = dw_1.GetItemNumber(1, 'seq')

if s_cycsts <> '1' then 
	messagebox("확인", "실사완료처리를 할 수 없는 자료입니다.")
	return 
end if	

if isnull(s_depot) or s_depot = "" then
	f_message_chk(30,'[창고]')
	dw_1.SetColumn('depot')
	dw_1.SetFocus()
	return
end if	

if isnull(s_crdate) or s_crdate = "" then
	f_message_chk(30,'[기준일자]')
	dw_1.SetColumn('cr_date')
	dw_1.SetFocus()
	return
end if	

if isnull(iseq) or iseq = 0 then
	f_message_chk(30,'[순번]')
	dw_1.SetColumn('seq')
	dw_1.SetFocus()
	return
end if	

if isnull(s_date) or s_date = "" then
	f_message_chk(30,'[조정일자]')
	dw_1.SetColumn('wan_date')
	dw_1.SetFocus()
	return
end if	

IF Messagebox('확 인','완료 처리 하시겠습니까?',Question!,YesNo!,1) <> 1 THEN RETURN 

SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text = "전표 채번 中 ........."

iMaxOrderNo = sqlca.fun_junpyo(gs_sabu, s_Date, 'C0')
IF iMaxOrderNo <= 0 THEN
   w_mdi_frame.sle_msg.text = ""
	f_message_chk(51,'')
	ROLLBACK;
END IF

sjpno = s_Date + String(iMaxOrderNo,'0000')

Commit;

w_mdi_frame.sle_msg.text = "실사 차이에 의한 전표 생성 中 ........."

lRtnValue = sqlca.erp000000210(gs_sabu, s_depot, s_crdate, iseq, s_date, sjpno )

IF lRtnValue = -1 THEN	
	ROLLBACK;
	w_mdi_frame.sle_msg.text = ""
	f_message_chk(89,'[전표생성 실패]')
	Return
ELSEIF lRtnValue = -3 THEN	
	ROLLBACK;
	w_mdi_frame.sle_msg.text = ""
	f_message_chk(32,'[완료처리 실패]')
	Return
ELSEIF lRtnValue = -9 THEN	
	ROLLBACK;
	w_mdi_frame.sle_msg.text = ""
	f_message_chk(89,'[작업 실패]')
	Return
ELSEIF lRtnValue = -6 THEN	
	ROLLBACK;
	w_mdi_frame.sle_msg.text = ""
	f_message_chk(89,'[갱신 실패]')
	Return
END IF

commit;
if lrtnvalue = 0 then 	
	w_mdi_frame.sle_msg.text = "주기 실사 자료 완료 처리되었습니다."
	messagebox("완료확인", "주기실사 완료 처리 되었습니다.")
elseif lrtnvalue = 1 then 
	w_mdi_frame.sle_msg.text = "주기 실사 자료 완료 처리되었습니다. (" + &
	               string(lRtnValue) + '건에 전표가 생성처리)'
	messagebox("완료확인", sjpno + '001' + " 전표 생성")
elseif lrtnvalue > 1 then 
	w_mdi_frame.sle_msg.text = "주기 실사 자료 완료 처리되었습니다. (" + &
	               string(lRtnValue) + '건에 전표가 생성처리)'
	messagebox("완료확인", sjpno + '-001 부터' + sjpno + '-' + string(lRtnValue, '000') + " 까지 전표 생성")
end if

SetPointer(Arrow!)
p_can.TriggerEvent(Clicked!)
end event

event p_print::ue_lbuttondown;PictureName = "C:\erpman\image\실사완료_dn.gif"
end event

event p_print::ue_lbuttonup;PictureName = "C:\erpman\image\실사완료_up.gif"
end event

type p_inq from w_inherite`p_inq within w_mm03_00030
integer x = 3922
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;string s_depot, s_fritnbr, s_toitnbr, s_crdate, s_ittyp, s_itcls
int    iseq

if dw_1.AcceptText() = -1 then return 

s_depot   = trim(dw_1.GetItemString(1,'depot'))
s_crdate  = trim(dw_1.GetItemString(1,'cr_date'))
iseq      = dw_1.GetItemNumber(1,'seq')
s_ittyp   = trim(dw_1.GetItemString(1,'ittyp'))
s_itcls   = trim(dw_1.GetItemString(1,'itcls'))
s_fritnbr = trim(dw_1.GetItemString(1,'fr_itnbr'))
s_toitnbr = trim(dw_1.GetItemString(1,'to_itnbr'))

if isnull(s_depot) or s_depot = "" then
	f_message_chk(30,'[창고]')
	dw_1.SetColumn('depot')
	dw_1.SetFocus()
	return
end if	

if isnull(s_crdate) or s_crdate = "" then
	f_message_chk(30,'[생성일자]')
	dw_1.SetColumn('cr_date')
	dw_1.SetFocus()
	return
end if	

if isnull(iseq) or iseq = 0 then
	f_message_chk(30,'[순번]')
	dw_1.SetColumn('seq')
	dw_1.SetFocus()
	return
end if	

if isnull(s_ittyp) or s_ittyp = "" then
	s_ittyp = '%'
end if	

if isnull(s_itcls) or s_itcls = "" then 
	s_itcls = '%'
else
	s_itcls = s_itcls + '%'
end if	

if isnull(s_fritnbr) or s_fritnbr = "" then s_fritnbr = '.'
if isnull(s_toitnbr) or s_toitnbr = "" then s_toitnbr = 'zzzzzzzzzzzzzzz'

if s_fritnbr > s_toitnbr then 
	f_message_chk(34,'[품번]')
	dw_1.Setcolumn('fr_itnbr')
	dw_1.SetFocus()
	return
end if	

if dw_insert.Retrieve(gs_sabu, s_depot, s_crdate, s_fritnbr, s_toitnbr, s_ittyp, s_itcls, iseq) <= 0 then 
	dw_1.Setfocus()
	return
else
   dw_insert.SetColumn('sijqty')
	dw_insert.SetFocus()
end if	

ib_any_typing = FALSE


end event

type p_del from w_inherite`p_del within w_mm03_00030
boolean visible = false
integer x = 3762
integer y = 3276
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_mm03_00030
integer x = 4096
integer taborder = 40
end type

event p_mod::clicked;call super::clicked;long i

if dw_insert.AcceptText() = -1 then return 

if dw_insert.rowcount() <= 0 then return 	


//FOR i = 1 TO dw_insert.RowCount()
//	IF wf_required_chk(i) = -1 THEN RETURN
//NEXT
//
if f_msg_update() = -1 then return
	
if dw_insert.update() = 1 then
	w_mdi_frame.sle_msg.text = "자료가 저장되었습니다!!"
	ib_any_typing= FALSE
	commit ;
else
	rollback ;
	messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
	return 
end if	
		

end event

type cb_exit from w_inherite`cb_exit within w_mm03_00030
integer x = 2825
integer y = 3288
end type

type cb_mod from w_inherite`cb_mod within w_mm03_00030
integer x = 2121
integer y = 3288
end type

type cb_ins from w_inherite`cb_ins within w_mm03_00030
integer x = 462
integer y = 3288
string text = "사유조회"
end type

type cb_del from w_inherite`cb_del within w_mm03_00030
integer x = 1143
integer y = 2392
end type

type cb_inq from w_inherite`cb_inq within w_mm03_00030
integer x = 1774
integer y = 3288
end type

type cb_print from w_inherite`cb_print within w_mm03_00030
integer x = 814
integer y = 3288
integer width = 462
boolean enabled = false
string text = "실사완료(&E)"
end type

type st_1 from w_inherite`st_1 within w_mm03_00030
end type

type cb_can from w_inherite`cb_can within w_mm03_00030
integer x = 2473
integer y = 3288
end type

type cb_search from w_inherite`cb_search within w_mm03_00030
integer x = 1294
integer y = 3288
integer width = 462
boolean enabled = false
string text = "완료취소(&F)"
end type





type gb_10 from w_inherite`gb_10 within w_mm03_00030
integer x = 9
integer y = 2968
integer height = 144
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_mm03_00030
end type

type gb_button2 from w_inherite`gb_button2 within w_mm03_00030
end type

type dw_1 from datawindow within w_mm03_00030
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 41
integer y = 24
integer width = 3296
integer height = 412
integer taborder = 10
string dataobject = "d_mm03_00030_a"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;setnull(gs_code)

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	IF This.GetColumnName() = "fr_itnbr" Then
		open(w_itemas_popup2)
		if isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(1,"fr_itnbr",gs_code)
		RETURN 1
	ELSEIF This.GetColumnName() = "to_itnbr" Then
		open(w_itemas_popup2)
		if isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(1,"to_itnbr",gs_code)
		RETURN 1
   END IF
END IF

end event

event itemchanged;string snull, sdate, sdepot, sittyp, sitcls, s_name
int    ireturn, iseq 

setnull(snull)
IF this.GetColumnName() ="depot" THEN
	sdepot = trim(this.GetText())
	sdate =  trim(this.getitemstring(1, 'cr_date'))
	iseq  =  this.getitemNumber(1, 'seq')
	
	SELECT "VNDMST"."JUPROD" INTO :sittyp  FROM "VNDMST"  WHERE "VNDMST"."CVCOD" = :sdepot   ;

	dw_1.setitem(1, 'ittyp', sittyp)
	wf_check(sdate, sdepot, iseq)
	dw_insert.reset()
ELSEIF this.GetColumnName() ="cr_date" THEN
	sdate  =  trim(this.GetText())
	iseq   =  this.getitemNumber(1, 'seq')
	sdepot =  trim(this.getitemstring(1, 'depot'))
	
	if sdate = "" or isnull(sdate) then
   	wf_check(sdate, sdepot, iseq)
		return 
   end if
  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[기준일자]')
		this.setitem(1, "cr_date", sNull)
   	wf_check(sdate, sdepot, iseq)
		return 1
   ELSE
   	sdepot =  trim(this.getitemstring(1, 'depot'))
   	wf_check(sdate, sdepot, iseq)
   END IF
ELSEIF this.GetColumnName() ="seq" THEN
	sdate  =  trim(this.getitemstring(1, 'cr_date'))
	iseq   =  integer(this.GetText())
	sdepot =  trim(this.getitemstring(1, 'depot'))

  	wf_check(sdate, sdepot, iseq)
	
ELSEIF this.GetColumnName() ="wan_date" THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[조정일자]')
		this.setitem(1, "wan_date", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = "ittyp"	THEN
		This.setitem(1, 'itcls', snull)
		this.SetItem(1, 'titnm', snull)
ELSEIF this.GetColumnName() = "itcls"	THEN
	sitcls = this.gettext()
   IF sitcls = "" OR IsNull(sitcls) THEN 
		this.SetItem(1,'titnm', snull)
		return 
   ELSE
		sittyp  = this.getitemstring(1, 'ittyp')
		ireturn = f_get_name2('품목분류', 'Y', sitcls, s_name, sittyp)
		This.setitem(1, 'itcls', sitcls)
		This.setitem(1, 'titnm', s_name)
   END IF
	return ireturn 
END IF

end event

event itemerror;return 1
end event

event rbuttondown;string sname
str_itnct lstr_sitnct

setnull(gs_code)
setnull(gs_gubun)
setnull(gs_codename)

if this.GetColumnName() = 'fr_itnbr' then
   gs_code = this.GetText()
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"fr_itnbr",gs_code)
elseif this.GetColumnName() = 'to_itnbr' then
   gs_code = this.GetText()
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"to_itnbr",gs_code)
elseif this.GetColumnName() = 'itcls' then
   this.accepttext()
	sname = this.GetItemString(1, 'ittyp')
	OpenWithParm(w_ittyp_popup4, sname)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"ittyp",lstr_sitnct.s_ittyp)
   
	this.SetItem(1,"itcls", lstr_sitnct.s_sumgub)
	this.SetItem(1,"titnm", lstr_sitnct.s_titnm)
elseif this.GetColumnName() = 'seq' then
   gs_code = this.GetItemstring(1, 'depot')
	open(w_itmcyc_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"depot",  gs_gubun)
	this.SetItem(1,"cr_date", gs_code)
	this.SetItem(1,"seq",    integer(gs_codename))
	this.triggerevent(itemchanged!)
end if
end event

type rr_1 from roundrectangle within w_mm03_00030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 444
integer width = 4558
integer height = 1868
integer cornerheight = 40
integer cornerwidth = 55
end type

