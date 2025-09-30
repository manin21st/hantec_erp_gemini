$PBExportHeader$w_pdt_06565.srw
$PBExportComments$설비 지급 현황
forward
global type w_pdt_06565 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdt_06565
end type
end forward

global type w_pdt_06565 from w_standard_print
string title = "설비 지급이력 현황"
rr_1 rr_1
end type
global w_pdt_06565 w_pdt_06565

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string  ls_sdate, ls_edate, ls_smchno, ls_emchno, sDept, sGubun  , sGrpcod

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

ls_sdate  = trim(dw_ip.object.sdate[1])
ls_edate  = trim(dw_ip.object.edate[1])
ls_smchno = trim(dw_ip.object.smchno[1])
ls_emchno = trim(dw_ip.object.emchno[1])
sDept     = trim(dw_ip.object.deptcd[1])
sGubun    = dw_ip.object.gub[1]
sGrpcod   = dw_ip.object.grpcod[1]

if IsNull(ls_sdate) or ls_sdate = "" then ls_sdate = '10000101'
if IsNUll(ls_edate) or ls_edate = "" then ls_edate = '99991231'
if IsNull(ls_smchno) or ls_smchno = "" then ls_smchno = "."
if IsNull(ls_emchno) or ls_emchno = "" then ls_emchno = "zzzzzz"
if IsNull(sDept) or sDept = "" then sDept = "%"
if IsNull(sGrpcod) or sGrpcod = "" then sGrpcod = "%"

dw_print.setredraw(false)
if sGubun = '1' then 
	dw_print.SetFilter("gubun = '1'")
elseif sGubun = '2' then 
	dw_print.SetFilter("gubun = '2'")
else
	dw_print.SetFilter("")
end if

dw_print.Filter()

if dw_print.Retrieve(gs_sabu, ls_sdate, ls_edate, ls_smchno, ls_emchno, sDept,sGrpcod) <= 0 then
	f_message_chk(50,"[설비 지급이력 현황]")
	dw_ip.Setfocus()
	dw_list.setredraw(true)
	//return -1
	dw_list.insertrow(0)
end if

dw_print.setredraw(true)
dw_print.ShareData(dw_list)

return 1

end function

on w_pdt_06565.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdt_06565.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

type p_preview from w_standard_print`p_preview within w_pdt_06565
end type

type p_exit from w_standard_print`p_exit within w_pdt_06565
end type

type p_print from w_standard_print`p_print within w_pdt_06565
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_06565
end type







type st_10 from w_standard_print`st_10 within w_pdt_06565
end type



type dw_print from w_standard_print`dw_print within w_pdt_06565
string dataobject = "d_pdt_06565_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_06565
integer x = 27
integer y = 20
integer width = 3461
integer height = 248
string dataobject = "d_pdt_06565_01"
end type

event dw_ip::rbuttondown;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

IF	this.getcolumnname() = "smchno" THEN		
	open(w_mchno_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.SetItem(1, "smchno", gs_code)
	this.SetItem(1, "smchnam", gs_codename)
ELSEIF this.getcolumnname() = "emchno" THEN		
	open(w_mchno_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.SetItem(1, "emchno", gs_code)
	this.SetItem(1, "emchnam", gs_codename)
ELSEIF this.getcolumnname() = "deptcd" THEN		
	open( w_vndmst_4_popup ) 
	if gs_code = '' or isnull(gs_code) then return 
	this.SetItem(1, "deptcd", gs_code)
	this.SetItem(1, "deptnm", gs_codename)
END IF

end event

event dw_ip::itemchanged;String  s_cod, s_nam, ls_mchnam, snull
int     ireturn 

setnull(snull)

s_cod = Trim(this.GetText())

if this.GetColumnName() = "sdate" then 
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod ) = -1 then
		f_message_chk(35,"[지급일자]")
		this.object.sdate[1] = ""
		return 1
	end if	
elseif this.GetColumnName() = "edate" then 
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35,"[지급일자]")
		this.object.edate[1] = ""
		return 1 
	end if
	
elseif this.GetColumnName() = "smchno" then // 시작 설비번호  
	
 	if IsNull(s_cod) or s_cod = ""  then
		this.object.smchnam[1] = ""
		return 
	end if
	
	select mchnam 
	  into :ls_mchnam
  	  from mchmst
	 where sabu = :gs_sabu and mchno = :s_cod ;
	
	if sqlca.sqlcode <> 0 then
		f_message_chk(33, '[설비번호]')
		this.setitem(1,"smchno", snull )
		this.setitem(1,"smchnam", snull)
		return 1
	end if
	
	this.setitem(1,"smchnam", ls_mchnam ) 
	
elseif this.GetColumnName() = "emchno" then // 끝 설비번호  
	
 	if IsNull(s_cod) or s_cod = ""  then
		this.object.emchnam[1] = ""
		return 
	end if
	
	select mchnam 
	  into :ls_mchnam
  	  from mchmst
	 where sabu = :gs_sabu and mchno = :s_cod ;
	
	if sqlca.sqlcode <> 0 then
		f_message_chk(33, '[설비번호]')
		this.setitem(1,"emchno", snull)
		this.setitem(1,"emchnam", snull)
		return 1
	end if
	
	this.setitem(1,"emchnam", ls_mchnam ) 	
elseif this.getcolumnname() = "deptcd" then //의뢰부서 
	ireturn = f_get_name2('부서','Y', s_cod, s_nam, ls_mchnam)
	this.setitem(1, "deptcd", s_cod)
	this.setitem(1, "deptnm", s_nam)
	return ireturn
end if

end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_pdt_06565
integer x = 50
integer y = 292
integer width = 4544
integer height = 1944
string dataobject = "d_pdt_06565_02"
boolean border = false
boolean hsplitscroll = false
end type

type rr_1 from roundrectangle within w_pdt_06565
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 276
integer width = 4581
integer height = 1976
integer cornerheight = 40
integer cornerwidth = 55
end type

