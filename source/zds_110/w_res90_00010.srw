$PBExportHeader$w_res90_00010.srw
$PBExportComments$EO 현황
forward
global type w_res90_00010 from w_standard_print
end type
type rb_1 from radiobutton within w_res90_00010
end type
type rb_2 from radiobutton within w_res90_00010
end type
type p_1 from picture within w_res90_00010
end type
type gb_1 from groupbox within w_res90_00010
end type
type rr_1 from roundrectangle within w_res90_00010
end type
type dw_1 from datawindow within w_res90_00010
end type
type rb_3 from radiobutton within w_res90_00010
end type
type rb_4 from radiobutton within w_res90_00010
end type
type gb_2 from groupbox within w_res90_00010
end type
end forward

global type w_res90_00010 from w_standard_print
string title = "EO 현항"
rb_1 rb_1
rb_2 rb_2
p_1 p_1
gb_1 gb_1
rr_1 rr_1
dw_1 dw_1
rb_3 rb_3
rb_4 rb_4
gb_2 gb_2
end type
global w_res90_00010 w_res90_00010

type prototypes



end prototypes

type variables
boolean lb_src_down, lb_dsc_down
String s_row
end variables

forward prototypes
public function integer wf_retrieve ()
public subroutine wf_chg ()
end prototypes

public function integer wf_retrieve ();String ls_sitnbr , ls_eitnbr , ls_sitdsc, ls_eitdsc 

If dw_ip.AcceptText() = -1 Then 
	dw_ip.SetFocus()
	Return -1
End if	

ls_sitnbr = Trim(dw_ip.Object.sitnbr[1])
ls_eitdsc = Trim(dw_ip.Object.sitdsc[1])
ls_eitnbr = Trim(dw_ip.Object.eitnbr[1])
ls_eitdsc = Trim(dw_ip.Object.eitdsc[1])

If isNull(ls_sitnbr) or ls_sitnbr = ''  Then ls_sitnbr = '.'
If isNull(ls_eitnbr) or ls_eitnbr = ''  Then ls_eitnbr = 'z'

If isNull(ls_sitdsc) or ls_sitdsc = ''  Then ls_sitdsc = ''
If isNull(ls_eitdsc) or ls_eitdsc = ''  Then ls_eitdsc = ''

if dw_list.Retrieve(ls_sitnbr , ls_eitnbr) <= 0 then
	f_message_chk(50,"[EO 현황]")
	dw_ip.Setfocus()
	Return -1
Else
	If rb_1.Checked Then
		If ls_sitnbr = '.' And ls_eitnbr = 'z' then 
			dw_print.Object.t_itnbr.Text = "전체"
		Else
			dw_print.Object.t_itnbr.Text = "["+ls_sitnbr+"] "+ls_sitdsc+" - "+"["+ls_eitnbr+"] "+ls_eitdsc
		End If
	End If
End If

Return 1
	
end function

public subroutine wf_chg ();If rb_1.Checked Then
	dw_list.DataObject = 'd_res90_00010_a'
	dw_print.DataObject = 'd_res90_00010_p01'
Elseif rb_2.checked then
	dw_list.DataObject = 'd_res90_00010_b'
	dw_print.DataObject = 'd_res90_00010_p02'
elseIf rb_3.checked then 
   dw_list.DataObject = 'd_res90_00010_c'
	dw_print.DataObject = 'd_res90_00010_p04'
	end if

dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

dw_print.ShareData(dw_list)



end subroutine

on w_res90_00010.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.p_1=create p_1
this.gb_1=create gb_1
this.rr_1=create rr_1
this.dw_1=create dw_1
this.rb_3=create rb_3
this.rb_4=create rb_4
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.p_1
this.Control[iCurrent+4]=this.gb_1
this.Control[iCurrent+5]=this.rr_1
this.Control[iCurrent+6]=this.dw_1
this.Control[iCurrent+7]=this.rb_3
this.Control[iCurrent+8]=this.rb_4
this.Control[iCurrent+9]=this.gb_2
end on

on w_res90_00010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.p_1)
destroy(this.gb_1)
destroy(this.rr_1)
destroy(this.dw_1)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.gb_2)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)

