$PBExportHeader$w_qct_05025.srw
$PBExportComments$계측기 지급이력등록
forward
global type w_qct_05025 from w_inherite
end type
type dw_1 from datawindow within w_qct_05025
end type
type gb_2 from groupbox within w_qct_05025
end type
type gb_3 from groupbox within w_qct_05025
end type
type rr_1 from roundrectangle within w_qct_05025
end type
end forward

global type w_qct_05025 from w_inherite
string title = "계측기 지급이력 등록"
dw_1 dw_1
gb_2 gb_2
gb_3 gb_3
rr_1 rr_1
end type
global w_qct_05025 w_qct_05025

type variables
string  ismchno
end variables

on w_qct_05025.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.gb_2
this.Control[iCurrent+3]=this.gb_3
this.Control[iCurrent+4]=this.rr_1
end on

on w_qct_05025.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.rr_1)
end on

event open;call super::open;dw_1.settransobject(sqlca)
dw_insert.Settransobject(sqlca)
dw_1.insertrow(0)
dw_1.setcolumn("mchno")
dw_1.setfocus()
end event

type dw_insert from w_inherite`dw_insert within w_qct_05025
integer x = 87
integer y = 248
integer width = 4498
integer height = 2044
string dataobject = "d_qct_05025"
boolean border = false
end type

event dw_insert::itemchanged;call super::itemchanged;String s_cod, s_nam1, s_nam2, sNull
Integer i_rtn
long    lrow

SetNull(sNull)

lrow = this.getrow()
s_cod = Trim(this.GetText())

if this.getcolumnname() = "dptno" then //관리부서
	i_rtn = f_get_name2("V0", "Y", s_cod, s_nam1, s_nam2)
	this.object.dptno[lrow] = s_cod
	this.object.cvnas[lrow] = s_nam1
	return i_rtn
elseif this.getcolumnname() = "jidat" then //지급일자
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[지급일자]")
		this.object.jidat[lrow] = ""
		return 1
	end if
elseif this.getcolumnname() = "hidat" then //회수일자
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[반납일자]")
		this.object.hidat[lrow] = ""
		return 1
	end if
elseif this.getcolumnname() = "ipemp" then 
	i_rtn = f_get_name2("사번", "Y", s_cod, s_nam1, s_nam2)
	this.object.ipemp[lrow] = s_cod
	this.object.p1_master_empname[lrow] = s_nam1
	return i_rtn
End If


end event

event dw_insert::rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

if this.getcolumnname() = "dptno" then
	open(w_vndmst_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.SetItem(this.getrow(), "dptno", gs_code)
	this.SetItem(this.getrow(), "cvnas", gs_codename)
elseif this.getcolumnname() = "ipemp" then
	open(w_sawon_popup)
	If IsNull(gs_code) Or gs_code = '' Then Return
	this.SetItem(this.getrow(), "ipemp", gs_code)
	this.SetItem(this.getrow(), "p1_master_empname", gs_codename)
	return
end if
end event

event dw_insert::itemerror;call super::itemerror;return 1
end event

event dw_insert::rowfocuschanged;call super::rowfocuschanged;this.SetRowFocusIndicator(Hand!)
end event

type p_delrow from w_inherite`p_delrow within w_qct_05025
integer x = 3922
end type

event p_delrow::clicked;call super::clicked;long lrow

lrow = dw_insert.getrow()

if lrow < 1 then return

if f_msg_delete() = 1 then
	if dw_insert.getitemstring(lrow, 'ipdat') > '.' then 
		messagebox('확 인', '접수처리된 자료는 삭제할 수 없습니다.')
		return 
	end if
	
	dw_insert.deleterow(lrow)
	ib_any_typing = true
end if


//if wf_requiredchk() = -1 then return
//
//if dw_insert.update() = 1 then
//	sle_msg.text = "자료가 삭제되었습니다!!"
//	ib_any_typing= FALSE
//	commit ;
//else
//	rollback ;
//	messagebox("삭제 실패", "자료에 대한 삭제가 실패하였읍니다")
//	return 
//end if	
//		
//cb_inq.TriggerEvent(Clicked!)
end event

