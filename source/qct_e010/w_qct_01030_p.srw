$PBExportHeader$w_qct_01030_p.srw
$PBExportComments$재 검사 등록 현황
forward
global type w_qct_01030_p from w_standard_print
end type
type rb_wai from radiobutton within w_qct_01030_p
end type
type rb_nae from radiobutton within w_qct_01030_p
end type
type pb_2 from u_pb_cal within w_qct_01030_p
end type
type pb_1 from u_pb_cal within w_qct_01030_p
end type
type gb_5 from groupbox within w_qct_01030_p
end type
type rr_2 from roundrectangle within w_qct_01030_p
end type
end forward

global type w_qct_01030_p from w_standard_print
integer width = 4686
integer height = 2912
string title = "재 검사 등록 현황"
rb_wai rb_wai
rb_nae rb_nae
pb_2 pb_2
pb_1 pb_1
gb_5 gb_5
rr_2 rr_2
end type
global w_qct_01030_p w_qct_01030_p

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();dw_ip.AcceptText()

Long   row

row = dw_ip.GetRow()
If row < 1 Then Return -1

String ls_saupj

ls_saupj = dw_ip.GetItemString(row, 'porgu')
If Trim(ls_saupj) = '' OR IsNull(ls_saupj) Then
	MessageBox('사업장 확인', '사업장은 필수 사항입니다.')
	dw_ip.SetColumn('porgu')
	dw_ip.SetFocus()
	Return -1
End If

String ls_st

ls_st = dw_ip.GetItemString(row, 'sdate')
If Trim(ls_st) = '' OR IsNull(ls_st) Then
	ls_st = '19000101'
Else
	If IsDate(LEFT(ls_st, 4) + '.' + MID(ls_st, 5, 2) + '.' + RIGHT(ls_st, 2)) = False Then
		MessageBox('일자형식 확인', '일자 형식을 확인하십시오.')
		dw_ip.Setcolumn('sdate')
		dw_ip.SetFocus()
		Return -1
	End If
End If

String ls_ed

ls_ed = dw_ip.GetItemString(row, 'edate')
If Trim(ls_ed) = '' OR IsNull(ls_ed) Then
	ls_ed = '29991231'
Else
	If IsDate(LEFT(ls_ed, 4) + '.' + MID(ls_ed, 5, 2) + '.' + RIGHT(ls_ed, 2)) = False Then
		MessageBox('일자형식 확인', '일자 형식을 확인하십시오.')
		dw_ip.Setcolumn('edate')
		dw_ip.SetFocus()
		Return -1
	End If
End If

If ls_st > ls_ed Then
	MessageBox('기간 확인', '의뢰 기간을 확인 하십시오.')
	dw_ip.SetColumn('sdate')
	dw_ip.SetFocus()
	Return -1
End If

dw_list.SetRedraw(False)
dw_list.Retrieve(ls_saupj, gs_sabu, ls_st, ls_ed)
dw_list.SetRedraw(True)

If dw_list.RowCount() < 1 Then Return -1

dw_list.ShareData(dw_print)

Return 1



end function

on w_qct_01030_p.create
int iCurrent
call super::create
this.rb_wai=create rb_wai
this.rb_nae=create rb_nae
this.pb_2=create pb_2
this.pb_1=create pb_1
this.gb_5=create gb_5
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_wai
this.Control[iCurrent+2]=this.rb_nae
this.Control[iCurrent+3]=this.pb_2
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.gb_5
this.Control[iCurrent+6]=this.rr_2
end on

on w_qct_01030_p.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_wai)
destroy(this.rb_nae)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.gb_5)
destroy(this.rr_2)
end on

event open;call super::open;f_mod_saupj(dw_ip, 'porgu')

dw_ip.SetItem(1, 'sdate', String(TODAY(), 'yyyymm' + '01'))
dw_ip.SetItem(1, 'edate', String(TODAY(), 'yyyymmdd'))
end event

type p_xls from w_standard_print`p_xls within w_qct_01030_p
boolean visible = true
integer x = 4270
integer y = 24
end type

type p_sort from w_standard_print`p_sort within w_qct_01030_p
integer x = 3378
end type

