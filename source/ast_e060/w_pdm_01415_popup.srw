$PBExportHeader$w_pdm_01415_popup.srw
$PBExportComments$** 일별 조 인원조정(생산근태 일괄조정)
forward
global type w_pdm_01415_popup from window
end type
type pb_2 from u_pb_cal within w_pdm_01415_popup
end type
type pb_1 from u_pb_cal within w_pdm_01415_popup
end type
type p_search from uo_picture within w_pdm_01415_popup
end type
type p_exit from uo_picture within w_pdm_01415_popup
end type
type st_1 from statictext within w_pdm_01415_popup
end type
type dw_1 from datawindow within w_pdm_01415_popup
end type
end forward

global type w_pdm_01415_popup from window
integer x = 823
integer y = 360
integer width = 1413
integer height = 800
boolean titlebar = true
string title = "일변 근태 일괄조정"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
pb_2 pb_2
pb_1 pb_1
p_search p_search
p_exit p_exit
st_1 st_1
dw_1 dw_1
end type
global w_pdm_01415_popup w_pdm_01415_popup

on w_pdm_01415_popup.create
this.pb_2=create pb_2
this.pb_1=create pb_1
this.p_search=create p_search
this.p_exit=create p_exit
this.st_1=create st_1
this.dw_1=create dw_1
this.Control[]={this.pb_2,&
this.pb_1,&
this.p_search,&
this.p_exit,&
this.st_1,&
this.dw_1}
end on

on w_pdm_01415_popup.destroy
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.p_search)
destroy(this.p_exit)
destroy(this.st_1)
destroy(this.dw_1)
end on

event open;f_window_center_response(this)

dw_1.settransobject(sqlca)
dw_1.insertrow(0)
dw_1.setfocus()
end event

type pb_2 from u_pb_cal within w_pdm_01415_popup
integer x = 1248
integer y = 280
integer taborder = 20
end type

event clicked;call super::clicked;dw_1.SetColumn('tdate')
IF Isnull(gs_code) THEN Return
dw_1.SetItem(dw_1.getrow(), 'tdate', gs_code)
end event

type pb_1 from u_pb_cal within w_pdm_01415_popup
integer x = 805
integer y = 280
integer taborder = 20
end type

event clicked;call super::clicked;dw_1.SetColumn('fdate')
IF Isnull(gs_code) THEN Return
dw_1.SetItem(dw_1.getrow(), 'fdate', gs_code)
end event

type p_search from uo_picture within w_pdm_01415_popup
integer x = 891
integer y = 20
integer width = 306
integer taborder = 90
string picturename = "C:\erpman\image\생산근태일괄생성_up.gif"
end type

event clicked;call super::clicked;String 	sFdate, stdate, sEmpno, sdptno
long  	lReturn 

IF dw_1.accepttext() = -1 THEN RETURN 

SetPointer(HourGlass!)

sfdate 	= TRIM(dw_1.getitemstring(1, "fdate"))
stdate 	= TRIM(dw_1.getitemstring(1, "tdate"))
sEmpno	= dw_1.getitemstring(1, "empno")
//sdptno	= dw_1.getitemstring(1, "dptno")

IF isnull(sfdate) or trim(sfdate) = '' then 
	f_message_chk(30, "[근태일자 FROM]")
	dw_1.SetColumn("fdate")
	dw_1.SetFocus()
	RETURN
END IF
IF isnull(stdate) or trim(stdate) = '' then 
	f_message_chk(30, "[근태일자 TO]")
	dw_1.SetColumn("tdate")
	dw_1.SetFocus()
	RETURN
END IF

//if isnull(sdptno) or trim(sdptno) = '' then sdptno = '%'
if isnull(sempno) or trim(sempno) = '' then sempno = '%'

St_1.text = '생산근태 일괄처리 중 입니다...!!'

lreturn = sqlca.sp_calc_kentaetime_interface(sfdate,stdate,sempno);

If lReturn  < 1 then
	rollback ;
	f_message_chk(41, '[생산근태 생성] '+ string(lreturn)) 
	Return 
Else
	commit ;
	Messagebox("생산근태", "생산근태 일괄 처리 되었읍니다", information!)
end if

st_1.text = ''
gs_code = 'Y' 

close(parent)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\생산근태일괄생성_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\생산근태일괄생성_up.gif"
end event

type p_exit from uo_picture within w_pdm_01415_popup
integer x = 1193
integer y = 24
integer width = 178
integer taborder = 80
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;setnull(gs_code)

close(parent)
end event

type st_1 from statictext within w_pdm_01415_popup
integer x = 46
integer y = 608
integer width = 1307
integer height = 80
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_pdm_01415_popup
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 46
integer y = 204
integer width = 1321
integer height = 372
integer taborder = 10
string dataobject = "d_pdm_01415_popup"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1

end event

event rbuttondown;SetNull(Gs_code)
SetNull(Gs_codename)

IF this.getcolumnname() = "empno"	THEN		
	open(w_sawon_popup)
	IF isnull(gs_Code)  or  gs_Code = ''	then  return
	this.SetItem(1, "empno", gs_code)
	this.SetItem(1, "empnm", gs_codename)
END IF
end event

event itemchanged;String s_dptno, s_name, s_name2, s_date, snull
int    ireturn

setnull(snull)

if this.GetColumnName() = "empno" then
	s_dptno = this.gettext()
 
   ireturn = f_get_name2('사번', 'Y', s_dptno, s_name, s_name2)
	this.SetItem(Row, "empno", s_dptno)
	this.SetItem(Row, "empnm", s_name)
  	return ireturn 
elseif this.GetColumnName() ="fdate" THEN
	s_date = trim(this.GetText())
	
	if s_date = "" or isnull(s_date) then return 

  	IF f_datechk(s_date) = -1	then
      f_message_chk(35, '[근태일자]')
		this.setitem(1, "fdate", snull)
		return 1
	END IF
elseif this.GetColumnName() ="tdate" THEN
	s_date = trim(this.GetText())
	
	if s_date = "" or isnull(s_date) then return 

  	IF f_datechk(s_date) = -1	then
      f_message_chk(35, '[근태일자]')
		this.setitem(1, "tdate", snull)
		return 1
	END IF
END IF
end event

event itemerror;return 1
end event

