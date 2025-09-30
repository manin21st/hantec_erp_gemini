$PBExportHeader$w_han_01030.srw
$PBExportComments$블럭/설비별 비가동 유형별 현황
forward
global type w_han_01030 from w_standard_print
end type
type dw_1 from datawindow within w_han_01030
end type
type pb_1 from u_pb_cal within w_han_01030
end type
type pb_2 from u_pb_cal within w_han_01030
end type
type cb_1 from commandbutton within w_han_01030
end type
type cb_2 from commandbutton within w_han_01030
end type
type st_1 from statictext within w_han_01030
end type
type rr_1 from roundrectangle within w_han_01030
end type
type st_2 from statictext within w_han_01030
end type
end forward

global type w_han_01030 from w_standard_print
string title = "블럭/설비별 비가동 유형별 현황"
dw_1 dw_1
pb_1 pb_1
pb_2 pb_2
cb_1 cb_1
cb_2 cb_2
st_1 st_1
rr_1 rr_1
st_2 st_2
end type
global w_han_01030 w_han_01030

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();dw_ip.AcceptText()

Long   row

row = dw_ip.GetRow()
If row < 1 Then Return -1

String ls_gub
String ls_title

ls_gub = dw_ip.GetItemString(row, 'gubun')
If ls_gub = '1' Then
	dw_list.DataObject = 'd_han_01030_301'
	dw_1.DataObject    = 'd_han_01030_302'
ElseIf ls_gub = '2' Then
	dw_list.DataObject = 'd_han_01030_401'
	dw_1.DataObject    = 'd_han_01030_402'
ElseIf ls_gub = '3' Then
	dw_list.DataObject = 'd_han_01030_201'
	dw_1.DataObject    = 'd_han_01030_202'
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

If ls_gub <> '3' Then
	String ls_jocod
	
	ls_jocod = dw_ip.GetItemString(row, 'jocod')
	If Trim(ls_jocod) = '' OR IsNull(ls_jocod) Then
		MessageBox('블럭코드 확인', '블럭코드는 필수 항목 입니다.')
		dw_ip.SetColumn('jocod')
		dw_ip.SetFocus()
		Return -1
	End If
End If

If ls_gub = '2' Then
	String ls_mch
	
	ls_mch = dw_ip.GetItemString(row, 'mchno')
	If Trim(ls_mch) = '' OR IsNull(ls_mch) Then
		MessageBox('설비코드 확인', '설비코드는 필수 항목 입니다.')
		dw_ip.SetColumn('mchno')
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

If ls_gub = '1' Then

	dw_list.SetRedraw(False)
	dw_list.Retrieve(ls_st, ls_ed, ls_jocod, ls_stim, ls_etim)
	dw_list.SetRedraw(True)
	
	If dw_list.RowCount() < 1 Then
		MessageBox('조회확인', '조회된 내역이 없습니다.')
		Return -1
	End If
	
	//dw_list.ShareData(dw_print)
	
	dw_1.SetRedraw(False)
	dw_1.Retrieve(ls_st, ls_ed, ls_jocod, ls_stim, ls_etim)
	dw_1.SetRedraw(True)
		
	ls_title = dw_ip.Describe("evaluate('lookupdisplay(jocod)',1)")
	
	dw_list.Modify("gr_1.Title = '" + ls_title + "'")
ElseIf ls_gub = '2' Then
	
	dw_list.SetRedraw(False)
	dw_list.Retrieve(ls_st, ls_ed, ls_jocod, ls_mch, ls_stim, ls_etim)
	dw_list.SetRedraw(True)
	
	If dw_list.RowCount() < 1 Then
		MessageBox('조회확인', '조회된 내역이 없습니다.')
		Return -1
	End If
	
	//dw_list.ShareData(dw_print)
	
	dw_1.SetRedraw(False)
	dw_1.Retrieve(ls_st, ls_ed, ls_jocod, ls_mch, ls_stim, ls_etim)
	dw_1.SetRedraw(True)
	
	
	ls_title = dw_ip.Describe("evaluate('lookupdisplay(jocod)',1)")+' / '+dw_ip.Describe("evaluate('lookupdisplay(mchno)',1)")
	
	dw_list.Modify("gr_1.Title = '" + ls_title + "'")
