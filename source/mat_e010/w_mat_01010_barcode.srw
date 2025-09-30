$PBExportHeader$w_mat_01010_barcode.srw
$PBExportComments$기타 입고의뢰 바코드 발행
forward
global type w_mat_01010_barcode from w_inherite_popup
end type
type dw_head from datawindow within w_mat_01010_barcode
end type
type p_print from uo_picture within w_mat_01010_barcode
end type
type p_close from uo_picture within w_mat_01010_barcode
end type
type cbx_1 from checkbox within w_mat_01010_barcode
end type
type dw_print from datawindow within w_mat_01010_barcode
end type
type rr_1 from roundrectangle within w_mat_01010_barcode
end type
type rr_2 from roundrectangle within w_mat_01010_barcode
end type
end forward

global type w_mat_01010_barcode from w_inherite_popup
integer x = 663
integer y = 136
integer width = 4430
integer height = 2188
string title = "기타입고의뢰 바코드출력"
dw_head dw_head
p_print p_print
p_close p_close
cbx_1 cbx_1
dw_print dw_print
rr_1 rr_1
rr_2 rr_2
end type
global w_mat_01010_barcode w_mat_01010_barcode

type variables
string  is_code , is_codename 
end variables

on w_mat_01010_barcode.create
int iCurrent
call super::create
this.dw_head=create dw_head
this.p_print=create p_print
this.p_close=create p_close
this.cbx_1=create cbx_1
this.dw_print=create dw_print
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_head
this.Control[iCurrent+2]=this.p_print
this.Control[iCurrent+3]=this.p_close
this.Control[iCurrent+4]=this.cbx_1
this.Control[iCurrent+5]=this.dw_print
this.Control[iCurrent+6]=this.rr_1
this.Control[iCurrent+7]=this.rr_2
end on

on w_mat_01010_barcode.destroy
call super::destroy
destroy(this.dw_head)
destroy(this.p_print)
destroy(this.p_close)
destroy(this.cbx_1)
destroy(this.dw_print)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_1.settransobject(sqlca)
dw_head.settransobject(sqlca)
dw_print.settransobject(sqlca)
dw_head.insertrow(0)

//전표번호
is_code = gs_code

dw_1.retrieve( gs_sabu, gs_saupj, is_code)
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_mat_01010_barcode
integer x = 91
integer y = 5000
end type

type p_exit from w_inherite_popup`p_exit within w_mat_01010_barcode
integer x = 4032
integer y = 28
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

dw_head.reset()
dw_head.insertrow(0)
dw_1.reset()

cbx_1.checked = false
cbx_1.text = '전체선택'

end event

type p_inq from w_inherite_popup`p_inq within w_mat_01010_barcode
integer x = 3685
integer y = 28
end type

event p_inq::clicked;call super::clicked;string ls_jpno

if dw_head.accepttext() = -1 then return -1

//입고번호
ls_jpno = dw_head.GetItemString(1,'jpno') 

if IsNull(ls_jpno) or ls_jpno = '' then 
    f_message_chk(30,'[입고번호]')
	 dw_head.Setcolumn("jpno")
	 dw_head.setfocus()
	 return
else
	 ls_jpno = ls_jpno + '%'
end if

dw_1.setredraw(false)

IF	dw_1.retrieve( gs_sabu, gs_saupj, ls_jpno)<	1	THEN
	dw_1.setredraw(true)
	f_message_chk(50, '[입고내역]')
	dw_head.setcolumn("jpno")
	dw_head.setfocus()
END IF

dw_1.setredraw(true)

end event

