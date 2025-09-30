$PBExportHeader$w_pdt_06060.srw
$PBExportComments$수리 사용자재 등록(메뉴에서 삭제)
forward
global type w_pdt_06060 from w_inherite
end type
type dw_ins1 from u_key_enter within w_pdt_06060
end type
type cb_add from commandbutton within w_pdt_06060
end type
type p_add from uo_picture within w_pdt_06060
end type
type rr_1 from roundrectangle within w_pdt_06060
end type
type rr_2 from roundrectangle within w_pdt_06060
end type
end forward

global type w_pdt_06060 from w_inherite
integer width = 3717
integer height = 2192
string title = "사용자재 등록"
boolean resizable = true
boolean center = true
dw_ins1 dw_ins1
cb_add cb_add
p_add p_add
rr_1 rr_1
rr_2 rr_2
end type
global w_pdt_06060 w_pdt_06060

type variables
String sIspecText, sJijilText
string  is_gubun  //구분(4:설비)
end variables

forward prototypes
public function integer wf_required_chk ()
end prototypes

public function integer wf_required_chk ();String sidat, mchno, s_itnbr, siojpno 
Long   i, ll_found, ljpno, lRow
int    iseq, ijpno

sidat = Trim(dw_ins1.object.sidat[1])
mchno = Trim(dw_ins1.object.mchno[1])
iseq  = dw_ins1.object.seq[1]

if IsNull(sidat) or sidat = "" then
	f_message_chk(1400,"[실시일자]")
	return -1
end if	
if IsNull(mchno) or mchno = "" then
	f_message_chk(1400,"[관리번호]")
	return -1
end if	
if IsNull(iseq) or iseq <= 0 then
	f_message_chk(1400,"[의뢰번호]")
	return -1
end if	

iJpno = 0
lRow = dw_insert.RowCount()
for i = 1 to lRow
	if IsNull(Trim(dw_insert.object.itnbr[i])) or Trim(dw_insert.object.itnbr[i]) = "" then
		f_message_chk(1400,"[품번]")
		dw_insert.SetRow(i)
		dw_insert.SetColumn("itnbr")
		dw_insert.SetFocus()
		return -1
	end if
	if IsNull(dw_insert.object.qtypr[i]) or dw_insert.object.qtypr[i] <= 0 then
		f_message_chk(1400,"[사용수량]")
		dw_insert.SetRow(i)
		dw_insert.SetColumn("qtypr")
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
		IF iJpno < 1 THEN 
			lJpno = SQLCA.FUN_JUNPYO(gs_sabu, sidat, 'C0')
			IF lJpno < 1 then 
				messagebox('확 인', '전표채번을 실패하였습니다. 전산실에 문의하세요!')
				return -1
			ELSE
				COMMIT ;
			END IF
			
			siojpno = String(lJpno, "0000") 
			iJpno = 1 
		ELSE
			iJpno ++ 
		END IF
		
		dw_insert.object.iojpno[i] = sidat + siojpno + String(iJpno, "000") 
		dw_insert.object.sabu[i]  = gs_sabu
		dw_insert.object.sidat[i] = sidat
		dw_insert.object.mchno[i] = mchno
		dw_insert.object.seqno[i] = iseq
		dw_insert.object.gubun[i] = is_gubun
   end if	
next

return 1
end function

on w_pdt_06060.create
int iCurrent
call super::create
this.dw_ins1=create dw_ins1
this.cb_add=create cb_add
this.p_add=create p_add
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_ins1
this.Control[iCurrent+2]=this.cb_add
this.Control[iCurrent+3]=this.p_add
this.Control[iCurrent+4]=this.rr_1
this.Control[iCurrent+5]=this.rr_2
end on

on w_pdt_06060.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_ins1)
destroy(this.cb_add)
destroy(this.p_add)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_insert.SetTransObject(SQLCA)
dw_ins1.InsertRow(0)

is_gubun  = gs_gubun //4:설비
dw_ins1.object.sidat[1]  = gs_codename2
dw_ins1.object.mchno[1]  = gs_code
dw_ins1.object.mchnam[1] = gs_codename
dw_ins1.object.seq[1]    = gi_page

/* 규격,재질 Text 변경 */
If f_change_name('1') = 'Y' Then
	sIspecText = f_change_name('2')
	sJijilText = f_change_name('3')
	dw_insert.Object.ispec_t.text =  sIspecText 
	dw_insert.Object.jijil_t.text =  sJijilText
End If

p_inq.TriggerEvent(Clicked!)

end event

