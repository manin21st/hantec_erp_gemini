$PBExportHeader$w_kfic12.srw
$PBExportComments$리스상환계획 등록
forward
global type w_kfic12 from w_inherite
end type
type dw_2 from datawindow within w_kfic12
end type
type dw_print from datawindow within w_kfic12
end type
type dw_1 from datawindow within w_kfic12
end type
type rr_1 from roundrectangle within w_kfic12
end type
end forward

global type w_kfic12 from w_inherite
integer x = 174
integer y = 4
integer width = 3579
integer height = 1960
string title = "리스상환계획 등록"
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
dw_2 dw_2
dw_print dw_print
dw_1 dw_1
rr_1 rr_1
end type
global w_kfic12 w_kfic12

forward prototypes
public function integer wf_requiredchk (integer ll_row)
end prototypes

public function integer wf_requiredchk (integer ll_row);//integer i_shseq
string s_shdate

ll_row = dw_2.getrow()

//i_shseq = dw_2.getitemnumber(ll_row, "shseq")
s_shdate = dw_2.getitemstring(ll_row, "shdate")

//if i_shseq = 0 or isnull(i_shseq) then
//	messagebox("확인", "[회차]를 입력하세요")
//	dw_2.setcolumn("shseq")
//	dw_2.setfocus()
//	return -1
//end if

if s_shdate = "" or isnull(s_shdate) then
	messagebox("확인", "[상환일자]를 입력하세요")
	dw_2.setcolumn("shdate")
	dw_2.setfocus()
	return -1 
end if

return 1 
end function

on w_kfic12.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.dw_print=create dw_print
this.dw_1=create dw_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.dw_print
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.rr_1
end on

on w_kfic12.destroy
call super::destroy
destroy(this.dw_2)
destroy(this.dw_print)
destroy(this.dw_1)
destroy(this.rr_1)
end on

event open;call super::open;String s_lsno

F_Window_Center_Response(This)

dw_1.settransobject(sqlca)
dw_2.settransobject(sqlca)
dw_print.settransobject(sqlca)

dw_1.insertrow(0)
dw_1.setfocus()

s_lsno = message.stringparm

dw_1.setitem(1, "lsno", s_lsno)

dw_2.setredraw(false)

if dw_2.retrieve(s_lsno) <=0 then
	dw_2.setfocus()
	dw_2.setredraw(true)
	sle_msg.text = ""
	setpointer(arrow!)
else
//	cb_del.enabled = true
	cb_ins.enabled = true
//	cb_mod.enabled = true
	dw_2.setcolumn("shdate")
	dw_2.setfocus()
end if

dw_2.setredraw(true)

//cb_del.enabled = false
//cb_mod.enabled = false

end event

type dw_insert from w_inherite`dw_insert within w_kfic12
integer x = 78
integer y = 2140
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kfic12
boolean visible = false
integer x = 4457
integer y = 396
end type

type p_addrow from w_inherite`p_addrow within w_kfic12
boolean visible = false
integer x = 4283
integer y = 396
end type

type p_search from w_inherite`p_search within w_kfic12
boolean visible = false
integer x = 4119
integer y = 400
end type

type p_ins from w_inherite`p_ins within w_kfic12
integer x = 2382
end type

event p_ins::clicked;call super::clicked;integer i_currow, i_functionvalue, i_shseq, i_row, i_seq, i_cnt
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
	i_functionvalue = wf_requiredchk(dw_2.getrow())  	
	i_currow = dw_2.rowcount()
end if

if i_functionvalue = 1 then
   i_row = dw_2.rowcount()
   if i_row > 0 then
      select nvl(max(shseq),0)
      into :i_shseq
      from kfm20t2    
      where lsno = :s_lsno ;

      if sqlca.sqlcode <> 0 then
	      i_shseq = 0
      end if	
      i_cnt = 1
      do until i_cnt > i_row
         i_seq = dw_2.getitemnumber(i_cnt, "shseq")
		   if i_shseq < i_seq then
		 	   i_shseq = i_seq
		   end if
		   i_cnt = i_cnt + 1
      loop
     end if
	  i_shseq = i_shseq + 1
