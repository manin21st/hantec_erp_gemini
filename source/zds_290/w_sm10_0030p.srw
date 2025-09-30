$PBExportHeader$w_sm10_0030p.srw
$PBExportComments$HMC VAN 현황
forward
global type w_sm10_0030p from w_standard_print
end type
type p_search from uo_picture within w_sm10_0030p
end type
type p_delrow from uo_picture within w_sm10_0030p
end type
type p_delrow_all from uo_picture within w_sm10_0030p
end type
type pb_1 from u_pb_cal within w_sm10_0030p
end type
type dw_d2 from datawindow within w_sm10_0030p
end type
type dw_d0 from datawindow within w_sm10_0030p
end type
type dw_d68 from datawindow within w_sm10_0030p
end type
type dw_gi from datawindow within w_sm10_0030p
end type
type dw_dh from datawindow within w_sm10_0030p
end type
type dw_p6 from datawindow within w_sm10_0030p
end type
type dw_p7 from datawindow within w_sm10_0030p
end type
type dw_d1 from datawindow within w_sm10_0030p
end type
type dw_d9 from datawindow within w_sm10_0030p
end type
type dw_d3 from datawindow within w_sm10_0030p
end type
type st_state from statictext within w_sm10_0030p
end type
type pb_2 from u_pb_cal within w_sm10_0030p
end type
type dw_d2_detail from datawindow within w_sm10_0030p
end type
type st_caption from statictext within w_sm10_0030p
end type
type rr_1 from roundrectangle within w_sm10_0030p
end type
end forward

global type w_sm10_0030p from w_standard_print
integer width = 4677
integer height = 2516
string title = "KMC VAN 현황(아산)"
p_search p_search
p_delrow p_delrow
p_delrow_all p_delrow_all
pb_1 pb_1
dw_d2 dw_d2
dw_d0 dw_d0
dw_d68 dw_d68
dw_gi dw_gi
dw_dh dw_dh
dw_p6 dw_p6
dw_p7 dw_p7
dw_d1 dw_d1
dw_d9 dw_d9
dw_d3 dw_d3
st_state st_state
pb_2 pb_2
dw_d2_detail dw_d2_detail
st_caption st_caption
rr_1 rr_1
end type
global w_sm10_0030p w_sm10_0030p

type variables
String is_custid
end variables

forward prototypes
public function integer wf_retrieve ()
public function long wf_van_scan_chk (string arg_value, string arg_value_1)
public function string wf_choose (string as_gubun)
public subroutine wf_error (string as_gubun, long al_line, string as_doccode, string as_factory, string as_itnbr, string as_errtext)
public function double wf_van_scan_chk2 (string arg_gubun, string arg_value, string arg_value_1)
end prototypes

public function integer wf_retrieve ();Long i ,ll_rcnt
String ls_gubun ,ls_saupj , ls_cvcod ,ls_sdate  ,ls_edate, ls_saupj_cust , ls_itnbr_from, ls_itnbr_to
String tx_saupj, ls_factory, ls_from, ls_to
Integer li_no

DataWindow ldw_x

if dw_ip.AcceptText() = -1 then return -1
if dw_ip.rowcount() <= 0 then return -1

ls_gubun = Trim(dw_ip.Object.gubun[1]) 
ls_saupj = Trim(dw_ip.Object.saupj[1])
ls_cvcod = Trim(dw_ip.Object.mcvcod[1])
ls_factory = Trim(dw_ip.Object.factory[1])

IF isNull(ls_factory) OR ls_factory = '.' THEN ls_factory = '%'

ls_itnbr_from = Trim(dw_ip.Object.tx_itnbr_f[1])
IF isNull(ls_itnbr_from) THEN ls_itnbr_from = ''
ls_itnbr_to = Trim(dw_ip.Object.tx_itnbr_t[1])
IF isNull(ls_itnbr_to) THEN ls_itnbr_to = ''

ls_sdate = Trim(dw_ip.Object.jisi_date[1])
ls_edate = Trim(dw_ip.Object.jisi_date2[1])

IF isNull(ls_cvcod) OR ls_cvcod = '' THEN ls_cvcod = '%'

SetNull(ls_saupj_cust)

select fun_get_reffpf_value('AD',:ls_saupj,'4') Into :ls_saupj_cust
  from dual ;
If sqlca.sqlcode <> 0 Or ls_saupj_cust = '' Or isNull(ls_saupj_cust) Then
	MessageBox('확인','사업장을 선택하세요')
	Return -1
End If
	
// 품번 전체를 검색 할 때에 ITEMAS의 최소, 최고 품번을 조회한다.	
IF ls_itnbr_from = '' and ls_itnbr_to = '' THEN	
	SELECT MIN(ITNBR), MAX(ITNBR) 
	INTO   :ls_from, :ls_to
	FROM   ITEMAS;
	
	If sqlca.sqlcode <> 0 Then
		MessageBox('에러','품번마스터를 조회할 수 없습니다.~n전산실에 문의 바랍니다.')
		Return -1
	End If
	li_no = 1
ELSE
	ls_from = ls_itnbr_from
	ls_to = ls_itnbr_to
	li_no = 2
END IF

Choose Case ls_gubun 
	Case 'D0'
		ldw_x = dw_d0
		dw_print.DataObject = "d_sm10_p0030_d0_p"
	Case 'D2'
		//ldw_x = dw_d2
		ldw_x = dw_list
		dw_print.DataObject = "d_sm10_p0030_d2_p"
	Case 'D6'
		ldw_x = dw_d68
		dw_print.DataObject = "d_sm10_p0030_d6_p"
	Case 'D8'
		ldw_x = dw_d68
		dw_print.DataObject = "d_sm10_p0030_d8_p"
	Case 'GI'
		ldw_x = dw_gi
		dw_print.DataObject = "d_sm10_p0030_gi_p"
	Case 'DH'
		ldw_x = dw_dh
		dw_print.DataObject = "d_sm10_p0030_dh_p"
	Case 'P6'
		ldw_x = dw_p6
		dw_print.DataObject = "d_sm10_p0030_p6_p"
	Case 'P7'
		ldw_x = dw_p7
		dw_print.DataObject = "d_sm10_p0030_p7_p"
	Case 'D1'
		ldw_x = dw_d1
		dw_print.DataObject = "d_sm10_p0030_d1_p"
	Case 'D9'
		ldw_x = dw_d9
		dw_print.DataObject = "d_sm10_p0030_d9_p"
	Case 'D3'
		ldw_x = dw_d3		
		dw_print.DataObject = "d_sm10_p0030_d3_p"
End Choose

dw_print.SetTransObject(SQLCA)

//MessageBox('' , ls_saupj_cust +'|'+ ls_gubun +ls_sdate  +'|'+ ls_gubun+ls_edate +'|'+  ls_cvcod +'|'+  ls_from +'|'+  ls_to +'|'+  '%'+ls_factory +'|'+  string(li_no ))

IF ldw_x.Retrieve(ls_saupj_cust , ls_gubun+ls_sdate ,ls_gubun+ls_edate, ls_cvcod, ls_from, ls_to, '%'+ls_factory, li_no ) <=0 THEN
	f_message_chk(50,"")
	p_xls.enabled = False
	p_preview.enabled = False	
	
	p_xls.picturename = "c:\erpman\image\엑셀변환_d.gif"
	p_preview.picturename = "c:\erpman\image\미리보기_d.gif"
	Return -1
END IF
	
IF dw_print.Retrieve(ls_saupj_cust , ls_gubun+ls_sdate ,ls_gubun+ls_edate, ls_cvcod, ls_from, ls_to, '%'+ls_factory, li_no) <=0 THEN
	f_message_chk(50,"")
	p_xls.enabled = False
	p_preview.enabled = False	
	
	p_xls.picturename = "c:\erpman\image\엑셀변환_d.gif"
	p_preview.picturename = "c:\erpman\image\미리보기_d.gif"
	Return -1
