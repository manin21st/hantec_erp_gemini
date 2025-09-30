$PBExportHeader$w_pm05_00060.srw
$PBExportComments$비가동 현황(DDS)
forward
global type w_pm05_00060 from w_standard_print
end type
type rb_1 from radiobutton within w_pm05_00060
end type
type rb_2 from radiobutton within w_pm05_00060
end type
type rb_3 from radiobutton within w_pm05_00060
end type
type pb_1 from u_pb_cal within w_pm05_00060
end type
type pb_3 from u_pb_cal within w_pm05_00060
end type
type gb_1 from groupbox within w_pm05_00060
end type
type rr_2 from roundrectangle within w_pm05_00060
end type
end forward

global type w_pm05_00060 from w_standard_print
string title = "비가동 현황"
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
pb_1 pb_1
pb_3 pb_3
gb_1 gb_1
rr_2 rr_2
end type
global w_pm05_00060 w_pm05_00060

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sFrom, sTo, sPdtgu, sJocod, scode

If dw_ip.AcceptText() <> 1 Then Return -1

sFrom = Trim(dw_ip.GetItemString(1, 'pedat'))
If IsNull(sFrom) Or sFrom = '' Then
	f_message_chk(1400,'[실적일자]')
	Return -1
End If

sTo = Trim(dw_ip.GetItemString(1, 'pedatto'))
If IsNull(sTo) Or sTo = '' Then
	f_message_chk(1400,'[실적일자]')
	Return -1
End If

sPdtgu = Trim(dw_ip.GetItemString(1, 'pdtgu'))
If IsNull(sPdtgu) Or sPdtgu = '' Then sPdtgu = ''

sJocod = Trim(dw_ip.GetItemString(1, 'jocod'))
If IsNull(sJocod) Then sJocod = ''

scode = Trim(dw_ip.GetItemString(1, 'code'))

If IsNull(scode) Then scode = '%'

IF dw_print.Retrieve(gs_sabu, sFrom, sTo, sPdtgu + '%', sJocod+'%', '%') < 1 THEN
	f_message_chk(50,'')
	dw_ip.Setfocus()
	return -1
end if

dw_print.sharedata(dw_list)

// Argument 표시
String tx_name

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(pdtgu) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_pdtgu.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.GetItemString(1, 'jonam'))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_jocod.text = '"+tx_name+"'")


return 1
end function

on w_pm05_00060.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.pb_1=create pb_1
this.pb_3=create pb_3
this.gb_1=create gb_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rb_3
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.pb_3
this.Control[iCurrent+6]=this.gb_1
this.Control[iCurrent+7]=this.rr_2
end on

on w_pm05_00060.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.pb_1)
destroy(this.pb_3)
destroy(this.gb_1)
destroy(this.rr_2)
end on

event open;call super::open;string ls_today


ls_today  = f_today()

dw_ip.setitem(1,'pedat',ls_today)
dw_ip.setitem(1,'pedatto',ls_today)

end event

type p_preview from w_standard_print`p_preview within w_pm05_00060
end type

type p_exit from w_standard_print`p_exit within w_pm05_00060
end type

type p_print from w_standard_print`p_print within w_pm05_00060
end type

type p_retrieve from w_standard_print`p_retrieve within w_pm05_00060
end type







type st_10 from w_standard_print`st_10 within w_pm05_00060
end type



type dw_print from w_standard_print`dw_print within w_pm05_00060
string dataobject = "d_pm05_00060_11_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pm05_00060
integer x = 782
integer y = 20
integer width = 3150
integer height = 272
string dataobject = "d_pm05_00060_1"
end type

event dw_ip::rbuttondown;call super::rbuttondown;String sData, sname
long lrow

SetNull(gs_code)
SetNull(gs_codename)

Choose Case GetColumnName()
	 Case 'jocod'
			Open(w_jomas_popup)
			SetItem(1,'jocod',gs_code)
			SetItem(1,'jonam',gs_codename)
	 Case 'code'
			if rb_1.checked then
				sdata = this.getitemstring(1,'jocod')
				select dptno into :sname from jomast where jocod = :sdata ;
				if sqlca.sqlcode = 0 then gs_gubun = sname
				open(w_sawon_popup)
			elseif rb_2.checked then
				open(w_mchno_popup)
			else
				open(w_itemas_popup)
			end if
			
			this.setitem(1,'code',gs_code)
			this.triggerevent(itemchanged!)

