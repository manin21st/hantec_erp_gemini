$PBExportHeader$w_sal_02680.srw
$PBExportComments$ ** 거래처별 제품단가 현황
forward
global type w_sal_02680 from w_standard_print
end type
type dw_1 from dw_list within w_sal_02680
end type
type rb_1 from radiobutton within w_sal_02680
end type
type rb_2 from radiobutton within w_sal_02680
end type
type gb_1 from groupbox within w_sal_02680
end type
type rr_3 from roundrectangle within w_sal_02680
end type
end forward

global type w_sal_02680 from w_standard_print
string title = "거래처 제품단가 현황"
dw_1 dw_1
rb_1 rb_1
rb_2 rb_2
gb_1 gb_1
rr_3 rr_3
end type
global w_sal_02680 w_sal_02680

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string s_sarea, s_cvcod, s_saupj, ls_itnbr
string tx_name

If dw_ip.accepttext() <> 1 Then Return -1

s_saupj  = gs_saupj
s_sarea  = dw_ip.getitemstring(1,"areacode")
s_cvcod  = dw_ip.getitemstring(1,"custcode")
ls_itnbr = dw_ip.getitemstring(1,"itnbr")

If IsNull(s_cvcod) then s_cvcod = ''

if IsNull(s_sarea) Then s_sarea = '' 

if IsNull(ls_itnbr) Then ls_itnbr = '%' 

//// <조회> ///////////////////////////////////////////////////////////////////////////////////////////
IF dw_print.retrieve(s_saupj, s_sarea+'%', s_cvcod+'%',ls_itnbr) <= 0 THEN
  f_message_chk(50,'[거래처별 제품단가 현황]')
	dw_ip.setfocus()
	SetPointer(Arrow!)
	Return -1
else
	dw_print.sharedata(dw_list)
END IF

return 1
end function

on w_sal_02680.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_1=create gb_1
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.gb_1
this.Control[iCurrent+5]=this.rr_3
end on

on w_sal_02680.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_1)
destroy(this.rr_3)
end on

event open;call super::open;dw_ip.setfocus()

DataWindowChild state_child
integer rtncode

