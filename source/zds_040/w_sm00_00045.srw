$PBExportHeader$w_sm00_00045.srw
$PBExportComments$년 판매계획 현황(품목)
forward
global type w_sm00_00045 from w_standard_print
end type
type rr_2 from roundrectangle within w_sm00_00045
end type
type rr_1 from roundrectangle within w_sm00_00045
end type
end forward

global type w_sm00_00045 from w_standard_print
string title = "년 판매계획 현황(품목)"
rr_2 rr_2
rr_1 rr_1
end type
global w_sm00_00045 w_sm00_00045

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sYear, scust, stemp, sDate, eDate, sFilter, sCargbn1, sCargbn2, sItem, sCod
String scvcod, tx_name
Long   nCnt, ix, nrow, nChasu
String sSaupj


If dw_ip.AcceptText() <> 1 Then Return -1
If dw_print.AcceptText() <> 1 Then Return -1

sYear = trim(dw_ip.getitemstring(1, 'yymm'))
scust = trim(dw_ip.getitemstring(1, 'cust'))
scvcod = trim(dw_ip.getitemstring(1, 'cvcod'))
sItem = trim(dw_ip.getitemstring(1, 'item'))
sCod = trim(dw_ip.getitemstring(1, 'scod'))

nChasu = dw_ip.GetItemNumber(1, 'chasu')
If IsNull(nChasu) Or nChasu <= 0 Then
	f_message_chk(1400,'[계획차수]')
	Return -1
End If

If IsNull(sYear) Or sYear = '' Then
	f_message_chk(1400,'[계획년도]')
	Return -1
End If

/* 사업장 체크 */
sSaupj= Trim(dw_ip.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_ip.SetFocus()
	dw_ip.SetColumn('saupj')
	Return -1
End If


sCvcod = ''

If dw_print.Retrieve(gs_sabu, sYear, scust+'%', scvcod+'%', sCod +'%',  sSaupj, nChasu) <= 0 Then
	f_message_chk(50,'')
End If

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(cust) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_cust.text = '"+tx_name+"'")

dw_print.ShareData(dw_list)

return 1
end function

on w_sm00_00045.create
int iCurrent
call super::create
this.rr_2=create rr_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
this.Control[iCurrent+2]=this.rr_1
end on

on w_sm00_00045.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
destroy(this.rr_1)
end on

event open;call super::open;f_mod_saupj(dw_ip, 'saupj')
end event

type p_preview from w_standard_print`p_preview within w_sm00_00045
end type

type p_exit from w_standard_print`p_exit within w_sm00_00045
end type

type p_print from w_standard_print`p_print within w_sm00_00045
end type

type p_retrieve from w_standard_print`p_retrieve within w_sm00_00045
end type







type st_10 from w_standard_print`st_10 within w_sm00_00045
end type



type dw_print from w_standard_print`dw_print within w_sm00_00045
string dataobject = "d_sm00_00045_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sm00_00045
integer x = 73
integer y = 60
integer width = 2939
integer height = 108
string dataobject = "d_sm00_00045_1"
end type

event dw_ip::itemchanged;call super::itemchanged;String s_cvcod, snull, get_nm, sItem, sCust, sDate, sSaupj
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
	Case 'cvcod'
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
	Case 'cust'
		// 차종
		If GetText() = '1' Then
			SetItem(1, 'cargbn1', 'E')
			SetItem(1, 'cargbn2', 'E')
		// 기종
		ElseIf GetText() = '2' Then
			SetItem(1, 'cargbn1', '0')
			SetItem(1, 'cargbn2', '9')
		// 기종
		ElseIf GetText() = '3' Then
			SetItem(1, 'cargbn1', '1')
			SetItem(1, 'cargbn2', '9')
		// 기아
		ElseIf GetText() = '7' Then
			SetItem(1, 'cargbn1', 'E')
			SetItem(1, 'cargbn2', 'E')
		// CKD
		ElseIf GetText() = '8' Then
			SetItem(1, 'cargbn1', 'E')
			SetItem(1, 'cargbn2', 'E')
		// 기타(품목별)
		Else
			SetItem(1, 'cargbn1', '9')
			SetItem(1, 'cargbn2', '9')
		End If
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
	Case 'cvcod'
		gs_code = GetText()
		Open(w_vndmst_popup)
		If IsNull(gs_code) Or gs_code = '' Then Return
		
		SetItem(lrow, "cvcod", gs_Code)
		SetItem(lrow, "cvnas", gs_Codename)
End Choose
end event

type dw_list from w_standard_print`dw_list within w_sm00_00045
integer x = 32
integer y = 292
string dataobject = "d_sm00_00045_2"
boolean border = false
end type

event dw_list::clicked;call super::clicked;If Row <= 0 then
	SelectRow(0,False)
ELSE
	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
END IF
end event

type rr_2 from roundrectangle within w_sm00_00045
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 59
integer y = 44
integer width = 3008
integer height = 152
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_sm00_00045
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 288
integer width = 4613
integer height = 1980
integer cornerheight = 40
integer cornerwidth = 55
end type

