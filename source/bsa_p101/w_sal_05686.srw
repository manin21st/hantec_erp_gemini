$PBExportHeader$w_sal_05686.srw
$PBExportComments$년도별 월별 판매금액 그래프
forward
global type w_sal_05686 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_05686
end type
end forward

global type w_sal_05686 from w_standard_print
string title = "년도별 월별 판매금액 그래프"
rr_1 rr_1
end type
global w_sal_05686 w_sal_05686

type variables
str_itnct str_sitnct
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sSteamCd, sArea, tx_name
String sFRom, sTo,sMsg, sModString
Long   ix, iy, iz, nRow, nRtn
Double dAmt[13]

If dw_ip.AcceptText() <> 1 Then Return -1

sFrom       = Trim(dw_ip.GetItemString(1,"sdatef"))
sTo         = Trim(dw_ip.GetItemString(1,"sdatet"))
sSteamCd    = Trim(dw_ip.GetItemString(1,"deptcode"))
sArea       = Trim(dw_ip.GetItemString(1,"areacode"))

IF sFrom = "" OR IsNull(sFrom) THEN
	f_message_chk(30,'[판매기간]')
	dw_ip.SetColumn("sdatef")
	dw_ip.SetFocus()
	Return -1
END IF

IF sTo = "" OR IsNull(sTo) THEN
	f_message_chk(30,'[판매기간]')
	dw_ip.SetColumn("sdatet")
	dw_ip.SetFocus()
	Return -1
END IF

If Isnull(sSteamCd) Then sSteamCd = ''
If Isnull(sArea) Then sArea = ''

SetPointer(HourGlass!)


string ls_silgu

SELECT DATANAME
INTO  :ls_silgu
FROM  SYSCNFG
WHERE SYSGU = 'S' AND SERIAL = '8' AND LINENO = '40' ;

IF dw_print.Retrieve(gs_sabu, sFrom+'01', sTo+'12', sSteamCd+'%',sArea+'%',ls_silgu) <=0 THEN
	f_message_chk(50,'')
   dw_ip.setcolumn('sdatef')
	dw_ip.SetFocus()
	dw_print.InsertRow(0)
//	Return -1
else
	dw_print.sharedata(dw_list)
END IF

/* 합계 계산 */
For ix = Long(sFrom) To Long(sTo)
	dAmt = { 0,0,0,0,0,0,0,0,0,0,0,0,0 }	
	
	/* 년도별 합계 */
	For iz = 1 To dw_print.RowCount()
		If String(ix) = dw_print.GetItemString(iz,'year') Then
			For iy = 1 To 13
				dAmt[iy] += dw_print.GetItemNumber(iz, 'qty'+string(iy))
			Next
		End If
	Next
	
	nRow = dw_print.InsertRow(0)
	dw_print.SetItem(nRow,'steamcd','합  계')
	dw_print.SetItem(nRow,'year', String(ix))
	
	For iy = 1 To 13
		dw_print.SetItem(nRow,'qty'+String(iy), dAmt[iy])
	Next
Next

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(deptcode) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("txt_steamcd.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(areacode) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("txt_sarea.text = '"+tx_name+"'")

dw_print.GroupCalc()

Return 1
end function

on w_sal_05686.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sal_05686.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(1,"sdatef", Left(is_today,4))
dw_ip.SetItem(1,"sdatet", Left(is_today,4))




end event

type p_preview from w_standard_print`p_preview within w_sal_05686
end type

type p_exit from w_standard_print`p_exit within w_sal_05686
end type

type p_print from w_standard_print`p_print within w_sal_05686
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_05686
end type











type dw_print from w_standard_print`dw_print within w_sal_05686
string dataobject = "d_sal_056861_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_05686
integer x = 46
integer y = 24
integer width = 1586
integer height = 308
string dataobject = "d_sal_056863"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::itemchanged;String  sNull, sPrtGbn
Long    nRow

SetNull(snull)

nRow = GetRow()
If nRow <= 0 Then Return

SetPointer(HourGlass!)

Choose Case GetColumnName() 
	/* 자료구분 */
	Case 'prtgbn'
		sPrtGbn = this.GetText()
		
		dw_list.SetRedraw(False)
		IF sPrtGbn = '1' THEN													/* 영업팀 */
			dw_list.DataObject = 'd_sal_056861'
		ELSEIF sPrtGbn = '2' THEN												/* 관할구역 */
			dw_list.DataObject = 'd_sal_056862'
		END IF
		dw_list.SetTransObject(SQLCA)
		dw_list.Reset()
		dw_list.SetRedraw(True)
END Choose

end event

event dw_ip::ue_key;call super::ue_key;string sCol

SetNull(gs_code)
SetNull(gs_codename)

IF KeyDown(KeyF2!) THEN
	Choose Case GetColumnName()
	   Case  'itcls'
		    open(w_ittyp_popup3) 
			 str_sitnct = Message.PowerObjectParm
			 if IsNull(str_sitnct.s_ittyp) or str_sitnct.s_ittyp = "" then return
		    this.SetItem(1, "ittyp", str_sitnct.s_ittyp)
		    this.SetItem(1, "itcls", str_sitnct.s_sumgub)
		    this.SetItem(1, "itclsnm", str_sitnct.s_titnm)
	END Choose
End if	
end event

type dw_list from w_standard_print`dw_list within w_sal_05686
integer x = 64
integer y = 364
integer width = 4530
integer height = 1952
string dataobject = "d_sal_056861"
boolean vscrollbar = false
boolean border = false
end type

type rr_1 from roundrectangle within w_sal_05686
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 352
integer width = 4558
integer height = 1976
integer cornerheight = 40
integer cornerwidth = 55
end type

