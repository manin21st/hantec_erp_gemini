$PBExportHeader$w_qct_05510.srw
$PBExportComments$교정 계획 대 실적
forward
global type w_qct_05510 from w_standard_print
end type
type rr_1 from roundrectangle within w_qct_05510
end type
end forward

global type w_qct_05510 from w_standard_print
string title = "교정 계획 대 실적"
rr_1 rr_1
end type
global w_qct_05510 w_qct_05510

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ar_syear, ar_silgu, ar_sort, ar_frmchno, ar_tomchno, buncd, buncd1

string tx_dptnm

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

ar_syear  = dw_ip.GetItemString(dw_ip.GetRow(),'syear')
ar_silgu  = dw_ip.GetItemString(dw_ip.GetRow(),'silgu')
ar_sort  = dw_ip.GetItemString(dw_ip.GetRow(),'sort')
buncd  = trim(dw_ip.object.buncd[1])
buncd1 = trim(dw_ip.object.buncd1[1])
//ar_dptno  = dw_ip.GetItemString(dw_ip.GetRow(),'dptno')
//ar_frmchno  = dw_ip.GetItemString(dw_ip.GetRow(),'fr_mchno')
//ar_tomchno  = dw_ip.GetItemString(dw_ip.GetRow(),'to_mchno')
IF	IsNull(ar_syear) or ar_syear = '' then
	f_message_chk(1400,'[기준년도]')
	dw_ip.setcolumn('syear')
	dw_ip.setfocus()
	Return -1
END IF

if (IsNull(buncd) or buncd = "" ) then buncd = '.'
if (IsNull(buncd1) or buncd1 = "" ) then buncd1 = 'zzzzzzzzzzzzz' 
If IsNull(ar_frmchno) Then ar_frmchno = '.'
If IsNull(ar_tomchno) Then ar_tomchno = 'ZZZZZZ'
////////////////////////////////////////////////////////////////
dw_list.SetRedraw(False)

//dw_list.object.txt_mchno.text = buncd + " - " + buncd1
	
//if dw_list.retrieve(gs_sabu, ar_syear,ar_silgu,ar_sort, buncd, buncd1) <= 0	then
//   dw_list.SetRedraw(True)
//	f_message_chk(50,"[교정 계획 및 실적")
//	dw_ip.setcolumn('syear')
//	dw_ip.setfocus()
//	return -1
//end if

IF dw_print.Retrieve(gs_sabu, ar_syear,ar_silgu,ar_sort, buncd, buncd1) <= 0	then
	f_message_chk(50,"[교정 계획 및 실적")
	dw_list.Reset()
	dw_ip.SetFocus()
	dw_list.SetRedraw(true)
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

//tx_dptnm = Trim(dw_ip.object.dptnonm[1])
//If tx_dptnm = '' Or IsNull(tx_dptnm) Then tx_dptnm = '전체'
//
//dw_list.Object.tx_dptnm.Text = tx_dptnm
//
Choose Case ar_sort
	Case '1'
		dw_list.SetSort('mesmst_yudat A')
	Case '2'
		dw_list.SetSort('amt A')
	Case '3'
		dw_list.SetSort('vndmst_cvnas2 A')
End Choose
dw_list.Sort()

dw_list.SetRedraw(True)

Return 1

end function

on w_qct_05510.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_qct_05510.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(1,'syear', left(is_today, 4))
sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 가로방향"
end event

type p_preview from w_standard_print`p_preview within w_qct_05510
end type

type p_exit from w_standard_print`p_exit within w_qct_05510
end type

type p_print from w_standard_print`p_print within w_qct_05510
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_05510
end type







type st_10 from w_standard_print`st_10 within w_qct_05510
end type



type dw_print from w_standard_print`dw_print within w_qct_05510
string dataobject = "d_qct_05510_p"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_05510
integer x = 78
integer y = 56
integer width = 2679
integer height = 200
string dataobject = "d_qct_05510_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;setnull(gs_gubun)
setnull(gs_code)
setnull(gs_codename)

//Choose Case GetColumnName()
//	Case 'dptno' 
//		OPEN(w_vndmst_4_popup)
//		if gs_code = '' or isnull(gs_code) then return 
//		this.SetItem(1, "dptno", gs_code)
//		this.object.deptnm[1] = gs_codename
//	Case 'fr_mchno' 
//		gs_code = '계측기'
//   	OPEN(w_mchno_popup)
//		if gs_code = '' or isnull(gs_code) then return 
//	   dw_ip.object.fr_mchno[1] = gs_code
//	Case 'to_mchno' 
//		gs_code = '계측기'
//   	OPEN(w_mchno_popup)
//		if gs_code = '' or isnull(gs_code) then return 
//	   dw_ip.object.to_mchno[1] = gs_code
//	Case 'buncd'
//		gs_gubun = 'Y'
//		open(w_mittyp_popup)
//		if isnull(gs_code) or gs_code = '' then return
//		this.object.buncd[1] = gs_code
//		this.object.bunnam[1] = gs_codename		
//End choose


if this.GetColumnName() = "buncd" then
	gs_gubun = 'ALL'
	gs_code = '계측기'
	gs_codename = '계측기관리번호'
	open(w_mchno_popup)
	if isnull(gs_code) or gs_code = '' then return
	this.object.buncd[1] = gs_code
	
elseif this.GetColumnName() = "buncd1" then
	gs_gubun = 'ALL'
	gs_code = '계측기'
	gs_codename = '계측기관리번호'
	open(w_mchno_popup)
	if isnull(gs_code) or gs_code = '' then return
	this.object.buncd1[1] = gs_code
		
end if
end event

event dw_ip::itemchanged;String s_cod, s_nam1, s_nam2, ls_buncd
Long   i_rtn

s_cod = Trim(this.getText())

if this.GetColumnName() = "syear" then 	
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod + '0101') = -1 then
		f_message_chk(35, "[기준년도]")
		this.object.syear[1] = ""
		return 1
	end if
end if
end event

type dw_list from w_standard_print`dw_list within w_qct_05510
integer x = 91
integer y = 268
integer width = 4489
integer height = 2056
string dataobject = "d_qct_05510"
boolean border = false
end type

event dw_list::retrievestart;This.SetRedraw(False)
end event

event dw_list::retrieveend;This.SetRedraw(True)
end event

type rr_1 from roundrectangle within w_qct_05510
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 82
integer y = 260
integer width = 4517
integer height = 2072
integer cornerheight = 40
integer cornerwidth = 55
end type

