$PBExportHeader$w_kummm50_p10602.srw
$PBExportComments$주간구매계획 (코일)
forward
global type w_kummm50_p10602 from w_standard_print
end type
type pb_1 from u_pb_cal within w_kummm50_p10602
end type
type rr_1 from roundrectangle within w_kummm50_p10602
end type
end forward

global type w_kummm50_p10602 from w_standard_print
integer height = 2872
string title = "주간구매계획 (코일)"
pb_1 pb_1
rr_1 rr_1
end type
global w_kummm50_p10602 w_kummm50_p10602

forward prototypes
public function integer wf_retrieve ()
public subroutine wf_rewind (string as_ym)
end prototypes

public function integer wf_retrieve ();dw_ip.AcceptText()

Long   row

row = dw_ip.GetRow()
If row < 1 Then Return -1

String ls_saupj
String ls_ym
String ls_typ
String ls_sec

ls_saupj = dw_ip.GetItemString(row, 'saupj')
If Trim(ls_saupj) = '' OR IsNull(ls_saupj) Then ls_saupj = '%'

ls_ym = dw_ip.GetItemString(row, 'yymm')
If Trim(ls_ym) = '' OR IsNull(ls_ym) Then
	MessageBox('확인', '계획일자는 필수 항목입니다.')
	dw_ip.SetColumn('yymm')
	dw_ip.SetFocus()
	Return -1
End If

ls_typ = dw_ip.GetItemString(row, 'ittyp')
If Trim(ls_typ) = '' OR IsNull(ls_typ) Then ls_typ = '%'

ls_sec = dw_ip.GetItemString(row, 'section')
If Trim(ls_sec) = '' OR IsNull(ls_sec) Then ls_sec = '%'

//wf_rewind(ls_ym)

dw_list.SetRedraw(False)
dw_list.Retrieve(ls_saupj,ls_ym)
dw_list.SetRedraw(True)

If dw_list.RowCount() < 1 Then Return -1

dw_list.ShareData(dw_print)

//w_mdi_frame.sle_msg.text = '자료 생성 성공...'

Return 1
end function

public subroutine wf_rewind (string as_ym);Long   ll_cnt, i
String ls_rtn, ls_itn, ls_dsc


//기존자료 삭제
DELETE FROM BOM_PCINBR ;
If SQLCA.SQLCODE <> 0 Then
	ROLLBACK USING SQLCA;
	MessageBox('자료생성 오류', '자료 생성 중 오류가 발생했습니다.')
	Return 
Else
	COMMIT USING SQLCA;
End If


/* 원자재중 절단코일(01XXXXX), 시트(02XXXXX) */
DECLARE bom_find CURSOR FOR
	SELECT ITNBR, ITDSC
	  FROM ITEMAS
	 WHERE ITTYP = '3' AND SUBSTR(ITCLS,1,2) IN ('01','02') ;
	

OPEN bom_find;

Do While True
	FETCH bom_find INTO :ls_itn, :ls_dsc;
	if sqlca.sqlcode <> 0 then Exit
	
	ls_rtn = SQLCA.BOM_REWIND2(as_ym, ls_itn)
	If Long(ls_rtn) < 1 Then 
		MessageBox('자료생성 오류', '자료 생성 중 오류가 발생했습니다.')
		Return
	End If
	
	w_mdi_frame.sle_msg.text = '자료 생성 중...' + ls_itn + ' / ' + ls_dsc
	
Loop

Close bom_find;

end subroutine

on w_kummm50_p10602.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_kummm50_p10602.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;string	smaxdate

select max(yymmdd) into :smaxdate from pu03_weekplan
 where waigb = '1' ;
if isnull(smaxdate) or smaxdate = '' then
	smaxdate = f_nearday(f_today(),2)  /* 가장 가까운 월요일 */
	dw_ip.Object.yymm[1] = smaxdate
else
	dw_ip.Object.yymm[1] = smaxdate
end if

end event

type p_xls from w_standard_print`p_xls within w_kummm50_p10602
boolean visible = true
integer x = 4270
integer y = 24
end type

type p_sort from w_standard_print`p_sort within w_kummm50_p10602
end type

type p_preview from w_standard_print`p_preview within w_kummm50_p10602
boolean visible = false
integer x = 2533
integer y = 12
end type

type p_exit from w_standard_print`p_exit within w_kummm50_p10602
end type

type p_print from w_standard_print`p_print within w_kummm50_p10602
boolean visible = false
integer x = 2802
integer y = 0
end type

type p_retrieve from w_standard_print`p_retrieve within w_kummm50_p10602
integer x = 4096
end type







type st_10 from w_standard_print`st_10 within w_kummm50_p10602
end type



type dw_print from w_standard_print`dw_print within w_kummm50_p10602
string dataobject = "d_kummm50_p10602_002"
end type

type dw_ip from w_standard_print`dw_ip within w_kummm50_p10602
integer x = 23
integer width = 1778
integer height = 168
string dataobject = "d_kummm50_p10602_001"
end type

event dw_ip::itemchanged;call super::itemchanged;string	scolnm , sdate, scnfirm,s_empno, s_name, get_nm
Int      ireturn

scolnm = Lower(GetColumnName())

Choose Case scolnm
	Case 'yymm'
		sdate = this.gettext()
		If DayNumber(Date( Left(sdate,4)+'-'+Mid(sdate,5,2) +'-'+Right(sdate,2) )) <> 2 Then
			MessageBox('확 인','주간 구매계획은 월요일부터 가능합니다.!!')
			Return 1
		End If
End Choose
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_kummm50_p10602
integer y = 200
integer width = 4581
integer height = 2084
string dataobject = "d_kummm50_p10602_002"
boolean border = false
end type

type pb_1 from u_pb_cal within w_kummm50_p10602
integer x = 736
integer y = 52
integer taborder = 31
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('yymm')
IF IsNull(gs_code) THEN Return 

If DayNumber(Date( Left(gs_code,4)+'-'+Mid(gs_code,5,2) +'-'+Right(gs_code,2) )) <> 2 Then
	MessageBox('확 인','주간 구매계획은 월요일부터 가능합니다.!!')
	Return 1
End If

dw_ip.SetItem(1, 'yymm', gs_code)
end event

type rr_1 from roundrectangle within w_kummm50_p10602
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 23
integer y = 192
integer width = 4608
integer height = 2100
integer cornerheight = 40
integer cornerwidth = 55
end type

