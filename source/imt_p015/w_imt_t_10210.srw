$PBExportHeader$w_imt_t_10210.srw
$PBExportComments$** 월 발주 금액 현황
forward
global type w_imt_t_10210 from w_standard_print
end type
type rr_1 from roundrectangle within w_imt_t_10210
end type
end forward

global type w_imt_t_10210 from w_standard_print
string title = "월 발주 금액 현황"
boolean maxbox = true
rr_1 rr_1
end type
global w_imt_t_10210 w_imt_t_10210

type variables
String is_nadat
String is_printgu = 'Y'
end variables

forward prototypes
public function integer wf_retrieve ()
public function integer wf_plncrt_check ()
end prototypes

public function integer wf_retrieve ();string ls_cvcod1, ls_cvcod2, ls_baldate, ls_prv_mon

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

ls_baldate  = trim(dw_ip.object.baldate[1])
ls_cvcod1   = trim(dw_ip.object.cvcod1[1])
ls_cvcod2   = trim(dw_ip.object.cvcod2[1])

if (IsNull(ls_cvcod1) or ls_cvcod1		= "") then ls_cvcod1 = "."
if (IsNull(ls_cvcod2) or ls_cvcod2		= "") then ls_cvcod2 = "ZZZ"

if IsNull(ls_baldate) or ls_baldate = "" then 
	f_message_chk(30,'[ 발주월 ]')
	return -1
End If

if dw_list.Retrieve(gs_sabu, ls_baldate, ls_cvcod1, ls_cvcod2, gs_saupj) <= 0 then
	f_message_chk(50,'[ 월 발주금액 현황 ]')
	dw_ip.Setfocus()
	return -1
end if

select To_Char(add_months(TO_DATE(:ls_baldate||'01','YYYYMMDD'),-1),'MM')
Into :ls_prv_mon
From Dual;

dw_list.Object.t_1.Text = ls_prv_mon + '월 발주수량'
//dw_list.Object.t_2.Text = ls_prv_mon + '월 평균단가'
dw_list.Object.t_3.Text = ls_prv_mon + '월 발주금액'
dw_list.Object.t_4.Text = right(ls_baldate,2) + '월 발주수량'
//dw_list.Object.t_5.Text = right(ls_baldate,2) + '월 평균단가'
dw_list.Object.t_6.Text = right(ls_baldate,2) + '월 발주금액'

dw_print.Object.t_1.Text = ls_prv_mon + '월 발주수량'
//dw_print.Object.t_2.Text = ls_prv_mon + '월 평균단가'
dw_print.Object.t_3.Text = ls_prv_mon + '월 발주금액'
dw_print.Object.t_4.Text = right(ls_baldate,2) + '월 발주수량'
//dw_print.Object.t_5.Text = right(ls_baldate,2) + '월 평균단가'
dw_print.Object.t_6.Text = right(ls_baldate,2) + '월 발주금액'

dw_print.ShareData(dw_list)

return 1
end function

public function integer wf_plncrt_check ();	String ls_plncrt
	
	ls_plncrt = dw_ip.GetItemString(1, 'plncrt')
	
	If ls_plncrt = '1' Then
		dw_list.DataObject = 'd_imt_t_10110_d_1'
		dw_print.DataObject = 'd_imt_t_10110_p_1'
		dw_ip.Object.t_3.text  = '기준년월'
		dw_ip.Object.nadatm.visible = True
		dw_ip.Object.nadat.visible  = False
		dw_ip.Object.nadat2.visible = False
		dw_ip.Object.t_5.visible  = False
	Else
		dw_list.DataObject = 'd_imt_t_10110_d_2'
		dw_print.DataObject = 'd_imt_t_10110_p_2'
//		this.Object.t_5.visible  = True
//		this.Object.t_6.visible  = True
		dw_ip.Object.t_3.text  = '기준입고일'
		dw_ip.Object.nadat.visible  = True
		dw_ip.Object.nadatm.visible = False
		dw_ip.Object.nadat2.visible = True
		dw_ip.Object.t_5.visible  = True
	End If

return 1
end function

on w_imt_t_10210.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_imt_t_10210.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(1,'baldate',Left(f_today(),6))
end event

