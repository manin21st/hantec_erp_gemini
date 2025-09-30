$PBExportHeader$w_adt_10100_han.srw
$PBExportComments$용차사용 등록
forward
global type w_adt_10100_han from w_inherite
end type
type dw_list from datawindow within w_adt_10100_han
end type
type dw_top from datawindow within w_adt_10100_han
end type
type dw_print from datawindow within w_adt_10100_han
end type
type dw_dtl from datawindow within w_adt_10100_han
end type
type rr_2 from roundrectangle within w_adt_10100_han
end type
type rr_1 from roundrectangle within w_adt_10100_han
end type
type dw_mis from datawindow within w_adt_10100_han
end type
type dw_pop from datawindow within w_adt_10100_han
end type
type cb_1 from commandbutton within w_adt_10100_han
end type
end forward

global type w_adt_10100_han from w_inherite
integer width = 4686
integer height = 2908
string title = "용차사용 등록"
dw_list dw_list
dw_top dw_top
dw_print dw_print
dw_dtl dw_dtl
rr_2 rr_2
rr_1 rr_1
dw_mis dw_mis
dw_pop dw_pop
cb_1 cb_1
end type
global w_adt_10100_han w_adt_10100_han

forward prototypes
public function integer wf_month (string as_jpno)
end prototypes

public function integer wf_month (string as_jpno);String ls_usedat
ls_usedat = dw_insert.GetItemString(1, 'usedat')
If Trim(ls_usedat) = '' Or IsNull(ls_usedat) Then
	MessageBox('사용일자 확인', '사용일자를 입력 하십시오.')
	Return -1
End If

String ls_last
  SELECT TO_CHAR(LAST_DAY(TO_DATE(:ls_usedat, 'YYYYMMDD')), 'YYYYMMDD')
    INTO :ls_last
	 FROM DUAL ;
If SQLCA.SQLCODE <> 0 Then Return -1

Long   ll_last
ll_last = Long(RIGHT(ls_last, 2)) - 1 /* 이미 생성 된 1개의 자료를 이용하기 때문에 1개를 뺌 */

Integer i
Integer li_seq
li_seq  = Integer(RIGHT(as_jpno, 3))

String ls_jpno
For i = 1 To ll_last
	li_seq  = li_seq + 1
	ls_jpno = LEFT(as_jpno, 4) + String(li_seq, '000')
	
	INSERT INTO YONGCHA (
	JPNO , USEDPT, USEDAT , USETIM, IPCUST, ETCCUST, USEAMT,
	CVCOD, MISVND, YONGVND, DRIVER, CALLNO, CARNO  , BANK  ,
	ACCNO, MAKEMP, GUBUN  , MAKDAT, DTLAMT, CVNAME , T_GBN )
	SELECT :ls_jpno, USEDPT, USEDAT , USETIM, IPCUST, ETCCUST, USEAMT,
	       CVCOD   , MISVND, YONGVND, DRIVER, CALLNO, CARNO  , BANK  ,
	       ACCNO   , MAKEMP, GUBUN  , MAKDAT, DTLAMT, CVNAME , T_GBN
	  FROM YONGCHA
	 WHERE JPNO = :as_jpno ;
	If SQLCA.SQLCODE <> 0 Then
		ROLLBACK USING SQLCA;
		MessageBox('생성 오류', '자료 생성 중 오류가 발생했습니다.')
		Return -1
	End If
Next

Return 1
end function

on w_adt_10100_han.create
int iCurrent
call super::create
this.dw_list=create dw_list
this.dw_top=create dw_top
this.dw_print=create dw_print
this.dw_dtl=create dw_dtl
this.rr_2=create rr_2
this.rr_1=create rr_1
this.dw_mis=create dw_mis
this.dw_pop=create dw_pop
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
this.Control[iCurrent+2]=this.dw_top
this.Control[iCurrent+3]=this.dw_print
this.Control[iCurrent+4]=this.dw_dtl
this.Control[iCurrent+5]=this.rr_2
this.Control[iCurrent+6]=this.rr_1
this.Control[iCurrent+7]=this.dw_mis
this.Control[iCurrent+8]=this.dw_pop
this.Control[iCurrent+9]=this.cb_1
end on

on w_adt_10100_han.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_list)
destroy(this.dw_top)
destroy(this.dw_print)
destroy(this.dw_dtl)
destroy(this.rr_2)
destroy(this.rr_1)
destroy(this.dw_mis)
destroy(this.dw_pop)
destroy(this.cb_1)
end on

event open;call super::open;This.PostEvent('ue_open')

end event

event ue_open;call super::ue_open;dw_top.SetItem(1, 'd_st', String(TODAY(), 'yyyymm' + '01'))
dw_top.SetItem(1, 'd_ed', String(TODAY(), 'yyyymmdd'))

dw_insert.SetItem(1, 'makemp' , gs_empno                       )
dw_insert.SetItem(1, 'empname', f_get_name5('02', gs_empno, ''))
dw_insert.SetItem(1, 'usedpt' , gs_dept                        )
dw_insert.SetItem(1, 'dptnm'  , f_get_name5('01', gs_dept, '') )
dw_insert.SetItem(1, 'makdat' , String(TODAY(), 'yyyymmdd')    )
dw_insert.SetItem(1, 'usedat' , String(TODAY(), 'yyyymmdd')    )
dw_insert.SetItem(1, 'usetim' , String(TODAY(), 'hhmm')        )
end event

