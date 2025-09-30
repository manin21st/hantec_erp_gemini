$PBExportHeader$w_imt_05080.srw
$PBExportComments$거래처별 품목별 발주현황
forward
global type w_imt_05080 from w_standard_print
end type
type shl_1 from statichyperlink within w_imt_05080
end type
type shl_2 from statichyperlink within w_imt_05080
end type
type st_1 from statictext within w_imt_05080
end type
type st_2 from statictext within w_imt_05080
end type
type pb_1 from u_pb_cal within w_imt_05080
end type
type pb_2 from u_pb_cal within w_imt_05080
end type
type rr_1 from roundrectangle within w_imt_05080
end type
end forward

global type w_imt_05080 from w_standard_print
string title = "거래처별 품목별 발주현황"
string menuname = ""
shl_1 shl_1
shl_2 shl_2
st_1 st_1
st_2 st_2
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_imt_05080 w_imt_05080

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();IF dw_ip.AcceptText() = -1 THEN Return -1

String	ls_bscdate, ls_bscdate1, ls_cvcod, ls_from , ls_to, ls_saupj, ls_balgu

ls_bscdate = dw_ip.GetItemString(1, 'bscdate')
ls_bscdate1 = dw_ip.GetItemString(1, 'bscdate1')
ls_cvcod   = dw_ip.GetItemString(1, 'cvcod')
ls_saupj   = dw_ip.GetItemString(1, 'saupj')
ls_balgu   = dw_ip.GetItemString(1, 'balgu')

IF ls_bscdate = '' OR IsNull(ls_bscdate) THEN
	f_message_chk(30, '[기준일자 From]')
	dw_ip.SetFocus()
	Return -1
END IF

IF ls_bscdate1 = '' OR IsNull(ls_bscdate1) THEN
	f_message_chk(30, '[기준일자 To]')
	dw_ip.SetFocus()
	Return -1
END IF

IF ls_cvcod = '' OR IsNull(ls_cvcod) THEN
	f_message_chk(30, '[거래처]')
	dw_ip.SetFocus()
	Return -1
END IF
//f_weekly(ls_bscdate, '1','7',ls_from, ls_to)

IF ls_saupj = '' OR IsNull(ls_saupj) THEN ls_saupj ='%'
	
IF ls_balgu = '' OR IsNull(ls_balgu) THEN ls_balgu ='%'

IF dw_list.Retrieve(ls_bscdate, ls_bscdate1, ls_cvcod, ls_saupj, ls_balgu ) <= 0 THEN
	f_message_chk(50, '[]')
	Return -1
END IF


Return 1
end function

on w_imt_05080.create
int iCurrent
call super::create
this.shl_1=create shl_1
this.shl_2=create shl_2
this.st_1=create st_1
this.st_2=create st_2
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.shl_1
this.Control[iCurrent+2]=this.shl_2
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.pb_1
this.Control[iCurrent+6]=this.pb_2
this.Control[iCurrent+7]=this.rr_1
end on

on w_imt_05080.destroy
call super::destroy
destroy(this.shl_1)
destroy(this.shl_2)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.insertRow(0)

dw_ip.SetItem(1, 'bscdate', gs_codename)
dw_ip.SetItem(1, 'bscdate1', gs_codename2)
dw_ip.SetItem(1,'cvcod', gs_gubun)
dw_ip.SetItem(1,'cvnas', gs_code)

String ls_balgu

ls_balgu = Message.StringParm	
If ls_balgu <> '%' and Not(IsNull(ls_balgu)) Then
	dw_ip.SetItem(1,'balgu', ls_balgu)
End If

f_mod_saupj(dw_ip, 'saupj')
//
SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)
wf_retrieve()
end event

type p_preview from w_standard_print`p_preview within w_imt_05080
boolean visible = false
integer x = 2843
integer y = 12
end type

type p_exit from w_standard_print`p_exit within w_imt_05080
end type

type p_print from w_standard_print`p_print within w_imt_05080
boolean visible = false
integer x = 3017
integer y = 12
end type

type p_retrieve from w_standard_print`p_retrieve within w_imt_05080
integer x = 4265
end type







type st_10 from w_standard_print`st_10 within w_imt_05080
end type



type dw_print from w_standard_print`dw_print within w_imt_05080
integer x = 3255
string dataobject = "d_imt_05080_1"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_05080
integer y = 96
integer width = 4114
integer height = 152
string dataobject = "d_imt_05080"
end type

event dw_ip::itemchanged;call super::itemchanged;String sCvcod, sNull, sCvnas, sArea, sTeam, sSaupj, sName1

Choose Case getColumnName()
	Case "cvcod"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"cvcod",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'cvnas', snull)
			Return 1
		ELSE		
			SetItem(1,"cvnas", scvnas)
		END IF
	/* 거래처명 */
	Case "cvnas"
		scvnas = Trim(GetText())
		IF scvnas ="" OR IsNull(scvnas) THEN
			SetItem(1,"cvcod",snull)
			Return
		END IF
		
		If f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'cvnas', snull)
			Return 1
		ELSE		
			SetItem(1,'cvcod', sCvcod)
			SetItem(1,"cvnas", scvnas)

			Return 1
		END IF
END CHOOSE
end event