ElseIf ls_gub = '3' Then
	
	dw_list.SetRedraw(False)
	dw_list.Retrieve(ls_st, ls_ed, ls_stim, ls_etim)
	dw_list.SetRedraw(True)
	
	If dw_list.RowCount() < 1 Then
		MessageBox('조회확인', '조회된 내역이 없습니다.')
		Return -1
	End If
	
	//dw_list.ShareData(dw_print)
	
	dw_1.SetRedraw(False)
	dw_1.Retrieve(ls_st, ls_ed, ls_stim, ls_etim)
	dw_1.SetRedraw(True)
	
End If

Return 1
end function

on w_han_01030.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.cb_1=create cb_1
this.cb_2=create cb_2
this.st_1=create st_1
this.rr_1=create rr_1
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.pb_2
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.cb_2
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.rr_1
this.Control[iCurrent+8]=this.st_2
end on

on w_han_01030.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.st_1)
destroy(this.rr_1)
destroy(this.st_2)
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

event open;//
Integer  li_idx

li_idx = w_mdi_frame.dw_listbar.InsertRow(0)
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_id',Upper(This.ClassName()))
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_name',Upper(This.Title))
w_mdi_frame.Postevent("ue_barrefresh")

is_today = f_today()
is_totime = f_totime()
is_window_id = this.ClassName()

w_mdi_frame.st_window.Text = Upper(is_window_id)

SELECT "SUB2_T"."OPEN_HISTORY", "SUB2_T"."UPMU"  
  INTO :is_usegub,  :is_upmu 
  FROM "SUB2_T"  
 WHERE "SUB2_T"."WINDOW_NAME" = :is_window_id  ;

IF is_usegub = 'Y' THEN
   INSERT INTO "PGM_HISTORY"  
	 		 ( "L_USERID",   "CDATE",       "STIME",      "WINDOW_NAME",   "EDATE",   
			   "ETIME",      "IPADD",       "USER_NAME" )  
   VALUES ( :gs_userid,   :is_today,     :is_totime,   :is_window_id,   NULL, 
	   		NULL,         :gs_ipaddress, :gs_comname )  ;

   IF SQLCA.SQLCODE = 0 THEN 
	   COMMIT;
   ELSE 	  
	   ROLLBACK;
   END IF	  
END IF



DataWindowChild dwc_joc

dw_ip.GetChild('jocod', dwc_joc)
dwc_joc.SetTransObject(SQLCA)
dwc_joc.Retrieve()

DataWindowChild dwc_mch

dw_ip.GetChild('mchno', dwc_mch)
dwc_mch.SetTransObject(SQLCA)
dwc_mch.Retrieve('%')

//dw_ip.SetTransObject(SQLCA)
//dw_ip.Reset()
dw_ip.InsertRow(0)

dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)

IF is_upmu = 'A' THEN //회계인 경우
   int iRtnVal 

	IF Upper(Mid(is_window_id,4,2)) = 'BG' THEN							   /*예산*/
		IF F_Valid_EmpNo(Gs_EmpNo) = 'N' THEN							/*권한 체크- 현업 여부*/
			dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
			
			dw_ip.Modify("saupj.protect = 1")
		ELSE
			dw_ip.Modify("saupj.protect = 0")
		END IF
	ELSE
		IF Upper(Mid(is_window_id,4,2)) = 'FI' THEN							/*자금*/
			iRtnVal = F_Authority_Fund_Chk(Gs_Dept)	
		ELSE
			iRtnVal = F_Authority_Chk(Gs_Dept)
		END IF
		IF iRtnVal = -1 THEN							/*권한 체크- 현업 여부*/
			dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
			
			dw_ip.Modify("saupj.protect = 1")
		ELSE
			dw_ip.Modify("saupj.protect = 0")
		END IF	
	END IF
END IF
dw_print.object.datawindow.print.preview = "yes"	

dw_print.ShareData(dw_list)

PostEvent('ue_open')
end event