type dw_insert from w_inherite`dw_insert within w_adt_10100_han
integer x = 1710
integer y = 256
integer width = 2885
integer height = 1120
integer taborder = 140
string dataobject = "d_adt_10100_han_03"
boolean border = false
end type

event dw_insert::constructor;call super::constructor;This.SetTransObject(SQLCA)
This.InsertRow(0)
end event

event dw_insert::rbuttondown;call super::rbuttondown;If row < 1 Then Return

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case dwo.name
	Case 'cvcod'
		gs_gubun = '1'
		Open(w_vndmst_popup)
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
	
		This.SetItem(row, 'cvcod' , gs_code    )
		This.SetItem(row, 'cvname', gs_codename)
		
		String ls_own
		String ls_tel[]
		
	   SELECT OWNAM, TELDDD, TELNO1, TELNO2
		  INTO :ls_own, :ls_tel[1], :ls_tel[2], :ls_tel[3]
        FROM VNDMST
       WHERE CVCOD = :gs_code ;
		 
		This.SetItem(row, 'driver', ls_own)
		This.SetItem(row, 'callno', ls_tel[1] + '-' + ls_tel[2] + '-' + ls_tel[3])
		
	Case 'usedpt'
		gs_gubun = '4'
		Open(w_vndmst_popup)
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
	
		This.SetItem(row, 'usedpt', gs_code    )
		This.SetItem(row, 'dptnm' , gs_codename)
		
	Case 'misvnd'
		gs_gubun = '1'
		Open(w_vndmst_popup)
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
	
		This.SetItem(row, 'misvnd', gs_code    )
		This.SetItem(row, 'misnas', gs_codename)
		
	Case 'yongvnd'
		gs_gubun = '1'
		Open(w_vndmst_popup)
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
	
		This.SetItem(row, 'yongvnd', gs_code    )
		This.SetItem(row, 'yongnas', gs_codename)
		
	Case 'bank'
		gs_gubun = '3'
		Open(w_vndmst_popup)
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
	
		This.SetItem(row, 'bank'   , gs_code    )
		This.SetItem(row, 'banknas', gs_codename)
		
	Case 'makemp'
		Open(w_sawon_popup)
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
	
		This.SetItem(row, 'makemp' , gs_code    )
		This.SetItem(row, 'empname', gs_codename)
		
	Case 'itnbr'
		gs_gubun = '1'
		
		str_code lst_code
		String ls_itn
		Long   i
		Long   ll
		
		ll = 0
		
		Open(w_itemas_multi_popup_yongcha)
		
		lst_code = Message.PowerObjectParm
		
		If IsValid(lst_code) = False Then Return 
		
		If UpperBound(lst_code.code) < 1 Then Return 
		
		This.SetColumn('itnbr')
		
		For i = row To UpperBound(lst_code.code) + row - 1
			ll++
						
			If Trim(lst_code.code[ll]) = '' OR IsNull(lst_code.code[ll]) Then
			Else
				If ll = 1 Then
					ls_itn = lst_code.code[ll] + ' : ' + String(lst_code.dgubun1[ll]) + lst_code.sgubun4[ll]
				Else
					ls_itn = ls_itn + ', ' + lst_code.code[ll] + ' : ' + String(lst_code.dgubun1[ll]) + lst_code.sgubun4[ll]
				End If
			End If
		Next
		
		String ls_val
		ls_val = This.GetItemString(row, 'itnbr')
		If Trim(ls_val) = '' OR IsNull(ls_val) Then
			This.SetItem(row, 'itnbr', ls_itn)
		Else
			This.SetItem(row, 'itnbr', ls_val + ', ' + ls_itn)
		End If
		
End Choose




end event

event dw_insert::itemchanged;call super::itemchanged;If row < 1 Then Return

Choose Case dwo.name
	Case 'cvcod'
		If Trim(data) = '' OR IsNull(data) Then
			This.SetItem(row, 'cvname', '')
//			This.SetItem(row, 'cvcod'  , '')
			Return
		End If
	
		This.SetItem(row, 'cvname', f_get_name5('11', data, ''))
//		
//		String ls_own
//		String ls_tel[]
//		String ls_data
//		
//		ls_data = data
//		
//	   SELECT OWNAM, TELDDD, TELNO1, TELNO2
//		  INTO :ls_own, :ls_tel[1], :ls_tel[2], :ls_tel[3]
//        FROM VNDMST
//       WHERE CVCOD = :ls_data ;
//		 
//		This.SetItem(row, 'driver', ls_own)
//		This.SetItem(row, 'callno', ls_tel[1] + '-' + ls_tel[2] + '-' + ls_tel[3])
		
	Case 'usedpt'
		If Trim(data) = '' OR IsNull(data) Then
			This.SetItem(row, 'dptnm', '')
			Return
		End If
		
		This.SetItem(row, 'dptnm' , f_get_name5('01', data, ''))
		
	Case 'misvnd'
		If Trim(data) = '' OR IsNull(data) Then
			This.SetItem(row, 'misnas', '')
			Return
		End If
		
		This.SetItem(row, 'misnas', f_get_name5('11', data, ''))
		
	Case 'yongvnd'
		If Trim(data) = '' OR IsNull(data) Then
			This.SetItem(row, 'yongnas', '')
			Return
		End If
		
		This.SetItem(row, 'yongnas', f_get_name5('11', data, ''))
		
	Case 'bank'
		If Trim(data) = '' OR IsNull(data) Then
			This.SetItem(row, 'banknas', '')
			Return
		End If
		
		This.SetItem(row, 'banknas', f_get_name5('11', data, ''))
		
	Case 'makemp'
		If Trim(data) = '' OR IsNull(data) Then
			This.SetItem(row, 'empname', '')
			Return
		End If
		
		This.SetItem(row, 'empname', f_get_name5('02', data, ''))
		
	Case 'carno'
		If Trim(data) = '' OR IsNull(data) Then Return
		
		String ls_na1
		String ls_na5
		
		SELECT RFNA1  , RFNA5
		  INTO :ls_na1, :ls_na5
		  FROM REFFPF
		 WHERE RFCOD = '2R'
		   AND RFGUB = :data ;
			
		This.SetItem(row, 'driver', ls_na1)
		This.SetItem(row, 'callno', ls_na5)
		
	Case 'gubun'		
		If data = '1' Then
			cb_1.Enabled = True
		Else
			cb_1.Enabled = False
		End If
		
End Choose








end event

event dw_insert::ue_pressenter;//
If This.GetRow() < 1 Then Return

Choose Case This.GetColumnName()
	Case 'wonin', 'reform', 'itnbr'
		Return
End Choose

Send(Handle(This), 256, 9, 0)
Return 1
		
end event

event dw_insert::buttonclicked;call super::buttonclicked;If row < 1 Then Return

Choose Case dwo.name
	Case 'b_ins'
		dw_mis.Visible = True
		
		String ls_jpno
		ls_jpno = dw_insert.GetItemString(1, 'jpno')
		If Trim(ls_jpno) = '' OR IsNull(ls_jpno) Then
			dw_mis.InsertRow(0)
		Else
			If dw_mis.Retrieve(ls_jpno) < 1 Then
				dw_mis.InsertRow(0)
			End If
		End If
		
		dw_mis.SetColumn('misvnd')
		dw_mis.SetFocus()
		dw_mis.SetRow(1)
End Choose
end event

type p_delrow from w_inherite`p_delrow within w_adt_10100_han
integer x = 4402
integer y = 1388
integer taborder = 50
boolean enabled = false
string picturename = "C:\erpman\image\행삭제_d.gif"
end type

