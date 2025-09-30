$PBExportHeader$w_pdt_06530.srw
$PBExportComments$** 설비 점검기준표
forward
global type w_pdt_06530 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdt_06530
end type
end forward

global type w_pdt_06530 from w_standard_print
string title = "정기점검 기록표"
rr_1 rr_1
end type
global w_pdt_06530 w_pdt_06530

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string mchno1, mchno2, sfilter ,ls_gubun, sPrtgb

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

mchno1  = trim(dw_ip.object.mchno1[1])
mchno2  = trim(dw_ip.object.mchno2[1])
sfilter = trim(dw_ip.object.sfilter[1])
sPrtgb  = trim(dw_ip.object.prtgb[1])
ls_gubun = Trim(dw_ip.getitemstring(1,'gubun'))

if (IsNull(mchno1) or mchno1 = "") then mchno1 = "."
if (IsNull(mchno2) or mchno2 = "") then mchno2 = "ZZZZZZ"

if sPrtgb = 'Y' then
	dw_list.dataobject = "d_pdt_06530_05"
	dw_list.settransobject(sqlca)	
	dw_print.dataobject = "d_pdt_06530_05_p"
	dw_print.settransobject(sqlca)	
	ls_gubun = "%"
Else
		if sfilter = '%' then 
			dw_list.dataobject = "d_pdt_06530_02"
			dw_list.settransobject(sqlca)	
			dw_list.SetFilter("")
			dw_print.dataobject = "d_pdt_06530_02_p"
			dw_print.settransobject(sqlca)	
			dw_print.SetFilter("")
			dw_print.filter()
		
		elseif sfilter = '1' then 
			dw_list.dataobject = "d_pdt_06530_02"
			dw_list.settransobject(sqlca)	
			dw_list.SetFilter("mchmst_insp_inspday = '1'")
			dw_print.dataobject = "d_pdt_06530_02_p"
			dw_print.settransobject(sqlca)	
			dw_print.SetFilter("mchmst_insp_inspday = '1'")
			dw_print.filter()
			
		elseif  sfilter = '2' then
			dw_list.dataobject = "d_pdt_06530_02"
			dw_list.settransobject(sqlca)	
			dw_list.SetFilter("mchmst_insp_inspday = '2'")
			dw_print.dataobject = "d_pdt_06530_02_p"
			dw_print.settransobject(sqlca)	
			dw_print.SetFilter("mchmst_insp_inspday = '2'")
			dw_print.filter()
		//else  
		//	dw_list.dataobject = "d_pdt_06530_03" 
		//	dw_list.settransobject(sqlca)
		//	dw_print.dataobject = "d_pdt_06530_03_p" 
		//	dw_print.settransobject(sqlca)	
		end if
End if

if dw_print.Retrieve(gs_sabu, mchno1, mchno2,ls_gubun) <= 0 then
	f_message_chk(50,"[설비 점검 기준표]")
	dw_ip.Setfocus()
	//return -1
	dw_list.insertrow(0)
end if

dw_print.ShareData(dw_list)

return 1
end function

on w_pdt_06530.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdt_06530.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

type p_xls from w_standard_print`p_xls within w_pdt_06530
end type

type p_sort from w_standard_print`p_sort within w_pdt_06530
end type

type p_preview from w_standard_print`p_preview within w_pdt_06530
end type

type p_exit from w_standard_print`p_exit within w_pdt_06530
end type

type p_print from w_standard_print`p_print within w_pdt_06530
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_06530
end type







type st_10 from w_standard_print`st_10 within w_pdt_06530
end type



type dw_print from w_standard_print`dw_print within w_pdt_06530
string dataobject = "d_pdt_06530_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_06530
integer x = 32
integer y = 12
integer width = 2583
integer height = 320
string dataobject = "d_pdt_06530_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String  s_cod, s_nam1, s_nam2
integer i_rtn

s_cod = Trim(this.GetText())

if this.GetColumnName() = "mchno1" then 
	
	if IsNull(s_cod) or s_cod = "" then 
		this.object.mchnam1[1] = ""
		return 
	end if
	
	select mchnam,buncd into :s_nam1,:s_nam2 from mchmst
	 where sabu = :gs_sabu and mchno = :s_cod;
	 
	if sqlca.sqlcode <> 0 then 
	   this.object.mchno1[1] = ""
	   this.object.mchnam1[1] = ""
	   this.object.buncd1[1] = ""
	else
	   this.object.mchno1[1] = s_cod
	   this.object.mchnam1[1] = s_nam1
	   this.object.buncd1[1] = s_nam2
   end if
elseif this.GetColumnName() = "mchno2" then 
	if IsNull(s_cod) or s_cod = "" then 
	   this.object.mchnam2[1] = ""
		return 
	end if
	
	select mchnam,buncd into :s_nam1,:s_nam2 from mchmst
	 where sabu = :gs_sabu and mchno = :s_cod;
	 
	if sqlca.sqlcode <> 0 then 
	   this.object.mchno2[1] = ""
	   this.object.mchnam2[1] = ""
	   this.object.buncd2[1] = ""
	else
	   this.object.mchno2[1] = s_cod
	   this.object.mchnam2[1] = s_nam1
	   this.object.buncd2[1] = s_nam2
   end if
elseif this.GetColumnName() = "buncd1" then 
	if IsNull(s_cod) or s_cod = "" then 
	   this.object.mchno1[1] = ""
	   this.object.mchnam1[1] = ""
		return 
	end if
	
	select mchno,mchnam into :s_nam1,:s_nam2 from mchmst
	 where sabu = :gs_sabu and buncd = :s_cod and rownum < 2;
	 
	if sqlca.sqlcode <> 0 then 
	   this.object.mchno1[1] = ""
	   this.object.mchnam1[1] = ""
	else
	   this.object.mchno1[1] = s_nam1
	   this.object.mchnam1[1] = s_nam2
   end if
	
elseif this.GetColumnName() = "buncd2" then 
	if IsNull(s_cod) or s_cod = "" then 
	   this.object.mchno2[1] = ""
	   this.object.mchnam2[1] = ""
		return 
	end if
	
	select mchno,mchnam into :s_nam1,:s_nam2 from mchmst
	 where sabu = :gs_sabu and buncd = :s_cod and rownum < 2;
	 
	if sqlca.sqlcode <> 0 then 
	   this.object.mchno2[1] = ""
	   this.object.mchnam2[1] = ""
	else
	   this.object.mchno2[1] = s_nam1
	   this.object.mchnam2[1] = s_nam2
   end if
	
end if


end event

event dw_ip::rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

if this.GetColumnName() = "mchno1" then
	gs_gubun = 'ALL'
	open(w_mchno_popup)
	this.object.mchno1[1] = gs_code
	this.object.mchnam1[1] = gs_codename
	return
elseif this.GetColumnName() = "mchno2" then
	gs_gubun = 'ALL'
   open(w_mchno_popup)
	this.object.mchno2[1] = gs_code
	this.object.mchnam2[1] = gs_codename
	return
end if	
end event

type dw_list from w_standard_print`dw_list within w_pdt_06530
integer x = 50
integer y = 348
integer width = 4553
string dataobject = "d_pdt_06530_02"
boolean border = false
end type

type rr_1 from roundrectangle within w_pdt_06530
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 336
integer width = 4585
integer height = 1936
integer cornerheight = 40
integer cornerwidth = 55
end type

