$PBExportHeader$w_pik1002.srw
$PBExportComments$** 달력 수정
forward
global type w_pik1002 from w_inherite_standard
end type
type uo_1 from u_ddcal_pi within w_pik1002
end type
type dw_detail from u_key_enter within w_pik1002
end type
type p_1 from uo_picture within w_pik1002
end type
type rr_1 from roundrectangle within w_pik1002
end type
type rr_3 from roundrectangle within w_pik1002
end type
type st_2 from statictext within w_pik1002
end type
type dw_c from u_key_enter within w_pik1002
end type
type st_3 from statictext within w_pik1002
end type
type st_status from statictext within w_pik1002
end type
end forward

global type w_pik1002 from w_inherite_standard
string title = "달력 수정"
uo_1 uo_1
dw_detail dw_detail
p_1 p_1
rr_1 rr_1
rr_3 rr_3
st_2 st_2
dw_c dw_c
st_3 st_3
st_status st_status
end type
global w_pik1002 w_pik1002

type variables
boolean b_check = false

String print_gu                //window가 조회인지 인쇄인지  
String     is_preview          // dw상태가 preview인지
String     is_saup             //사업장코드
Integer   ii_factor = 100      // 프린트 확대축소
boolean   iv_b_down = false
end variables

event open;call super::open;
dw_datetime.settransobject(sqlca)
dw_datetime.insertrow(0)
dw_c.settransobject(sqlca)
dw_c.insertrow(0)

f_set_saupcd(dw_c, 'saup', '1')
is_saupcd = gs_saupcd

dw_detail.settransobject(sqlca)

//uo_1.init_cal(today())

string 	date_format

date_format = "yyyy/mm/dd"
uo_1.set_date_format ( date_format )

uo_1.fu_init_datawindow(dw_detail, is_saupcd)

uo_1.init_cal(today())


/*====================================================
	 WINDOW  datawindow(dw_1) 에 현재일자 retrieve
=====================================================*/
string 	retrieve_format

retrieve_format = String( today(), "yyyymmdd" )

dw_detail.retrieve( is_saupcd, retrieve_format )

st_status.text = ''	



ib_any_typing=False

end event

event mousemove;call super::mousemove;uo_1.uf_tips(uo_1.st_tips, w_pik1002, uo_1.dw_cal, xpos, ypos, 0, 0)
end event

on w_pik1002.create
int iCurrent
call super::create
this.uo_1=create uo_1
this.dw_detail=create dw_detail
this.p_1=create p_1
this.rr_1=create rr_1
this.rr_3=create rr_3
this.st_2=create st_2
this.dw_c=create dw_c
this.st_3=create st_3
this.st_status=create st_status
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.dw_detail
this.Control[iCurrent+3]=this.p_1
this.Control[iCurrent+4]=this.rr_1
this.Control[iCurrent+5]=this.rr_3
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.dw_c
this.Control[iCurrent+8]=this.st_3
this.Control[iCurrent+9]=this.st_status
end on

on w_pik1002.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
destroy(this.dw_detail)
destroy(this.p_1)
destroy(this.rr_1)
destroy(this.rr_3)
destroy(this.st_2)
destroy(this.dw_c)
destroy(this.st_3)
destroy(this.st_status)
end on

type p_mod from w_inherite_standard`p_mod within w_pik1002
boolean visible = false
integer x = 1399
integer y = 2296
end type

type p_del from w_inherite_standard`p_del within w_pik1002
boolean visible = false
integer x = 1573
integer y = 2296
end type

type p_inq from w_inherite_standard`p_inq within w_pik1002
boolean visible = false
integer x = 704
integer y = 2296
end type

type p_print from w_inherite_standard`p_print within w_pik1002
boolean visible = false
integer x = 530
integer y = 2296
end type

type p_can from w_inherite_standard`p_can within w_pik1002
boolean visible = false
integer x = 1746
integer y = 2296
end type

type p_exit from w_inherite_standard`p_exit within w_pik1002
integer x = 4416
end type

type p_ins from w_inherite_standard`p_ins within w_pik1002
boolean visible = false
integer x = 878
integer y = 2296
end type

type p_search from w_inherite_standard`p_search within w_pik1002
boolean visible = false
integer x = 352
integer y = 2296
end type

type p_addrow from w_inherite_standard`p_addrow within w_pik1002
boolean visible = false
integer x = 1051
integer y = 2296
end type

type p_delrow from w_inherite_standard`p_delrow within w_pik1002
boolean visible = false
integer x = 1225
integer y = 2296
end type

type dw_insert from w_inherite_standard`dw_insert within w_pik1002
boolean visible = false
integer y = 2300
end type

type st_window from w_inherite_standard`st_window within w_pik1002
boolean visible = false
end type

type cb_exit from w_inherite_standard`cb_exit within w_pik1002
boolean visible = false
end type

type cb_update from w_inherite_standard`cb_update within w_pik1002
boolean visible = false
end type

