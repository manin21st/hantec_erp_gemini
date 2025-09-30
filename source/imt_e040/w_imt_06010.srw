$PBExportHeader$w_imt_06010.srw
$PBExportComments$** 업체협력도
forward
global type w_imt_06010 from w_inherite
end type
type gb_33 from groupbox within w_imt_06010
end type
type gb_3 from groupbox within w_imt_06010
end type
type gb_2 from groupbox within w_imt_06010
end type
type gb_1 from groupbox within w_imt_06010
end type
type dw_list from u_key_enter within w_imt_06010
end type
type dw_ins from datawindow within w_imt_06010
end type
type dw_1 from datawindow within w_imt_06010
end type
type gb_11 from groupbox within w_imt_06010
end type
end forward

global type w_imt_06010 from w_inherite
integer height = 2400
string title = "업체 협력도"
gb_33 gb_33
gb_3 gb_3
gb_2 gb_2
gb_1 gb_1
dw_list dw_list
dw_ins dw_ins
dw_1 dw_1
gb_11 gb_11
end type
global w_imt_06010 w_imt_06010

forward prototypes
public function integer wf_required_chk ()
end prototypes

public function integer wf_required_chk ();//필수입력항목 체크
Long i, findrow
sle_msg.Text = ""

if dw_insert.AcceptText() = -1 then
	if dw_insert.RowCount() >= 1 then dw_insert.SetFocus()
	sle_msg.Text = "자료를 정확하게 입력하세요!"
	return -1
end if	


for i = 1 to dw_insert.RowCount()
	if dw_insert.object.hcnt[i] > 0 then
		findrow = dw_ins.Find("cvcod = '"+ dw_insert.object.vcvcod[i] + "'", 1, dw_ins.RowCount())
		if findrow = 0 then findrow = dw_ins.InsertRow(0)
		dw_ins.object.sabu[findrow] = gs_sabu
		dw_ins.object.hyymm[findrow] = dw_list.object.hyymm[1]
		dw_ins.object.cvcod[findrow] = dw_insert.object.vcvcod[i]
		dw_ins.object.hcnt[findrow] = dw_insert.object.hcnt[i]
	end if
next
if dw_ins.AcceptText() = 1 then
	return 1
else
	sle_msg.Text = "자료를 정확하게 입력하세요!"
	return -1
end if	
end function

on w_imt_06010.create
int iCurrent
call super::create
this.gb_33=create gb_33
this.gb_3=create gb_3
this.gb_2=create gb_2
this.gb_1=create gb_1
this.dw_list=create dw_list
this.dw_ins=create dw_ins
this.dw_1=create dw_1
this.gb_11=create gb_11
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_33
this.Control[iCurrent+2]=this.gb_3
this.Control[iCurrent+3]=this.gb_2
this.Control[iCurrent+4]=this.gb_1
this.Control[iCurrent+5]=this.dw_list
this.Control[iCurrent+6]=this.dw_ins
this.Control[iCurrent+7]=this.dw_1
this.Control[iCurrent+8]=this.gb_11
end on

on w_imt_06010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_33)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.dw_list)
destroy(this.dw_ins)
destroy(this.dw_1)
destroy(this.gb_11)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)
dw_ins.SetTransObject(SQLCA)
dw_insert.SetTransObject(SQLCA)

dw_1.retrieve(gs_sabu)
dw_insert.ReSet()
dw_list.SetTransObject(SQLCA)
dw_list.ReSet()
dw_list.InsertRow(0)
dw_list.SetFocus()



end event

type dw_insert from w_inherite`dw_insert within w_imt_06010
integer x = 1815
integer y = 268
integer width = 1755
integer height = 1568
integer taborder = 70
string dataobject = "d_imt_06010_02"
boolean vscrollbar = true
boolean border = true
borderstyle borderstyle = stylelowered!
end type

event dw_insert::itemerror;RETURN 1
end event

event dw_insert::itemchanged;call super::itemchanged;sle_msg.Text = ""
end event

type cb_exit from w_inherite`cb_exit within w_imt_06010
integer x = 3232
integer y = 1948
integer taborder = 100
end type

type cb_mod from w_inherite`cb_mod within w_imt_06010
integer x = 2181
integer y = 1940
integer taborder = 80
end type

event cb_mod::clicked;call super::clicked;SetPointer(HourGlass!)

IF dw_insert.RowCount() < 1			THEN 	RETURN 
IF dw_insert.AcceptText() = -1	THEN	RETURN

if f_msg_update() = -1 then return

if wf_required_chk() = -1 then return //필수입력항목 체크 

IF dw_ins.Update() > 0 THEN		
	COMMIT;
	sle_msg.Text = "저장 되었습니다!"
ELSE
	ROLLBACK;
	f_message_chk(32, "[저장실패]")
	sle_msg.Text = "저장작업 실패!"
END IF

ib_any_typing = False //입력필드 변경여부 No
end event

type cb_ins from w_inherite`cb_ins within w_imt_06010
integer x = 69
integer y = 1944
string text = "추가(&A)"
end type

