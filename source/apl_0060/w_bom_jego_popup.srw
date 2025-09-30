$PBExportHeader$w_bom_jego_popup.srw
$PBExportComments$BOM 재고수량 조회 [v2.0.170514]
forward
global type w_bom_jego_popup from w_inherite_popup
end type
type dw_2 from datawindow within w_bom_jego_popup
end type
type rr_1 from roundrectangle within w_bom_jego_popup
end type
type rr_2 from roundrectangle within w_bom_jego_popup
end type
end forward

global type w_bom_jego_popup from w_inherite_popup
integer x = 640
integer y = 200
integer width = 3977
integer height = 2116
string title = "BOM 재고수량 조회"
dw_2 dw_2
rr_1 rr_1
rr_2 rr_2
end type
global w_bom_jego_popup w_bom_jego_popup

type variables
string is_visible
end variables

on w_bom_jego_popup.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.rr_1
this.Control[iCurrent+3]=this.rr_2
end on

on w_bom_jego_popup.destroy
call super::destroy
destroy(this.dw_2)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_2.SetTransObject(SQLCA)

dw_jogun.SetTransObject(SQLCA)
dw_jogun.Reset()
dw_jogun.InsertRow(0)

string sitdsc, sispec, sitnbr

f_get_name2('품번', 'Y', gs_code, sitdsc, sispec)    //1이면 실패, 0이 성공	
dw_jogun.setitem(1, "itnbr", gs_code)	    // 품번 
dw_jogun.setitem(1, "itdsc", sitdsc)	    // 품명 
//dw_jogun.setitem(1, "depot_no", gs_gubun )  // 창고 
//dw_jogun.SetFocus()

//// open하는 곳에서 gs_codename = 'Y' 시 선택가능 	
//is_visible = gs_codename
//IF is_visible = '' or isnull(is_visible) then is_visible = 'N' 
//if is_visible = 'Y' then 
//   cb_1.visible = true
//else
//   cb_1.visible = false 
//end if
//
//dw_1.SelectRow(0,False)
//dw_1.SelectRow(1,True)
//dw_1.ScrollToRow(1)

p_inq.PostEvent(Clicked!)
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_bom_jego_popup
integer x = 27
integer y = 8
integer width = 1554
integer height = 140
string dataobject = "d_bom_jego_popup"
end type

type p_exit from w_inherite_popup`p_exit within w_bom_jego_popup
integer x = 3717
integer y = 8
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event p_exit::clicked;call super::clicked;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

close( parent)
end event

event p_exit::ue_lbuttondown;PictureName = 'C:\erpman\image\닫기_dn.gif'
end event

event p_exit::ue_lbuttonup;PictureName = 'C:\erpman\image\닫기_up.gif'
end event

type p_inq from w_inherite_popup`p_inq within w_bom_jego_popup
boolean visible = false
integer x = 3538
integer y = 8
end type

event p_inq::clicked;call super::clicked;String   ls_itnbr, ls_depot_no, ls_ymd
  
IF dw_jogun.AcceptText() = -1 THEN RETURN 

ls_itnbr = dw_jogun.Getitemstring(1, "itnbr" )

//ls_depot_no = Trim(dw_jogun.Getitemstring(1,"depot_no"))
//IF ls_depot_no = "" OR IsNull( ls_depot_no ) THEN
//	ls_depot_no = '%'
//END IF

IF dw_1.Retrieve(ls_itnbr) <= 0 THEN
//   messagebox("확인", "조건에 맞는 자료가 없습니다!!")
//	dw_jogun.SetColumn("depot_no")
//	dw_jogun.SetFocus()
	Return
END IF

ls_ymd = f_today()
dw_2.Retrieve(ls_ymd, ls_itnbr)

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()

end event

type p_choose from w_inherite_popup`p_choose within w_bom_jego_popup
boolean visible = false
integer x = 1723
integer y = 4
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "stock_pspec")


Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_bom_jego_popup
integer x = 32
integer y = 184
integer width = 3886
integer height = 1408
string dataobject = "d_bom_jego_popup1"
boolean hscrollbar = true
end type

event dw_1::clicked;call super::clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
//	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
//	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

event dw_1::doubleclicked;//IF is_visible <> 'Y' THEN RETURN 
//
//IF Row <= 0 THEN
//   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
//   return
//END IF
//
//gs_code = dw_1.GetItemString(Row, "stock_pspec")  
//
//Close(Parent)
end event

type sle_2 from w_inherite_popup`sle_2 within w_bom_jego_popup
boolean visible = false
integer x = 549
integer y = 2440
end type

type cb_1 from w_inherite_popup`cb_1 within w_bom_jego_popup
boolean visible = false
integer x = 1815
integer y = 2440
end type

type cb_return from w_inherite_popup`cb_return within w_bom_jego_popup
boolean visible = false
integer x = 2427
integer y = 2440
integer taborder = 40
end type

type cb_inq from w_inherite_popup`cb_inq within w_bom_jego_popup
boolean visible = false
integer x = 2121
integer y = 2440
integer taborder = 20
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_bom_jego_popup
boolean visible = false
integer x = 366
integer y = 2440
end type

type st_1 from w_inherite_popup`st_1 within w_bom_jego_popup
boolean visible = false
integer x = 87
integer y = 2440
end type

type dw_2 from datawindow within w_bom_jego_popup
integer x = 32
integer y = 1628
integer width = 3886
integer height = 356
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_bom_jego_popup2"
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_bom_jego_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 176
integer width = 3904
integer height = 1424
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_bom_jego_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 1620
integer width = 3904
integer height = 372
integer cornerheight = 40
integer cornerwidth = 55
end type

