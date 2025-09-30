$PBExportHeader$w_imt_04010.srw
$PBExportComments$소급적용 등록(조회)
forward
global type w_imt_04010 from window
end type
type pb_3 from u_pb_cal within w_imt_04010
end type
type pb_1 from u_pb_cal within w_imt_04010
end type
type dw_list from datawindow within w_imt_04010
end type
type dw_detail from datawindow within w_imt_04010
end type
type rr_1 from roundrectangle within w_imt_04010
end type
type rr_2 from roundrectangle within w_imt_04010
end type
end forward

global type w_imt_04010 from window
integer x = 247
integer y = 212
integer width = 3223
integer height = 2068
boolean titlebar = true
string title = "소급대상 이력 조회"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
pb_3 pb_3
pb_1 pb_1
dw_list dw_list
dw_detail dw_detail
rr_1 rr_1
rr_2 rr_2
end type
global w_imt_04010 w_imt_04010

type variables
string is_pspec, is_jijil
end variables

on w_imt_04010.create
this.pb_3=create pb_3
this.pb_1=create pb_1
this.dw_list=create dw_list
this.dw_detail=create dw_detail
this.rr_1=create rr_1
this.rr_2=create rr_2
this.Control[]={this.pb_3,&
this.pb_1,&
this.dw_list,&
this.dw_detail,&
this.rr_1,&
this.rr_2}
end on

on w_imt_04010.destroy
destroy(this.pb_3)
destroy(this.pb_1)
destroy(this.dw_list)
destroy(this.dw_detail)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;f_window_center_response(this)

dw_detail.SetTransObject(sqlca)
dw_list.SetTransObject(sqlca)

dw_detail.InsertRow(0)

string sitdsc, sispec, sjijil, sispec_code

////////////////////////////////////////////////////////////////////////////
str_item		str_parm
str_parm = Message.PowerObjectParm

select itdsc, ispec, ispec_code, jijil
  into :sitdsc, :sispec, :sispec_code, :sjijil
  from itemas
 where itnbr = :str_parm.code ;

dw_detail.SetItem(1, "item", 		str_parm.code)
dw_detail.SetItem(1, "itemname", sitdsc)
dw_detail.SetItem(1, "spec",		sispec)
dw_detail.SetItem(1, "jijil",    sjijil)
dw_detail.SetItem(1, "ispec_code",	sispec_code)
dw_detail.SetItem(1, "vendor",	str_parm.cust)
dw_detail.SetItem(1, "sdate",		str_parm.etc1)
dw_detail.SetItem(1, "edate",		str_parm.flag)
dw_detail.SetItem(1, "saupj",		str_parm.name)

dw_list.Retrieve(gs_Sabu,str_parm.cust,str_parm.code,str_parm.etc1,str_parm.flag, str_parm.name)
end event

type pb_3 from u_pb_cal within w_imt_04010
integer x = 2816
integer y = 40
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_detail.SetColumn('edate')
IF IsNull(gs_code) THEN Return
ll_row = dw_detail.GetRow()
If ll_row < 1 Then Return
dw_detail.SetItem(ll_row, 'edate', gs_code)



end event

type pb_1 from u_pb_cal within w_imt_04010
integer x = 2377
integer y = 40
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_detail.SetColumn('sdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_detail.GetRow()
If ll_row < 1 Then Return
dw_detail.SetItem(ll_row, 'sdate', gs_code)



end event

type dw_list from datawindow within w_imt_04010
integer x = 46
integer y = 416
integer width = 3109
integer height = 1524
integer taborder = 20
string dataobject = "d_imt_04011"
boolean border = false
boolean livescroll = true
end type

type dw_detail from datawindow within w_imt_04010
integer x = 101
integer y = 32
integer width = 2999
integer height = 356
integer taborder = 10
string dataobject = "d_imt_04010"
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_imt_04010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 404
integer width = 3127
integer height = 1548
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_imt_04010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 32
integer y = 24
integer width = 3127
integer height = 372
integer cornerheight = 40
integer cornerwidth = 55
end type

