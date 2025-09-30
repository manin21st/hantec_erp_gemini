$PBExportHeader$w_pdt_02780.srw
$PBExportComments$생산일보 현황
forward
global type w_pdt_02780 from w_standard_print
end type
type st_1 from statictext within w_pdt_02780
end type
type rb_02780 from radiobutton within w_pdt_02780
end type
type rb_02790 from radiobutton within w_pdt_02780
end type
type st_2 from statictext within w_pdt_02780
end type
type rb_02670 from radiobutton within w_pdt_02780
end type
type rb_02680 from radiobutton within w_pdt_02780
end type
type rb_02685 from radiobutton within w_pdt_02780
end type
type rr_1 from roundrectangle within w_pdt_02780
end type
end forward

global type w_pdt_02780 from w_standard_print
string title = "생산일보 현황"
st_1 st_1
rb_02780 rb_02780
rb_02790 rb_02790
st_2 st_2
rb_02670 rb_02670
rb_02680 rb_02680
rb_02685 rb_02685
rr_1 rr_1
end type
global w_pdt_02780 w_pdt_02780

forward prototypes
public function integer wf_retrieve ()
public function integer wf_retrieve_02670 ()
public function integer wf_retrieve_02680 ()
public function integer wf_retrieve_02685 ()
public function integer wf_retrieve_02780 ()
public function integer wf_retrieve_02790 ()
end prototypes

public function integer wf_retrieve ();integer i_rtn

if dw_ip.AcceptText() = -1 then return -1

if rb_02780.Checked then
	i_rtn = wf_retrieve_02780()
elseif rb_02790.Checked then
	i_rtn = wf_retrieve_02790()
elseif rb_02670.Checked then
   i_rtn = wf_retrieve_02670()
elseif rb_02680.Checked then
	i_rtn = wf_retrieve_02680()
elseif rb_02685.Checked then
	i_rtn = wf_retrieve_02685()	
else
	MessageBox("확인","출력구분을 확인 하세요!")
	i_rtn = -1
end if	

return i_rtn



end function

public function integer wf_retrieve_02670 ();string sdate, edate, saengfr, saengto, jocod1, jocod2, gong, sil

sdate = Trim(dw_ip.object.sdate[1])
edate = Trim(dw_ip.object.edate[1])
saengfr = Trim(dw_ip.object.saengfr[1])
saengto = Trim(dw_ip.object.saengto[1])
jocod1 = Trim(dw_ip.object.jocod1[1])
jocod2 = Trim(dw_ip.object.jocod2[1])
gong = Trim(dw_ip.object.gong[1])
sil = Trim(dw_ip.object.sil[1])

if IsNull(sdate) or sdate = "" then sdate = "11110101"
if IsNull(edate) or edate = "" then edate = "99991231"
if IsNull(saengfr) or saengfr = "" then saengfr = "."
if IsNull(saengto) or saengto = "" then saengto = "ZZZZZZ"
if IsNull(jocod1) or jocod1 = "" then jocod1 = "."
if IsNull(jocod2) or jocod2 = "" then jocod2 = "ZZZZZZ"

//dw_print.object.txt_ymd.text = String(sdate, "@@@@.@@.@@") + " - " + String(edate, "@@@@.@@.@@")
IF dw_print.retrieve(gs_sabu, sdate, edate, saengfr, saengto, jocod1, jocod2, gong, sil, gs_saupj) <= 0 THEN
	f_message_chk(50,'[작업장(W/C)별 생산일보]')
	dw_ip.setfocus()
	Return -1
END IF

dw_print.ShareData(dw_list)

return 1
end function

public function integer wf_retrieve_02680 ();string sdate, edate, pdtgu1, pdtgu2, ch1, ch2, sqctgu

