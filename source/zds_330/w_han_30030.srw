$PBExportHeader$w_han_30030.srw
$PBExportComments$개인별 달성률 현황 - 그래프
forward
global type w_han_30030 from w_standard_print
end type
type pb_1 from u_pb_cal within w_han_30030
end type
type pb_2 from u_pb_cal within w_han_30030
end type
type rr_1 from roundrectangle within w_han_30030
end type
type dw_1 from datawindow within w_han_30030
end type
type st_1 from statictext within w_han_30030
end type
end forward

global type w_han_30030 from w_standard_print
string title = "개인별 달성률 그래프 현황"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
dw_1 dw_1
st_1 st_1
end type
global w_han_30030 w_han_30030

forward prototypes
public function integer wf_retrieve ()
public subroutine wf_calc (string as_gub, string as_st, string as_ed, string as_stim, string as_etim, string as_jocod)
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
	ls_ed = '29991231'
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

String ls_gub

ls_gub = dw_ip.GetItemString(row, 'gubun')
If ls_gub = 'B' Then
	
	String ls_jocod
	
	ls_jocod = dw_ip.GetItemString(row, 'jocod')
	If Trim(ls_jocod) = '' OR IsNull(ls_jocod) Then
		MessageBox('블럭코드 확인', '블럭코드는 필수 입력 항목 입니다.')
		dw_ip.SetColumn('jocod')
		dw_ip.SetFocus()
		Return -1
	End If	
	
	dw_1.SetRedraw(False)
	dw_1.Retrieve(ls_st, ls_ed, ls_stim, ls_etim, ls_jocod)
	dw_1.SetRedraw(True)
	
	dw_list.SetRedraw(False)
	dw_list.Retrieve(ls_st, ls_ed, ls_stim, ls_etim, ls_jocod)
	dw_list.SetRedraw(True)
Else
	dw_1.SetRedraw(False)
	dw_1.Retrieve(ls_st, ls_ed, ls_stim, ls_etim)
	dw_1.SetRedraw(True)
	
	dw_list.SetRedraw(False)
	dw_list.Retrieve(ls_st, ls_ed, ls_stim, ls_etim)
	dw_list.SetRedraw(True)
End If

If dw_1.RowCount() < 1 Then Return -1
//dw_1.ShareData(dw_print)
wf_calc(ls_gub, ls_st, ls_ed, ls_stim, ls_etim, ls_jocod)

Return 1
end function

public subroutine wf_calc (string as_gub, string as_st, string as_ed, string as_stim, string as_etim, string as_jocod);Double ldb_dal

If as_gub = 'B' Then
	SELECT DECODE(SUM(NVL(AA.JIQTY, 0)), 0, 0, ROUND((SUM(NVL(AA.ROQTY, 0)) / SUM(NVL(AA.JIQTY, 0))) * 100, 2))
	  INTO :ldb_dal
	  FROM
	  (
	  SELECT SUM(NVL(A.ROQTY, 0)) AS ROQTY, SUM(NVL(D.JIQTY, 0)) AS JIQTY
		 FROM SHPACT A,
				ITEMAS B,
				ROUTNG C,
				ERPPOP.SHPACT_POP D
		WHERE A.STDAT||A.STIME >= :as_st||:as_stim
		  AND A.STDAT||A.STIME <= :as_ed||:as_etim
		  AND A.SIDAT||A.ETIME >= :as_st||:as_stim
		  AND A.SIDAT||A.ETIME <= :as_ed||:as_etim
		  AND A.JOCOD          =  :as_jocod
		  AND A.ITNBR          =  B.ITNBR
		  AND A.ITNBR          =  C.ITNBR
		  AND A.OPSNO          =  C.OPSEQ
		  AND A.CMNT           =  D.POPJPNO(+)
		  AND A.SHPJPNO NOT LIKE 'P%'
	GROUP BY A.JOCOD
	UNION ALL
	  SELECT SUM(NVL(A.ROQTY, 0)) AS ROQTY, SUM(NVL(D.PDQTY, 0)) AS JIQTY
		 FROM SHPACT A,
				ITEMAS B,
				ROUTNG C,
				ERPMAN.MOMAST@P_O_P D
		WHERE A.STDAT||A.STIME >= :as_st||:as_stim
		  AND A.STDAT||A.STIME <= :as_ed||:as_etim
		  AND A.SIDAT||A.ETIME >= :as_st||:as_stim
		  AND A.SIDAT||A.ETIME <= :as_ed||:as_etim
		  AND A.JOCOD          =  :as_jocod
		  AND A.ITNBR          =  B.ITNBR
		  AND A.ITNBR          =  C.ITNBR
		  AND A.OPSNO          =  C.OPSEQ
		  AND A.PORDNO         =  D.PORDNO(+)
		  AND A.SHPJPNO LIKE 'P%'
	GROUP BY A.JOCOD
	  ) AA;
	
	If IsNull(ldb_dal) Then ldb_dal = 0

	st_1.Text = as_jocod + '블럭 달성률(%) : ' + String(ldb_dal) + '% '
