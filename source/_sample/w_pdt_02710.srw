$PBExportHeader$w_pdt_02710.srw
$PBExportComments$ ** 불량현황(수리작업기준)
forward
global type w_pdt_02710 from w_standard_print
end type
type st_1 from statictext within w_pdt_02710
end type
type rb_02710 from radiobutton within w_pdt_02710
end type
type st_2 from statictext within w_pdt_02710
end type
type rb_02720 from radiobutton within w_pdt_02710
end type
type st_3 from statictext within w_pdt_02710
end type
type rb_02725 from radiobutton within w_pdt_02710
end type
type st_4 from statictext within w_pdt_02710
end type
type rb_02740 from radiobutton within w_pdt_02710
end type
type st_5 from statictext within w_pdt_02710
end type
type rr_1 from roundrectangle within w_pdt_02710
end type
end forward

global type w_pdt_02710 from w_standard_print
string title = "불량현황"
st_1 st_1
rb_02710 rb_02710
st_2 st_2
rb_02720 rb_02720
st_3 st_3
rb_02725 rb_02725
st_4 st_4
rb_02740 rb_02740
st_5 st_5
rr_1 rr_1
end type
global w_pdt_02710 w_pdt_02710

forward prototypes
public function integer wf_retrieve_02710 ()
public function integer wf_retrieve_02720 ()
public function integer wf_retrieve_02725 ()
public function integer wf_retrieve_02740 ()
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve_02710 ();string s_sfrdate, s_stodate, s_saengfr, s_saengto, s_sigbn
string s_get_saeng1, s_get_saeng2

s_saengfr = trim(dw_ip.getitemstring(1,"saengfr"))
s_saengto = trim(dw_ip.getitemstring(1,"saengto"))
s_sfrdate = trim(dw_ip.getitemstring(1,"sfrdate"))
s_stodate = trim(dw_ip.getitemstring(1,"stodate"))
s_sigbn   = trim(dw_ip.getitemstring(1,"sigbn"))

////필수입력항목 체크///////////////////////////////////
if isnull(s_sfrdate) or s_sfrdate = "" then s_sfrdate = '10000101'
	
if isnull(s_stodate) or s_stodate = "" then s_stodate = '99991231'

////조건(생산팀)에서 값이 없을때 전체를 출력할 경우//////////////////
if isnull(s_saengfr) or s_saengfr = "" then 
	s_saengfr = '.'
	s_get_saeng1 = '전체'
else
   s_get_saeng1 = f_get_reffer('03', s_saengfr)
end if
///////////////////////////////////////////////////////
if isnull(s_saengto) or s_saengto = "" then 
   s_saengto = 'ZZZZZZ'
	s_get_saeng2 = '전체'
else
   s_get_saeng2 = f_get_reffer('03', s_saengto)
end if

dw_print.Object.kbgsaeng1.Text = s_get_saeng1
dw_print.Object.kbgsaeng2.Text = s_get_saeng2

IF dw_print.retrieve(gs_sabu, s_saengfr,s_saengto,s_sfrdate,s_stodate,s_sigbn, gs_saupj) <= 0 THEN
   f_message_chk(50,'[불량 항목별 불량대장 - (상세)]')
	dw_ip.setfocus()
	SetPointer(Arrow!)
	Return -1
END IF

SetPointer(Arrow!)

dw_print.sharedata(dw_list)
return 1
end function

public function integer wf_retrieve_02720 ();string s_sfrdate, s_stodate, s_saengfr, s_saengto, slmsgu, s_sigbn

s_saengfr = trim(dw_ip.getitemstring(1,"saengfr"))
s_saengto = trim(dw_ip.getitemstring(1,"saengto"))
s_sfrdate = trim(dw_ip.getitemstring(1,"sfrdate"))
s_stodate = trim(dw_ip.getitemstring(1,"stodate"))
s_sigbn   = trim(dw_ip.getitemstring(1,"sigbn"))
slmsgu    = dw_ip.getitemstring(1,"lmsgu")
////필수입력항목 체크///////////////////////////////////
if isnull(s_sfrdate) or s_sfrdate = "" then s_sfrdate = '10000101'
if isnull(s_stodate) or s_stodate = "" then s_stodate = '99991231'