rb_1.Checked = True

wf_chg()
end event

type p_preview from w_standard_print`p_preview within w_res90_00010
integer x = 3867
integer y = 32
end type

type p_exit from w_standard_print`p_exit within w_res90_00010
integer x = 4389
integer y = 32
integer taborder = 110
end type

type p_print from w_standard_print`p_print within w_res90_00010
integer x = 4215
integer y = 32
integer taborder = 70
end type

type p_retrieve from w_standard_print`p_retrieve within w_res90_00010
integer x = 3694
integer y = 32
end type



type sle_msg from w_standard_print`sle_msg within w_res90_00010
boolean displayonly = true
end type



type st_10 from w_standard_print`st_10 within w_res90_00010
end type



type dw_print from w_standard_print`dw_print within w_res90_00010
string dataobject = "d_res90_00010_p02"
end type

type dw_ip from w_standard_print`dw_ip within w_res90_00010
integer x = 32
integer y = 32
integer width = 2629
integer height = 196
string dataobject = "d_res90_00010_1"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String  ls_col , ls_cod ,ls_nam , ls_null
Setnull(ls_null)
ls_col = Lower(GetColumnName())
ls_cod = Trim(GetText())

if rb_3.checked = true then

Choose Case ls_col
  
	Case 'sitnbr'
		If ls_cod = '' Or isNull(ls_cod) Then
			this.setitem(1,'sitnbr',ls_null)
			this.setitem(1,'sitdsc',ls_null)
			Return 
		End If
		
		select itdsc into :ls_nam 
		  from ITEMAS
	 	 where itnbr = :ls_cod ;
	 
		if sqlca.sqlcode = 0 then
			this.setitem(1,'sitdsc',ls_nam)
		else
			f_message_chk(33, "[품번]")
			this.setitem(1,'sitnbr',ls_null)
			this.setitem(1,'sitdsc',ls_null)
			return 1
		end if
		
	Case 'eitnbr'
		If ls_cod = '' Or isNull(ls_cod) Then
			this.setitem(1,'eitnbr',ls_null)
			this.setitem(1,'eitdsc',ls_null)
			Return 
		End If
		
		select itdsc into :ls_nam 
		  from ITEMAS
	 	 where itnbr = :ls_cod ;
	 
		if sqlca.sqlcode = 0 then
			this.setitem(1,'eitdsc',ls_nam)
		else
			f_message_chk(33, "[품번]")
			this.setitem(1,'eitnbr',ls_null)
			this.setitem(1,'eitdsc',ls_null)
			return 1
		end if
End Choose

elseif rb_4.checked = true then 

Choose Case ls_col
  
	Case 'sitnbr'
		If ls_cod = '' Or isNull(ls_cod) Then
			this.setitem(1,'sitnbr',ls_null)
			this.setitem(1,'sitdsc',ls_null)
			Return 
		End If
		
		select itnbr into :ls_nam  
		  from eo_tb
	 	 where eo_no = :ls_cod ;
	 
		if sqlca.sqlcode = 0 then
			this.setitem(1,'sitdsc',ls_nam)
		else
			f_message_chk(33, "[품번]")
			this.setitem(1,'sitnbr',ls_null)
			this.setitem(1,'sitdsc',ls_null)
			return 1
		end if
		
	Case 'eitnbr'
		If ls_cod = '' Or isNull(ls_cod) Then
			this.setitem(1,'eitnbr',ls_null)
			this.setitem(1,'eitdsc',ls_null)
			Return 
		End If
		
		select itnbr into :ls_nam  
		  from eo_tb
	 	 where eo_no = :ls_cod ;
	 
		if sqlca.sqlcode = 0 then
			this.setitem(1,'eitdsc',ls_nam)
		else
			f_message_chk(33, "[품번]")
			this.setitem(1,'eitnbr',ls_null)
			this.setitem(1,'eitdsc',ls_null)
			return 1
		end if
End Choose	


end if 

end event

event dw_ip::rbuttondown;call super::rbuttondown;String ls_col

setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)
ls_col = Lower(GetColumnName())