sdate = Trim(dw_ip.object.sdate[1])
edate = Trim(dw_ip.object.edate[1])
pdtgu1 = Trim(dw_ip.object.pdtgu1[1])
pdtgu2 = Trim(dw_ip.object.pdtgu2[1])
sqctgu  = Trim(dw_ip.object.qctgu[1])
ch1 = Trim(dw_ip.object.ch1[1])
ch2 = Trim(dw_ip.object.ch2[1])

if IsNull(sdate) or sdate = "" then sdate = "11110101"
if IsNull(edate) or edate = "" then edate = "99991231"
if IsNull(pdtgu1) or pdtgu1 = "" then pdtgu1 = "."
if IsNull(pdtgu2) or pdtgu2 = "" then pdtgu2 = "ZZZZZZ"
if IsNull(ch1) or ch1 = "" then ch1 = "."
if IsNull(ch2) or ch2 = "" then ch2 = "ZZZZZZ"

IF dw_print.retrieve(gs_sabu, sdate, edate, pdtgu1, pdtgu2, ch1, ch2, gs_saupj) <= 0 THEN
   f_message_chk(50,'[생산 완료 통보서]')
	dw_ip.setfocus()
	Return -1
END IF

dw_print.setfilter("")
if sqctgu = '1' then 
   dw_print.setfilter("shpact_coqty > 0")
end if
dw_print.filter()
	
dw_print.ShareData(dw_list)

return 1
end function

public function integer wf_retrieve_02685 ();string sdate, edate, pdtgu1, pdtgu2, gbn, pgbn

sdate = Trim(dw_ip.object.sdate[1])
edate = Trim(dw_ip.object.edate[1])
pdtgu1 = Trim(dw_ip.object.pdtgu1[1])
pdtgu2 = Trim(dw_ip.object.pdtgu2[1])
gbn    = Trim(dw_ip.object.gbn[1])
pgbn    = Trim(dw_ip.object.pgbn[1])

if IsNull(sdate) or sdate = "" then sdate = "11110101"
if IsNull(edate) or edate = "" then edate = "99991231"
if IsNull(pdtgu1) or pdtgu1 = "" then pdtgu1 = "."
if IsNull(pdtgu2) or pdtgu2 = "" then pdtgu2 = "ZZZZZZ"

if gbn = '1' then
	dw_list.dataobject = "d_pdt_02685_02"	
Else
	dw_list.dataobject = "d_pdt_02685_03"		
End if
//dw_list.settransobject(sqlca)


IF dw_print.retrieve(gs_sabu, sdate, edate, pdtgu1, pdtgu2, pgbn, gs_saupj) <= 0 THEN
   f_message_chk(50,'[공정 완료 통보서]')
	dw_ip.setfocus()
	Return -1
END IF

dw_print.ShareData(dw_list)

return 1
end function

public function integer wf_retrieve_02780 ();String sFrom,sTo,sGubn,snull,scodefrom, scodeto,sdepot, sdepotname

setnull(snull)


sFrom       = trim(dw_ip.GetItemString(1,"jidat"))
sTo         = trim(dw_ip.GetItemString(1,"jidatto"))
scodeFrom   = trim(dw_ip.GetItemString(1,"itnbr"))
scodeTo     = trim(dw_ip.GetItemString(1,"itnbrto"))
sdepot     = trim(dw_ip.GetItemString(1,"depot_no"))
sdepotname     = trim(dw_ip.GetItemString(1,"depot_name"))

IF sFrom ="" OR IsNull(sFrom) THEN sfrom = '10000101'

IF sTo ="" OR IsNull(sTo) THEN  sto = '99991231'


if scodeFrom = "" or isnull(scodeFrom) then	
	SELECT MIN("ITEMAS"."ITNBR")
	  INTO :scodeFrom  
	  FROM "ITEMAS"  ;
END IF
	
IF scodeTo   = ""	or isnull(scodeTo) then	
	SELECT MAX("ITEMAS"."ITNBR")
	  INTO :scodeTo  
	  FROM "ITEMAS"   ;
END IF

