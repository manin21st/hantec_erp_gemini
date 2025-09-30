$PBExportHeader$w_kfic11.srw
$PBExportComments$리스설비 등록
forward
global type w_kfic11 from w_inherite
end type
type dw_2 from datawindow within w_kfic11
end type
type dw_1 from datawindow within w_kfic11
end type
type rr_1 from roundrectangle within w_kfic11
end type
end forward

global type w_kfic11 from w_inherite
integer x = 155
integer y = 4
integer width = 4640
integer height = 1952
string title = "리스설비등록"
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
dw_2 dw_2
dw_1 dw_1
rr_1 rr_1
end type
global w_kfic11 w_kfic11

forward prototypes
public function integer wf_requiredchk (integer ll_row)
end prototypes

public function integer wf_requiredchk (integer ll_row);string s_sbno

ll_row = dw_2.getrow()

s_sbno = dw_2.getitemstring(ll_row, "sbno")

if isnull(s_sbno) then
	messagebox("확인", "[설비번호]를 입력하세요")
	dw_2.setcolumn("sbno")
	dw_2.setfocus()
	return -1 
end if

return 1 
end function

on w_kfic11.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.dw_1=create dw_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.rr_1
end on

on w_kfic11.destroy
call super::destroy
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.rr_1)
end on

event open;call super::open;string s_lsno

F_Window_Center_ResPonse(This)

dw_1.settransobject(sqlca)
dw_1.insertrow(0)
dw_1.setfocus()

dw_2.settransobject(sqlca)

s_lsno = message.stringparm

  select kfm20m.lsno into :s_lsno
    from kfm20m 
	where kfm20m.lsno = :s_lsno ;
	
dw_1.setitem(1, "lsno", s_lsno)
   
dw_2.setredraw(false)
if dw_2.retrieve(s_lsno) <=0 then
	dw_2.setfocus()
	dw_2.setredraw(true)
	w_mdi_frame.sle_msg.text = ""
	setpointer(arrow!)
else
//	cb_del.enabled = true
	p_ins.Enabled = True
  	p_ins.PictureName = "C:\erpman\image\추가_up.gif"
//	cb_mod.enabled = true
	dw_2.setcolumn("mseq")
	dw_2.setfocus()
end if

dw_2.setredraw(true)


//cb_del.enabled = false
//cb_mod.enabled = false
end event

type dw_insert from w_inherite`dw_insert within w_kfic11
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kfic11
boolean visible = false
integer x = 4347
integer y = 2444
end type

type p_addrow from w_inherite`p_addrow within w_kfic11
boolean visible = false
integer x = 4174
integer y = 2444
end type

type p_search from w_inherite`p_search within w_kfic11
boolean visible = false
integer x = 3479
integer y = 2444
end type

type p_ins from w_inherite`p_ins within w_kfic11
integer x = 3749
end type

event p_ins::clicked;call super::clicked;integer i_currow, i_functionvalue, i_row, i_mseq, i_seq, i_cnt
string s_lsno

w_mdi_frame.sle_msg.text = ""

if dw_1.accepttext() = -1 then return

s_lsno = dw_1.getitemstring(1, "lsno")

if s_lsno = "" or isnull(s_lsno) then
	f_messagechk(1,"[자사리스번호]")
	dw_1.setcolumn("lsno")
	dw_1.setfocus()
	return
end if

if dw_2.rowcount() <= 0 then
	i_currow = 0
	i_functionvalue = 1
else
	if wf_requiredchk(dw_2.getrow()) = -1 then return
	i_functionvalue = wf_requiredchk(dw_2.getrow())  	
	i_currow = dw_2.getrow()
end if

if i_functionvalue = 1 then
   i_row = dw_2.rowcount()
   if i_row > 0 then
      select nvl(max(mseq),0)
      into :i_mseq
      from kfm20t1    
      where lsno = :s_lsno ;

      if sqlca.sqlcode <> 0 then
	      i_mseq = 0
      end if	
      i_cnt = 1
      do until i_cnt > i_row
         i_seq = dw_2.getitemnumber(i_cnt, "mseq")
		   if i_mseq < i_seq then
		 	   i_mseq = i_seq
		   end if
		   i_cnt = i_cnt + 1
      loop
    end if
	  i_mseq = i_mseq + 1
else
	  i_mseq = 1
end if 

//i_currow = i_currow + 1
	
dw_2.insertrow(i_mseq)
dw_2.scrolltorow(i_mseq)
dw_2.setitem(i_mseq, "lsno", s_lsno)
dw_2.SetItem(i_mseq,'sflag','I')
dw_2.setcolumn("sbno")
dw_2.setfocus()
//cb_del.enabled = true

