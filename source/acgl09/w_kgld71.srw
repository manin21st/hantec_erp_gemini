$PBExportHeader$w_kgld71.srw
$PBExportComments$계정상계 현황
forward
global type w_kgld71 from w_standard_print
end type
type rr_1 from roundrectangle within w_kgld71
end type
end forward

global type w_kgld71 from w_standard_print
integer x = 0
integer y = 0
string title = "계정 상계 현황"
rr_1 rr_1
end type
global w_kgld71 w_kgld71

forward prototypes
public function integer wf_retrieve ()
public function integer wf_create_work (datastore ds_sanglst, string ssaupj, string sfrom, string sto, string ssaupno)
end prototypes

public function integer wf_retrieve ();String     sSaupj,sDateF,sDateT,sSaupNo
DataStore  Idw_SangLst
		
dw_ip.AcceptText()
sSaupj = dw_ip.GetItemString(1,"saupj")
sDateF = Trim(dw_ip.GetItemString(1,"sdate"))
sDateT = Trim(dw_ip.GetItemString(1,"edate"))
sSaupNo= dw_ip.GetItemString(1,"saupno")

IF sSaupj = "" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return -1
END IF
	
IF sDateF = "" OR IsNull(sDateF) THEN
	F_MessageChk(1,'[처리일자]')
	dw_ip.SetColumn("sdate")
	dw_ip.SetFocus()
	Return -1
END IF
IF sDateT = "" OR IsNull(sDateT) THEN
	F_MessageChk(1,'[처리일자]')
	dw_ip.SetColumn("edate")
	dw_ip.SetFocus()
	Return -1
END IF

IF sSaupNo = "" OR IsNull(sSaupNo) THEN
	F_MessageChk(1,'[거래처]')
	dw_ip.SetColumn("saupno")
	dw_ip.SetFocus()
	Return -1
END IF

Idw_SangLst    = Create DataStore

Idw_SangLst.DataObject = 'dw_kgld713'
Idw_SangLst.SetTransObject(Sqlca)
Idw_SangLst.Reset()

setpointer(hourglass!)

IF Idw_SangLst.Retrieve(sSaupj,sDateF,sDateT,sSaupNo) <=0 then
	F_Messagechk(14,'')
   dw_list.SetRedraw(true)	
	return -1	 	
END IF

If Wf_Create_Work(Idw_SangLst,sSaupj,sDateF,sDateT,sSaupNo) = -1 then Return 1

//dw_list.SetRedraw(false)
//dw_print.sharedata(dw_list)
//dw_list.SetRedraw(true)	
//setpointer(arrow!)

return 1
end function

public function integer wf_create_work (datastore ds_sanglst, string ssaupj, string sfrom, string sto, string ssaupno);Integer  iRowCount,iCurRow,k,iCnt1,iCnt2,iInsRow,i
String   sSaupjS,sBalDateS,sUpmuGuS,sDcGbn
Long     lJunNoS

iCurRow = 1
iRowCount = ds_sanglst.RowCount()

FOR k = 1 TO iRowCount
	sSaupjS   = ds_sanglst.GetItemString(k,"saupj_s")
	sBalDateS = ds_sanglst.GetItemString(k,"bal_date_s")
	sUpmuGuS  = ds_sanglst.GetItemString(k,"upmu_gu_s")
	lJunNoS   = ds_sanglst.GetItemNumber(k,"bjun_no_s")
	iCnt1     = ds_sanglst.GetItemNumber(k,"cnt1")						/*외상매출,미수 건수*/
	iCnt2     = ds_sanglst.GetItemNumber(k,"cnt2")						/*외상매입,미지급 건수*/
	
	if iCnt1 >= iCnt2 then
		iInsRow = iCnt1
		sDcGbn = '2'
	else
		iInsRow = iCnt2
		sDcGbn = '1'
	end if
	for i = 1 to iInsRow
		dw_list.InsertRow(0)
	next
	iCurRow = 1
	
	
NEXT
	
Return 1
end function

on w_kgld71.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kgld71.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;
dw_ip.SetItem(1,"sdate", f_today())
dw_ip.SetItem(1,"saupj",  gs_saupj)
dw_ip.SetFocus()


IF F_Authority_Chk(Gs_Dept) = -1 THEN							/*권한 체크- 현업 여부*/
	dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
	
	dw_ip.Modify("saupj.protect = 1")
ELSE
	dw_ip.Modify("saupj.protect = 0")
END IF	
end event

type p_preview from w_standard_print`p_preview within w_kgld71
integer x = 4087
integer y = 0
end type

type p_exit from w_standard_print`p_exit within w_kgld71
integer x = 4434
integer y = 0
end type

type p_print from w_standard_print`p_print within w_kgld71
integer x = 4261
integer y = 0
end type

type p_retrieve from w_standard_print`p_retrieve within w_kgld71
integer x = 3913
integer y = 0
end type

type st_window from w_standard_print`st_window within w_kgld71
integer x = 2409
integer width = 457
end type

type sle_msg from w_standard_print`sle_msg within w_kgld71
integer width = 2016
end type

type dw_datetime from w_standard_print`dw_datetime within w_kgld71
integer x = 2866
end type

type st_10 from w_standard_print`st_10 within w_kgld71
end type

type gb_10 from w_standard_print`gb_10 within w_kgld71
integer width = 3607
end type

type dw_print from w_standard_print`dw_print within w_kgld71
string dataobject = "dw_kgld702_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kgld71
integer x = 50
integer y = 4
integer width = 3753
integer height = 144
string dataobject = "dw_kgld711"
end type

type dw_list from w_standard_print`dw_list within w_kgld71
integer x = 73
integer y = 172
integer width = 4517
integer height = 2000
string dataobject = "dw_kgld712"
boolean border = false
end type

type rr_1 from roundrectangle within w_kgld71
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 69
integer y = 160
integer width = 4535
integer height = 2040
integer cornerheight = 40
integer cornerwidth = 55
end type

