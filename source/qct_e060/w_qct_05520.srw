$PBExportHeader$w_qct_05520.srw
$PBExportComments$설비별 검교정 이력 현황
forward
global type w_qct_05520 from w_standard_print
end type
type rr_1 from roundrectangle within w_qct_05520
end type
end forward

global type w_qct_05520 from w_standard_print
string title = "계측기별 교정 이력 현황"
rr_1 rr_1
end type
global w_qct_05520 w_qct_05520

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ar_frdate, ar_todate, ar_frdept, ar_todept, ar_silgu, buncd,  buncd1, ar_gikwan
string tx_frdeptnm, tx_todeptnm

//////////////////////////////////////////////////////////////////
if dw_ip.accepttext() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

ar_frdate  = Trim(dw_ip.GetItemString(1,'frdate'))
IF	IsNull(ar_frdate) or ar_frdate = '' then ar_frdate = "11110101" 

ar_todate  = Trim(dw_ip.GetItemString(1,'todate'))
IF	IsNull(ar_todate) or ar_todate = '' then ar_todate = "99991231"

//ar_frdept  = Trim(dw_ip.GetItemString(1,'frdept'))
//ar_todept  = Trim(dw_ip.GetItemString(1,'todept'))

//tx_frdeptnm  = Trim(dw_ip.GetItemString(1,'frdeptnm'))
//tx_todeptnm  = Trim(dw_ip.GetItemString(1,'todeptnm'))
//
//If IsNull(ar_frdept) Or ar_frdept = '' Then ar_frdept = "."
//If IsNull(ar_todept) Or ar_todept = ''  Then ar_todept = "ZZZZZZ"

ar_silgu   = Trim(dw_ip.GetItemString(1,'silgu'))
If IsNull(ar_silgu) or ar_silgu = '' Then 
	ar_silgu = '%'  
else
	ar_silgu = 	ar_silgu + '%'
end if

buncd  = trim(dw_ip.object.buncd[1])
buncd1 = trim(dw_ip.object.buncd1[1])

if (IsNull(buncd) or buncd = "" ) then buncd = '.'
if (IsNull(buncd1) or buncd1 = "" ) then buncd1 = 'zzzzzzzzzzzzz' 

ar_gikwan = trim(dw_ip.object.gikwan[1])
if (IsNull(ar_gikwan) or ar_gikwan = "" ) then ar_gikwan = '%' 

////if IsNull(tx_frdeptnm) or tx_frdeptnm = "" then tx_frdeptnm  = " "
////if IsNull(tx_todeptnm) or tx_todeptnm = "" then tx_todeptnm  = " "
////
////dw_list.Object.tx_deptnm.Text = tx_frdeptnm + ' - '  + tx_todeptnm
//if dw_list.retrieve(gs_sabu, ar_frdate, ar_todate, ar_silgu, buncd, buncd1) <= 0	then
//	f_message_chk(50,"[계측기별 교정 이력 현황]")
//	dw_ip.Setfocus()
//	return -1
//end if

IF dw_print.retrieve(gs_sabu, ar_frdate, ar_todate, ar_silgu, buncd, buncd1, ar_gikwan) <= 0	then
	f_message_chk(50,"[계측기별 교정 이력 현황]")
	dw_list.Reset()
	dw_ip.SetFocus()
	dw_list.SetRedraw(true)
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

Return 1

end function

on w_qct_05520.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_qct_05520.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 가로방향"
end event

type p_preview from w_standard_print`p_preview within w_qct_05520
end type

type p_exit from w_standard_print`p_exit within w_qct_05520
end type

type p_print from w_standard_print`p_print within w_qct_05520
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_05520
end type







type st_10 from w_standard_print`st_10 within w_qct_05520
end type



type dw_print from w_standard_print`dw_print within w_qct_05520
string dataobject = "d_qct_05520_p"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_05520
integer x = 50
integer y = 24
integer width = 3771
integer height = 220
string dataobject = "d_qct_05520_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;setnull(gs_gubun)
setnull(gs_code)
setnull(gs_codename)

Choose Case GetColumnName()
	Case 'frdept' 
   	OPEN(w_vndmst_4_popup)
		if gs_code = '' or isnull(gs_code) then return 
	   dw_ip.SetItem(1, 'frdept',gs_code)
		dw_ip.SetItem(1,'frdeptnm',gs_codename)
	Case 'todept' 
   	OPEN(w_vndmst_4_popup)
		if gs_code = '' or isnull(gs_code) then return 
	   dw_ip.SetItem(1, 'todept' ,gs_code)
		dw_ip.SetItem(1,'todeptnm',gs_codename)
	Case 'buncd' 
		gs_gubun = 'ALL'
		gs_code = '계측기'
		gs_codename = '계측기관리번호'
		open(w_mchno_popup)
		if isnull(gs_code) or gs_code = '' then return
		this.object.buncd[1] = gs_code	
	Case 'buncd1' 
		gs_gubun = 'ALL'
		gs_code = '계측기'
		gs_codename = '계측기관리번호'
		open(w_mchno_popup)
		if isnull(gs_code) or gs_code = '' then return
		this.object.buncd1[1] = gs_code
End choose

end event

event dw_ip::itemchanged;call super::itemchanged;String s_cod, s_nam1, s_nam2, ls_buncd
Long   i_rtn

s_cod = Trim(this.getText())

if this.GetColumnName() = "frdate" then 	
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[시작일자]")
		this.object.frdate[1] = ""
		return 1
	end if	
elseif this.GetColumnName() = "todate" then 	
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[끝일자]")
		this.object.todate[1] = ""
		return 1
	end if	

//elseif this.GetColumnName() = "frdept" then 	
//	i_rtn = f_get_name2("부서", "N", s_cod, s_nam1, s_nam2)
//	this.object.frdept[1] = s_cod
//	this.object.frdeptnm[1] = s_nam1
//	return i_rtn
//elseif this.GetColumnName() = "todept" then 	
//	i_rtn = f_get_name2("부서", "N", s_cod, s_nam1, s_nam2)
//	this.object.todept[1] = s_cod
//	this.object.todeptnm[1] = s_nam1
//	return i_rtn

end if

return
end event

type dw_list from w_standard_print`dw_list within w_qct_05520
integer x = 64
integer y = 268
integer width = 4517
integer height = 2052
string dataobject = "d_qct_05520"
boolean border = false
end type

event dw_list::retrievestart;This.SetRedraw(False)
end event

event dw_list::retrieveend;This.SetRedraw(True)
end event

type rr_1 from roundrectangle within w_qct_05520
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 264
integer width = 4539
integer height = 2068
integer cornerheight = 40
integer cornerwidth = 55
end type