event p_delrow::clicked;call super::clicked;Long   row

row = dw_dtl.GetRow()
If row < 1 Then Return

If f_msg_delete() <> 1 Then Return

dw_dtl.DeleteRow(row)

If dw_dtl.UPDATE() = 1 Then
	COMMIT USING SQLCA;
Else
	ROLLBACK USING SQLCA;
	MessageBox('삭제실패', '삭제 진행 중 오류가 발생 했습니다.')
	Return
End If

end event

type p_addrow from w_inherite`p_addrow within w_adt_10100_han
integer x = 4229
integer y = 1388
boolean enabled = false
string picturename = "C:\erpman\image\행추가_d.gif"
end type

event p_addrow::clicked;call super::clicked;Long   row

row = dw_insert.GetRow()
If row < 1 Then Return

String ls_jpno

ls_jpno = dw_insert.GetItemString(row, 'jpno')
If Trim(ls_jpno) = '' OR IsNull(ls_jpno) Then
	MessageBox('관리번호 확인', '마스터 정보를 먼저 등록 하십시오.')
	Return
End If

Long   ll_ins

ll_ins = dw_dtl.InsertRow(0)

dw_dtl.ScrollToRow(ll_ins)
dw_dtl.SetColumn('pop')
dw_dtl.SetFocus()

dw_dtl.TriggerEvent(Clicked!)
end event

type p_search from w_inherite`p_search within w_adt_10100_han
boolean visible = false
integer x = 2862
integer width = 174
integer taborder = 110
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_adt_10100_han
integer x = 3730
end type

event p_ins::clicked;call super::clicked;dw_insert.ReSet()
dw_dtl.ReSet()
dw_mis.ReSet()
dw_pop.ReSet()

dw_insert.InsertRow(0)
dw_pop.InsertRow(0)
dw_mis.InsertRow(0)

//dw_insert.Enabled = True

dw_insert.SetItem(1, 'makemp' , gs_empno                       )
dw_insert.SetItem(1, 'empname', f_get_name5('02', gs_empno, ''))
dw_insert.SetItem(1, 'usedpt' , gs_dept                        )
dw_insert.SetItem(1, 'dptnm'  , f_get_name5('01', gs_dept, '') )
dw_insert.SetItem(1, 'makdat' , String(TODAY(), 'yyyymmdd')    )
dw_insert.SetItem(1, 'usedat' , String(TODAY(), 'yyyymmdd')    )
dw_insert.SetItem(1, 'usetim' , String(TODAY(), 'hhmm')        )

p_addrow.PictureName = 'C:\erpman\image\행추가_d.gif'
p_delrow.PictureName = 'C:\erpman\image\행삭제_d.gif'
p_addrow.Enabled     = False
p_delrow.Enabled     = False

////관리번호 채번
//String ls_ym
//ls_ym = String(TODAY(), 'yymm')
//
//String ls_max
//Long   ll_max
//
//SELECT MAX(SUBSTR(JPNO, 5, 2))
//  INTO :ls_max
//  FROM YONGCHA
// WHERE JPNO LIKE :ls_ym||'%' ;
//If Trim(ls_max) = '' OR IsNull(ls_max) Then
//	ll_max = 1
//Else
//	ll_max = Long(ls_max) + 1
//End If
//
//String ls_jpno
//ls_jpno = ls_ym + String(ll_max, '00')
//
//Long   ll_dup
//SELECT COUNT('X')
//  INTO :ll_dup
//  FROM YONGCHA
// WHERE JPNO = :ls_jpno ;
//If ll_dup > 0 Then
//	MessageBox('관리번호 생성', '관리번호 생성이 정상적으로 이루어지지 않았습니다.~r~n전산실로 문의 하십시오.')
//	Return
//End If
//
//dw_insert.SetItem(1, 'jpno', ls_jpno)
//
////---------------------------------------------------------