////조건(생산팀)에서 값이 없을때 전체를 출력할 경우//////////////////
if isnull(s_saengfr) or s_saengfr = "" then 
   s_saengfr = '.'
end if
///////////////////////////////////////////////////////
if isnull(s_saengto) or s_saengto = "" then 
   s_saengto = 'ZZZZZZ'
end if

//// <조회> /////////////////////////////////////////////////////////////////////////
IF dw_print.retrieve(gs_sabu, s_saengfr,s_saengto,s_sfrdate,s_stodate, slmsgu, s_sigbn, gs_saupj) <= 0 THEN
   f_message_chk(50,'[품목별 불량대장 - (집계) / 그룹]')
	dw_ip.setfocus()
	SetPointer(Arrow!)
	Return -1
END IF

dw_print.sharedata(dw_list)

dw_list.scrolltorow(1)
SetPointer(Arrow!)

return 1
end function

public function integer wf_retrieve_02725 ();string s_sfrdate, s_stodate, s_saengfr, s_saengto, s_grcode, s_sigbn
string s_get_saeng1, s_get_saeng2

s_sfrdate = trim(dw_ip.getitemstring(1,"sfrdate"))
s_stodate = trim(dw_ip.getitemstring(1,"stodate"))
s_saengfr = trim(dw_ip.getitemstring(1,"saengfr"))
s_saengto = trim(dw_ip.getitemstring(1,"saengto"))
s_grcode  = trim(dw_ip.getitemstring(1,"gr_code"))
s_sigbn   = trim(dw_ip.getitemstring(1,"sigbn"))

if isnull(s_sfrdate) or s_sfrdate = "" then s_sfrdate = '10000101'
if isnull(s_stodate) or s_stodate = "" then s_stodate = '99991231'

if isnull(s_grcode) or s_grcode = "" then
	f_message_chk(30,'[그룹 code]')
	dw_ip.setcolumn("gr_code")
	dw_ip.setfocus()
	return -1
end if

if isnull(s_saengfr) or s_saengfr = "" then s_saengfr = '.'
if isnull(s_saengto) or s_saengto = "" then s_saengto = 'ZZZZZZ'

//// <조회> /////////////////////////////////////////////////////////////////////////
IF dw_print.retrieve(gs_sabu, s_sfrdate,s_stodate,s_saengfr,s_saengto,s_grcode,s_sigbn, gs_saupj) <= 0 THEN
   f_message_chk(50,'[품목별 불량대장 - (집계) / 그룹별 상세]')
	dw_ip.setfocus()
	SetPointer(Arrow!)
	Return -1
END IF

dw_print.sharedata(dw_list)

dw_list.scrolltorow(1)
SetPointer(Arrow!)

return 1
end function

public function integer wf_retrieve_02740 ();string sdate, edate, fpdtgu, tpdtgu, fwkctr, twkctr

sdate  = trim(dw_ip.object.sfrdate[1])
edate  = trim(dw_ip.object.stodate[1])
fpdtgu = trim(dw_ip.object.fpdtgu[1])
tpdtgu = trim(dw_ip.object.tpdtgu[1])
fwkctr = trim(dw_ip.object.fwkctr[1])
twkctr = trim(dw_ip.object.twkctr[1])

if (IsNull(sdate) or sdate = "")  then sdate = "10000101"
if (IsNull(edate) or edate = "")  then edate = "99991231"
if (IsNull(fpdtgu) or fpdtgu = "")  then fpdtgu = "."
if (IsNull(tpdtgu) or tpdtgu = "")  then tpdtgu = "zzzzzz"
if (IsNull(fwkctr) or fwkctr = "")  then fwkctr = "."
if (IsNull(twkctr) or twkctr = "")  then twkctr = "zzzzzz"

if dw_print.Retrieve(gs_sabu, sdate, edate, fpdtgu, tpdtgu, fwkctr, twkctr, gs_saupj) <= 0 then
	f_message_chk(50,'')
	dw_ip.Setfocus()
	return -1
end if
  
dw_print.sharedata(dw_list)
return 1
end function