type p_choose from w_inherite_popup`p_choose within w_mat_01010_barcode
boolean visible = false
integer x = 2702
integer y = 32
end type

event p_choose::clicked;call super::clicked;//Long ll_row
//
//ll_Row = dw_1.GetSelectedRow(0)
//
//IF ll_Row <= 0 THEN
//   f_message_chk(36,'')
//   return
//END IF
//
//gs_code     = dw_1.GetItemString(ll_Row, "rollno")
//gs_codename = dw_1.GetItemString(ll_Row, "rollnm")
//gi_page     = dw_1.GetItemnumber(ll_Row, "seq")
//
//Close(Parent)
//
end event

type dw_1 from w_inherite_popup`dw_1 within w_mat_01010_barcode
integer x = 50
integer y = 212
integer width = 4297
integer height = 1836
string dataobject = "d_mat_01010_bar_1"
end type

event dw_1::clicked;call super::clicked;If Row >0 then
	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
END IF

end event

event dw_1::doubleclicked;//IF Row <= 0 THEN
//   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
//   return
//END IF
//
//gs_code     = dw_1.GetItemString(Row, "rollno")
//gs_codename = dw_1.GetItemString(Row, "rollnm")
//gi_page     = dw_1.GetItemnumber(row, "seq")
//
//Close(Parent)
//
end event

type sle_2 from w_inherite_popup`sle_2 within w_mat_01010_barcode
integer x = 558
end type

type cb_1 from w_inherite_popup`cb_1 within w_mat_01010_barcode
integer x = 1687
integer y = 5000
end type

type cb_return from w_inherite_popup`cb_return within w_mat_01010_barcode
integer x = 2322
integer y = 5000
end type

type cb_inq from w_inherite_popup`cb_inq within w_mat_01010_barcode
integer x = 2002
integer y = 5000
end type

event cb_inq::clicked;//
end event

type sle_1 from w_inherite_popup`sle_1 within w_mat_01010_barcode
integer width = 242
integer limit = 6
end type

type st_1 from w_inherite_popup`st_1 within w_mat_01010_barcode
long textcolor = 128
long backcolor = 12632256
string text = "설 비 :"
end type

type dw_head from datawindow within w_mat_01010_barcode
integer x = 50
integer y = 48
integer width = 1591
integer height = 116
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_mat_01000_bar"
boolean border = false
boolean livescroll = true
end type

event itemchanged;string ls_jpno, ls_null
long   ll_cnt
			
SetNull(ls_null)

IF this.GetColumnName() = 'jpno'	THEN
	ls_jpno = TRIM(this.GetText())
	
	SELECT count(*) INTO :ll_cnt
	  FROM imhist
	 WHERE sabu   = :gs_sabu			
	   AND iojpno like :ls_jpno
		AND jnpcrt = '009' 
		AND rownum = 1;
		
	IF SQLCA.SQLCODE <> 0	THEN
		f_message_chk(33,'[입고번호]')
		this.setitem(1, "jpno", ls_null)
		RETURN 1
	END IF
END IF



end event

event itemerror;return 1
end event

event rbuttondown;setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