event cb_ins::clicked;call super::clicked;IF dw_1.AcceptText() = -1	THEN	RETURN

long		lRow

lRow = dw_1.InsertRow(0)

dw_1.ScrollToRow(lRow)
dw_1.SetColumn("cvcod")
dw_1.SetFocus()


end event

type cb_del from w_inherite`cb_del within w_imt_06010
integer x = 416
integer y = 1944
end type

event cb_del::clicked;call super::clicked;long	lrow
lRow = dw_1.GetRow()

IF lRow < 1		THEN	RETURN

IF f_msg_delete() = -1 THEN	RETURN

dw_1.DeleteRow(lRow)


end event

type cb_inq from w_inherite`cb_inq within w_imt_06010
integer x = 1833
integer y = 1940
integer taborder = 60
end type

event cb_inq::clicked;call super::clicked;String hyymm, gubun, cvcod1, cvcod2

if dw_list.AcceptText()  = -1 then return 

hyymm = Trim(dw_list.object.hyymm[1])
cvcod1 = Trim(dw_list.object.cvcod1[1])
cvcod2 = Trim(dw_list.object.cvcod2[1])
gubun = Trim(dw_list.object.gubun[1])

IF IsNull(hyymm) or hyymm = ''	THEN
	f_message_chk(30, "[기준년월]")
	dw_list.SetColumn("hyymm")
	dw_list.SetFocus()
	RETURN
END IF
IF IsNull(cvcod1) or cvcod1 = ''	THEN cvcod1 = "."
IF IsNull(cvcod2) or cvcod2 = ''	THEN cvcod2 = "ZZZZZZ"

dw_insert.SetRedraw(False)

dw_insert.SetFilter("")
if gubun = "1" then //매출
   dw_insert.SetFilter("saleyn = 'Y'")
elseif gubun = "2" then //구매
   dw_insert.SetFilter("gumaeyn = 'Y' AND exprice = 1")
elseif gubun = "3" then //외주
   dw_insert.SetFilter("oyjuyn = 'Y'")
elseif gubun = "4" then //외주가공
   dw_insert.SetFilter("oyjugayn = 'Y'")
elseif gubun = "5" then //용역
   dw_insert.SetFilter("yongyn = 'Y'")
end if
dw_insert.Filter( )

if dw_insert.Retrieve(gs_sabu, hyymm, cvcod1, cvcod2) < 1 then
	f_message_chk(50, "[해당하는 거래처코드가 없습니다!]")
else
	dw_ins.Retrieve(gs_sabu, hyymm, cvcod1, cvcod2)
end if	
dw_insert.SetRedraw(True)

end event

type cb_print from w_inherite`cb_print within w_imt_06010
integer x = 763
integer y = 1944
integer taborder = 40
string text = "저장(&U)"
end type

event cb_print::clicked;call super::clicked;SetPointer(HourGlass!)

IF dw_1.RowCount() < 1			THEN 	RETURN 
IF dw_1.AcceptText() = -1	THEN	RETURN

string  scvcod 
long    k, lcount

lcount = dw_1.rowcount()

FOR k = 1 TO lcount
	scvcod = dw_1.GetItemString(k, "cvcod")
	IF IsNull(scvcod) 	or   scvcod = ''	THEN
		f_message_chk(30,'[거래처]')		
		dw_1.ScrollToRow(k)
		dw_1.SetColumn("cvcod")
		dw_1.SetFocus()
		RETURN 
	END IF
   dw_1.setitem(k , 'sabu', gs_sabu)
NEXT

/////////////////////////////////////////////////////////////////////////
IF f_msg_update() = -1 		THEN	RETURN

IF dw_1.Update() > 0		THEN
	COMMIT;
ELSE
	ROLLBACK;
	f_Rollback()
END IF

dw_1.retrieve(gs_sabu)


end event

type st_1 from w_inherite`st_1 within w_imt_06010
end type

type cb_can from w_inherite`cb_can within w_imt_06010
integer x = 2875
integer y = 1948
integer taborder = 90
end type

event cb_can::clicked;call super::clicked;dw_1.retrieve(gs_sabu)
dw_insert.reset()

sle_msg.text = ''
ib_any_typing = False //입력필드 변경여부 No


end event

type cb_search from w_inherite`cb_search within w_imt_06010
boolean visible = false
integer x = 1198
integer y = 2420
integer width = 667
integer height = 192
integer taborder = 0
string text = "승인 및 의견 등록"
end type