type dw_insert from w_inherite`dw_insert within w_pdt_06060
integer x = 46
integer y = 296
integer width = 3584
integer height = 1656
integer taborder = 20
string dataobject = "d_pdt_06060_02"
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemerror;return 1
end event

event dw_insert::itemchanged;String s_cod, s_nam1, s_nam2, s_nam3, s_nam4 
Integer i_rtn
Long crow

s_cod = Trim(this.GetText())
crow = this.GetRow()

if	this.getcolumnname() = "itnbr" then
	i_rtn = f_get_name4("품번","Y",s_cod, s_nam1, s_nam2, s_nam3, s_nam4)
	dw_insert.object.itnbr[crow] = s_cod
	dw_insert.object.itdsc[crow] = s_nam1
	dw_insert.object.ispec[crow] = s_nam2
	dw_insert.object.jijil[crow] = s_nam3
	dw_insert.object.ispec_code[crow] = s_nam4
   return i_rtn  
elseif this.getcolumnname() = "itdsc" then
   i_rtn = f_get_name4("품명", "Y", s_nam1, s_cod, s_nam2, s_nam3, s_nam4)
   this.object.itnbr[crow] = s_nam1
   this.object.itdsc[crow] = s_cod
   this.object.ispec[crow] = s_nam2
	dw_insert.object.jijil[crow] = s_nam3
	dw_insert.object.ispec_code[crow] = s_nam4
   return i_rtn  
elseif this.getcolumnname() = "ispec" then
   i_rtn = f_get_name4("규격", "Y", s_nam1, s_nam2, s_cod, s_nam3, s_nam4)
   this.object.itnbr[crow] = s_nam1
   this.object.itdsc[crow] = s_nam2
   this.object.ispec[crow] = s_cod
	dw_insert.object.jijil[crow] = s_nam3
	dw_insert.object.ispec_code[crow] = s_nam4
   return i_rtn  
elseif this.getcolumnname() = "jijil" then
   i_rtn = f_get_name4("재질", "Y", s_nam1, s_nam2, s_nam3, s_cod, s_nam4)
   this.object.itnbr[crow] = s_nam1
   this.object.itdsc[crow] = s_nam2
   this.object.ispec[crow] = s_nam3
	dw_insert.object.jijil[crow] = s_cod
	dw_insert.object.ispec_code[crow] = s_nam4
   return i_rtn 
elseif this.getcolumnname() = "ispec_code" then
   i_rtn = f_get_name4("규격코드", "Y", s_nam1, s_nam2, s_nam3, s_nam4, s_cod)
   this.object.itnbr[crow] = s_nam1
   this.object.itdsc[crow] = s_nam2
   this.object.ispec[crow] = s_nam3
	dw_insert.object.jijil[crow] = s_nam4
	dw_insert.object.ispec_code[crow] = s_cod
   return i_rtn 
elseif this.getcolumnname() = "depot_no" then	
	i_rtn = f_get_name2("창고", "Y", s_cod, s_nam1, s_nam2)
   this.object.depot_no[crow] = s_cod
   this.object.cvnas2[crow] = s_nam1
   return i_rtn  
end if



end event

event dw_insert::ue_key;call super::ue_key;Long crow 
String s_jijil

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

SetNull(s_jijil)

crow = this.GetRow()
IF keydown(keyF2!) THEN
   IF	this.getcolumnname() = "itnbr" or this.getcolumnname() = "itdsc" or &
	   this.getcolumnname() = "ispec" THEN		
	   open(w_itemas_popup2)
	   this.SetItem(crow, "itnbr", gs_code)
	   this.SetItem(crow, "itdsc", gs_codename)
      this.SetItem(crow, "ispec", gs_gubun)
		if IsNull(gs_code) or gs_code = "" then return 1
		select jijil into :s_jijil from itemas
		 where itnbr = :gs_code;
		this.SetItem(crow, "jijil", s_jijil) 
      return 1
   END IF
END IF
end event

event dw_insert::rbuttondown;Long crow

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

crow = this.getRow()
IF	this.getcolumnname() = "itnbr"  THEN		 
	gs_gubun = '5' 
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = '' then return 
	
	this.SetItem(crow, "itnbr", gs_code)
	this.triggerevent(itemchanged!)
ELSEIF this.getcolumnname() = "depot_no" THEN		
	open(w_vndmst_46_popup)
	if isnull(gs_code) or gs_code = '' then return 
	this.SetItem(crow, "depot_no", gs_code)
	this.SetItem(crow, "cvnas2", gs_codename)
END IF


end event

event dw_insert::rowfocuschanged;//this.SetRowFocusIndicator(HAND!)
end event

type p_delrow from w_inherite`p_delrow within w_pdt_06060
integer y = 5000
end type