dw_2.setitem(dw_2.GetRow(), 'mseq', i_mseq)
//cb_mod.enabled = true

 
end event

type p_exit from w_inherite`p_exit within w_kfic11
end type

type p_can from w_inherite`p_can within w_kfic11
end type

event p_can::clicked;call super::clicked;//dw_1.reset()
dw_2.reset()

dw_1.insertrow(0)
//cb_del.enabled = false

end event

type p_print from w_inherite`p_print within w_kfic11
boolean visible = false
integer x = 3653
integer y = 2444
end type

type p_inq from w_inherite`p_inq within w_kfic11
integer x = 3575
end type

event p_inq::clicked;call super::clicked;string ls_lsno

if dw_1.accepttext() = -1 then return

ls_lsno = dw_1.getitemstring(1, "lsno")
if isnull(ls_lsno) or ls_lsno = "" then
	f_messagechk(1, "[자사리스번호]")
	dw_1.setcolumn("lsno")
	dw_1.setfocus()
	return
end if

w_mdi_frame.sle_msg.text = "조회 중 ..."

setpointer(hourglass!)
dw_2.setredraw(false)
if dw_2.retrieve(ls_lsno) <=0 then
	f_messagechk(14, "")
	dw_2.setfocus()
	dw_2.setredraw(true)
	w_mdi_frame.sle_msg.text = ""
	setpointer(arrow!)
	return
else
//	cb_del.enabled = true
	p_ins.Enabled = True
   p_ins.PictureName = "C:\erpman\image\추가_up.gif"
//	cb_mod.enabled = true
	dw_2.setcolumn("mseq")
	dw_2.setfocus()
end if
dw_2.setredraw(true)

w_mdi_frame.sle_msg.text = "조회 완료" 

setpointer(arrow!)


end event

type p_del from w_inherite`p_del within w_kfic11
end type

event p_del::clicked;String s_lsno
integer k

w_mdi_frame.sle_msg.text =""

dw_1.AcceptText()

s_lsno =dw_1.GetItemString(1, "lsno")

IF f_dbconfirm("삭제") = 2 THEN RETURN

dw_2.DeleteRow(0)

IF dw_2.Update() = 1 THEN
	COMMIT;
	
	FOR k = 1 TO dw_2.RowCount()
		dw_2.SetItem(k,'sflag','M')
	NEXT
	
	ib_any_typing = false
	w_mdi_frame.sle_msg.text ="자료가 삭제되었습니다.!!!"	
//	cb_del.enabled = false
//	dw_2.insertrow(0)
ELSE
	f_messagechk(12,'')
	ROLLBACK;
END IF

end event

type p_mod from w_inherite`p_mod within w_kfic11
end type

event p_mod::clicked;call super::clicked;String s_lsno
integer k

w_mdi_frame.sle_msg.text =""

IF dw_1.AcceptText() = -1 then return 

s_lsno = dw_1.GetItemString(dw_1.GetRow(),"lsno")

if dw_2.GetRow() <=0 then Return

if wf_requiredchk(dw_2.getrow()) = -1 then return

IF f_dbconfirm("저장") = 2 THEN RETURN

IF dw_2.Update() = 1 THEN
	COMMIT;
	
	FOR k = 1 TO dw_2.RowCount()
		dw_2.SetItem(k,'sflag','M')
	NEXT
			
	p_inq.Triggerevent(Clicked!)
	
	w_mdi_frame.sle_msg.text ="자료가 저장되었습니다.!!!"	
	
	ib_any_typing = false
	
ELSE
	f_messagechk(13,"") 
	ROLLBACK;
	
	RETURN
END IF







end event

type cb_exit from w_inherite`cb_exit within w_kfic11
boolean visible = false
integer x = 3067
integer y = 2352
integer taborder = 70
end type

type cb_mod from w_inherite`cb_mod within w_kfic11
boolean visible = false
integer x = 1998
integer y = 2352
end type

event cb_mod::clicked;call super::clicked;String s_lsno
integer k

sle_msg.text =""

IF dw_1.AcceptText() = -1 then return 

s_lsno = dw_1.GetItemString(dw_1.GetRow(),"lsno")

if dw_2.GetRow() <=0 then Return

if wf_requiredchk(dw_2.getrow()) = -1 then return

IF f_dbconfirm("저장") = 2 THEN RETURN

