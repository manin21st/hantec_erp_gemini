$PBExportHeader$w_sm01_00040.srw
$PBExportComments$월 판매계획 현황
forward
global type w_sm01_00040 from w_standard_print
end type
type rr_2 from roundrectangle within w_sm01_00040
end type
type rr_1 from roundrectangle within w_sm01_00040
end type
end forward

global type w_sm01_00040 from w_standard_print
string title = "월 판매계획 현황"
rr_2 rr_2
rr_1 rr_1
end type
global w_sm01_00040 w_sm01_00040

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sYear, sPlnt, stemp, sDate, eDate, sFilter, sItcls, sType, sItem, sCod, sGbn
String scvcod, tx_name
Long   nCnt, ix, nrow, nChasu
String sSaupj, ssarea

If dw_ip.AcceptText() <> 1 Then Return -1

sItem  = trim(dw_ip.getitemstring(1, 'item'))
sYear  = trim(dw_ip.getitemstring(1, 'yymm'))
sSaupj = Trim(dw_ip.GetItemString(1, 'saupj'))
sPlnt  = trim(dw_ip.getitemstring(1, 'plnt'))
sItcls = trim(dw_ip.getitemstring(1, 'itcls'))
sType  = trim(dw_ip.getitemstring(1, 'cartype'))
sGbn   = trim(dw_ip.getitemstring(1, 'gbn'))

If IsNull(sYear) Or sYear = '' Then
	f_message_chk(1400,'[계획년월]')
	Return -1
End If

/* 사업장 체크 */
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_ip.SetFocus()
	dw_ip.SetColumn('saupj')
	Return -1
End If

if sPlnt = '.' or isNull(sPlnt) or sPlnt = "" then sPlnt = "%"
if isNull(sItcls) or sItcls = "" then sItcls = "%"
if sType = '.' or isNull(sType) or sType = "" then sType = "%"

If sItem = 'Z' Then
	dw_print.DataObject = 'd_sm01_00040_6_p'
	dw_list.DataObject  = 'd_sm01_00040_6'
Elseif sItem = 'Y' Then
		dw_print.DataObject = 'd_sm01_00040_5_p'
		dw_list.DataObject = 'd_sm01_00040_5'
Elseif sItem = 'N' Then
		dw_print.DataObject = 'd_sm01_00040_7_p'
		dw_list.DataObject = 'd_sm01_00040_7'
Else
	dw_print.DataObject = 'd_sm01_00040_8_p'
	dw_list.DataObject = 'd_sm01_00040_8_p'
End If

dw_print.SetTransObject(sqlca)
dw_print.ShareData(dw_list)

If dw_print.Retrieve(sSaupj, sYear, sPlnt , sItcls , sType, sGbn ) <= 0 Then
	f_message_chk(50,'')
End If

String tx_name1, tx_name2, tx_name3

tx_name1 = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(plnt) ', 1)"))
tx_name2 = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(itcls) ', 1)"))
tx_name3 = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(cartype) ', 1)"))

If IsNull(tx_name1) Or tx_name1 = '' Then tx_name1 = '전체'
If IsNull(tx_name2) Or tx_name2 = '' Then tx_name2 = '전체'
If IsNull(tx_name3) Or tx_name3 = '' Then tx_name3 = '전체'

dw_print.Object.t_sdate.text = String(sYear,'@@@@.@@')
dw_print.Modify("t_plnt.text = '"+tx_name1+"'")
dw_print.Modify("t_itcls.text = '"+tx_name2+"'")
dw_print.Modify("t_cartype.text = '"+tx_name3+"'")

return 1
end function

on w_sm01_00040.create
int iCurrent
call super::create
this.rr_2=create rr_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
this.Control[iCurrent+2]=this.rr_1
end on

on w_sm01_00040.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
destroy(this.rr_1)
end on

event open;call super::open;f_mod_saupj(dw_ip, 'saupj')
end event

type p_preview from w_standard_print`p_preview within w_sm01_00040
end type

type p_exit from w_standard_print`p_exit within w_sm01_00040
end type

type p_print from w_standard_print`p_print within w_sm01_00040
end type

type p_retrieve from w_standard_print`p_retrieve within w_sm01_00040
end type







type st_10 from w_standard_print`st_10 within w_sm01_00040
end type



type dw_print from w_standard_print`dw_print within w_sm01_00040
string dataobject = "d_sm01_00040_8_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sm01_00040
integer y = 48
integer width = 3799
integer height = 256
string dataobject = "d_sm01_00040_9"
end type

event dw_ip::itemchanged;String s_cvcod, snull, get_nm, sItem, sCust, sDate, sSaupj
Int    nChasu

SetNull(sNull)

/* 사업장 체크 */
sSaupj= Trim(GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	Return 2
End If

Choose Case GetColumnName()
	/* 계획년월 */
	Case 'yymm'
		sDate = Left(GetText(),6)
				
		If f_datechk(sDate+'01') <> 1 Then
			f_message_chk(35,'')
			return 1
		End If
	Case 'cartype'
		sCust = GetText()
				
			SELECT carnm INTO :get_nm FROM carhead
			 WHERE carcode = :sCust;
			If IsNull(get_nm) or get_nm = "" then 
				f_message_chk(35,'차종')
			End if
	Case 'item'
		sItem = GetText()
End Choose
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::rbuttondown;call super::rbuttondown;long lrow

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

lrow = this.GetRow()
Choose Case GetcolumnName() 
	Case 'cartype'
		gs_code = GetText()
		gs_codename  = 'E'
		gs_codename2 = 'E'
		Open(w_carhead_popup)
		If isNull(gs_code) Then Return
		
		SetItem(1, 'cartype', gs_code)
//		SetItem(1, 'cargbn1', gs_codename)
//		SetItem(1, 'cargbn2', gs_codename2)
		TriggerEvent(ItemChanged!)
End Choose
end event

type dw_list from w_standard_print`dw_list within w_sm01_00040
integer x = 32
integer y = 336
integer height = 1876
string dataobject = "d_sm01_00040_5"
boolean border = false
end type

event dw_list::clicked;call super::clicked;If Row <= 0 then
	SelectRow(0,False)
ELSE
	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
END IF
end event

type rr_2 from roundrectangle within w_sm01_00040
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 27
integer y = 44
integer width = 3840
integer height = 272
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_sm01_00040
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 324
integer width = 4613
integer height = 1944
integer cornerheight = 40
integer cornerwidth = 55
end type

