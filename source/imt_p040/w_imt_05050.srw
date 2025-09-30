$PBExportHeader$w_imt_05050.srw
$PBExportComments$년간 구매계획 대 실적[거래처별 품목중분류]
forward
global type w_imt_05050 from w_standard_print
end type
type shl_1 from statichyperlink within w_imt_05050
end type
type st_1 from statictext within w_imt_05050
end type
type shl_3 from statichyperlink within w_imt_05050
end type
type st_2 from statictext within w_imt_05050
end type
type shl_4 from statichyperlink within w_imt_05050
end type
type st_21 from statictext within w_imt_05050
end type
type rr_1 from roundrectangle within w_imt_05050
end type
end forward

global type w_imt_05050 from w_standard_print
string title = "년간 구매계획 대 실적[거래처별 품목중분류]"
string menuname = ""
shl_1 shl_1
st_1 st_1
shl_3 shl_3
st_2 st_2
shl_4 shl_4
st_21 st_21
rr_1 rr_1
end type
global w_imt_05050 w_imt_05050

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();IF dw_ip.AcceptText() = -1 THEN Return -1

String	ls_yymm, ls_cvcod, ls_itcls, ls_saupj, ls_iogbn

ls_yymm  = dw_ip.GetItemString(1, 'yymm')
ls_cvcod = dw_ip.GetItemString(1, 'cvcod')
ls_itcls = dw_ip.GetItemString(1, 'itcls')
ls_saupj = dw_ip.GetItemString(1, 'saupj')

IF ls_yymm = '' OR IsNull(ls_yymm) THEN
	f_message_chk(30, '[기준년월]')
	dw_ip.SetFocus()
	Return -1
END IF

IF ls_cvcod = '' OR IsNull(ls_cvcod) THEN
	f_message_chk(30, '[거래처]')
	dw_ip.SetFocus()
	Return -1
END IF

IF ls_saupj = '' OR IsNull(ls_saupj) THEN
	ls_saupj ='%'
END IF

ls_iogbn = dw_ip.GetItemString(1, 'iogbn')
IF ls_iogbn = '' OR IsNull(ls_iogbn) THEN ls_iogbn = '%'

// head 처리
dw_list.object.m_11.text = RIGHT(f_aftermonth(ls_yymm, -11),2) +'월'
dw_list.object.m_10.text = RIGHT(f_aftermonth(ls_yymm, -10),2) +'월'
dw_list.object.m_9.text  = RIGHT(f_aftermonth(ls_yymm, -9),2)  +'월' 
dw_list.object.m_8.text  = RIGHT(f_aftermonth(ls_yymm, -8),2) +'월' 
dw_list.object.m_7.text  = RIGHT(f_aftermonth(ls_yymm, -7),2) +'월' 
dw_list.object.m_6.text  = RIGHT(f_aftermonth(ls_yymm, -6),2) +'월'  
dw_list.object.m_5.text  = RIGHT(f_aftermonth(ls_yymm, -5),2) +'월' 
dw_list.object.m_4.text  = RIGHT(f_aftermonth(ls_yymm, -4),2) +'월' 
dw_list.object.m_3.text  = RIGHT(f_aftermonth(ls_yymm, -3),2) +'월' 
dw_list.object.m_2.text  = RIGHT(f_aftermonth(ls_yymm, -2),2) +'월' 
dw_list.object.m_1.text  = RIGHT(f_aftermonth(ls_yymm, -1),2) +'월' 
dw_list.object.m.text    = RIGHT(ls_yymm,2) +'월' 

IF dw_list.Retrieve(ls_yymm, ls_cvcod, gs_codename2, ls_itcls, ls_saupj, ls_iogbn) <= 0 THEN
	f_message_chk(50, '[]')
	Return -1
END IF

Return 1
end function

on w_imt_05050.create
int iCurrent
call super::create
this.shl_1=create shl_1
this.st_1=create st_1
this.shl_3=create shl_3
this.st_2=create st_2
this.shl_4=create shl_4
this.st_21=create st_21
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.shl_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.shl_3
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.shl_4
this.Control[iCurrent+6]=this.st_21
this.Control[iCurrent+7]=this.rr_1
end on

on w_imt_05050.destroy
call super::destroy
destroy(this.shl_1)
destroy(this.st_1)
destroy(this.shl_3)
destroy(this.st_2)
destroy(this.shl_4)
destroy(this.st_21)
destroy(this.rr_1)
end on

event open;call super::open;String sCvnas

dw_ip.insertRow(0)

dw_ip.SetItem(1, 'yymm', gs_gubun)
dw_ip.SetItem(1,'cvcod', gs_code)