type cb_insert from w_inherite_standard`cb_insert within w_pik1002
boolean visible = false
end type

type cb_delete from w_inherite_standard`cb_delete within w_pik1002
boolean visible = false
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pik1002
boolean visible = false
end type

type st_1 from w_inherite_standard`st_1 within w_pik1002
boolean visible = false
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pik1002
boolean visible = false
end type

type dw_datetime from w_inherite_standard`dw_datetime within w_pik1002
boolean visible = false
end type

type sle_msg from w_inherite_standard`sle_msg within w_pik1002
boolean visible = false
end type

type gb_2 from w_inherite_standard`gb_2 within w_pik1002
boolean visible = false
end type

type gb_1 from w_inherite_standard`gb_1 within w_pik1002
boolean visible = false
end type

type gb_10 from w_inherite_standard`gb_10 within w_pik1002
boolean visible = false
end type

type uo_1 from u_ddcal_pi within w_pik1002
event destroy ( )
integer x = 800
integer y = 476
integer taborder = 40
boolean bringtotop = true
string is_saup = "is_saup"
end type

on uo_1.destroy
call u_ddcal_pi::destroy
end on

type dw_detail from u_key_enter within w_pik1002
integer x = 2729
integer y = 712
integer width = 1070
integer height = 640
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_pik10021"
boolean border = false
borderstyle borderstyle = styleraised!
end type

type p_1 from uo_picture within w_pik1002
integer x = 4242
integer y = 24
integer width = 178
integer taborder = 80
boolean bringtotop = true
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;call super::clicked;
date		date_selected
string	sWorkDay
int		iyydate, immdate, idddate, i_FirstDayNum, i_cell

st_status.text = ''	

IF	dw_detail.AcceptText() = -1	then
	RETURN
END IF

sWorkDay = dw_detail.GetItemString(1, "cldate")

iyydate  = integer( mid(sWorkDay, 1, 4) )
immdate  = integer( mid(sWorkDay, 5, 2) )
idddate  = integer( mid(sWorkDay, 7, 2) )

date_selected = date(iyydate, immdate, idddate )

SetPointer(HourGlass!)
IF dw_detail.Update() > 0 THEN	 

	COMMIT USING sqlca;

	i_FirstDayNum = DayNumber(date(iyydate, immdate, 1 ))

	i_Cell = i_FirstDayNum + idddate - 1					// 현재일자 위치
	
	if dw_detail.Getitemstring(1,"hdaygubn") <> '0' and  & 
   	dw_detail.Getitemstring(1,"daygubn") <> '7'  then //저장시 휴무일이면 빨간색으로 변환
	 	uo_1.uf_redcolumnchk(string(i_cell))
	elseif dw_detail.Getitemstring(1,"hdaygubn") <> '0'  and & 
	        dw_detail.Getitemstring(1,"daygubn") = '7'  then //저장시 휴무일이면 파란색으로 변환
	 	uo_1.uf_bluecolumnchk(string(i_cell))
   else	 
		uo_1.uf_blackcolumnchk(string(i_cell))
	end if
	
	uo_1.fu_WorkDayCount( date_selected )

   b_check = true

ELSE

	ROLLBACK USING sqlca;
	SetPointer(Arrow!)
	Return
END IF

w_mdi_frame.sle_msg.Text ='자료를 저장하였습니다!!'
SetPointer(Arrow!)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type rr_1 from roundrectangle within w_pik1002
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2720
integer y = 700
integer width = 1106
integer height = 676
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_pik1002
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 754
integer y = 448
integer width = 1765
integer height = 1292
integer cornerheight = 40
integer cornerwidth = 55
end type

type st_2 from statictext within w_pik1002
boolean visible = false
integer x = 2080
integer y = 488
integer width = 411
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 12632256
boolean enabled = false
string text = "CALENDAR"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_c from u_key_enter within w_pik1002
integer x = 745
integer y = 256
integer width = 901
integer height = 164
integer taborder = 11
boolean bringtotop = true
string title = "none"
string dataobject = "d_pik10021_c"
boolean border = false
end type

event itemchanged;call super::itemchanged;this.AcceptText()

IF this.GetColumnName() = 'saup' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF


uo_1.fu_init_datawindow(dw_detail, is_saupcd)

uo_1.init_cal(uo_1.id_date_selected)

///*====================================================
//	 WINDOW  datawindow(dw_1) 에 현재일자 retrieve
//=====================================================*/
//string 	retrieve_format
//
//retrieve_format = String( id_date_selected, "yyyymmdd" )
//dw_1.retrieve( is_saup, retrieve_format )

end event

event itemerror;call super::itemerror;return 1
end event

type st_3 from statictext within w_pik1002
boolean visible = false
integer x = 3913
integer y = 2856
integer width = 247
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean enabled = false
boolean focusrectangle = false
end type

type st_status from statictext within w_pik1002
boolean visible = false
integer x = 3077
integer y = 2848
integer width = 681
integer height = 124
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 33027312
boolean enabled = false
boolean focusrectangle = false
end type

