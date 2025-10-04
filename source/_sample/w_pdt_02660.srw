$PBExportHeader$w_pdt_02660.srw
$PBExportComments$공정재고현황
forward
global type w_pdt_02660 from w_standard_print
end type
type rb_1 from radiobutton within w_pdt_02660
end type
type rb_2 from radiobutton within w_pdt_02660
end type
type gb_5 from groupbox within w_pdt_02660
end type
type rr_1 from roundrectangle within w_pdt_02660
end type
end forward

global type w_pdt_02660 from w_standard_print
string title = "공정재고/작지취소 현황"
rb_1 rb_1
rb_2 rb_2
gb_5 gb_5
rr_1 rr_1
end type
global w_pdt_02660 w_pdt_02660

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string itnbr1, itnbr2, pdtgu, wkctr1, wcdsc1, wkctr2, wcdsc2
String sDatef, sDatet, sPdtgu, tx_name

if dw_ip.AcceptText() <> 1 then return -1

/* 공정재고 현황 */
If rb_1.Checked = True Then
	itnbr1 = Trim(dw_ip.object.itnbr1[1])
	itnbr1 = Trim(dw_ip.object.itnbr1[1])
	pdtgu = Trim(dw_ip.object.pdtgu[1])
	wkctr1 = Trim(dw_ip.object.wkctr1[1])
	wcdsc1 = Trim(dw_ip.object.wcdsc1[1])
	wkctr2 = Trim(dw_ip.object.wkctr2[1])
	wcdsc2 = Trim(dw_ip.object.wcdsc2[1])
	
	if IsNull(itnbr1) or itnbr1 = "" then itnbr1 = "."
	if IsNull(itnbr2) or itnbr2 = "" then itnbr2 = "ZZZZZZZZZZZZZZZ"
	if IsNull(pdtgu) or pdtgu = "" then pdtgu = "%"
	if IsNull(wkctr1) or wkctr1 = "" then wkctr1 = "."
	if IsNull(wcdsc1) or wcdsc1 = "" then wcdsc1 = " "
	if IsNull(wkctr2) or wkctr2 = "" then wkctr2 = "ZZZZZZ"
	if IsNull(wcdsc2) or wcdsc2 = "" then wcdsc2 = " "
	
	dw_print.object.txt_wkctr.text = wcdsc1 + " - " + wcdsc2
	IF dw_print.Retrieve(gs_sabu, itnbr1, itnbr2, pdtgu, wkctr1, wkctr2) <=0 THEN
		f_message_chk(50,'')
		dw_ip.setcolumn('itnbr1')
		dw_ip.SetFocus()
		Return -1
	END IF
Else
/* 작지취소 현황 */
	sDatef = dw_ip.GetItemString(1, 'frdate')
	If f_datechk(sdatef) <> 1 Then
		f_message_chk(35,'[지시기간]')
		Return -1
	End If
	
	sDatet = dw_ip.GetItemString(1, 'todate')
	If f_datechk(sdatet) <> 1 Then
		f_message_chk(35,'[지시기간]')
		Return -1
	End If
	
	sPdtgu = dw_ip.GetItemString(1, 'pdtgu')
	If IsNull(sPdtgu) Then sPdtgu = ''
	
	IF dw_print.Retrieve(gs_sabu, sDatef, sDatet, sPdtgu+'%') <=0 THEN
		f_message_chk(50,'')
		dw_ip.setcolumn('frdate')
		dw_ip.SetFocus()
		Return -1
	END IF
	
	tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(pdtgu) ', 1)"))
	If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
	dw_print.Modify("txt_pdtgu.text = '"+tx_name+"'")	
End If

dw_print.sharedata(dw_list)
Return 1

end function

on w_pdt_02660.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_5=create gb_5
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.gb_5
this.Control[iCurrent+4]=this.rr_1
end on

on w_pdt_02660.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_5)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.Setfocus()

end event

type p_preview from w_standard_print`p_preview within w_pdt_02660
integer taborder = 40
end type

type p_exit from w_standard_print`p_exit within w_pdt_02660
integer taborder = 70
end type

type p_print from w_standard_print`p_print within w_pdt_02660
integer taborder = 50
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_02660
integer taborder = 30
end type











type dw_print from w_standard_print`dw_print within w_pdt_02660
string dataobject = "d_pdt_02660_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_02660
integer x = 713
integer y = 68
integer width = 3008
integer height = 192
string dataobject = "d_pdt_02660_0"
end type

event dw_ip::itemerror;Return 1
end event

