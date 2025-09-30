$PBExportHeader$w_sys_001_mdi_sheet_07.srw
$PBExportComments$User별 프로그램 권한현황
forward
global type w_sys_001_mdi_sheet_07 from window
end type
type st_10 from statictext within w_sys_001_mdi_sheet_07
end type
type dw_datetime from datawindow within w_sys_001_mdi_sheet_07
end type
type sle_msg from singlelineedit within w_sys_001_mdi_sheet_07
end type
type dw_ip from datawindow within w_sys_001_mdi_sheet_07
end type
type ddlb_zoom from dropdownlistbox within w_sys_001_mdi_sheet_07
end type
type pb_1 from picturebutton within w_sys_001_mdi_sheet_07
end type
type pb_3 from picturebutton within w_sys_001_mdi_sheet_07
end type
type pb_2 from picturebutton within w_sys_001_mdi_sheet_07
end type
type pb_4 from picturebutton within w_sys_001_mdi_sheet_07
end type
type st_zoom from statictext within w_sys_001_mdi_sheet_07
end type
type dw_print from datawindow within w_sys_001_mdi_sheet_07
end type
type cb_retrieve from commandbutton within w_sys_001_mdi_sheet_07
end type
type cb_exit from commandbutton within w_sys_001_mdi_sheet_07
end type
type cb_print from commandbutton within w_sys_001_mdi_sheet_07
end type
type gb_3 from groupbox within w_sys_001_mdi_sheet_07
end type
type gb_2 from groupbox within w_sys_001_mdi_sheet_07
end type
type gb_1 from groupbox within w_sys_001_mdi_sheet_07
end type
end forward

global type w_sys_001_mdi_sheet_07 from window
integer width = 3630
integer height = 2168
boolean titlebar = true
string title = "User별 프로그램 권한현황"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
windowstate windowstate = maximized!
long backcolor = 79741120
st_10 st_10
dw_datetime dw_datetime
sle_msg sle_msg
dw_ip dw_ip
ddlb_zoom ddlb_zoom
pb_1 pb_1
pb_3 pb_3
pb_2 pb_2
pb_4 pb_4
st_zoom st_zoom
dw_print dw_print
cb_retrieve cb_retrieve
cb_exit cb_exit
cb_print cb_print
gb_3 gb_3
gb_2 gb_2
gb_1 gb_1
end type
global w_sys_001_mdi_sheet_07 w_sys_001_mdi_sheet_07

type variables
long lvl_row = 0
string lvl_itnbr
string is_gubun
Datastore ds_list1, ds_list2

end variables

event open;dw_print.settransobject(sqlca)

dw_datetime.insertrow(0)
dw_ip.settransobject(sqlca)
dw_ip.insertrow(0)



end event

on w_sys_001_mdi_sheet_07.create
this.st_10=create st_10
this.dw_datetime=create dw_datetime
this.sle_msg=create sle_msg
this.dw_ip=create dw_ip
this.ddlb_zoom=create ddlb_zoom
this.pb_1=create pb_1
this.pb_3=create pb_3
this.pb_2=create pb_2
this.pb_4=create pb_4
this.st_zoom=create st_zoom
this.dw_print=create dw_print
this.cb_retrieve=create cb_retrieve
this.cb_exit=create cb_exit
this.cb_print=create cb_print
this.gb_3=create gb_3
this.gb_2=create gb_2
this.gb_1=create gb_1
this.Control[]={this.st_10,&
this.dw_datetime,&
this.sle_msg,&
this.dw_ip,&
this.ddlb_zoom,&
this.pb_1,&
this.pb_3,&
this.pb_2,&
this.pb_4,&
this.st_zoom,&
this.dw_print,&
this.cb_retrieve,&
this.cb_exit,&
this.cb_print,&
this.gb_3,&
this.gb_2,&
this.gb_1}
end on

on w_sys_001_mdi_sheet_07.destroy
destroy(this.st_10)
destroy(this.dw_datetime)
destroy(this.sle_msg)
destroy(this.dw_ip)
destroy(this.ddlb_zoom)
destroy(this.pb_1)
destroy(this.pb_3)
destroy(this.pb_2)
destroy(this.pb_4)
destroy(this.st_zoom)
destroy(this.dw_print)
destroy(this.cb_retrieve)
destroy(this.cb_exit)
destroy(this.cb_print)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.gb_1)
end on

