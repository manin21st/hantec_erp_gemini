$PBExportHeader$w_han_30010.srw
$PBExportComments$여유시간 현황
forward
global type w_han_30010 from w_standard_print
end type
type pb_2 from u_pb_cal within w_han_30010
end type
type pb_1 from u_pb_cal within w_han_30010
end type
type rb_1 from radiobutton within w_han_30010
end type
type dw_grp1 from datawindow within w_han_30010
end type
type dw_grp2 from datawindow within w_han_30010
end type
type rb_3 from radiobutton within w_han_30010
end type
type rr_1 from roundrectangle within w_han_30010
end type
type rb_2 from radiobutton within w_han_30010
end type
end forward

global type w_han_30010 from w_standard_print
string title = "설비별 여유시간 현황"
pb_2 pb_2
pb_1 pb_1
rb_1 rb_1
dw_grp1 dw_grp1
dw_grp2 dw_grp2
rb_3 rb_3
rr_1 rr_1
rb_2 rb_2
end type
global w_han_30010 w_han_30010

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();dw_ip.AcceptText()

Long   row

row = dw_ip.GetRow()
If row < 1 Then Return -1

String ls_st
String ls_ed

ls_st = dw_ip.GetItemString(row, 'd_st')
If Trim(ls_st) = '' OR IsNull(ls_st) Then
	ls_st = '19000101'
Else
	If IsDate(LEFT(ls_st, 4) + '.' + MID(ls_st, 5, 2) + '.' + RIGHT(ls_st, 2)) = False Then
		MessageBox('일자형식 확인', '일자 형식이 잘못되었습니다.')
		dw_ip.SetColumn('d_st')
		dw_ip.SetFocus()
		Return -1
	End If
End If

ls_ed = dw_ip.GetItemString(row, 'd_ed')
If Trim(ls_ed) = '' OR IsNull(ls_ed) Then
	ls_ed = '29991231'
Else
	If IsDate(LEFT(ls_ed, 4) + '.' + MID(ls_ed, 5, 2) + '.' + RIGHT(ls_ed, 2)) = False Then
		MessageBox('일자형식 확인', '일자 형식이 잘못되었습니다.')
		dw_ip.SetColumn('d_ed')
		dw_ip.SetFocus()
		Return -1
	End If
End If

If ls_st > ls_ed Then
	MessageBox('기간확인', '시작일 보다 종료일이 빠릅니다.')
	dw_ip.SetColumn('d_st')
	dw_ip.SetFocus()
	Return -1
End If

String ls_jocod

ls_jocod = dw_ip.GetItemString(row, 'jocod')
If Trim(ls_jocod) = '' OR IsNull(ls_jocod) Then
	ls_jocod = '%'
Else
	ls_jocod = ls_jocod + '%'
End If

String ls_stim

ls_stim = dw_ip.GetItemString(row, 'stim')
If Trim(ls_stim) = '' OR IsNull(ls_stim) Then ls_stim = '0800'

String ls_etim

ls_etim = dw_ip.GetItemString(row, 'etim')
If Trim(ls_etim) = '' OR IsNull(ls_etim) Then ls_etim = '0630'

If rb_2.Checked = False Then
	dw_grp1.SetRedraw(False)
	dw_grp1.Retrieve(ls_st, ls_ed, ls_stim, ls_etim, ls_jocod)
	dw_grp1.SetRedraw(True)
	
	dw_grp2.SetRedraw(False)
	dw_grp2.Retrieve(ls_st, ls_ed, ls_stim, ls_etim, ls_jocod)
	dw_grp2.SetRedraw(True)	
Else
	dw_list.SetRedraw(False)
	dw_list.Retrieve(ls_st, ls_ed, ls_stim, ls_etim, ls_jocod)
	dw_list.SetRedraw(True)
End If

dw_list.ShareData(dw_print)

Return 1
end function

on w_han_30010.create
int iCurrent
call super::create
this.pb_2=create pb_2
this.pb_1=create pb_1
this.rb_1=create rb_1
this.dw_grp1=create dw_grp1
this.dw_grp2=create dw_grp2
this.rb_3=create rb_3
this.rr_1=create rr_1
this.rb_2=create rb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_2
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.dw_grp1
this.Control[iCurrent+5]=this.dw_grp2
this.Control[iCurrent+6]=this.rb_3
this.Control[iCurrent+7]=this.rr_1
this.Control[iCurrent+8]=this.rb_2
end on