event dw_ip::rbuttondown;call super::rbuttondown;string sIocvnas, sIoCustArea,	sDept,sIoGbn,sNull

SetNull(sNull)
SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case this.GetColumnName() 
	Case "cvcod", "cvnas"
		gs_gubun = '1'
		If GetColumnName() = "cvnas" then
			gs_codename = Trim(GetText())
		End If
		Open(w_vndmst_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		SetColumn("cvcod")
		TriggerEvent(ItemChanged!)

// Case "cvcod","cvnas"
//	sIoGbn = Trim(this.GetItemString(1,'iogbn'))
//
//	If sIogbn = 'Y' Then
//	  gs_gubun = '1'
//		If GetColumnName() = "cvnas" then
//			gs_codename = Trim(GetText())
//		End If
//	  Open(w_agent_popup)
//	
//	  IF gs_code ="" OR IsNull(gs_code) THEN RETURN
//	
//	  this.SetItem(1,"cvcod",gs_code)
//	
//	  SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
//	    INTO :sIocvnas,		:sIoCustArea,			:sDept
//	    FROM "VNDMST","SAREA" 
//     WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
//		
//	  IF SQLCA.SQLCODE = 0 THEN
//	    this.SetItem(1,"deptcode",  sDept)
//	    this.SetItem(1,"cvnas",  sIocvnas)
//	    this.SetItem(1,"areacode",  sIoCustArea)
//	  END IF
//	Else
//	  Open(w_dept_popup)
//	  IF gs_code ="" OR IsNull(gs_code) THEN RETURN
//	
//  	  this.SetItem(1,"cvcod",  gs_code)
//	  this.SetItem(1,"cvnas",  gs_codeName)
//	  this.SetItem(1,"deptcode",  sNull)
//	  this.SetItem(1,"areacode",  sNull)
//	End If
END Choose

end event

type dw_list from w_standard_print`dw_list within w_imt_05080
event ue_mousemove pbm_mousemove
integer x = 46
integer y = 268
integer width = 4549
integer height = 2040
string dataobject = "d_imt_05080_1"
boolean border = false
end type

event dw_list::ue_mousemove;//String ls_Object
//Long	 ll_Row
//
//IF this.Rowcount() < 1 then return 
//
//ls_Object = Lower(This.GetObjectAtPointer())
//
//IF mid(ls_Object, 1, 11)  = 'itnct_titnm' THEN 
//   ll_Row = long(mid(ls_Object, 12, 5))
//	this.setrow(ll_row)
//	this.setitem(ll_row, 'opt', '1')
//ELSE
//	this.setitem(this.getrow(), 'opt', '0')
//END IF
//
//
end event

event dw_list::clicked;call super::clicked;//String  ls_Object, ls_Sort
//Long	  ll_Row
//
//IF this.Rowcount() < 1 then return 
//
//ls_Object = Lower(This.GetObjectAtPointer())
//
//IF mid(ls_Object, 1, 11)  = 'itnct_titnm' THEN 
//   ll_Row = long(mid(ls_Object, 12, 3))
//	if ll_Row < 1 or isnull(ll_Row) then return 
//
//	gs_gubun = dw_ip.GetItemString(1, 'yymm')
//	gs_code  = dw_ip.GetItemString(1, 'cvcod')
//  	gs_codename = This.GetItemString(ll_row, 'itnct_itcls')
//   gs_codename2 = This.GetItemString(ll_row, 'itemas_ittyp')
//	OpenSheet(w_imt_05050, w_mdi_frame, 0, Layered!)
//
//END IF
//
end event

type shl_1 from statichyperlink within w_imt_05080
integer x = 69
integer y = 36
integer width = 251
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 16711680
long backcolor = 32106727
string text = "기준일자"
alignment alignment = center!
end type

event clicked;Boolean				lb_isopen
Window				lw_window

lb_isopen = FALSE
lw_window = parent.GetFirstSheet()
DO WHILE IsValid(lw_window)
	if ClassName(lw_window) = 'w_imt_05070' then
		lb_isopen = TRUE
		Exit
	else		
		lw_window = parent.GetNextSheet(lw_window)
	end if
LOOP
if lb_isopen then
	lw_window.windowstate = Normal!
	lw_window.SetFocus()
else	
	OpenSheet(w_imt_05070, w_mdi_frame, 0, Layered!)	
end if

close(Parent)
end event

type shl_2 from statichyperlink within w_imt_05080
integer x = 457
integer y = 36
integer width = 640
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string pointer = "HyperLink!"
long textcolor = 16711680
long backcolor = 32106727
boolean enabled = false
string text = "거래처별 품목대분류별"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_imt_05080
integer x = 320
integer y = 36
integer width = 114
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = ">>"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_imt_05080
integer x = 4251
integer y = 200
integer width = 334
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 31778020
string text = "(단위:천원)"
boolean focusrectangle = false
end type

type pb_1 from u_pb_cal within w_imt_05080
integer x = 1513
integer y = 108
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('bscdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'bscdate', gs_code)



end event

type pb_2 from u_pb_cal within w_imt_05080
integer x = 1989
integer y = 108
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('bscdate1')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'bscdate1', gs_code)



end event

type rr_1 from roundrectangle within w_imt_05080
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 260
integer width = 4576
integer height = 2056
integer cornerheight = 40
integer cornerwidth = 55
end type