END IF

	p_print.enabled = True
	p_preview.enabled = True	
	
	p_print.picturename = "c:\erpman\image\엑셀변환_up.gif"
	p_preview.picturename = "c:\erpman\image\미리보기_up.gif"
	
	ldw_x.sharedata(dw_print)
	
	//Report   검색조건 값 Display
	dw_print.Modify("t_sdate.text = '"+String(ls_sdate,'@@@@.@@.@@')+"'")
	dw_print.Modify("t_tdate.text = '"+String(ls_edate,'@@@@.@@.@@')+"'")
	
	tx_saupj = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj)', 1)"))
	If IsNull(tx_saupj) Or tx_saupj = '' Then tx_saupj = '전체'
	dw_print.Modify("tx_saupj.text = '"+tx_saupj+"'")
	dw_print.Modify("tx_itnbr_from.text = '"+ls_itnbr_from+"'")
	dw_print.Modify("tx_itnbr_to.text = '"+ls_itnbr_to+"'")

if ls_factory = '' then 
	dw_print.Modify("tx_factory.text = '전체'")
else
	dw_print.Modify("tx_factory.text = '"+ls_factory+"'")
end if

//IF ls_gubun = 'D2' and ls_cvcod = 'S00100'	THEN
//	dw_print.Modify("t_prev_result.text = 'HMC'")
//	dw_print.Modify("t_cur_stock.text = 'HMC'")
//	dw_print.Modify("t_actual_stock.text = 'HMC'")
//ELSEIF ls_gubun = 'D2' and ls_cvcod = 'S00906'	THEN			
//	dw_print.Modify("t_prev_result.text = 'KMC'")
//	dw_print.Modify("t_cur_stock.text = 'KMC'")
//	dw_print.Modify("t_actual_stock.text = 'KMC'")
//ELSEIF ls_gubun = 'P7' and ls_cvcod = 'S00100'	THEN			
//	dw_print.Modify("t_trim_result.text = 'HMC'")
//ELSEIF ls_gubun = 'P7' and ls_cvcod = 'S00906'	THEN			
//	dw_print.Modify("t_trim_result.text = 'KMC'")
//END IF

Return 1
end function

public function long wf_van_scan_chk (string arg_value, string arg_value_1);//정수형
long ll_asc_value
long ll_return_value

ll_asc_value = asc(arg_value_1)
// 'A' ~ 'I'
if ll_asc_value >= 64 and ll_asc_value <= 73 then
	ll_return_value = long(arg_value) * 10 + ll_asc_value - 64
// 'J' ~ 'R'
elseif ll_asc_value >= 74 and ll_asc_value <= 82 then
	ll_return_value = (long(arg_value) * 10 + ll_asc_value - 73) * -1
// '{'
elseif ll_asc_value = 123 then
	ll_return_value = long(arg_value) * 10
// '}'
elseif ll_asc_value = 125 then
	ll_return_value = long(arg_value) * -10
else
	ll_return_value = long(arg_value) * 10 + long(arg_value_1)
end if
	
return ll_return_value
end function

public function string wf_choose (string as_gubun);//If as_gubun = 'AL' Then
//	Tab_1.Tabpage_2.Enabled = False
//Else
//	Tab_1.Tabpage_2.Enabled = True
//	//Tab_1.SelectedTab = 2
//End IF
//
//Choose Case as_gubun
//	Case 'D0'
//		If Tab_1.SelectedTab = 2 Then
//			dw_d0.x = dw_list.x
//			dw_d0.y = dw_list.y
//			dw_d0.width  = dw_list.width
//			dw_d0.height = dw_list.height
//			
//			dw_list.visible = False
//			
//			dw_d0.visible = True
//			dw_d2.visible = False
//			dw_d68.visible = False
//			dw_gi.visible = False
//			dw_dh.visible = False
//			dw_p6.visible = False
//			dw_p7.visible = False
//			dw_d1.visible = False
//			dw_d9.visible = False
//			dw_d3.visible = False
//		End If
//		return 'C:\HCK\VAN\HKCD0.TXT'
//	Case 'D2'
//		If Tab_1.SelectedTab = 2 Then
//			dw_d2.x = dw_list.x
//			dw_d2.y = dw_list.y
//			dw_d2.width  = dw_list.width
//			dw_d2.height = dw_list.height
//			
//			dw_list.visible = False
//			
//			dw_d0.visible = False
//			dw_d2.visible = True
//			dw_d68.visible = False
//			dw_gi.visible = False
//			dw_dh.visible = False
//			dw_p6.visible = False
//			dw_p7.visible = False
//			dw_d1.visible = False
//			dw_d9.visible = False
//			dw_d3.visible = False
//		End If
//		return 'C:\HCK\VAN\HKCD2.TXT'
//	Case 'D6'
//		If Tab_1.SelectedTab = 2 Then
//			dw_d68.x = dw_list.x
//			dw_d68.y = dw_list.y
//			dw_d68.width  = dw_list.width
//			dw_d68.height = dw_list.height
//			
//			dw_list.visible = False
//			
//			dw_d0.visible = False
//			dw_d2.visible = False
//			dw_d68.visible = True
//			dw_gi.visible = False
//			dw_dh.visible = False
//			dw_p6.visible = False
//			dw_p7.visible = False
//			dw_d1.visible = False
//			dw_d9.visible = False
//			dw_d3.visible = False
//		End if
//		return 'C:\HCK\VAN\HKCD6.TXT'
//	Case 'D8'
//		If Tab_1.SelectedTab = 2 Then
//			dw_d68.x = dw_list.x
//			dw_d68.y = dw_list.y
//			dw_d68.width  = dw_list.width
//			dw_d68.height = dw_list.height
//			
//			dw_list.visible = False
//			
//			dw_d0.visible = False
//			dw_d2.visible = False
//			dw_d68.visible = True
//			dw_gi.visible = False
//			dw_dh.visible = False
//			dw_p6.visible = False
//			dw_p7.visible = False
//			dw_d1.visible = False
//			dw_d9.visible = False
//			dw_d3.visible = False
//		End If
//		return 'C:\HCK\VAN\HKCD8.TXT'	
//	Case 'GI'
//		If Tab_1.SelectedTab = 2 Then
//			dw_gi.x = dw_list.x
//			dw_gi.y = dw_list.y
//			dw_gi.width  = dw_list.width
//			dw_gi.height = dw_list.height
//			dw_list.visible = False
//			
//			dw_d0.visible = False
//			dw_d2.visible = False
//			dw_d68.visible = False
//			dw_gi.visible = True
//			dw_dh.visible = False
//			dw_p6.visible = False
//			dw_p7.visible = False
//			dw_d1.visible = False
//			dw_d9.visible = False
//			dw_d3.visible = False
//		End If
//		return 'C:\HCK\VAN\GINGUB.TXT'
//	Case 'DH'
//		If Tab_1.SelectedTab = 2 Then
//			dw_dh.x = dw_list.x
//			dw_dh.y = dw_list.y
//			dw_dh.width  = dw_list.width
//			dw_dh.height = dw_list.height
//			dw_list.visible = False
//			
//			dw_d0.visible = False
//			dw_d2.visible = False
//			dw_d68.visible = False
//			dw_gi.visible = False
//			dw_dh.visible = True
//			dw_p6.visible = False
//			dw_p7.visible = False
//			dw_d1.visible = False
//			dw_d9.visible = False
//			dw_d3.visible = False
//		End IF
//		return 'C:\HCK\VAN\HKCDH.TXT'
//	Case 'P6'
//		If Tab_1.SelectedTab = 2 Then
//			dw_p6.x = dw_list.x
//			dw_p6.y = dw_list.y
//			dw_p6.width  = dw_list.width
//			dw_p6.height = dw_list.height
//			dw_list.visible = False
//			
//			dw_d0.visible = False
//			dw_d2.visible = False
//			dw_d68.visible = False
//			dw_gi.visible = False
//			dw_dh.visible = False
//			dw_p6.visible = True
//			dw_p7.visible = False
//			dw_d1.visible = False
//			dw_d9.visible = False
//			dw_d3.visible = False
//		End IF
//		return 'C:\HCK\VAN\HKCP6.TXT'
//	Case 'P7'
//		If Tab_1.SelectedTab = 2 Then
//			dw_p7.x = dw_list.x
//			dw_p7.y = dw_list.y
//			dw_p7.width  = dw_list.width
//			dw_p7.height = dw_list.height
//			dw_list.visible = False
//			
//			dw_d0.visible = False
//			dw_d2.visible = False
//			dw_d68.visible = False
//			dw_gi.visible = False
//			dw_dh.visible = False
//			dw_p6.visible = False
//			dw_p7.visible = True
//			dw_d1.visible = False
//			dw_d9.visible = False
//			dw_d3.visible = False
//		End IF
//		return 'C:\HCK\VAN\HKCP7.TXT'
//	Case 'D1'
//		If Tab_1.SelectedTab = 2 Then
//			dw_d1.x = dw_list.x
//			dw_d1.y = dw_list.y
//			dw_d1.width  = dw_list.width
//			dw_d1.height = dw_list.height
//			dw_list.visible = False
//			
//			dw_d0.visible = False
//			dw_d2.visible = False
//			dw_d68.visible = False
//			dw_gi.visible = False
//			dw_dh.visible = False
//			dw_p6.visible = False
//			dw_p7.visible = False
//			dw_d1.visible = True
//			dw_d9.visible = False
//			dw_d3.visible = False
//		End If
//		return 'C:\HCK\VAN\HKCD1.TXT'
//	Case 'D9'
//		If Tab_1.SelectedTab = 2 Then
//			dw_d9.x = dw_list.x
//			dw_d9.y = dw_list.y
//			dw_d9.width  = dw_list.width
//			dw_d9.height = dw_list.height
//			dw_list.visible = False
//			
//			dw_d0.visible = False
//			dw_d2.visible = False
//			dw_d68.visible = False
//			dw_gi.visible = False
//			dw_dh.visible = False
//			dw_p6.visible = False
//			dw_p7.visible = False
//			dw_d1.visible = False
//			dw_d9.visible = True
//			dw_d3.visible = False
//		End If
//		return 'C:\HCK\VAN\HKCD9.TXT'
//	Case 'D3'
//		If Tab_1.SelectedTab = 2 Then
//			dw_d3.x = dw_list.x
//			dw_d3.y = dw_list.y
//			dw_d3.width  = dw_list.width
//			dw_d3.height = dw_list.height
//			dw_list.visible = False
//			
//			dw_d0.visible = False
//			dw_d2.visible = False
//			dw_d68.visible = False
//			dw_gi.visible = False
//			dw_dh.visible = False
//			dw_p6.visible = False
//			dw_p7.visible = False
//			dw_d1.visible = False
//			dw_d9.visible = False
//			dw_d3.visible = True
//		End IF
//		return 'C:\HCK\VAN\HKCD3.TXT'
//	Case Else
//		If Tab_1.SelectedTab = 2 Then
//			Tab_1.SelectedTab = 1
//		End IF
//		dw_d0.visible = False
//		dw_d2.visible = False
//		dw_d68.visible = False
//		dw_gi.visible = False
//		dw_dh.visible = False
//		dw_p6.visible = False
//		dw_p7.visible = False
//		dw_d1.visible = False
//		dw_d9.visible = False
//		dw_d3.visible = False
//		
//		dw_list.visible = True
//
		return 'C:\HCK\VAN'