public function integer wf_retrieve ();if dw_ip.AcceptText() = -1 then 
	dw_ip.SetFocus()
	return -1
end if

if rb_02710.Checked then
	return wf_retrieve_02710()
elseif rb_02720.Checked then
   return wf_retrieve_02720()
elseif rb_02725.Checked then
   return wf_retrieve_02725()
elseif rb_02740.Checked then
   return wf_retrieve_02740()	
else
	MessageBox("출력구분 확인","출력구분을 먼저 선택하세요!")
end if	

// dw_list.sharedataoff()

return -1
end function

on w_pdt_02710.create
int iCurrent
call super::create
this.st_1=create st_1
this.rb_02710=create rb_02710
this.st_2=create st_2
this.rb_02720=create rb_02720
this.st_3=create st_3
this.rb_02725=create rb_02725
this.st_4=create st_4
this.rb_02740=create rb_02740
this.st_5=create st_5
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.rb_02710
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.rb_02720
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.rb_02725
this.Control[iCurrent+7]=this.st_4
this.Control[iCurrent+8]=this.rb_02740
this.Control[iCurrent+9]=this.st_5
this.Control[iCurrent+10]=this.rr_1
end on

on w_pdt_02710.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.rb_02710)
destroy(this.st_2)
destroy(this.rb_02720)
destroy(this.st_3)
destroy(this.rb_02725)
destroy(this.st_4)
destroy(this.rb_02740)
destroy(this.st_5)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.setitem(1,"sfrdate", left(is_today, 6)+"01")
dw_ip.SetItem(1,"stodate", f_today())

end event

type p_preview from w_standard_print`p_preview within w_pdt_02710
end type

type p_exit from w_standard_print`p_exit within w_pdt_02710
end type

type p_print from w_standard_print`p_print within w_pdt_02710
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_02710
end type







type st_10 from w_standard_print`st_10 within w_pdt_02710
end type



type dw_print from w_standard_print`dw_print within w_pdt_02710
string dataobject = "d_pdt_02710_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_02710
integer x = 73
integer y = 236
integer width = 3488
integer height = 240
string dataobject = "d_pdt_02710_01"
end type

event dw_ip::itemchanged;string snull, s_cod, s_nam1, s_nam2
int    i_rtn

setnull(snull)

s_cod = Trim(this.GetText())

////작업일자 from ~ to//////////////////////////////////////////////////////////
IF	this.getcolumnname() = "sfrdate" THEN
	if s_cod = '' or isnull(s_cod) then return 
	
	IF f_datechk(s_cod) = -1	then
      f_message_chk(35,'[일자 FROM]')
		this.setitem(1, "sfrdate", sNull)
		return 1
	END IF
ELSEIF this.getcolumnname() = "stodate" THEN
	if s_cod = '' or isnull(s_cod) then return 

	IF f_datechk(s_cod) = -1	then
		f_message_chk(35,'[일자 TO]')
		this.setitem(1, "stodate", sNull)
		return 1
	END IF
elseif this.GetColumnName() = "fwkctr" then	
	i_rtn = f_get_name2("작업장", "N", s_cod, s_nam1, s_nam2)
	this.object.fwkctr[1] = s_cod
	this.object.fwknm[1] = s_nam1
	return i_rtn
elseif this.GetColumnName() = "twkctr" then	
	i_rtn = f_get_name2("작업장", "N", s_cod, s_nam1, s_nam2)
	this.object.twkctr[1] = s_cod
	this.object.twknm[1] = s_nam1
	return i_rtn
end if	

end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;SetNull(Gs_gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

IF this.GetColumnName() ="fwkctr" THEN
	Open(w_workplace_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.object.fwkctr[1] = gs_code
	this.object.fwknm[1] = gs_codename
ELSEIF this.GetColumnName() ="twkctr" THEN
	Open(w_workplace_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.object.twkctr[1] = gs_code
	this.object.twknm[1] = gs_codename
END IF
end event

type dw_list from w_standard_print`dw_list within w_pdt_02710
integer x = 91
integer y = 520
integer width = 4498
integer height = 1700
string dataobject = "d_pdt_02710_02"
boolean border = false
boolean hsplitscroll = false
end type