type p_addrow from w_inherite`p_addrow within w_pdt_06060
integer y = 5000
end type

type p_search from w_inherite`p_search within w_pdt_06060
integer y = 5000
end type

type p_ins from w_inherite`p_ins within w_pdt_06060
integer x = 4087
integer y = 5000
end type

type p_exit from w_inherite`p_exit within w_pdt_06060
integer x = 3392
integer y = 84
end type

type p_can from w_inherite`p_can within w_pdt_06060
integer y = 5000
end type

type p_print from w_inherite`p_print within w_pdt_06060
integer y = 5000
end type

type p_inq from w_inherite`p_inq within w_pdt_06060
integer x = 2697
integer y = 84
end type

event p_inq::clicked;call super::clicked;String sidat, mchno, s_stopdat
int    iseq

if dw_ins1.AcceptText() = -1 then return
sidat = dw_ins1.object.sidat[1]
mchno = dw_ins1.object.mchno[1]
iseq   = dw_ins1.object.seq[1]

if IsNull(sidat) or sidat = "" then
	f_message_chk(30, "[실시일자]")
	dw_ins1.SetColumn("sidat")
	dw_ins1.SetFocus()
   return
end if
if IsNull(mchno) or mchno = "" then
	f_message_chk(30, "[관리번호]")
	dw_ins1.SetColumn("mchno")
	dw_ins1.SetFocus()
   return
end if
if IsNull(iseq) or iseq <= 0 then
	f_message_chk(30, "[의뢰번호]")
	dw_ins1.SetColumn("seq")
	dw_ins1.SetFocus()
   return
end if

//사용중지일자 확인
select stopdat into :s_stopdat from mchmst
 where sabu = :gs_sabu and mchno = :mchno;
 
if sqlca.sqlcode <> 0 or (not (IsNull(s_stopdat) or s_stopdat = "")) then
	MessageBox("사용중지일자 확인", String(s_stopdat,"@@@@.@@.@@") + " 일자로 사용 중지된 설비 입니다!")
end if	

if dw_insert.Retrieve(gs_sabu, sidat, mchno, iseq, is_gubun) < 1 then
	p_del.Enabled = False
	p_del.picturename = "c:\erpman\image\삭제_d.gif"
	sle_msg.text = "신규로 등록하세요!"
else
	p_del.Enabled = True
	p_del.picturename = "c:\erpman\image\삭제_up.gif"
	sle_msg.text = ""
end if	
dw_insert.SetFocus()

end event

type p_del from w_inherite`p_del within w_pdt_06060
integer x = 3218
integer y = 84
end type

event p_del::clicked;call super::clicked;Long    crow 
Boolean fg

if f_msg_delete() = -1 then return

crow = dw_insert.GetRow()
if crow < 1 or crow > dw_insert.RowCount() then
	sle_msg.text = "해당품번을 선택한 다음 진행하세요!"
	return
end if	
if IsNull(dw_insert.object.sabu[crow]) or dw_insert.object.sabu[crow] = "" then
	fg = False
else
	fg = True
end if

dw_insert.Setredraw(False)
dw_insert.DeleteRow(crow)
if fg = True then
   if dw_insert.Update() <> 1 then
      ROLLBACK;
      f_message_chk(31,'[삭제실패 : 점검 및 수리 소요자재]') 
      sle_msg.Text = "삭제 작업 실패!"
      dw_insert.Setredraw(True)
	   Return
   else
      COMMIT;
	end if
end if

dw_insert.Setredraw(True)
sle_msg.Text = "삭제 되었습니다!"

end event

type p_mod from w_inherite`p_mod within w_pdt_06060
integer x = 3045
integer y = 84
end type

event p_mod::clicked;call super::clicked;if f_msg_update() = -1 then return
if dw_insert.AcceptText() = -1 then return
if dw_ins1.AcceptText() = -1 then return

if wf_required_chk() = -1 then return //필수입력항목 체크 

IF dw_insert.Update() > 0 THEN
	COMMIT;
	sle_msg.Text = "저장 되었습니다!"
	p_del.Enabled = True
	p_del.picturename = "c:\erpman\image\삭제_up.gif"
ELSE
	ROLLBACK;
	f_message_chk(32, "[저장실패]")
	sle_msg.Text = "저장작업 실패!"
END IF

ib_any_typing = False //입력필드 변경여부 No
end event

type cb_exit from w_inherite`cb_exit within w_pdt_06060
integer x = 3154
integer y = 5000
integer taborder = 60
end type