Else
	SELECT DECODE(SUM(NVL(AA.JIQTY, 0)), 0, 0, ROUND((SUM(NVL(AA.ROQTY, 0)) / SUM(NVL(AA.JIQTY, 0))) * 100, 2))
	  INTO :ldb_dal
	  FROM
	  (
	  SELECT SUM(NVL(A.ROQTY, 0)) AS ROQTY, SUM(NVL(D.JIQTY, 0)) AS JIQTY
		 FROM SHPACT A,
				ITEMAS B,
				ROUTNG C,
				ERPPOP.SHPACT_POP D
		WHERE A.STDAT||A.STIME >= :as_st||:as_stim
		  AND A.STDAT||A.STIME <= :as_ed||:as_etim
		  AND A.SIDAT||A.ETIME >= :as_st||:as_stim
		  AND A.SIDAT||A.ETIME <= :as_ed||:as_etim
		  AND A.ITNBR          =  B.ITNBR
		  AND A.ITNBR          =  C.ITNBR
		  AND A.OPSNO          =  C.OPSEQ
		  AND A.CMNT           =  D.POPJPNO(+)
		  AND A.SHPJPNO NOT LIKE 'P%'
		UNION ALL
	  SELECT SUM(NVL(A.ROQTY, 0)) AS ROQTY, SUM(NVL(D.PDQTY, 0)) AS JIQTY
		 FROM SHPACT A,
				ITEMAS B,
				ROUTNG C,
				ERPMAN.MOMAST@P_O_P D
		WHERE A.STDAT||A.STIME >= :as_st||:as_stim
		  AND A.STDAT||A.STIME <= :as_ed||:as_etim
		  AND A.SIDAT||A.ETIME >= :as_st||:as_stim
		  AND A.SIDAT||A.ETIME <= :as_ed||:as_etim
		  AND A.ITNBR          =  B.ITNBR
		  AND A.ITNBR          =  C.ITNBR
		  AND A.OPSNO          =  C.OPSEQ
		  AND A.PORDNO         =  D.PORDNO(+)
		  AND A.SHPJPNO LIKE 'P%'
	  ) AA;
	
	If IsNull(ldb_dal) Then ldb_dal = 0

	st_1.Text = '전체 달성률(%) : ' + String(ldb_dal) + '% '
End If

end subroutine

on w_han_30030.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
this.dw_1=create dw_1
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_1
this.Control[iCurrent+4]=this.dw_1
this.Control[iCurrent+5]=this.st_1
end on

on w_han_30030.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
destroy(this.dw_1)
destroy(this.st_1)
end on

event ue_open;call super::ue_open;dw_1.SetTransObject(SQLCA)

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

type p_xls from w_standard_print`p_xls within w_han_30030
boolean visible = true
integer x = 4224
integer y = 28
boolean enabled = false
string picturename = "C:\erpman\image\엑셀변환_d.gif"
end type

type p_sort from w_standard_print`p_sort within w_han_30030
integer x = 3675
integer y = 36
boolean enabled = false
boolean originalsize = false
end type

type p_preview from w_standard_print`p_preview within w_han_30030
boolean visible = false
integer x = 3323
integer y = 40
end type

type p_exit from w_standard_print`p_exit within w_han_30030
integer x = 4398
integer y = 28
end type

type p_print from w_standard_print`p_print within w_han_30030
boolean visible = false
integer x = 3497
integer y = 40
end type

type p_retrieve from w_standard_print`p_retrieve within w_han_30030
integer x = 4050
integer y = 28
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







type st_10 from w_standard_print`st_10 within w_han_30030
end type



type dw_print from w_standard_print`dw_print within w_han_30030
integer x = 3904
integer y = 60
string dataobject = "d_han_30030_002"
end type

type dw_ip from w_standard_print`dw_ip within w_han_30030
integer x = 37
integer width = 2971
integer height = 184
string dataobject = "d_han_30030_001"
end type

event dw_ip::itemchanged;call super::itemchanged;If row < 1 Then Return

Choose Case dwo.name
	Case 'gubun'
		If data = '%' Then
			dw_1.DataObject = 'd_han_30030_004'
			dw_list.DataObject = 'd_han_30030_005'
		Else
			dw_1.DataObject = 'd_han_30030_002'
			dw_list.DataObject = 'd_han_30030_003'
		End If
		
		st_1.Text = ''
		
		dw_1.SetTransObject(SQLCA)
		dw_list.SetTransObject(SQLCA)
		
	Case 'd_st'
		If Trim(data) = '' OR IsNull(data) Then Return

		If data = dw_ip.GetItemString(1, 'd_ed') Then
			dw_ip.SetItem(1, 'etim', '2400')
		Else
			dw_ip.SetItem(1, 'etim', f_get_syscnfg('Y', 89, 'ED'))
		End If
		
	Case 'd_ed'
		If Trim(data) = '' OR IsNull(data) Then Return

		If data = dw_ip.GetItemString(1, 'd_st') Then
			dw_ip.SetItem(1, 'etim', '2400')
		Else
			dw_ip.SetItem(1, 'etim', f_get_syscnfg('Y', 89, 'ED'))
		End If
		
End Choose

end event

type dw_list from w_standard_print`dw_list within w_han_30030
integer x = 46
integer y = 1976
integer width = 4544
integer height = 256
string dataobject = "d_han_30030_005"
boolean border = false
end type

event dw_list::rowfocuschanged;//

end event

event dw_list::clicked;//

end event

type pb_1 from u_pb_cal within w_han_30030
integer x = 658
integer y = 56
integer height = 76
integer taborder = 110
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

type pb_2 from u_pb_cal within w_han_30030
integer x = 1280
integer y = 60
integer height = 76
integer taborder = 120
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

type rr_1 from roundrectangle within w_han_30030
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 32
integer y = 212
integer width = 4571
integer height = 2032
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_1 from datawindow within w_han_30030
integer x = 46
integer y = 224
integer width = 4539
integer height = 1744
integer taborder = 50
string title = "none"
string dataobject = "d_han_30030_004"
boolean border = false
boolean livescroll = true
end type

type st_1 from statictext within w_han_30030
integer x = 3077
integer y = 248
integer width = 1504
integer height = 76
boolean bringtotop = true
integer textsize = -13
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean underline = true
long textcolor = 8388608
long backcolor = 16777215
alignment alignment = right!
boolean focusrectangle = false
end type

