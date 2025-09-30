$PBExportHeader$w_han_01035.srw
$PBExportComments$비 가동 TOP 5
forward
global type w_han_01035 from w_standard_print
end type
type dw_1 from datawindow within w_han_01035
end type
type dw_2 from datawindow within w_han_01035
end type
type rr_1 from roundrectangle within w_han_01035
end type
type dw_3 from datawindow within w_han_01035
end type
type pb_1 from u_pb_cal within w_han_01035
end type
type pb_2 from u_pb_cal within w_han_01035
end type
type dw_4 from datawindow within w_han_01035
end type
end forward

global type w_han_01035 from w_standard_print
string title = "비 가동 TOP 5"
dw_1 dw_1
dw_2 dw_2
rr_1 rr_1
dw_3 dw_3
pb_1 pb_1
pb_2 pb_2
dw_4 dw_4
end type
global w_han_01035 w_han_01035

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();dw_ip.AcceptText()

Long   row

row = dw_ip.GetRow()
If row < 1 Then Return -1

String ls_st

ls_st = dw_ip.GetItemString(row, 'd_st')
If Trim(ls_st) = '' OR IsNull(ls_st) Then
	ls_st = '19000101'
Else
	If IsDate(LEFT(ls_st, 4) + '.' + MID(ls_st, 5, 2) + '.' + RIGHT(ls_st, 2)) = False Then
		MessageBox('일자형식 확인', '일자 형식이 잘못 되었습니다.')
		dw_ip.SetColumn('d_st')
		dw_ip.SetFocus()
		Return -1
	End If
End If

String ls_ed

ls_ed = dw_ip.GetItemString(row, 'd_ed')
If Trim(ls_ed) = '' OR IsNull(ls_ed) Then
	ls_st = '29991231'
Else
	If IsDate(LEFT(ls_ed, 4) + '.' + MID(ls_ed, 5, 2) + '.' + RIGHT(ls_ed, 2)) = False Then
		MessageBox('일자형식 확인', '일자 형식이 잘못 되었습니다.')
		dw_ip.SetColumn('d_ed')
		dw_ip.SetFocus()
		Return -1
	End If
End If

String ls_stim

ls_stim = dw_ip.GetItemString(row, 'stim')
If Trim(ls_stim) = '' OR IsNull(ls_stim) Then ls_stim = '0800'

String ls_etim

ls_etim = dw_ip.GetItemString(row, 'etim')
If Trim(ls_etim) = '' OR IsNull(ls_etim) Then ls_etim = '0630'

String ls_gbn

ls_gbn = dw_ip.GetItemString(row, 'gubun')
If ls_gbn = 'B' Then
	dw_3.SetRedraw(False)
	dw_3.Retrieve(ls_st, ls_ed, ls_stim, ls_etim)
	dw_3.SetRedraw(True)
	
	dw_list.SetRedraw(False)
	dw_list.Retrieve(ls_st, ls_ed, ls_stim, ls_etim)
	dw_list.SetRedraw(True)
Else
	dw_2.SetRedraw(False)
	dw_2.Retrieve(ls_st, ls_ed, ls_stim, ls_etim)
	dw_2.SetRedraw(True)
End If

Return 1

end function

on w_han_01035.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.rr_1=create rr_1
this.dw_3=create dw_3
this.pb_1=create pb_1
this.pb_2=create pb_2
this.dw_4=create dw_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.rr_1
this.Control[iCurrent+4]=this.dw_3
this.Control[iCurrent+5]=this.pb_1
this.Control[iCurrent+6]=this.pb_2
this.Control[iCurrent+7]=this.dw_4
end on

on w_han_01035.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.rr_1)
destroy(this.dw_3)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.dw_4)
end on

event ue_open;call super::ue_open;dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
dw_3.SetTransObject(SQLCA)

dw_ip.SetItem(1, 'd_st', String(TODAY(), 'yyyymm' + '01'))
dw_ip.SetItem(1, 'd_ed', String(TODAY(), 'yyyymmdd'))

String ls_st
ls_st = f_get_syscnfg('Y', 89, 'ST')
If Trim(ls_st) = '' OR IsNull(ls_st) Then ls_st = '0800'

String ls_ed
ls_ed = f_get_syscnfg('Y', 89, 'ED')
If Trim(ls_ed) = '' OR IsNull(ls_ed) Then ls_ed = '0630'

dw_ip.SetItem(1, 'stim', ls_st)
dw_ip.SetItem(1, 'etim', ls_ed)

dw_1.Visible = False
dw_2.Visible = False
dw_3.Visible = True

dw_list.DataObject = 'd_han_01035_005'
dw_print.DataObject = 'd_han_01035_005'

dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
end event