else
		i_shseq = 1
end if 

i_currow = i_currow + 1
	
dw_2.insertrow(i_currow)
dw_2.scrolltorow(i_currow)
dw_2.setitem(i_currow, "lsno", s_lsno)
dw_2.SetItem(i_currow,'sflag','I')
dw_2.setcolumn("shdate")
dw_2.setfocus()
//cb_del.enabled = true

dw_2.setitem(dw_2.GetRow(), 'shseq', i_shseq)
//cb_mod.enabled = true

end event

type p_exit from w_inherite`p_exit within w_kfic12
integer x = 3374
end type

type p_can from w_inherite`p_can within w_kfic12
integer x = 3200
end type

event p_can::clicked;call super::clicked;//dw_1.reset()
dw_2.reset()

dw_1.insertrow(0)
//cb_del.enabled = false
end event

type p_print from w_inherite`p_print within w_kfic12
integer x = 2551
integer width = 306
boolean originalsize = true
string picturename = "C:\Erpman\image\상환계획표출력_up.gif"
boolean focusrectangle = true
end type

event p_print::clicked;call super::clicked;
string  ls_lsno


if dw_1.accepttext() = -1 then return

ls_lsno = dw_1.getitemstring(1, "lsno")

dw_print.reset()
if dw_print.retrieve(ls_lsno) <= 0 then
	messagebox("확인", "출력할 자료가 존재하지 않습니다.")
	return
end if

openwithparm(w_print_options, dw_print)
end event

event p_print::ue_lbuttondown;PictureName = "C:\Erpman\image\상환계획표출력_dn.gif"
end event

event p_print::ue_lbuttonup;PictureName = "C:\Erpman\image\상환계획표출력_up.gif"
end event

type p_inq from w_inherite`p_inq within w_kfic12
integer x = 2208
end type

event p_inq::clicked;call super::clicked;string ls_lsno
Integer i_shseq

if dw_1.accepttext() = -1 then return

ls_lsno = dw_1.getitemstring(1, "lsno")

if isnull(ls_lsno) or ls_lsno = "" then
	f_messagechk(1, "[자사리스번호]")
	dw_1.setcolumn("lsno")
	dw_1.setfocus()
	return
end if

//select shseq
//into :i_shseq
//from kfm20t2
//where lsno = :ls_lsno
//  and rownum = 1;
//
//if isnull(i_shseq) or i_shseq = 0 then
//	messagebox("확인", "조회하신 자료가 없습니다.!!!")
//	return
//end if

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
	dw_2.setcolumn("shdate")
	dw_2.setfocus()
end if

dw_2.setredraw(true)

w_mdi_frame.sle_msg.text = "조회 완료" 

setpointer(arrow!)
end event

type p_del from w_inherite`p_del within w_kfic12
integer x = 3026
end type

event p_del::clicked;call super::clicked;String s_lsno
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

type p_mod from w_inherite`p_mod within w_kfic12
integer x = 2853
end type

event p_mod::clicked;call super::clicked;String ls_lsno, ls_shdate, ls_hjdate
integer k

w_mdi_frame.sle_msg.text =""

IF dw_1.AcceptText() = -1 then return 

ls_lsno = dw_1.GetItemString(dw_1.GetRow(),"lsno")

if dw_2.GetRow() <=0 then Return

if wf_requiredchk(dw_2.getrow()) = -1 then return

IF f_dbconfirm("저장") = 2 THEN RETURN

IF dw_2.Update() = 1 THEN
	COMMIT;
	
	FOR k = 1 TO dw_2.RowCount()
		dw_2.SetItem(k,'sflag','M')
	NEXT
	
	w_mdi_frame.sle_msg.text ="자료가 저장되었습니다.!!!"	
	ib_any_typing = false
	
ELSE
	f_messagechk(13,"") 
	ROLLBACK;
	
	RETURN
END IF

end event