on w_han_30010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.rb_1)
destroy(this.dw_grp1)
destroy(this.dw_grp2)
destroy(this.rb_3)
destroy(this.rr_1)
destroy(this.rb_2)
end on

event ue_open;call super::ue_open;/* DataWindow NTIM 값 관련 */
/* POP 비가동 시간 관련하여 필요없어 보이더라도 절대 생략하면 안됨 */
/* 가동시간에 맞는 비가동 시간만 불러오도록 해야함 '20.03.12 BY BHKIM */

dw_ip.SetItem(1, 'd_st', String(RelativeDate(TODAY(), -1), 'yyyymmdd'))
dw_ip.SetItem(1, 'd_ed', String(TODAY(), 'yyyymmdd'))

String ls_st
SELECT DATANAME
  INTO :ls_st
  FROM SYSCNFG
 WHERE SYSGU  = 'Y'
   AND SERIAL = '89'
   AND LINENO = 'ST' ;
If Trim(ls_st) = '' OR IsNull(ls_st) Then ls_st = '0800'

String ls_ed
SELECT DATANAME
  INTO :ls_ed
  FROM SYSCNFG
 WHERE SYSGU  = 'Y'
   AND SERIAL = '89'
   AND LINENO = 'ED' ;
If Trim(ls_ed) = '' OR IsNull(ls_ed) Then ls_ed = '0630'

dw_ip.SetItem(1, 'stim', ls_st)
dw_ip.SetItem(1, 'etim', ls_ed)
end event

type p_xls from w_standard_print`p_xls within w_han_30010
boolean visible = true
integer x = 4270
integer y = 24
boolean enabled = false
string picturename = "C:\erpman\image\엑셀변환_d.gif"
end type

type p_sort from w_standard_print`p_sort within w_han_30010
integer x = 3607
integer y = 148
boolean enabled = false
boolean originalsize = false
end type

type p_preview from w_standard_print`p_preview within w_han_30010
end type

type p_exit from w_standard_print`p_exit within w_han_30010
end type

type p_print from w_standard_print`p_print within w_han_30010
boolean visible = false
integer x = 3424
integer y = 148
end type

type p_retrieve from w_standard_print`p_retrieve within w_han_30010
end type

event p_retrieve::clicked;//

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
//	p_print.Enabled =False
//	p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
	
	p_xls.Enabled = False
	p_xls.PictureName = 'C:\erpman\image\엑셀변환_d.gif'
	SetPointer(Arrow!)
	Return
Else
//	p_print.Enabled =True
//	p_print.PictureName =  'C:\erpman\image\인쇄_up.gif'
	If rb_2.Checked = True Then
		p_preview.enabled = true
		p_preview.PictureName = 'C:\erpman\image\미리보기_up.gif'
		p_xls.Enabled = True
		p_xls.PictureName = 'C:\erpman\image\엑셀변환_up.gif'
	End If
END IF
dw_list.scrolltorow(1)
dw_list.SetFocus()
SetPointer(Arrow!)	

w_mdi_frame.sle_msg.text =""

///-----------------------------------------------------------------------------------------
// by 2006.09.30 font채 변경 - 신
String ls_gbn
SELECT DATANAME
  INTO :ls_gbn
  FROM SYSCNFG
 WHERE SYSGU  = 'C'
   AND SERIAL = '81'
   AND LINENO = '1' ;
If ls_gbn = 'Y' Then
	//wf_setfont()
	WindowObject l_object[]
	Long i
	gstr_object_chg lstr_object		
	For i = 1 To UpperBound(Control[])
		lstr_object.lu_object[i] = Control[i]  //Window Object
		lstr_object.li_obj = i						//Window Object 갯수
	Next
	f_change_font(lstr_object)
End If

///-----------------------------------------------------------------------------------------


end event







type st_10 from w_standard_print`st_10 within w_han_30010
end type



type dw_print from w_standard_print`dw_print within w_han_30010
integer x = 3790
integer y = 148
boolean enabled = false
string dataobject = "d_han_30010_003"
end type