type p_xls from w_standard_print`p_xls within w_han_01035
boolean visible = true
integer x = 4219
integer y = 24
boolean enabled = false
string picturename = "C:\erpman\image\엑셀변환_d.gif"
end type

type p_sort from w_standard_print`p_sort within w_han_01035
integer x = 3735
integer y = 32
boolean enabled = false
boolean originalsize = false
end type

type p_preview from w_standard_print`p_preview within w_han_01035
boolean visible = false
integer x = 3387
integer y = 32
end type

type p_exit from w_standard_print`p_exit within w_han_01035
integer x = 4393
end type

type p_print from w_standard_print`p_print within w_han_01035
boolean visible = false
integer x = 3561
integer y = 32
end type

type p_retrieve from w_standard_print`p_retrieve within w_han_01035
integer x = 4046
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
	p_xls.Enabled =False
	p_xls.PictureName = 'C:\erpman\image\엑셀변환_d.gif'
	SetPointer(Arrow!)
	Return
Else
	p_xls.Enabled =True
	p_xls.PictureName =  'C:\erpman\image\엑셀변환_up.gif'
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







type st_10 from w_standard_print`st_10 within w_han_01035
end type



type dw_print from w_standard_print`dw_print within w_han_01035
integer x = 3918
string dataobject = "d_han_01035_005"
end type

type dw_ip from w_standard_print`dw_ip within w_han_01035
integer x = 37
integer y = 12
integer width = 2551
integer height = 176
string dataobject = "d_han_01035_001"
end type

event dw_ip::itemchanged;call super::itemchanged;If row < 1 Then Return

Choose Case dwo.name
	Case 'gubun'
		If data = 'B' Then
			dw_1.Visible = False
			dw_2.Visible = False
			dw_3.Visible = True
			
			dw_list.DataObject = 'd_han_01035_005'
			dw_print.DataObject = 'd_han_01035_005'
		Else
			dw_1.Visible = True
			dw_2.Visible = True
			dw_3.Visible = False
			
			dw_list.DataObject = 'd_han_01035_006'
			dw_print.DataObject = 'd_han_01035_006'
		End If
		
		dw_list.SetTransObject(SQLCA)
		dw_print.SetTransObject(SQLCA)

	Case 'd_st'
		If Trim(data) = '' OR IsNull(data) Then Return
		
		If data = This.GetItemString(row, 'd_ed') Then
			This.SetItem(row, 'etim', '2400')
		Else
			This.SetItem(row, 'etim', f_get_syscnfg('Y', 89, 'ED'))
		End If
		
	Case 'd_ed'
		If Trim(data) = '' OR IsNull(data) Then Return
		
		If data = This.GetItemString(row, 'd_st') Then
			This.SetItem(row, 'etim', '2400')
		Else
			This.SetItem(row, 'etim', f_get_syscnfg('Y', 89, 'ED'))
		End If
End Choose
end event

type dw_list from w_standard_print`dw_list within w_han_01035
integer x = 50
integer y = 1768
integer width = 4526
integer height = 480
string dataobject = "d_han_01035_005"
end type

type dw_1 from datawindow within w_han_01035
boolean visible = false
integer x = 1202
integer y = 212
integer width = 3374
integer height = 1548
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_han_01035_004"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
end type

type dw_2 from datawindow within w_han_01035
boolean visible = false
integer x = 50
integer y = 212
integer width = 1138
integer height = 1548
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_han_01035_002"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;if row <=0 then return

this.SelectRow(0,False)
this.SelectRow(row,True)

String ls_st
String ls_ed
String ls_stim
String ls_etim

ls_st   = dw_ip.GetItemString(1, 'd_st')
ls_ed   = dw_ip.GetItemString(1, 'd_ed')
ls_stim = dw_ip.GetItemString(1, 'stim')
ls_etim = dw_ip.GetItemString(1, 'etim')

Double ldb_tot

ldb_tot = This.GetItemNumber(row, 'ntime')

String ls_ntcod

ls_ntcod = This.GetItemString(row, 'ntcod')
If Trim(ls_ntcod) = '' OR IsNull(ls_ntcod) Then Return

dw_1.SetRedraw(False)
dw_1.Retrieve(ls_st, ls_ed, ls_stim, ls_etim, ls_ntcod)
dw_1.SetRedraw(True)

dw_list.SetRedraw(False)
dw_list.Retrieve(ls_st, ls_ed, ls_stim, ls_etim, ls_ntcod, ldb_tot)
dw_list.SetRedraw(True)

dw_4.SetRedraw(False)
dw_4.Retrieve(ls_st, ls_ed, ls_stim, ls_etim, ls_ntcod)
dw_4.SetRedraw(True)

String ls_ntnam
String ls_rk

ls_ntnam = This.GetItemString(row, 'ntnam')
ls_rk    = String(This.GetItemNumber(row, 'rk'), '00')

