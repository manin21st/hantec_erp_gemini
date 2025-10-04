$PBExportHeader$w_pdt_02760.srw
$PBExportComments$폐기현황
forward
global type w_pdt_02760 from w_standard_print
end type
type st_1 from statictext within w_pdt_02760
end type
type rb_02760 from radiobutton within w_pdt_02760
end type
type rb_02770 from radiobutton within w_pdt_02760
end type
type rb_02765 from radiobutton within w_pdt_02760
end type
type rr_1 from roundrectangle within w_pdt_02760
end type
type rr_2 from roundrectangle within w_pdt_02760
end type
end forward

global type w_pdt_02760 from w_standard_print
string title = "폐기 현황"
st_1 st_1
rb_02760 rb_02760
rb_02770 rb_02770
rb_02765 rb_02765
rr_1 rr_1
rr_2 rr_2
end type
global w_pdt_02760 w_pdt_02760

forward prototypes
public function integer wf_retrieve ()
public function integer wf_retrieve_02760 ()
public function integer wf_retrieve_02770 ()
end prototypes

public function integer wf_retrieve ();integer i_rtn

if dw_ip.AcceptText() = -1 then return -1

if rb_02760.checked then
   i_rtn = wf_retrieve_02760()
elseif rb_02765.checked then
   i_rtn = wf_retrieve_02760()
elseif rb_02770.checked then
	i_rtn = wf_retrieve_02770()
else
	MessageBox("출력구분 확인","출력구분을 확인 하세요!")
	i_rtn = -1
end if	

return i_rtn


end function

public function integer wf_retrieve_02760 ();String sFrom, sTo, scodefrom, scodeto

sFrom       = trim(dw_ip.GetItemString(1,"pedat"))
sTo         = trim(dw_ip.GetItemString(1,"pedatto"))
scodeFrom   = trim(dw_ip.GetItemString(1,"pdtgu"))
scodeTo     = trim(dw_ip.GetItemString(1,"pdtguto"))

IF sFrom ="" OR IsNull(sFrom) THEN sFrom = "10000101"

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

IF dw_print.Retrieve(gs_sabu,sFrom,sTo,scodefrom,scodeto, gs_saupj) <=0 THEN
	f_message_chk(50,'')
   dw_ip.setcolumn('pedat')
	dw_ip.SetFocus()
	Return -1
END IF
 
   dw_print.sharedata(dw_list) 
Return 1

end function

public function integer wf_retrieve_02770 ();String sFrom,sTo

sFrom       = trim(dw_ip.GetItemString(1,"pedat"))
sTo         = trim(dw_ip.GetItemString(1,"pedatto"))

IF sFrom ="" OR IsNull(sFrom) THEN sFrom = "10000101"
IF sTo ="" OR IsNull(sTo) THEN sTo = "99991231"

IF dw_print.Retrieve(gs_sabu, sFrom, sTo) <=0 THEN
	f_message_chk(50,'')
   dw_ip.setcolumn('pedat')
	dw_ip.SetFocus()
	Return -1
END IF
   
	dw_print.sharedata(dw_list)
Return 1

end function

on w_pdt_02760.create
int iCurrent
call super::create
this.st_1=create st_1
this.rb_02760=create rb_02760
this.rb_02770=create rb_02770
this.rb_02765=create rb_02765
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.rb_02760
this.Control[iCurrent+3]=this.rb_02770
this.Control[iCurrent+4]=this.rb_02765
this.Control[iCurrent+5]=this.rr_1
this.Control[iCurrent+6]=this.rr_2
end on

on w_pdt_02760.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.rb_02760)
destroy(this.rb_02770)
destroy(this.rb_02765)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_ip.SetItem(1,"pedat", is_today)
dw_ip.SetItem(1,"pedatto", is_today)
dw_ip.SetColumn("pedat")
dw_ip.Setfocus()

end event

type p_preview from w_standard_print`p_preview within w_pdt_02760
integer x = 3922
integer y = 72
end type

type p_exit from w_standard_print`p_exit within w_pdt_02760
integer x = 4279
integer y = 72
end type

