$PBExportHeader$w_qct_05050.srw
$PBExportComments$계측기 지급이력 현황
forward
global type w_qct_05050 from w_standard_print
end type
end forward

global type w_qct_05050 from w_standard_print
string title = "계측기 지급이력 현황"
end type
global w_qct_05050 w_qct_05050

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string  ls_sdate, ls_edate, ls_buncd, ls_buncd1, ls_deptcd, ls_deptcd1, gu_sdate, gu_edate, sgubun
string  ls_smchno,ls_emchno
if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

ls_buncd  = trim(dw_ip.object.buncd[1])
ls_buncd1 = trim(dw_ip.object.buncd1[1])
ls_deptcd = trim(dw_ip.object.deptcd[1])
ls_deptcd1 = trim(dw_ip.object.deptcd1[1])
gu_sdate  = trim(dw_ip.object.gu_sdate[1])
gu_edate  = trim(dw_ip.object.gu_edate[1])
ls_sdate  = trim(dw_ip.object.sdate[1])
ls_edate  = trim(dw_ip.object.edate[1])
ls_smchno = trim(dw_ip.object.smchno[1])
ls_emchno = trim(dw_ip.object.emchno[1])
//sDept     = trim(dw_ip.object.deptcd[1])
sGubun    = dw_ip.object.gub[1]
//buncd     = trim(dw_ip.object.buncd[1])

if IsNull(ls_smchno) or ls_smchno = "" then ls_smchno = '.'
if IsNull(ls_emchno) or ls_emchno = "" then ls_emchno = 'zzzzzzzzzzzzz'
if IsNull(ls_deptcd) or ls_deptcd = "" then ls_deptcd = ' '
if IsNull(ls_deptcd1) or ls_deptcd1 = "" then ls_deptcd1 = 'zzzzzz'
if IsNull(gu_sdate) or gu_sdate = "" then gu_sdate = '10000101'
if IsNull(gu_edate) or gu_edate = "" then gu_edate = '99991231'
if IsNull(ls_sdate) or ls_sdate = "" then ls_sdate = '10000101'
if IsNull(ls_edate) or ls_edate = "" then ls_edate = '99991231'


string dwfilter1, dwfilter2, dwfilter3
dwfilter1 = "gubun = '1' AND deptcd >= '"+ ls_deptcd + "' and  deptcd <= '" + ls_deptcd1 + "'" 
dwfilter2 = "gubun = '2' AND deptcd >= '"+ ls_deptcd + "' and  deptcd <= '" + ls_deptcd1 + "'" 
dwfilter3 = "deptcd >= '"+ ls_deptcd + "' and  deptcd <= '" + ls_deptcd1 + "'"

//dw_list.setredraw(false)
if sGubun = '1' then 
	dw_list.SetFilter(dwfilter1)
elseif sGubun = '2' then 
	dw_list.SetFilter(dwfilter2)
else
	dw_list.SetFilter(dwfilter3)
end if
dw_list.Filter()
//


//if ls_deptcd='.' and ls_deptcd1 = "zzzzzz" then 
//	dw_list.setfilter("")  
//else		
//	dw_list.setfilter(dwfilter2)  
//end if
//dw_list.filter()
//
//dw_list.setredraw(false)
//if sGubun = '1' then 
//	dw_list.SetFilter("gubun = '1'")
//elseif sGubun = '2' then 
//	dw_list.SetFilter("gubun = '2'")
//else
//	dw_list.SetFilter("")
//end if
//dw_list.Filter()

//if dw_list.Retrieve(gs_sabu, ls_buncd, ls_buncd1, gu_sdate, gu_edate, ls_sdate, ls_edate ) <= 0 then
//	f_message_chk(50,"[계측기 지급이력 현황]")
//	dw_ip.Setfocus()
//	dw_list.setredraw(true)
//	return -1
//end if
//dw_list.setredraw(true)

IF dw_print.Retrieve(gs_sabu, ls_smchno, ls_emchno, gu_sdate, gu_edate, ls_sdate, ls_edate ) <= 0 then
	f_message_chk(50,"[계측기 지급이력 현황]")
	dw_list.Reset()
	dw_ip.SetFocus()
	dw_list.SetRedraw(true)
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

