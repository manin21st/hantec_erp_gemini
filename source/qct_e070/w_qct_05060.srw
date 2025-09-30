$PBExportHeader$w_qct_05060.srw
$PBExportComments$계측기 폐기현황
forward
global type w_qct_05060 from w_standard_print
end type
end forward

global type w_qct_05060 from w_standard_print
string title = "계측기 폐기현황"
end type
global w_qct_05060 w_qct_05060

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string  ls_sdate, ls_edate, ls_buncd, ls_buncd1, ls_deptcd, ls_deptcd1 
string  ls_smchno, ls_emchno
if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

ls_sdate = trim(dw_ip.object.sdate[1])
ls_edate = trim(dw_ip.object.edate[1])
ls_smchno = trim(dw_ip.object.smchno[1])
ls_emchno = trim(dw_ip.object.emchno[1])
ls_deptcd = trim(dw_ip.object.deptcd[1])
ls_deptcd1 = trim(dw_ip.object.deptcd1[1])

if IsNull(ls_sdate) or ls_sdate = "" then ls_sdate = '10000101'
if IsNUll(ls_edate) or ls_edate = "" then ls_edate = '99991231'
if IsNull(ls_smchno) or ls_smchno = "" then ls_smchno = "."
if IsNull(ls_emchno) or ls_emchno = "" then ls_emchno = "zzzzzzzzzzzzz"
if IsNull(ls_deptcd) or ls_deptcd = "" then ls_deptcd = "."
if IsNull(ls_deptcd1) or ls_deptcd1 = "" then ls_deptcd1 = "zzzzzz"

string dwfilter2

dwfilter2 = "deptcd >= '"+ ls_deptcd + "' and  deptcd <= '" + ls_deptcd1 + "'" 

//if dw_list.Retrieve(gs_sabu, ls_sdate, ls_edate, ls_buncd, ls_buncd1 ) <= 0 then
//	f_message_chk(50,"[계측기 폐기 현황]")
//	dw_ip.Setfocus()
//	return -1
//end if

IF dw_print.Retrieve(gs_sabu, ls_sdate, ls_edate, ls_smchno, ls_emchno ) <= 0 then
	f_message_chk(50,"[계측기 폐기 현황]")
	dw_list.Reset()
	dw_ip.SetFocus()
	dw_list.SetRedraw(true)
	dw_print.insertrow(0)
//	Return -1
END IF 

if ls_deptcd='.' and ls_deptcd1 = "zzzzzz" then 
	dw_print.setfilter("")  
else		
	dw_print.setfilter(dwfilter2)  
end if

dw_print.filter()

dw_print.ShareData(dw_list)

return 1
end function

on w_qct_05060.create
call super::create
end on

on w_qct_05060.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type p_xls from w_standard_print`p_xls within w_qct_05060
end type

type p_sort from w_standard_print`p_sort within w_qct_05060
end type

type p_preview from w_standard_print`p_preview within w_qct_05060
end type

type p_exit from w_standard_print`p_exit within w_qct_05060
end type

type p_print from w_standard_print`p_print within w_qct_05060
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_05060
end type







type st_10 from w_standard_print`st_10 within w_qct_05060
end type



type dw_print from w_standard_print`dw_print within w_qct_05060
string dataobject = "d_qct_05060_02"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_05060
integer x = 46
integer y = 24
integer width = 2793
integer height = 308
string dataobject = "d_qct_05060_01"
end type

event dw_ip::rbuttondown;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

if this.GetColumnName() = "smchno" then
//	gs_gubun = 'ALL'
//	gs_code = '계측기'
//	gs_codename = '계측기관리번호'
	open(w_st22_00020_popup)
	if isnull(gs_code) or gs_code = '' then return
	this.setitem(1,"smchno", gs_code)
	this.setitem(1,"smchnam", gs_codename)
	
elseif this.GetColumnName() = "emchno" then
//	gs_gubun = 'ALL'
//	gs_code = '계측기'
//	gs_codename = '계측기관리번호'
	open(w_st22_00020_popup)
	if isnull(gs_code) or gs_code = '' then return
	this.setitem(1,"emchno", gs_code)
	this.setitem(1,"emchnam", gs_codename)
	
ELSEIF this.getcolumnname() = "deptcd" THEN   // 사용부서 		
	open( w_vndmst_4_popup ) 
	if gs_code = '' or isnull(gs_code) then return 
	this.SetItem(1, "deptcd", gs_code)
	this.SetItem(1, "deptnam", gs_codename)
	
ELSEIF this.getcolumnname() = "deptcd1" THEN		
	open( w_vndmst_4_popup ) 
	if gs_code = '' or isnull(gs_code) then return 
	this.SetItem(1, "deptcd1", gs_code)
	this.SetItem(1, "deptnam1", gs_codename)
end if
end event

event dw_ip::itemchanged;String  s_cod, s_nam, ls_mchnam, snull, ls_buncd
int     ireturn 

setnull(snull)

s_cod = Trim(this.GetText())

//if this.GetColumnName() = "buncd" then    // 계측기 관리번호
//	if IsNull(s_cod) or s_cod = "" then return 
//		
//	SELECT buncd   
//	INTO :ls_buncd
//   FROM mchmst
//	WHERE KEGBN = 'Y'
//	AND   BUNCD = :s_cod ; 
//	
//	if sqlca.sqlcode <> 0  then
//		f_message_chk(33, '[계측기관리번호]')
//      setitem(1 , "buncd", '')
//		return 1 
//	end if
//
//elseif this.GetColumnName() = "buncd1" then    // 계측기 관리번호
//	if IsNull(s_cod) or s_cod = "" then return 
//		
//	SELECT buncd   
//	INTO :ls_buncd
//	FROM mchmst
//	WHERE KEGBN = 'Y'
//	AND   BUNCD = :s_cod ; 
//	
//	if sqlca.sqlcode <> 0  then
//		f_message_chk(33, '[계측기관리번호]')
//   	setitem(1 , "buncd1", '')
//		return 1
//	end if
	
if this.getcolumnname() = "deptcd" then //시작 사용부서 
	ireturn = f_get_name2('부서','Y', s_cod, s_nam, ls_mchnam)
	this.setitem(1, "deptcd", s_cod)
	this.setitem(1, "deptnam", s_nam)
	return ireturn
elseif this.getcolumnname() = "deptcd1" then //끝 사용부서 
	ireturn = f_get_name2('부서','Y', s_cod, s_nam, ls_mchnam)
	this.setitem(1, "deptcd1", s_cod)
	this.setitem(1, "deptnam1", s_nam)
	return ireturn	
	
elseif this.GetColumnName() = "sdate" then 
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod ) = -1 then
		f_message_chk(35,"[폐기일자]")
		this.object.sdate[1] = ""
		return 1
	end if	
elseif this.GetColumnName() = "edate" then 
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35,"[폐기일자]")
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
  	  from mesmst
	 where mchno = :s_cod ;
	
	if sqlca.sqlcode <> 0 then
		f_message_chk(33, '[계측기 번호]')
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
  	  from mesmst
	 where mchno = :s_cod ;
	
	if sqlca.sqlcode <> 0 then
		f_message_chk(33, '[계측기 번호]')
		this.setitem(1,"emchno", snull)
		this.setitem(1,"emchnam", snull)
		return 1
	end if
end if
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_qct_05060
string dataobject = "d_qct_05060_02"
end type

