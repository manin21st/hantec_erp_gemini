$PBExportHeader$w_sys_009.srw
$PBExportComments$** 시스템메세지 등록
forward
global type w_sys_009 from w_inherite
end type
type dw_1 from datawindow within w_sys_009
end type
type rr_1 from roundrectangle within w_sys_009
end type
end forward

global type w_sys_009 from w_inherite
string title = "시스템 메세지 등록"
boolean resizable = true
dw_1 dw_1
rr_1 rr_1
end type
global w_sys_009 w_sys_009

type variables

end variables

event open;call super::open;
dw_1.SetTransObject(SQLCA)

dw_1.Retrieve()

ib_any_typing = false
end event

on w_sys_009.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_sys_009.destroy
call super::destroy
destroy(this.dw_1)
destroy(this.rr_1)
end on

type dw_insert from w_inherite`dw_insert within w_sys_009
boolean visible = false
integer x = 923
integer y = 2376
integer width = 91
integer height = 76
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_sys_009
integer x = 3895
integer y = 20
end type

event p_delrow::clicked;call super::clicked;
long ll_RowNbr

ll_RowNbr = dw_1.Getitemnumber(dw_1.getrow(), "msg_no" )   

IF MessageBox("확인",string(ll_RowNbr) + "번 MESSAGE를 삭제하시겠습니까?",Question!,YesNo!) = 2 THEN RETURN

long 	curr_row

curr_row = dw_1.getrow()

if curr_row > 0  then
   dw_1.deleterow(curr_row)
   dw_1.setcolumn(2)
   dw_1.setfocus()
end if

IF dw_1.Update() = 1 THEN
	COMMIT;
	dw_1.SetRedraw(FALSE)
	dw_1.Reset()
	dw_1.Retrieve(0)
	dw_1.SetRedraw(true)
	w_mdi_frame.sle_msg.text ="자료를 삭제하였습니다.!!!"
ELSE
	ROLLBACK;
END IF

ib_any_typing =False
end event

type p_addrow from w_inherite`p_addrow within w_sys_009
integer x = 3721
integer y = 20
end type

event p_addrow::clicked;call super::clicked;w_mdi_frame.sle_msg.text = "자료를 입력하십시요.!!!" 
 
//dw_1.InsertRow(0)
dw_1.ScrollToRow(dw_1.insertrow(0))

dw_1.SetColumn(1)

dw_1.SetRow( dw_1.rowcount() )

dw_1.SetFocus()


end event

type p_search from w_inherite`p_search within w_sys_009
boolean visible = false
integer x = 1787
integer y = 2376
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_sys_009
boolean visible = false
integer x = 1522
integer y = 2380
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_sys_009
integer x = 4416
integer y = 20
end type

type p_can from w_inherite`p_can within w_sys_009
boolean visible = false
integer x = 2121
integer y = 2380
boolean enabled = false
end type

type p_print from w_inherite`p_print within w_sys_009
integer x = 4242
integer y = 20
end type

event p_print::clicked;call super::clicked;IF MessageBox("확인", "출력하시겠습니까?", question!, yesno!) = 2	THEN	RETURN

dw_1.print()
end event

type p_inq from w_inherite`p_inq within w_sys_009
integer x = 3547
integer y = 20
end type

event p_inq::clicked;call super::clicked;dw_1.Retrieve()

ib_any_typing = false
end event

type p_del from w_inherite`p_del within w_sys_009
boolean visible = false
integer x = 1947
integer y = 2380
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_sys_009
integer x = 4069
integer y = 20
end type

event p_mod::clicked;call super::clicked;IF dw_1.AcceptText() = -1 THEN 
	dw_1.retrieve(0) 
	RETURN
end if 

if f_msg_update() = -1 then return

IF dw_1.Update() = 1 THEN
	
	dw_1.SetRedraw(FALSE)
	//dw_1.Reset()
	dw_1.Retrieve(0)
	dw_1.SetRedraw(true)
	
	sle_msg.text ="자료를 저장하였습니다.!!!"
	COMMIT;

ELSE

	ROLLBACK;
	
   dw_1.SetColumn(1)

   dw_1.SetRow( dw_1.rowcount() )

   dw_1.SetFocus()
   
   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
END IF
	
ib_any_typing =False	


end event

type st_1 from w_inherite`st_1 within w_sys_009
integer x = 9
integer y = 2432
integer width = 361
end type

type cb_can from w_inherite`cb_can within w_sys_009
boolean visible = false
integer x = 2478
integer y = 2428
end type

type cb_search from w_inherite`cb_search within w_sys_009
boolean visible = false
integer x = 2834
integer y = 2428
end type

type dw_datetime from w_inherite`dw_datetime within w_sys_009
integer x = 2821
integer y = 2432
integer width = 741
integer height = 84
end type

type sle_msg from w_inherite`sle_msg within w_sys_009
integer x = 375
integer y = 2432
integer width = 2446
end type

type gb_10 from w_inherite`gb_10 within w_sys_009
boolean visible = false
integer y = 2444
integer width = 3579
end type

type gb_button1 from w_inherite`gb_button1 within w_sys_009
end type

type gb_button2 from w_inherite`gb_button2 within w_sys_009
end type

type dw_1 from datawindow within w_sys_009
event dw pbm_dwnprocessenter
integer x = 37
integer y = 192
integer width = 4535
integer height = 2096
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_sys_009"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event dw;send(handle(this),256,9,0)

return 1
end event

event editchanged;ib_any_typing =True
end event

event clicked;//long lrow
//
//lrow = dw_1.rowcount()
//
//IF lrow <= 0 THEN RETURN
//
//SelectRow(0,False)
//
//SelectRow(dw_1.getrow(),True)
//
end event

event itemchanged;long lReturnRow, lnull, lrow

sle_msg.text = ""

setnull(lnull)

IF dwo.name ="msg_no" THEN
	IF data ="" OR IsNull(data) THEN RETURN 
	
	lRow  = this.GetRow()	
	
	lReturnRow = This.Find("str_msg_no = '"+data+"' ", 1, This.RowCount())
	
	IF (lRow <> lReturnRow) and (lReturnRow <> 0)		THEN
	
		f_message_chk(37,'[MSG NO]') 
		
		this.SetItem(lRow, "msg_no", lNull)
		
		RETURN  1
		
	END IF

END IF

end event

event itemerror;
Return 1
end event

event itemfocuschanged;Long wnd

wnd =Handle(this)

IF dwo.name ="msg_txt1" OR dwo.name ="msg_txt2" OR dwo.name ="msg_bigo" THEN
	f_toggle_kor(wnd)
ELSE
	f_toggle_eng(wnd)
END IF
end event

type rr_1 from roundrectangle within w_sys_009
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 180
integer width = 4558
integer height = 2120
integer cornerheight = 40
integer cornerwidth = 55
end type

