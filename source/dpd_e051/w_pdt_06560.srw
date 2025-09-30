$PBExportHeader$w_pdt_06560.srw
$PBExportComments$설비 정기점검/수리 결과서(월간)
forward
global type w_pdt_06560 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdt_06560
end type
end forward

global type w_pdt_06560 from w_standard_print
string title = "설비 정기점검/수리 결과서(월간)"
rr_1 rr_1
end type
global w_pdt_06560 w_pdt_06560

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ym, mchno1, mchno2, ls_dptno 

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

ym = Trim(dw_ip.object.ym[1])
ls_dptno = dw_ip.object.sdptno[1]

if IsNULL(ls_dptno) or ls_dptno="" then ls_dptno = '%' 

if dw_print.Retrieve(gs_sabu, ym, ls_dptno) <= 0 then
	f_message_chk(50, "")
	dw_ip.Setfocus()
	return -1
end if

dw_print.sharedata(dw_list)

return 1
end function

on w_pdt_06560.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdt_06560.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

type p_preview from w_standard_print`p_preview within w_pdt_06560
end type

type p_exit from w_standard_print`p_exit within w_pdt_06560
end type

type p_print from w_standard_print`p_print within w_pdt_06560
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_06560
end type







type st_10 from w_standard_print`st_10 within w_pdt_06560
end type



type dw_print from w_standard_print`dw_print within w_pdt_06560
string dataobject = "d_pdt_06560_02_P"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_06560
integer x = 46
integer y = 24
integer width = 2103
integer height = 232
string dataobject = "d_pdt_06560_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;call super::itemchanged;String  s_cod, s_nam1 , s_nam2
integer i_rtn

s_cod = Trim(this.getText())

if this.GetColumnName() = "ym" then 	
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod + '01') = -1 then
		f_message_chk(35, "[기준년월]")
		this.object.ym[1] = ""
		return 1
	end if	
	
elseif this.getcolumnname() = 'sdptno' then //거래처코드(FROM)  
	i_rtn = f_get_name2("부서", "Y", s_cod, s_nam1, s_nam2)
	this.object.sdptno[1] = s_cod
	this.object.sdptnam[1] = s_nam1
	return i_rtn
	
elseif this.getcolumnname() = 'gubun' then
	
	dw_list.setredraw(false)
	
	if s_cod = '2' then    //정기정검 
		dw_list.dataobject = 'd_pdt_06560_02'
		dw_print.dataobject = 'd_pdt_06560_02_p'
//	elseif s_cod = '3' then // 주유정검 
//		dw_list.dataobject = 'd_pdt_06560_03'
//		dw_print.dataobject = 'd_pdt_06560_03_p'
	elseif s_cod = '4' then // 수리 
		dw_list.dataobject = 'd_pdt_06560_04'
		dw_print.dataobject = 'd_pdt_06560_04_p'
	end if
	
	dw_list.Settransobject(sqlca)
	dw_print.Settransobject(sqlca)	
	dw_print.ShareData(dw_list)	
	
	dw_list.setredraw(true)
	
end if	
	
//elseif this.GetColumnName() = "mchno1" then 
//	if IsNull(s_cod) or s_cod = "" then 
//		this.object.mchnam1[1] = ""
//		return 
//	end if
//	
//	select mchnam into :s_nam1 from mchmst
//	 where sabu = :gs_sabu and mchno = :s_cod;
//	 
//	if sqlca.sqlcode <> 0 then 
//	   this.object.mchno1[1] = ""
//	   this.object.mchnam1[1] = ""
//	else
//	   this.object.mchno1[1] = s_cod
//	   this.object.mchnam1[1] = s_nam1
//   end if
//elseif this.GetColumnName() = "mchno2" then 
//	if IsNull(s_cod) or s_cod = "" then 
//		this.object.mchnam2[1] = ""
//		return 
//	end if
//	
//	select mchnam into :s_nam1 from mchmst
//	 where sabu = :gs_sabu and mchno = :s_cod;
//	 
//	if sqlca.sqlcode <> 0 then 
//	   this.object.mchno2[1] = ""
//	   this.object.mchnam2[1] = ""
//	else
//	   this.object.mchno2[1] = s_cod
//	   this.object.mchnam2[1] = s_nam1
//   end if
//end if
//
//
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

IF this.getcolumnname() = "sdptno"	THEN //거래처코드(FROM)		
	open(w_vndmst_4_popup)
	if gs_code = '' or isnull(gs_code) then return 
   this.SetItem(row, "sdptno", gs_code)
	this.SetItem(row, "sdptnam", gs_codename)
END IF

//
//if this.GetColumnName() = "mchno1" then
//	open(w_mchno_popup)
//	if gs_code = '' or isnull(gs_code) then return 
//	this.object.mchno1[1] = gs_code
//	this.object.mchnam1[1] = gs_codename
//elseif this.GetColumnName() = "mchno2" then
//   open(w_mchno_popup)
//	if gs_code = '' or isnull(gs_code) then return 
//	this.object.mchno2[1] = gs_code
//	this.object.mchnam2[1] = gs_codename
//end if
end event

type dw_list from w_standard_print`dw_list within w_pdt_06560
integer x = 69
integer y = 284
integer width = 4544
integer height = 1956
string dataobject = "d_pdt_06560_02"
boolean border = false
end type

type rr_1 from roundrectangle within w_pdt_06560
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 272
integer width = 4576
integer height = 1988
integer cornerheight = 40
integer cornerwidth = 55
end type

