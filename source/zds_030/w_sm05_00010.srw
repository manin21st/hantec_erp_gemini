$PBExportHeader$w_sm05_00010.srw
$PBExportComments$월 판매계획 대비 실적현황
forward
global type w_sm05_00010 from w_standard_print
end type
type rr_1 from roundrectangle within w_sm05_00010
end type
end forward

global type w_sm05_00010 from w_standard_print
string title = "월 판매계획 대비 실적현황"
rr_1 rr_1
end type
global w_sm05_00010 w_sm05_00010

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string  ls_sdate, ls_edate , ls_smchno , ls_emchno  , sArea, sCvcod
String  sSaupj, tx_name


if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

ls_sdate = trim(dw_ip.object.sdate[1])
sArea = trim(dw_ip.object.sArea[1])
If IsNull(sArea) Then sArea = ''

sCvcod = trim(dw_ip.object.cvcod[1])
If IsNull(sCvcod) Then sCvcod = ''

/* 사업장 체크 */
sSaupj= Trim(dw_ip.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_ip.SetFocus()
	dw_ip.SetColumn('saupj')
	Return -1
End If
string sitnbr1,sitnbr2
sitnbr1 = trim(dw_ip.getitemstring(1,'itnbr1'))
      sitnbr2 = trim(dw_ip.getitemstring(1,'itnbr2'))		
		
	if sitnbr1 = '' or isnull(sitnbr1) then sitnbr1 = '...'
	if sitnbr2 = '' or isnull(sitnbr2) then sitnbr2 = 'zzz'	

if dw_print.Retrieve(gs_sabu, ls_sdate, sSaupj, sArea+'%', scvcod+'%',sitnbr1,sitnbr2) <= 0 then
	f_message_chk(50,"[월판매계획 대비 실적 현황]")
	dw_ip.Setfocus()
	return -1
end if

dw_print.Sharedata(dw_list)

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_saupj.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(sarea) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_sarea.text = '"+tx_name+"'")

return 1
end function

on w_sm05_00010.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sm05_00010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_print.ShareDataOff()

/* User별 사업장 Setting Start */
String sarea, steam, saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_ip.Modify("saupj.protect=1")
	dw_ip.Modify("sarea.protect=1")
End If
dw_ip.SetItem(1, 'sarea', sarea)
dw_ip.SetItem(1, 'saupj', saupj)
/* ---------------------- End  */

f_mod_saupj(dw_ip, 'saupj')

dw_ip.object.sdate[1] = left(is_today,6)


end event

type p_preview from w_standard_print`p_preview within w_sm05_00010
end type

event p_preview::clicked;call super::clicked;//If dw_list.RowCount() < 1 Then Return
//
//String ls_mchno
//Long   i
//For i =1 To dw_list.RowCount()
//	If dw_list.isSelected(i) Then
//		ls_mchno = Trim(dw_list.Object.mchno[i])
//	Else
//		Continue
//	End If
//Next
//If ls_mchno = '' Or isNull(ls_mchno) Then
//	MessageBox('확인','조회된 리스트 중에서 해당 설비를 선택하세요.')
//	Return
//End If
//
//If dw_print.Retrieve(gs_sabu , ls_mchno) > 0 Then
////   dw_print.Object.t_empno.text = gs_username
//	OpenWithParm(w_print_preview, dw_print)
//End If
end event

type p_exit from w_standard_print`p_exit within w_sm05_00010
end type

type p_print from w_standard_print`p_print within w_sm05_00010
end type

type p_retrieve from w_standard_print`p_retrieve within w_sm05_00010
end type







type st_10 from w_standard_print`st_10 within w_sm05_00010
end type



type dw_print from w_standard_print`dw_print within w_sm05_00010
string dataobject = "d_sm05_00010_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sm05_00010
integer x = 46
integer y = 32
integer width = 3159
integer height = 208
string dataobject = "d_sm05_00010_ip"
end type

event dw_ip::itemchanged;String  s_cod, snull, s_cvcod, get_nm, s_nam1

setnull(snull)

s_cod = Trim(this.GetText())

if this.GetColumnName() = "sdate" then 
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod + '01' ) = -1 then
		f_message_chk(35,"[기준년월]")
		this.object.sdate[1] = snull
		return 1
	end if	
end if

if this.GetColumnName() = 'cvcod' then
	s_cvcod = this.GetText()								
	 
	if s_cvcod = "" or isnull(s_cvcod) then 
		this.setitem(1, 'cvnas', snull)
		return 
	end if
	
	SELECT "VNDMST"."CVNAS"  
	  INTO :get_nm  
	  FROM "VNDMST"  
	 WHERE "VNDMST"."CVCOD" = :s_cvcod  ;

	if sqlca.sqlcode = 0 then 
		this.setitem(1, 'cvnas', get_nm)
	else
		this.triggerevent(RbuttonDown!)
		return 1
	end if
End If




Choose Case GetColumnName()
case "itnbr1" 
	if IsNull(s_cod) or s_cod = "" then return 1
	
	Select itdsc Into :s_nam1 
	  From ITEMAS
	 Where sabu = :gs_sabu 
	   And itnbr = :s_cod ;
	
	If SQLCA.SQLCODE <> 0 then
		This.Object.itnbr1[1]  = ''
		This.Object.itdsc1[1]  = ''
		f_message_chk(33, "[품번 - From]")
		Return 1
	Else
		This.Object.itdsc1[1] = s_nam1
	End If
   case  "itnbr2"  
	if IsNull(s_cod) or s_cod = "" then return 1
	
	Select itdsc Into :s_nam1 
	  From ITEMAS
	 Where sabu = :gs_sabu 
	   And itnbr = :s_cod ;
	
	If SQLCA.SQLCODE <> 0 then
		This.Object.itnbr2[1]  = ''
		This.Object.itdsc2[1]  = ''
		f_message_chk(33, "[품번 - To]")
		Return 1
	Else
		This.Object.itdsc2[1]  = s_nam1
	End If
	End Choose
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::rbuttondown;long lrow

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

lrow = this.GetRow()
Choose Case GetcolumnName() 
	Case 'cvcod'
		gs_code = GetText()
		Open(w_vndmst_popup)
		If IsNull(gs_code) Or gs_code = '' Then Return
		
		SetItem(lrow, "cvcod", gs_Code)
		SetItem(lrow, "cvnas", gs_Codename)
		
		case "itnbr1" 

	open(w_itemas_popup)
	this.SetItem(1, "itnbr1", gs_code)
	this.SetItem(1, "itdsc1", gs_codename)
	if not (IsNull(gs_code) or gs_codename = "") then
		TriggerEvent("itemchanged")
	end if	
	return
  
case "itnbr2" 

	open(w_itemas_popup)
	this.SetItem(1, "itnbr2", gs_code)
	this.SetItem(1, "itdsc2", gs_codename)
	if not (IsNull(gs_code) or gs_codename = "") then
		TriggerEvent("itemchanged")
	end if	
	return
End Choose
end event

type dw_list from w_standard_print`dw_list within w_sm05_00010
integer x = 64
integer y = 280
integer width = 4549
integer height = 1960
string dataobject = "d_sm05_00010"
boolean border = false
end type

event dw_list::clicked;call super::clicked;If Row <= 0 then
	SelectRow(0,False)
ELSE
	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
END IF
end event

type rr_1 from roundrectangle within w_sm05_00010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 268
integer width = 4576
integer height = 2000
integer cornerheight = 40
integer cornerwidth = 55
end type