//관할 구역
rtncode 	= dw_ip.GetChild('areacode', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 관할구역")
state_child.SetTransObject(SQLCA)
state_child.Retrieve('%')

/* User별 관할구역 Setting */
String sarea, steam , saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
   dw_ip.Modify("areacode.protect=1")
	dw_ip.Modify("areacode.background.color = 80859087")
End If
dw_ip.SetItem(1, 'areacode', sarea)

///* 출고창고 & 관할구역 Filtering */
//DataWindowChild state_child1, state_child2
//integer rtncode1, rtncode2
//
//IF gs_saupj    = '10' THEN
//	rtncode1    = dw_ip.GetChild('areacode', state_child1)
//	IF rtncode1 = -1 THEN MessageBox("Error1", "Not a DataWindowChild")
//	state_child1.setFilter("sarea < '03' ")
//	state_child1.Filter()
//	
//ELSEIF gs_saupj= '11' THEN
//   rtncode1    = dw_ip.GetChild('areacode', state_child1)
//	IF rtncode1 = -1 THEN MessageBox("Error1", "Not a DataWindowChild")
//	state_child1.setFilter("sarea > '02' ")
//	state_child1.Filter()
//END IF
end event

type p_preview from w_standard_print`p_preview within w_sal_02680
integer x = 4069
end type

type p_exit from w_standard_print`p_exit within w_sal_02680
integer x = 4416
end type

type p_print from w_standard_print`p_print within w_sal_02680
integer x = 4242
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_02680
integer x = 3895
boolean originalsize = true
end type







type st_10 from w_standard_print`st_10 within w_sal_02680
end type



type dw_print from w_standard_print`dw_print within w_sal_02680
integer x = 3182
integer y = 12
string dataobject = "d_sal_02680_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_02680
integer x = 46
integer y = 28
integer width = 3374
integer height = 156
string dataobject = "d_sal_02680_01"
end type

event dw_ip::itemchanged;String  sIoCust,sIoCustArea,sIoCustName,sDept,snull,sIoJpno,sIoconfirm,sIoDate,sInsDat , sCvcod, scvnas, sarea, steam, sSaupj, sName1, ls_itnbr

SetNull(snull)

Choose Case GetColumnName() 
/* 관할구역 */
 Case "areacode"
	SetItem(1,"custcode",sNull)
	SetItem(1,"custname",sNull)

	sIoCustArea = this.GetText()
	IF sIoCustArea = "" OR IsNull(sIoCustArea) THEN RETURN
	
	SELECT "SAREA"."SAREA" ,"SAREA"."STEAMCD" 	INTO :sIoCustArea  ,:sDept
		FROM "SAREA"  
		WHERE "SAREA"."SAREA" = :sIoCustArea   ;
 /* 거래처 */
	Case "custcode"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"custname",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'custcode', sNull)
			SetItem(1, 'custname', snull)
			Return 1
		ELSE		
			SetItem(1,"custname", scvnas)
			SetItem(1,"areacode",   sarea)
		END IF
	/* 거래처명 */
	Case "custname"
		scvnas = Trim(GetText())
		IF scvnas ="" OR IsNull(scvnas) THEN
			SetItem(1,"custcode",snull)
			Return
		END IF
		
		If f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'custcode', sNull)
			SetItem(1, 'custname', snull)
			Return 1
		ELSE		
			SetItem(1,'custcode', sCvcod)
			SetItem(1,"custname", scvnas)
			SetItem(1,"areacode",   sarea)
			Return 1
		END IF
Case 'itnbr'
	scvnas = trim(this.GetText())
	IF scvnas = '' or	IsNull(scvnas)	THEN
		RETURN 
	END IF
	
	SELECT "ITEMAS"."ITNBR"
	  INTO :ls_itnbr
	  FROM "ITEMAS"  ,"ITNCT"
	 WHERE "ITEMAS"."ITTYP" = "ITNCT"."ITTYP" AND
	       "ITEMAS"."ITCLS" = "ITNCT"."ITCLS" AND
	       "ITEMAS"."ITNBR" = :scvnas ;
	
	IF sqlca.sqlcode <> 0 THEN
		f_message_chk(33, "[품번]" )
		this.setitem(1, "itnbr", snull)
//		this.setitem(1, "itdsc", snull)
//		this.setitem(1, "ispec", snull)
		RETURN 1
	ELSE
//		this.setitem(1, "itdsc", get_nm)
//		this.setitem(1, "ittyp", sIttyp)
//		this.setitem(1, "itcls", sItcls)
//		this.setitem(1, "itclsnm", sItclsnm)
//		this.setitem(1, "ispec", sIspec)
	END IF
END Choose

end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;string sIoCustName,sIoCustArea,sDept,siojpno,siocust,sIoDate,sInsDat
Long nRow

SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case this.GetColumnName() 
	Case "custcode", "custname"
		gs_gubun = '1'
		If GetColumnName() = "custname" then
			gs_codename = Trim(GetText())
		End If
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"custcode",gs_code)
		SetColumn("custcode")
		TriggerEvent(ItemChanged!)
//Case "custcode"
//	gs_gubun = '1'
//	Open(w_agent_popup)
//	
//	IF gs_code ="" OR IsNull(gs_code) THEN RETURN
//	
//	this.SetItem(1,"custcode",gs_code)
//	
//	SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
//		INTO :sIoCustName,		:sIoCustArea,			:sDept
//	   FROM "VNDMST","SAREA" 
//   	WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
//	IF SQLCA.SQLCODE = 0 THEN
//	  this.SetItem(1,"custname",  sIoCustName)
//	  this.SetItem(1,"areacode",  sIoCustArea)
//	END IFz
//Case "custname"
//	gs_codename = Trim(GetText())
//	gs_gubun = '1'
//	Open(w_agent_popup)
//	
//	IF gs_code ="" OR IsNull(gs_code) THEN RETURN
//	
//	this.SetItem(1,"custcode",gs_code)
//	
//	SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
//		INTO :sIoCustName,		:sIoCustArea,			:sDept
//	   FROM "VNDMST","SAREA" 
//   	WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
//	IF SQLCA.SQLCODE = 0 THEN
//	  this.SetItem(1,"custname",  sIoCustName)
//	  this.SetItem(1,"areacode",  sIoCustArea)
//	END IF
END Choose

If this.GetColumnName() = 'itnbr' then
	Gs_gubun = Trim(GetItemString(GetRow(),'ittyp'))
	If Gs_gubun = '' Or IsNull(Gs_gubun) Then Gs_gubun = '1'
	open(w_itemas_popup)
   
	if gs_code = "" or isnull(gs_code) then return 
		
	this.setitem(1, 'itnbr', gs_code)
   TriggerEvent(ItemChanged!)
End If

end event

type dw_list from w_standard_print`dw_list within w_sal_02680
integer x = 73
integer y = 216
integer width = 4494
integer height = 2072
string dataobject = "d_sal_02680"
boolean border = false
boolean hsplitscroll = false
end type

type dw_1 from dw_list within w_sal_02680
integer x = 41
integer y = 2588
integer width = 4590
integer height = 2272
integer taborder = 10
boolean bringtotop = true
boolean hscrollbar = false
boolean vscrollbar = false
boolean border = true
boolean livescroll = false
end type

type rb_1 from radiobutton within w_sal_02680
integer x = 3461
integer y = 48
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "전체"
boolean checked = true
end type

event clicked;dw_list.setFilter('')
dw_list.Filter()
end event

type rb_2 from radiobutton within w_sal_02680
integer x = 3461
integer y = 116
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "현재일 기준"
end type

event clicked;String ls_filterstr

ls_filterstr = "vnddan_start_date <= '" + gs_today  + "' and  vnddan_end_date >= '" + gs_today + "'"

dw_list.setFilter(ls_filterstr)
dw_list.Filter()
end event

type gb_1 from groupbox within w_sal_02680
integer x = 3419
integer width = 471
integer height = 184
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "Filter"
end type

type rr_3 from roundrectangle within w_sal_02680
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 55
integer y = 208
integer width = 4530
integer height = 2092
integer cornerheight = 40
integer cornerwidth = 46
end type