IF	( scodeFrom > scodeTo  )	  then
	MessageBox("확인","품목코드의 범위를 확인하세요!")
	dw_ip.setcolumn('itnbr')
	dw_ip.setfocus()
	Return -1
END IF

if sdepot = "" or isnull(sdepot) then 
	sdepot = '%'
	sdepotname= ''
end if

IF dw_print.Retrieve(gs_sabu,sFrom,sTo,scodefrom,scodeto,sdepot,sdepotname, gs_saupj) <=0 THEN
	f_message_chk(50,'')
   dw_ip.setcolumn('jidat')
	dw_ip.SetFocus()
	Return -1
END IF

dw_print.ShareData(dw_list)

Return 1

end function

public function integer wf_retrieve_02790 ();String sFrom,sTo,sGubn,snull, sitnbr, spordno

setnull(snull)

sFrom       = trim(dw_ip.GetItemString(1,"jidat"))
sTo         = trim(dw_ip.GetItemString(1,"jidatto"))
sPordno     = trim(dw_ip.GetItemString(1,"pordno"))
sItnbr      = trim(dw_ip.GetItemString(1,"fitnbr"))
sGubn       = dw_ip.GetItemString(1,"gubn")

IF sFrom ="" OR IsNull(sFrom) THEN  sfrom = '10000101'

IF sTo ="" OR IsNull(sTo) THEN sto = '99991231'

IF spordno = "" OR IsNull(sPordno) then 
	spordno = '%' 
ELSE
	sPordno = sPordno + '%'
END IF

IF sItnbr = "" OR IsNull(sItnbr) then 
	sItnbr = '%' 
ELSE
	sItnbr = sItnbr + '%'
END IF

dw_list.setredraw(false)

IF dw_print.Retrieve(gs_sabu, sPordno, sFrom, sTo, sItnbr, gs_saupj) <=0 THEN
	dw_list.setredraw(True)
	f_message_chk(50,'')
   dw_ip.setcolumn('jidat')
	dw_ip.SetFocus()
	Return -1
END IF

IF sGubn = '1' then
  dw_print.setfilter("jqty = 0 and pdtgu ='Y'")
ELSEIF sGubn = '2' then	
  dw_print.setfilter("jqty <> 0 and pdtgu ='Y'")
ELSE
  dw_print.setfilter("pdtgu ='Y'")
END IF	
dw_print.filter()

IF dw_print.RowCount() <=0 THEN
	dw_list.setredraw(True)
	f_message_chk(50,'')
   dw_ip.setcolumn('jidat')
	dw_ip.SetFocus()
	Return -1
END IF

dw_print.ShareData(dw_list)

dw_list.setredraw(True)

Return 1

end function

on w_pdt_02780.create
int iCurrent
call super::create
this.st_1=create st_1
this.rb_02780=create rb_02780
this.rb_02790=create rb_02790
this.st_2=create st_2
this.rb_02670=create rb_02670
this.rb_02680=create rb_02680
this.rb_02685=create rb_02685
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.rb_02780
this.Control[iCurrent+3]=this.rb_02790
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.rb_02670
this.Control[iCurrent+6]=this.rb_02680
this.Control[iCurrent+7]=this.rb_02685
this.Control[iCurrent+8]=this.rr_1
end on

on w_pdt_02780.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.rb_02780)
destroy(this.rb_02790)
destroy(this.st_2)
destroy(this.rb_02670)
destroy(this.rb_02680)
destroy(this.rb_02685)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(1,"jidat", is_today)
dw_ip.SetItem(1,"jidatto", is_today)
dw_ip.SetColumn("jidat")
dw_ip.Setfocus()

end event

type p_preview from w_standard_print`p_preview within w_pdt_02780
integer x = 4059
integer y = 28
end type

type p_exit from w_standard_print`p_exit within w_pdt_02780
integer x = 4407
integer y = 28
end type

type p_print from w_standard_print`p_print within w_pdt_02780
integer x = 4233
integer y = 28
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_02780
integer x = 3886
end type











type dw_print from w_standard_print`dw_print within w_pdt_02780
string dataobject = "d_pdt_02780_1_p"
end type