type p_addrow from w_inherite`p_addrow within w_qct_05025
integer x = 3749
end type

event p_addrow::clicked;call super::clicked;string  ls_mchno
long lrow

if dw_1.AcceptText() = -1 then
	dw_1.SetFocus()
	return -1
end if	

ls_mchno = trim(dw_1.object.mchno[1])

if IsNull(ls_mchno) or ls_mchno = '' then
	sle_msg.text = "관리번호를 먼저 입력한 후 진행하세요!"
	dw_1.SetColumn("mchno")
	dw_1.SetFocus()
	return 
end if

lrow = dw_insert.insertrow(0)
dw_insert.setrow(lrow)
dw_insert.setfocus()

ib_any_typing = true
end event

type p_search from w_inherite`p_search within w_qct_05025
boolean visible = false
end type

type p_ins from w_inherite`p_ins within w_qct_05025
boolean visible = false
end type

type p_exit from w_inherite`p_exit within w_qct_05025
end type

type p_can from w_inherite`p_can within w_qct_05025
end type

event p_can::clicked;call super::clicked;dw_1.reset()
dw_1.insertrow(0)
dw_insert.setredraw(false)
dw_insert.reset()
dw_insert.setredraw(true)
dw_1.setcolumn("mchno")
dw_1.setfocus()

ib_any_typing = FALSE

end event

type p_print from w_inherite`p_print within w_qct_05025
boolean visible = false
end type

type p_inq from w_inherite`p_inq within w_qct_05025
integer x = 3575
end type

event p_inq::clicked;call super::clicked;string  ls_mchno

if dw_1.AcceptText() = -1 then
	dw_1.SetFocus()
	return -1
end if	

ls_mchno = trim(dw_1.object.mchno[1])

if IsNull(ls_mchno) or ls_mchno = '' then
	sle_msg.text = "관리번호를 먼저 입력한 후 진행하세요!"
	dw_1.SetColumn("mchno")
	dw_1.SetFocus()
	return 
end if

if dw_insert.Retrieve(gs_sabu, ls_mchno ) <= 0 then
	f_message_chk(50,"[계측기 지급이력 등록]")
	dw_1.Setfocus()
	return -1
end if
   ib_any_typing = FALSE 
   dw_insert.Setfocus()

return 1
end event

type p_del from w_inherite`p_del within w_qct_05025
boolean visible = false
end type

type p_mod from w_inherite`p_mod within w_qct_05025
integer x = 4096
end type

event p_mod::clicked;call super::clicked;long  lCount, lrow, ll_found
string sfind, ls_mchno

if dw_1.accepttext() = -1 then return
if dw_insert.accepttext() = -1 then return

ls_mchno = dw_1.Getitemstring(1, "mchno" )
lCount = dw_insert.rowcount()

for lrow = 1 to lCount
   if Isnull(Trim(dw_insert.object.jidat[lRow])) or Trim(dw_insert.object.jidat[lRow]) = "" then
  	   f_message_chk(1400,'[지급일자]')
		dw_insert.SetRow(lRow)  
	   dw_insert.SetColumn('jidat')
	   dw_insert.SetFocus()
	   return 
   end if	
   if Isnull(Trim(dw_insert.object.dptno[lRow])) or Trim(dw_insert.object.dptno[lRow]) = "" then
  	   f_message_chk(1400,'[지급부서]')
		dw_insert.SetRow(lRow)  
	   dw_insert.SetColumn('dptno')
	   dw_insert.SetFocus()
	   return 
   end if	
	
	if lrow < lCount then
		sfind = dw_insert.object.jidat[lRow] + '||' + dw_insert.object.dptno[lRow]
      ll_found = dw_insert.Find("sfind = '" + sfind + "'", lrow + 1,  lcount) 
		if ll_found > 0 then
			MessageBox("확 인", String(ll_found) + " 번째 Row의 지급일자/부서 중복입니다!(등록 불가능!)")
			dw_insert.SetRow(ll_found)  
			dw_insert.SetColumn('jidat')
			dw_insert.SetFocus()
			return
		end if	
   end if

   if Isnull(Trim(dw_insert.object.sabu[lRow])) or Trim(dw_insert.object.sabu[lRow]) = "" then
		dw_insert.setitem(lrow, "sabu", gs_sabu)
		dw_insert.setitem(lrow, "mchno", ls_mchno)
	end if
next

if dw_insert.update() = 1 then
	commit;
	ib_any_typing= FALSE
	w_mdi_frame.sle_msg.text = "자료가 저장되었습니다."
else
	rollback;
	f_rollback()
end if

end event

type cb_exit from w_inherite`cb_exit within w_qct_05025
integer x = 3246
integer y = 1928
end type