IF this.GetColumnName() = 'jpno'	THEN
	gs_gubun = '009'
	Open(w_007_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return
	SetItem(1,"jpno",	left(gs_code, 12))
	this.TriggerEvent("itemchanged")
	
	dw_1.reset()
END IF


end event

type p_print from uo_picture within w_mat_01010_barcode
integer x = 3858
integer y = 28
integer width = 178
integer taborder = 80
boolean bringtotop = true
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\인쇄_up.gif"
end type

event clicked;string ls_chk, ls_code, ls_no
long   ll_rowcnt, ll_cnt, ll_copies, ll_count, ll_mod
int    i, j, h, k
dec    ld_pqty, ld_cutqty

if dw_1.accepttext() = -1 then return -1

ll_rowcnt = dw_1.rowcount()
if ll_rowcnt < 1 then
	MessageBox('확인','인쇄할 자료가 존재하지 않습니다!')
	return
end if

ll_cnt = 0
for i = 1 to dw_1.rowcount()
	 ls_chk = dw_1.GetItemString(i,'chk')
	 if ls_chk = 'Y' then
		 ll_cnt++
	 end if	
next	

if ll_cnt = 0 then
	MessageBox('확인','인쇄할 자료를 선택 후 작업하세요!')
	return
end if

//용지 SIZE 지정
dw_print.object.datawindow.print.paper.size = '11.43cm * 11.43cm'

//프린터 옵션 Open
if printsetup() = -1 then
	messagebox("프린트 선택 에러!", "프린트를 선택할 수 없습니다.")
end if

//OpenWithParm(w_print_options, dw_1)

//바코드 발행
for j = 1 to dw_1.rowcount()
	 ls_chk = dw_1.GetItemString(j,'chk')
	 if ls_chk = 'Y' then
 		 ls_code   = dw_1.GetItemString(j,'imhist_itnbr')
		 ls_no     = dw_1.GetItemString(j,'iojpno')
		 ll_copies = dw_1.GetItemNumber(j,'copies')
	    ld_pqty   = dw_1.GetItemNumber(j,'imhist_ioqty')  //수량
   	 ld_cutqty = dw_1.GetItemNumber(j,'print_qty') //분할수량	
		 
		 if ld_cutqty > 0 then			 			 
			 if ld_pqty <= ld_cutqty then
				 if dw_print.retrieve(gs_sabu, gs_saupj, ls_no, ls_code) = 1 then
					 for k = 1 to ll_copies
						  dw_print.print()
					 next	
				 end if				 
			 else
				 // ll_cutqty : 분할 수량
				 // ll_qty    : 조회 수량
				 // ll_mod    : 나머지 수량
				 // ll_count  : 출력 장수
				 ll_count = Int(ld_pqty / ld_cutqty)  
				 ll_mod   = MOD(ld_pqty, ld_cutqty)   

				 if dw_print.retrieve(gs_sabu, gs_saupj, ls_no, ls_code) = 1 then
					 //분할수량을 조회수량에 입력하여 출력 장수만큼 출력
					 dw_print.setitem(1,'imhist_ioqty', ld_cutqty )
					 for h = 1 to ll_count				     	  						  
						  for k = 1 to ll_copies
							   dw_print.print()
						  next	
					 next					 
					 //나머지 수량이 존재할 경우 나머지 수량 입력 후 한번 더 출력
					 if ll_mod <> 0 then
						 dw_print.setitem(1,'imhist_ioqty', ll_mod)
						 for k = 1 to ll_copies
							  dw_print.print()
						 next	
					 end if	 
				 end if				 			 			 
			 end if	 
		else
			if dw_print.retrieve(gs_sabu, gs_saupj, ls_no, ls_code) = 1 then
				for k = 1 to ll_copies
			       dw_print.print()
 			   next	
			end if	 
		end if
	end if		

next	
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\인쇄_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\인쇄_up.gif"
end event

type p_close from uo_picture within w_mat_01010_barcode
integer x = 4206
integer y = 28
integer width = 178
integer taborder = 80
boolean bringtotop = true
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;w_mdi_frame.sle_msg.text =""

close(parent)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type cbx_1 from checkbox within w_mat_01010_barcode
integer x = 1705
integer y = 112
integer width = 402
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 134217750
string text = "전체선택"
end type

event clicked;long ll_count, lCount
string ls_status

if this.checked = true then
	ls_status='Y'
	this.text = '전체해제'
else
	ls_status='N'
	this.text = '전체선택'
end if

SetPointer(HourGlass!)

lCount = dw_1.rowcount() 

for ll_count=1 to lCount
	dw_1.setitem(ll_count, 'chk', ls_status)
next


end event

type dw_print from datawindow within w_mat_01010_barcode
boolean visible = false
integer x = 2144
integer y = 28
integer width = 366
integer height = 148
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_mat_01010_bar_p"
boolean border = false
end type

type rr_1 from roundrectangle within w_mat_01010_barcode
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 200
integer width = 4352
integer height = 1864
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_mat_01010_barcode
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 44
integer width = 1614
integer height = 128
integer cornerheight = 40
integer cornerwidth = 55
end type