//		
//End Choose
end function

public subroutine wf_error (string as_gubun, long al_line, string as_doccode, string as_factory, string as_itnbr, string as_errtext);Long ll_r

ll_r = dw_list.InsertRow(0)

dw_list.Object.saupj[ll_r] = Trim(dw_ip.Object.saupj[1])
dw_list.Object.err_date[ll_r] = Trim(dw_ip.Object.jisi_date[1])
dw_list.Object.err_time[ll_r] = f_totime()
dw_list.Object.doctxt[ll_r] = as_gubun
dw_list.Object.err_line[ll_r] = al_line
dw_list.Object.doccode[ll_r] = as_doccode
dw_list.Object.factory[ll_r] = as_factory
dw_list.Object.itnbr[ll_r] = as_itnbr
dw_list.Object.err_txt[ll_r] = as_errtext

dw_list.scrolltorow(ll_r)
end subroutine

public function double wf_van_scan_chk2 (string arg_gubun, string arg_value, string arg_value_1);//정수형
long ll_asc_value
double ld_return_value
if arg_gubun = '1' then
	ll_asc_value = asc(arg_value_1)
	// 'A' ~ 'I'
	if ll_asc_value >= 64 and ll_asc_value <= 73 then
		ld_return_value = double(arg_value) * 10 + ll_asc_value - 64
	// 'J' ~ 'R'
	elseif ll_asc_value >= 74 and ll_asc_value <= 82 then
		ld_return_value = (double(arg_value) * 10 + ll_asc_value - 73) * -1
	// '{'
	elseif ll_asc_value = 123 then
		ld_return_value = double(arg_value) * 10
	// '}'
	elseif ll_asc_value = 125 then
		ld_return_value = double(arg_value) * -10
	else
		ld_return_value = double(arg_value) * 10 + double(arg_value_1)
	end if
//실수형
else 
	ll_asc_value = asc(right(arg_value_1,1))
	// 'A' ~ 'I'
	if ll_asc_value >= 64 and ll_asc_value <= 73 then
		ld_return_value = double(arg_value) + &
								(double(left(arg_value_1,1)) * 0.1) + &
								((ll_asc_value - 64) * 0.01)
	// 'J' ~ 'R'
	elseif ll_asc_value >= 74 and ll_asc_value <= 82 then
		ld_return_value = (double(arg_value) + &
								(double(left(arg_value_1,1)) * 0.1) + &
								((ll_asc_value - 73) * 0.01)) * -1
	// '{'
	elseif ll_asc_value = 123 then
		ld_return_value = (double(arg_value) + &
								(double(left(arg_value_1,1)) * 0.1)) * 1 &
	// '}'
	elseif ll_asc_value = 125 then
		ld_return_value = (double(arg_value) + &
								(double(left(arg_value_1,1)) * 0.1)) * -1  
	else
		ld_return_value = double(arg_value) + (double(arg_value) * 0.01)
	end if
	
end if
	
return ld_return_value
end function

on w_sm10_0030p.create
int iCurrent
call super::create
this.p_search=create p_search
this.p_delrow=create p_delrow
this.p_delrow_all=create p_delrow_all
this.pb_1=create pb_1
this.dw_d2=create dw_d2
this.dw_d0=create dw_d0
this.dw_d68=create dw_d68
this.dw_gi=create dw_gi
this.dw_dh=create dw_dh
this.dw_p6=create dw_p6
this.dw_p7=create dw_p7
this.dw_d1=create dw_d1
this.dw_d9=create dw_d9
this.dw_d3=create dw_d3
this.st_state=create st_state
this.pb_2=create pb_2
this.dw_d2_detail=create dw_d2_detail
this.st_caption=create st_caption
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_search
this.Control[iCurrent+2]=this.p_delrow
this.Control[iCurrent+3]=this.p_delrow_all
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.dw_d2
this.Control[iCurrent+6]=this.dw_d0
this.Control[iCurrent+7]=this.dw_d68
this.Control[iCurrent+8]=this.dw_gi
this.Control[iCurrent+9]=this.dw_dh
this.Control[iCurrent+10]=this.dw_p6
this.Control[iCurrent+11]=this.dw_p7
this.Control[iCurrent+12]=this.dw_d1
this.Control[iCurrent+13]=this.dw_d9
this.Control[iCurrent+14]=this.dw_d3
this.Control[iCurrent+15]=this.st_state
this.Control[iCurrent+16]=this.pb_2
this.Control[iCurrent+17]=this.dw_d2_detail
this.Control[iCurrent+18]=this.st_caption
this.Control[iCurrent+19]=this.rr_1
end on