event key;// Page Up & Page Down & Home & End Key 사용 정의
choose case key
	case keypageup!
		dw_print.scrollpriorpage()
	case keypagedown!
		dw_print.scrollnextpage()
	case keyhome!
		dw_print.scrolltorow(1)
	case keyend!
		dw_print.scrolltorow(dw_print.rowcount())
end choose
end event

type st_10 from statictext within w_sys_001_mdi_sheet_07
integer x = 9
integer y = 1936
integer width = 361
integer height = 84
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 12632256
boolean enabled = false
string text = "메세지"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type dw_datetime from datawindow within w_sys_001_mdi_sheet_07
integer x = 2821
integer y = 1936
integer width = 741
integer height = 84
string dataobject = "d_datetime"
boolean border = false
boolean livescroll = true
end type

type sle_msg from singlelineedit within w_sys_001_mdi_sheet_07
integer x = 375
integer y = 1936
integer width = 2446
integer height = 84
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12632256
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type dw_ip from datawindow within w_sys_001_mdi_sheet_07
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 23
integer y = 60
integer width = 745
integer height = 528
integer taborder = 10
string dataobject = "d_sys_001_mdi_sheet_03_1"
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

event itemchanged;STRING sempno,sempnm,snull,sget_name,sdptno

setnull(snull)

IF this.GetColumnName() ="s_dept" THEN
	
	sdptno = this.GetText()
	
	IF sdptno ="" OR IsNull(sdptno) THEN 
		this.SetItem(1,"s_deptnm",snull)
		RETURN
	END IF
	
  SELECT "P0_DEPT"."DEPTNAME"  
    INTO :sget_name  
    FROM "P0_DEPT"  
   WHERE "P0_DEPT"."DEPTCODE" = :sdptno   ;

	IF SQLCA.SQLCODE = 0 THEN
		this.SetItem(1,"s_deptnm",sget_name)
	ELSE
		this.TriggerEvent(RbuttonDown!)
		IF gs_code ="" OR IsNull(gs_code) THEN 
			this.SetItem(1,"s_dept",snull)
			this.SetItem(1,"s_deptnm",snull)
		END IF
		
		Return 1	
	END IF
ELSEIF this.GetColumnName() ="s_fremp" THEN
	sempno = this.GetText()
	IF sempno ="" OR IsNull(sempno) THEN 
		this.SetItem(1,"s_frnm",snull)
		RETURN
	END IF

  SELECT EMPNAME
    INTO :sget_name  
    FROM "P1_MASTER"  
   WHERE "EMPNO" = :sempno   ;
   
	IF SQLCA.SQLCODE = 0 THEN
		this.SetItem(1,"s_frnm",sget_name)
	ELSE
		this.TriggerEvent(RbuttonDown!)
		
		IF gs_code ="" OR IsNull(gs_code) THEN 
			this.Setitem(1,"s_fremp",snull)
			this.SetItem(1,"s_frnm",snull)
		END IF
		Return 1
	END IF
ELSEIF this.GetColumnName() ="s_frnm" THEN
	sempnm = this.GetText()
	IF sempnm ="" OR IsNull(sempnm) THEN 
		this.SetItem(1,"s_fremp",snull)
		RETURN
	END IF

  SELECT EMPNO
    INTO :sget_name  
    FROM "P1_MASTER"  
   WHERE "EMPNAME" = :sempnm   ;

	IF SQLCA.SQLCODE = 0 THEN
		this.SetItem(1,"s_fremp",sget_name)
	ELSE
		this.TriggerEvent(RbuttonDown!)
		
		IF gs_code ="" OR IsNull(gs_code) THEN 
			this.Setitem(1,"s_fremp",snull)
			this.SetItem(1,"s_frnm",snull)
		END IF
		
		Return 1
	END IF
ELSEIF this.GetColumnName() ="s_toemp" THEN
	sempno = this.GetText()
	IF sempno ="" OR IsNull(sempno) THEN 
		this.SetItem(1,"s_tonm",snull)
		RETURN
	END IF

  SELECT EMPNAME
    INTO :sget_name  
    FROM "P1_MASTER"  
   WHERE "EMPNO" = :sempno   ;

	IF SQLCA.SQLCODE = 0 THEN
		this.SetItem(1,"s_tonm",sget_name)
	ELSE
		this.TriggerEvent(RbuttonDown!)
		
		IF gs_code ="" OR IsNull(gs_code) THEN 
			this.Setitem(1,"s_toemp",snull)
			this.SetItem(1,"s_tonm",snull)
		END IF
		Return 1
	END IF
