$PBExportHeader$w_pig5031.srw
$PBExportComments$설문지 등록
forward
global type w_pig5031 from w_inherite_standard
end type
type dw_1 from datawindow within w_pig5031
end type
type rr_1 from roundrectangle within w_pig5031
end type
end forward

global type w_pig5031 from w_inherite_standard
integer width = 4023
string title = "설문지 등록"
string menuname = ""
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
dw_1 dw_1
rr_1 rr_1
end type
global w_pig5031 w_pig5031

type variables
str_edu    istr_edu
end variables

on w_pig5031.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_pig5031.destroy
call super::destroy
destroy(this.dw_1)
destroy(this.rr_1)
end on

event open;string sOwrEmp = '999999'

f_window_center_response(this)

dw_1.SetTransObject(sqlca)

istr_edu = Message.PowerObjectParm

if dw_1.retrieve(gs_company, istr_edu.str_empno, istr_edu.str_eduyear,istr_edu.str_empseq,istr_edu.str_empno ) > 0 then
	dw_1.SetItem(1,"sflag",'M')
	dw_1.setColumn("paper1")
	dw_1.setfocus()
//else
//	dw_1.insertrow(0)
//	dw_1.Setitem(1, 'companycode', gs_company)
end if


end event

type p_mod from w_inherite_standard`p_mod within w_pig5031
integer x = 3616
integer y = 44
integer taborder = 30
end type

event p_mod::clicked;call super::clicked;
if dw_1.update() = 1 then
   commit;
else
	MessageBox("확인", "자료가 저장되지 않았습니다")
	rollback;
end if

ib_any_typing = false

messagebox("확인", "자료가 저장되었습니다.!!")
end event

type p_del from w_inherite_standard`p_del within w_pig5031
integer x = 3767
integer y = 3500
integer taborder = 0
end type

type p_inq from w_inherite_standard`p_inq within w_pig5031
integer x = 2898
integer y = 3500
integer taborder = 0
end type

type p_print from w_inherite_standard`p_print within w_pig5031
integer x = 2725
integer y = 3508
integer taborder = 0
end type

type p_can from w_inherite_standard`p_can within w_pig5031
boolean visible = false
integer x = 3643
integer y = 732
integer taborder = 0
end type

event p_can::clicked;call super::clicked;if dw_1.retrieve(gs_code, istr_edu.str_empno, istr_edu.str_eduyear,istr_edu.str_empseq) > 0 then
	dw_1.SetItem(1,"sflag",'M')
	dw_1.setColumn("paper1")
	dw_1.setfocus()
end if

ib_any_typing = false
sle_msg.text = "자료가 취소되었습니다.!!"

end event

type p_exit from w_inherite_standard`p_exit within w_pig5031
integer x = 3790
integer y = 44
integer taborder = 40
end type

type p_ins from w_inherite_standard`p_ins within w_pig5031
integer x = 3072
integer y = 3500
integer taborder = 0
end type

type p_search from w_inherite_standard`p_search within w_pig5031
integer x = 2546
integer y = 3500
integer taborder = 0
end type

type p_addrow from w_inherite_standard`p_addrow within w_pig5031
integer x = 3246
integer y = 3500
integer taborder = 0
end type

type p_delrow from w_inherite_standard`p_delrow within w_pig5031
integer x = 3419
integer y = 3500
integer taborder = 0
end type

type dw_insert from w_inherite_standard`dw_insert within w_pig5031
boolean visible = false
integer x = 78
integer y = 3040
integer taborder = 0
end type

type st_window from w_inherite_standard`st_window within w_pig5031
boolean visible = false
integer x = 2272
integer y = 3280
integer taborder = 0
long backcolor = 80269524
end type

type cb_exit from w_inherite_standard`cb_exit within w_pig5031
boolean visible = false
integer x = 3278
integer y = 3108
integer taborder = 0
end type

type cb_update from w_inherite_standard`cb_update within w_pig5031
boolean visible = false
integer x = 2537
integer y = 3108
integer taborder = 0
end type

type cb_insert from w_inherite_standard`cb_insert within w_pig5031
boolean visible = false
integer x = 526
integer y = 3108
integer taborder = 0
boolean enabled = false
end type

type cb_delete from w_inherite_standard`cb_delete within w_pig5031
boolean visible = false
integer x = 2533
integer y = 3108
integer taborder = 20
boolean enabled = false
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pig5031
boolean visible = false
integer x = 151
integer y = 3104
integer taborder = 0
boolean enabled = false
end type

type st_1 from w_inherite_standard`st_1 within w_pig5031
boolean visible = false
integer x = 96
integer y = 3276
long backcolor = 80269524
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pig5031
boolean visible = false
integer x = 2907
integer y = 3108
integer taborder = 0
end type

type dw_datetime from w_inherite_standard`dw_datetime within w_pig5031
boolean visible = false
integer x = 2917
integer y = 3280
end type

type sle_msg from w_inherite_standard`sle_msg within w_pig5031
boolean visible = false
integer x = 434
integer y = 3280
long backcolor = 80269524
end type

type gb_2 from w_inherite_standard`gb_2 within w_pig5031
boolean visible = false
integer x = 2496
integer y = 3048
integer width = 1157
long backcolor = 80269524
end type

type gb_1 from w_inherite_standard`gb_1 within w_pig5031
boolean visible = false
integer x = 123
integer y = 3048
boolean enabled = false
end type

type gb_10 from w_inherite_standard`gb_10 within w_pig5031
boolean visible = false
integer x = 87
integer y = 3228
long backcolor = 80269524
end type

type dw_1 from datawindow within w_pig5031
event ue_enterkey pbm_dwnprocessenter
integer x = 59
integer y = 64
integer width = 3515
integer height = 2184
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pig50311"
boolean border = false
end type

event ue_enterkey;
Send(Handle(this),256,9,0)
Return 1

end event

event itemerror;return 1
end event

event editchanged;ib_any_typing =True
end event

type rr_1 from roundrectangle within w_pig5031
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 52
integer width = 3552
integer height = 2220
integer cornerheight = 40
integer cornerwidth = 55
end type

