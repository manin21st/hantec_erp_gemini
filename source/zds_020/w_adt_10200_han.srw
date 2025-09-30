$PBExportHeader$w_adt_10200_han.srw
$PBExportComments$용차사용 현황
forward
global type w_adt_10200_han from w_standard_print
end type
type rr_1 from roundrectangle within w_adt_10200_han
end type
end forward

global type w_adt_10200_han from w_standard_print
string title = "용차사용 현황"
rr_1 rr_1
end type
global w_adt_10200_han w_adt_10200_han

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
		MessageBox('일자형식', '일자형식이 잘못 되었습니다.')
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
		MessageBox('일자형식', '일자형식이 잘못 되었습니다.')
		dw_ip.SetColumn('d_ed')
		dw_ip.SetFocus()
		Return -1
	End If
End If

If ls_st > ls_ed Then
	MessageBox('기간오류', '시작일 보다 종료일이 빠릅니다.')
	Return -1
End If

dw_list.SetRedraw(False)
dw_list.Retrieve(ls_st, ls_ed)
dw_list.SetRedraw(True)

If dw_list.RowCount() < 1 Then Return -1

dw_list.ShareData(dw_print)

Return 1
end function

on w_adt_10200_han.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_adt_10200_han.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;dw_ip.SetItem(1, 'd_st', String(TODAY(), 'yyyymm' + '01'))
dw_ip.SetItem(1, 'd_ed', String(TODAY(), 'yyyymmdd'))
end event

type p_xls from w_standard_print`p_xls within w_adt_10200_han
boolean visible = true
integer x = 4256
integer y = 24
boolean enabled = false
string picturename = "C:\erpman\image\엑셀변환_d.gif"
end type

event p_xls::clicked;//
If this.Enabled Then wf_excel_down(dw_list)
end event

type p_sort from w_standard_print`p_sort within w_adt_10200_han
integer x = 3520
integer y = 28
end type

type p_preview from w_standard_print`p_preview within w_adt_10200_han
integer x = 4082
end type

type p_exit from w_standard_print`p_exit within w_adt_10200_han
integer x = 4430
end type

type p_print from w_standard_print`p_print within w_adt_10200_han
boolean visible = false
integer x = 3342
integer y = 32
end type

type p_retrieve from w_standard_print`p_retrieve within w_adt_10200_han
integer x = 3909
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







type st_10 from w_standard_print`st_10 within w_adt_10200_han
end type



type dw_print from w_standard_print`dw_print within w_adt_10200_han
integer x = 3717
string dataobject = "d_adt_10200_han_03"
end type

type dw_ip from w_standard_print`dw_ip within w_adt_10200_han
integer x = 37
integer width = 1065
integer height = 184
string dataobject = "d_adt_10200_han_01"
end type

type dw_list from w_standard_print`dw_list within w_adt_10200_han
integer x = 50
integer y = 220
integer width = 4544
integer height = 2016
string dataobject = "d_adt_10200_han_02"
boolean border = false
end type

type rr_1 from roundrectangle within w_adt_10200_han
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 37
integer y = 208
integer width = 4571
integer height = 2044
integer cornerheight = 40
integer cornerwidth = 55
end type

