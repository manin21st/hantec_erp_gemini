$PBExportHeader$w_sal_03560.srw
$PBExportComments$운송송장
forward
global type w_sal_03560 from w_standard_print
end type
type rr_2 from roundrectangle within w_sal_03560
end type
end forward

global type w_sal_03560 from w_standard_print
string title = "운송 송장"
rr_2 rr_2
end type
global w_sal_03560 w_sal_03560

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string	sfrdate, stodate, sarea,sfrvnd,sfrvndnm,sareanm, steamcd, sSaupj, sToarea

//////////////////////////////////////////////////////////////////
If dw_ip.accepttext() <> 1 Then return -1

sSaupj  = trim(dw_ip.getitemstring(1, 'saupj'))
sfrdate  = trim(dw_ip.getitemstring(1, 'frdate'))
stodate  = trim(dw_ip.getitemstring(1, 'todate'))
steamcd  = trim(dw_ip.getitemstring(1, 'steamcd'))
sarea    = trim(dw_ip.getitemstring(1, 'sarea'))
sfrvnd   = trim(dw_ip.getitemstring(1, 'cvcod'))
sfrvndnm = trim(dw_ip.getitemstring(1, 'cvcodnm'))
sareanm  = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(sarea) ', 1)"))
stoarea  = trim(dw_ip.getitemstring(1, 'toarea'))

If IsNull(steamcd)   Then steamcd = ''
If IsNull(sarea)     Then sarea = ''
If IsNull(sfrvnd)    Then sfrvnd = ''
If IsNull(sfrvndnm)  Then sfrvndnm = ''
If IsNull(sareanm) Or sareanm = ''     Then sareanm = '전체'
////////////////////////////////////////////////////// 기간 유효성 check
If IsNull(sSaupj) Or sSaupj = '' Then
   f_message_chk(1400,'[사업장]')
	dw_ip.setcolumn('saupj')
	dw_ip.setfocus()
	Return -1
End If

If IsNull(sfrdate) Or sfrdate = '' Then
   f_message_chk(1400,'[운송기간]')
	dw_ip.setcolumn('frdate')
	dw_ip.setfocus()
	Return -1
End If

If IsNull(stodate) Or stodate = '' Then
   f_message_chk(1400,'[운송기간]')
	dw_ip.setcolumn('todate')
	dw_ip.setfocus()
	Return -1
End If

If IsNull(sfrvnd) Or sfrvnd = '' Then
   f_message_chk(1400,'[발송처]')
	dw_ip.setcolumn('cvcod')
	dw_ip.setfocus()
	Return -1
End If

If IsNull(sToarea) or sToarea = '' Then sToarea = '%'

////////////////////////////////////////////////////////////////
SetPointer(HourGlass!)

dw_list.SetRedraw(False)
//if dw_list.retrieve(sfrdate, stodate, sfrvnd, sarea+'%', steamcd+'%') < 1	then
//	f_message_chk(50,"")
//	dw_ip.setcolumn('cvcod')
//	dw_ip.setfocus()
//	return -1
//end if

if dw_print.retrieve(gs_sabu, sfrdate, stodate, sfrvnd, gs_saupj, sToarea) < 1	then
	f_message_chk(50,"")
	dw_ip.setcolumn('cvcod')
	dw_ip.setfocus()
	return -1
end if

dw_print.ShareData(dw_list)

//////////////////////////////////////////////////////// title  설정
//dw_list.Object.tx_frvndnm.text = sfrvndnm
//dw_list.Object.tx_sareanm.text = sareanm

//dw_print.Object.tx_frvndnm.text = sfrvndnm
//dw_print.Object.tx_sareanm.text = sareanm

dw_list.SetRedraw(True)
Return 1


end function

on w_sal_03560.create
int iCurrent
call super::create
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
end on

on w_sal_03560.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
end on

event open;call super::open;string sDate

sDate = f_today()

dw_ip.SetItem(1,'frdate',left(sDate,6) + '01')
dw_ip.SetItem(1,'todate',sDate)

sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 세로방향"

/* User별 관할구역 Setting */
String sarea, steam , saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_ip.SetItem(1, 'sarea', sarea)
	dw_ip.SetItem(1, 'steamcd', steam)
	dw_ip.Modify("sarea.protect=1")
	dw_ip.Modify("steamcd.protect=1")
	dw_ip.Modify("sarea.background.color = 80859087")
	dw_ip.Modify("steamcd.background.color = 80859087")
End If
end event

type p_preview from w_standard_print`p_preview within w_sal_03560
end type

type p_exit from w_standard_print`p_exit within w_sal_03560
end type

type p_print from w_standard_print`p_print within w_sal_03560
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_03560
end type







type st_10 from w_standard_print`st_10 within w_sal_03560
end type



type dw_print from w_standard_print`dw_print within w_sal_03560
boolean visible = true
integer x = 82
integer y = 300
integer width = 4507
integer height = 1980
string dataobject = "d_sal_03560"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type dw_ip from w_standard_print`dw_ip within w_sal_03560
integer x = 59
integer y = 44
integer width = 2789
integer height = 232
string dataobject = "d_sal_03560_01"
end type

event dw_ip::rbuttondown;setnull(gs_code)
setnull(gs_codename)

IF dwo.name ="cvcod" THEN
	OPEN(W_VNDMST_POPUP)
	If IsNull(gs_code) Then Return
	
	dw_ip.SetItem(1,"cvcod",gs_code)
	dw_ip.SetItem(1,"cvcodnm",gs_codename)
End If

end event

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String snamef,snamet, ssort_gu,scode,sDate,sNull
Int il_Count

SetNull(sNull)
Choose Case GetColumnName() 
	Case 'frdate','todate'
		sdate = Trim(GetText())
		If f_datechk(sdate) <> 1 Then
			f_message_chk(35,'')
      setcolumn('frdate')
	     Return 1
    END IF
	Case "cvcod" 
  	  scode = this.GetText()
	  IF scode ="" OR IsNull(scode) THEN Return 
	
	  SELECT "VNDMST"."CVNAS2"		INTO :snamef
		 FROM "VNDMST"  
		WHERE "VNDMST"."CVCOD" =:scode ;
		
	 IF SQLCA.SQLCODE = 0 THEN				
		 dw_ip.SetItem(1,"cvcodnm",snamef)
		 dw_ip.SetFocus()
	 Else
		 f_message_chk(33,'')
		 dw_ip.SetItem(1,"cvcodnm",sNull)
		 Return 1
	 END IF
END Choose
end event

type dw_list from w_standard_print`dw_list within w_sal_03560
boolean visible = false
integer x = 3227
integer y = 108
integer width = 146
integer height = 116
string dataobject = "d_sal_03560"
end type

event dw_list::retrievestart;This.SetRedraw(False)
end event

event dw_list::retrieveend;This.SetRedraw(True)
end event

type rr_2 from roundrectangle within w_sal_03560
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 69
integer y = 288
integer width = 4544
integer height = 2084
integer cornerheight = 40
integer cornerwidth = 55
end type

