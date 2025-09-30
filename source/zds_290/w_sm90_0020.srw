$PBExportHeader$w_sm90_0020.srw
$PBExportComments$월 판매계획 대 실적 현황
forward
global type w_sm90_0020 from w_standard_print
end type
type st_1 from statictext within w_sm90_0020
end type
type rr_1 from roundrectangle within w_sm90_0020
end type
end forward

global type w_sm90_0020 from w_standard_print
integer width = 4677
integer height = 2516
string title = "월 판매계획 대비 실적"
st_1 st_1
rr_1 rr_1
end type
global w_sm90_0020 w_sm90_0020

type variables
String 	  is_sort
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String ls_saupj , ls_yymm , ls_from , ls_to ,ls_itnbr_from, ls_itnbr_to, ls_carcode, ls_car

If dw_ip.AcceptText() <> 1 Then Return 1

/* 사업장 체크 */
ls_saupj= Trim(dw_ip.GetItemString(1, 'saupj'))
If IsNull(ls_saupj) Or ls_saupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_ip.SetFocus()
	dw_ip.SetColumn('saupj')
	Return -1
End If

ls_yymm = trim(dw_ip.getitemstring(1, 'yymm'))
If IsNull(ls_yymm) Or ls_yymm = '' Then
	f_message_chk(1400,'[기준년월]')
	Return -1
End If

ls_itnbr_from = trim(dw_ip.getitemstring(1, 'tx_itnbr_f'))
ls_itnbr_to   = trim(dw_ip.getitemstring(1, 'tx_itnbr_t'))

IF isNull(ls_itnbr_from) THEN ls_itnbr_from = ''
IF isNull(ls_itnbr_to) THEN ls_itnbr_to = ''

// 품번 전체를 검색 할 때에 ITEMAS의 최소, 최고 품번을 조회한다.	
IF ls_itnbr_from = '' and ls_itnbr_to = '' THEN	
	SELECT MIN(ITNBR), MAX(ITNBR) 
	INTO   :ls_from, :ls_to
	FROM   ITEMAS;
	
	If sqlca.sqlcode <> 0 Then
		MessageBox('에러','품번마스터를 조회할 수 없습니다.~n전산실에 문의 바랍니다.')
		Return -1
	End If
ELSE
	ls_from = ls_itnbr_from
	ls_to = ls_itnbr_to
END IF



If dw_list.Retrieve(ls_saupj, ls_yymm, ls_from, ls_to ) <= 0 Then
	f_message_chk(50,'')
	return -1
End If	
		
//Report   검색조건 값 Display
dw_print.Modify("tx_yymm.text = '"+String(ls_yymm,'@@@@.@@')+"'")

ls_saupj = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj)', 1)"))
If IsNull(ls_saupj) Or ls_saupj = '' Then ls_saupj = '전체'
dw_print.Modify("tx_saupj.text = '"+ls_saupj+"'")

return 1
end function

on w_sm90_0020.create
int iCurrent
call super::create
this.st_1=create st_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_sm90_0020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.rr_1)
end on

event open;call super::open;/* User별 사업장 Setting Start */
setnull(gs_code)
If f_check_saupj() = 1 Then
	dw_ip.SetItem(1, 'saupj', gs_code)
   if gs_code <> '%' then
   	dw_ip.Modify("saupj.protect=1")
		dw_ip.Modify("saupj.background.color = 80859087")
   End if
End If
/* ---------------------- End  */

dw_ip.Object.yymm[1] = Left(is_today,6)

end event

type p_preview from w_standard_print`p_preview within w_sm90_0020
integer x = 4091
integer taborder = 30
end type

type p_exit from w_standard_print`p_exit within w_sm90_0020
integer x = 4439
integer taborder = 50
end type

type p_print from w_standard_print`p_print within w_sm90_0020
integer x = 4265
integer taborder = 40
end type

type p_retrieve from w_standard_print`p_retrieve within w_sm90_0020
integer x = 3918
end type







type st_10 from w_standard_print`st_10 within w_sm90_0020
end type



type dw_print from w_standard_print`dw_print within w_sm90_0020
string dataobject = "d_sm90_0020_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sm90_0020
integer x = 27
integer width = 2651
string dataobject = "d_sm90_0020_1"
end type

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::itemchanged;call super::itemchanged;String ls_col , ls_value, ls_itnbr_t, ls_itnbr_f

ls_col = GetColumnName()
ls_value = Trim(GetText())

CHOOSE Case ls_col
	Case "tx_itnbr_f"
		ls_itnbr_t = Trim(This.GetItemString(row, 'tx_itnbr_t'))
		if IsNull(ls_itnbr_t) or ls_itnbr_t = '' then
			This.SetItem(row, 'tx_itnbr_t', ls_value)
	   end if
	Case "tx_itnbr_t"
		ls_itnbr_f = Trim(This.GetItemString(row, 'tx_itnbr_f'))
		if IsNull(ls_itnbr_f) or ls_itnbr_f = '' then
			This.SetItem(row, 'tx_itnbr_f', ls_value)
	   end if
END CHOOSE

end event

type dw_list from w_standard_print`dw_list within w_sm90_0020
integer x = 46
integer y = 296
integer width = 4544
integer height = 2032
integer taborder = 60
string dataobject = "d_sm90_0020"
boolean border = false
end type

event dw_list::clicked;call super::clicked;String ls_sort

If Right(dwo.Name, 2) = '_t' Then
	ls_sort = left(dwo.Name, Pos(dwo.Name, '_t') - 1) + ' A'
	If ls_sort <> is_sort Then
		is_sort = ls_sort
		SetSort(is_sort)
		Sort()
	End If
End If

IF row <= 0  THEN RETURN

IF IsSelected(row) THEN
	Selectrow(0,False)
ELSE
	Selectrow(0,False)
	Selectrow(row,True)
END IF
end event

type st_1 from statictext within w_sm90_0020
integer x = 2702
integer y = 200
integer width = 1399
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "* 공장구분 전체(Y 공장 제외) , Y 공장 만 집계"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_sm90_0020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 288
integer width = 4585
integer height = 2056
integer cornerheight = 40
integer cornerwidth = 55
end type

