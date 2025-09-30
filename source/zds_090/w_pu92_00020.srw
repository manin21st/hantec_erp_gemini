$PBExportHeader$w_pu92_00020.srw
$PBExportComments$발주 대비 입고 현황(품목별)
forward
global type w_pu92_00020 from w_standard_print
end type
type rb_1 from radiobutton within w_pu92_00020
end type
type rb_2 from radiobutton within w_pu92_00020
end type
type rb_3 from radiobutton within w_pu92_00020
end type
type gb_1 from groupbox within w_pu92_00020
end type
type rr_1 from roundrectangle within w_pu92_00020
end type
end forward

global type w_pu92_00020 from w_standard_print
string title = "발주 대비 입고 현황(품목별)"
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
gb_1 gb_1
rr_1 rr_1
end type
global w_pu92_00020 w_pu92_00020

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String ls_sdate ,ls_edate ,ls_deptcode , ls_depot ,ls_gubun 
String ls_itnbr1 , ls_itnbr2

IF dw_ip.AcceptText() = -1 THEN RETURN -1

ls_sdate  = Trim(dw_ip.Object.sdate[1])
ls_edate  = Trim(dw_ip.Object.edate[1])

ls_deptcode  = Trim(dw_ip.Object.deptcode[1])
ls_depot     = Trim(dw_ip.Object.depot[1])

ls_itnbr1 = Trim(dw_ip.Object.itnbr1[1])
ls_itnbr2 = Trim(dw_ip.Object.itnbr2[1])

If rb_1.Checked Then
	ls_gubun  = "1"
ElseIf rb_2.Checked Then
	ls_gubun  = "11"
Else
	ls_gubun  = "3"
End if
	
If ls_sdate = '' Or isNull(ls_sdate) Or f_dateChk(ls_sdate) < 1 Then
	f_message_chk(35,'[기준일자]')
	dw_ip.SetFocus()
	dw_ip.SetColumn("sdate")
	Return -1
end If

If ls_edate = '' Or isNull(ls_edate) Or f_dateChk(ls_edate) < 1 Then
	f_message_chk(35,'[기준일자]')
	dw_ip.SetFocus()
	dw_ip.SetColumn("edate")
	Return -1
end If

If ls_sdate > ls_edate Then
   MessageBox('확인','날짜 범위지정에 벗어납니다.')
	dw_ip.Object.edate[1] = ''
	dw_ip.SetFocus()
	dw_ip.SetColumn("sdate")
	Return -1
end If

If ls_deptcode = '' Or isNull(ls_deptcode) Then 
	f_message_chk(1400,'[팀구분]')
	dw_ip.SetFocus()
	dw_ip.SetColumn("deptcode")
	Return -1
End If

If ls_itnbr1 = '' Or isNull(ls_itnbr1) Then ls_itnbr1 = '.'
If ls_itnbr2 = '' Or isNull(ls_itnbr2) Then ls_itnbr2 = 'zzzzzzzzzzzzzzz'

If dw_print.Retrieve(gs_sabu,ls_sdate ,ls_edate ,ls_depot ,ls_itnbr1 , ls_itnbr2 ,ls_gubun) <= 0 then
	f_message_chk(50,'[발주 대비 입고 현황(품목별)]')
	dw_ip.Setfocus()
	Return -1

End If

Return 1

end function

on w_pu92_00020.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.gb_1=create gb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rb_3
this.Control[iCurrent+4]=this.gb_1
this.Control[iCurrent+5]=this.rr_1
end on

on w_pu92_00020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.gb_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.Object.sdate[1] = f_afterday(is_today , -30)
dw_ip.Object.edate[1] = is_today




end event

type p_preview from w_standard_print`p_preview within w_pu92_00020
end type

type p_exit from w_standard_print`p_exit within w_pu92_00020
end type

type p_print from w_standard_print`p_print within w_pu92_00020
end type

type p_retrieve from w_standard_print`p_retrieve within w_pu92_00020
end type







type st_10 from w_standard_print`st_10 within w_pu92_00020
end type



type dw_print from w_standard_print`dw_print within w_pu92_00020
string dataobject = "d_pu92_00020_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pu92_00020
integer x = 27
integer y = 32
integer width = 3232
integer height = 344
string dataobject = "d_pu92_00020_1"
end type

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::itemchanged;string  snull,  sdate ,s_cod ,s_nam1
int     ireturn 
setnull(snull)


