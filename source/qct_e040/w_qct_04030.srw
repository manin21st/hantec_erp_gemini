$PBExportHeader$w_qct_04030.srw
$PBExportComments$** A/S사용자재 등록
forward
global type w_qct_04030 from w_inherite
end type
type dw_ip from u_key_enter within w_qct_04030
end type
type rr_1 from roundrectangle within w_qct_04030
end type
end forward

global type w_qct_04030 from w_inherite
string title = "A/S 사용자재 등록"
boolean resizable = true
dw_ip dw_ip
rr_1 rr_1
end type
global w_qct_04030 w_qct_04030

forward prototypes
public function integer wf_required_chk ()
end prototypes

public function integer wf_required_chk ();//필수입력항목 체크
Long   i
String jpno, iojpno, sysdat
Real   qty, amt

if dw_ip.AcceptText() = -1 then return -1

jpno = Trim(dw_ip.object.rsl_jpno[1])
if IsNull(jpno) or jpno = "" then
	f_message_chk(30,"[A/S 처리번호]")
	dw_ip.SetFocus()
	return -1
end if	

if dw_insert.AcceptText() = -1 then return -1

sysdat = f_today()
for i = 1 to dw_insert.RowCount()
	dw_insert.object.sabu[i] = gs_sabu
	dw_insert.object.rsljpno[i] = dw_ip.object.rsl_jpno[1]
	dw_insert.object.unprc[i] = dw_insert.object.wonprc[i]
	dw_insert.object.unamt[i] = dw_insert.object.amt[i]
	qty = dw_insert.object.qtypr[i]
	amt = dw_insert.object.unamt[i]

	if qty <= 0 then
		f_message_chk(30,"[수량]")
		dw_insert.SetRow(i)
		dw_insert.SetColumn("qtypr")
		dw_insert.SetFocus()
	   return -1
	end if	

/*	if amt <= 0 then
		f_message_chk(30,"[단가]")
		dw_insert.SetRow(i)
		dw_insert.SetColumn("wonprc")
		dw_insert.SetFocus()
	   return -1
	end if	*/
	
	if IsNull(Trim(dw_insert.object.itnbr[i])) or Trim(dw_insert.object.itnbr[i]) = "" then
      f_message_chk(30,"[품번]")
		dw_insert.SetRow(i)
		dw_insert.SetColumn("itnbr")
		dw_insert.SetFocus()
	   return -1
	end if	
	if IsNull(Trim(dw_insert.object.depot_no[i])) or Trim(dw_insert.object.depot_no[i]) = "" then
      f_message_chk(30,"[출고창고]")
		dw_insert.SetRow(i)
		dw_insert.SetColumn("depot_no")
		dw_insert.SetFocus()
	   return -1
	end if	
	//입출고전표번호
	if IsNull(Trim(dw_insert.object.iojpno[i])) or Trim(dw_insert.object.iojpno[i]) = "" then
      iojpno = String(SQLCA.FUN_JUNPYO(gs_sabu, sysdat, 'C0'), "0000") 
		dw_insert.object.iojpno[i] = sysdat + iojpno + "001"
   end if	
	dw_insert.object.sidat[i] = dw_ip.object.rsldat[1]
next

dw_insert.AcceptText()

return 1
end function

on w_qct_04030.create
int iCurrent
call super::create
this.dw_ip=create dw_ip
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_ip
this.Control[iCurrent+2]=this.rr_1
end on

on w_qct_04030.destroy
call super::destroy
destroy(this.dw_ip)
destroy(this.rr_1)
end on

event open;call super::open;String jpno

f_toggle_eng(Handle(this))

dw_insert.SetTransObject(SQLCA)
dw_ip.SetTransObject(SQLCA)

dw_ip.SetRedraw(False)
dw_ip.ReSet()
dw_ip.InsertRow(0)
dw_ip.SetRedraw(True)
	
jpno = Trim(Message.StringParm)
dw_ip.object.rsl_jpno[1] = jpno

String is_ispec, is_jijil
IF f_change_name('1') = 'Y' then 
	is_ispec = f_change_name('2')
	is_jijil = f_change_name('3')
	dw_insert.object.ispec_t.text = is_ispec
	dw_insert.object.jijil_t.text = is_jijil
END IF

if IsNull(jpno) or jpno = "" or jpno = "w_qct_04030" then
	dw_ip.object.rsl_jpno[1] = ""
	dw_ip.SetFocus()	
else
	p_inq.TriggerEvent(Clicked!)