end event

type p_exit from w_inherite`p_exit within w_adt_10100_han
integer x = 4425
integer taborder = 100
end type

type p_can from w_inherite`p_can within w_adt_10100_han
integer x = 4251
integer taborder = 90
end type

event p_can::clicked;call super::clicked;dw_top.ReSet()
dw_list.ReSet()
dw_insert.ReSet()
dw_dtl.ReSet()
dw_mis.ReSet()
dw_pop.ReSet()

dw_top.InsertRow(0)
dw_insert.InsertRow(0)
dw_pop.InsertRow(0)
dw_mis.InsertRow(0)

dw_insert.Enabled = False

dw_top.SetItem(1, 'd_st', String(TODAY(), 'yyyymm' + '01'))
dw_top.SetItem(1, 'd_ed', String(TODAY(), 'yyyymmdd'))

dw_insert.SetItem(1, 'makemp' , gs_empno                       )
dw_insert.SetItem(1, 'empname', f_get_name5('02', gs_empno, ''))
dw_insert.SetItem(1, 'usedpt' , gs_dept                        )
dw_insert.SetItem(1, 'dptnm'  , f_get_name5('01', gs_dept, '') )
dw_insert.SetItem(1, 'makdat' , String(TODAY(), 'yyyymmdd')    )
dw_insert.SetItem(1, 'usedat' , String(TODAY(), 'yyyymmdd')    )
dw_insert.SetItem(1, 'usetim' , String(TODAY(), 'hhmm')        )

p_addrow.PictureName = 'C:\erpman\image\행추가_d.gif'
p_delrow.PictureName = 'C:\erpman\image\행삭제_d.gif'
p_addrow.Enabled     = False
p_delrow.Enabled     = False

ib_any_typing = False
end event

type p_print from w_inherite`p_print within w_adt_10100_han
integer x = 3383
integer taborder = 120
end type

event p_print::clicked;call super::clicked;If dw_list.GetRow() < 1 Then Return

String ls_jpno

ls_jpno = dw_list.GetItemString(dw_list.GetRow(), 'yongcha_jpno')
dw_print.Retrieve(ls_jpno)

OpenWithParm(w_print_preview, dw_print)
end event

type p_inq from w_inherite`p_inq within w_adt_10100_han
integer x = 3557
end type

event p_inq::clicked;call super::clicked;dw_top.AcceptText()

Long   row

row = dw_top.GetRow()
If row < 1 Then Return

String ls_st

ls_st = dw_top.GetItemString(row, 'd_st')
If Trim(ls_st) = '' OR IsNull(ls_st) Then
	ls_st = '19000101'
Else
	If IsDate(LEFT(ls_st, 4) + '.' + MID(ls_st, 5, 2) + '.' + RIGHT(ls_st, 2)) = False Then
		MessageBox('일자확인', '일자 형식이 잘못 되었습니다!')
		dw_top.SetColumn('d_st')
		dw_top.SetFocus()
		Return
	End If
End If

String ls_ed

ls_ed = dw_top.GetItemString(row, 'd_ed')
If Trim(ls_ed) = '' OR IsNull(ls_ed) Then
	ls_ed = '29991231'
Else
	If IsDate(LEFT(ls_ed, 4) + '.' + MID(ls_ed, 5, 2) + '.' + RIGHT(ls_ed, 2)) = False Then
		MessageBox('일자확인', '일자 형식이 잘못 되었습니다!')
		dw_top.SetColumn('d_ed')
		dw_top.SetFocus()
		Return
	End If
End If

If ls_st > ls_ed Then
	MessageBox('기간 확인', '시작일 보다 종료일이 빠릅니다.')
	dw_top.SetColumn('d_ed')
	dw_top.SetFocus()
	Return
End If

String ls_ip

ls_ip = dw_top.GetItemString(row, 'ipcust')
If Trim(ls_ip) = '' OR IsNull(ls_ip) Then ls_ip = '%'

dw_list.SetRedraw(False)
dw_list.Retrieve(ls_st, ls_ed, ls_ip)
dw_list.SetRedraw(True)

If dw_list.RowCount() < 1 Then Return

p_addrow.PictureName = 'C:\erpman\image\행추가_up.gif'
p_delrow.PictureName = 'C:\erpman\image\행삭제_up.gif'
p_addrow.Enabled     = True
p_delrow.Enabled     = True

//dw_insert.Enabled = True


end event

type p_del from w_inherite`p_del within w_adt_10100_han
integer x = 4078
integer taborder = 80
end type

event p_del::clicked;call super::clicked;Long   row

row = dw_list.GetRow()
If row < 1 Then Return

If f_msg_delete() <> 1 Then Return

String ls_jpno
ls_jpno = dw_list.GetItemString(row, 'yongcha_jpno')

dw_list.DeleteRow(row)

If dw_list.UPDATE() = 1 Then
	DELETE YONGCHA_DTL
	 WHERE JPNO = :ls_jpno ;
	If SQLCA.SQLCODE <> 0 Then
		ROLLBACK USING SQLCA;
		MessageBox('삭제실패', '선택 자료 삭제 중 오류가 발생했습니다.')
		Return
	End If
	
	DELETE YONGCHA_MISVND
	 WHERE JPNO = :ls_jpno ;
	If SQLCA.SQLCODE <> 0 Then
		ROLLBACK USING SQLCA;
		MessageBox('삭제실패', '선택 자료 삭제 중 오류가 발생했습니다.')
		Return
	End If
	
	COMMIT USING SQLCA;
Else
	ROLLBACK USING SQLCA;
	MessageBox('삭제실패', '선택 자료 삭제 중 오류가 발생했습니다.')
	Return
End If
	
p_inq.PostEvent(Clicked!)

ib_any_typing = False
end event

type p_mod from w_inherite`p_mod within w_adt_10100_han
integer x = 3904
integer taborder = 70
end type