End Choose
end event

event dw_ip::itemerror;call super::itemerror;RETURN 1
end event

event dw_ip::itemchanged;call super::itemchanged;String sDate, sData, sNull,sName

SetNull(sNull)

Choose Case GetColumnName()
	Case 'pedat', 'pedatto'
		sDate = Trim(GetText())
		
		If f_datechk(sDate) <> 1 Then
			f_message_chk(35,'')
			Return 1
		End If
	Case 'jocod'
		sData = this.gettext()
		Select jonam into :sName From jomast
		Where jocod = :sData;
		if sqlca.sqlcode <> 0 then
		f_message_chk(33,'[반코드]')
			setitem(1, "jocod", sNull)
			setitem(1, "jonam", sNull)
			setcolumn("jocod")
			setfocus()
			Return 1					
		End if
		setitem(1, "jonam", sName)
		
	Case 'code'
		sData = this.gettext()
		if rb_1.checked then
			select empname into :sName from p1_master where empno = :sdata ;
		elseif rb_2.checked then
			select mchnam into :sName from mchmst where mchno = :sdata ;
		else
			select itdsc into :sName from itemas where itnbr = :sdata ;
		end if

		if sqlca.sqlcode = 0 then 
			this.setitem(1,'cname',sname)
		else
			this.setitem(1,'code',sNull)
			this.setitem(1,'cname',sNull)
		end if

End Choose
end event

type dw_list from w_standard_print`dw_list within w_pm05_00060
integer x = 50
integer y = 304
integer width = 4558
integer height = 1952
string dataobject = "d_pm05_00060_11"
boolean border = false
end type

event dw_list::rowfocuschanged;call super::rowfocuschanged;if currentrow > 0 then
	selectrow(0, false)
	selectrow(currentrow, true)
else
	selectrow(0, false)
end if

end event

type rb_1 from radiobutton within w_pm05_00060
integer x = 78
integer y = 48
integer width = 521
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
string text = "부서/반별"
boolean checked = true
end type

event clicked;dw_list.DataObject = 'd_pm05_00060_11'
dw_print.DataObject = 'd_pm05_00060_11_p'
dw_list.SetTransObject(sqlca)
dw_print.SetTransObject(sqlca)

//string	snull
//
//setnull(snull)
//dw_ip.setitem(1,'code',snull)
//dw_ip.setitem(1,'cname',snull)
//dw_ip.modify("t_name.text='작업자'")
end event

type rb_2 from radiobutton within w_pm05_00060
integer x = 78
integer y = 124
integer width = 439
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
string text = "작업장별"
end type

event clicked;dw_list.DataObject = 'd_pm05_00060_12'
dw_print.DataObject = 'd_pm05_00060_12_p'
dw_list.SetTransObject(sqlca)
dw_print.SetTransObject(sqlca)

//string	snull
//setnull(snull)
//dw_ip.setitem(1,'code',snull)
//dw_ip.setitem(1,'cname',snull)
//dw_ip.modify("t_name.text='설비'")
end event

type rb_3 from radiobutton within w_pm05_00060
integer x = 78
integer y = 200
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
string text = "원인별"
end type

event clicked;dw_list.DataObject = 'd_pm05_00060_13'
dw_print.DataObject = 'd_pm05_00060_13_p'
dw_list.SetTransObject(sqlca)
dw_print.SetTransObject(sqlca)

//string	snull
//
//setnull(snull)
//dw_ip.setitem(1,'code',snull)
//dw_ip.setitem(1,'cname',snull)
//dw_ip.modify("t_name.text='품번'")
end event

type pb_1 from u_pb_cal within w_pm05_00060
integer x = 1975
integer y = 108
integer height = 76
integer taborder = 110
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('pedatto')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'pedatto', gs_code)

end event

type pb_3 from u_pb_cal within w_pm05_00060
integer x = 1495
integer y = 108
integer height = 76
integer taborder = 120
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('pedat')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'pedat', gs_code)

end event

type gb_1 from groupbox within w_pm05_00060
integer x = 55
integer y = 4
integer width = 718
integer height = 276
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
end type

type rr_2 from roundrectangle within w_pm05_00060
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 41
integer y = 296
integer width = 4581
integer height = 2024
integer cornerheight = 40
integer cornerwidth = 55
end type

