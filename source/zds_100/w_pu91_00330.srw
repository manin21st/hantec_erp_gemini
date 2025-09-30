$PBExportHeader$w_pu91_00330.srw
$PBExportComments$mro 발주 대비 입고 현황
forward
global type w_pu91_00330 from w_standard_print
end type
type rb_1 from radiobutton within w_pu91_00330
end type
type rb_2 from radiobutton within w_pu91_00330
end type
type rb_3 from radiobutton within w_pu91_00330
end type
type gb_1 from groupbox within w_pu91_00330
end type
type rr_1 from roundrectangle within w_pu91_00330
end type
end forward

global type w_pu91_00330 from w_standard_print
string title = "소모품 발주 대비 입고 현황"
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
gb_1 gb_1
rr_1 rr_1
end type
global w_pu91_00330 w_pu91_00330

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String ls_sdate ,ls_edate ,ls_depot ,ls_gubun
String ls_sitcls , ls_eitcls

IF dw_ip.AcceptText() = -1 THEN RETURN -1

ls_sdate  = Trim(dw_ip.Object.sdate[1])
ls_edate  = Trim(dw_ip.Object.edate[1])
ls_depot   = Trim(dw_ip.Object.depot[1])

If rb_1.Checked Then
	ls_gubun  = "8"
ElseIf rb_2.Checked Then
	ls_gubun  = "9"
Else
	ls_gubun  = "%%"
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

If ls_depot = '' Or isNull(ls_depot) Then 
	f_message_chk(1400,'[담당부서]')
	dw_ip.SetFocus()
	dw_ip.SetColumn("deptcode")
	Return -1
End If

if dw_print.Retrieve(gs_sabu,ls_sdate ,ls_edate ,ls_depot ,ls_gubun) <= 0 then
	f_message_chk(50,'[MOR 발주 대비 입고 현황]')
	dw_ip.Setfocus()
	return -1
Else
	dw_print.Object.t_deptname.Text = Trim(dw_ip.Object.deptname[1])
	
end if

Return 1

end function

on w_pu91_00330.create
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

on w_pu91_00330.destroy
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


String	sdeptcode, sdeptname

Select deptcode, fun_get_dptno(deptcode)
  into :sdeptcode, :sdeptname
  from p1_master
 where empno = :gs_empno ;

If SQLCA.SQLCODE <> 0 Then Return

dw_ip.Object.deptcode[1] = sdeptcode
dw_ip.Object.deptname[1] = sdeptname

string	sdepot

select cvcod into :sdepot from vndmst
 where cvgu = '5' and deptcode = :sdeptcode and juprod = 'Z' ;

if sqlca.sqlcode = 0 then
	dw_ip.setitem(1,'depot',sdepot)
end if
end event

type p_preview from w_standard_print`p_preview within w_pu91_00330
end type

type p_exit from w_standard_print`p_exit within w_pu91_00330
end type

type p_print from w_standard_print`p_print within w_pu91_00330
end type

type p_retrieve from w_standard_print`p_retrieve within w_pu91_00330
end type







type st_10 from w_standard_print`st_10 within w_pu91_00330
end type



type dw_print from w_standard_print`dw_print within w_pu91_00330
string dataobject = "d_pu91_00330_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pu91_00330
integer x = 23
integer y = 32
integer width = 1819
integer height = 244
string dataobject = "d_pu91_00330_1"
end type

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::itemchanged;string  snull,  sdate ,s_cod ,s_nam1
int     ireturn 
setnull(snull)


IF this.GetColumnName() = "sdate"	THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[기준일자 FROM]')
		this.setitem(1, "sdate", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = "edate"	THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[기준일자 TO]')
		this.setitem(1, "edate", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = 'deptcode' THEN
	s_cod  = TRIM(this.gettext())
	
	If s_cod = '' Or isNull(s_cod) Then 
		This.Object.deptcode[1] = ''
		This.Object.deptname[1] = ''
		Return 1
	Else
		Select cvnas Into :s_nam1 
		  From VNDMST
		 where cvcod = :s_cod ;
			
		If SQLCA.SQLCODE <> 0 Then
			This.Object.deptcode[1] = ''
			This.Object.deptname[1] = ''
			Return 1
		Else
			This.Object.deptname[1] = s_nam1
		End If
			
		string	sdepot
			
		select cvcod into :sdepot from vndmst
		 where cvgu = '5' and deptcode = :s_cod and juprod = 'Z' ;
			
		if sqlca.sqlcode = 0 then
			This.setitem(1,'depot',sdepot)
		Else
			This.Object.deptcode[1] = ''
			This.Object.deptname[1] = ''
			This.Object.depot[1] = ''
			MessageBox('확인','해당 부서는 등록된 MRO구매부서가 아닙니다.')
			Return 1
		end if	
		
	End If
End If 

end event

event dw_ip::rbuttondown;setnull(gs_gubun)
setnull(gs_code)
setnull(gs_codename)

If this.GetColumnName() = "deptcode" then
	gs_gubun = '1' 
	open(w_vndmst_4_popup)
	IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	this.object.deptcode[1] = gs_code
	TriggerEvent("itemchanged")
END IF
	



end event

type dw_list from w_standard_print`dw_list within w_pu91_00330
integer x = 41
integer y = 296
integer width = 4539
string dataobject = "d_pu91_00330_a"
boolean border = false
end type

type rb_1 from radiobutton within w_pu91_00330
boolean visible = false
integer x = 1966
integer y = 128
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
string text = "정기"
end type

event clicked;p_retrieve.TriggerEvent(Clicked!)
end event

type rb_2 from radiobutton within w_pu91_00330
boolean visible = false
integer x = 2354
integer y = 128
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
boolean checked = true
end type

event clicked;p_retrieve.TriggerEvent(Clicked!)
end event

type rb_3 from radiobutton within w_pu91_00330
boolean visible = false
integer x = 2770
integer y = 128
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
string text = "전체"
end type

event clicked;p_retrieve.TriggerEvent(Clicked!)
end event

type gb_1 from groupbox within w_pu91_00330
boolean visible = false
integer x = 1874
integer y = 44
integer width = 1253
integer height = 192
integer taborder = 10
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "구분"
end type

type rr_1 from roundrectangle within w_pu91_00330
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 288
integer width = 4581
integer height = 2048
integer cornerheight = 40
integer cornerwidth = 55
end type

