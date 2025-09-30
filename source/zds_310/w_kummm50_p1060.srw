$PBExportHeader$w_kummm50_p1060.srw
$PBExportComments$월 자재소요량
forward
global type w_kummm50_p1060 from w_standard_print
end type
type rr_1 from roundrectangle within w_kummm50_p1060
end type
end forward

global type w_kummm50_p1060 from w_standard_print
integer height = 2872
string title = "월 자재 소요량"
rr_1 rr_1
end type
global w_kummm50_p1060 w_kummm50_p1060

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
	MessageBox('기준년월 확인', '기준년월은 필수 항목입니다.')
	dw_ip.SetColumn('yymm')
	dw_ip.SetFocus()
	Return -1
End If

ls_typ = dw_ip.GetItemString(row, 'ittyp')
If Trim(ls_typ) = '' OR IsNull(ls_typ) Then ls_typ = '%'

ls_sec = dw_ip.GetItemString(row, 'section')
If Trim(ls_sec) = '' OR IsNull(ls_sec) Then ls_sec = '%'

wf_rewind(ls_ym)

dw_list.SetRedraw(False)
dw_list.Retrieve('%','%')
dw_list.SetRedraw(True)

If dw_list.RowCount() < 1 Then Return -1

dw_list.ShareData(dw_print)

w_mdi_frame.sle_msg.text = '자료 생성 성공...'

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

String ls_ittyp
ls_ittyp = dw_ip.GetItemString(1, 'ittyp')
If Trim(ls_ittyp) = '' OR IsNull(ls_ittyp) Then
	MessageBox('품목구분 확인', '품목구분은 필수 항목 입니다.')
	Return
End If

/* 원자재중 절단코일(01XXXXX), 시트(02XXXXX) */
DECLARE bom_find CURSOR FOR
	SELECT ITNBR, ITDSC
	  FROM ITEMAS
	 WHERE ITTYP = :ls_ittyp
	   AND DECODE(ITTYP, '3', SUBSTR(ITCLS, 1, 2), '01') IN ('01', '02') ;
	

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

on w_kummm50_p1060.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kummm50_p1060.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;dw_ip.SetItem(1, 'yymm', String(TODAY(), 'yyyymm'))
end event

type p_xls from w_standard_print`p_xls within w_kummm50_p1060
boolean visible = true
integer x = 4270
integer y = 24
end type

type p_sort from w_standard_print`p_sort within w_kummm50_p1060
end type

type p_preview from w_standard_print`p_preview within w_kummm50_p1060
boolean visible = false
integer x = 2533
integer y = 12
end type

type p_exit from w_standard_print`p_exit within w_kummm50_p1060
end type

type p_print from w_standard_print`p_print within w_kummm50_p1060
boolean visible = false
integer x = 2802
integer y = 0
end type

type p_retrieve from w_standard_print`p_retrieve within w_kummm50_p1060
integer x = 4096
end type







type st_10 from w_standard_print`st_10 within w_kummm50_p1060
end type



type dw_print from w_standard_print`dw_print within w_kummm50_p1060
string dataobject = "d_kummm50_p1060_002_new"
end type

type dw_ip from w_standard_print`dw_ip within w_kummm50_p1060
integer x = 23
integer width = 1495
integer height = 168
string dataobject = "d_kummm50_p1060_001"
end type

type dw_list from w_standard_print`dw_list within w_kummm50_p1060
integer y = 200
integer width = 4581
integer height = 2084
string dataobject = "d_kummm50_p1060_002_new"
boolean border = false
end type

type rr_1 from roundrectangle within w_kummm50_p1060
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