type cb_exit from w_inherite`cb_exit within w_kfic12
boolean visible = false
integer x = 3113
integer y = 2376
integer taborder = 80
end type

type cb_mod from w_inherite`cb_mod within w_kfic12
boolean visible = false
integer x = 2043
integer y = 2376
end type

event cb_mod::clicked;call super::clicked;String ls_lsno, ls_shdate, ls_hjdate
integer k

sle_msg.text =""

IF dw_1.AcceptText() = -1 then return 

ls_lsno = dw_1.GetItemString(dw_1.GetRow(),"lsno")

if dw_2.GetRow() <=0 then Return

if wf_requiredchk(dw_2.getrow()) = -1 then return

IF f_dbconfirm("저장") = 2 THEN RETURN

IF dw_2.Update() = 1 THEN
	COMMIT;
	
	FOR k = 1 TO dw_2.RowCount()
		dw_2.SetItem(k,'sflag','M')
	NEXT
	
	sle_msg.text ="자료가 저장되었습니다.!!!"	
	ib_any_typing = false
	
ELSE
	f_messagechk(13,"") 
	ROLLBACK;
	
	RETURN
END IF

end event

type cb_ins from w_inherite`cb_ins within w_kfic12
boolean visible = false
integer x = 480
integer y = 2376
end type

event cb_ins::clicked;call super::clicked;integer i_currow, i_functionvalue, i_shseq, i_row, i_seq, i_cnt
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
	i_functionvalue = wf_requiredchk(dw_2.getrow())  	
	i_currow = dw_2.rowcount()
end if

if i_functionvalue = 1 then
   i_row = dw_2.rowcount()
   if i_row > 0 then
      select nvl(max(shseq),0)
      into :i_shseq
      from kfm20t2    
      where lsno = :s_lsno ;

      if sqlca.sqlcode <> 0 then
	      i_shseq = 0
      end if	
      i_cnt = 1
      do until i_cnt > i_row
         i_seq = dw_2.getitemnumber(i_cnt, "shseq")
		   if i_shseq < i_seq then
		 	   i_shseq = i_seq
		   end if
		   i_cnt = i_cnt + 1
      loop
     end if
	  i_shseq = i_shseq + 1
else
		i_shseq = 1
end if 

i_currow = i_currow + 1
	
dw_2.insertrow(i_currow)
dw_2.scrolltorow(i_currow)
dw_2.setitem(i_currow, "lsno", s_lsno)
dw_2.SetItem(i_currow,'sflag','I')
dw_2.setcolumn("shdate")
dw_2.setfocus()
//cb_del.enabled = true

dw_2.setitem(dw_2.GetRow(), 'shseq', i_shseq)
//cb_mod.enabled = true

end event

type cb_del from w_inherite`cb_del within w_kfic12
boolean visible = false
integer x = 2400
integer y = 2376
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

type cb_inq from w_inherite`cb_inq within w_kfic12
boolean visible = false
integer x = 123
integer y = 2376
end type

event cb_inq::clicked;call super::clicked;string ls_lsno
Integer i_shseq

if dw_1.accepttext() = -1 then return

ls_lsno = dw_1.getitemstring(1, "lsno")

if isnull(ls_lsno) or ls_lsno = "" then
	f_messagechk(1, "[자사리스번호]")
	dw_1.setcolumn("lsno")
	dw_1.setfocus()
	return
end if

//select shseq
//into :i_shseq
//from kfm20t2
//where lsno = :ls_lsno
//  and rownum = 1;
//
//if isnull(i_shseq) or i_shseq = 0 then
//	messagebox("확인", "조회하신 자료가 없습니다.!!!")
//	return
//end if

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
	dw_2.setcolumn("shdate")
	dw_2.setfocus()
end if

dw_2.setredraw(true)

sle_msg.text = "조회 완료" 

setpointer(arrow!)
end event

type cb_print from w_inherite`cb_print within w_kfic12
boolean visible = false
integer x = 837
integer y = 2376
integer width = 663
string text = "상환계획표 출력(&P)"
end type