event p_mod::clicked;call super::clicked;dw_insert.AcceptText()

Long   row

row = dw_insert.GetRow()
If row < 1 Then Return

If f_msg_update() <> 1 Then Return

If dw_insert.GetItemStatus(row, 0, Primary!) = New! OR dw_insert.GetItemStatus(row, 0, Primary!) = NewModified! Then
	String ls_ym
	
	ls_ym = String(TODAY(), 'yymm')
	
	//관리번호 채번
	String ls_max
	Long   ll_max
	
	SELECT MAX(SUBSTR(JPNO, 5, 3))
	  INTO :ls_max
	  FROM YONGCHA
	 WHERE JPNO LIKE :ls_ym||'%' ;
	If Trim(ls_max) = '' OR IsNull(ls_max) Then
		ll_max = 1
	Else
		ll_max = Long(ls_max) + 1
	End If
	
	String ls_jpno
	ls_jpno = ls_ym + String(ll_max, '000')
	
	Long   ll_dup
	SELECT COUNT('X')
	  INTO :ll_dup
	  FROM YONGCHA
	 WHERE JPNO = :ls_jpno ;
	If ll_dup > 0 Then
		MessageBox('관리번호 생성', '관리번호 생성이 정상적으로 이루어지지 않았습니다.~r~n전산실로 문의 하십시오.')
		Return
	End If
	
	dw_insert.SetItem(row, 'jpno', ls_jpno)
	
	//---------------------------------------------------------
End If

//필수 확인
String ls_dpt
ls_dpt = dw_insert.GetItemString(row, 'usedpt')
If Trim(ls_dpt) = '' OR IsNull(ls_dpt) Then
	MessageBox('사용부서 확인', '사용부서는 필수 항목 입니다.')
	dw_insert.SetColumn('usedpt')
	dw_insert.setFocus()
	Return
End If

String ls_day
ls_day = dw_insert.GetItemString(row, 'usedat')
If Trim(ls_day) = '' OR IsNull(ls_day) Then
	MessageBox('사용일시 확인', '사용일은 필수 항목 입니다.')
	dw_insert.SetColumn('usedat')
	dw_insert.SetFocus()
	Return
End If

String ls_tim
ls_tim = dw_insert.GetItemString(row, 'usetim')
If Trim(ls_tim) = '' OR IsNull(ls_tim) Then
	MessageBox('사용시간 확인', '사용시간은 필수 항목 입니다.')
	dw_insert.SetColumn('usetim')
	dw_insert.SetFocus()
	Return
End If

String ls_ip
ls_ip = dw_insert.GetItemString(row, 'ipcust')
If Trim(ls_ip) = '' OR IsNull(ls_ip) Then
	MessageBox('입고처 확인', '입고처는 필수 항목 입니다.')
	dw_insert.SetColumn('ipcust')
	dw_insert.SetFocus()
	Return
End If

//Double ldb_amt
//ldb_amt = dw_insert.GetItemNumber(row, 'useamt')
//If ldb_amt < 1 OR IsNull(ldb_amt) Then
//	MessageBox('사용금액 확인', '사용금액은 필수 항목 입니다.')
//	dw_insert.SetColumn('useamt')
//	dw_insert.SetFocus()
//	Return
//End If

String ls_mak
ls_mak = dw_insert.GetItemString(row, 'makemp')
If Trim(ls_mak) = '' OR IsNull(ls_mak) Then
	MessageBox('작성자 확인', '작성자는 필수 항목 입니다.')
	dw_insert.SetColumn('makemp')
	dw_insert.SetFocus()
	Return
End If

String ls_dat
ls_dat = dw_insert.GetItemString(row, 'makdat')
If Trim(ls_dat) = '' OR IsNull(ls_dat) Then
	MessageBox('작성일 확인', '작성일은 필수 항목 입니다.')
	dw_insert.SetColumn('makdat')
	dw_insert.SetFocus()
	Return
End If

String ls_gub
ls_gub = dw_insert.GetItemString(row, 'gubun')
If Trim(ls_gub) = '' OR IsNull(ls_gub) Then
	MessageBox('구분확인', '정규/비정규 구분은 필수 항목 입니다.')
	dw_insert.SetColumn('gubun')
	dw_insert.SetFocus()
	Return
End If

String ls_tgub
ls_tgub = dw_insert.GetItemString(row, 't_gbn')
If Trim(ls_tgub) = '' OR IsNull(ls_tgub) Then
	MessageBox('자료구분 확인', '용차/택배 구분은 필수 항목 입니다.')
	dw_insert.SetColumn('t_gbn')
	dw_insert.SetFocus()
	Return
End If

//추가 귀책처 저장
dw_mis.AcceptText()

Long   ll_cnt
Long   i
ll_cnt = dw_mis.RowCount()
If ll_cnt > 0 Then
	String ls_vnd
	String ls_key
	ls_key = dw_insert.GetItemString(row, 'jpno')
	For i = 1 To dw_mis.RowCount()
		If i > dw_mis.RowCount() Then Exit
		ls_vnd = dw_mis.GetItemString(i, 'misvnd')
		If Trim(ls_vnd) = '' OR IsNull(ls_vnd) Then
			dw_mis.DeleteRow(i)
			i = i - 1
		Else
			dw_mis.SetItem(i, 'jpno', ls_key)
		End If
	Next