end if	

end event

type dw_insert from w_inherite`dw_insert within w_qct_04030
integer x = 73
integer y = 192
integer width = 4480
integer height = 2072
integer taborder = 40
string dataobject = "d_qct_04030_02"
boolean vscrollbar = true
boolean border = false
boolean livescroll = false
end type

event dw_insert::itemerror;RETURN 1
end event

event dw_insert::itemchanged;String  s_col, s_cod, s_nam1, s_nam2, s_nam3, s_nam4
Integer i_rtn
Dec {2} iamt 
Long crow

ib_any_typing = True //입력필드 변경여부 Yes

s_col = this.GetColumnName()
crow = this.GetRow()
if s_col = "itnbr" or s_col = "itdsc" or s_col = "ispec" or s_col = "ispec_code" or s_col = "jijil" then //품번,품명,규격,규격코드, 재질 
   if s_col = "itnbr" then
		s_cod = Trim(this.getText())   
  	   i_rtn = f_get_name4("품번", "Y", s_cod, s_nam1, s_nam2, s_nam3, s_nam4)
	elseif s_col = "itdsc" then
  	   s_nam1 = Trim(this.getText())   
		i_rtn = f_get_name4("품명", "Y", s_cod, s_nam1, s_nam2, s_nam3, s_nam4)
	elseif s_col = "ispec" then
  	   s_nam2 = Trim(this.getText())
		i_rtn = f_get_name4("규격", "Y", s_cod, s_nam1, s_nam2, s_nam3, s_nam4)
   elseif s_col = "jijil" then
  	   s_nam3 = Trim(this.getText())
		i_rtn = f_get_name4("재질", "Y", s_cod, s_nam1, s_nam2, s_nam3, s_nam4)
   elseif s_col = "ispec_code" then
  	   s_nam4 = Trim(this.getText())
		i_rtn = f_get_name4("규격코드", "Y", s_cod, s_nam1, s_nam2, s_nam3, s_nam4)
  end if
		
	this.object.itnbr[crow] = s_cod
	this.object.itdsc[crow] = s_nam1
	this.object.ispec[crow] = s_nam2
	this.object.jijil[crow] = s_nam3
	this.object.ispec_code[crow] = s_nam4
	if IsNull(s_cod) or s_cod = "" then
		iamt = 0
	else	
	  select decode(cunit, 'WON', unprc, 
				erp000000090_1(substr(:is_today, 1, 6), itnbr, cunit, unprc, '2'))
		 into :iamt
		 from danmst 
		where itnbr  = :s_cod and
				NVL(efrdt, '10000101') <= :is_today  and 
				NVL(eftdt, '99999999') >= :is_today  and 
				opseq = '9999'    and
				sltcd = 'Y'        and
				( guout is null  or
				  guout = '2'    or
				  guout = '1' )   and 
				rownum  = 1  ;
	end if
	
	this.object.wonprc[crow] = iamt
	return i_rtn
elseif s_col = "depot_no" then
	s_cod = Trim(this.getText())   
	i_rtn = f_get_name2("창고", "Y", s_cod, s_nam1, s_nam2)
	this.object.depot_no[crow] = s_cod
	this.object.cvnas2[crow] = s_nam1
	return i_rtn
end if	

end event

event dw_insert::rbuttondown;Real iamt
Long i

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)
i = this.GetRow()

if this.getcolumnname() = "itnbr" then 
	gs_gubun = '3' 
	open(w_itemas_popup)
	if gs_code = '' or isnull(gs_code) then return 
	
   this.object.itnbr[i] = gs_code
	
	this.TriggerEvent(itemchanged!)
elseif this.getcolumnname() = "depot_no" then
	
	open(w_vndmst_46_popup)
	
	if gs_code = '' or isnull(gs_code) then return 
	
   this.object.depot_no[i] = gs_code
	this.object.cvnas2[i] = gs_codename
end if	


end event

event dw_insert::rowfocuschanged;this.SetRowFocusIndicator(HAND!)
if this.RowCount() >= 1 then
	p_mod.Enabled = True
	p_mod.PictureName = 'c:\erpman\image\저장_up.gif'
	
	p_del.Enabled = True
	p_del.PictureName = 'c:\erpman\image\삭제_up.gif'
else
	p_mod.Enabled = False
	p_mod.PictureName = 'c:\erpman\image\저장_d.gif'
	
	p_del.Enabled = False
	p_del.PictureName = 'c:\erpman\image\삭제_d.gif'
end if	
end event

event dw_insert::ue_key;Real iamt
Long i

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)
i = this.GetRow()

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
elseIF keydown(keyF2!) THEN
   if this.getcolumnname() = "itnbr" or this.getcolumnname() = "itdsc" or &
      this.getcolumnname() = "ispec" then //품번,품명,규격
      open(w_itemas_popup2)
      this.object.itnbr[i] = gs_code
	   this.object.itdsc[i] = gs_codename
	   this.object.ispec[i] = gs_gubun
	   if IsNull(gs_code) or gs_code = "" then
		   iamt = 0
	   else	
	      select wonprc into :iamt
	        from itemas
	       where itnbr = :gs_code;
	   end if
	   this.object.wonprc[i] = iamt
	end if	
END IF

return
end event

type p_delrow from w_inherite`p_delrow within w_qct_04030
boolean visible = false
integer x = 4384
integer y = 3340
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_qct_04030
boolean visible = false
integer x = 4210
integer y = 3340
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_qct_04030
boolean visible = false
integer x = 3515
integer y = 3340
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_qct_04030
integer x = 3707
integer taborder = 30
end type