event dw_print::dberror;call super::dberror;//MessageBox("Error", "SQLCOD:" + string(sqldbcode) +", TEXT :" + sqlerrtext )
end event

type dw_ip from w_standard_print`dw_ip within w_pdt_02780
integer x = 73
integer y = 32
integer width = 3040
integer height = 408
string dataobject = "d_pdt_02780_0"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::itemchanged;String  sDateFrom,sDateTo,snull
String s_cod, s_nam1, s_nam2
integer i_rtn

s_cod = Trim(this.GetText())

SetNull(snull)

IF this.GetColumnName() = "jidat" THEN
	sDateFrom = Trim(this.GetText())
	IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
	
	IF f_datechk(sDateFrom) = -1 THEN
		f_message_chk(35,'[입고일자]')
		this.SetItem(1,"jidat",snull)
		Return 1
	END IF
elseIF this.GetColumnName() = "jidatto" THEN
	sDateTo = Trim(this.GetText())
	IF sDateTo ="" OR IsNull(sDateTo) THEN RETURN
	
	IF f_datechk(sDateTo) = -1 THEN
		f_message_chk(35,'[입고일자]')
		this.SetItem(1,"jidatto",snull)
		Return 1
	END IF
elseIF this.GetColumnName() = "fitnbr" THEN //품목번호
	s_cod = Trim(this.GetText())
	i_rtn = f_get_name2("품번", "N", s_cod, s_nam1, s_nam2)
	this.setitem(1,"fitnbr",s_cod)
	this.SetItem(1,"fitdsc",s_nam1)	
	this.SetItem(1,"fispec",s_nam2)	
	return i_rtn
elseIF this.GetColumnName() = "fitdsc" THEN 
	s_nam1 = Trim(this.GetText())
	i_rtn = f_get_name2("품명", "N", s_cod, s_nam1, s_nam2)
	this.setitem(1,"fitnbr",s_cod)
	this.SetItem(1,"fitdsc",s_nam1)	
	this.SetItem(1,"fispec",s_nam2)	
	return i_rtn
elseIF this.GetColumnName() = "fispec" THEN 
	s_nam2 = Trim(this.GetText())
	i_rtn = f_get_name2("규격", "N", s_cod, s_nam1, s_nam2)
	this.setitem(1,"fitnbr",s_cod)
	this.SetItem(1,"fitdsc",s_nam1)	
	this.SetItem(1,"fispec",s_nam2)	
	return i_rtn
elseIF this.GetColumnName() = "itnbr" THEN //품목번호
	s_cod = Trim(this.GetText())
	i_rtn = f_get_name2("품번", "N", s_cod, s_nam1, s_nam2)
	this.setitem(1,"itnbr",s_cod)
	this.SetItem(1,"itname",s_nam1)	
	return i_rtn

elseIF this.GetColumnName() = "itnbrto" THEN
	s_cod = Trim(this.GetText())
	i_rtn = f_get_name2("품번", "N", s_cod, s_nam1, s_nam2)
	this.setitem(1,"itnbrto",s_cod)
	this.SetItem(1,"itnameto",s_nam1)	
	return i_rtn
elseif this.getcolumnname() = "depot_no" then 
	s_cod = Trim(this.GetText())
	i_rtn = f_get_name2("창고", "Y", s_cod, s_nam1, s_nam2)
	this.setitem(1,"depot_no",s_cod)
	this.setitem(1,"depot_name",s_nam1)		
	return i_rtn
elseif	this.getcolumnname() = "sdate" then
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1	then
      f_message_chk(35,'[시작일자]')
		this.object.sdate[1] = ""
		return 1
	end if
elseif this.getcolumnname() = "edate" then
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1	then
      f_message_chk(35,'[끝일자]')
		this.object.edate[1] = ""
		return 1
	end if
elseif this.getcolumnname() = "jocod1" then
	i_rtn = f_get_name2("조", "N", s_cod, s_nam1, s_nam2)
	this.object.jocod1[1] = s_cod
	this.object.jonam1[1] = s_nam1
	return i_rtn
elseif this.getcolumnname() = "jocod2" then
	i_rtn = f_get_name2("조", "N", s_cod, s_nam1, s_nam2)
	this.object.jocod2[1] = s_cod
	this.object.jonam2[1] = s_nam1
	return i_rtn
elseif this.getcolumnname() = "ch1" then	
	i_rtn = f_get_name2("창고", "N", s_cod, s_nam1, s_nam2)
	this.object.ch1[1] = s_cod
	this.object.chnm1[1] = s_nam1
	return i_rtn
elseif this.getcolumnname() = "ch2" then	
	i_rtn = f_get_name2("창고", "N", s_cod, s_nam1, s_nam2)
	this.object.ch2[1] = s_cod
	this.object.chnm2[1] = s_nam1
	return i_rtn
end if	



end event

event dw_ip::rbuttondown;SetNull(gs_Code)
SetNull(gs_codename)
SetNull(gs_gubun)

IF this.GetColumnName() ="itnbr" THEN
	gs_gubun = '1'
	Open(w_itemas_popup)
	
	IF gs_code ="" OR IsNull(gs_code) THEN RETURN
	
	this.SetItem(1,"itnbr",gs_code)
	this.SetItem(1,"itname",Gs_CodeName)
	Return
elseIF this.GetColumnName() ="itnbrto" THEN
	gs_gubun = '1'
	Open(w_itemas_popup)
	
	IF gs_code ="" OR IsNull(gs_code) THEN RETURN
	
	this.SetItem(1,"itnbrto",gs_code)
	this.SetItem(1,"itnameto",Gs_CodeName)
	Return
elseIF this.GetColumnName() ="fitnbr" THEN
	gs_gubun = '1'
	Open(w_itemas_popup)
	
	IF gs_code ="" OR IsNull(gs_code) THEN RETURN
	
	this.SetItem(1,"fitnbr",gs_code)
	this.SetItem(1,"fitdsc",Gs_CodeName)
	this.SetItem(1,"fispec",Gs_gubun)
	Return
elseIF this.GetColumnName() ="pordno" THEN
	open(w_jisi_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1, "pordno", 	 gs_Code)
elseIF this.GetColumnName() ="depot_no" THEN
	Open(w_vndmst_46_popup)
	
	IF gs_code ="" OR IsNull(gs_code) THEN RETURN
	
	this.SetItem(1,"depot_no",gs_code)
	this.SetItem(1,"depot_name",Gs_CodeName)
	Return
elseif this.getcolumnname() = "ch1" then 
	open(w_vndmst_46_popup)
	IF gs_code ="" OR IsNull(gs_code) THEN RETURN
   this.object.ch1[1] = gs_code
	this.object.chnm1[1] = gs_codename
elseif this.getcolumnname() = "ch2" then 
	open(w_vndmst_46_popup)
	IF gs_code ="" OR IsNull(gs_code) THEN RETURN
   this.object.ch2[1] = gs_code
   this.object.chnm2[1] = gs_codename
elseif this.getcolumnname() = "jocod1" then 
	open(w_jomas_popup)
	IF gs_code ="" OR IsNull(gs_code) THEN RETURN
   this.object.jocod1[1] = gs_code
	this.object.jonam1[1] = gs_codename
elseif this.getcolumnname() = "jocod2" then 
	open(w_jomas_popup)
	IF gs_code ="" OR IsNull(gs_code) THEN RETURN
   this.object.jocod2[1] = gs_code
   this.object.jonam2[1] = gs_codename
end if	


end event

type dw_list from w_standard_print`dw_list within w_pdt_02780
integer x = 87
integer y = 464
integer width = 4503
integer height = 1780
string dataobject = "d_pdt_02780_1"
boolean border = false
boolean hsplitscroll = false
end type

