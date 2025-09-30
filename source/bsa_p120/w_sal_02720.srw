$PBExportHeader$w_sal_02720.srw
$PBExportComments$이송현황
forward
global type w_sal_02720 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_02720
end type
end forward

global type w_sal_02720 from w_standard_print
string title = "이송 현황"
rr_1 rr_1
end type
global w_sal_02720 w_sal_02720

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_sdate , ls_edate , ls_sarea , ls_saupj , ls_cvcod ,tx_name , ls_gubun, sDepot
 
if dw_ip.accepttext() <> 1 then return -1

ls_sdate = Trim(dw_ip.getitemstring(1,'sdate'))
ls_edate = Trim(dw_ip.getitemstring(1,'edate'))
ls_sarea = Trim(dw_ip.getitemstring(1,'sarea'))
ls_saupj = Trim(dw_ip.getitemstring(1,'saupj'))
ls_cvcod = Trim(dw_ip.getitemstring(1,'cvcod'))
sDepot   = Trim(dw_ip.getitemstring(1,'depot_no'))

if ls_sdate = "" or isnull(ls_sdate) then
	f_message_chk(30,'[수주기간 FROM]')
	dw_ip.setfocus()
	dw_ip.setcolumn('sdate')
	return -1
end if

if ls_edate = "" or isnull(ls_edate) then
	f_message_chk(30,'[수주기간 TO]')
	dw_ip.setfocus()
	dw_ip.setcolumn('edate')
	return -1
end if

if sDepot = "" or isnull(sDepot) then
	f_message_chk(30,'[출고요청창고]')
	dw_ip.setfocus()
	dw_ip.setcolumn('depot_no')
	return -1
end if

if ls_sarea = "" or isnull(ls_sarea) then ls_sarea = '%'
if ls_saupj = "" or isnull(ls_saupj) then ls_saupj = '%'
if ls_cvcod = "" or isnull(ls_cvcod) then ls_cvcod = '%'


ls_gubun = Trim(dw_ip.getitemstring(1,'gubun'))
If IsNull(ls_gubun) Or ls_gubun = 'A' Then ls_gubun = ''

//if dw_list.retrieve(gs_sabu , ls_sdate , ls_edate , ls_saupj , ls_sarea , ls_cvcod, ls_gubun+'%', sDepot) < 1 then
//	f_message_chk(300,'')
//	dw_ip.setfocus()
//	dw_ip.setcolumn('sdate')
//	return -1
//end if

if dw_print.retrieve(gs_sabu , ls_sdate , ls_edate , ls_saupj , ls_sarea , ls_cvcod, ls_gubun+'%', sDepot) < 1 then
	f_message_chk(300,'')
	dw_ip.setfocus()
	dw_ip.setcolumn('sdate')
	return -1
end if

dw_print.ShareData(dw_list)

//dw_list.object.tx_sdate.text = left(ls_sdate,4) + '.' + mid(ls_sdate,5,2)+ '.' + mid(ls_sdate,7,2)
//dw_list.object.tx_edate.text = left(ls_edate,4) + '.' + mid(ls_edate,5,2)+ '.' + mid(ls_edate,7,2)

dw_print.object.tx_sdate.text = left(ls_sdate,4) + '.' + mid(ls_sdate,5,2)+ '.' + mid(ls_sdate,7,2)
dw_print.object.tx_edate.text = left(ls_edate,4) + '.' + mid(ls_edate,5,2)+ '.' + mid(ls_edate,7,2)

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_saupj.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(sarea) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_sarea.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(depot_no) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_depot.text = '"+tx_name+"'")

return 1
end function

on w_sal_02720.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sal_02720.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.settransobject(sqlca)
dw_list.settransobject(sqlca)

dw_ip.insertrow(0)

dw_ip.setitem(1,'sdate',left(f_today(),6) + '01' )
dw_ip.setitem(1,'edate',left(f_today(),8))

/* User별 관할구역 Setting */
String sarea, steam , saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
   dw_ip.Modify("sarea.protect=1")
	dw_ip.Modify("sarea.background.color = 80859087")
End If
dw_ip.SetItem(1, 'sarea', sarea)
dw_ip.SetItem(1, 'saupj', saupj)

sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 가로방향"
end event

type p_preview from w_standard_print`p_preview within w_sal_02720
end type

type p_exit from w_standard_print`p_exit within w_sal_02720
end type

type p_print from w_standard_print`p_print within w_sal_02720
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_02720
end type



type sle_msg from w_standard_print`sle_msg within w_sal_02720
integer x = 389
end type



type st_10 from w_standard_print`st_10 within w_sal_02720
end type



type dw_print from w_standard_print`dw_print within w_sal_02720
string dataobject = "d_sal_02720_01_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_02720
integer x = 18
integer y = 28
integer width = 3799
integer height = 236
string dataobject = "d_sal_02720"
end type

event dw_ip::itemchanged;call super::itemchanged;string snull ,sCvcod, scvnas, sarea, steam, sSaupj, sName1 ,ls_sdate ,ls_edate

setnull(snull)

Choose Case this.getcolumnname()
	 Case "sdate"
	ls_sdate = Trim(this.GetText())
	IF ls_sdate ="" OR IsNull(ls_sdate) THEN RETURN
	
	IF f_datechk(ls_sdate) = -1 THEN
		f_message_chk(35,'[수주기간 FROM]')
		this.SetItem(1,"sdate",snull)
		Return 1
	END IF
 Case "edate"
	ls_edate = Trim(this.GetText())
	IF ls_edate ="" OR IsNull(ls_edate) THEN RETURN
	
	IF f_datechk(ls_edate) = -1 THEN
		f_message_chk(35,'[수주기간 TO]')
		this.SetItem(1,"edate",snull)
		Return 1
	END IF
	
Case 'sarea'
	this.setitem(1,'cvcod',snull)
	this.setitem(1,'cvcodnm',snull)
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
End Choose
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::rbuttondown;call super::rbuttondown;setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

Choose Case this.getcolumnname()
	Case "cvcod"
		gs_gubun = '1'
		If GetColumnName() = "cvcodnm" then
			gs_codename = Trim(GetText())
		End If
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		SetColumn("cvcod")
		TriggerEvent(ItemChanged!)
End Choose
end event

type dw_list from w_standard_print`dw_list within w_sal_02720
integer x = 55
integer y = 276
integer width = 4526
integer height = 2028
string dataobject = "d_sal_02720_01"
boolean hscrollbar = false
boolean vscrollbar = false
boolean border = false
boolean hsplitscroll = false
boolean livescroll = false
end type

type rr_1 from roundrectangle within w_sal_02720
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 268
integer width = 4558
integer height = 2048
integer cornerheight = 40
integer cornerwidth = 55
end type