event cb_print::clicked;call super::clicked;
string  ls_lsno


if dw_1.accepttext() = -1 then return

ls_lsno = dw_1.getitemstring(1, "lsno")

dw_print.reset()
if dw_print.retrieve(ls_lsno) <= 0 then
	messagebox("확인", "출력할 자료가 존재하지 않습니다.")
	return
end if

openwithparm(w_print_options, dw_print)
end event

type st_1 from w_inherite`st_1 within w_kfic12
integer x = 37
integer y = 2236
end type

type cb_can from w_inherite`cb_can within w_kfic12
boolean visible = false
integer x = 2757
integer y = 2376
end type

event cb_can::clicked;call super::clicked;//dw_1.reset()
dw_2.reset()

dw_1.insertrow(0)
//cb_del.enabled = false
end event

type cb_search from w_inherite`cb_search within w_kfic12
integer x = 2126
integer y = 2364
end type

type dw_datetime from w_inherite`dw_datetime within w_kfic12
integer x = 2661
integer y = 2236
end type

type sle_msg from w_inherite`sle_msg within w_kfic12
integer y = 2236
integer width = 2277
end type

type gb_10 from w_inherite`gb_10 within w_kfic12
integer x = 23
integer y = 2184
integer width = 3397
end type

type gb_button1 from w_inherite`gb_button1 within w_kfic12
boolean visible = false
integer x = 87
integer y = 2320
integer width = 1454
end type

type gb_button2 from w_inherite`gb_button2 within w_kfic12
boolean visible = false
integer x = 2002
integer y = 2320
end type

type dw_2 from datawindow within w_kfic12
event ue_enterkey pbm_dwnprocessenter
integer x = 18
integer y = 196
integer width = 3493
integer height = 1636
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_kfic12_1"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_enterkey;Send(Handle(this),256,9,0)
Return 1

end event

event editchanged;ib_any_typing = true
end event

event getfocus;this.accepttext()
end event

event itemchanged;integer li_shseq, icurrow
string  ls_shdate, ls_lsno, ls_hjdate
decimal ld_wmihsamt, ld_umihsamt, ld_wjylsamt, ld_ujylsamt, ld_wtot, ld_utot, &
        ld_wlswamt, ld_ulswamt, ld_wlsamt, ld_ulsamt, ld_wmihsamt1, ld_umihsamt1, &
		  ld_wjylsamt1, ld_ujylsamt1, ld_wamt, ld_uamt, ld_wlseja, ld_ulseja
long    ll_row

if this.accepttext() = -1 then return

ls_lsno = dw_1.getitemstring(1, 'lsno')
icurrow = this.getrow()
ld_wlswamt = dw_2.getitemdecimal(icurrow, "wlswamt")
ld_ulswamt = dw_2.getitemdecimal(icurrow, "ulswamt")
ld_wlseja = dw_2.getitemdecimal(icurrow, "wlseja")
ld_ulseja = dw_2.getitemdecimal(icurrow, "ulseja")

if this.getcolumnname() = "shdate" then
	ls_shdate = this.gettext() 
	if isnull(ls_shdate) or ls_shdate = "" then
		f_messagechk(1, "[상환일자]")
		this.setcolumn("shdate")
		this.setfocus()
		return
	end if
end if

SELECT LSHJDATE
  INTO :ls_hjdate
  FROM KFM20M
 WHERE LSNO = :ls_lsno ;
 
ls_shdate = dw_2.getitemstring(dw_2.getrow(), "shdate")
 
if ls_shdate >= ls_hjdate then
	dw_2.setitem(dw_2.getrow(), "kfm20t2_etc1", '1')
end if

//dw_2.setitem(icurrow, "shseq", icurrow)