IF dw_2.Update() = 1 THEN
	COMMIT;
	
	FOR k = 1 TO dw_2.RowCount()
		dw_2.SetItem(k,'sflag','M')
	NEXT
			
	cb_inq.Triggerevent(Clicked!)
	
	sle_msg.text ="자료가 저장되었습니다.!!!"	
	
	ib_any_typing = false
	
ELSE
	f_messagechk(13,"") 
	ROLLBACK;
	
	RETURN
END IF







end event

type cb_ins from w_inherite`cb_ins within w_kfic11
boolean visible = false
integer x = 425
integer y = 2352
string text = "추가(&A)"
end type

event cb_ins::clicked;call super::clicked;integer i_currow, i_functionvalue, i_row, i_mseq, i_seq, i_cnt
string s_lsno

sle_msg.text = ""

if dw_1.accepttext() = -1 then return

s_lsno = dw_1.getitemstring(1, "lsno")

if s_lsno = "" or isnull(s_lsno) then
	f_messagechk(1,"[자사리스번호]")
	dw_1.setcolumn("lsno")
	dw_1.setfocus()
	return
end if

if dw_2.rowcount() <= 0 then
	i_currow = 0
	i_functionvalue = 1
else
	if wf_requiredchk(dw_2.getrow()) = -1 then return
	i_functionvalue = wf_requiredchk(dw_2.getrow())  	
	i_currow = dw_2.getrow()
end if

if i_functionvalue = 1 then
   i_row = dw_2.rowcount()
   if i_row > 0 then
      select nvl(max(mseq),0)
      into :i_mseq
      from kfm20t1    
      where lsno = :s_lsno ;

      if sqlca.sqlcode <> 0 then
	      i_mseq = 0
      end if	
      i_cnt = 1
      do until i_cnt > i_row
         i_seq = dw_2.getitemnumber(i_cnt, "mseq")
		   if i_mseq < i_seq then
		 	   i_mseq = i_seq
		   end if
		   i_cnt = i_cnt + 1
      loop
    end if
	  i_mseq = i_mseq + 1
else
	  i_mseq = 1
end if 

//i_currow = i_currow + 1
	
dw_2.insertrow(i_mseq)
dw_2.scrolltorow(i_mseq)
dw_2.setitem(i_mseq, "lsno", s_lsno)
dw_2.SetItem(i_mseq,'sflag','I')
dw_2.setcolumn("sbno")
dw_2.setfocus()
//cb_del.enabled = true

dw_2.setitem(dw_2.GetRow(), 'mseq', i_mseq)
//cb_mod.enabled = true

 
end event

type cb_del from w_inherite`cb_del within w_kfic11
boolean visible = false
integer x = 2354
integer y = 2352
end type

event cb_del::clicked;call super::clicked;String s_lsno
integer k

sle_msg.text =""

dw_1.AcceptText()

s_lsno =dw_1.GetItemString(1, "lsno")

IF f_dbconfirm("삭제") = 2 THEN RETURN

dw_2.DeleteRow(0)

IF dw_2.Update() = 1 THEN
	COMMIT;
	
	FOR k = 1 TO dw_2.RowCount()
		dw_2.SetItem(k,'sflag','M')
	NEXT
	
	ib_any_typing = false
	sle_msg.text ="자료가 삭제되었습니다.!!!"	
//	cb_del.enabled = false
//	dw_2.insertrow(0)
ELSE
	f_messagechk(12,'')
	ROLLBACK;
END IF

end event

type cb_inq from w_inherite`cb_inq within w_kfic11
boolean visible = false
integer x = 69
integer y = 2352
end type

event cb_inq::clicked;call super::clicked;string ls_lsno

if dw_1.accepttext() = -1 then return

ls_lsno = dw_1.getitemstring(1, "lsno")
if isnull(ls_lsno) or ls_lsno = "" then
	f_messagechk(1, "[자사리스번호]")
	dw_1.setcolumn("lsno")
	dw_1.setfocus()
	return
end if

sle_msg.text = "조회 중 ..."

setpointer(hourglass!)
dw_2.setredraw(false)
if dw_2.retrieve(ls_lsno) <=0 then
	f_messagechk(14, "")
	dw_2.setfocus()
	dw_2.setredraw(true)
	sle_msg.text = ""
	setpointer(arrow!)
	return
else
//	cb_del.enabled = true
	cb_ins.enabled = true
//	cb_mod.enabled = true
	dw_2.setcolumn("mseq")
	dw_2.setfocus()
end if
dw_2.setredraw(true)

sle_msg.text = "조회 완료" 

setpointer(arrow!)


end event

type cb_print from w_inherite`cb_print within w_kfic11
integer x = 1285
integer y = 2756
end type