event p_ins::clicked;call super::clicked;Long crow

dw_insert.Setredraw(False)
crow = dw_insert.InsertRow(dw_insert.GetRow() + 1)
if IsNull(crow) then 
	crow = dw_insert.InsertRow(0)
end if	
dw_insert.ScrollToRow(crow)
dw_insert.Setredraw(True)
dw_insert.SetColumn("itnbr")
dw_insert.SetFocus()
end event

type p_exit from w_inherite`p_exit within w_qct_04030
integer x = 4402
end type

type p_can from w_inherite`p_can within w_qct_04030
integer x = 4229
end type

event p_can::clicked;call super::clicked;IF wf_warndataloss("취소") = -1 THEN RETURN //변경된 자료 체크 

dw_insert.SetRedraw(False)
dw_insert.Reset()
dw_insert.SetRedraw(True)

dw_ip.SetRedraw(False)
dw_ip.Reset()
dw_ip.InsertRow(0)
dw_ip.SetRedraw(True)
dw_ip.SetFocus()

w_mdi_frame.sle_msg.Text = "최종 저장 후의 작업을 취소 하였습니다!"
ib_any_typing = False //입력필드 변경여부 No


end event

type p_print from w_inherite`p_print within w_qct_04030
boolean visible = false
integer x = 3689
integer y = 3340
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_qct_04030
integer x = 3534
end type

event p_inq::clicked;call super::clicked;String jpno
Long i, crow

dw_insert.SetRedraw(False)
dw_insert.ReSet()
dw_insert.SetRedraw(True)
	
if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return
end if	
jpno = dw_ip.object.rsl_jpno[1]

if dw_ip.Retrieve(gs_sabu, jpno) < 1 then
	dw_ip.SetRedraw(False)
	dw_ip.ReSet()
	dw_ip.InsertRow(0)
	dw_ip.SetRedraw(True)
	if (IsNull(jpno) or jpno = "")  then 
   else
		MessageBox("A/S 처리번호 확인","등록되지 않은 A/S처리번호 입니다!")
	end if	
	dw_ip.SetColumn("rsl_jpno")
	dw_ip.SetFocus()
	return
end if	

crow = dw_insert.Retrieve(gs_sabu, jpno)
if crow < 1 then
	w_mdi_frame.sle_msg.text = "추가버튼을 누려면 자료를 추가 할 수 있습니다."
else
	for i = 1 to crow 
		dw_insert.object.wonprc[i] = dw_insert.object.unprc[i]	
	next	
end if	


end event

type p_del from w_inherite`p_del within w_qct_04030
integer x = 4055
boolean enabled = false
string picturename = "C:\erpman\image\삭제_d.gif"
end type

event p_del::clicked;call super::clicked;String jpno
long   lcRow

if f_msg_delete() = -1 then return

lcRow = dw_insert.GetRow()
jpno = dw_insert.object.rsljpno[lcRow]

dw_insert.DeleteRow(lcRow)

if IsNull(jpno) or jpno = "" then
	w_mdi_frame.sle_msg.Text = "삭제 되었습니다!"
   ib_any_typing = True //입력필드 변경여부 No
   return
end if

if dw_insert.Update() <> 1 then
   ROLLBACK;
	f_message_chk(31,'[삭제실패 : A/S 소요자재 등록]') 
	w_mdi_frame.sle_msg.Text = "삭제 작업 실패!"
	Return
