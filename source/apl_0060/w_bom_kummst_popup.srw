$PBExportHeader$w_bom_kummst_popup.srw
$PBExportComments$BOM ���� ��ȸ (2017.06.18-����)
forward
global type w_bom_kummst_popup from w_inherite_popup
end type
type rr_1 from roundrectangle within w_bom_kummst_popup
end type
end forward

global type w_bom_kummst_popup from w_inherite_popup
integer x = 640
integer y = 200
integer width = 2811
integer height = 1736
string title = "BOM ������ ��ȸ"
rr_1 rr_1
end type
global w_bom_kummst_popup w_bom_kummst_popup

type variables
string is_visible
end variables

on w_bom_kummst_popup.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_bom_kummst_popup.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)
dw_jogun.Reset()
dw_jogun.InsertRow(0)

string sitdsc, sispec, sitnbr

f_get_name2('ǰ��', 'Y', gs_code, sitdsc, sispec)    //1�̸� ����, 0�� ����	
dw_jogun.setitem(1, "itnbr", gs_code)	    // ǰ�� 
dw_jogun.setitem(1, "itdsc", sitdsc)	    // ǰ�� 

p_inq.PostEvent(Clicked!)
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_bom_kummst_popup
integer x = 27
integer y = 8
integer width = 1554
integer height = 140
string title = ""
string dataobject = "d_bom_kummst_popup"
end type

type p_exit from w_inherite_popup`p_exit within w_bom_kummst_popup
integer x = 2533
integer y = 0
string picturename = "C:\erpman\image\�ݱ�_up.gif"
end type

event p_exit::clicked;call super::clicked;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

close( parent)
end event

event p_exit::ue_lbuttondown;PictureName = 'C:\erpman\image\�ݱ�_dn.gif'
end event

event p_exit::ue_lbuttonup;PictureName = 'C:\erpman\image\�ݱ�_up.gif'
end event

type p_inq from w_inherite_popup`p_inq within w_bom_kummst_popup
boolean visible = false
integer x = 2185
integer y = 0
boolean originalsize = false
end type

event p_inq::clicked;call super::clicked;String   ls_itnbr, ls_depot_no, ls_ymd
  
IF dw_jogun.AcceptText() = -1 THEN RETURN 

ls_itnbr = dw_jogun.Getitemstring(1, "itnbr" )
IF dw_1.Retrieve(ls_itnbr) <= 0 THEN
//   messagebox("Ȯ��", "���ǿ� �´� �ڷᰡ �����ϴ�!!")
//	dw_jogun.SetColumn("depot_no")
//	dw_jogun.SetFocus()
	Return
END IF

ls_ymd = f_today()

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()

end event

type p_choose from w_inherite_popup`p_choose within w_bom_kummst_popup
integer x = 2359
integer y = 0
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "kumno")
Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_bom_kummst_popup
integer x = 32
integer y = 184
integer width = 2706
integer height = 1408
string dataobject = "d_bom_kummst_popup1"
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

event dw_1::doubleclicked;IF Row <= 0 THEN
   MessageBox("Ȯ ��", "���ð��� �����ϴ�. �ٽ� �������� ���ù�ư�� �����ʽÿ� !")
   return
END IF

gs_code = dw_1.GetItemString(Row, "kumno") 
Close(Parent)
end event

type sle_2 from w_inherite_popup`sle_2 within w_bom_kummst_popup
boolean visible = false
integer x = 549
integer y = 2440
end type

type cb_1 from w_inherite_popup`cb_1 within w_bom_kummst_popup
boolean visible = false
integer x = 1815
integer y = 2440
end type

type cb_return from w_inherite_popup`cb_return within w_bom_kummst_popup
boolean visible = false
integer x = 2427
integer y = 2440
integer taborder = 40
end type

type cb_inq from w_inherite_popup`cb_inq within w_bom_kummst_popup
boolean visible = false
integer x = 2121
integer y = 2440
integer taborder = 20
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_bom_kummst_popup
boolean visible = false
integer x = 366
integer y = 2440
end type

type st_1 from w_inherite_popup`st_1 within w_bom_kummst_popup
boolean visible = false
integer x = 87
integer y = 2440
end type

type rr_1 from roundrectangle within w_bom_kummst_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 176
integer width = 2725
integer height = 1424
integer cornerheight = 40
integer cornerwidth = 55
end type

