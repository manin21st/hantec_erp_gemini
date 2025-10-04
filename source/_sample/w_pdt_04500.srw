$PBExportHeader$w_pdt_04500.srw
$PBExportComments$** 일일 입고 현황
forward
global type w_pdt_04500 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdt_04500
end type
type rr_2 from roundrectangle within w_pdt_04500
end type
end forward

global type w_pdt_04500 from w_standard_print
string title = "일일입고현황"
rr_1 rr_1
rr_2 rr_2
end type
global w_pdt_04500 w_pdt_04500

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sdate, edate, cod, ssaupj

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sdate  = trim(dw_ip.object.sdate[1])
edate  = trim(dw_ip.object.edate[1])
cod    = trim(dw_ip.object.cod[1])
ssaupj = trim(dw_ip.object.saupj[1])

if (IsNull(sdate) or sdate = "")  then sdate = "11110101"
if (IsNull(edate) or edate = "")  then edate = "99991231"
if (IsNull(cod) or cod = "")  then cod = '%'
if (IsNull(ssaupj) or ssaupj = "")  then cod = '%'

//if dw_list.Retrieve(gs_sabu, sdate, edate, cod) <= 0 then
//	f_message_chk(50,"[일일 입고 현황]")
//	dw_ip.Setfocus()
//	return -1
//end if

IF dw_print.Retrieve(gs_sabu, sdate, edate, cod, ssaupj) <= 0 then
	f_message_chk(50,"[일일 입고 현황]")
	dw_list.Reset()
	dw_ip.Setfocus()
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.object.txt_date.text = String(sdate,"@@@@.@@.@@") + " - " + String(edate,"@@@@.@@.@@")
dw_print.ShareData(dw_list)

return 1
end function

on w_pdt_04500.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.rr_2
end on

on w_pdt_04500.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_ip.setitem(1, 'sdate', is_today)
dw_ip.setitem(1, 'edate', is_today)

/* 사업장 구분 */
setnull(gs_code)
//If f_check_saupj() = 1 Then
//	dw_ip.SetItem(1, 'saupj', gs_code)
//	if gs_code <> '%' then
//		dw_ip.Modify("saupj.protect=1")
//		dw_ip.Modify("saupj.background.color = 80859087")
//	End if
//End If

f_mod_saupj(dw_ip, 'saupj')
f_child_saupj(dw_ip, 'cod', gs_saupj)
///* 생산팀 & 영업팀 & 관할구역 Filtering */
//DataWindowChild state_child1, state_child2, state_child3
//integer rtncode1, rtncode2, rtncode3
//
//IF gs_saupj              = '10' THEN
//	rtncode1    = dw_ip.GetChild('cod', state_child1)
//	
//	IF rtncode1 = -1 THEN MessageBox("Error1", "Not a DataWindowChild")	
//	state_child1.setFilter("Mid(cvcod,1,2) <> 'Z9'")
//	state_child1.Filter()
//	
//ELSEIF gs_saupj      = '11' THEN
//   rtncode1    = dw_ip.GetChild('cod', state_child1)
//	
//	IF rtncode1 = -1 THEN MessageBox("Error1", "Not a DataWindowChild")	
//	state_child1.setFilter("Mid(cvcod,1,2) = 'Z9'")
//	state_child1.Filter()
//END IF

DataWindowChild state_child
integer rtncode

//창고
rtncode 	= dw_ip.GetChild('cod', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 창고")
state_child.SetTransObject(SQLCA)
state_child.Retrieve(gs_saupj)
end event

type p_preview from w_standard_print`p_preview within w_pdt_04500
integer x = 4073
end type

type p_exit from w_standard_print`p_exit within w_pdt_04500
integer x = 4421
end type

type p_print from w_standard_print`p_print within w_pdt_04500
integer x = 4247
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_04500
integer x = 3899
end type







type st_10 from w_standard_print`st_10 within w_pdt_04500
end type



type dw_print from w_standard_print`dw_print within w_pdt_04500
string dataobject = "d_pdt_04500_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_04500
integer x = 55
integer y = 48
integer width = 2825
integer height = 112
string dataobject = "d_pdt_04500_01"
end type

event dw_ip::itemchanged;String s_cod

s_cod = Trim(this.GetText())

if this.GetColumnName() = "sdate" then
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[시작일자]")
		this.object.sdate[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "edate" then
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[끝일자]")
		this.object.edate[1] = ""
		return 1
	end if
elseif getcolumnname() = 'saupj' then
	f_child_saupj(this, 'cod', gettext())
end if
end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_pdt_04500
integer y = 212
integer width = 4530
integer height = 2104
string dataobject = "d_pdt_04500_02"
boolean border = false
end type

type rr_1 from roundrectangle within w_pdt_04500
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 32
integer y = 40
integer width = 2875
integer height = 144
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdt_04500
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 200
integer width = 4553
integer height = 2136
integer cornerheight = 40
integer cornerwidth = 55
end type