if	rb_3.checked = true  then 

Choose Case ls_col

	Case 'sitnbr' , 'eitnbr' 
		open(w_itemas_popup)
		if isnull(gs_code) or gs_code = '' then return
		
		This.setitem(1,ls_col,gs_code)
	   This.TriggerEvent(itemchanged!)
	
End Choose

elseif rb_4.checked = true then  
	Choose Case ls_col

	Case 'sitnbr' , 'eitnbr' 
		open(w_eomst_popup)
		if isnull(gs_code) or gs_code = '' then return
		
		This.setitem(1,ls_col,gs_code)
	   This.TriggerEvent(itemchanged!)
	
End Choose
	

end if
end event

type dw_list from w_standard_print`dw_list within w_res90_00010
integer x = 55
integer y = 240
integer width = 4498
integer height = 2012
string dataobject = "d_res90_00010_b"
boolean border = false
end type

event dw_list::clicked;call super::clicked;If Row <= 0 then
	SelectRow(0,False)
ELSE
	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
END IF
end event

type rb_1 from radiobutton within w_res90_00010
integer x = 3223
integer y = 56
integer width = 306
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
string text = "리스트"
boolean checked = true
end type

event clicked;wf_chg()
end event

type rb_2 from radiobutton within w_res90_00010
integer x = 3223
integer y = 132
integer width = 357
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
string text = "상세이력"
end type

event clicked;wf_chg()
end event

type p_1 from picture within w_res90_00010
integer x = 4041
integer y = 32
integer width = 178
integer height = 144
boolean bringtotop = true
string picturename = "C:\ERPMAN\image\상세출력.gif"
boolean focusrectangle = false
end type

event clicked;If dw_list.RowCount() < 1 Then Return

String ls_itnbr
Long   i 

For i =1 To dw_list.RowCount()
	If dw_list.isSelected(i) Then
		ls_itnbr = Trim(dw_list.Object.eo_tb_itnbr[i])
	Else
		Continue
	End If
Next

If ls_itnbr = '' Or isNull(ls_itnbr) Then
	MessageBox('확인','조회된 리스트 중에서 해당 품번를 선택하세요.')
	Return
End If


If dw_1.Retrieve(ls_itnbr) > 0 Then

	
	OpenWithParm(w_print_preview, dw_1)
Else
   
End If
end event

type gb_1 from groupbox within w_res90_00010
integer x = 3191
integer y = 4
integer width = 443
integer height = 216
integer taborder = 50
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
end type

type rr_1 from roundrectangle within w_res90_00010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 232
integer width = 4521
integer height = 2036
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_1 from datawindow within w_res90_00010
boolean visible = false
integer x = 3863
integer y = 348
integer width = 571
integer height = 600
integer taborder = 80
string title = "none"
string dataobject = "d_res90_00010_p03"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rb_3 from radiobutton within w_res90_00010
integer x = 2697
integer y = 56
integer width = 411
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
string text = "품목코드별"
boolean checked = true
end type

event clicked;string ls_null
Setnull(ls_null)

dw_ip.setitem(1,'sitnbr',ls_null)
dw_ip.setitem(1,'sitdsc',ls_null)
dw_ip.setitem(1,'eitnbr',ls_null)
dw_ip.setitem(1,'eitdsc',ls_null)

rb_2.visible = true 
rb_2.enabled = true

dw_ip.object.t_tt.text = "품번"
end event

type rb_4 from radiobutton within w_res90_00010
integer x = 2697
integer y = 132
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
string text = "EO 별"
end type

event clicked;string ls_null
Setnull(ls_null)

dw_ip.setitem(1,'sitnbr',ls_null)
dw_ip.setitem(1,'sitdsc',ls_null)
dw_ip.setitem(1,'eitnbr',ls_null)
dw_ip.setitem(1,'eitdsc',ls_null)

rb_2.visible = false 
rb_2.enabled = false
rb_1.enabled = false
dw_ip.object.t_tt.text = "EO_No"
end event

type gb_2 from groupbox within w_res90_00010
integer x = 2661
integer y = 4
integer width = 498
integer height = 216
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