select cvnas2
Into  :sCvnas
from   vndmst
where  cvcod = :gs_code;

dw_ip.SetItem(1,'cvnas', sCvnas)
dw_ip.SetItem(1,'itcls', gs_codename)

f_mod_saupj(dw_ip, 'saupj')
//
SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

String ls_iogbn
ls_iogbn = Message.StringParm	
If ls_iogbn <> '%' and Not(IsNull(ls_iogbn)) Then
	dw_ip.SetItem(1,'iogbn', ls_iogbn)
End If

wf_retrieve()
end event

type p_preview from w_standard_print`p_preview within w_imt_05050
boolean visible = false
integer x = 2843
integer y = 12
end type

type p_exit from w_standard_print`p_exit within w_imt_05050
end type

type p_print from w_standard_print`p_print within w_imt_05050
boolean visible = false
integer x = 3017
integer y = 12
end type

type p_retrieve from w_standard_print`p_retrieve within w_imt_05050
integer x = 4265
end type







type st_10 from w_standard_print`st_10 within w_imt_05050
end type



type dw_print from w_standard_print`dw_print within w_imt_05050
integer x = 3255
string dataobject = "d_imt_05050_1"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_05050
integer y = 96
integer width = 2930
integer height = 228
string dataobject = "d_imt_05050"
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

type dw_list from w_standard_print`dw_list within w_imt_05050
event ue_mousemove pbm_mousemove
integer x = 46
integer y = 352
integer width = 4549
integer height = 1976
string dataobject = "d_imt_05050_1"
boolean border = false
end type

event dw_list::ue_mousemove;String ls_Object
Long	 ll_Row

IF this.Rowcount() < 1 then return 

ls_Object = Lower(This.GetObjectAtPointer())

IF mid(ls_Object, 1, 11)  = 'itnct_titnm' THEN 
   ll_Row = long(mid(ls_Object, 12, 5))
	this.setrow(ll_row)
	this.setitem(ll_row, 'opt', '1')
ELSE
	this.setitem(this.getrow(), 'opt', '0')
END IF


end event

event dw_list::clicked;call super::clicked;String  ls_Object, ls_Sort, ls_itcls
Long	  ll_Row

IF this.Rowcount() < 1 then return 

ls_Object = Lower(This.GetObjectAtPointer())

IF mid(ls_Object, 1, 11)  = 'itnct_titnm' THEN 
   ll_Row = long(mid(ls_Object, 12, 3))
	if ll_Row < 1 or isnull(ll_Row) then return 

	gs_gubun = dw_ip.GetItemString(1, 'yymm')
	gs_code  = dw_ip.GetItemString(1, 'cvcod')
	ls_itcls = dw_ip.GetItemString(1, 'itcls')
  	gs_codename = This.GetItemString(ll_row, 'itnct_itcls')
   gs_codename2 = This.GetItemString(ll_row, 'itemas_ittyp')
	OpenSheet(w_imt_05060, w_mdi_frame, 0, Layered!)

END IF


end event

type shl_1 from statichyperlink within w_imt_05050
integer x = 69
integer y = 36
integer width = 192
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
string text = "년월별"
alignment alignment = center!
end type

event clicked;Boolean				lb_isopen
Window				lw_window

lb_isopen = FALSE
lw_window = parent.GetFirstSheet()
DO WHILE IsValid(lw_window)
	if ClassName(lw_window) = 'w_imt_05010' then
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
	OpenSheet(w_imt_05010, w_mdi_frame, 0, Layered!)	
end if

close(Parent)
close(w_imt_05040)
end event

type st_1 from statictext within w_imt_05050
integer x = 283
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

type shl_3 from statichyperlink within w_imt_05050
integer x = 1221
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
string text = "거래처별 품목중분류별"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_imt_05050
integer x = 1083
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

type shl_4 from statichyperlink within w_imt_05050
integer x = 416
integer y = 36
integer width = 640
integer height = 48
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
string text = "거래처별 품목대분류별"
alignment alignment = center!
boolean focusrectangle = false
end type

event clicked;Boolean				lb_isopen
Window				lw_window

lb_isopen = FALSE
lw_window = parent.GetFirstSheet()
DO WHILE IsValid(lw_window)
	if ClassName(lw_window) = 'w_imt_05040' then
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
	OpenSheet(w_imt_05040, w_mdi_frame, 0, Layered!)	
end if

close(Parent)
end event

type st_21 from statictext within w_imt_05050
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

type rr_1 from roundrectangle within w_imt_05050
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 344
integer width = 4576
integer height = 1992
integer cornerheight = 40
integer cornerwidth = 55
end type