on w_sm10_0030p.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.p_search)
destroy(this.p_delrow)
destroy(this.p_delrow_all)
destroy(this.pb_1)
destroy(this.dw_d2)
destroy(this.dw_d0)
destroy(this.dw_d68)
destroy(this.dw_gi)
destroy(this.dw_dh)
destroy(this.dw_p6)
destroy(this.dw_p7)
destroy(this.dw_d1)
destroy(this.dw_d9)
destroy(this.dw_d3)
destroy(this.st_state)
destroy(this.pb_2)
destroy(this.dw_d2_detail)
destroy(this.st_caption)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.Object.jisi_date[1] = is_today
dw_ip.Object.jisi_date2[1] = is_today
//dw_ip.Object.factory[1] = "."

dw_d0.SetTransObject(SQLCA)
dw_d2.SetTransObject(SQLCA)
dw_d68.SetTransObject(SQLCA)
dw_gi.SetTransObject(SQLCA)
dw_dh.SetTransObject(SQLCA)
dw_p6.SetTransObject(SQLCA)
dw_p7.SetTransObject(SQLCA)
dw_d1.SetTransObject(SQLCA)
dw_d9.SetTransObject(SQLCA)
dw_d3.SetTransObject(SQLCA)

dw_d2_detail.SetTransObject(SQLCA)

setnull(gs_code)
If f_check_saupj() = 1 Then
	dw_ip.SetItem(1, 'saupj', gs_code)
   if gs_code <> '%' then
   	dw_ip.Modify("saupj.protect=1")
   End if
End If

Select rfna5 Into :is_custid
  From reffpf
  Where rfcod = 'AD'
    and rfcod != '00' 
	 and rfgub = :gs_code ;
If sqlca.sqlcode <> 0 Then
	f_message_chk(33 ,'[사업장]')
	Return
End If

//dw_list.Retrieve(gs_code , 'D2'+is_today , 'D2'+is_today, '%S00100%', '%%', '%')

	dw_d0.visible = False
	dw_d2.visible = False
	dw_d68.visible = False
	dw_gi.visible = False
	dw_dh.visible = False
	dw_p6.visible = False
	dw_p7.visible = False
	dw_d1.visible = False
	dw_d9.visible = False
	dw_d3.visible = False
	
	dw_d2_detail.visible = False
		
	dw_list.visible = True





end event

type p_xls from w_standard_print`p_xls within w_sm10_0030p
boolean visible = true
integer x = 4270
integer y = 24
boolean enabled = false
string picturename = "C:\erpman\image\엑셀변환_d.gif"
end type

type p_sort from w_standard_print`p_sort within w_sm10_0030p
boolean visible = true
integer x = 3922
integer y = 188
end type

type p_preview from w_standard_print`p_preview within w_sm10_0030p
integer taborder = 20
end type

type p_exit from w_standard_print`p_exit within w_sm10_0030p
integer taborder = 50
end type

event p_exit::clicked;close(parent)

end event

type p_print from w_standard_print`p_print within w_sm10_0030p
boolean visible = false
integer x = 3406
integer y = 228
integer taborder = 30
end type

type p_retrieve from w_standard_print`p_retrieve within w_sm10_0030p
integer taborder = 10
end type

event p_retrieve::clicked;//
if is_Upmu = 'A' then
	
	if dw_ip.AcceptText() = -1 then return  

	w_mdi_frame.sle_msg.text =""
	
	sabu_f =Trim(dw_ip.GetItemString(1,"saupj"))
	
	SetPointer(HourGlass!)
	IF sabu_f ="" OR IsNull(sabu_f) OR sabu_f ="99" THEN	//사업장이 전사이거나 없으면 모든 사업장//
		sabu_f ="10"
		sabu_t ="98"
		SELECT "REFFPF"."RFNA1"  
		 INTO :sabu_nm  
		 FROM "REFFPF"  
		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND  
				( "REFFPF"."RFGUB" = '99' )   ;
	ELSE
		sabu_t =sabu_f
		SELECT "REFFPF"."RFNA1"  
		 INTO :sabu_nm  
		 FROM "REFFPF"  
		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND  
				( "REFFPF"."RFGUB" = :sabu_f )   ;
	END IF
end if

IF wf_retrieve() = -1 THEN
	p_xls.Enabled =False
	p_xls.PictureName = 'C:\erpman\image\엑셀변환_d.gif'

	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
	SetPointer(Arrow!)
	Return
Else
	p_xls.Enabled =True
	p_xls.PictureName =  'C:\erpman\image\엑셀변환_up.gif'
	p_preview.enabled = true
	p_preview.PictureName = 'C:\erpman\image\미리보기_up.gif'
END IF
dw_list.scrolltorow(1)
dw_list.SetFocus()
SetPointer(Arrow!)	

w_mdi_frame.sle_msg.text =""

///-----------------------------------------------------------------------------------------
// by 2006.09.30 font채 변경 - 신
String ls_gbn
SELECT DATANAME
  INTO :ls_gbn
  FROM SYSCNFG
 WHERE SYSGU  = 'C'
   AND SERIAL = '81'
   AND LINENO = '1' ;
If ls_gbn = 'Y' Then
	//wf_setfont()
	WindowObject l_object[]
	Long i
	gstr_object_chg lstr_object		
	For i = 1 To UpperBound(Control[])
		lstr_object.lu_object[i] = Control[i]  //Window Object
		lstr_object.li_obj = i						//Window Object 갯수
	Next
	f_change_font(lstr_object)
End If

///-----------------------------------------------------------------------------------------


end event







type st_10 from w_standard_print`st_10 within w_sm10_0030p
end type



type dw_print from w_standard_print`dw_print within w_sm10_0030p
integer x = 3712
integer y = 248
string dataobject = "d_sm10_p0030_d1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sm10_0030p
integer x = 9
integer y = 28
integer width = 3909
integer height = 356
integer taborder = 60
string dataobject = "d_sm10_p0030_1"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;call super::itemchanged;String ls_col , ls_value, ls_itnbr_t, ls_itnbr_f

ls_col = GetColumnName()
ls_value = Trim(GetText())

