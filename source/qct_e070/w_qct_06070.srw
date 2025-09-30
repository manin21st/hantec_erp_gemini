$PBExportHeader$w_qct_06070.srw
$PBExportComments$계측기 정기점검/수리 결과서
forward
global type w_qct_06070 from w_standard_print
end type
end forward

global type w_qct_06070 from w_standard_print
string title = "계측기 정기점검/수리 결과서(월간)"
end type
global w_qct_06070 w_qct_06070

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ym, mchno1, mchno2 , ls_gubun , ls_dptno 
Long   i, j, cnt 

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

ym = Trim(dw_ip.object.ym[1])
//ls_gubun = dw_ip.object.gubun[1]
ls_dptno = dw_ip.object.sdptno[1]

if IsNull(ym) or ym = "" then 
	f_message_chk(35, "[기준년월]")
	dw_ip.Setcolumn('ym')
	dw_ip.Setfocus()
	return -1
end if

//if Isnull(ym
//if ls_gubun = '2' then 
//	dw_list.object.txt_title.text = "( " + String(ym,"@@@@年@@月") + " ) 설비 정기 점검 결과서"
//elseif ls_gubun = '3' then 
//	dw_list.object.txt_title.text = "( " + String(ym,"@@@@年@@月") + " ) 설비 주유 점검 결과서"
//else
//	dw_list.object.txt_title.text = "( " + String(ym,"@@@@年@@月") + " ) 설비 수리 결과서"
//end if

if IsNULL(ls_dptno) or ls_dptno="" then
	dw_list.setfilter("")
else
	string dwfilter2
   
	dwfilter2 = "deptcd = '"+ ls_dptno +" '"  
		
	dw_list.setfilter(dwfilter2)  
		
	dw_list.filter()
end if
	
//if dw_list.Retrieve(gs_sabu, ym) <= 0 then
//	f_message_chk(50, "")
//	dw_ip.Setfocus()
//	return -1
//end if

IF dw_print.Retrieve(gs_sabu, ym) <= 0 then
	f_message_chk(50,"[계측기 정기점검/수리 결과서]")
	dw_list.Reset()
	dw_ip.SetFocus()
	dw_list.SetRedraw(true)
	dw_print.insertrow(0)
//	Return -1
END IF

if ls_gubun = '2' then 
	dw_print.object.txt_title.text = "( " + String(ym,"@@@@年@@月") + " ) 설비 정기 점검 결과서"
elseif ls_gubun = '3' then 
	dw_print.object.txt_title.text = "( " + String(ym,"@@@@年@@月") + " ) 설비 주유 점검 결과서"
else
	dw_print.object.txt_title.text = "( " + String(ym,"@@@@年@@月") + " ) 설비 수리 결과서"
end if
dw_print.ShareData(dw_list)

//설비번호별 항번
//cnt = 1
//mchno1 = dw_list.object.mchrsl_mchno[1]
//dw_list.object.cnt[1] = cnt
//for i = 2 to dw_list.RowCount()
//	mchno2 = dw_list.object.mchrsl_mchno[i]			
//	if mchno1 <> mchno2 then 
//		cnt++
//	   mchno1 = mchno2
//	end if	
//	dw_list.object.cnt[i] = cnt	
//next

//Page당 37개의 설비 출력 가능
//j = Mod(dw_list.RowCount(), 37)
//for i = 37 to j step -1
//	dw_list.InsertRow(0)
//next
//
return 1
end function

on w_qct_06070.create
call super::create
end on

on w_qct_06070.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type p_preview from w_standard_print`p_preview within w_qct_06070
end type

type p_exit from w_standard_print`p_exit within w_qct_06070
end type

type p_print from w_standard_print`p_print within w_qct_06070
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_06070
end type







type st_10 from w_standard_print`st_10 within w_qct_06070
end type



type dw_print from w_standard_print`dw_print within w_qct_06070
string dataobject = "d_qct_06070_02"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_06070
integer x = 27
integer y = 0
integer width = 1417
integer height = 256
string dataobject = "d_qct_06070_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String  s_cod, s_nam1 , s_nam2
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
	i_rtn = f_get_name2("부서 ", "N", s_cod, s_nam1, s_nam2)
	this.object.sdptno[1] = s_cod
	this.object.sdptnam[1] = s_nam1
	return i_rtn
	
elseif this.getcolumnname() = 'gubun' then
	
	dw_list.setredraw(false)
	
	if s_cod = '2' then    //정기정검 
		dw_list.dataobject = 'd_qct_06070_02'
		dw_print.dataobject = 'd_qct_06070_02'
//	elseif s_cod = '3' then // 주유정검 
//		dw_list.dataobject = 'd_qct_06070_03'
	elseif s_cod = '4' then // 수리 
		dw_list.dataobject = 'd_qct_06070_04'
		dw_print.dataobject = 'd_qct_06070_04'
	end if
	
	dw_list.setredraw(true)
	
end if	
	
dw_list.Settransobject(sqlca)
dw_print.Settransobject(sqlca)
	
//elseif this.GetColumnName() = "mchno1" then 
//	if IsNull(s_cod) or s_cod = "" then 
//		this.object.mchnam1[1] = ""
//		return 
//	end if
//	
//	select mchnam into :s_nam1 from mchmst
//	 where sabu = :gs_saupj and mchno = :s_cod;
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
//	 where sabu = :gs_saupj and mchno = :s_cod;
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

type dw_list from w_standard_print`dw_list within w_qct_06070
integer x = 0
integer y = 280
string dataobject = "d_qct_06070_02"
end type