ELSEIF this.GetColumnName() ="s_tonm" THEN
	sempnm = this.GetText()
	IF sempnm ="" OR IsNull(sempnm) THEN 
		this.SetItem(1,"s_toemp",snull)
		RETURN
	END IF

  SELECT EMPNO
    INTO :sget_name  
    FROM "P1_MASTER"  
   WHERE "EMPNAME" = :sempnm   ;

	IF SQLCA.SQLCODE = 0 THEN
		this.SetItem(1,"s_toemp",sget_name)
	ELSE
		this.TriggerEvent(RbuttonDown!)
		
		IF gs_code ="" OR IsNull(gs_code) THEN 
			this.Setitem(1,"s_toemp",snull)
			this.SetItem(1,"s_tonm",snull)
		END IF
		
		Return 1
	END IF
END IF
end event

event itemerror;return 1
end event

event rbuttondown;setnull(gs_code)
setnull(gs_codename)

IF this.GetColumnName() = "s_dept" THEN
	Open(w_vndmst_4_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then  return

	this.SetItem(1, "s_dept", gs_Code)
	this.SetItem(1, "s_deptnm", gs_Codename)
ELSEIF this.GetColumnName() = "s_fremp" THEN
	Open(w_sawon_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then  return

	this.SetItem(1, "s_fremp", gs_Code)
	this.SetItem(1, "s_frnm", gs_Codename)
ELSEIF this.GetColumnName() = "s_frnm" THEN
		
	gs_codename = this.GetItemString(1,"s_frnm")
	IF IsNull(gs_codename) THEN 
		gs_codename =""
	END IF
	
	Open(w_sawon_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then  return

	this.SetItem(1, "s_fremp", gs_Code)
	this.SetItem(1, "s_frnm", gs_Codename)
ELSEIF this.GetColumnName() = "s_toemp" THEN
	Open(w_sawon_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then  return

	this.SetItem(1, "s_toemp", gs_Code)
	this.SetItem(1, "s_tonm", gs_Codename)
ELSEIF this.GetColumnName() = "s_tonm" THEN
		
	gs_codename = this.GetItemString(1,"s_tonm")
	IF IsNull(gs_codename) THEN 
		gs_codename =""
	END IF
	
	Open(w_sawon_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then  return

	this.SetItem(1, "s_toemp", gs_Code)
	this.SetItem(1, "s_tonm", gs_Codename)
END IF

end event

type ddlb_zoom from dropdownlistbox within w_sys_001_mdi_sheet_07
event modified pbm_cbnmodified
integer x = 384
integer y = 1412
integer width = 265
integer height = 296
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
string text = "100"
boolean allowedit = true
boolean sorted = false
boolean vscrollbar = true
integer limit = 3
string item[] = {"30","50","75","100","120","150","200"}
borderstyle borderstyle = stylelowered!
end type

event modified;string ls_zoom, ls_return

ls_zoom = trim(ddlb_zoom.text)

triggerevent(selectionchanged!)

choose case ls_zoom
	case '30'
		ls_zoom = '30'
	case '50'
		ls_zoom = '50'		
	case '75'
		ls_zoom = '75'
	case '100'
		ls_zoom = '100'
	case '120'
		ls_zoom = '120'
	case '150'
		ls_zoom = '150'
	case '200'
		ls_zoom = '200'
	case '250'
		ls_zoom = '250'
	case '300'
		ls_zoom = '300'
	case '350'
		ls_zoom = '350'
	case '400'
		ls_zoom = '400'
	case else
		if isnumber(ddlb_zoom.text) then
			ls_zoom = ddlb_zoom.text
		else
			messagebox("ZOOM 확인", "배율 범위를 확인하세요.!", information!, OK!)
			return
		end if
end choose

dw_print.modify("Datawindow.print.preview.zoom = '"+ls_zoom+"'")
end event

type pb_1 from picturebutton within w_sys_001_mdi_sheet_07
event clicked pbm_bnclicked
integer x = 128
integer y = 1312
integer width = 101
integer height = 84
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean originalsize = true
string picturename = "first.bmp"
end type

event clicked;dw_print.scrolltorow(1)
end event

type pb_3 from picturebutton within w_sys_001_mdi_sheet_07
event clicked pbm_bnclicked
integer x = 539
integer y = 1312
integer width = 101
integer height = 84
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean originalsize = true
string picturename = "last.bmp"
end type

event clicked;dw_print.scrolltorow(999999999)
end event

type pb_2 from picturebutton within w_sys_001_mdi_sheet_07
event clicked pbm_bnclicked
integer x = 265
integer y = 1312
integer width = 101
integer height = 84
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean originalsize = true
string picturename = "prior1.bmp"
end type

event clicked;dw_print.scrollpriorpage()
end event

type pb_4 from picturebutton within w_sys_001_mdi_sheet_07
event clicked pbm_bnclicked
integer x = 402
integer y = 1312
integer width = 101
integer height = 84
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean originalsize = true
string picturename = "next1.bmp"
end type

event clicked;dw_print.scrollnextpage()
end event

type st_zoom from statictext within w_sys_001_mdi_sheet_07
integer x = 128
integer y = 1412
integer width = 247
integer height = 84
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
string text = "ZOOM"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type dw_print from datawindow within w_sys_001_mdi_sheet_07
event ue_key pbm_dwnkey
integer x = 791
integer y = 16
integer width = 2770
integer height = 1908
string dataobject = "d_sys_001_mdi_sheet_07"
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_key;// Page Up & Page Down & Home & End Key 사용 정의
choose case key
	case keypageup!
		dw_print.scrollpriorpage()
	case keypagedown!
		dw_print.scrollnextpage()
	case keyhome!
		dw_print.scrolltorow(1)
	case keyend!
		dw_print.scrolltorow(dw_print.rowcount())
end choose
end event

type cb_retrieve from commandbutton within w_sys_001_mdi_sheet_07
integer x = 133
integer y = 1584
integer width = 521
integer height = 92
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "조회(&R)"
end type

event clicked;string	sDept, sfremp, stoemp		

if dw_ip.accepttext() = -1 	then	return

setpointer(hourglass!)

sDept = dw_ip.getitemstring(1, 's_dept')
sFrEmp = dw_ip.getitemstring(1, 's_fremp')
sToEmp = dw_ip.getitemstring(1, 's_toemp')

if isnull(sdept) 	or	trim(sdept) = ''		then sDept = '%'

if isnull(sfremp) or	trim(sFremp) = ''		then
   SELECT MIN("P1_MASTER"."EMPNO")  
     INTO :sfremp  
     FROM "P1_MASTER"  ;
end if

if isnull(stoemp) or	trim(stoemp) = ''		then
   SELECT MAX("P1_MASTER"."EMPNO")  
     INTO :stoemp  
     FROM "P1_MASTER"  ;
end if

IF stoemp < sfremp THEN
   MessageBox("확인","사번 범위를 확인하세요!")
	dw_ip.SetColumn('s_fremp')
	dw_ip.SetFocus()
	Return
End If
	
//////////////////////////////////////////////////////////////////////////////
if dw_print.Retrieve(sdept, sfremp, stoemp) = 0 then
   MessageBox("확인","출력자료가 없습니다!")
	dw_ip.SetColumn('s_dept')
	dw_ip.SetFocus()
	cb_print.Enabled =False
	SetPointer(Arrow!)
	Return
END IF

cb_print.Enabled =True

/* Last page 구하는 routine */
long Li_row = 1, Ll_prev_row

dw_print.setredraw(false)
dw_print.object.datawindow.print.preview="yes"

gi_page = 1

do while true
	ll_prev_row = Li_row
	Li_row = dw_print.ScrollNextPage()
	If Li_row = ll_prev_row or Li_row <= 0 then
		exit
	Else
		gi_page++
	End if
loop

dw_print.scrolltorow(1)
dw_print.setredraw(true)
setpointer(arrow!)
end event

type cb_exit from commandbutton within w_sys_001_mdi_sheet_07
integer x = 133
integer y = 1792
integer width = 521
integer height = 92
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "종료(&X)"
end type

on clicked;CLOSE(PARENT)
end on

type cb_print from commandbutton within w_sys_001_mdi_sheet_07
integer x = 133
integer y = 1688
integer width = 521
integer height = 92
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "출력(&P)"
end type

event clicked;OpenWithParm(w_print_options, dw_print)
end event

type gb_3 from groupbox within w_sys_001_mdi_sheet_07
integer x = 9
integer y = 1248
integer width = 773
integer height = 280
integer textsize = -8
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 12632256
borderstyle borderstyle = stylelowered!
end type

type gb_2 from groupbox within w_sys_001_mdi_sheet_07
integer x = 9
integer y = 1520
integer width = 773
integer height = 400
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 12632256
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_sys_001_mdi_sheet_07
boolean visible = false
integer x = 14
integer width = 773
integer height = 1336
integer textsize = -3
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
borderstyle borderstyle = stylelowered!
end type

