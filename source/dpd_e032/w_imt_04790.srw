$PBExportHeader$w_imt_04790.srw
$PBExportComments$금형/치공구 지급이력 현황
forward
global type w_imt_04790 from w_standard_print
end type
end forward

global type w_imt_04790 from w_standard_print
boolean TitleBar=true
string Title="금형/치공구 지급이력 현황"
end type
global w_imt_04790 w_imt_04790

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string  ls_sdate, ls_edate, ls_skumno, ls_ekumno, sDept, sGubun  

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

ls_sdate  = trim(dw_ip.object.sdate[1])
ls_edate  = trim(dw_ip.object.edate[1])
ls_skumno = trim(dw_ip.object.skumno[1])
ls_ekumno = trim(dw_ip.object.ekumno[1])
sDept     = trim(dw_ip.object.deptcd[1])
sGubun    = dw_ip.object.gub[1]

if IsNull(ls_sdate) or ls_sdate = "" then ls_sdate = '10000101'
if IsNUll(ls_edate) or ls_edate = "" then ls_edate = '99991231'
if IsNull(ls_skumno) or ls_skumno = "" then ls_skumno = "."
if IsNull(ls_ekumno) or ls_ekumno = "" then ls_ekumno = "zzzzzzz"
if IsNull(sDept) or sDept = "" then sDept = "%"

dw_list.setredraw(false)
if sGubun = '1' then 
	dw_list.SetFilter("gubun = '1'")
elseif sGubun = '2' then 
	dw_list.SetFilter("gubun = '2'")
else
	dw_list.SetFilter("")
end if
dw_list.Filter()

if dw_list.Retrieve(gs_sabu, ls_sdate, ls_edate, ls_skumno, ls_ekumno, sDept) <= 0 then
	f_message_chk(50,"[금형/치공구 지급이력 현황]")
	dw_ip.Setfocus()
	dw_list.setredraw(true)
	return -1
end if
dw_list.setredraw(true)

return 1

end function

on w_imt_04790.create
call super::create
end on

on w_imt_04790.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_ip from w_standard_print`dw_ip within w_imt_04790
int X=37
int Y=96
int Width=741
int Height=1156
string DataObject="d_imt_04790_01"
end type

event dw_ip::rbuttondown;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

IF	this.getcolumnname() = "skumno" THEN
	
	OPEN(w_imt_04630_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.SetItem(1, "skumno", gs_code)
	this.SetItem(1, "skumname", gs_codename)
ELSEIF this.getcolumnname() = "ekumno" THEN		
	open(w_imt_04630_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.SetItem(1, "ekumno", gs_code)
	this.SetItem(1, "ekumname", gs_codename)
ELSEIF this.getcolumnname() = "deptcd" THEN		
	open( w_vndmst_4_popup ) 
	if gs_code = '' or isnull(gs_code) then return 
	this.SetItem(1, "deptcd", gs_code)
	this.SetItem(1, "deptnm", gs_codename)
END IF



end event

event dw_ip::itemchanged;String  s_cod, s_nam, ls_kumname, snull
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
	
elseif this.GetColumnName() = "skumno" then // 시작 번호  
	
 	if IsNull(s_cod) or s_cod = ""  then
		this.object.skumname[1] = ""
		return 
	end if
	
	select kumname 
	  into :ls_kumname
  	  from kummst
	 where sabu = :gs_sabu and kumno = :s_cod ;
	
	if sqlca.sqlcode <> 0 then
		f_message_chk(33, '[금형/계측기 번호]')
		this.setitem(1,"skumno", snull )
		this.setitem(1,"skumname", snull)
		return 1
	end if
	
	this.setitem(1,"skumname", ls_kumname ) 
	
elseif this.GetColumnName() = "ekumno" then // 끝 번호  
	
 	if IsNull(s_cod) or s_cod = ""  then
		this.object.ekumname[1] = ""
		return 
	end if
	
	select kumname 
	  into :ls_kumname
  	  from kummst
	 where sabu = :gs_sabu and kumno = :s_cod ;
	
	if sqlca.sqlcode <> 0 then
		f_message_chk(33, '[금형/치공구 번호]')
		this.setitem(1,"ekumno", snull)
		this.setitem(1,"ekumname", snull)
		return 1
	end if
	
	this.setitem(1,"ekumname", ls_kumname ) 	
elseif this.getcolumnname() = "deptcd" then //의뢰부서 
	ireturn = f_get_name2('부서','Y', s_cod, s_nam, ls_kumname)
	this.setitem(1, "deptcd", s_cod)
	this.setitem(1, "deptnm", s_nam)
	return ireturn
end if

end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_imt_04790
int X=818
string DataObject="d_imt_04790_02"
end type