End If

If dw_insert.UPDATE() = 1 Then
	If dw_mis.UPDATE() = 1 Then
		COMMIT USING SQLCA;
	Else
		ROLLBACK USING SQLCA;
		MessageBox('저장실패', '자료 저장에 실패 했습니다.')
		Return
	End If
Else
	ROLLBACK USING SQLCA;
	MessageBox('저장실패', '자료 저장에 실패 했습니다.')
	Return
End If

p_inq.TriggerEvent(Clicked!)

Long   ll_find

ll_find = dw_list.FIND("yongcha_jpno = '" + ls_jpno + "'", 1, dw_list.RowCount())
If ll_find < 1 Then Return

dw_list.ScrollToRow(ll_find)
dw_list.SelectRow(0, False)
dw_list.SelectRow(ll_find, True)

p_addrow.PictureName = 'C:\erpman\image\행추가_up.gif'
p_delrow.PictureName = 'C:\erpman\image\행삭제_up.gif'
p_addrow.Enabled     = True
p_delrow.Enabled     = True

ib_any_typing = False
end event

type cb_exit from w_inherite`cb_exit within w_adt_10100_han
end type

type cb_mod from w_inherite`cb_mod within w_adt_10100_han
end type

type cb_ins from w_inherite`cb_ins within w_adt_10100_han
end type

type cb_del from w_inherite`cb_del within w_adt_10100_han
end type

type cb_inq from w_inherite`cb_inq within w_adt_10100_han
end type

type cb_print from w_inherite`cb_print within w_adt_10100_han
end type

type st_1 from w_inherite`st_1 within w_adt_10100_han
end type

type cb_can from w_inherite`cb_can within w_adt_10100_han
end type

type cb_search from w_inherite`cb_search within w_adt_10100_han
end type







type gb_button1 from w_inherite`gb_button1 within w_adt_10100_han
end type