type st_1 from statictext within w_pdt_02780
integer x = 3186
integer y = 32
integer width = 256
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
string text = "출력구분"
boolean focusrectangle = false
end type

type rb_02780 from radiobutton within w_pdt_02780
integer x = 3150
integer y = 80
integer width = 709
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "기간별 입고현황 LIST"
boolean checked = true
end type

event clicked;dw_ip.Setredraw(False)
dw_list.Setredraw(False)
dw_ip.DataObject = "d_pdt_02780_0"
dw_list.DataObject = "d_pdt_02780_1"
dw_print.DataObject = "d_pdt_02780_1_p"

dw_ip.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

dw_ip.InsertRow(0)
dw_ip.Setredraw(True)
dw_list.Setredraw(True)
dw_ip.SetFocus()

p_print.Enabled =False
p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

p_preview.enabled = False
p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
//
end event

type rb_02790 from radiobutton within w_pdt_02780
integer x = 3150
integer y = 140
integer width = 709
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "작업지시 NO별 "
end type

event clicked;dw_ip.Setredraw(False)
dw_list.Setredraw(False)
dw_ip.DataObject = "d_pdt_02790_0"
dw_list.DataObject = "d_pdt_02790_1"
dw_print.DataObject = "d_pdt_02790_1_p"
dw_ip.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