type gb_10 from w_inherite`gb_10 within w_imt_06010
integer y = 2080
integer height = 140
integer textsize = -8
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_imt_06010
end type

type gb_button2 from w_inherite`gb_button2 within w_imt_06010
end type

type gb_33 from groupbox within w_imt_06010
integer x = 1787
integer y = 16
integer width = 1815
integer height = 1844
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 67108864
string text = "업체 협력도 등록"
borderstyle borderstyle = stylelowered!
end type

type gb_3 from groupbox within w_imt_06010
integer x = 27
integer y = 16
integer width = 1737
integer height = 1844
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 67108864
string text = "주요 협력업체 등록"
borderstyle borderstyle = stylelowered!
end type

type gb_2 from groupbox within w_imt_06010
integer x = 1787
integer y = 1872
integer width = 768
integer height = 208
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 67108864
string text = "업체 협력도"
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_imt_06010
integer x = 2834
integer y = 1884
integer width = 768
integer height = 196
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type dw_list from u_key_enter within w_imt_06010
event ue_key pbm_dwnkey
integer x = 1879
integer y = 76
integer width = 1714
integer height = 188
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_imt_06010_01"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
end if	
end event

event itemchanged;String  s_cod, s_nam1, s_nam2
Integer i_rtn

s_cod = Trim(this.GetText())

if this.getcolumnname() = 'cvcod1' then //거래처코드(FROM)  
	i_rtn = f_get_name2("V1", "N", s_cod, s_nam1, s_nam2)
	this.object.cvcod1[1] = s_cod
	return i_rtn
elseif this.getcolumnname() = 'cvcod2' then //거래처코드(TO)  
	i_rtn = f_get_name2("V1", "N", s_cod, s_nam1, s_nam2)
	this.object.cvcod2[1] = s_cod
	return i_rtn
elseif this.GetColumnName() = "hyymm" then
	s_cod = Trim(this.GetText())
	if IsNull(s_cod) or s_cod = "" then
		return
	end if
	
	if f_datechk(s_cod + '01') = -1 then
		f_message_chk(35, "[기준년월]")
		this.object.hyymm[1] = ""
		return 1
	end if
end if

end event

event itemerror;return 1
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

IF	this.getcolumnname() = "cvcod1"	THEN		
	open(w_vndmst_popup)
	this.SetItem(1, "cvcod1", gs_code)
elseif this.getcolumnname() = "cvcod2"	then
	open(w_vndmst_popup)
	this.SetItem(1, "cvcod2", gs_code)
end if

return
end event

event getfocus;call super::getfocus;dw_insert.SetReDraw(False)
dw_insert.ReSet()
dw_insert.SetReDraw(True)
end event

type dw_ins from datawindow within w_imt_06010
boolean visible = false
integer x = 2203
integer y = 2264
integer width = 763
integer height = 660
boolean bringtotop = true
string dataobject = "d_imt_06010_03"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_1 from datawindow within w_imt_06010
integer x = 55
integer y = 80
integer width = 1682
integer height = 1756
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_imt_06010_04"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemerror;return 1
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

IF	this.getcolumnname() = "cvcod"	THEN		
	gs_gubun ='1'
	open(w_vndmst_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.SetItem(row, "cvcod", gs_code)
	this.SetItem(row, "vndmst_cvnas2", gs_codename)
	return
end if	
end event

event itemchanged;string s_cod, s_nam1, s_nam2, snull
int    i_rtn
long   lrow, lreturnrow

setnull(snull)

if this.GetColumnName() = "cvcod" then	
   s_cod = Trim(this.GetText())
   lRow  = this.getrow()
	lReturnRow = This.Find("cvcod = '"+s_cod+"' ", 1, This.RowCount())
	
	IF (lRow <> lReturnRow) and (lReturnRow <> 0)		THEN
		f_message_chk(37,'[거래처코드]') 
		this.SetItem(lRow, "cvcod", sNull)
		RETURN  1
	END IF
	i_rtn = f_get_name2("V1", "Y", s_cod, s_nam1, s_nam2)
	this.object.cvcod[lrow] = s_cod
	this.object.vndmst_cvnas2[lrow] = s_nam1
	return i_rtn
end if
end event

type gb_11 from groupbox within w_imt_06010
integer x = 23
integer y = 1872
integer width = 1115
integer height = 208
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 67108864
string text = "주요 협력업체"
borderstyle borderstyle = stylelowered!
end type

