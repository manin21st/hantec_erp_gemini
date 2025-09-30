$PBExportHeader$w_pdt_02300.srw
$PBExportComments$품목별 수주집계현황
forward
global type w_pdt_02300 from w_standard_print
end type
type gb_4 from groupbox within w_pdt_02300
end type
type rr_1 from roundrectangle within w_pdt_02300
end type
end forward

global type w_pdt_02300 from w_standard_print
string title = "품목별 수주 집계 현황"
gb_4 gb_4
rr_1 rr_1
end type
global w_pdt_02300 w_pdt_02300

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sFrom,sTo,sGubn,snull,scodefrom, scodeto, sDepot, sDepot_name
setnull(snull)

dw_ip.accepttext()

sFrom       = dw_ip.GetItemString(1,"pedat")
sTo         = dw_ip.GetItemString(1,"pedatto")
scodeFrom   = trim(dw_ip.GetItemString(1,"pdtgu"))
scodeTo     = trim(dw_ip.GetItemString(1,"pdtguto"))
sDepot      = dw_ip.GetItemString(1,"Depot")

IF sFrom ="" OR IsNull(sFrom) THEN sFrom = "00000101"

IF sTo ="" OR IsNull(sTo) THEN sTo = "99991231"

IF scodeFrom = "" OR isnull(scodeFrom) THEN
	  SELECT MIN("REFFPF"."RFGUB")  
	    INTO :scodeFrom  
  		 FROM "REFFPF"  
	   WHERE ( "REFFPF"."SABU" = '1' ) AND  
            ( "REFFPF"."RFCOD" = '03' )   ;
END IF

IF scodeTo = "" OR isnull(scodeTo) THEN
	  SELECT MAX("REFFPF"."RFGUB")  
	    INTO :scodeTo  
  		 FROM "REFFPF"  
	   WHERE ( "REFFPF"."SABU" = '1' ) AND  
            ( "REFFPF"."RFCOD" = '03' )   ;
END IF	

IF	( scodeFrom > scodeTo  )	  then
	MessageBox("확인","생산팀의 범위를 확인하세요!")
	dw_ip.setcolumn('pdtgu')
	dw_ip.setfocus()
	Return -1
END IF

if isnull(sDepot) or Trim(sDepot) = '' then
	sDepot = '%'
	sDepot_name = '전체'
Else
	select cvnas into :sDepot_name from vndmst where cvcod = :sDepot;	
End if

IF dw_list.Retrieve(gs_sabu,sFrom,sTo,scodefrom,scodeto,sDepot) <=0 THEN
	f_message_chk(50,'')
   dw_ip.setcolumn('pedat')
	dw_ip.SetFocus()
	Return -1
END IF

dw_print.object.dayname.text 	 = String(sFrom, '@@@@.@@.@@ - ') + String(sTo, '@@@@.@@.@@')
dw_print.object.depot_name.text = sDepot_Name

//dw_print.sharedata(dw_list)
Return 1

end function

on w_pdt_02300.create
int iCurrent
call super::create
this.gb_4=create gb_4
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_4
this.Control[iCurrent+2]=this.rr_1
end on

on w_pdt_02300.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_4)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(1,"pedat", is_today)
dw_ip.SetItem(1,"pedatto", is_today)
dw_ip.SetColumn("pedat")
dw_ip.Setfocus()

end event

type p_preview from w_standard_print`p_preview within w_pdt_02300
end type

type p_exit from w_standard_print`p_exit within w_pdt_02300
end type

type p_print from w_standard_print`p_print within w_pdt_02300
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_02300
end type











type dw_print from w_standard_print`dw_print within w_pdt_02300
string dataobject = "d_pdt_02300_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_02300
integer x = 69
integer y = 160
integer width = 3785
integer height = 100
string dataobject = "d_pdt_02300_2"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::itemchanged;String  sDateFrom,sDateTo,snull, sDepot

SetNull(snull)

IF this.GetColumnName() = "pedat" THEN
	sDateFrom = Trim(this.GetText())
	IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
	
	IF f_datechk(sDateFrom) = -1 THEN
		f_message_chk(35,'[폐기일자기간]')
		this.SetItem(1,"pedat",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "pedatto" THEN
	sDateTo = Trim(this.GetText())
	IF sDateTo ="" OR IsNull(sDateTo) THEN RETURN
	
	IF f_datechk(sDateTo) = -1 THEN
		f_message_chk(35,'[폐기일자기간]')
		this.SetItem(1,"pedatto",snull)
		Return 1
	END IF
END IF

if this.getcolumnname() = "Depot" then
	sDepot = Trim(this.gettext())
	
	if isnull(sDepot) or trim(sDepot) = '' then return
	
	select cvnas into :sDateto from vndmst
	 where cvcod = :sDepot and cvgu = '5';
	if sqlca.sqlcode <> 0 then
		this.setitem(1, "depot", snull)
		Messagebox("창고", "창고가 부정확합니다", stopsign!)
		return 1
	end if
	
end if

end event

event dw_ip::rbuttondown;SetNull(Gs_Code)
SetNull(Gs_CodeName)

IF this.GetColumnName() ="itnbr" THEN
	Open(w_itemas_popup3)
	
	IF gs_code ="" OR IsNull(gs_code) THEN RETURN
	
	this.SetItem(1,"itnbr",gs_code)
	this.SetItem(1,"itname",Gs_CodeName)
	Return
END IF
IF this.GetColumnName() ="itnbrto" THEN
	Open(w_itemas_popup3)
	
	IF gs_code ="" OR IsNull(gs_code) THEN RETURN
	
	this.SetItem(1,"itnbrto",gs_code)
	this.SetItem(1,"itnameto",Gs_CodeName)
	Return
END IF

IF this.GetColumnName() ="depot_no" THEN
	Open(w_vndmst_45_popup)
	
	IF gs_code ="" OR IsNull(gs_code) THEN RETURN
	
	this.SetItem(1,"depot_no",gs_code)
	this.SetItem(1,"depot_name",Gs_CodeName)
	Return
END IF
end event

type dw_list from w_standard_print`dw_list within w_pdt_02300
integer x = 82
integer y = 288
integer width = 4512
integer height = 2012
string dataobject = "d_pdt_02300_1"
boolean border = false
boolean hsplitscroll = false
end type

type gb_4 from groupbox within w_pdt_02300
integer x = 155
integer y = 528
integer width = 494
integer height = 360
integer taborder = 40
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "none"
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_pdt_02300
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 280
integer width = 4539
integer height = 2028
integer cornerheight = 40
integer cornerwidth = 55
end type