Choose Case ls_col
	Case "tx_itnbr_f"
		ls_itnbr_t = Trim(This.GetItemString(row, 'tx_itnbr_t'))
		if IsNull(ls_itnbr_t) or ls_itnbr_t = '' then
			This.SetItem(row, 'tx_itnbr_t', ls_value)
	   end if
	Case "tx_itnbr_t"
		ls_itnbr_f = Trim(This.GetItemString(row, 'tx_itnbr_f'))
		if IsNull(ls_itnbr_f) or ls_itnbr_f = '' then
			This.SetItem(row, 'tx_itnbr_f', ls_value)
	   end if
	Case "gubun"
		Choose Case ls_value
			Case 'D0'
				
					dw_d0.x = dw_list.x
					dw_d0.y = dw_list.y
					dw_d0.width  = dw_list.width
					dw_d0.height = dw_list.height
					
					dw_list.visible = False
					
					dw_d0.visible = True
					dw_d2.visible = False
					dw_d68.visible = False
					dw_gi.visible = False
					dw_dh.visible = False 
					dw_p6.visible = False
					dw_p7.visible = False
					dw_d1.visible = False
					dw_d9.visible = False
					dw_d3.visible = False
				
			Case 'D2'
				
					dw_list.x = dw_list.x
					dw_list.y = dw_list.y
					dw_list.width  = dw_list.width
					dw_list.height = dw_list.height
					
					dw_list.visible = True
					
					dw_d0.visible = False
					dw_d2.visible = False
					dw_d68.visible = False
					dw_gi.visible = False
					dw_dh.visible = False
					dw_p6.visible = False
					dw_p7.visible = False
					dw_d1.visible = False
					dw_d9.visible = False
					dw_d3.visible = False
				
			Case 'D6'
				
					dw_d68.x = dw_list.x
					dw_d68.y = dw_list.y
					dw_d68.width  = dw_list.width
					dw_d68.height = dw_list.height
					
					dw_list.visible = False
					
					dw_d0.visible = False
					dw_d2.visible = False
					dw_d68.visible = True
					dw_gi.visible = False
					dw_dh.visible = False
					dw_p6.visible = False
					dw_p7.visible = False
					dw_d1.visible = False
					dw_d9.visible = False
					dw_d3.visible = False
				
			Case 'D8'
				
					dw_d68.x = dw_list.x
					dw_d68.y = dw_list.y
					dw_d68.width  = dw_list.width
					dw_d68.height = dw_list.height
					
					dw_list.visible = False
					
					dw_d0.visible = False
					dw_d2.visible = False
					dw_d68.visible = True
					dw_gi.visible = False
					dw_dh.visible = False
					dw_p6.visible = False
					dw_p7.visible = False
					dw_d1.visible = False
					dw_d9.visible = False
					dw_d3.visible = False
				
			Case 'GI'
				
					dw_gi.x = dw_list.x
					dw_gi.y = dw_list.y
					dw_gi.width  = dw_list.width
					dw_gi.height = dw_list.height
					dw_list.visible = False
					
					dw_d0.visible = False
					dw_d2.visible = False
					dw_d68.visible = False
					dw_gi.visible = True
					dw_dh.visible = False
					dw_p6.visible = False
					dw_p7.visible = False
					dw_d1.visible = False
					dw_d9.visible = False
					dw_d3.visible = False
				
			Case 'DH'
				
					dw_dh.x = dw_list.x
					dw_dh.y = dw_list.y
					dw_dh.width  = dw_list.width
					dw_dh.height = dw_list.height
					dw_list.visible = False
					
					dw_d0.visible = False
					dw_d2.visible = False
					dw_d68.visible = False
					dw_gi.visible = False
					dw_dh.visible = True
					dw_p6.visible = False
					dw_p7.visible = False
					dw_d1.visible = False
					dw_d9.visible = False
					dw_d3.visible = False
				
			Case 'P6'
				
					dw_p6.x = dw_list.x
					dw_p6.y = dw_list.y
					dw_p6.width  = dw_list.width
					dw_p6.height = dw_list.height
					dw_list.visible = False
					
					dw_d0.visible = False
					dw_d2.visible = False
					dw_d68.visible = False
					dw_gi.visible = False
					dw_dh.visible = False
					dw_p6.visible = True
					dw_p7.visible = False
					dw_d1.visible = False
					dw_d9.visible = False
					dw_d3.visible = False
				
			Case 'P7'
				
					dw_p7.x = dw_list.x
					dw_p7.y = dw_list.y
					dw_p7.width  = dw_list.width
					dw_p7.height = dw_list.height
					dw_list.visible = False
					
					dw_d0.visible = False
					dw_d2.visible = False
					dw_d68.visible = False
					dw_gi.visible = False
					dw_dh.visible = False
					dw_p6.visible = False
					dw_p7.visible = True
					dw_d1.visible = False
					dw_d9.visible = False
					dw_d3.visible = False
			
			Case 'D1'
				
					dw_d1.x = dw_list.x
					dw_d1.y = dw_list.y
					dw_d1.width  = dw_list.width
					dw_d1.height = dw_list.height
					dw_list.visible = False
					
					dw_d0.visible = False
					dw_d2.visible = False
					dw_d68.visible = False
					dw_gi.visible = False
					dw_dh.visible = False
					dw_p6.visible = False
					dw_p7.visible = False
					dw_d1.visible = True
					dw_d9.visible = False
					dw_d3.visible = False
			
			Case 'D9'
				
					dw_d9.x = dw_list.x
					dw_d9.y = dw_list.y
					dw_d9.width  = dw_list.width
					dw_d9.height = dw_list.height
					dw_list.visible = False
					
					dw_d0.visible = False
					dw_d2.visible = False
					dw_d68.visible = False
					dw_gi.visible = False
					dw_dh.visible = False
					dw_p6.visible = False
					dw_p7.visible = False
					dw_d1.visible = False
					dw_d9.visible = True
					dw_d3.visible = False
			
			Case 'D3'
				
					dw_d3.x = dw_list.x
					dw_d3.y = dw_list.y
					dw_d3.width  = dw_list.width
					dw_d3.height = dw_list.height
					dw_list.visible = False
					
					dw_d0.visible = False
					dw_d2.visible = False
					dw_d68.visible = False
					dw_gi.visible = False
					dw_dh.visible = False
					dw_p6.visible = False
					dw_p7.visible = False
					dw_d1.visible = False
					dw_d9.visible = False
					dw_d3.visible = True			
		
		End Choose
END CHOOSE

if ls_value = 'AL' Then st_caption.Text = ' '
if ls_value = 'D0' Then st_caption.Text = '품목정보'
if ls_value = 'DH' Then st_caption.Text = 'HPC-CODE 기초정보'
if ls_value = 'D1' Then st_caption.Text = '검수합격통보서(입고일기준)'
if ls_value = 'D2' Then st_caption.Text = '주간(부품) 소요량'
if ls_value = 'D6' Then st_caption.Text = '납입지시(정규발주)'
if ls_value = 'D8' Then st_caption.Text = '납입지시(변동분)'
if ls_value = 'GI' Then st_caption.Text = ' '
if ls_value = 'P6' Then st_caption.Text = '서열부품집계표(상세용)'
if ls_value = 'P7' Then st_caption.Text = '서열부품집계표(종합용)'
if ls_value = 'D9' Then st_caption.Text = '검수합격통보서(월집계)'
if ls_value = 'D3' Then st_caption.Text = '초도발주'
end event