type dw_ip from w_standard_print`dw_ip within w_han_30010
integer x = 37
integer width = 3625
integer height = 176
string dataobject = "d_han_30010_001"
end type

event dw_ip::itemchanged;call super::itemchanged;If row < 1 Then Return

Choose Case dwo.name

	Case 'd_st'
		If Trim(data) = '' OR IsNull(data) Then Return
		
		If data = This.GetItemString(row, 'd_ed') Then
			This.SetItem(row, 'etim', '2400')
		Else
			This.SetItem(row, 'etim', '0630')
		End If
		
	Case 'd_ed'
		If Trim(data) = '' OR IsNull(data) Then Return
		
		If data = This.GetItemString(row, 'd_st') Then
			This.SetItem(row, 'etim', '2400')
		Else
			This.SetItem(row, 'etim', '0630')
		End If
	
End Choose
end event

type dw_list from w_standard_print`dw_list within w_han_30010
integer x = 55
integer y = 220
integer width = 4503
integer height = 2044
string dataobject = "d_han_30010_002"
boolean border = false
end type

type pb_2 from u_pb_cal within w_han_30010
integer x = 1211
integer y = 56
integer height = 76
integer taborder = 130
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('d_ed')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'd_ed', gs_code)

If Trim(gs_code) = '' OR IsNull(gs_code) Then Return

If gs_code = dw_ip.GetItemString(1, 'd_st') Then
	dw_ip.SetItem(1, 'etim', '2400')
Else
	dw_ip.SetItem(1, 'etim', '0630')
End If


end event

type pb_1 from u_pb_cal within w_han_30010
integer x = 558
integer y = 56
integer height = 76
integer taborder = 140
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('d_st')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'd_st', gs_code)

If Trim(gs_code) = '' OR IsNull(gs_code) Then Return

If gs_code = dw_ip.GetItemString(1, 'd_ed') Then
	dw_ip.SetItem(1, 'etim', '2400')
Else
	dw_ip.SetItem(1, 'etim', '0630')
End If

end event

type rb_1 from radiobutton within w_han_30010
integer x = 2528
integer y = 48
integer width = 480
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
string text = "Block Graph"
end type

event clicked;If This.Checked = True Then
	dw_list.Visible = False
	dw_grp1.Visible = True
	dw_grp2.Visible = True
End If

dw_grp1.DataObject = 'd_han_30010_004'
dw_grp2.DataObject = 'd_han_30010_005'

dw_grp1.SetTransObject(SQLCA)
dw_grp2.SetTransObject(SQLCA)

p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
p_xls.PictureName     = 'C:\erpman\image\엑셀변환_d.gif'

p_preview.Enabled = False
p_xls.Enabled     = False
end event

type dw_grp1 from datawindow within w_han_30010
boolean visible = false
integer x = 55
integer y = 220
integer width = 4503
integer height = 1640
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_han_30010_004"
boolean border = false
boolean livescroll = true
end type

type dw_grp2 from datawindow within w_han_30010
boolean visible = false
integer x = 55
integer y = 1868
integer width = 4503
integer height = 404
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_han_30010_005"
boolean hscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

type rb_3 from radiobutton within w_han_30010
integer x = 3022
integer y = 48
integer width = 526
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
string text = "Machine Graph"
end type

event clicked;If This.Checked = True Then
	dw_list.Visible = False
	dw_grp1.Visible = True
	dw_grp2.Visible = True
End If

dw_grp1.DataObject = 'd_han_30010_006'
dw_grp2.DataObject = 'd_han_30010_007'

dw_grp1.SetTransObject(SQLCA)
dw_grp2.SetTransObject(SQLCA)

p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
p_xls.PictureName     = 'C:\erpman\image\엑셀변환_d.gif'

p_preview.Enabled = False
p_xls.Enabled     = False
end event

type rr_1 from roundrectangle within w_han_30010
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 37
integer y = 204
integer width = 4539
integer height = 2076
integer cornerheight = 40
integer cornerwidth = 55
end type

type rb_2 from radiobutton within w_han_30010
integer x = 2528
integer y = 112
integer width = 402
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
string text = "Grid List"
boolean checked = true
end type

event clicked;If This.Checked = True Then
	dw_list.Visible = True
	dw_grp1.Visible = False
	dw_grp2.Visible = False
End If
end event

