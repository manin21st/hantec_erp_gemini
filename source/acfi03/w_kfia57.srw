$PBExportHeader$w_kfia57.srw
$PBExportComments$차입금명세서
forward
global type w_kfia57 from w_standard_print
end type
type rr_1 from roundrectangle within w_kfia57
end type
end forward

global type w_kfia57 from w_standard_print
integer x = 0
integer y = 0
string title = "차입금 명세서 조회 출력"
rr_1 rr_1
end type
global w_kfia57 w_kfia57

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_acc_ymd, ls_pre_mm, ls_bnk_cdf, ls_bnk_cdt, &
       get_code, get_name, snull, get_bnk_cdf, get_bnk_cdt
long ll_row

SetNull(snull)

ll_row = dw_ip.GetRow()

if ll_row < 1 then return -1
if dw_ip.AcceptText() = -1 then return -1

ls_acc_ymd = Trim(dw_ip.GetItemString(ll_row, 'acc_ymd'))   // 기준일자

ls_bnk_cdf = dw_ip.GetItemString(ll_row, 'bnk_cdf')   // 금융기관 범위(FROM)
ls_bnk_cdt = dw_ip.GetItemString(ll_row, 'bnk_cdt')   // 금융기관 범위(TO)

if trim(ls_acc_ymd) = '' or isnull(ls_acc_ymd) then 
	F_MessageChk(1, "[기준일자]")
	dw_ip.SetColumn('acc_ymd')
	dw_ip.SetFocus()
	return -1
else 
	if f_datechk(ls_acc_ymd) = -1 then 
		F_MessageChk(21, "[기준일자]")
		dw_ip.SetColumn('acc_ymd')
		dw_ip.SetFocus()
		return -1		
	end if
end if

if trim(ls_bnk_cdf) = '' or isnull(ls_bnk_cdf) then 	ls_bnk_cdf = '0'
if trim(ls_bnk_cdt) = '' or isnull(ls_bnk_cdt) then ls_bnk_cdt = 'zzzzzz'

ls_pre_mm = mid(ls_acc_ymd, 5, 2)
if ls_pre_mm = '01' then 
	ls_pre_mm = '00'
else
	ls_pre_mm = string(long(ls_pre_mm) - 1, '00')
end if	

dw_print.object.acc_ymd_t.text = left(ls_acc_ymd, 4) + "." + mid(ls_acc_ymd, 5, 2) + &
                            "." + right(ls_acc_ymd, 2)
 
if dw_print.retrieve(ls_acc_ymd, ls_pre_mm, ls_bnk_cdf, ls_bnk_cdt) < 1 then 
	F_MessageChk(14, "")
	dw_list.insertrow(0)
	dw_ip.SetColumn('acc_ymd')
	dw_ip.SetFocus()
	//return -1
end if

dw_print.sharedata(dw_list)

return 1
end function

on w_kfia57.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kfia57.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(dw_ip.GetRow(), 'acc_ymd', f_today())
dw_ip.SetFocus()
end event

type p_xls from w_standard_print`p_xls within w_kfia57
end type

type p_sort from w_standard_print`p_sort within w_kfia57
end type

type p_preview from w_standard_print`p_preview within w_kfia57
end type

type p_exit from w_standard_print`p_exit within w_kfia57
end type

type p_print from w_standard_print`p_print within w_kfia57
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfia57
end type







type st_10 from w_standard_print`st_10 within w_kfia57
end type



type dw_print from w_standard_print`dw_print within w_kfia57
string dataobject = "dw_kfia57_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfia57
integer x = 46
integer y = 12
integer width = 3634
integer height = 200
string dataobject = "dw_kfia57_01"
end type

event dw_ip::itemchanged;string ls_acc_ymd, ls_bnk_cdf, get_code, get_name, snull, ls_bnk_cdt

SetNull(snull)

if this.GetColumnName() ='acc_ymd' then
	ls_acc_ymd = this.GetText()
	if trim(ls_acc_ymd) = '' or isnull(ls_acc_ymd) then
		F_MessageChk(1, "[기준일자]")
		return 1
	else 
		if f_datechk(ls_acc_ymd) = -1 then
			F_MessageChk(21, "[기준일자]")
			return 1
		end if
	end if
end if

if this.GetColumnName() = 'bnk_cdf' then 
	
   ls_bnk_cdf = this.GetText()
	
	if trim(ls_bnk_cdf) = '' or isnull(ls_bnk_cdf) then 
		return 
	else
		SELECT person_cd, person_nm
		 INTO :get_code, :get_name
		FROM kfz04om0_v2
		WHERE person_cd = :ls_bnk_cdf ; 
		if sqlca.sqlcode <> 0 then
//			MessageBox("확 인", "금융기관 코드를 확인하십시오.!!")
//			this.SetItem(this.GetRow(), 'bnk_cdf', snull)
//			this.SetItem(this.GetRow(), 'bnk_nmf', snull)		 
//		   return 1
		else
			this.SetItem(this.GetRow(), 'bnk_nmf', get_name)		 			
		end if
	end if
elseif this.GetColumnName() = 'bnk_cdt' then 
	
   ls_bnk_cdt = this.GetText()
	
	if trim(ls_bnk_cdt) = '' or isnull(ls_bnk_cdt) then 
		return 
	else
		SELECT person_cd, person_nm
		 INTO :get_code, :get_name
		FROM kfz04om0_v2
		WHERE person_cd = :ls_bnk_cdt ; 
		if sqlca.sqlcode <> 0 then
//			MessageBox("확 인", "금융기관 코드를 확인하십시오.!!")
//			this.SetItem(this.GetRow(), 'bnk_cdt', snull)
//			this.SetItem(this.GetRow(), 'bnk_nmt', snull)		 
//		   return 1
		else
			this.SetItem(this.GetRow(), 'bnk_nmt', get_name)
		end if
	end if
end if
end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;SetNUll(lstr_custom.code)
SetNUll(lstr_custom.name)

this.accepttext()

if this.GetColumnName() = 'bnk_cdf' then
	
	lstr_custom.code = this.object.bnk_cdf[1]
	
	OpenWithParm(w_kfz04om0_popup, '2')
	
   this.SetItem(this.GetRow(), 'bnk_cdf', lstr_custom.code)
   this.SetItem(this.GetRow(), 'bnk_nmf', lstr_custom.name)
	
elseif this.GetColumnName() = 'bnk_cdt' then
	
	lstr_custom.code = this.object.bnk_cdt[1]
	
	OpenWithParm(w_kfz04om0_popup, '2')
	
   this.SetItem(this.GetRow(), 'bnk_cdt', lstr_custom.code)
   this.SetItem(this.GetRow(), 'bnk_nmt', lstr_custom.name)
end if
end event

event dw_ip::getfocus;this.AcceptText()
end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_kfia57
integer x = 64
integer y = 220
integer width = 4521
integer height = 1996
string title = "차입금 명세서"
string dataobject = "dw_kfia57_02"
boolean border = false
end type

type rr_1 from roundrectangle within w_kfia57
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 216
integer width = 4553
integer height = 2020
integer cornerheight = 40
integer cornerwidth = 55
end type

