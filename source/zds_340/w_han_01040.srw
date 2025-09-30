$PBExportHeader$w_han_01040.srw
$PBExportComments$블럭/유형별 불량률
forward
global type w_han_01040 from w_standard_print
end type
type dw_1 from datawindow within w_han_01040
end type
type pb_1 from u_pb_cal within w_han_01040
end type
type pb_2 from u_pb_cal within w_han_01040
end type
type st_1 from statictext within w_han_01040
end type
type rr_1 from roundrectangle within w_han_01040
end type
end forward

global type w_han_01040 from w_standard_print
integer height = 2436
string title = "블럭/유형별 불량률"
dw_1 dw_1
pb_1 pb_1
pb_2 pb_2
st_1 st_1
rr_1 rr_1
end type
global w_han_01040 w_han_01040

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();dw_ip.AcceptText()

Long   row

row = dw_ip.GetRow()
If row < 1 Then Return -1

String ls_gub

ls_gub = dw_ip.GetItemString(row, 'gubun')
If ls_gub = '1' Then
	dw_list.DataObject = 'd_han_01040_201'
	dw_1.DataObject    = 'd_han_01040_202'
ElseIf ls_gub = '2' Then
	dw_list.DataObject = 'd_han_01040_301'
	dw_1.DataObject    = 'd_han_01040_302'
End If

dw_list.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)

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

String ls_stim

ls_stim = dw_ip.GetItemString(row, 'stim')
If Trim(ls_stim) = '' OR IsNull(ls_stim) Then ls_stim = '0800'

String ls_etim

ls_etim = dw_ip.GetItemString(row, 'etim')
If Trim(ls_etim) = '' OR IsNull(ls_etim) Then ls_etim = '0630'

dw_list.SetRedraw(False)
dw_list.Retrieve(ls_st, ls_ed, ls_stim, ls_etim)
dw_list.SetRedraw(True)

dw_1.SetRedraw(False)
dw_1.Retrieve(ls_st, ls_ed, ls_stim, ls_etim)
dw_1.SetRedraw(True)

Double ldb_ppm

SELECT NVL(ROUND((SUM(FAQTY)/SUM(ROQTY))*1000000, 2), 0)
  INTO :ldb_ppm
  FROM WRKCTR X,
		 (  SELECT A.SHPJPNO,
					  A.JOCOD ,
					  SUM(DISTINCT A.FAQTY) AS FAQTY,
					  SUM(DISTINCT A.ROQTY) AS ROQTY
				FROM SHPACT A,
					  ITEMAS B,
					  ROUTNG C,
					  SHPFAT D,
					  REFFPF E
			  WHERE E.RFCOD   =    '33'
				 AND A.STDAT||A.STIME >= :ls_st||:ls_stim AND A.STDAT||A.STIME <= :ls_ed||:ls_etim
             AND A.SIDAT||A.ETIME >= :ls_st||:ls_stim AND A.SIDAT||A.ETIME <= :ls_ed||:ls_etim
				 AND A.ITNBR   =    B.ITNBR
				 AND A.ITNBR   =    C.ITNBR
				 AND A.OPSNO   =    C.OPSEQ
				 AND A.SABU    =    D.SABU
				 AND A.SHPJPNO =    D.SHPJPNO
				 AND D.GUCOD   =    E.RFGUB
		  GROUP BY A.SHPJPNO, A.JOCOD   ) Z
 WHERE X.JOCOD IS NOT NULL
	AND X.JOCOD = Z.JOCOD(+) ;
If SQLCA.SQLCODE <> 0 Then
	ldb_ppm = 0
End If

st_1.Text = '전체 PPM : ' + String(ldb_ppm, '#,##0.00')

Return 1
end function

on w_han_01040.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.st_1=create st_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.pb_2
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.rr_1
end on

on w_han_01040.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.st_1)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;dw_ip.SetItem(1, 'd_st', String(TODAY(), 'yyyymm' + '01'))
dw_ip.Setitem(1, 'd_ed', String(TODAY(), 'yyyymmdd'))

String ls_st
ls_st = f_get_syscnfg('Y', 89, 'ST')
If Trim(ls_st) = '' OR IsNull(ls_st) Then ls_st = '0800'

String ls_ed
ls_ed = f_get_syscnfg('Y', 89, 'ED')
If Trim(ls_ed) = '' OR IsNull(ls_ed) Then ls_ed = '0630'

dw_ip.SetItem(1, 'stim', ls_st)
dw_ip.SetItem(1, 'etim', ls_ed)
end event

type p_xls from w_standard_print`p_xls within w_han_01040
boolean visible = true
integer x = 4270
integer y = 24
boolean enabled = false
string picturename = "C:\erpman\image\엑셀변환_d.gif"
end type

event p_xls::clicked;//

If this.Enabled Then wf_excel_down(dw_1)
end event

type p_sort from w_standard_print`p_sort within w_han_01040
end type

type p_preview from w_standard_print`p_preview within w_han_01040
boolean visible = false
integer x = 2866
integer y = 40
end type

type p_exit from w_standard_print`p_exit within w_han_01040
end type

type p_print from w_standard_print`p_print within w_han_01040
boolean visible = false
integer x = 3054
integer y = 44
end type

type p_retrieve from w_standard_print`p_retrieve within w_han_01040
integer x = 4096
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

//	p_preview.enabled = False
//	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
	SetPointer(Arrow!)
	Return
Else
	p_xls.Enabled =True
	p_xls.PictureName =  'C:\erpman\image\엑셀변환_up.gif'
//	p_preview.enabled = true
//	p_preview.PictureName = 'C:\erpman\image\미리보기_up.gif'
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

type st_window from w_standard_print`st_window within w_han_01040
integer x = 2016
integer y = 2324
end type





type st_10 from w_standard_print`st_10 within w_han_01040
end type



type dw_print from w_standard_print`dw_print within w_han_01040
string dataobject = "d_han_01040_301"
end type

type dw_ip from w_standard_print`dw_ip within w_han_01040
integer x = 32
integer width = 2377
integer height = 180
string dataobject = "d_han_01040_001"
end type

event dw_ip::itemchanged;call super::itemchanged;If row < 1 Then Return

Choose Case dwo.name
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

type dw_list from w_standard_print`dw_list within w_han_01040
integer x = 55
integer y = 224
integer width = 4530
integer height = 1632
string dataobject = "d_han_01040_201"
end type

type dw_1 from datawindow within w_han_01040
integer x = 55
integer y = 1868
integer width = 4530
integer height = 360
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_han_01040_202"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
end type

event constructor;This.SetTransObject(SQLCA)
end event

type pb_1 from u_pb_cal within w_han_01040
integer x = 549
integer y = 64
integer height = 76
integer taborder = 130
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

type pb_2 from u_pb_cal within w_han_01040
integer x = 1179
integer y = 64
integer height = 76
integer taborder = 140
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

type st_1 from statictext within w_han_01040
integer x = 3168
integer y = 256
integer width = 1394
integer height = 84
boolean bringtotop = true
integer textsize = -16
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 16777215
alignment alignment = right!
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_han_01040
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 37
integer y = 212
integer width = 4567
integer height = 2032
integer cornerheight = 40
integer cornerwidth = 55
end type