dw_1.Modify("gr_1.Title = '" + 'TOP-' + ls_rk + ') ' + ls_ntnam + "'")
end event

event rowfocuschanged;if currentrow <=0 then return

this.SelectRow(0,False)
this.SelectRow(currentrow,True)

String ls_st
String ls_ed
String ls_stim
String ls_etim

ls_st   = dw_ip.GetItemString(1, 'd_st')
ls_ed   = dw_ip.GetItemString(1, 'd_ed')
ls_stim = dw_ip.GetItemString(1, 'stim')
ls_etim = dw_ip.GetItemString(1, 'etim')

Double ldb_tot

ldb_tot = This.GetItemNumber(currentrow, 'ntime')

String ls_ntcod

ls_ntcod = This.GetItemString(currentrow, 'ntcod')
If Trim(ls_ntcod) = '' OR IsNull(ls_ntcod) Then Return

dw_1.SetRedraw(False)
dw_1.Retrieve(ls_st, ls_ed, ls_stim, ls_etim, ls_ntcod)
dw_1.SetRedraw(True)

dw_list.SetRedraw(False)
dw_list.Retrieve(ls_st, ls_ed, ls_stim, ls_etim, ls_ntcod, ldb_tot)
dw_list.SetRedraw(True)

dw_4.SetRedraw(False)
dw_4.Retrieve(ls_st, ls_ed, ls_stim, ls_etim, ls_ntcod)
dw_4.SetRedraw(True)

String ls_ntnam
String ls_rk

ls_ntnam = This.GetItemString(currentrow, 'ntnam')
ls_rk    = String(This.GetItemNumber(currentrow, 'rk'), '00')

dw_1.Modify("gr_1.Title = '" + 'TOP-' + ls_rk + ') ' + ls_ntnam + "'")
end event

event retrieveend;String ls_st
String ls_ed
String ls_stim
String ls_etim

ls_st   = dw_ip.GetItemString(1, 'd_st')
ls_ed   = dw_ip.GetItemString(1, 'd_ed')
ls_stim = dw_ip.GetItemString(1, 'stim')
ls_etim = dw_ip.GetItemString(1, 'etim')

Double ldb_tot

ldb_tot = This.GetItemNumber(1, 'ntime')

String ls_ntcod

ls_ntcod = This.GetItemString(1, 'ntcod')
If Trim(ls_ntcod) = '' OR IsNull(ls_ntcod) Then Return

dw_1.SetRedraw(False)
dw_1.Retrieve(ls_st, ls_ed, ls_stim, ls_etim, ls_ntcod)
dw_1.SetRedraw(True)

dw_list.SetRedraw(False)
dw_list.Retrieve(ls_st, ls_ed, ls_stim, ls_etim, ls_ntcod, ldb_tot)
dw_list.SetRedraw(True)

dw_4.SetRedraw(False)
dw_4.Retrieve(ls_st, ls_ed, ls_stim, ls_etim, ls_ntcod)
dw_4.SetRedraw(True)

String ls_ntnam
String ls_rk

ls_ntnam = This.GetItemString(1, 'ntnam')
ls_rk    = String(This.GetItemNumber(1, 'rk'), '00')

dw_1.Modify("gr_1.Title = '" + 'TOP-' + ls_rk + ') ' + ls_ntnam + "'")
end event

event doubleclicked;If row < 1 Then Return

If dw_4.Visible = True Then Return

dw_4.Visible = True
end event

type rr_1 from roundrectangle within w_han_01035
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 37
integer y = 200
integer width = 4553
integer height = 2060
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_3 from datawindow within w_han_01035
integer x = 50
integer y = 212
integer width = 4526
integer height = 1548
integer taborder = 50
string title = "none"
string dataobject = "d_han_01035_003"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
end type

type pb_1 from u_pb_cal within w_han_01035
integer x = 599
integer y = 48
integer height = 76
integer taborder = 120
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
	dw_ip.SetItem(1, 'etim', f_get_syscnfg('Y', 89, 'ED'))
End If
end event

type pb_2 from u_pb_cal within w_han_01035
integer x = 1230
integer y = 48
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
	dw_ip.SetItem(1, 'etim', f_get_syscnfg('Y', 89, 'ED'))
End If

end event

type dw_4 from datawindow within w_han_01035
boolean visible = false
integer x = 1120
integer y = 592
integer width = 2560
integer height = 1392
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "TOP 5 설비"
string dataobject = "d_han_01035_007"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
string icon = "Exclamation!"
boolean hsplitscroll = true
boolean livescroll = true
end type

event doubleclicked;This.Visible = False
end event

event constructor;This.SetTransObject(SQLCA)
end event

event clicked;//This.Visible = False
end event