dw_ip.InsertRow(0)
dw_ip.Setredraw(True)
dw_list.Setredraw(True)
dw_ip.SetFocus()

p_print.Enabled =False
p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

p_preview.enabled = False
p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
end event

type st_2 from statictext within w_pdt_02780
integer x = 3237
integer y = 200
integer width = 617
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
string text = "생산입고/미입고 현황"
boolean focusrectangle = false
end type

type rb_02670 from radiobutton within w_pdt_02780
integer x = 3150
integer y = 244
integer width = 759
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "작업장별 일일 생산일보"
end type

event clicked;dw_ip.Setredraw(False)
dw_list.Setredraw(False)
dw_ip.DataObject = "d_pdt_02670_01"
dw_list.DataObject = "d_pdt_02670_02"
dw_print.DataObject = "d_pdt_02670_02_p"

dw_ip.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

dw_ip.InsertRow(0)
dw_ip.Setredraw(True)
dw_list.Setredraw(True)
dw_ip.SetFocus()

p_print.Enabled =False
p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

p_preview.enabled = False
p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'


end event

type rb_02680 from radiobutton within w_pdt_02780
integer x = 3150
integer y = 368
integer width = 759
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "생산완료 통보서"
end type

event clicked;dw_ip.Setredraw(False)
dw_list.Setredraw(False)
dw_ip.DataObject = "d_pdt_02680_01"
dw_list.DataObject = "d_pdt_02680_02"
dw_print.DataObject = "d_pdt_02680_02_p"

dw_ip.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

dw_ip.InsertRow(0)
dw_ip.Setredraw(True)
dw_list.Setredraw(True)
dw_ip.SetFocus()

p_print.Enabled =False
p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

p_preview.enabled = False
p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'

end event

type rb_02685 from radiobutton within w_pdt_02780
integer x = 3150
integer y = 304
integer width = 759
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "공정완료 통보서"
end type

event clicked;dw_ip.Setredraw(False)
dw_list.Setredraw(False)
dw_ip.DataObject = "d_pdt_02685_01"
dw_list.DataObject = "d_pdt_02685_02"
dw_print.DataObject = "d_pdt_02685_02_p"

dw_ip.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

dw_ip.InsertRow(0)
dw_ip.Setredraw(True)
dw_list.Setredraw(True)
dw_ip.SetFocus()

p_print.Enabled =False
p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

p_preview.enabled = False
p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'

end event

type rr_1 from roundrectangle within w_pdt_02780
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 456
integer width = 4530
integer height = 1796
integer cornerheight = 40
integer cornerwidth = 55
end type