type cb_mod from w_inherite`cb_mod within w_qct_05025
integer x = 2190
integer y = 1928
end type

type cb_ins from w_inherite`cb_ins within w_qct_05025
integer x = 448
integer y = 1928
string text = "추가(&I)"
end type

type cb_del from w_inherite`cb_del within w_qct_05025
integer x = 2542
integer y = 1928
end type

type cb_inq from w_inherite`cb_inq within w_qct_05025
integer x = 91
integer y = 1928
end type

type cb_print from w_inherite`cb_print within w_qct_05025
integer x = 1979
integer y = 2528
end type

type st_1 from w_inherite`st_1 within w_qct_05025
end type

type cb_can from w_inherite`cb_can within w_qct_05025
integer x = 2894
integer y = 1928
end type

type cb_search from w_inherite`cb_search within w_qct_05025
integer x = 2368
integer y = 2524
end type







type gb_button1 from w_inherite`gb_button1 within w_qct_05025
end type

type gb_button2 from w_inherite`gb_button2 within w_qct_05025
end type

type dw_1 from datawindow within w_qct_05025
event ue_key pbm_dwnkey
event ue_pressententer pbm_dwnprocessenter
integer x = 69
integer y = 16
integer width = 2830
integer height = 200
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_qct_05025_1"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_pressententer;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;String  s_cod, s_nam, ls_mchno, ls_mchnam, snull, ls_buncd
int     ireturn 

setnull(snull)

s_cod = Trim(this.GetText())
	
if this.GetColumnName() = "mchno" then // 관리번호  
	
 	if IsNull(s_cod) or s_cod = ""  then
		this.object.mchnam[1] = ""
		this.object.buncd[1] = ""
		dw_insert.reset()
		return 
	end if
	
	select mchnam
	  into :ls_mchnam
  	  from mesmst
	 where sabu = :gs_sabu and mchno = :s_cod ;
	
	if sqlca.sqlcode <> 0 then
		f_message_chk(33, '[ 관리 번호]')
		this.setitem(1,"mchno", snull )
		this.setitem(1,"mchnam", snull)
//		this.setitem(1,"buncd",  snull)
		dw_insert.reset()
		return 1
	end if
	
	this.setitem(1,"mchnam", ls_mchnam )
//	this.setitem(1,"buncd" , ls_buncd  )
	cb_inq.postevent(clicked!)
	
elseif this.GetColumnName() = "buncd" then    // 계측기 관리번호
	if IsNull(s_cod) or s_cod = "" then
		this.object.mchno[1] = ""
		this.object.mchnam[1] = ""
		dw_insert.reset()
		return 
	end if
		
	SELECT mchno, mchnam   
	INTO :ls_mchno, :ls_mchnam
   FROM mchmst
	WHERE KEGBN = 'Y'
	AND   BUNCD = :s_cod ; 
	
	if sqlca.sqlcode <> 0  then
		f_message_chk(33, '[계측기관리번호]')
      this.setitem(1,"mchno", snull )
		this.setitem(1,"mchnam", snull)
		this.setitem(1,"buncd",  snull)
		dw_insert.reset()
		return 1 
	end if
	
	this.setitem(1,"mchno", ls_mchno )
	this.setitem(1,"mchnam" , ls_mchnam  )
	cb_inq.postevent(clicked!)
	
end if

end event

event rbuttondown;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

IF	this.getcolumnname() = "mchno" THEN	
//	gs_gubun = 'ALL'
//	gs_code = '계측기'
	open(w_st22_00020_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.SetItem(1, "mchno", gs_code)
	this.SetItem(1, "mchnam", gs_codename)
	this.triggerevent(itemchanged!)
	
elseif this.GetColumnName() = "buncd" then
	
	gs_gubun = 'ALL'
	gs_code = '계측기'
	gs_codename = '계측기관리번호'
	open(w_st22_00020_popup)
	if isnull(gs_code) or gs_code = '' then return
	this.object.buncd[1] = gs_code
	this.triggerevent(itemchanged!)	
end if
end event

event itemerror;return 1
end event

type gb_2 from groupbox within w_qct_05025
integer x = 50
integer y = 1880
integer width = 777
integer height = 176
integer taborder = 11
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_3 from groupbox within w_qct_05025
integer x = 2139
integer y = 1880
integer width = 1477
integer height = 176
integer taborder = 21
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type rr_1 from roundrectangle within w_qct_05025
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 240
integer width = 4539
integer height = 2064
integer cornerheight = 40
integer cornerwidth = 55
end type