return 1

end function

on w_qct_05050.create
call super::create
end on

on w_qct_05050.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type p_xls from w_standard_print`p_xls within w_qct_05050
end type

type p_sort from w_standard_print`p_sort within w_qct_05050
end type

type p_preview from w_standard_print`p_preview within w_qct_05050
end type

type p_exit from w_standard_print`p_exit within w_qct_05050
end type

type p_print from w_standard_print`p_print within w_qct_05050
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_05050
end type







type st_10 from w_standard_print`st_10 within w_qct_05050
end type



type dw_print from w_standard_print`dw_print within w_qct_05050
string dataobject = "d_qct_05050_02"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_05050
integer x = 37
integer y = 36
integer width = 3538
integer height = 288
string dataobject = "d_qct_05050_01"
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
	this.SetItem(1, "deptnm", gs_codename)
	
ELSEIF this.getcolumnname() = "deptcd1" THEN		
	open( w_vndmst_4_popup ) 
	if gs_code = '' or isnull(gs_code) then return 
	this.SetItem(1, "deptcd1", gs_code)
	this.SetItem(1, "deptnm1", gs_codename)
end if
	
//elseIF this.getcolumnname() = "smchno" THEN		
//	open(w_mchno_popup)
//	if gs_code = '' or isnull(gs_code) then return 
//	this.SetItem(1, "smchno", gs_code)
//	this.SetItem(1, "smchnam", gs_codename)
//ELSEIF this.getcolumnname() = "emchno" THEN		
//	open(w_mchno_popup)
//	if gs_code = '' or isnull(gs_code) then return 
//	this.SetItem(1, "emchno", gs_code)
//	this.SetItem(1, "emchnam", gs_codename)
//
//
//elseif this.GetColumnName() = "buncd" then
//	gs_gubun = 'Y'
//	open(w_mittyp_popup)
//	if isnull(gs_code) or gs_code = '' then return
//	this.object.buncd[1] = gs_code
//	this.object.bunnam[1] = gs_codename
//END IF
//
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
//		return 2 
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
//		f_message_chk(33, '[분류코드]')
//      		setitem(1 , "buncd1", '')
//		return 2 
//	end if
	
if this.getcolumnname() = "deptcd" then //시작 사용부서 
	ireturn = f_get_name2('부서','Y', s_cod, s_nam, ls_mchnam)
	this.setitem(1, "deptcd", s_cod)
	this.setitem(1, "deptnm", s_nam)
	return ireturn
elseif this.getcolumnname() = "deptcd1" then //끝 사용부서 
	ireturn = f_get_name2('부서','Y', s_cod, s_nam, ls_mchnam)
	this.setitem(1, "deptcd1", s_cod)
	this.setitem(1, "deptnm1", s_nam)
	return ireturn	
	
elseif this.GetColumnName() = "gu_sdate" then 
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod ) = -1 then
		f_message_chk(35,"[구입일자]")
		this.object.gu_sdate[1] = ""
		return 1
	end if	
elseif this.GetColumnName() = "gu_edate" then 
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35,"[구입일자]")
		this.object.gu_edate[1] = ""
		return 1 
	end if	

elseif this.GetColumnName() = "sdate" then 
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
//	
//	this.setitem(1,"emchnam", ls_mchnam ) 	
//	
//elseif this.GetColumnName() = "buncd" then    // 분류코드
//	if IsNull(s_cod) or s_cod = "" then 
//		setitem( 1, 'bunnam' , "" ) 
//		return
//	end if
//		
//	SELECT bunnam  
//	INTO :ls_bunnam
//   FROM MITNCT
//	WHERE KEGBN = 'Y'
//	AND   BUNCD = :s_cod ; 
//	
//	if sqlca.sqlcode <> 0  then
//		f_message_chk(33, '[분류코드]')
//		setitem(1 , "buncd", '')
//		setitem(1 , "bunnam", '')
//		return 2 
//	else
//		setitem( 1 ,"bunnam" , ls_bunnam )
//	end if 
//end if
//

end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_qct_05050
string dataobject = "d_qct_05050_02"
end type