event dw_ip::rbuttondown;SetNull(Gs_gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

IF this.GetColumnName() ="itnbr1" THEN
	Open(w_itemas_popup3)
	
	if gs_code = '' or isnull(gs_code) then return 
	
	this.object.itnbr1[1] = gs_code
	this.object.itdsc1[1] = gs_codename
	Return
ELSEIF this.GetColumnName() ="itnbr2" THEN
	Open(w_itemas_popup3)
	if gs_code = '' or isnull(gs_code) then return 
	this.object.itnbr2[1] = gs_code
	this.object.itdsc2[1] = gs_codename
	Return
ELSEIF this.GetColumnName() ="wkctr1" THEN
	Open(w_workplace_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.object.wkctr1[1] = gs_code
	this.object.wcdsc1[1] = gs_codename
	Return
ELSEIF this.GetColumnName() ="wkctr2" THEN
	Open(w_workplace_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.object.wkctr2[1] = gs_code
	this.object.wcdsc2[1] = gs_codename
	Return
END IF

end event

event dw_ip::itemchanged;call super::itemchanged;string s_cod, s_nam1, s_nam2
integer i_rtn
String sDate, sNull

SetNull(snull)

s_cod = Trim(this.GetText())

if this.GetColumnName() = "itnbr1" then
	i_rtn = f_get_name2("품번", "N", s_cod, s_nam1, s_nam2)
	this.object.itnbr1[1] = s_cod
	this.object.itdsc1[1] = s_nam1
	return i_rtn
elseif this.GetColumnName() = "itnbr2" then	
	i_rtn = f_get_name2("품번", "N", s_cod, s_nam1, s_nam2)
	this.object.itnbr2[1] = s_cod
	this.object.itdsc2[1] = s_nam1
	return i_rtn
elseif this.GetColumnName() = "wkctr1" then	
	i_rtn = f_get_name2("작업장", "N", s_cod, s_nam1, s_nam2)
	this.object.wkctr1[1] = s_cod
	this.object.wcdsc1[1] = s_nam1
	return i_rtn
elseif this.GetColumnName() = "wkctr2" then	
	i_rtn = f_get_name2("작업장", "N", s_cod, s_nam1, s_nam2)
	this.object.wkctr2[1] = s_cod
	this.object.wcdsc2[1] = s_nam1
	return i_rtn
elseif this.GetColumnName() = "frdate" then
	sDate = Trim(this.GetText())
	IF sDate ="" OR IsNull(sDate) THEN RETURN
	
	IF f_datechk(sdate) = -1 THEN
		f_message_chk(35,'[지시기간]')
		this.SetItem(1,"frdate",sNull)
		Return 1
	END IF
elseif this.GetColumnName() = "todate" then
	sDate = Trim(this.GetText())
	IF sDate ="" OR IsNull(sDate) THEN RETURN
	
	IF f_datechk(sdate) = -1 THEN
		f_message_chk(35,'[지시기간]')
		this.SetItem(1,"todate",sNull)
		Return 1
	END IF
end if	

return 
end event

type dw_list from w_standard_print`dw_list within w_pdt_02660
integer x = 91
integer y = 368
integer width = 4494
integer height = 1924
string dataobject = "d_pdt_02660_1"
boolean border = false
boolean hsplitscroll = false
end type

type rb_1 from radiobutton within w_pdt_02660
integer x = 169
integer y = 144
integer width = 517
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "공정 재고 현황"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;
dw_ip.SetRedraw(False)
dw_ip.DataObject = 'd_pdt_02660_0'
dw_ip.InsertRow(0)
dw_ip.SetRedraw(True)

dw_print.SetRedraw(False)
dw_list.DataObject = 'd_pdt_02660_1'
dw_print.DataObject = 'd_pdt_02660_1_p'
dw_list.SetTransObject(sqlca)
dw_print.SetTransObject(sqlca)
dw_print.SetRedraw(True)


p_print.Enabled =False
p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

p_preview.enabled = False
p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'

end event

type rb_2 from radiobutton within w_pdt_02660
integer x = 169
integer y = 228
integer width = 517
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "작지 취소 현황"
borderstyle borderstyle = stylelowered!
end type

event clicked;dw_ip.SetRedraw(False)
dw_ip.DataObject = 'd_pdt_02660_2'
dw_ip.InsertRow(0)
dw_ip.SetRedraw(True)

dw_print.SetRedraw(False)
dw_list.DataObject = 'd_pdt_02660_3'
dw_print.DataObject = 'd_pdt_02660_3_p'
dw_list.SetTransObject(sqlca)
dw_print.SetTransObject(sqlca)
dw_print.SetRedraw(True)

dw_ip.SetFocus()
dw_ip.SetColumn('frdate')

p_print.Enabled =False
p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

p_preview.enabled = False
p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'

end event

type gb_5 from groupbox within w_pdt_02660
integer x = 78
integer y = 64
integer width = 631
integer height = 272
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "출력구분"
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_pdt_02660
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 82
integer y = 360
integer width = 4521
integer height = 1948
integer cornerheight = 40
integer cornerwidth = 55
end type