type p_xls from w_standard_print`p_xls within w_han_01030
boolean visible = true
integer x = 4247
integer y = 24
boolean enabled = false
string picturename = "C:\erpman\image\엑셀변환_d.gif"
end type

event p_xls::clicked;//

If this.Enabled Then wf_excel_down(dw_1)
end event

type p_sort from w_standard_print`p_sort within w_han_01030
integer x = 4224
integer y = 176
end type

type p_preview from w_standard_print`p_preview within w_han_01030
boolean visible = false
integer x = 3863
integer y = 176
end type

type p_exit from w_standard_print`p_exit within w_han_01030
integer x = 4421
end type

type p_print from w_standard_print`p_print within w_han_01030
boolean visible = false
integer x = 4037
integer y = 176
end type

type p_retrieve from w_standard_print`p_retrieve within w_han_01030
integer x = 4073
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







type st_10 from w_standard_print`st_10 within w_han_01030
end type



type dw_print from w_standard_print`dw_print within w_han_01030
integer x = 4384
integer y = 184
string dataobject = "d_han_01030_202"
end type

type dw_ip from w_standard_print`dw_ip within w_han_01030
integer x = 37
integer width = 3918
integer height = 184
string dataobject = "d_han_01030_001"
end type

event dw_ip::itemchanged;call super::itemchanged;If row < 1 Then Return

Choose Case dwo.name
	Case 'jocod'		
		DataWindowChild dwc_mch

		This.GetChild('mchno', dwc_mch)			
		dwc_mch.SetTransObject(SQLCA)
		
		If Trim(data) = '' OR IsNull(data) Then
			dwc_mch.Retrieve('%')
		Else
			dwc_mch.Retrieve(data)
		End If	
		
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

type dw_list from w_standard_print`dw_list within w_han_01030
integer x = 123
integer y = 224
integer width = 4466
integer height = 1600
string dataobject = "d_han_01030_201"
boolean border = false
end type

type dw_1 from datawindow within w_han_01030
integer x = 50
integer y = 1832
integer width = 4539
integer height = 400
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_han_01030_302"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
end type

event constructor;This.SetTransObject(SQLCA)
end event

type pb_1 from u_pb_cal within w_han_01030
integer x = 558
integer y = 64
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

type pb_2 from u_pb_cal within w_han_01030
integer x = 1184
integer y = 64
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

type cb_1 from commandbutton within w_han_01030
boolean visible = false
integer x = 82
integer y = 252
integer width = 343
integer height = 84
integer taborder = 140
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "건수"
end type

event clicked;//dw_list.Object.gr_1.values = 'cnt'
dw_list.Object.gr_1.Title  = '블럭별 비가동 건수'

//string ( sum(value) , '#,##0' ) + ' 건'
dw_list.Object.gr_1.values = 'sum(cnt for graph)'
dw_list.Object.gr_1.pie.dispattr.displayexpression="string ( sum(value) , '#,##0' ) + '(건)'"
end event

type cb_2 from commandbutton within w_han_01030
boolean visible = false
integer x = 82
integer y = 336
integer width = 343
integer height = 84
integer taborder = 150
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "시간(분)"
end type

event clicked;//dw_list.Object.gr_1.values = 'ntim'
dw_list.Object.gr_1.Title  = '블럭별 비가동 시간(분)'

//string ( sum(value) , '#,##0' ) + ' 건'
dw_list.Object.gr_1.values = 'sum(ntim for graph)'
dw_list.Object.gr_1.pie.dispattr.displayexpression="string ( sum(value) , '#,##0.00' ) + '(분)'"
end event

type st_1 from statictext within w_han_01030
integer x = 50
integer y = 888
integer width = 78
integer height = 272
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "굴림"
long textcolor = 33554432
long backcolor = 16777215
string text = "비가동원인"
alignment alignment = center!
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_han_01030
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

type st_2 from statictext within w_han_01030
integer x = 46
integer y = 224
integer width = 78
integer height = 1600
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "굴림"
long textcolor = 33554432
long backcolor = 16777215
alignment alignment = center!
boolean focusrectangle = false
end type