type p_preview from w_standard_print`p_preview within w_qct_01030_p
end type

type p_exit from w_standard_print`p_exit within w_qct_01030_p
end type

type p_print from w_standard_print`p_print within w_qct_01030_p
boolean visible = false
integer x = 4443
integer y = 172
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_01030_p
end type

event p_retrieve::clicked;call super::clicked;//
if is_Upmu = 'A' then
	
	if dw_ip.AcceptText() = -1 then return  

	w_mdi_frame.sle_msg.text =""
	
	sabu_f =Trim(dw_ip.GetItemString(1,"saupj"))
	
	SetPointer(HourGlass!)
	IF sabu_f ="" OR IsNull(sabu_f) OR sabu_f ="99" THEN	//사업장이 전사이거나 없으면 모든 사업장//
		sabu_f ="10"
		sabu_t ="98"
		SELECT "REFFPF"."RFNA1"  
		 INTO :sabu_nm  
		 FROM "REFFPF"  
		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND  
				( "REFFPF"."RFGUB" = '99' )   ;
	ELSE
		sabu_t =sabu_f
		SELECT "REFFPF"."RFNA1"  
		 INTO :sabu_nm  
		 FROM "REFFPF"  
		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND  
				( "REFFPF"."RFGUB" = :sabu_f )   ;
	END IF
end if

IF wf_retrieve() = -1 THEN
	p_xls.Enabled =False
	p_xls.PictureName = 'C:\erpman\image\엑셀변환_d.gif'	
	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
	SetPointer(Arrow!)
	Return
Else
	p_xls.Enabled =True
	p_xls.PictureName =  'C:\erpman\image\엑셀변환_up.gif'
	p_preview.enabled = true
	p_preview.PictureName = 'C:\erpman\image\미리보기_up.gif'
END IF
dw_list.scrolltorow(1)
dw_list.SetFocus()
SetPointer(Arrow!)	
end event







type st_10 from w_standard_print`st_10 within w_qct_01030_p
end type



type dw_print from w_standard_print`dw_print within w_qct_01030_p
integer x = 4297
integer y = 180
string dataobject = "d_qct_01031_p_out_1"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_01030_p
integer x = 27
integer y = 36
integer width = 2455
integer height = 128
string dataobject = "d_qct_01030_p_001"
end type

type dw_list from w_standard_print`dw_list within w_qct_01030_p
integer x = 46
integer y = 200
integer width = 4558
integer height = 2036
string dataobject = "d_qct_01031_p_out"
boolean border = false
end type

type rb_wai from radiobutton within w_qct_01030_p
integer x = 2683
integer y = 72
integer width = 338
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "사외입고"
boolean checked = true
end type

event clicked;If This.checked = True Then
	dw_list.DataObject = 'd_qct_01031_p_out'
	dw_print.DataObject = 'd_qct_01031_p_out_1'
End If

dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)



end event

type rb_nae from radiobutton within w_qct_01030_p
integer x = 3035
integer y = 72
integer width = 338
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "사내의뢰"
end type

event clicked;If This.checked = True Then
	dw_list.DataObject = 'd_qct_01031_p_in'
	dw_print.DataObject = 'd_qct_01031_p_in_1'
End If

dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)


end event

type pb_2 from u_pb_cal within w_qct_01030_p
integer x = 2318
integer y = 64
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('edate')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'edate', gs_code)
end event

type pb_1 from u_pb_cal within w_qct_01030_p
integer x = 1806
integer y = 64
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('sdate')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'sdate', gs_code)
end event

type gb_5 from groupbox within w_qct_01030_p
integer x = 2629
integer y = 32
integer width = 795
integer height = 128
integer taborder = 20
integer textsize = -2
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 32106727
borderstyle borderstyle = styleraised!
end type

type rr_2 from roundrectangle within w_qct_01030_p
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 188
integer width = 4585
integer height = 2064
integer cornerheight = 40
integer cornerwidth = 55
end type