type dw_list from w_standard_print`dw_list within w_sm10_0030p
integer x = 59
integer y = 412
integer width = 4535
integer taborder = 0
string dataobject = "d_sm10_p0030_d2"
boolean border = false
end type

event dw_list::clicked;f_multi_select(this)
end event

event dw_list::rowfocuschanged;//
end event

event dw_list::doubleclicked;call super::doubleclicked;String ls_sabu, ls_doccode, ls_custcd, ls_factory, ls_itnbr
			
//DataWindow 크기 재정의			
dw_d2_detail.x = 443
dw_d2_detail.y = 1196
dw_d2_detail.Width = 3621
dw_d2_detail.Height = 1144

//DoubleClick한 Row의 PK 값을 받아온다
ls_sabu    = This.GetItemString(This.GetRow(), "sabu")
ls_doccode = This.GetItemString(This.GetRow(), "doccode")
ls_custcd  = This.GetItemString(This.GetRow(), "custcd")
ls_factory = This.GetItemString(This.GetRow(), "van_hkcd2_factory")
ls_itnbr   = This.GetItemString(This.GetRow(), "van_hkcd2_itnbr")

dw_d2_detail.Visible = True

dw_d2_detail.Retrieve(ls_sabu, ls_doccode, ls_custcd, ls_factory, ls_itnbr)

end event

type p_search from uo_picture within w_sm10_0030p
boolean visible = false
integer x = 4096
integer y = 188
integer width = 178
boolean bringtotop = true
string pointer = "C:\erpman\cur\create2.cur"
boolean enabled = false
string picturename = "C:\erpman\image\생성_up.gif"
end type

event clicked;call super::clicked;//Long ll_cnt
//string ls_filename , ls_gubun , ls_reg_gb
//If dw_ip.AcceptText() < 1 Then Return
//If dw_ip.RowCount() < 1 Then Return
//
//ls_gubun = Trim(dw_ip.Object.gubun[1])
//
//dw_ip.Object.reg_gb[1] = 'N'
//pb_2.visible = False
//
//pointer oldpointer
//oldpointer = SetPointer(HourGlass!)
//
//dw_list.reset()
//
//Choose Case ls_gubun
//	Case "D0"
//		
//		ll_cnt=0
//		ls_gubun = "HKCD0"
//		ls_filename = "C:\HKC\VAN\HKCD0.TXT"
//		ll_cnt = wf_van_d0(ls_filename,gs_sabu)
//		If ll_cnt > 0 Then
//			wf_error(ls_gubun,ll_cnt,'','','','D0 파일에서 '+string(ll_cnt)+' 건수가 정상적으로 생성되었습니다.')
//		End if
//	Case "D2"
//		
//		ll_cnt=0
//		ls_gubun = "HKCD2"
//		ls_filename = "C:\HKC\VAN\HKCD2.TXT"
//		ll_cnt = wf_van_d2(ls_filename,gs_sabu)
//		If ll_cnt > 0 Then
//			wf_error(ls_gubun,ll_cnt,'','','','D2 파일에서 '+string(ll_cnt)+' 건수가 정상적으로 생성되었습니다.')
//		End if
//	Case "D6"
//		
//		ll_cnt=0
//		ls_gubun = "HKCD6"
//		ls_filename = "C:\HKC\VAN\HKCD6.TXT"
//		ll_cnt = wf_van_d68(ls_filename,gs_sabu)
//		If ll_cnt > 0 Then
//			wf_error(ls_gubun,ll_cnt,'','','','D6 파일에서 '+string(ll_cnt)+' 건수가 정상적으로 생성되었습니다.')
//		End if
//	Case "D8"
//		
//		ll_cnt=0
//		ls_gubun = "HKCD8"
//		ls_filename = "C:\HKC\VAN\HKCD8.TXT"
//		ll_cnt = wf_van_d68(ls_filename,gs_sabu)
//		If ll_cnt > 0 Then
//			wf_error(ls_gubun,ll_cnt,'','','','D8 파일에서 '+string(ll_cnt)+' 건수가 정상적으로 생성되었습니다.')
//		End if
//	Case "GI"
//			
//		ll_cnt=0
//		ls_gubun = "GINGUB"
//		ls_filename = "C:\HKC\VAN\GINGUB.TXT"
//		ll_cnt = wf_van_gi(ls_filename,gs_sabu)
//		If ll_cnt > 0 Then
//			wf_error(ls_gubun,ll_cnt,'','','','GINGUB 파일에서 '+string(ll_cnt)+' 건수가 정상적으로 생성되었습니다.')
//		End if
//	Case "DH"
//		ll_cnt=0
//		ls_gubun = "HKCDH"
//		ls_filename = "C:\HKC\VAN\HKCDH.TXT"
//		ll_cnt = wf_van_dh(ls_filename,gs_sabu)
//		If ll_cnt > 0 Then
//			wf_error(ls_gubun,ll_cnt,'','','','DH 파일에서 '+string(ll_cnt)+' 건수가 정상적으로 생성되었습니다.')
//		End if
//	Case "P6"
//		ll_cnt=0
//		ls_gubun = "HKCP6"
//		ls_filename = "C:\HKC\VAN\HKCP6.TXT"
//		ll_cnt = wf_van_p6(ls_filename,gs_sabu)
//		If ll_cnt > 0 Then
//			wf_error(ls_gubun,ll_cnt,'','','','P6 파일에서 '+string(ll_cnt)+' 건수가 정상적으로 생성되었습니다.')
//		End if
//	Case "P7"
//		
//		ll_cnt=0
//		ls_gubun = "HKCP7"
//		ls_filename = "C:\HKC\VAN\HKCP7.TXT"
//		ll_cnt = wf_van_P7(ls_filename,gs_sabu)
//		If ll_cnt > 0 Then
//			wf_error(ls_gubun,ll_cnt,'','','','P7 파일에서 '+string(ll_cnt)+' 건수가 정상적으로 생성되었습니다.')
//		End if
//	Case "D1"
//	
//		ll_cnt=0
//		ls_gubun = "HKCD1"
//		ls_filename = "C:\HKC\VAN\HKCD1.TXT"
//		ll_cnt = wf_van_d1(ls_filename,gs_sabu)
//		If ll_cnt > 0 Then
//			wf_error(ls_gubun,ll_cnt,'','','','D1 파일에서 '+string(ll_cnt)+' 건수가 정상적으로 생성되었습니다.')
//		End if
//	Case "D9"
//		
//		ll_cnt=0
//		ls_gubun = "HKCD9"
//		ls_filename = "C:\HKC\VAN\HKCD9.TXT"
//		ll_cnt = wf_van_d9(ls_filename,gs_sabu)
//		If ll_cnt > 0 Then
//			wf_error(ls_gubun,ll_cnt,'','','','D9 파일에서 '+string(ll_cnt)+' 건수가 정상적으로 생성되었습니다.')
//		End if
//	Case "D3"
//		ll_cnt=0
//		ls_gubun = "HKCD3"
//		ls_filename = "C:\HKC\VAN\HKCD3.TXT"
//		ll_cnt = wf_van_d3(ls_filename,gs_sabu)
//		If ll_cnt > 0 Then
//			wf_error(ls_gubun,ll_cnt,'','','','D3 파일에서 '+string(ll_cnt)+' 건수가 정상적으로 생성되었습니다.')
//		End if
//	Case Else
//		// D0
//		ll_cnt=0
//		ls_gubun = "HKCD0"
//		ls_filename = "C:\HKC\VAN\HKCD0.TXT"
//		ll_cnt = wf_van_d0(ls_filename,gs_sabu)
//		If ll_cnt > 0 Then
//			wf_error(ls_gubun,ll_cnt,'','','','D0 파일에서 '+string(ll_cnt)+' 건수가 정상적으로 생성되었습니다.')
//		End if
//		
//		// DH
//		ll_cnt=0
//		ls_gubun = "HKCDH"
//		ls_filename = "C:\HKC\VAN\HKCDH.TXT"
//		ll_cnt = wf_van_dh(ls_filename,gs_sabu)
//		If ll_cnt > 0 Then
//			wf_error(ls_gubun,ll_cnt,'','','','DH 파일에서 '+string(ll_cnt)+' 건수가 정상적으로 생성되었습니다.')
//		End if
//		
//		// D2
//		ll_cnt=0
//		ls_gubun = "HKCD2"
//		ls_filename = "C:\HKC\VAN\HKCD2.TXT"
//		ll_cnt = wf_van_d2(ls_filename,gs_sabu)
//		If ll_cnt > 0 Then
//			wf_error(ls_gubun,ll_cnt,'','','','D2 파일에서 '+string(ll_cnt)+' 건수가 정상적으로 생성되었습니다.')
//		End if
//		// D6
//		ll_cnt=0
//		ls_gubun = "HKCD6"
//		ls_filename = "C:\HKC\VAN\HKCD6.TXT"
//		ll_cnt = wf_van_d68(ls_filename,gs_sabu)
//		If ll_cnt > 0 Then
//			wf_error(ls_gubun,ll_cnt,'','','','D6 파일에서 '+string(ll_cnt)+' 건수가 정상적으로 생성되었습니다.')
//		End if
//		// D8
//		ll_cnt=0
//		ls_gubun = "HKCD8"
//		ls_filename = "C:\HKC\VAN\HKCD8.TXT"
//		ll_cnt = wf_van_d68(ls_filename,gs_sabu)
//		If ll_cnt > 0 Then
//			wf_error(ls_gubun,ll_cnt,'','','','D8 파일에서 '+string(ll_cnt)+' 건수가 정상적으로 생성되었습니다.')
//		End if
//		// GINGUB
//		ll_cnt=0
//		ls_gubun = "GINGUB"
//		ls_filename = "C:\HKC\VAN\GINGUB.TXT"
//		ll_cnt = wf_van_gi(ls_filename,gs_sabu)
//		If ll_cnt > 0 Then
//			wf_error(ls_gubun,ll_cnt,'','','','GINGUB 파일에서 '+string(ll_cnt)+' 건수가 정상적으로 생성되었습니다.')
//		End if
//		
//		// P6
//		ll_cnt=0
//		ls_gubun = "HKCP6"
//		ls_filename = "C:\HKC\VAN\HKCP6.TXT"
//		ll_cnt = wf_van_p6(ls_filename,gs_sabu)
//		If ll_cnt > 0 Then
//			wf_error(ls_gubun,ll_cnt,'','','','P6 파일에서 '+string(ll_cnt)+' 건수가 정상적으로 생성되었습니다.')
//		End if
//		// P7
//		ll_cnt=0
//		ls_gubun = "HKCP7"
//		ls_filename = "C:\HKC\VAN\HKCP7.TXT"
//		ll_cnt = wf_van_P7(ls_filename,gs_sabu)
//		If ll_cnt > 0 Then
//			wf_error(ls_gubun,ll_cnt,'','','','P7 파일에서 '+string(ll_cnt)+' 건수가 정상적으로 생성되었습니다.')
//		End if
//		// D1
//		ll_cnt=0
//		ls_gubun = "HKCD1"
//		ls_filename = "C:\HKC\VAN\HKCD1.TXT"
//		ll_cnt = wf_van_d1(ls_filename,gs_sabu)
//		If ll_cnt > 0 Then
//			wf_error(ls_gubun,ll_cnt,'','','','D1 파일에서 '+string(ll_cnt)+' 건수가 정상적으로 생성되었습니다.')
//		End if
//		// D9
//		ll_cnt=0
//		ls_gubun = "HKCD9"
//		ls_filename = "C:\HKC\VAN\HKCD9.TXT"
//		ll_cnt = wf_van_d9(ls_filename,gs_sabu)
//		If ll_cnt > 0 Then
//			wf_error(ls_gubun,ll_cnt,'','','','D9 파일에서 '+string(ll_cnt)+' 건수가 정상적으로 생성되었습니다.')
//		End if
//		// D3
//		ll_cnt=0
//		ls_gubun = "HKCD3"
//		ls_filename = "C:\HKC\VAN\HKCD3.TXT"
//		ll_cnt = wf_van_d3(ls_filename,gs_sabu)
//		If ll_cnt > 0 Then
//			wf_error(ls_gubun,ll_cnt,'','','','D3 파일에서 '+string(ll_cnt)+' 건수가 정상적으로 생성되었습니다.')
//		End if
//		
//End Choose
//
////If dw_list.RowCount() > 0 Then
////   
////	Long ll_max ,i; String ls_new
////	
////	Select NVL(Max(err_seq),0) Into :ll_max
////	  From VAN_ERROR ;
////	
////	dw_list.AcceptText()
////	For i =1 To dw_list.Rowcount()
////		ls_new = Trim(dw_list.Object.is_new[i])
////		If ls_new = 'Y' Then
////			ll_max++
////			dw_list.Object.err_seq[i] = ll_max
////		End iF
////	Next
////	dw_list.AcceptText()
////	If dw_list.Update() < 1 Then
////		Rollback;
////		MessageBox('확인','ERROR LIST 저장 실패')
////		Return
////	Else
////		Commit;
////		
////		
////		
////	End If
////End If	
//SetPointer(oldpointer)
//
//If ll_cnt > 0 Then
//	p_print.Enabled =True
//	p_print.PictureName = 'C:\erpman\image\인쇄_up.gif'
//
//	p_preview.enabled = True
//	p_preview.PictureName = 'C:\erpman\image\미리보기_up.gif'
//Else
//	p_print.Enabled =False
//	p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'
//
//	p_preview.enabled = False
//	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
//End If	
//SetPointer(Arrow!)
//
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\생성_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\생성_up.gif"
end event

type p_delrow from uo_picture within w_sm10_0030p
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
boolean visible = false
integer x = 4443
integer y = 188
integer width = 178
boolean bringtotop = true
string pointer = "C:\erpman\cur\delrow.cur"
boolean enabled = false
string picturename = "C:\erpman\image\행삭제_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\행삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\행삭제_up.gif"
end event

event clicked;call super::clicked;//Long i ,ll_rcnt
//string ls_gubun ,ls_saupj , ls_cvcod ,ls_date , ls_saupj_cust
//DataWindow ldw_x
//
//if dw_ip.AcceptText() = -1 then return -1
//if dw_ip.rowcount() <= 0 then return -1
//
//ls_gubun = Trim(dw_ip.Object.gubun[1]) 
//ls_saupj = Trim(dw_ip.Object.saupj[1])
//ls_cvcod = Trim(dw_ip.Object.mcvcod[1])
//
//ls_date = Trim(dw_ip.Object.jisi_date[1])
//
//SetNull(ls_saupj_cust)
//
//select fun_get_reffpf_value('AD',:ls_saupj,'4') Into :ls_saupj_cust
//  from dual ;
//If sqlca.sqlcode <> 0 Or ls_saupj_cust = '' Or isNull(ls_saupj_cust) Then
//	MessageBox('확인','사업장을 선택하세요')
//	Return -1
//End If
//	
//If Tab_1.SelectedTab = 1 Then
//	ldw_x = dw_list
//
//Else
//	Choose Case ls_gubun 
//		Case 'D0'
//			ldw_x = dw_d0
//		Case 'D2'
//			ldw_x = dw_d2
//		Case 'D6'
//			ldw_x = dw_d68
//		Case 'D8'
//			ldw_x = dw_d68
//		Case 'GI'
//			ldw_x = dw_gi
//		Case 'DH'
//			ldw_x = dw_dh
//		Case 'P6'
//			ldw_x = dw_p6
//		Case 'P7'
//			ldw_x = dw_p7
//		Case 'D1'
//			ldw_x = dw_d1
//		Case 'D9'
//			ldw_x = dw_d9
//		Case 'D3'
//			ldw_x = dw_d3
//		
//	End Choose
//	
//End IF
//
//
//ll_rcnt = ldw_x.RowCount()
//
//If ll_rcnt < 1 Then 
//	MessageBox('확인','삭제할 데이타가 존재하지 않습니다.')
//	Return
//End IF
//if f_msg_delete() = -1 then return
//
//ldw_x.SetRedraw(FALSE)
//
//For i = ll_rcnt To 1 Step -1
//	If ldw_x.isSelected(i) Then
//		ldw_x.ScrollToRow(i)
//		ldw_x.DeleteRow(i)
//	End iF
//Next
//
//if ldw_x.Update() = 1 then
//	
//	commit ;
//	sle_msg.text =	"모든자료를 삭제하였습니다!!"	
//else
//	rollback ;
//   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
//end if	
//ldw_x.SetRedraw(TRUE)
//
//
end event

type p_delrow_all from uo_picture within w_sm10_0030p
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
boolean visible = false
integer x = 4270
integer y = 188
integer width = 178
boolean bringtotop = true
string pointer = "C:\erpman\cur\create2.cur"
boolean enabled = false
string picturename = "C:\erpman\image\전체삭제_up.gif"
end type

event clicked;call super::clicked;//Long i ,ll_rcnt
//string ls_gubun ,ls_saupj , ls_cvcod ,ls_date , ls_saupj_cust
//DataWindow ldw_x
//
//if dw_ip.AcceptText() = -1 then return -1
//if dw_ip.rowcount() <= 0 then return -1
//
//ls_gubun = Trim(dw_ip.Object.gubun[1]) 
//ls_saupj = Trim(dw_ip.Object.saupj[1])
//ls_cvcod = Trim(dw_ip.Object.mcvcod[1])
//
//ls_date = Trim(dw_ip.Object.jisi_date[1])
//
//SetNull(ls_saupj_cust)
//
//select fun_get_reffpf_value('AD',:ls_saupj,'4') Into :ls_saupj_cust
//  from dual ;
//If sqlca.sqlcode <> 0 Or ls_saupj_cust = '' Or isNull(ls_saupj_cust) Then
//	MessageBox('확인','사업장을 선택하세요')
//	Return -1
//End If
//	
//If Tab_1.SelectedTab = 1 Then
//	ldw_x = dw_list
//
//Else
//	Choose Case ls_gubun 
//		Case 'D0'
//			ldw_x = dw_d0
//		Case 'D2'
//			ldw_x = dw_d2
//		Case 'D6'
//			ldw_x = dw_d68
//		Case 'D8'
//			ldw_x = dw_d68
//		Case 'GI'
//			ldw_x = dw_gi
//		Case 'DH'
//			ldw_x = dw_dh
//		Case 'P6'
//			ldw_x = dw_p6
//		Case 'P7'
//			ldw_x = dw_p7
//		Case 'D1'
//			ldw_x = dw_d1
//		Case 'D9'
//			ldw_x = dw_d9
//		Case 'D3'
//			ldw_x = dw_d3
//		
//	End Choose
//	
//End IF
//
//
//ll_rcnt = ldw_x.RowCount()
//
//If ll_rcnt < 1 Then 
//	MessageBox('확인','삭제할 데이타가 존재하지 않습니다.')
//	Return
//End IF
//if f_msg_delete() = -1 then return
//
//ldw_x.SetRedraw(FALSE)
//
//For i = ll_rcnt To 1 Step -1
//	
//	ldw_x.ScrollToRow(i)
//	ldw_x.DeleteRow(i)
//	
//Next
//
//if ldw_x.Update() = 1 then
//	
//	commit ;
//	sle_msg.text =	"모든자료를 삭제하였습니다!!"	
//else
//	rollback ;
//   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
//end if	
//ldw_x.SetRedraw(TRUE)
//
//
//
//
end event

type pb_1 from u_pb_cal within w_sm10_0030p
integer x = 800
integer y = 172
integer height = 76
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('jisi_date')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'jisi_date', gs_code)

end event

type dw_d2 from datawindow within w_sm10_0030p
integer x = 882
integer y = 1052
integer width = 686
integer height = 400
boolean bringtotop = true
string title = "D2"
string dataobject = "d_sm10_p0030_d2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;f_multi_select(this)
end event

event doubleclicked;String ls_sabu, ls_doccode, ls_custcd, ls_factory, ls_itnbr
			
//DataWindow 크기 재정의			
dw_d2_detail.x = 443
dw_d2_detail.y = 1196
dw_d2_detail.Width = 3621
dw_d2_detail.Height = 1144

//DoubleClick한 Row의 PK 값을 받아온다
ls_sabu    = This.GetItemString(This.GetRow(), "sabu")
ls_doccode = This.GetItemString(This.GetRow(), "doccode")
ls_custcd  = This.GetItemString(This.GetRow(), "custcd")
ls_factory = This.GetItemString(This.GetRow(), "van_hkcd2_factory")
ls_itnbr   = This.GetItemString(This.GetRow(), "van_hkcd2_itnbr")

dw_d2_detail.Visible = True

//해당 상세 DataWindow를 연결한다.
dw_d2_detail.DataObject = "d_sm10_p0030_d2_detail"
dw_d2_detail.SetTransObject(SQLCA)

dw_d2_detail.Retrieve(ls_sabu, ls_doccode, ls_custcd, ls_factory, ls_itnbr)
			
end event

type dw_d0 from datawindow within w_sm10_0030p
integer x = 174
integer y = 1052
integer width = 686
integer height = 400
boolean bringtotop = true
string title = "D0"
string dataobject = "d_sm10_p0030_d0"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;f_multi_select(this)
end event

type dw_d68 from datawindow within w_sm10_0030p
integer x = 1591
integer y = 1056
integer width = 686
integer height = 400
boolean bringtotop = true
string title = "D68"
string dataobject = "d_sm10_p0030_d68"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;f_multi_select(this)
end event

type dw_gi from datawindow within w_sm10_0030p
integer x = 2309
integer y = 1064
integer width = 686
integer height = 400
boolean bringtotop = true
string title = "긴급"
string dataobject = "d_sm10_p0030_gi"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;f_multi_select(this)
end event

type dw_dh from datawindow within w_sm10_0030p
integer x = 3022
integer y = 1068
integer width = 686
integer height = 400
boolean bringtotop = true
string title = "DH"
string dataobject = "d_sm10_p0030_dh"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;f_multi_select(this)
end event

type dw_p6 from datawindow within w_sm10_0030p
integer x = 183
integer y = 1504
integer width = 686
integer height = 400
boolean bringtotop = true
string title = "P6"
string dataobject = "d_sm10_p0030_p6"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;f_multi_select(this)
end event

event doubleclicked;String ls_sabu, ls_doccode, ls_custcd, ls_factory, ls_itemser, ls_itemname, ls_itemcode
			
//DataWindow 크기 재정의			
dw_d2_detail.x = 475
dw_d2_detail.y = 1304
dw_d2_detail.Width = 3621
dw_d2_detail.Height = 1064

//DoubleClick한 Row의 PK 값을 받아온다
ls_sabu    = This.GetItemString(This.GetRow(), "sabu")
ls_doccode = This.GetItemString(This.GetRow(), "doccode")
ls_custcd  = This.GetItemString(This.GetRow(), "custcd")
ls_factory = This.GetItemString(This.GetRow(), "factory")
ls_itemser   = This.GetItemString(This.GetRow(), "itemser")
ls_itemname  = This.GetItemString(This.GetRow(), "itemname")
ls_itemcode  = This.GetItemString(This.GetRow(), "itemcode")

dw_d2_detail.Visible = True

//해당 상세 DataWindow를 연결한다.
dw_d2_detail.DataObject = "d_sm10_p0030_p6_detail"
dw_d2_detail.SetTransObject(SQLCA)

dw_d2_detail.Retrieve(ls_sabu, ls_doccode, ls_custcd, ls_factory, ls_itemser, ls_itemname, ls_itemcode)
end event

type dw_p7 from datawindow within w_sm10_0030p
integer x = 878
integer y = 1508
integer width = 686
integer height = 400
boolean bringtotop = true
string title = "P7"
string dataobject = "d_sm10_p0030_p7"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;f_multi_select(this)
end event

event doubleclicked;String ls_sabu, ls_doccode, ls_custcd, ls_factory, ls_itemser, ls_itemname, ls_itemcode
			
//DataWindow 크기 재정의			
dw_d2_detail.x = 635
dw_d2_detail.y = 1624
dw_d2_detail.Width = 3323
dw_d2_detail.Height = 716

//DoubleClick한 Row의 PK 값을 받아온다
ls_sabu    = This.GetItemString(This.GetRow(), "sabu")
ls_doccode = This.GetItemString(This.GetRow(), "doccode")
ls_custcd  = This.GetItemString(This.GetRow(), "custcd")
ls_factory = This.GetItemString(This.GetRow(), "factory")
ls_itemser   = This.GetItemString(This.GetRow(), "itemser")
ls_itemname  = This.GetItemString(This.GetRow(), "itemname")
ls_itemcode  = This.GetItemString(This.GetRow(), "itemcode")

dw_d2_detail.Visible = True

//해당 상세 DataWindow를 연결한다.
dw_d2_detail.DataObject = "d_sm10_p0030_p7_detail"
dw_d2_detail.SetTransObject(SQLCA)

dw_d2_detail.Retrieve(ls_sabu, ls_doccode, ls_custcd, ls_factory, ls_itemser, ls_itemname, ls_itemcode)
end event

type dw_d1 from datawindow within w_sm10_0030p
integer x = 1573
integer y = 1508
integer width = 686
integer height = 400
boolean bringtotop = true
string title = "D1"
string dataobject = "d_sm10_p0030_d1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;f_multi_select(this)
end event

type dw_d9 from datawindow within w_sm10_0030p
integer x = 2299
integer y = 1512
integer width = 686
integer height = 400
boolean bringtotop = true
string title = "D9"
string dataobject = "d_sm10_p0030_d9"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;f_multi_select(this)
end event

type dw_d3 from datawindow within w_sm10_0030p
integer x = 3031
integer y = 1512
integer width = 686
integer height = 400
boolean bringtotop = true
string title = "D3"
string dataobject = "d_sm10_p0030_d3"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;f_multi_select(this)
end event

type st_state from statictext within w_sm10_0030p
boolean visible = false
integer x = 1691
integer y = 816
integer width = 1440
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 32106727
string text = "데이타를 읽는 중입니다..."
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_2 from u_pb_cal within w_sm10_0030p
integer x = 1285
integer y = 172
integer height = 76
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('jisi_date2')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'jisi_date2', gs_code)

end event

type dw_d2_detail from datawindow within w_sm10_0030p
boolean visible = false
integer x = 306
integer y = 1192
integer width = 3621
integer height = 1144
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "소요량 상세"
string dataobject = "d_sm10_p0030_d2_detail"
boolean border = false
boolean livescroll = true
end type

event buttonclicked;This.Visible = False
end event

type st_caption from statictext within w_sm10_0030p
integer x = 3218
integer y = 288
integer width = 681
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 32106727
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_sm10_0030p
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 9
integer y = 396
integer width = 4603
integer height = 1944
integer cornerheight = 40
integer cornerwidth = 55
end type

