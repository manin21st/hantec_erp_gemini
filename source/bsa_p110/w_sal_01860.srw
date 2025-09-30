$PBExportHeader$w_sal_01860.srw
$PBExportComments$담보 만기 유효 현황
forward
global type w_sal_01860 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_01860
end type
end forward

global type w_sal_01860 from w_standard_print
string title = "담보만기 유효현황"
rr_1 rr_1
end type
global w_sal_01860 w_sal_01860

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_cvcod , ls_sarea , ls_sdate ,ls_edate , ls_yymm , ls_date

if dw_ip.accepttext() <> 1 then return -1

ls_sdate = Trim(dw_ip.getitemstring(1,'sdate'))
ls_edate = Trim(dw_ip.getitemstring(1,'edate'))
ls_cvcod = Trim(dw_ip.getitemstring(1,'cvcod'))
ls_sarea = Trim(dw_ip.getitemstring(1,'sarea'))

if ls_cvcod = "" or isnull(ls_cvcod) then ls_cvcod = '%'
if ls_sarea = "" or isnull(ls_sarea) then ls_sarea = '%'
	
if ls_sdate = "" or isnull(ls_sdate) then
	f_message_chk(30,'[유효기간 FROM]')
	dw_ip.setcolumn('sdate')
	dw_ip.setfocus()
	return -1
end if

if ls_edate = "" or isnull(ls_edate) then
	f_message_chk(30,'[유효기간 TO]')
	dw_ip.setcolumn('edate')
	dw_ip.setfocus()
	return -1
end if

ls_yymm = left(f_today(),6)
ls_date = left(f_today(),8)

string ls_silgu

SELECT DATANAME
INTO  :ls_silgu
FROM  SYSCNFG
WHERE SYSGU = 'S' AND SERIAL = '8' AND LINENO = '40' ;

if dw_print.retrieve(ls_sarea , ls_cvcod , ls_sdate , ls_edate , ls_yymm , ls_date , gs_sabu,ls_silgu ) < 1 then
	f_message_chk(300,'')
	return -1
end if

dw_print.sharedata(dw_list)

//dw_list.object.sdate.text = left(ls_sdate,4) + '.' + mid(ls_sdate,5,2) + '.' + mid(ls_sdate,7,2)
//dw_list.object.edate.text = left(ls_edate,4) + '.' + mid(ls_edate,5,2) + '.' + mid(ls_edate,7,2)

return 1

end function

on w_sal_01860.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sal_01860.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.settransobject(sqlca)
dw_ip.setitem(1,'sdate',left(f_today(),6) + '01' )
dw_ip.setitem(1,'edate',left(f_today(),8))

/* User별 관할구역 Setting */
String sarea, steam , saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
   dw_ip.Modify("sarea.protect=1")
	//dw_ip.Modify("sarea.background.color = 80859087")
End If
dw_ip.SetItem(1, 'sarea', sarea)
end event

type p_preview from w_standard_print`p_preview within w_sal_01860
end type

type p_exit from w_standard_print`p_exit within w_sal_01860
end type

type p_print from w_standard_print`p_print within w_sal_01860
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_01860
end type







type st_10 from w_standard_print`st_10 within w_sal_01860
end type



type dw_print from w_standard_print`dw_print within w_sal_01860
string dataobject = "d_sal_01860_01_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_01860
integer x = 78
integer y = 52
integer width = 3278
integer height = 152
string dataobject = "d_sal_01860"
end type

event dw_ip::rbuttondown;call super::rbuttondown;string ls_cvcod , ls_sarea , ls_cvcodnm , snull

setnull(gs_code)
setnull(gs_codename)

Choose Case this.getcolumnname()	
	Case "cvcod", "cvcodnm"
		gs_gubun = '1'
		If GetColumnName() = "cvcodnm" then
			gs_codename = Trim(GetText())
		End If
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		SetColumn("cvcod")
		TriggerEvent(ItemChanged!)
//	Case "cvcod"
//		
//		gs_gubun = '1'
//		Open(w_agent_popup)
//		
//		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
//		
//		this.SetItem(1,"cvcod",gs_code)
//		
//		SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA"
//		  INTO :ls_cvcodnm,		:ls_sarea
//		  FROM "VNDMST","SAREA" 
//		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
//		 
//		IF SQLCA.SQLCODE = 0 THEN
//			this.SetItem(1,"cvcodnm",  ls_cvcodnm)
//			this.SetItem(1,"sarea",  ls_sarea)
//		END IF
End Choose
end event

event dw_ip::itemchanged;call super::itemchanged;string  ls_cvcod , ls_cvcodnm , ls_sdate , ls_edate , ls_sarea , ls_data , snull , sCvcod, scvnas, sarea, steam, sSaupj, sName1

SetNull(snull)

Choose Case GetColumnName() 
 Case "sdate"
	ls_sdate = Trim(this.GetText())
	IF ls_sdate ="" OR IsNull(ls_sdate) THEN RETURN
	
	IF f_datechk(ls_sdate) = -1 THEN
		f_message_chk(35,'[유효기간 FROM]')
		this.SetItem(1,'sdate',snull)
		Return 1
	END IF
 Case "edate"
	ls_edate = Trim(this.GetText())
	IF ls_edate ="" OR IsNull(ls_edate) THEN RETURN
	
	IF f_datechk(ls_edate) = -1 THEN
		f_message_chk(35,'[유효기간 TO]')
		this.SetItem(1,'edate',snull)
		Return 1
	END IF
/* 관할구역 */
 Case "sarea"
	SetItem(1,"cvcod",sNull)
	SetItem(1,"cvcodnm",sNull)

	ls_sarea = this.GetText()
	IF ls_sarea = "" OR IsNull(ls_sarea) THEN RETURN
 /* 거래처 */
	Case "cvcod"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"cvcodnm",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'cvcodnm', snull)
			Return 1
		ELSE		
			SetItem(1,"cvcodnm", scvnas)
			SetItem(1,"sarea",   sarea)
		END IF
///* 거래처 */
//	Case "cvcod"
//		ls_cvcod = this.GetText()
//		IF ls_cvcod ="" OR IsNull(ls_cvcod) THEN
//			this.SetItem(1,"cvcodnm",snull)
//			Return
//		END IF
//		
//		SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA"
//			INTO :ls_cvcodnm,		:ls_sarea
//			FROM "VNDMST","SAREA" 
//			WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :ls_cvcod   ;
//		IF SQLCA.SQLCODE <> 0 THEN
//			this.TriggerEvent(RbuttonDown!)
//			Return 2
//		ELSE
//			this.SetItem(1,"cvcodnm",  ls_cvcodnm)
//			this.SetItem(1,"sarea",  ls_sarea)
//		END IF
End Choose
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_sal_01860
integer x = 87
integer y = 228
integer width = 4498
integer height = 2064
string dataobject = "d_sal_01860_01"
boolean border = false
end type

type rr_1 from roundrectangle within w_sal_01860
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 220
integer width = 4526
integer height = 2088
integer cornerheight = 40
integer cornerwidth = 55
end type