type st_1 from w_inherite`st_1 within w_kfic11
integer x = 46
integer y = 2516
end type

type cb_can from w_inherite`cb_can within w_kfic11
boolean visible = false
integer x = 2711
integer y = 2352
integer taborder = 60
end type

event cb_can::clicked;call super::clicked;//dw_1.reset()
dw_2.reset()

dw_1.insertrow(0)
//cb_del.enabled = false

end event

type cb_search from w_inherite`cb_search within w_kfic11
integer x = 1682
integer y = 2844
end type

type dw_datetime from w_inherite`dw_datetime within w_kfic11
integer x = 2670
integer y = 2516
end type

type sle_msg from w_inherite`sle_msg within w_kfic11
integer x = 398
integer y = 2516
integer width = 2272
end type

type gb_10 from w_inherite`gb_10 within w_kfic11
integer y = 2464
integer width = 3438
end type

type gb_button1 from w_inherite`gb_button1 within w_kfic11
boolean visible = false
integer x = 37
integer y = 2296
end type

type gb_button2 from w_inherite`gb_button2 within w_kfic11
boolean visible = false
integer x = 1957
integer y = 2296
end type

type dw_2 from datawindow within w_kfic11
event ue_key pbm_dwnkey
event ue_enterkey pbm_dwnprocessenter
integer x = 23
integer y = 192
integer width = 4576
integer height = 1628
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_kfic11_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_key;if keydown(keyf1!) then
	triggerevent(rbuttondown!)
end if
end event

event ue_enterkey;Send(Handle(this),256,9,0)
Return 1
end event

event editchanged;ib_any_typing = true
end event

event getfocus;this.accepttext()
end event

event itemerror;return 1
end event

event rbuttondown;s_us_in	lstr_mchmst

if this.getcolumnname() = "sbno" then

	OpenWithParm(w_mchmst_popup,lstr_mchmst)
	
	if Not IsValid(Message.PowerObjectParm) then return
	
	lstr_mchmst = Message.PowerObjectParm
	
	this.setitem(dw_2.getrow(), "sbno", lstr_mchmst.schk_bnk)
	this.setitem(dw_2.getrow(), "esbnam", lstr_mchmst.schk_bnk2)
	this.setitem(dw_2.getrow(), "workstation", lstr_mchmst.spur_date)
	this.setitem(dw_2.getrow(), "modelnam", lstr_mchmst.spur_date2)
	this.setitem(dw_2.getrow(), "nitdsc", lstr_mchmst.schk_gu)
	this.setitem(dw_2.getrow(), "jejoco", lstr_mchmst.schk_no1)
	this.setitem(dw_2.getrow(), "kwdept", lstr_mchmst.schk_no2)
//	this.setitem(dw_2.getrow(), "wgiamt", lstr_mchmst.suse_gu)
//	this.setitem(dw_2.getrow(), "ugiamt", lstr_mchmst.flag)
	
end if


end event

event retrieveend;Integer k

FOR k = 1 TO rowcount
	this.SetItem(k,'sflag','M')
NEXT
end event

event retrieverow;IF row > 0 THEN
	this.SetItem(row,'sflag','M')
END IF
end event

type dw_1 from datawindow within w_kfic11
event ue_key pbm_dwnkey
integer x = 55
integer y = 24
integer width = 1070
integer height = 140
boolean bringtotop = true
string dataobject = "d_kfic11"
boolean border = false
boolean livescroll = true
end type

event ue_key;if keydown(keyf1!) then
	triggerevent(rbuttondown!)
end if
end event

event itemchanged;//string slsno
//
//sle_msg.text = ""
//
//if this.getcolumnname() = "lsno" then
//	slsno = this.gettext()
//	
//	if slsno = "" or isnull(slsno) then
//		f_messagechk(1, "[자사리스번호]")
//		this.setcolumn("lsno")
//		this.setfocus()
//		return
//	end if
//end if
//
end event

event editchanged;ib_any_typing = true
end event

event getfocus;this.accepttext()
end event

event itemerror;return 1
end event

event rbuttondown;//setnull(gs_code)
//
//if this.getcolumnname() = "lsno" then
//   gs_code = this.getitemstring(1, "lsno")
//	if isnull(gs_code) then gs_code = ""
//	
//   open(w_kfic10_popup)
//	
//   if isnull(gs_code) then return
//	
//   this.setitem(1, "lsno", gs_code)
//	cb_inq.TriggerEvent(clicked!)
//end if
	

end event

type rr_1 from roundrectangle within w_kfic11
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 188
integer width = 4594
integer height = 1652
integer cornerheight = 40
integer cornerwidth = 46
end type