type p_print from w_standard_print`p_print within w_pdt_02760
integer x = 4101
integer y = 72
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_02760
integer x = 3744
integer y = 72
end type











type dw_print from w_standard_print`dw_print within w_pdt_02760
integer x = 3186
integer y = 28
integer width = 256
integer height = 208
string dataobject = "d_pdt_02760_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_02760
integer x = 37
integer y = 44
integer width = 1879
integer height = 292
string dataobject = "d_pdt_02760_0"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::itemchanged;String  sDateFrom,sDateTo,snull

SetNull(snull)

IF this.GetColumnName() = "pedat" THEN
	sDateFrom = Trim(this.GetText())
	IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
	
	IF f_datechk(sDateFrom) = -1 THEN
		f_message_chk(35,'[폐기일자 FROM]')
		this.SetItem(1,"pedat",snull)
		Return 1
	END IF
ELSEIF this.GetColumnName() = "pedatto" THEN
	sDateTo = Trim(this.GetText())
	IF sDateTo ="" OR IsNull(sDateTo) THEN RETURN
	
	IF f_datechk(sDateTo) = -1 THEN
		f_message_chk(35,'[폐기일자 TO]')
		this.SetItem(1,"pedatto",snull)
		Return 1
	END IF
END IF

end event

type dw_list from w_standard_print`dw_list within w_pdt_02760
integer x = 55
integer y = 348
integer width = 4549
integer height = 1948
string dataobject = "d_pdt_02760_1"
boolean border = false
end type

type st_1 from statictext within w_pdt_02760
integer x = 2007
integer y = 88
integer width = 498
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "출력구분"
boolean focusrectangle = false
end type

type rb_02760 from radiobutton within w_pdt_02760
integer x = 2286
integer y = 76
integer width = 722
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "제품,반제품 폐기현황"
boolean checked = true
end type

event clicked;dw_ip.Setredraw(False)
dw_list.Setredraw(False)
dw_ip.DataObject = "d_pdt_02760_0"
dw_list.DataObject = "d_pdt_02760_1"
dw_ip.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)
dw_ip.InsertRow(0)
dw_ip.Setredraw(True)
dw_list.Setredraw(True)
dw_ip.SetFocus()

dw_print.DataObject = "d_pdt_02760_1_p"
dw_print.SetTransObject(SQLCA)


end event

type rb_02770 from radiobutton within w_pdt_02760
boolean visible = false
integer x = 2286
integer y = 220
integer width = 722
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "폐기 사유별 현황"
end type

event clicked;dw_ip.Setredraw(False)
dw_list.Setredraw(False)
dw_ip.DataObject = "d_pdt_02770_0"
dw_list.DataObject = "d_pdt_02770_1"
dw_ip.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)
dw_ip.InsertRow(0)
dw_ip.Setredraw(True)
dw_list.Setredraw(True)
dw_ip.SetFocus()

dw_print.DataObject = "d_pdt_02770_1"
dw_print.SetTransObject(SQLCA)

end event

type rb_02765 from radiobutton within w_pdt_02760
integer x = 2286
integer y = 148
integer width = 704
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "제품,반제품 폐기(상세)"
end type

event clicked;dw_ip.Setredraw(False)
dw_list.Setredraw(False)
dw_ip.DataObject = "d_pdt_02760_0"
dw_list.DataObject = "d_pdt_02765_1"
dw_ip.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)
dw_ip.InsertRow(0)
dw_ip.Setredraw(True)
dw_list.Setredraw(True)
dw_ip.SetFocus()

dw_print.DataObject = "d_pdt_02765_1_p"
dw_print.SetTransObject(SQLCA)

end event

type rr_1 from roundrectangle within w_pdt_02760
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 1943
integer y = 44
integer width = 1134
integer height = 260
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdt_02760
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 41
integer y = 336
integer width = 4581
integer height = 1984
integer cornerheight = 40
integer cornerwidth = 55
end type