IF this.GetColumnName() = "sdate"	THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) Or f_dateChk(sdate) < 1 then	
		f_message_chk(35, '[기준일자 FROM]')
		this.setitem(1, "sdate", sNull)
		return 1
	End If

  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[기준일자 FROM]')
		this.setitem(1, "sdate", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = "edate"	THEN
	sdate = trim(this.GetText())
	if sdate = "" or isnull(sdate) Or f_dateChk(sdate) < 1 then	
		f_message_chk(35, '[기준일자 TO]')
		this.setitem(1, "sdate", sNull)
		return 1
	End If
	
  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[기준일자 TO]')
		this.setitem(1, "edate", sNull)
		return 1
	END IF

ELSEIF this.GetColumnName() = "deptcode"	THEN
	s_cod = trim(this.GetText())
	
//	select cvcod  Into :s_nam1
//	  from vndmst 
//	 where cvgu = '5'
//	   and soguan = '3'
//	   and jumaeip  = :s_cod ;

	// 입고창고는 생산창고
	s_nam1 = 'Z30'

	If SQLCA.SQLCODE <> 0 Then
		f_message_chk(33 , "[팀구분]")
		This.Object.deptcode[1] = ''
		Return 1
	Else
		This.Object.depot[1] = s_nam1
	End If
	
ElseIf this.GetColumnName() = "itnbr1"	THEN
	s_cod = trim(this.GetText())
	
	Select itdsc Into :s_nam1
	  From ITEMAS
	 Where itnbr = :s_cod ;
	If SQLCA.SQLCODE <> 0 then
		f_message_chk(33 , "[품고]")
		This.Object.itnbr1[1] = ""
		This.Object.itdsc1[1] = ""
		Return 1
	Else
		This.Object.itdsc1[1] = s_nam1
	End If

ElseIf this.GetColumnName() = "itnbr2"	THEN
	s_cod = trim(this.GetText())
	
	Select itdsc Into :s_nam1
	  From ITEMAS
	 Where itnbr = :s_cod ;
	 
	If SQLCA.SQLCODE <> 0 then
		f_message_chk(33 , "[품고]")
		This.Object.itnbr2[1] = ""
		This.Object.itdsc2[1] = ""
		Return 1
	Else
		This.Object.itdsc2[1] = s_nam1
	End If
	
	
End If 

end event

event dw_ip::rbuttondown;setnull(gs_gubun)
setnull(gs_code)
setnull(gs_codename)

If this.GetColumnName() = "itnbr1" then
	gs_gubun = '1' 
	open(w_itemas_popup)
	IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	this.object.itnbr1[1] = gs_code
	TriggerEvent("itemchanged")
	
ElseIf this.GetColumnName() = "itnbr2" then
	gs_gubun = '1' 
	open(w_itemas_popup)
	IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	this.object.itnbr2[1] = gs_code
	TriggerEvent("itemchanged")
	
END IF
	



end event

type dw_list from w_standard_print`dw_list within w_pu92_00020
integer x = 41
integer y = 388
integer width = 4539
integer height = 1860
string dataobject = "d_pu92_00020_a"
boolean border = false
end type

type rb_1 from radiobutton within w_pu92_00020
integer x = 3378
integer y = 248
integer width = 302
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "구매"
boolean checked = true
end type

event clicked;p_retrieve.TriggerEvent(Clicked!)
end event

type rb_2 from radiobutton within w_pu92_00020
boolean visible = false
integer x = 3680
integer y = 164
integer width = 302
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "부정기"
end type

event clicked;p_retrieve.TriggerEvent(Clicked!)
end event

type rb_3 from radiobutton within w_pu92_00020
integer x = 3680
integer y = 248
integer width = 265
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "외주"
end type

event clicked;p_retrieve.TriggerEvent(Clicked!)
end event

type gb_1 from groupbox within w_pu92_00020
integer x = 3291
integer y = 176
integer width = 1125
integer height = 172
integer taborder = 10
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "입고구분"
end type

type rr_1 from roundrectangle within w_pu92_00020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 384
integer width = 4581
integer height = 1880
integer cornerheight = 40
integer cornerwidth = 55
end type