if this.getcolumnname() = "wlswamt" then
	 	
  SELECT "KFM20M"."LSWAMT",   
         "KFM20M"."TOTWLSAMT"   
    INTO :ld_wamt,   
         :ld_wtot   
    FROM "KFM20M"  
	WHERE "KFM20M"."LSNO" = :ls_lsno ;
	
	if sqlca.sqlcode = 0 then
	
		ld_wlswamt = this.getitemdecimal(icurrow, "wlswamt")
		ld_wlseja = dw_2.getitemdecimal(icurrow, "wlseja")
		ld_wlsamt = ld_wlswamt + ld_wlseja
		dw_2.setitem(icurrow, "wlsamt", ld_wlsamt)
		ld_wmihsamt = this.getitemdecimal(icurrow, "wmihsamt")
		ld_wjylsamt = this.getitemdecimal(icurrow, "wjylsamt")
		
		if icurrow = 1 then
	
			ld_wmihsamt = ld_wamt - ld_wlswamt
			ld_wjylsamt = ld_wtot - ld_wlsamt 

			dw_2.setitem(icurrow, "wmihsamt", ld_wmihsamt)
			dw_2.setitem(icurrow, "wjylsamt", ld_wjylsamt)
 
		else
			ll_row = icurrow - 1
			
			ld_wmihsamt1 = this.getitemdecimal(ll_row, "wmihsamt")
			ld_wjylsamt1 = this.getitemdecimal(ll_row, "wjylsamt")

			ld_wmihsamt = ld_wmihsamt1 - ld_wlswamt
			ld_wjylsamt = ld_wjylsamt1 - ld_wlsamt

			dw_2.setitem(icurrow, "wmihsamt", ld_wmihsamt)
			dw_2.setitem(icurrow, "wjylsamt", ld_wjylsamt)

     end if
	  
   end if

end if

if this.getcolumnname() = "ulswamt" then
   
	SELECT "KFM20M"."LSUAMT",      
          "KFM20M"."TOTULSAMT"  
     INTO :ld_uamt,      
          :ld_utot  
     FROM "KFM20M"  
	 WHERE "KFM20M"."LSNO" = :ls_lsno ;
	 
	if sqlca.sqlcode = 0 then
		
	   ld_ulswamt = this.getitemdecimal(icurrow, "ulswamt")
	   ld_ulseja = this.getitemdecimal(icurrow, "ulseja")
	   ld_ulsamt = ld_ulswamt + ld_ulseja
	   dw_2.setitem(icurrow, "ulsamt", ld_ulsamt)
	   ld_umihsamt = this.getitemdecimal(icurrow, "umihsamt")
	   ld_ujylsamt = this.getitemdecimal(icurrow, "ujylsamt")

		if icurrow = 1 then
			
			ld_umihsamt = ld_uamt - ld_ulswamt
			ld_ujylsamt = ld_utot - ld_ulsamt
			
			dw_2.setitem(icurrow, "umihsamt", ld_umihsamt)
			dw_2.setitem(icurrow, "ujylsamt", ld_ujylsamt) 
		else
			ll_row = icurrow - 1
		
			ld_umihsamt1 = this.getitemdecimal(ll_row, "umihsamt")
			ld_ujylsamt1 = this.getitemdecimal(ll_row, "ujylsamt")
		
			ld_umihsamt = ld_umihsamt1 - ld_ulswamt
			ld_ujylsamt = ld_ujylsamt1 - ld_ulsamt
			
			dw_2.setitem(icurrow, "umihsamt", ld_umihsamt)
			dw_2.setitem(icurrow, "ujylsamt", ld_ujylsamt)
			
     end if
	  
   end if

end if