type st_1 from statictext within w_pdt_02710
integer x = 78
integer y = 36
integer width = 270
integer height = 56
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

type rb_02710 from radiobutton within w_pdt_02710
integer x = 78
integer y = 100
integer width = 635
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "불량항목별 불량대장"
boolean checked = true
end type

event clicked;dw_ip.Setredraw(False)
dw_list.Setredraw(False)
dw_ip.DataObject = "d_pdt_02710_01"
dw_list.DataObject = "d_pdt_02710_02"
dw_print.DataObject = "d_pdt_02710_02_p"
dw_ip.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
dw_ip.InsertRow(0)
dw_ip.setitem(1,"sfrdate",string(today(),"yyyymm"+"01"))
dw_ip.SetItem(1,"stodate", f_today())
dw_ip.Setredraw(True)
dw_list.Setredraw(True)
dw_ip.SetFocus()

p_print.Enabled =False
p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

p_preview.enabled = False
p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'



end event

type st_2 from statictext within w_pdt_02710
integer x = 160
integer y = 160
integer width = 439
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
string text = "(상세)"
boolean focusrectangle = false
end type

type rb_02720 from radiobutton within w_pdt_02710
integer x = 731
integer y = 100
integer width = 635
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "품목별 불량대장"
end type

event clicked;dw_ip.Setredraw(False)
dw_list.Setredraw(False)
dw_ip.DataObject = "d_pdt_02720_01"
dw_print.DataObject = "d_pdt_02720_02_p"
dw_list.DataObject = "d_pdt_02720_02"
dw_ip.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)
dw_ip.InsertRow(0)
dw_ip.setitem(1,"sfrdate",string(today(),"yyyymm"+"01"))
dw_ip.SetItem(1,"stodate", f_today())
dw_ip.Setredraw(True)
dw_list.Setredraw(True)
dw_ip.SetFocus()

p_print.Enabled =False
p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

p_preview.enabled = False
p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'


end event

type st_3 from statictext within w_pdt_02710
integer x = 814
integer y = 160
integer width = 439
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
string text = "(집계)"
boolean focusrectangle = false
end type

type rb_02725 from radiobutton within w_pdt_02710
integer x = 1376
integer y = 100
integer width = 635
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "품목별 불량대장"
end type

event clicked;dw_ip.Setredraw(False)
dw_list.Setredraw(False)
dw_ip.DataObject = "d_pdt_02725_01"
dw_print.DataObject = "d_pdt_02725_02_p"
dw_list.DataObject = "d_pdt_02725_02"
dw_ip.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
dw_ip.InsertRow(0)
dw_ip.setitem(1,"sfrdate",string(today(),"yyyymm"+"01"))
dw_ip.SetItem(1,"stodate", f_today())
dw_ip.Setredraw(True)
dw_list.Setredraw(True)
dw_ip.SetFocus()

p_print.Enabled =False
p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

p_preview.enabled = False
p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'


end event

type st_4 from statictext within w_pdt_02710
integer x = 1458
integer y = 160
integer width = 544
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
string text = "(집계/그룹별상세)"
boolean focusrectangle = false
end type

type rb_02740 from radiobutton within w_pdt_02710
integer x = 2016
integer y = 100
integer width = 635
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "불량품 발생원인별"
end type

event clicked;dw_ip.Setredraw(False)
dw_list.Setredraw(False)
dw_ip.DataObject = "d_pdt_02740_a"
dw_print.DataObject = "d_pdt_02740_1_p"
dw_list.DataObject = "d_pdt_02740_1" 
dw_ip.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)
dw_ip.InsertRow(0)
dw_ip.SetItem(1, "sfrdate", left(f_today(), 6) + '01')
dw_ip.SetItem(1, "stodate", f_today())
dw_ip.Setredraw(True)
dw_list.Setredraw(True)
dw_ip.SetFocus()

p_print.Enabled =False
p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

p_preview.enabled = False
p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'


end event

type st_5 from statictext within w_pdt_02710
integer x = 2098
integer y = 160
integer width = 544
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
string text = "조사보고서"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_pdt_02710
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 78
integer y = 512
integer width = 4530
integer height = 1716
integer cornerheight = 40
integer cornerwidth = 55
end type