end if
	
COMMIT;
w_mdi_frame.sle_msg.Text = "삭제 되었습니다!"
ib_any_typing = False //입력필드 변경여부 No
end event

type p_mod from w_inherite`p_mod within w_qct_04030
integer x = 3881
boolean enabled = false
string picturename = "C:\erpman\image\저장_d.gif"
end type

event p_mod::clicked;call super::clicked;Real   tot_amt
String jpno

if f_msg_update() = -1 then return  //저장 Yes/No ?
if wf_required_chk() = -1 then return //필수입력항목 체크 

if dw_insert.Update() <> 1 then
	ROLLBACK;
	f_message_chk(32,'[자료저장 실패 : A/S처리 소요자재]') 
	w_mdi_frame.sle_msg.text = "저장작업 실패 하였습니다!"
	return 
end if

// A/S처리 일반정보의 재료비 UPDATE
dw_insert.AcceptText()
tot_amt = Real(dw_insert.object.tot_amt)
jpno = dw_ip.object.rsl_jpno[1]

update asgnom 
set rslmtr = (select sum(unamt) from aspart where sabu = :gs_sabu and rsljpno = :jpno)
where sabu = :gs_sabu and rsl_jpno = :jpno;

if sqlca.sqlcode <> 0 then
	ROLLBACK;
	f_message_chk(32,'[자료저장 실패 : A/S처리 일반정보 UPDATE]') 
	w_mdi_frame.sle_msg.text = "저장작업 실패 하였습니다!"
	return 
end if

COMMIT;

w_mdi_frame.sle_msg.text = "저장 되었습니다!"

p_del.Enabled = True
p_del.PictureName = 'c:\erpman\image\삭제_d.gif'

ib_any_typing = False //입력필드 변경여부 No
 
end event

type cb_exit from w_inherite`cb_exit within w_qct_04030
boolean visible = false
integer x = 4238
integer y = 3228
end type

type cb_mod from w_inherite`cb_mod within w_qct_04030
boolean visible = false
integer x = 3538
integer y = 3228
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_qct_04030
boolean visible = false
integer x = 2834
integer y = 3224
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_qct_04030
boolean visible = false
integer x = 3186
integer y = 3224
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_qct_04030
boolean visible = false
integer x = 2491
integer y = 3220
end type

type cb_print from w_inherite`cb_print within w_qct_04030
boolean visible = false
integer x = 1033
integer y = 2848
end type

type st_1 from w_inherite`st_1 within w_qct_04030
boolean visible = false
end type

type cb_can from w_inherite`cb_can within w_qct_04030
boolean visible = false
integer x = 3890
integer y = 3228
end type

type cb_search from w_inherite`cb_search within w_qct_04030
boolean visible = false
integer x = 530
integer y = 2848
end type

type dw_datetime from w_inherite`dw_datetime within w_qct_04030
boolean visible = false
end type

type sle_msg from w_inherite`sle_msg within w_qct_04030
boolean visible = false
end type

type gb_10 from w_inherite`gb_10 within w_qct_04030
boolean visible = false
integer y = 2956
integer height = 140
integer textsize = -8
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_qct_04030
boolean visible = false
end type

type gb_button2 from w_inherite`gb_button2 within w_qct_04030
boolean visible = false
end type

type dw_ip from u_key_enter within w_qct_04030
event ue_key pbm_dwnkey
integer x = 59
integer y = 32
integer width = 3456
integer height = 148
integer taborder = 20
string dataobject = "d_qct_04030_01"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

if this.getcolumnname() = "rsl_jpno" then // A/S 처리번호
	open(w_asrslno_popup)
   this.object.rsl_jpno[1] = gs_code
	if IsNull(gs_code) or gs_code = "" then
	   this.SetFocus()	
   else
	   p_inq.TriggerEvent(Clicked!)
   end if	
end if	
end event

event itemerror;call super::itemerror;return 1
end event

event itemchanged;call super::itemchanged;String s_cod

s_cod = Trim(this.GetText())

if this.GetColumnName() = "rsl_jpno" then
	if not(IsNull(s_cod) or s_cod = "") then
	   p_inq.TriggerEvent(Clicked!)
	end if	
end if	
end event

type rr_1 from roundrectangle within w_qct_04030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 64
integer y = 184
integer width = 4503
integer height = 2096
integer cornerheight = 40
integer cornerwidth = 55
end type