if this.getcolumnname() = "wlseja" then
	 	
  SELECT "KFM20M"."LSWAMT",   
         "KFM20M"."TOTWLSAMT"   
    INTO :ld_wamt,   
         :ld_wtot   
    FROM "KFM20M"  
	WHERE "KFM20M"."LSNO" = :ls_lsno ;
	
	if sqlca.sqlcode = 0 then
	
		ld_wlswamt = this.getitemdecimal(icurrow, "wlswamt")
		ld_wlseja = dw_2.getitemdecimal(icurrow, "wlseja")
		ld_wlsamt = ld_wlswamt + ld_wlseja
		dw_2.setitem(icurrow, "wlsamt", ld_wlsamt)
		ld_wmihsamt = this.getitemdecimal(icurrow, "wmihsamt")
		ld_wjylsamt = this.getitemdecimal(icurrow, "wjylsamt")
		
		if icurrow = 1 then
	
			ld_wmihsamt = ld_wamt - ld_wlswamt
			ld_wjylsamt = ld_wtot - ld_wlsamt 

			dw_2.setitem(icurrow, "wmihsamt", ld_wmihsamt)
			dw_2.setitem(icurrow, "wjylsamt", ld_wjylsamt)
 
		else
			ll_row = icurrow - 1
			
			ld_wmihsamt1 = this.getitemdecimal(ll_row, "wmihsamt")
			ld_wjylsamt1 = this.getitemdecimal(ll_row, "wjylsamt")

			ld_wmihsamt = ld_wmihsamt1 - ld_wlswamt
			ld_wjylsamt = ld_wjylsamt1 - ld_wlsamt

			dw_2.setitem(icurrow, "wmihsamt", ld_wmihsamt)
			dw_2.setitem(icurrow, "wjylsamt", ld_wjylsamt)

     end if
	  
   end if

end if

if this.getcolumnname() = "ulseja" then
   
	SELECT "KFM20M"."LSUAMT",      
          "KFM20M"."TOTULSAMT"  
     INTO :ld_uamt,      
          :ld_utot  
     FROM "KFM20M"  
	 WHERE "KFM20M"."LSNO" = :ls_lsno ;
	 
	if sqlca.sqlcode = 0 then
		
	   ld_ulswamt = this.getitemdecimal(icurrow, "ulswamt")
	   ld_ulseja = this.getitemdecimal(icurrow, "ulseja")
	   ld_ulsamt = ld_ulswamt + ld_ulseja
	   dw_2.setitem(icurrow, "ulsamt", ld_ulsamt)
	   ld_umihsamt = this.getitemdecimal(icurrow, "umihsamt")
	   ld_ujylsamt = this.getitemdecimal(icurrow, "ujylsamt")

		if icurrow = 1 then
			
			ld_umihsamt = ld_uamt - ld_ulswamt
			ld_ujylsamt = ld_utot - ld_ulsamt
			
			dw_2.setitem(icurrow, "umihsamt", ld_umihsamt)
			dw_2.setitem(icurrow, "ujylsamt", ld_ujylsamt) 
		else
			ll_row = icurrow - 1
		
			ld_umihsamt1 = this.getitemdecimal(ll_row, "umihsamt")
			ld_ujylsamt1 = this.getitemdecimal(ll_row, "ujylsamt")
		
			ld_umihsamt = ld_umihsamt1 - ld_ulswamt
			ld_ujylsamt = ld_ujylsamt1 - ld_ulsamt
			
			dw_2.setitem(icurrow, "umihsamt", ld_umihsamt)
			dw_2.setitem(icurrow, "ujylsamt", ld_ujylsamt)
			
     end if
	  
   end if

end if



end event

event itemerror;return 1
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

type dw_print from datawindow within w_kfic12
boolean visible = false
integer x = 2062
integer y = 2488
integer width = 759
integer height = 104
boolean bringtotop = true
boolean titlebar = true
string title = "리스상환계획표"
string dataobject = "d_kfic12_2"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_1 from datawindow within w_kfic12
event ue_key pbm_dwnkey
integer x = 37
integer y = 36
integer width = 1175
integer height = 152
boolean bringtotop = true
string dataobject = "d_kfic12"
boolean border = false
boolean livescroll = true
end type

event ue_key;if keydown(keyf1!) then
	triggerevent(rbuttondown!)
end if
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
//	
//	cb_inq.TriggerEvent(clicked!)
//end if
//
end event

type rr_1 from roundrectangle within w_kfic12
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 5
integer y = 192
integer width = 3534
integer height = 1660
integer cornerheight = 40
integer cornerwidth = 46
end type