type gb_button2 from w_inherite`gb_button2 within w_adt_10100_han
end type

type dw_list from datawindow within w_adt_10100_han
integer x = 50
integer y = 268
integer width = 1623
integer height = 1964
integer taborder = 130
boolean bringtotop = true
string title = "none"
string dataobject = "d_adt_10100_han_02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event constructor;This.SetTransObject(SQLCA)

end event

event retrieveend;If rowcount < 1 Then Return

Long   row

row = This.GetRow()
If row < 1 Then Return

String ls_jpno

ls_jpno = This.GetItemString(row, 'yongcha_jpno')
If Trim(ls_jpno) = '' OR IsNull(ls_jpno) Then
	MessageBox('관리번호 오류', '관리번호 오류 입니다.~r~n~n전산실로 문의 하십시오.')
	Return
End If

If dw_insert.Retrieve(ls_jpno) < 1 Then
	dw_insert.InsertRow(0)
	Return
End If

dw_print.Retrieve(ls_jpno)

dw_dtl.SetRedraw(False)
dw_dtl.Retrieve(ls_jpno)
dw_dtl.SetRedraw(True)

dw_mis.SetRedraw(False)
If dw_mis.Retrieve(ls_jpno) < 1 Then
	dw_mis.InsertRow(0)
End If
dw_mis.SetRedraw(True)

end event

event rowfocuschanged;Long   row

row = This.GetRow()
If row < 1 Then Return

This.SelectRow(0, False)
This.SetRow(row)
This.SelectRow(row, True)

String ls_jpno

ls_jpno = This.GetItemString(row, 'yongcha_jpno')
If Trim(ls_jpno) = '' OR IsNull(ls_jpno) Then
	MessageBox('관리번호 오류', '관리번호 오류 입니다.~r~n~n전산실로 문의 하십시오.')
	Return
End If

If dw_insert.Retrieve(ls_jpno) < 1 Then
	dw_insert.InsertRow(0)
	Return
End If

dw_print.Retrieve(ls_jpno)

dw_dtl.SetRedraw(False)
dw_dtl.Retrieve(ls_jpno)
dw_dtl.SetRedraw(True)

end event

event clicked;If row < 1 Then Return

This.PostEvent(RowFocusChanged!)
end event

type dw_top from datawindow within w_adt_10100_han
integer x = 37
integer y = 28
integer width = 2821
integer height = 208
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_adt_10100_han_01"
boolean border = false
boolean livescroll = true
end type

event constructor;This.InsertRow(0)
end event

type dw_print from datawindow within w_adt_10100_han
boolean visible = false
integer x = 3077
integer y = 40
integer width = 105
integer height = 100
integer taborder = 60
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_adt_10100_han_04"
boolean border = false
boolean livescroll = true
end type

event constructor;This.SetTransObject(SQLCA)
end event

type dw_dtl from datawindow within w_adt_10100_han
integer x = 1719
integer y = 1548
integer width = 2871
integer height = 688
integer taborder = 150
boolean bringtotop = true
string title = "none"
string dataobject = "d_adt_10100_han_05"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event constructor;This.SetTransObject(SQLCA)
end event

event clicked;Long   ll_row

ll_row = dw_dtl.GetRow()

If row < 1 Then Return

dw_dtl.SelectRow(0, False)
dw_dtl.SetRow(ll_row)
dw_dtl.SelectRow(ll_row, True)

Choose Case This.GetColumnName()
	Case 'pop', ''
		dw_pop.ReSet()
		
		String ls_jpno
		ls_jpno = dw_insert.GetItemString(1, 'jpno')
		If Trim(ls_jpno) = '' OR IsNull(ls_jpno) Then
			MessageBox('관리번호 확인', '마스터 정보를 먼저 생성 하십시오.')
			Return
		End If
		
		String ls_pop
		ls_pop = dw_dtl.GetItemString(ll_row, 'pop')
		Long   ll_seq
		ll_seq = dw_dtl.GetItemNumber(ll_row, 'seq')
		If ls_pop = '등록' Then
			dw_pop.InsertRow(0)
			dw_pop.SetItem(1, 'jpno', ls_jpno)
		Else
			dw_pop.Retrieve(ls_jpno, ll_seq)
		End If
		dw_pop.Visible = True
		dw_pop.SetColumn('hachi')
		dw_pop.SetFocus()
End Choose
end event

event rowfocuschanged;Long   row

row = This.GetRow()
If row < 1 Then Return

This.SelectRow(0, False)
This.SetRow(row)
This.SelectRow(row, True)
end event

type rr_2 from roundrectangle within w_adt_10100_han
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 37
integer y = 256
integer width = 1650
integer height = 1992
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_adt_10100_han
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 1710
integer y = 1540
integer width = 2889
integer height = 704
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_mis from datawindow within w_adt_10100_han
event ue_enter pbm_dwnprocessenter
boolean visible = false
integer x = 1490
integer y = 828
integer width = 1728
integer height = 888
integer taborder = 160
boolean titlebar = true
string title = "귀책처 추가"
string dataobject = "d_adt_10100_han_pop_02"
boolean controlmenu = true
boolean border = false
boolean livescroll = true
end type

event ue_enter;Long   row

row = This.GetRow()
If row < 1 Then Return

Choose Case This.GetColumnName()
	Case 'misamt'
		Long   ll_ins
		ll_ins = This.InsertRow(0)
		
		This.SetColumn('misvnd')
		This.SetFocus()
		This.SetRow(ll_ins)
		
		Return 1
End Choose

Send(Handle(This), 256, 9, 0)
Return 1
end event

event constructor;This.SetTransObject(SQLCA)
This.InsertRow(0)
end event

event rbuttondown;If row < 1 Then Return

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case dwo.name
	Case 'misvnd'
		gs_gubun = '1'
		Open(w_vndmst_popup)
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
	
		This.SetItem(row, 'misvnd', gs_code    )
		This.SetItem(row, 'cvnas' , gs_codename)
		
End Choose

end event

event itemchanged;If row < 1 Then Return

Choose Case dwo.name
	Case 'misvnd'
		If Trim(data) = '' OR IsNull(data) Then
			This.SetItem(row, 'cvnas', '')
			Return
		End If
	
		This.SetItem(row, 'cvnas', f_get_name5('11', data, ''))
		
End Choose

end event

type dw_pop from datawindow within w_adt_10100_han
boolean visible = false
integer x = 1221
integer y = 428
integer width = 2327
integer height = 1444
integer taborder = 170
boolean titlebar = true
string title = "내용등록"
string dataobject = "d_adt_10100_han_pop_01"
boolean controlmenu = true
boolean border = false
boolean livescroll = true
end type

event constructor;This.SetTransObject(SQLCA)
end event

event rbuttondown;If row < 1 Then Return

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case dwo.name		
	Case 'itnbr_dsc'
		gs_gubun = '1'
		
		str_code lst_code
		String ls_itn
		Long   i
		Long   ll
		
		ll = 0
		
		Open(w_itemas_multi_popup_yongcha)
		
		lst_code = Message.PowerObjectParm
		
		If IsValid(lst_code) = False Then Return 
		
		If UpperBound(lst_code.code) < 1 Then Return 
		
		This.SetColumn('itnbr_dsc')
		
		For i = row To UpperBound(lst_code.code) + row - 1
			ll++
						
			If Trim(lst_code.code[ll]) = '' OR IsNull(lst_code.code[ll]) Then
			Else
				If ll = 1 Then
					ls_itn = lst_code.code[ll] + ' : ' + String(lst_code.dgubun1[ll]) + lst_code.sgubun4[ll]
				Else
					ls_itn = ls_itn + ', ' + lst_code.code[ll] + ' : ' + String(lst_code.dgubun1[ll]) + lst_code.sgubun4[ll]
				End If
			End If
		Next
		
		String ls_val
		ls_val = This.GetItemString(row, 'itnbr_dsc')
		If Trim(ls_val) = '' OR IsNull(ls_val) Then
			This.SetItem(row, 'itnbr_dsc', ls_itn)
		Else
			This.SetItem(row, 'itnbr_dsc', ls_val + ', ' + ls_itn)
		End If
		
End Choose




end event

event buttonclicked;If row < 1 Then Return

Choose Case dwo.name
	Case 'b_save'
		If f_msg_update() <> 1 Then Return
		
		Long   ll_seq
		String ls_jpno
		
		ls_jpno = dw_insert.GetItemString(1, 'jpno')
		
		If This.GetItemStatus(row, 0, Primary!) = New! OR This.GetItemStatus(row, 0, Primary!) = NewModified! Then
			SELECT MAX(SEQ)
			  INTO :ll_seq
			  FROM YONGCHA_DTL
			 WHERE JPNO = :ls_jpno ;
			If ll_seq < 1 OR IsNull(ll_seq) Then
				ll_seq = 1
			Else
				ll_seq++
			End If
			
			This.SetItem(row, 'seq', ll_seq)
		End If
		
		If This.UPDATE() = 1 Then
			COMMIT USING SQLCA;
		Else
			ROLLBACK USING SQLCA;
			MessageBox('저장실패', '자료 저장 중 오류가 발생 했습니다.')
			Return
		End If
		
		This.Visible = False
		This.ReSet()
		This.InsertRow(0)
		
		dw_dtl.Retrieve(ls_jpno)
		
End Choose
end event

type cb_1 from commandbutton within w_adt_10100_han
integer x = 2866
integer y = 116
integer width = 402
integer height = 112
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "월간 생성"
end type

event clicked;dw_insert.AcceptText()

Long   row

row = dw_insert.GetRow()
If row < 1 Then Return

If f_msg_update() <> 1 Then Return

If dw_insert.GetItemStatus(row, 0, Primary!) = New! OR dw_insert.GetItemStatus(row, 0, Primary!) = NewModified! Then
	String ls_ym
	
	ls_ym = String(TODAY(), 'yymm')
	
	//관리번호 채번
	String ls_max
	Long   ll_max
	
	SELECT MAX(SUBSTR(JPNO, 5, 3))
	  INTO :ls_max
	  FROM YONGCHA
	 WHERE JPNO LIKE :ls_ym||'%' ;
	If Trim(ls_max) = '' OR IsNull(ls_max) Then
		ll_max = 1
	Else
		ll_max = Long(ls_max) + 1
	End If
	
	String ls_jpno
	ls_jpno = ls_ym + String(ll_max, '000')
	
	Long   ll_dup
	SELECT COUNT('X')
	  INTO :ll_dup
	  FROM YONGCHA
	 WHERE JPNO = :ls_jpno ;
	If ll_dup > 0 Then
		MessageBox('관리번호 생성', '관리번호 생성이 정상적으로 이루어지지 않았습니다.~r~n전산실로 문의 하십시오.')
		Return
	End If
	
	dw_insert.SetItem(row, 'jpno', ls_jpno)
	
	//---------------------------------------------------------
End If

//필수 확인
String ls_dpt
ls_dpt = dw_insert.GetItemString(row, 'usedpt')
If Trim(ls_dpt) = '' OR IsNull(ls_dpt) Then
	MessageBox('사용부서 확인', '사용부서는 필수 항목 입니다.')
	dw_insert.SetColumn('usedpt')
	dw_insert.setFocus()
	Return
End If

String ls_day
ls_day = dw_insert.GetItemString(row, 'usedat')
If Trim(ls_day) = '' OR IsNull(ls_day) Then
	MessageBox('사용일시 확인', '사용일은 필수 항목 입니다.')
	dw_insert.SetColumn('usedat')
	dw_insert.SetFocus()
	Return
End If

If RIGHT(ls_day, 2) <> '01' Then
	MessageBox('월간생성 확인', '월간 자료 생성 시 사용일자는 해당 월의 1일 이어야 합니다.')
	dw_insert.SetColumn('usedat')
	dw_insert.SetFocus()
	Return
End If

String ls_tim
ls_tim = dw_insert.GetItemString(row, 'usetim')
If Trim(ls_tim) = '' OR IsNull(ls_tim) Then
	MessageBox('사용시간 확인', '사용시간은 필수 항목 입니다.')
	dw_insert.SetColumn('usetim')
	dw_insert.SetFocus()
	Return
End If

String ls_ip
ls_ip = dw_insert.GetItemString(row, 'ipcust')
If Trim(ls_ip) = '' OR IsNull(ls_ip) Then
	MessageBox('입고처 확인', '입고처는 필수 항목 입니다.')
	dw_insert.SetColumn('ipcust')
	dw_insert.SetFocus()
	Return
End If

//Double ldb_amt
//ldb_amt = dw_insert.GetItemNumber(row, 'useamt')
//If ldb_amt < 1 OR IsNull(ldb_amt) Then
//	MessageBox('사용금액 확인', '사용금액은 필수 항목 입니다.')
//	dw_insert.SetColumn('useamt')
//	dw_insert.SetFocus()
//	Return
//End If

String ls_mak
ls_mak = dw_insert.GetItemString(row, 'makemp')
If Trim(ls_mak) = '' OR IsNull(ls_mak) Then
	MessageBox('작성자 확인', '작성자는 필수 항목 입니다.')
	dw_insert.SetColumn('makemp')
	dw_insert.SetFocus()
	Return
End If

String ls_dat
ls_dat = dw_insert.GetItemString(row, 'makdat')
If Trim(ls_dat) = '' OR IsNull(ls_dat) Then
	MessageBox('작성일 확인', '작성일은 필수 항목 입니다.')
	dw_insert.SetColumn('makdat')
	dw_insert.SetFocus()
	Return
End If

String ls_gub
ls_gub = dw_insert.GetItemString(row, 'gubun')
If Trim(ls_gub) = '' OR IsNull(ls_gub) Then
	MessageBox('구분확인', '정규/비정규 구분은 필수 항목 입니다.')
	dw_insert.SetColumn('gubun')
	dw_insert.SetFocus()
	Return
End If

String ls_tgub
ls_tgub = dw_insert.GetItemString(row, 't_gbn')
If Trim(ls_tgub) = '' OR IsNull(ls_tgub) Then
	MessageBox('자료구분 확인', '용차/택배 구분은 필수 항목 입니다.')
	dw_insert.SetColumn('t_gbn')
	dw_insert.SetFocus()
	Return
End If

If dw_insert.UPDATE() = 1 Then
	wf_month(ls_jpno)
	COMMIT USING SQLCA;	
Else
	ROLLBACK USING SQLCA;
	MessageBox('저장실패', '자료 저장에 실패 했습니다.')
	Return
End If

ib_any_typing = False
end event

