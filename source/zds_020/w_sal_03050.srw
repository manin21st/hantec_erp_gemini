$PBExportHeader$w_sal_03050.srw
$PBExportComments$년 운송비 계획
forward
global type w_sal_03050 from w_standard_print
end type
type rr_2 from roundrectangle within w_sal_03050
end type
type rr_1 from roundrectangle within w_sal_03050
end type
end forward

global type w_sal_03050 from w_standard_print
string title = "운송비 년 계획 대 실적"
rr_2 rr_2
rr_1 rr_1
end type
global w_sal_03050 w_sal_03050

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sYear, sPlnt, stemp, sDate, eDate, sFilter, sItcls, sType, sItem, sCod, sGb
String scvcod, tx_name
Long   nCnt, ix, nrow, nChasu
String sSaupj, ssarea

If dw_ip.AcceptText() <> 1 Then Return -1

sYear  = trim(dw_ip.getitemstring(1, 'yymm'))
nChasu = dw_ip.GetItemNumber(1, 'chasu')
sSaupj = Trim(dw_ip.GetItemString(1, 'saupj'))
sPlnt  = trim(dw_ip.getitemstring(1, 'plnt'))
sGb    = trim(dw_ip.getitemstring(1, 'gb'))

If IsNull(sYear) Or sYear = '' Then
	f_message_chk(1400,'[계획년도]')
	Return -1
End If

if sGb = '1' then
	If IsNull(nChasu) Or nChasu <= 0 Then
		f_message_chk(1400,'[계획차수]')
		Return -1
	End If
End if

/* 사업장 체크 */
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_ip.SetFocus()
	dw_ip.SetColumn('saupj')
	Return -1
End If

if sPlnt = '.' or isNull(sPlnt) or sPlnt = "" then sPlnt = "%"
If sGb = '1' Then
	dw_print.DataObject = 'd_sal_03050_p'
	dw_list.DataObject  = 'd_sal_03050_1'
Else
	dw_print.DataObject = 'd_sal_03050_p2'
	dw_list.DataObject = 'd_sal_03050_2'
End If

dw_print.SetTransObject(sqlca)
dw_print.ShareData(dw_list)

if sGb = '1' then
	If dw_print.Retrieve(gs_sabu, sYear, nChasu ) <= 0 Then
		f_message_chk(50,'')
	End If
Else
		If dw_print.Retrieve(gs_sabu, sYear) <= 0 Then
		f_message_chk(50,'')
	End If
End if
String  tx_name1, tx_name2, tx_name3

tx_name1 = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(plnt) ', 1)"))

If IsNull(tx_name1) Or tx_name1 = '' Then tx_name1 = '전체'

dw_print.Modify("t_plnt.text = '"+tx_name1+"'")

return 1
end function

on w_sal_03050.create
int iCurrent
call super::create
this.rr_2=create rr_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
this.Control[iCurrent+2]=this.rr_1
end on

on w_sal_03050.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
destroy(this.rr_1)
end on

event open;call super::open;f_mod_saupj(dw_ip, 'saupj')
end event

type p_preview from w_standard_print`p_preview within w_sal_03050
end type

type p_exit from w_standard_print`p_exit within w_sal_03050
end type

type p_print from w_standard_print`p_print within w_sal_03050
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_03050
end type







type st_10 from w_standard_print`st_10 within w_sal_03050
end type



type dw_print from w_standard_print`dw_print within w_sal_03050
string dataobject = "d_sal_03050_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_03050
integer y = 48
integer width = 3799
integer height = 256
string dataobject = "d_sal_03050"
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
	/* 계획년도 */
	Case 'yymm'
		sDate = Left(GetText(),6)
				
		If f_datechk(sDate+'0101') <> 1 Then
			f_message_chk(35,'')
			return 1
		Else
			dw_list.Reset()
			
			// 해당년도의 최종차수 계산
			SELECT MAX(CHASU) INTO :nChasu FROM SM01_YEARPLAN 
			 WHERE SABU = :gs_sabu 
			   AND SAUPJ = :sSaupj 
				AND YYYY = :sDate;
			If IsNull(nChasu) Then nChasu = 1
			SetItem(1, 'chasu', nChasu)
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

type dw_list from w_standard_print`dw_list within w_sal_03050
integer x = 32
integer y = 332
integer height = 1876
string dataobject = "d_sal_03050_1"
boolean border = false
end type

event dw_list::clicked;call super::clicked;If Row <= 0 then
	SelectRow(0,False)
ELSE
	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
END IF
end event

type rr_2 from roundrectangle within w_sal_03050
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

type rr_1 from roundrectangle within w_sal_03050
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