type p_preview from w_standard_print`p_preview within w_imt_t_10210
end type

type p_exit from w_standard_print`p_exit within w_imt_t_10210
end type

type p_print from w_standard_print`p_print within w_imt_t_10210
end type

event p_print::clicked;call super::clicked;long k, lCount

//출력시 y로 변경
if is_printgu  = 'Y' then 

	lCount = dw_list.rowcount()
	
	if lCount < 1  then return 
	
	FOR k = 1 TO lCount
		dw_list.setitem(k, 'pomast_printgu', 'Y')
	NEXT
	
	if dw_list.update() = 1 then
		commit ;
	else
		rollback ;
	end if	

   is_printgu  = 'N'
end if
end event

type p_retrieve from w_standard_print`p_retrieve within w_imt_t_10210
end type







type st_10 from w_standard_print`st_10 within w_imt_t_10210
end type



type dw_print from w_standard_print`dw_print within w_imt_t_10210
string dataobject = "d_imt_t_10210_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_t_10210
integer x = 37
integer y = 24
integer width = 3218
integer height = 216
string dataobject = "d_imt_t_10210_h"
end type

event dw_ip::itemchanged;String  ls_cvcod, ls_cvnas

If this.getcolumnname() = 'cvcod1' then 
	
	ls_cvcod = this.getText()

	Select cvnas2
	Into :ls_cvnas
	From vndmst
	Where cvcod = :ls_cvcod;

	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("확인", "거래처 코드를 확인하십시요.")
		this.SetFocus()
		this.SetColumn("cvcod1")
		this.SetItem(1,"cvcod1",  "")
		//this.TriggerEvent(RbuttonDown!)
		Return 2
	ELSE
		this.setitem(1,"cvcod1", ls_cvcod)		
   	this.setitem(1,"cvnas1", ls_cvnas)
	END IF

elseif this.getcolumnname() = 'cvcod2' then   
	ls_cvcod = this.getText()

	Select cvnas2
	Into :ls_cvnas
	From vndmst
	Where cvcod = :ls_cvcod;

	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("확인", "거래처 코드를 확인하십시요.")
		this.SetFocus()
		this.SetColumn("cvcod1")
		this.SetItem(1,"cvcod1",  "")
		//this.TriggerEvent(RbuttonDown!)
		Return 2
	ELSE
		this.setitem(1,"cvcod2", ls_cvcod)		
   	this.setitem(1,"cvnas2", ls_cvnas)
	END IF

END IF
end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

IF this.getcolumnname() = "cvcod1"	THEN		
	gs_gubun = '1' 
	open(w_vndmst_popup)
	
	if gs_code = '' or isnull(gs_code) then return 
	
	this.SetItem(1, "cvcod1", gs_code)
	this.SetItem(1, "cvnas1", gs_codename)
ELSEIF this.getcolumnname() = "cvcod2"	THEN		
	gs_gubun = '1' 
	open(w_vndmst_popup)

	if gs_code = '' or isnull(gs_code) then return 
	this.SetItem(1, "cvcod2", gs_code)
	this.SetItem(1, "cvnas2", gs_codename)

ElseIf this.GetColumnName() = "baljpno" then
	//기존 발주서에서 호출하는 POPUp으로 수정함.
	gs_gubun = '1' //발주지시상태 => 1:의뢰
	open(w_poblkt_popup)
	IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	this.setitem(1, "baljpno", left(gs_code, 12))
	this.triggerevent(itemchanged!)
	
//	open(w_pomast_popup)
//	IF gs_code = "" OR IsNull(gs_code) THEN RETURN
//	this.object.baljpno[1] = gs_code
//	this.TriggerEvent(ItemChanged!)
end if
end event

type dw_list from w_standard_print`dw_list within w_imt_t_10210
integer x = 46
integer y = 252
integer width = 4549
integer height = 2016
string dataobject = "d_imt_t_10210_d"
boolean border = false
end type

event dw_list::printend;call super::printend;is_printgu  = 'Y'
end event

type rr_1 from roundrectangle within w_imt_t_10210
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 248
integer width = 4571
integer height = 2032
integer cornerheight = 40
integer cornerwidth = 55
end type