type cb_mod from w_inherite`cb_mod within w_pdt_06060
integer x = 2450
integer y = 5000
integer taborder = 40
end type

type cb_ins from w_inherite`cb_ins within w_pdt_06060
integer x = 1019
integer y = 2356
end type

type cb_del from w_inherite`cb_del within w_pdt_06060
integer x = 2802
integer y = 5000
integer taborder = 50
end type

type cb_inq from w_inherite`cb_inq within w_pdt_06060
integer x = 2359
integer y = 5000
integer taborder = 10
end type

type cb_print from w_inherite`cb_print within w_pdt_06060
integer x = 1381
integer y = 2396
end type

type st_1 from w_inherite`st_1 within w_pdt_06060
long backcolor = 12632256
end type

type cb_can from w_inherite`cb_can within w_pdt_06060
integer x = 2437
integer y = 2404
end type

event cb_can::clicked;call super::clicked;//sle_msg.text =""
//IF wf_warndataloss("취소") = -1 THEN RETURN //변경된 자료 체크 
//
//dw_insert.SetRedraw(False)
//dw_insert.Reset()
//dw_insert.SetRedraw(True)
//
//dw_ins1.SetRedraw(False)
//dw_ins1.Reset()
//dw_ins1.InsertRow(0)
//dw_ins1.SetRedraw(True)
//dw_ins1.SetFocus()
//
//ib_any_typing = False //입력필드 변경여부 No
end event

type cb_search from w_inherite`cb_search within w_pdt_06060
integer x = 1920
integer y = 2364
integer width = 334
string text = "IMAGE"
end type



type sle_msg from w_inherite`sle_msg within w_pdt_06060
long backcolor = 12632256
end type

type gb_10 from w_inherite`gb_10 within w_pdt_06060
long backcolor = 12632256
end type

type gb_button1 from w_inherite`gb_button1 within w_pdt_06060
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_06060
end type

type dw_ins1 from u_key_enter within w_pdt_06060
event ue_key pbm_dwnkey
integer x = 64
integer y = 48
integer width = 2007
integer height = 236
integer taborder = 0
boolean bringtotop = true
string dataobject = "d_pdt_06060_01"
boolean border = false
boolean livescroll = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

IF	this.getcolumnname() = "mchno" THEN		
	open(w_mchno_popup)
	IF gs_code = '' or isnull(gs_code) then return 
	this.SetItem(1, "mchno", gs_code)
	this.SetItem(1, "mchnam", gs_codename)
END IF

end event

event itemerror;return 1
end event

event itemchanged;String s_cod, s_nam

s_cod = Trim(this.GetText())

if	this.getcolumnname() = "mchno" then
	select mchnam into :s_nam from mchmst
	 where sabu = :gs_sabu and mchno = :s_cod;
	 
	if sqlca.sqlcode <> 0 then
		f_message_chk(33,"[관리번호]")
		this.object.mchnam[1] = ""
		return 1
	else	
		this.object.mchnam[1] = s_nam
	end if	
elseif this.getcolumnname() = "sidat" then	
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[실시일자]")
		this.object.sidat[1] = ""
		return 1
	end if
end if


end event

event getfocus;call super::getfocus;dw_insert.SetReDraw(False)
dw_insert.ReSet()
dw_insert.SetReDraw(True)
end event

type cb_add from commandbutton within w_pdt_06060
integer x = 2711
integer y = 5000
integer width = 334
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "추가(&A)"
end type

type p_add from uo_picture within w_pdt_06060
integer x = 2871
integer y = 84
integer width = 178
integer taborder = 20
boolean bringtotop = true
string pointer = "C:\erpman\cur\add.cur"
string picturename = "C:\erpman\image\추가_up.gif"
end type

event clicked;call super::clicked;Long crow

crow = dw_insert.InsertRow(dw_insert.GetRow() + 1)
if IsNull(crow) then 
	crow = dw_insert.InsertRow(0)
end if	
dw_insert.ScrollToRow(crow)
dw_insert.SetColumn("itnbr")
dw_insert.SetFocus()

p_del.Enabled = True
p_del.picturename = "c:\erpman\image\삭제_up.gif"

end event

type rr_1 from roundrectangle within w_pdt_06060
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 288
integer width = 3611
integer height = 1680
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdt_06060
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 2629
integer y = 48
integer width = 1006
integer height = 212
integer cornerheight = 40
integer cornerwidth = 55
end type

