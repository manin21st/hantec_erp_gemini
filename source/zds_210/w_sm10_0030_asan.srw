$PBExportHeader$w_sm10_0030_asan.srw
$PBExportComments$VAN 접수(아산)
forward
global type w_sm10_0030_asan from w_standard_print
end type
type p_search from uo_picture within w_sm10_0030_asan
end type
type p_delrow from uo_picture within w_sm10_0030_asan
end type
type p_delrow_all from uo_picture within w_sm10_0030_asan
end type
type pb_1 from u_pb_cal within w_sm10_0030_asan
end type
type dw_d2 from datawindow within w_sm10_0030_asan
end type
type dw_d0 from datawindow within w_sm10_0030_asan
end type
type dw_d68 from datawindow within w_sm10_0030_asan
end type
type dw_gi from datawindow within w_sm10_0030_asan
end type
type dw_dh from datawindow within w_sm10_0030_asan
end type
type dw_p6 from datawindow within w_sm10_0030_asan
end type
type dw_p7 from datawindow within w_sm10_0030_asan
end type
type dw_d1 from datawindow within w_sm10_0030_asan
end type
type dw_d9 from datawindow within w_sm10_0030_asan
end type
type dw_d3 from datawindow within w_sm10_0030_asan
end type
type st_state from statictext within w_sm10_0030_asan
end type
type tab_1 from tab within w_sm10_0030_asan
end type
type tabpage_1 from userobject within tab_1
end type
type rr_1 from roundrectangle within tabpage_1
end type
type tabpage_1 from userobject within tab_1
rr_1 rr_1
end type
type tabpage_2 from userobject within tab_1
end type
type rr_2 from roundrectangle within tabpage_2
end type
type tabpage_2 from userobject within tab_1
rr_2 rr_2
end type
type tab_1 from tab within w_sm10_0030_asan
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type pb_2 from u_pb_cal within w_sm10_0030_asan
end type
type p_excel from uo_picture within w_sm10_0030_asan
end type
type dw_d2_detail from datawindow within w_sm10_0030_asan
end type
type st_caption from statictext within w_sm10_0030_asan
end type
type p_mod from uo_picture within w_sm10_0030_asan
end type
type dw_dc from datawindow within w_sm10_0030_asan
end type
type dw_ckd1 from datawindow within w_sm10_0030_asan
end type
type dw_ckd9 from datawindow within w_sm10_0030_asan
end type
type dw_ckd0 from datawindow within w_sm10_0030_asan
end type
type dw_ckd68 from datawindow within w_sm10_0030_asan
end type
type dw_ckd2 from datawindow within w_sm10_0030_asan
end type
type cb_d9_et from commandbutton within w_sm10_0030_asan
end type
type cb_1 from commandbutton within w_sm10_0030_asan
end type
end forward

global type w_sm10_0030_asan from w_standard_print
integer width = 4677
integer height = 2508
string title = "HMC VAN 접수(아산/울산)"
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
tab_1 tab_1
pb_2 pb_2
p_excel p_excel
dw_d2_detail dw_d2_detail
st_caption st_caption
p_mod p_mod
dw_dc dw_dc
dw_ckd1 dw_ckd1
dw_ckd9 dw_ckd9
dw_ckd0 dw_ckd0
dw_ckd68 dw_ckd68
dw_ckd2 dw_ckd2
cb_d9_et cb_d9_et
cb_1 cb_1
end type
global w_sm10_0030_asan w_sm10_0030_asan

type variables
String is_custid
Long il_err , il_succeed, il_cnt

DataWindowChild idwc_d0
end variables

forward prototypes
public function integer wf_retrieve ()
public function string wf_choose (string as_gubun)
public subroutine wf_error (string as_gubun, long al_line, string as_doccode, string as_factory, string as_itnbr, string as_errtext)
public function integer wf_csv_split (string arg_text, ref string arg_data[], integer arg_num)
public function integer wf_erp_d0 (string arg_gubun, string arg_file_name)
public function integer wf_ckd_d0 (string arg_gubun, string arg_file_name)
public function integer wf_erp_d1 (string arg_gubun, string arg_file_name)
public function integer wf_ckd_d1 (string arg_gubun, string arg_file_name)
public function integer wf_erp_d2 (string arg_gubun, string arg_file_name)
public function integer wf_erp_d68 (string arg_gubun, string arg_file_name)
public function integer wf_erp_d9 (string arg_gubun, string arg_file_name)
public function integer wf_ckd_d9 (string arg_gubun, string arg_file_name)
public function integer wf_erp_dh (string arg_gubun, string arg_file_name)
public function integer wf_erp_p6 (string arg_gubun, string arg_file_name)
public function integer wf_erp_p7 (string arg_gubun, string arg_file_name)
public function integer wf_ref_code (string arg_gubun, string arg_custcd, string arg_factory, string arg_itnbr, ref string ref_mitnbr, ref string ref_mcvcod, ref string ref_mdcvcod)
public function integer wf_ckd_d68 (string arg_gubun, string arg_file_name)
public function integer wf_ckd_d2 (string arg_gubun, string arg_file_name)
end prototypes

public function integer wf_retrieve ();Long i ,ll_rcnt
string ls_gubun ,ls_saupj , ls_cvcod ,ls_sdate  ,ls_edate, ls_saupj_cust 
string ls_factory , ls_itnbr, ls_itnbr_from, ls_itnbr_to, ls_from, ls_to
Integer li_no
DataWindow ldw_x

If Tab_1.SelectedTab = 1 Then Return -1

if dw_ip.AcceptText() = -1 then return -1
if dw_ip.rowcount() <= 0 then return -1

ls_gubun = Trim(dw_ip.Object.gubun[1]) 
ls_saupj = Trim(dw_ip.Object.saupj[1])
ls_cvcod = Trim(dw_ip.Object.mcvcod[1])


ls_sdate = Trim(dw_ip.Object.jisi_date[1])
ls_edate = Trim(dw_ip.Object.jisi_date2[1])

//ls_itnbr = Trim(dw_ip.Object.itnbr[1])
ls_factory = Trim(dw_ip.Object.factory[1])

If ls_itnbr = '' Or isNull(ls_itnbr) Then ls_itnbr = ''
If ls_factory = '' Or isNull(ls_factory) Or ls_factory = '.' Then ls_factory = '%'

ls_itnbr_from = Trim(dw_ip.Object.itnbr_from[1])
IF isNull(ls_itnbr_from) THEN ls_itnbr_from = ''
ls_itnbr_to = Trim(dw_ip.Object.itnbr_to[1])
IF isNull(ls_itnbr_to) THEN ls_itnbr_to = ''

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

If Tab_1.SelectedTab = 1 Then
	dw_list.Retrieve(ls_saupj , ls_sdate ,ls_edate )
Else
	Choose Case ls_gubun 
		Case 'D0'
			ldw_x = dw_d0
			ls_gubun = 'D0'
		Case 'CKD0'
			ldw_x = dw_ckd0
			ls_gubun = 'D0'
		Case 'D1'
			ldw_x = dw_d1
			ls_gubun = 'D1'
		Case 'CKD1'
			ldw_x = dw_ckd1
			ls_gubun = 'D1'
		Case 'D2'
			ldw_x = dw_d2
			ls_gubun = 'D2'
		Case 'CKD2'
			ldw_x = dw_ckd2
			ls_gubun = 'D2'
		Case 'D6'
			ldw_x = dw_d68
			ls_gubun = 'D6'
		Case 'D8'
			ldw_x = dw_d68
			ls_gubun = 'D8'
		Case 'CKD6'
			ldw_x = dw_ckd68
			ls_gubun = 'D6'
		Case 'CKD8'
			ldw_x = dw_ckd68
			ls_gubun = 'D8'
		Case 'D9'
			ldw_x = dw_d9
			ls_gubun = 'D9'
		Case 'CKD9'
			ldw_x = dw_ckd9
			ls_gubun = 'D9'
		Case 'DH'
			ldw_x = dw_dh
			ls_gubun = 'DH'
		Case 'P6'
			ldw_x = dw_p6
			ls_gubun = 'P6'
		Case 'P7'
			ldw_x = dw_p7
			ls_gubun = 'P7'
		
	End Choose
	
	//Messagebox('',ls_saupj_cust +'  '+ ls_gubun+'  '+ls_sdate +'  '+ls_gubun+'  '+ls_edate+'  '+ ls_from+'  '+ ls_to +'  '+ ls_factory +'  '+ ls_cvcod+'  '+ string(li_no)  )
	
	ldw_x.Retrieve(ls_saupj_cust , ls_gubun+ls_sdate ,ls_gubun+ls_edate, ls_from, ls_to , ls_factory ,  li_no )
End IF

Return 1
end function

public function string wf_choose (string as_gubun);

Choose Case as_gubun
	Case 'D0'
		If Tab_1.SelectedTab = 2 Then
			dw_d0.x = dw_list.x
			dw_d0.y = dw_list.y
			dw_d0.width  = dw_list.width
			dw_d0.height = dw_list.height
			
			dw_list.visible = False
			
			dw_d0.visible = True
			dw_d2.visible = False
			dw_ckd2.visible = False					
			dw_dc.visible = false
			dw_d68.visible = False
			dw_ckd68.visible = False
			dw_gi.visible = False
			dw_ckd0.visible = False						
			dw_dh.visible = False
			dw_p6.visible = False
			dw_p7.visible = False
			dw_d1.visible = False
			dw_d9.visible = False
			dw_d3.visible = False
			dw_ckd1.visible = False
			dw_ckd9.visible = False			
		End If
		return 'C:\HKC\VAN\ERPD0.CSV'
	Case 'CKD0'
		If Tab_1.SelectedTab = 2 Then
			dw_ckd0.x = dw_list.x
			dw_ckd0.y = dw_list.y
			dw_ckd0.width  = dw_list.width
			dw_ckd0.height = dw_list.height
			
			dw_list.visible = False
			
			dw_d0.visible = False
			dw_ckd0.visible = True						
			dw_d2.visible = False
			dw_ckd2.visible = False					
			dw_dc.visible = false
			dw_d68.visible = False
			dw_ckd68.visible = False
			dw_gi.visible = False
			dw_dh.visible = False
			dw_p6.visible = False
			dw_p7.visible = False
			dw_d1.visible = False
			dw_d9.visible = False
			dw_d3.visible = False
			dw_ckd1.visible = False
			dw_ckd9.visible = False			
		End If
		return 'C:\HKC\VAN\CKDD0.CSV'
	Case 'D2'
		If Tab_1.SelectedTab = 2 Then
			dw_d2.x = dw_list.x
			dw_d2.y = dw_list.y
			dw_d2.width  = dw_list.width
			dw_d2.height = dw_list.height
			
			dw_list.visible = False
			
			dw_d0.visible = False
			dw_d2.visible = True
			dw_ckd2.visible = False					
			dw_dc.visible = false	
			dw_d68.visible = False
			dw_ckd68.visible = False
			dw_gi.visible = False
			dw_ckd0.visible = False						
			dw_dh.visible = False
			dw_p6.visible = False
			dw_p7.visible = False
			dw_d1.visible = False
			dw_d9.visible = False
			dw_d3.visible = False
			dw_ckd1.visible = False
			dw_ckd9.visible = False			
		End If
		return 'C:\HKC\VAN\ERPD2.CSV'
	Case 'CKD2'
		If Tab_1.SelectedTab = 2 Then
			dw_ckd2.x = dw_list.x
			dw_ckd2.y = dw_list.y
			dw_ckd2.width  = dw_list.width
			dw_ckd2.height = dw_list.height
			
			dw_list.visible = False
			
			dw_d0.visible = False
			dw_d2.visible = False
			dw_ckd2.visible = True					
			dw_dc.visible = false	
			dw_d68.visible = False
			dw_ckd68.visible = False
			dw_gi.visible = False
			dw_ckd0.visible = False						
			dw_dh.visible = False
			dw_p6.visible = False
			dw_p7.visible = False
			dw_d1.visible = False
			dw_d9.visible = False
			dw_d3.visible = False
			dw_ckd1.visible = False
			dw_ckd9.visible = False			
		End If
		return 'C:\HKC\VAN\CKDD2.CSV'
	Case 'DC'
		If Tab_1.SelectedTab = 2 Then
			dw_dc.x = dw_list.x
			dw_dc.y = dw_list.y
			dw_dc.width  = dw_list.width
			dw_dc.height = dw_list.height
			
			dw_list.visible = False
			
			dw_d0.visible = False
			dw_d2.visible = false
			dw_ckd2.visible = False					
			dw_dc.visible = True			
			dw_d68.visible = False
			dw_ckd68.visible = False
			dw_gi.visible = False
			dw_ckd0.visible = False						
			dw_dh.visible = False
			dw_p6.visible = False
			dw_p7.visible = False
			dw_d1.visible = False
			dw_d9.visible = False
			dw_d3.visible = False
			dw_ckd1.visible = False
			dw_ckd9.visible = False			
		End If
		return 'C:\HKC\VAN\HKCDC.TXT'

	Case 'D6'
		If Tab_1.SelectedTab = 2 Then
			dw_d68.x = dw_list.x
			dw_d68.y = dw_list.y
			dw_d68.width  = dw_list.width
			dw_d68.height = dw_list.height
			
			dw_list.visible = False
			
			dw_d0.visible = False
			dw_d2.visible = False
			dw_ckd2.visible = False					
			dw_dc.visible = false
			dw_d68.visible = True
			dw_ckd68.visible = False
			dw_gi.visible = False
			dw_ckd0.visible = False						
			dw_dh.visible = False
			dw_p6.visible = False
			dw_p7.visible = False
			dw_d1.visible = False
			dw_d9.visible = False
			dw_d3.visible = False
			dw_ckd1.visible = False
			dw_ckd9.visible = False			
		End if
		return 'C:\HKC\VAN\ERPD6.CSV'
		
	Case 'CKD6'
		If Tab_1.SelectedTab = 2 Then
			dw_ckd68.x = dw_list.x
			dw_ckd68.y = dw_list.y
			dw_ckd68.width  = dw_list.width
			dw_ckd68.height = dw_list.height
			
			dw_list.visible = False
			
			dw_d0.visible = False
			dw_d2.visible = False
			dw_ckd2.visible = False					
			dw_dc.visible = false
			dw_d68.visible = false
			dw_ckd68.visible = True
			dw_gi.visible = False
			dw_ckd0.visible = False						
			dw_dh.visible = False
			dw_p6.visible = False
			dw_p7.visible = False
			dw_d1.visible = False
			dw_d9.visible = False
			dw_d3.visible = False
			dw_ckd1.visible = False
			dw_ckd9.visible = False			
		End if
		return 'C:\HKC\VAN\CKDD6.CSV'

	Case 'D8'
		If Tab_1.SelectedTab = 2 Then
			dw_d68.x = dw_list.x
			dw_d68.y = dw_list.y
			dw_d68.width  = dw_list.width
			dw_d68.height = dw_list.height
			
			dw_list.visible = False
			
			dw_d0.visible = False
			dw_d2.visible = False
			dw_ckd2.visible = False					
			dw_dc.visible = false
			dw_d68.visible = True
			dw_ckd68.visible = False
			dw_gi.visible = False
			dw_ckd0.visible = False						
			dw_dh.visible = False
			dw_p6.visible = False
			dw_p7.visible = False
			dw_d1.visible = False
			dw_d9.visible = False
			dw_d3.visible = False
			dw_ckd1.visible = False
			dw_ckd9.visible = False			
		End If
		return 'C:\HKC\VAN\ERPD8.CSV'	
	Case 'CKD8'
		If Tab_1.SelectedTab = 2 Then
			dw_ckd68.x = dw_list.x
			dw_ckd68.y = dw_list.y
			dw_ckd68.width  = dw_list.width
			dw_ckd68.height = dw_list.height
			
			dw_list.visible = False
			
			dw_d0.visible = False
			dw_d2.visible = False
			dw_ckd2.visible = False					
			dw_dc.visible = false
			dw_d68.visible = false
			dw_ckd68.visible = True
			dw_gi.visible = False
			dw_ckd0.visible = False						
			dw_dh.visible = False
			dw_p6.visible = False
			dw_p7.visible = False
			dw_d1.visible = False
			dw_d9.visible = False
			dw_d3.visible = False
			dw_ckd1.visible = False
			dw_ckd9.visible = False			
		End If
		return 'C:\HKC\VAN\CKDD8.CSV'	
	Case 'DH'
		If Tab_1.SelectedTab = 2 Then
			dw_dh.x = dw_list.x
			dw_dh.y = dw_list.y
			dw_dh.width  = dw_list.width
			dw_dh.height = dw_list.height
			dw_list.visible = False
			
			dw_d0.visible = False
			dw_d2.visible = False
			dw_ckd2.visible = False					
			dw_dc.visible = false
			dw_d68.visible = False
			dw_ckd68.visible = False
			dw_gi.visible = False
			dw_ckd0.visible = False			
			dw_dh.visible = True
			dw_p6.visible = False
			dw_p7.visible = False
			dw_d1.visible = False
			dw_d9.visible = False
			dw_d3.visible = False
			dw_ckd1.visible = False
			dw_ckd9.visible = False			
		End IF
		return 'C:\HKC\VAN\ERPDH.CSV'
	Case 'P6'
		If Tab_1.SelectedTab = 2 Then
			dw_p6.x = dw_list.x
			dw_p6.y = dw_list.y
			dw_p6.width  = dw_list.width
			dw_p6.height = dw_list.height
			dw_list.visible = False
			
			dw_d0.visible = False
			dw_d2.visible = False
			dw_ckd2.visible = False					
			dw_dc.visible = false
			dw_d68.visible = False
			dw_ckd68.visible = False
			dw_gi.visible = False
			dw_ckd0.visible = False						
			dw_dh.visible = False
			dw_p6.visible = True
			dw_p7.visible = False
			dw_d1.visible = False
			dw_d9.visible = False
			dw_d3.visible = False
			dw_ckd1.visible = False
			dw_ckd9.visible = False			
		End IF
		return 'C:\HKC\VAN\ERPP6.CSV'
	Case 'P7'
		If Tab_1.SelectedTab = 2 Then
			dw_p7.x = dw_list.x
			dw_p7.y = dw_list.y
			dw_p7.width  = dw_list.width
			dw_p7.height = dw_list.height
			dw_list.visible = False
			
			dw_d0.visible = False
			dw_d2.visible = False
			dw_ckd2.visible = False					
			dw_dc.visible = false
			dw_d68.visible = False
			dw_ckd68.visible = False
			dw_gi.visible = False
			dw_ckd0.visible = False						
			dw_dh.visible = False
			dw_p6.visible = False
			dw_p7.visible = True
			dw_d1.visible = False
			dw_d9.visible = False
			dw_d3.visible = False
			dw_ckd1.visible = False
			dw_ckd9.visible = False			
		End IF
		return 'C:\HKC\VAN\ERPP7.CSV'
	Case 'D1'
		If Tab_1.SelectedTab = 2 Then
			dw_d1.x = dw_list.x
			dw_d1.y = dw_list.y
			dw_d1.width  = dw_list.width
			dw_d1.height = dw_list.height
			dw_list.visible = False
			
			dw_d0.visible = False
			dw_d2.visible = False
			dw_ckd2.visible = False					
			dw_dc.visible = false
			dw_d68.visible = False
			dw_ckd68.visible = False
			dw_gi.visible = False
			dw_ckd0.visible = False						
			dw_dh.visible = False
			dw_p6.visible = False
			dw_p7.visible = False
			dw_d1.visible = True
			dw_d9.visible = False
			dw_d3.visible = False
			dw_ckd1.visible = False
			dw_ckd9.visible = False			
		End If
		return 'C:\HKC\VAN\ERPD1.CSV'
	Case 'CKD1'
		If Tab_1.SelectedTab = 2 Then
			dw_ckd1.x = dw_list.x
			dw_ckd1.y = dw_list.y
			dw_ckd1.width  = dw_list.width
			dw_ckd1.height = dw_list.height
			dw_list.visible = False
			
			dw_d0.visible = False
			dw_d2.visible = False
			dw_ckd2.visible = False					
			dw_dc.visible = false
			dw_d68.visible = False
			dw_ckd68.visible = False
			dw_gi.visible = False
			dw_ckd0.visible = False						
			dw_dh.visible = False
			dw_p6.visible = False
			dw_p7.visible = False
			dw_d1.visible = False
			dw_d9.visible = False
			dw_d3.visible = False
			dw_ckd1.visible = True
			dw_ckd9.visible = False			
		End If
		return 'C:\HKC\VAN\CKDD1.CSV'
	Case 'D9'
		If Tab_1.SelectedTab = 2 Then
			dw_d9.x = dw_list.x
			dw_d9.y = dw_list.y
			dw_d9.width  = dw_list.width
			dw_d9.height = dw_list.height
			dw_list.visible = False
			
			dw_d0.visible = False
			dw_d2.visible = False
			dw_ckd2.visible = False					
			dw_dc.visible = false
			dw_d68.visible = False
			dw_ckd68.visible = False
			dw_gi.visible = False
			dw_ckd0.visible = False						
			dw_dh.visible = False
			dw_p6.visible = False
			dw_p7.visible = False
			dw_d1.visible = False
			dw_d9.visible = True
			dw_d3.visible = False
			dw_ckd1.visible = False
			dw_ckd9.visible = False			
		End If
		return 'C:\HKC\VAN\ERPD9.CSV'
	Case 'CKD9'
		If Tab_1.SelectedTab = 2 Then
			dw_ckd9.x = dw_list.x
			dw_ckd9.y = dw_list.y
			dw_ckd9.width  = dw_list.width
			dw_ckd9.height = dw_list.height
			dw_list.visible = False
			
			dw_d0.visible = False
			dw_d2.visible = False
			dw_ckd2.visible = False					
			dw_dc.visible = false
			dw_d68.visible = False
			dw_ckd68.visible = False
			dw_gi.visible = False
			dw_ckd0.visible = False						
			dw_dh.visible = False
			dw_p6.visible = False
			dw_p7.visible = False
			dw_d1.visible = False
			dw_d9.visible = False
			dw_d3.visible = False
			dw_ckd1.visible = False
			dw_ckd9.visible = True			
		End If
		return 'C:\HKC\VAN\CKDD9.CSV'
	
	Case Else
//		If Tab_1.SelectedTab = 2 Then
//			//Tab_1.SelectedTab = 1
//		End IF


		dw_d0.visible = False
		dw_d2.visible = False
		dw_ckd2.visible = False					
		dw_dc.visible = false
		dw_d68.visible = False
		dw_ckd68.visible = False
		dw_gi.visible = False
		dw_ckd0.visible = False					
		dw_dh.visible = False
		dw_p6.visible = False
		dw_p7.visible = False
		dw_d1.visible = False
		dw_d9.visible = False
		dw_d3.visible = False
		dw_ckd1.visible = False
		dw_ckd9.visible = False			
		
		dw_list.visible = True

		return 'C:\HKC\VAN'
		
End Choose
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

public function integer wf_csv_split (string arg_text, ref string arg_data[], integer arg_num);long		i, j=1, k, m, n
string	str

m = len(arg_text)
if m <= 0 then return 0

// 배열초기화
for i = 1 to arg_num
	setnull(arg_data[i])
next

// CSV문자자르기
for i = 1 to arg_num
	k = pos(arg_text,',',j+n)
	if k > 0 then
		//문자표시(따옴표)제거
		str = mid(arg_text,j,k -j)
		if left(str,1) = '"' then str = mid(str,2,len(str) -2)		
		arg_data[i] = trim(str)
		j = k+1

		//문자표시(따옴표)내 콤마건너뛰기
		if mid(arg_text,k+1,1) = '"' then
			n = pos(arg_text,'"',k+2) -j
		else
			n = 0
		end if
	else
		str = mid(arg_text,j)
		if left(str,1) = '"' then str = mid(str,2,len(str) -2)
		arg_data[i] = trim(str)
		i = arg_num
	end if
	
//	//공장코드 대체 - 임시
//	if arg_data[i] = 'HE21' then arg_data[i] = 'HE'
//	if arg_data[i] = 'HK21' then arg_data[i] = 'HK'
//	if arg_data[i] = 'HV21' then arg_data[i] = 'HV'
next

return 1
end function

public function integer wf_erp_d0 (string arg_gubun, string arg_file_name);integer 	li_FileNum, li_data, li_rtn, li_cnt
string 	ls_data[], ls_crt_date, ls_crt_time, ls_crt_user, ls_Input_Data
string	ls_mitnbr, ls_mcvcod, ls_mdcvcod

//현재일자,시간
ls_crt_date = string(today(),'yyyymmdd')
ls_crt_time = string(today(),'hhmm')
ls_crt_user = gs_userid 

li_FileNum = FileOpen(arg_file_name,LineMode!,Read!)
if li_FileNum = -1 then
	wf_error(arg_gubun,li_cnt,'','','',"["+arg_file_name+"]"+" VAN자료가 없습니다.!!")
	FileClose(li_FileNum)
	return -1
end if

li_data = 0
il_err = 0
st_state.Visible = True
st_state.Text = '데이타를 읽는 중입니다...'

Do While	FileRead(li_FileNum, ls_Input_Data) <> -100	
	li_data++
	
	li_rtn = wf_csv_split(ls_Input_Data, ls_data, 24)

	//기등록자료CHECK
	SELECT COUNT(*) INTO :li_cnt
	  FROM VAN_ERPD0
    WHERE SABU		= :gs_sabu
	 	AND DOCCODE = :ls_data[1]
		AND CUSTCD  = :ls_data[2]
		AND FACTORY = :ls_data[3]
		AND ITNBR   = :ls_data[4] ;

	If li_rtn > 0 And li_cnt = 0 Then
		//참조값(품번,거래처)가져오기
		if wf_ref_code(arg_gubun, ls_data[2], ls_data[3], ls_data[4], ls_mitnbr, ls_mcvcod, ls_mdcvcod) = -1 then
			wf_error(arg_gubun,li_data,ls_data[1],ls_data[3],ls_data[4],'참조코드가 없습니다.')
			il_err++
			Continue ;
		end if
		
		INSERT INTO VAN_ERPD0
		(SABU	,			DOCCODE	,			CUSTCD	,			FACTORY	,			ITNBR	,			HFR_DATE	,			HTO_DATE	,
		 ITDSC	,		UNMSR	,				NEWITS	,			CARCODE	,			CONTAINGU	,	CONTAINQTY	,		LOCATSITE	,
		 RES_USER	,	CONTAINQTY1	,		INSPYN	,			BALJUGU	,			SILGU	,			PRTGBN	,			MULGBN	,
		 LINEGBN	,		SEOGBN	,			GUMENO	,			GUITNO	,			CITNBR	,		MITNBR	,			MCVCOD	,
		 MDCVCOD	,		CRT_DATE	,			CRT_TIME	,			CRT_USER	)
		VALUES    
		(:gs_sabu	,	:ls_data[1],		:ls_data[2],		:ls_data[3],		:ls_data[4],	:ls_data[5]	,		:ls_data[6]	,
		 :ls_data[7],	:ls_data[8],		:ls_data[9],		:ls_data[10],		:ls_data[11],	:ls_data[12],		:ls_data[13]	,
		 :ls_data[14],	:ls_data[15],		:ls_data[16],		:ls_data[17],		:ls_data[18],	:ls_data[19],		:ls_data[20]	,
		 :ls_data[21],	:ls_data[22],		:ls_data[23],		:ls_data[24],		NULL	,			:ls_mitnbr, 		:ls_mcvcod, 
		 :ls_mdcvcod,	:ls_crt_date	,	:ls_crt_time	,	:ls_crt_user	) ;
	
		if sqlca.sqlcode <> 0 then	 
			st_state.Visible = False
			wf_error(arg_gubun,li_data,ls_data[1],ls_data[3],ls_data[4],sqlca.sqlerrText+" 입력에러가 발생했습니다." + '[열위치:'+string(li_data)+']')
			Rollback;
			FileClose(li_FileNum)
			return -3
		end if
		il_succeed++
	End If
	
	st_state.Text = "파일명: "+Right(arg_file_name,9) +"  라인수 :" +String(li_data)
	
Loop

FileClose(li_FileNum)
commit;

st_state.Visible = False
return li_data

end function

public function integer wf_ckd_d0 (string arg_gubun, string arg_file_name);integer 	li_FileNum, li_data, li_rtn, li_cnt
string 	ls_data[], ls_crt_date, ls_crt_time, ls_crt_user, ls_Input_Data
string	ls_mitnbr, ls_mcvcod, ls_mdcvcod

//현재일자,시간
ls_crt_date = string(today(),'yyyymmdd')
ls_crt_time = string(today(),'hhmm')
ls_crt_user = gs_userid 

li_FileNum = FileOpen(arg_file_name,LineMode!,Read!)
if li_FileNum = -1 then
	wf_error(arg_gubun,li_cnt,'','','',"["+arg_file_name+"]"+" VAN자료가 없습니다.!!")
	FileClose(li_FileNum)
	return -1
end if

li_data = 0
il_err = 0
st_state.Visible = True
st_state.Text = '데이타를 읽는 중입니다...'

Do While	FileRead(li_FileNum, ls_Input_Data) <> -100	
	li_data++
	
	li_rtn = wf_csv_split(ls_Input_Data, ls_data, 15)

	//기등록자료CHECK
	SELECT COUNT(*) INTO :li_cnt
	  FROM VAN_CKDD0
    WHERE SABU		= :gs_sabu
	 	AND DOCCODE = :ls_data[1]
		AND CUSTCD  = :ls_data[3]
		AND FACTORY = :ls_data[2]
		AND ITNBR   = :ls_data[5] ;

	If li_rtn > 0 And li_cnt = 0 Then
		//참조값(품번,거래처)가져오기
		if wf_ref_code(arg_gubun, ls_data[3], ls_data[2], ls_data[5], ls_mitnbr, ls_mcvcod, ls_mdcvcod) = -1 then
			wf_error(arg_gubun,li_data,ls_data[1],ls_data[2],ls_data[5],'참조코드가 없습니다.')
			il_err++
			Continue ;
		end if
		
		INSERT INTO VAN_CKDD0
		(SABU	,			DOCCODE	,			CUSTCD	,			FACTORY	,			JTYPE	,			ITNBR	,				ITDSC	,
		 UNMSR	,		CONTAINGU	,		CONTAINQTY	,		INSPYN	,			PACKSPEC	,		JILCODE	,			JILDESC	,
		 SPECGBN	,		PACKGBN	,			CITNBR	,			MITNBR	,			MCVCOD	,		MDCVCOD	,			CRT_DATE	,
		 CRT_TIME	,	CRT_USER	)
		VALUES    
		(:gs_sabu	,	:ls_data[1],		:ls_data[3],		:ls_data[2],		:ls_data[4],	:ls_data[5]	,		:ls_data[6]	,
		 :ls_data[7],	:ls_data[8],		:ls_data[9],		:ls_data[10],		:ls_data[11],	:ls_data[12],		:ls_data[13]	,
		 :ls_data[14],	:ls_data[15],		NULL,					:ls_mitnbr,			:ls_mcvcod	,	:ls_mdcvcod	,		:ls_crt_date	,	
		 :ls_crt_time,	:ls_crt_user	) ;
	
		if sqlca.sqlcode <> 0 then	 
			st_state.Visible = False
			wf_error(arg_gubun,li_data,ls_data[1],ls_data[2],ls_data[5],sqlca.sqlerrText+" 입력에러가 발생했습니다." + '[열위치:'+string(li_data)+']')
			Rollback;
			FileClose(li_FileNum)
			return -3
		end if
		il_succeed++
	End If
	
	st_state.Text = "파일명: "+Right(arg_file_name,9) +"  라인수 :" +String(li_data)
	
Loop

FileClose(li_FileNum)
commit;

st_state.Visible = False
return li_data

end function

public function integer wf_erp_d1 (string arg_gubun, string arg_file_name);integer 	li_FileNum, li_data, li_rtn, li_cnt
string 	ls_data[], ls_crt_date, ls_crt_time, ls_crt_user, ls_Input_Data
string	ls_mitnbr, ls_mcvcod, ls_mdcvcod, ls_new
Long     ll_cnt
Double   ld_price
Double   ld_14

//현재일자,시간
ls_crt_date = string(today(),'yyyymmdd')
ls_crt_time = string(today(),'hhmm')
ls_crt_user = gs_userid 

li_FileNum = FileOpen(arg_file_name,LineMode!,Read!)
if li_FileNum = -1 then
	wf_error(arg_gubun,li_cnt,'','','',"["+arg_file_name+"]"+" VAN자료가 없습니다.!!")
	FileClose(li_FileNum)
	return -1
end if

li_data = 0
il_err = 0
st_state.Visible = True
st_state.Text = '데이타를 읽는 중입니다...'

Do While	FileRead(li_FileNum, ls_Input_Data) <> -100	
	li_data++
	
	li_rtn = wf_csv_split(ls_Input_Data, ls_data, 34)

	//기등록자료CHECK
	SELECT COUNT(*) INTO :li_cnt
	  FROM VAN_ERPD1
    WHERE SABU		= :gs_sabu
	 	AND DOCCODE = :ls_data[1]
		AND CUSTCD  = :ls_data[2]
		AND FACTORY = :ls_data[3]
		AND ITNBR   = :ls_data[4]
		AND IPSOURCE = :ls_data[8]
		//AND IPGUBUN = :ls_data[9] PK값이 아님. - BY SHINGOON 2013.11.05
		AND JAJENO  = :ls_data[25]
		AND JAITNO  = :ls_data[26] ;

	If li_rtn > 0 And li_cnt = 0 Then
		//참조값(품번,거래처)가져오기
		if wf_ref_code(arg_gubun, ls_data[2], ls_data[3], ls_data[4], ls_mitnbr, ls_mcvcod, ls_mdcvcod) = -1 then
			wf_error(arg_gubun,li_data,ls_data[1],ls_data[3],ls_data[4],'참조코드가 없습니다.')
			il_err++
			Continue ;
		end if

		INSERT INTO VAN_ERPD1
		(SABU	,			DOCCODE	,			CUSTCD	,			FACTORY	,			ITNBR	,			IPHDATE	,			NAPJPNO	,
		 NAPSEQ	,		IPNO	,				IPSOURCE	,			IPGUBUN	,			IPHQTY	,		IPQTY	,				IPAMT	,
		 IPBAD_CD	,	CONFIRM_NO	,		IPDAN	,				IPDATE	,			ORDERNO	,		GUMENO	,			GUITNO	,
		 LC_CHA	,		LC_CHAQTY	,		LC_CHASUM	,		LC_NO	,				PACKDAN	,		PACKQTY	,			SHOPCODE	,
		 JAJENO	,		JAITNO	,			JAJEYM	,			IPSEQ	,				SUBSEQ	,		FIL	,				CITNBR	,
		 MITNBR	,		MCVCOD	,			MDCVCOD	,			CRT_DATE	,			CRT_TIME	,		CRT_USER	,			CITNBR_MON	,
		 IOJPNO	,		WON	)
		VALUES    
		(:gs_sabu	,	:ls_data[1],		:ls_data[2],		:ls_data[3],		:ls_data[4],	:ls_data[5]	,		:ls_data[6]	,
		 :ls_data[7],	1,						:ls_data[8],		:ls_data[9],		:ls_data[10],	:ls_data[11],		:ls_data[12],	
		 :ls_data[13], NULL,					:ls_data[14],		:ls_data[15],		NULL,				:ls_data[16],		:ls_data[17],
		 :ls_data[18],	:ls_data[19],		:ls_data[20]	,  :ls_data[21],		:ls_data[22],	:ls_data[23],		:ls_data[24],
		 :ls_data[25],	:ls_data[26],		:ls_data[27]	,  1,						1,					:ls_data[29],		NULL	,			
		 :ls_mitnbr, 	:ls_mcvcod, 		:ls_mdcvcod,		:ls_crt_date	,	:ls_crt_time,	:ls_crt_user,		NULL	,
		 NULL,			:ls_data[28]	) ;
	
		if sqlca.sqlcode <> 0 then	 
			st_state.Visible = False
			wf_error(arg_gubun,li_data,ls_data[1],ls_data[3],ls_data[4],sqlca.sqlerrText+" 입력에러가 발생했습니다." + '[열위치:'+string(li_data)+']')
			Rollback;
			FileClose(li_FileNum)
			return -3
		end if
	
		ld_14 = Double(ls_data[14])
		
		/* 아산 VAN D1 접수 시 vnddan 변동단가 insert - 2009.05.22 by shingoon */
		If ld_14 > 0 AND LEFT(ls_data[9], 1) = 'A' Then
			/* 단가 Update *******************************************************************/
	
			Select fun_vnddan_danga(:ls_data[15], :ls_mitnbr, :ls_mcvcod)
			  Into :ld_price From dual ;
			  
			if ld_price <> ld_14 then
				ls_new = 'Y'
			else
				ls_new = 'N'
			end if
	
			Select Count(*) Into :ll_cnt From vnddan 
			 Where cvcod = :ls_mcvcod and itnbr = :ls_mitnbr and start_date = :ls_data[15] ; 
		
			If ll_cnt > 0 Then
				ls_new = 'N'
			end if
	
			If ls_new = 'Y' Then
				
				If ls_data[3] = 'Y' Then
					Insert Into vnddan ( CVCOD       , ITNBR       , START_DATE  ,                                                      
												END_DATE    , SALES_PRICE , CURR ,
												BROAD_PRICE , BROAD_CURR  ,                                               
												CRT_DATE    , CRT_TIME    , CRT_USER,
												DANGU       , BIGO        )                                                           
									values(  :ls_mcvcod  , :ls_mitnbr , :ls_data[15] ,                                              
												'99991231'  , :ld_14 ,'WON' ,                                                             
												:ld_14   ,'WON' ,                                                     
												:is_today   , :is_totime , :gs_userid ,
												'1'         ,'0010' ) ; 
				Else
					Insert Into vnddan ( CVCOD       , ITNBR      , START_DATE  ,                                                      
												END_DATE    , SALES_PRICE, CURR ,
												BROAD_PRICE , BROAD_CURR ,                                               
												CRT_DATE    , CRT_TIME   , CRT_USER,
												DANGU       , BIGO         )                                                           
									values(  :ls_mcvcod  , :ls_mitnbr , :ls_data[15] ,                                              
												'99991231'  , :ld_14 ,'WON' ,                                                             
												0 ,'WON' ,                                                     
												:is_today ,:is_totime , :gs_userid ,
												'1'         ,'0010'  ) ; 
				End if
				
			End If
		
			If sqlca.sqlcode <> 0 Then
				st_state.Visible = False
				wf_error(arg_gubun,li_data,ls_data[1],ls_data[3],ls_data[4],"[단가입력 에러]"+sqlca.sqlerrText)
				/*wf_error(arg_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,"[단가입력 에러]"+sqlca.sqlerrText)*/
				rollback;
				FileClose(li_FileNum)
				return -3
			end if
		/*******************************************************************/
		END IF
		il_succeed++
	End If
	
	st_state.Text = "파일명: "+Right(arg_file_name,9) +"  라인수 :" +String(li_data)
	
Loop

FileClose(li_FileNum)
commit;

st_state.Visible = False
return li_data

end function

public function integer wf_ckd_d1 (string arg_gubun, string arg_file_name);integer 	li_FileNum, li_data, li_rtn, li_cnt
string 	ls_data[], ls_crt_date, ls_crt_time, ls_crt_user, ls_Input_Data
string	ls_mitnbr, ls_mcvcod, ls_mdcvcod, ls_new
Long     ll_cnt
Double   ld_price
Double   ld_14

//현재일자,시간
ls_crt_date = string(today(),'yyyymmdd')
ls_crt_time = string(today(),'hhmm')
ls_crt_user = gs_userid 

li_FileNum = FileOpen(arg_file_name,LineMode!,Read!)
if li_FileNum = -1 then
	wf_error(arg_gubun,li_cnt,'','','',"["+arg_file_name+"]"+" VAN자료가 없습니다.!!")
	FileClose(li_FileNum)
	return -1
end if

li_data = 0
il_err = 0
st_state.Visible = True
st_state.Text = '데이타를 읽는 중입니다...'

Do While	FileRead(li_FileNum, ls_Input_Data) <> -100	
	li_data++
	
	li_rtn = wf_csv_split(ls_Input_Data, ls_data, 16)

	//기등록자료CHECK
	SELECT COUNT(*) INTO :li_cnt
	  FROM VAN_CKDD1
    WHERE SABU		= :gs_sabu
	 	AND DOCCODE = :ls_data[1]
		AND CUSTCD  = :ls_data[3]
		AND FACTORY = :ls_data[2]
		AND ITNBR   = :ls_data[7]
		AND GUMENO  = :ls_data[9] ;

	If li_rtn > 0 And li_cnt = 0 Then
		//참조값(품번,거래처)가져오기
		if wf_ref_code(arg_gubun, ls_data[3], ls_data[2], ls_data[7], ls_mitnbr, ls_mcvcod, ls_mdcvcod) = -1 then
			wf_error(arg_gubun,li_data,ls_data[1],ls_data[2],ls_data[7],'참조코드가 없습니다.')
			il_err++
			Continue ;
		end if

		INSERT INTO VAN_CKDD1
		(SABU	,			DOCCODE	,			CUSTCD	,			FACTORY	,			JTYPE	,			ITNBR	,			IPHDATE	,
		 IPGDATE	,		UNMSR	,				GUMENO	,			ASNNO	,				ASNSEQ	,		IPGUBUN	,		IPHQTY	,
		 IPQTY	,		IPAMT	,				PACKAMT	,			CITNBR	,			MITNBR	,		MCVCOD	,		MDCVCOD	,
		 CRT_DATE	,	CRT_TIME	,			CRT_USER	,			CITNBR_MON	,		IOJPNO	,		WON	)
		VALUES    
		(:gs_sabu	,	:ls_data[1],		:ls_data[3],		:ls_data[2],		:ls_data[4],	:ls_data[7]	,	:ls_data[5]	,
		 :ls_data[6],	:ls_data[8],		:ls_data[9],		:ls_data[10],		:ls_data[11],	:ls_data[12],	:ls_data[13]	,
		 :ls_data[14],	:ls_data[15],		:ls_data[16],		NULL	,		 		:ls_mitnbr, 	:ls_mcvcod, 	:ls_mdcvcod	,
		 :ls_crt_date	,	:ls_crt_time,	:ls_crt_user,		NULL	,		 		NULL,				NULL	) ;
	
		if sqlca.sqlcode <> 0 then	 
			st_state.Visible = False
			wf_error(arg_gubun,li_data,ls_data[1],ls_data[3],ls_data[4],sqlca.sqlerrText+" 입력에러가 발생했습니다." + '[열위치:'+string(li_data)+']')
			Rollback;
			FileClose(li_FileNum)
			return -3
		end if
	
		ld_14 = Double(ls_data[14])
		
		/* 아산 VAN D1 접수 시 vnddan 변동단가 insert - 2009.05.22 by shingoon */
		If ld_14 > 0 AND LEFT(ls_data[9], 1) = 'A' Then
			/* 단가 Update *******************************************************************/
	
			Select fun_vnddan_danga(:ls_data[15], :ls_mitnbr, :ls_mcvcod)
			  Into :ld_price From dual ;
			  
			if ld_price <> ld_14 then
				ls_new = 'Y'
			else
				ls_new = 'N'
			end if
	
			Select Count(*) Into :ll_cnt From vnddan 
			 Where cvcod = :ls_mcvcod and itnbr = :ls_mitnbr and start_date = :ls_data[15] ; 
		
			If ll_cnt > 0 Then
				ls_new = 'N'
			end if
	
			If ls_new = 'Y' Then
				
				If ls_data[3] = 'Y' Then
					Insert Into vnddan ( CVCOD       , ITNBR       , START_DATE  ,                                                      
												END_DATE    , SALES_PRICE , CURR ,
												BROAD_PRICE , BROAD_CURR  ,                                               
												CRT_DATE    , CRT_TIME    , CRT_USER,
												DANGU       , BIGO        )                                                           
									values(  :ls_mcvcod  , :ls_mitnbr , :ls_data[15] ,                                              
												'99991231'  , :ld_14 ,'WON' ,                                                             
												:ld_14   ,'WON' ,                                                     
												:is_today   , :is_totime , :gs_userid ,
												'1'         ,'0010' ) ; 
				Else
					Insert Into vnddan ( CVCOD       , ITNBR      , START_DATE  ,                                                      
												END_DATE    , SALES_PRICE, CURR ,
												BROAD_PRICE , BROAD_CURR ,                                               
												CRT_DATE    , CRT_TIME   , CRT_USER,
												DANGU       , BIGO         )                                                           
									values(  :ls_mcvcod  , :ls_mitnbr , :ls_data[15] ,                                              
												'99991231'  , :ld_14 ,'WON' ,                                                             
												0 ,'WON' ,                                                     
												:is_today ,:is_totime , :gs_userid ,
												'1'         ,'0010'  ) ; 
				End if
				
			End If
		
			If sqlca.sqlcode <> 0 Then
				st_state.Visible = False
				wf_error(arg_gubun,li_data,ls_data[1],ls_data[3],ls_data[4],"[단가입력 에러]"+sqlca.sqlerrText)
				/*wf_error(arg_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,"[단가입력 에러]"+sqlca.sqlerrText)*/
				rollback;
				FileClose(li_FileNum)
				return -3
			end if
		/*******************************************************************/
		END IF
		il_succeed++
	End If
	
	st_state.Text = "파일명: "+Right(arg_file_name,9) +"  라인수 :" +String(li_data)
	
Loop

FileClose(li_FileNum)
commit;

st_state.Visible = False
return li_data

end function

public function integer wf_erp_d2 (string arg_gubun, string arg_file_name);integer 	li_FileNum, li_data, li_rtn, li_cnt
string 	ls_data[], ls_crt_date, ls_crt_time, ls_crt_user, ls_Input_Data
string	ls_mitnbr, ls_mcvcod, ls_mdcvcod

//현재일자,시간
ls_crt_date = string(today(),'yyyymmdd')
ls_crt_time = string(today(),'hhmm')
ls_crt_user = gs_userid 

li_FileNum = FileOpen(arg_file_name,LineMode!,Read!)
if li_FileNum = -1 then
	wf_error(arg_gubun,li_cnt,'','','',"["+arg_file_name+"]"+" VAN자료가 없습니다.!!")
	FileClose(li_FileNum)
	return -1
end if

li_data = 0
il_err = 0
st_state.Visible = True
st_state.Text = '데이타를 읽는 중입니다...'

Do While	FileRead(li_FileNum, ls_Input_Data) <> -100	
	li_data++
	
	li_rtn = wf_csv_split(ls_Input_Data, ls_data, 91)

	//기등록자료CHECK
	SELECT COUNT(*) INTO :li_cnt
	  FROM VAN_ERPD2
    WHERE SABU		= :gs_sabu
	 	AND DOCCODE = :ls_data[1]
		AND CUSTCD  = :ls_data[2]
		AND FACTORY = :ls_data[3]
		AND ITNBR   = :ls_data[4] ;

	If li_rtn > 0 And li_cnt = 0 Then
		//참조값(품번,거래처)가져오기
		if wf_ref_code(arg_gubun, ls_data[2], ls_data[3], ls_data[4], ls_mitnbr, ls_mcvcod, ls_mdcvcod) = -1 then
			wf_error(arg_gubun,li_data,ls_data[1],ls_data[3],ls_data[4],'참조코드가 없습니다.')
			il_err++
			Continue ;
		end if

		INSERT INTO VAN_ERPD2
		(SABU	,					DOCCODE	,			CUSTCD	,				FACTORY	,				ITNBR	,					CUR_STOCK	,			ACTUAL_STOCK	,
		 PREV_RESULT	,		PLAN_D8HQTY	,		PLAN_D10HQTY	,		PLAN_D13HQTY	,		PLAN_D15HQTY	,		PLAN_D18HQTY	,		PLAN_D21HQTY	,
		 PLAN_D23HQTY	,		PLAN_D2HQTY	,		PLAN_D4HQTY	,			PLAN_D6HQTY	,			PLAN_DQTY	,			PLAN_D1QTY1	,			PLAN_D1QTY2	,
		 PLAN_D1QTY3	,		PLAN_D1QTY4	,		PLAN_D1QTY5	,			PLAN_D1QTY6	,			PLAN_D1QTY7	,			PLAN_D1QTY8	,			PLAN_D1QTY9	,
		 PLAN_D1QTY10	,		PLAN_D1TQTY	,		PLAN_D2QTY1	,			PLAN_D2QTY2	,			PLAN_D2QTY3	,			PLAN_D2QTY4	,			PLAN_D2QTY5	,
		 PLAN_D2QTY6	,		PLAN_D2QTY7	,		PLAN_D2QTY8	,			PLAN_D2QTY9	,			PLAN_D2QTY10	,		PLAN_D2TQTY	,			PLAN_D3QTY1	,
		 PLAN_D3QTY2	,		PLAN_D3QTY3	,		PLAN_D3QTY4	,			PLAN_D3QTY5	,			PLAN_D3QTY6	,			PLAN_D3QTY7	,			PLAN_D3QTY8	,
		 PLAN_D3QTY9	,		PLAN_D3QTY10	,	PLAN_D3TQTY	,			PLAN_D4QTY1	,			PLAN_D4QTY2	,			PLAN_D4QTY3	,			PLAN_D4QTY4	,
		 PLAN_D4QTY5	,		PLAN_D4QTY6	,		PLAN_D4QTY7	,			PLAN_D4QTY8	,			PLAN_D4QTY9	,			PLAN_D4QTY10	,		PLAN_D4TQTY	,
		 PLAN_D5QTY	,			PLAN_D6QTY	,		PLAN_D7QTY	,			PLAN_D8QTY	,			PLAN_D9QTY	,			PLAN_D10QTY	,			PLAN_D11QTY	,
		 PLAN_D12QTY	,		PLAN_D13QTY	,		PLAN_D14QTY	,			PLAN_D15QTY	,			PLAN_D16QTY	,			PLAN_D17QTY	,			PLAN_D18QTY	,
		 PLAN_D19QTY	,		PLAN_D20QTY	,		PLAN_D21QTY	,			PLAN_D22QTY	,			PLAN_D23QTY	,			PLAN_D24QTY	,			PLAN_D25QTY	,
		 PLAN_D26QTY	,		PLAN_D27QTY	,		PLAN_D28QTY	,			PLAN_D29QTY	,			PLAN_D30QTY	,			PLAN_D45QTY	,			TODAY_IPQTY	,
		 ORDER_TYPE	,			CRT_DATE	,			CRT_TIME	,				CRT_USER	,				CITNBR	,				MITNBR	,				MCVCOD	,
		 MDCVCOD	)
		VALUES    
		(:gs_sabu	,			:ls_data[1],		:ls_data[2],			:ls_data[3],			:ls_data[4],			:ls_data[5]	,		:ls_data[6]	,
		 :ls_data[7],			:ls_data[8],		:ls_data[9],			:ls_data[10],			:ls_data[11],			:ls_data[12],		:ls_data[13]	,
		 :ls_data[14],			:ls_data[15],		:ls_data[16],			:ls_data[17],			:ls_data[18],			:ls_data[19],		:ls_data[20]	,
		 :ls_data[21],			:ls_data[22],		:ls_data[23],			:ls_data[24],			:ls_data[25],			:ls_data[26],		:ls_data[27]	,
		 :ls_data[28],			:ls_data[29],		:ls_data[30],			:ls_data[31],			:ls_data[32],			:ls_data[33],		:ls_data[34]	,
		 :ls_data[35],			:ls_data[36],		:ls_data[37],			:ls_data[38],			:ls_data[39],			:ls_data[40],		:ls_data[41]	,
		 :ls_data[42],			:ls_data[43],		:ls_data[44],			:ls_data[45],			:ls_data[46],			:ls_data[47],		:ls_data[48]	,
		 :ls_data[49],			:ls_data[50],		:ls_data[51],			:ls_data[52],			:ls_data[53],			:ls_data[54],		:ls_data[55]	,
		 :ls_data[56],			:ls_data[57],		:ls_data[58],			:ls_data[59],			:ls_data[60],			:ls_data[61],		:ls_data[62]	,
		 :ls_data[63],			:ls_data[64],		:ls_data[65],			:ls_data[66],			:ls_data[67],			:ls_data[68],		:ls_data[69]	,
		 :ls_data[70],			:ls_data[71],		:ls_data[72],			:ls_data[73],			:ls_data[74],			:ls_data[75],		:ls_data[76]	,
		 :ls_data[77],			:ls_data[78],		:ls_data[79],			:ls_data[80],			:ls_data[81],			:ls_data[82],		:ls_data[83]	,
		 :ls_data[84],			:ls_data[85],		:ls_data[86],			:ls_data[87],			:ls_data[88],			:ls_data[89],		:ls_data[90]	,
		 :ls_data[91],			:ls_crt_date	,	:ls_crt_time,			:ls_crt_user,			NULL	,	 				:ls_mitnbr, 		:ls_mcvcod, 
		 :ls_mdcvcod	) ;
	
		if sqlca.sqlcode <> 0 then	 
			st_state.Visible = False
			wf_error(arg_gubun,li_data,ls_data[1],ls_data[3],ls_data[4],sqlca.sqlerrText+" 입력에러가 발생했습니다." + '[열위치:'+string(li_data)+']')
			Rollback;
			FileClose(li_FileNum)
			return -3
		end if
		il_succeed++
	End If
	st_state.Text = "파일명: "+Right(arg_file_name,9) +"  라인수 :" +String(li_data)
	
Loop

FileClose(li_FileNum)
commit;

st_state.Visible = False
return li_data

end function

public function integer wf_erp_d68 (string arg_gubun, string arg_file_name);integer 	li_FileNum, li_data, li_rtn, li_cnt
string 	ls_data[], ls_crt_date, ls_crt_time, ls_crt_user, ls_Input_Data
string	ls_mitnbr, ls_mcvcod, ls_mdcvcod

//현재일자,시간
ls_crt_date = string(today(),'yyyymmdd')
ls_crt_time = string(today(),'hhmm')
ls_crt_user = gs_userid 

li_FileNum = FileOpen(arg_file_name,LineMode!,Read!)
if li_FileNum = -1 then
	wf_error(arg_gubun,li_cnt,'','','',"["+arg_file_name+"]"+" VAN자료가 없습니다.!!")
	FileClose(li_FileNum)
	return -1
end if

li_data = 0
il_err = 0
st_state.Visible = True
st_state.Text = '데이타를 읽는 중입니다...'

Do While	FileRead(li_FileNum, ls_Input_Data) <> -100	
	li_data++
	
	li_rtn = wf_csv_split(ls_Input_Data, ls_data, 13)

	//기등록자료CHECK
	SELECT COUNT(*) INTO :li_cnt
	  FROM VAN_ERPD68
    WHERE SABU		= :gs_sabu
	 	AND DOCCODE = :ls_data[1]
		AND CUSTCD  = :ls_data[2]
		AND FACTORY = :ls_data[3]
		AND ITNBR   = :ls_data[4]
		AND ORDER_GB= :ls_data[7]
		AND ORDERNO = :ls_data[5] ;

	If li_rtn > 0 And li_cnt = 0 Then
		//참조값(품번,거래처)가져오기
		if wf_ref_code(arg_gubun, ls_data[2], ls_data[3], ls_data[4], ls_mitnbr, ls_mcvcod, ls_mdcvcod) = -1 then
			wf_error(arg_gubun,li_data,ls_data[1],ls_data[3],ls_data[4],'참조코드가 없습니다.')
			il_err++
			Continue ;
		end if

		INSERT INTO VAN_ERPD68
		(SABU	,			DOCCODE	,			CUSTCD	,			FACTORY	,			ITNBR	,			ORDERNO	,		ORDERSN	,
		 ORDER_GB	,	ORDER_QTY	,		IPDAN	,				ORDER_DATE	,		ORDER_TYPE	,	ORDER_TIME	,	USEGBN	,
		 CRT_DATE	,	CRT_TIME	,			CRT_USER	,			CITNBR	,			MITNBR	,		MCVCOD	,		MDCVCOD	)
		VALUES    
		(:gs_sabu	,	:ls_data[1],		:ls_data[2],		:ls_data[3],		:ls_data[4],	:ls_data[5]	,	:ls_data[6]	,
		 :ls_data[7],	:ls_data[8],		:ls_data[9],		:ls_data[10],		:ls_data[11],	:ls_data[12],	:ls_data[13]	,
		 :ls_crt_date	,	:ls_crt_time,	:ls_crt_user,		NULL	,		 		:ls_mitnbr, 	:ls_mcvcod, 	:ls_mdcvcod	) ;
	
		if sqlca.sqlcode <> 0 then	 
			st_state.Visible = False
			wf_error(arg_gubun,li_data,ls_data[1],ls_data[3],ls_data[4],sqlca.sqlerrText+" 입력에러가 발생했습니다." + '[열위치:'+string(li_data)+']')
			Rollback;
			FileClose(li_FileNum)
			return -3
		end if
		il_succeed++
	End If
	
	st_state.Text = "파일명: "+Right(arg_file_name,9) +"  라인수 :" +String(li_data)
	
Loop

FileClose(li_FileNum)
commit;

st_state.Visible = False
return li_data

end function

public function integer wf_erp_d9 (string arg_gubun, string arg_file_name);integer 	li_FileNum, li_data, li_rtn, li_cnt
string 	ls_data[], ls_crt_date, ls_crt_time, ls_crt_user, ls_Input_Data
string	ls_mitnbr, ls_mcvcod, ls_mdcvcod

//현재일자,시간
ls_crt_date = string(today(),'yyyymmdd')
ls_crt_time = string(today(),'hhmm')
ls_crt_user = gs_userid 

li_FileNum = FileOpen(arg_file_name,LineMode!,Read!)
if li_FileNum = -1 then
	wf_error(arg_gubun,li_cnt,'','','',"["+arg_file_name+"]"+" VAN자료가 없습니다.!!")
	FileClose(li_FileNum)
	return -1
end if

li_data = 0
il_err = 0
st_state.Visible = True
st_state.Text = '데이타를 읽는 중입니다...'

Do While	FileRead(li_FileNum, ls_Input_Data) <> -100	
	li_data++
	
	li_rtn = wf_csv_split(ls_Input_Data, ls_data, 10)

	If ls_data[6] = '' Or isNull(ls_data[6]) Then ls_data[6] = '.'

	//기등록자료CHECK
	SELECT COUNT(*) INTO :li_cnt
	  FROM VAN_ERPD9
    WHERE SABU		= :gs_sabu
	 	AND DOCCODE = :ls_data[1]
		AND CUSTCD  = :ls_data[2]
		AND FACTORY = :ls_data[3]
		AND ITNBR   = :ls_data[4]
		AND IPSOURCE= :ls_data[5]
		AND IPGUBUN = :ls_data[6] ;

	If li_rtn > 0 And li_cnt = 0 Then
		//참조값(품번,거래처)가져오기
		if wf_ref_code(arg_gubun, ls_data[2], ls_data[3], ls_data[4], ls_mitnbr, ls_mcvcod, ls_mdcvcod) = -1 then
			wf_error(arg_gubun,li_data,ls_data[1],ls_data[3],ls_data[4],'참조코드가 없습니다.')
			il_err++
			Continue ;
		end if

		INSERT INTO VAN_ERPD9
		(SABU	,			DOCCODE	,			CUSTCD	,			FACTORY	,			ITNBR	,			IPSOURCE	,			IPGUBUN	,
		 IPTQTY	,		IPTAMT	,			PACKTAMT	,			CRT_DATE	,			CRT_TIME	,		CRT_USER	,			CITNBR	,
		 MITNBR	,		MCVCOD	,			MDCVCOD	,			WON	)
		VALUES    
		(:gs_sabu	,	:ls_data[1],		:ls_data[2],		:ls_data[3],		:ls_data[4],	:ls_data[5]	,		:ls_data[6]	,
		 :ls_data[7],	:ls_data[8],		:ls_data[9],		:ls_crt_date	,	:ls_crt_time,	:ls_crt_user,		NULL	,
		 :ls_mitnbr, 	:ls_mcvcod, 		:ls_mdcvcod,		:ls_data[10]	) ;
	
		if sqlca.sqlcode <> 0 then	 
			st_state.Visible = False
			wf_error(arg_gubun,li_data,ls_data[1],ls_data[3],ls_data[4],sqlca.sqlerrText+" 입력에러가 발생했습니다." + '[열위치:'+string(li_data)+']')
			Rollback;
			FileClose(li_FileNum)
			return -3
		end if
		il_succeed++
	End If
	
	st_state.Text = "파일명: "+Right(arg_file_name,9) +"  라인수 :" +String(li_data)
	
Loop

FileClose(li_FileNum)
commit;

st_state.Visible = False
return li_data

end function

public function integer wf_ckd_d9 (string arg_gubun, string arg_file_name);integer 	li_FileNum, li_data, li_rtn, li_cnt
string 	ls_data[], ls_crt_date, ls_crt_time, ls_crt_user, ls_Input_Data
string	ls_mitnbr, ls_mcvcod, ls_mdcvcod

//현재일자,시간
ls_crt_date = string(today(),'yyyymmdd')
ls_crt_time = string(today(),'hhmm')
ls_crt_user = gs_userid 

li_FileNum = FileOpen(arg_file_name,LineMode!,Read!)
if li_FileNum = -1 then
	wf_error(arg_gubun,li_cnt,'','','',"["+arg_file_name+"]"+" VAN자료가 없습니다.!!")
	FileClose(li_FileNum)
	return -1
end if

li_data = 0
il_err = 0
st_state.Visible = True
st_state.Text = '데이타를 읽는 중입니다...'

Do While	FileRead(li_FileNum, ls_Input_Data) <> -100	
	li_data++
	
	li_rtn = wf_csv_split(ls_Input_Data, ls_data, 11)
	
	//입고구분 자료가 NULL이 있음. DEFAULT로 "."입력 - by shingoon 2009.03.12
	If Trim(ls_data[8]) = '' OR IsNull(ls_data[8]) Then ls_data[8] = '.'

	//기등록자료CHECK
	SELECT COUNT(*) INTO :li_cnt
	  FROM VAN_CKDD9
    WHERE SABU		= :gs_sabu
	 	AND DOCCODE = :ls_data[1]
		AND CUSTCD  = :ls_data[3]
		AND FACTORY = :ls_data[2]
		AND ITNBR   = :ls_data[6]
		AND IPGUBUN = :ls_data[8] ;

	If li_rtn > 0 And li_cnt = 0 Then
		//참조값(품번,거래처)가져오기
		if wf_ref_code(arg_gubun, ls_data[3], ls_data[2], ls_data[6], ls_mitnbr, ls_mcvcod, ls_mdcvcod) = -1 then
			wf_error(arg_gubun,li_data,ls_data[1],ls_data[2],ls_data[6],'참조코드가 없습니다.')
			il_err++
			Continue ;
		end if
		
		INSERT INTO VAN_CKDD9
		(SABU	,			DOCCODE	,			CUSTCD	,			FACTORY	,			ITNBR	,			MONYYMM	,			JTYPE	,
		 UNMSR	,		IPGUBUN	,			IPTQTY	,			IPTAMT	,			PACKTAMT	,		CRT_DATE	,			CRT_TIME	,
		 CRT_USER	,	CITNBR	,			MITNBR	,			MCVCOD	,			MDCVCOD	,		WON	)
		VALUES    
		(:gs_sabu	,	:ls_data[1],		:ls_data[3],		:ls_data[2],		:ls_data[6],	:ls_data[4]	,		:ls_data[5]	,
		 :ls_data[7],	:ls_data[8],		:ls_data[9],		:ls_data[10],		:ls_data[11],	:ls_crt_date	,	:ls_crt_time,
		 :ls_crt_user,	NULL	,				:ls_mitnbr, 		:ls_mcvcod, 		:ls_mdcvcod,	NULL	) ;
	
		if sqlca.sqlcode <> 0 then	 
			st_state.Visible = False
			wf_error(arg_gubun,li_data,ls_data[1],ls_data[2],ls_data[6],sqlca.sqlerrText+" 입력에러가 발생했습니다." + '[열위치:'+string(li_data)+']')
			Rollback;
			FileClose(li_FileNum)
			return -3
		end if
		il_succeed++
	End If
	
	st_state.Text = "파일명: "+Right(arg_file_name,9) +"  라인수 :" +String(li_data)
	
Loop

FileClose(li_FileNum)
commit;

st_state.Visible = False
return li_data

end function

public function integer wf_erp_dh (string arg_gubun, string arg_file_name);integer 	li_FileNum, li_data, li_rtn, li_cnt
string 	ls_data[], ls_crt_date, ls_crt_time, ls_crt_user, ls_Input_Data
string	ls_mitnbr, ls_mcvcod, ls_mdcvcod

//현재일자,시간
ls_crt_date = string(today(),'yyyymmdd')
ls_crt_time = string(today(),'hhmm')
ls_crt_user = gs_userid 

li_FileNum = FileOpen(arg_file_name,LineMode!,Read!)
if li_FileNum = -1 then
	wf_error(arg_gubun,li_cnt,'','','',"["+arg_file_name+"]"+" VAN자료가 없습니다.!!")
	FileClose(li_FileNum)
	return -1
end if

li_data = 0
il_err = 0
st_state.Visible = True
st_state.Text = '데이타를 읽는 중입니다...'

Do While	FileRead(li_FileNum, ls_Input_Data) <> -100	
	li_data++
	
	li_rtn = wf_csv_split(ls_Input_Data, ls_data, 26)

	//기등록자료CHECK
	SELECT COUNT(*) INTO :li_cnt
	  FROM VAN_ERPDH
    WHERE SABU		= :gs_sabu
	 	AND DOCCODE = :ls_data[1]
		AND CUSTCD  = :ls_data[2]
		AND FACTORY = :ls_data[3]
		AND ITNBR   = :ls_data[4] 
		AND JRCODE  = :ls_data[8] 
		AND CARNAME = :ls_data[21];

	If li_rtn > 0 And li_cnt = 0 Then
		//참조값(품번,거래처)가져오기
		if wf_ref_code(arg_gubun, ls_data[2], ls_data[3], ls_data[4], ls_mitnbr, ls_mcvcod, ls_mdcvcod) = -1 then
			wf_error(arg_gubun,li_data,ls_data[1],ls_data[3],ls_data[4],'참조코드가 없습니다.')
			il_err++
			Continue ;
		end if

		INSERT INTO VAN_ERPDH
		(SABU	,			DOCCODE	,			CUSTCD	,			FACTORY	,			CARCODE	,			UPITNBR	,			JRCODE	,
		 ITNBR	,		SHOP_1	,			LINE_1	,			OPSEQ_1	,			RACK_1	,			HOUSE_LOT_1	,		SHOP_2	,
		 LINE_2	,		OPSEQ_2	,			RACK_2	,			HOUSE_LOT_2	,		GL_OUTMARK	,		IN_DATE	,			OUT_DATE	,
		 CARNAME	,		JR_CDATE_1	,		LOT_CDATE	,		JR_CDATE_2	,		RACK_CDATE	,		CRT_DATE	,			CRT_TIME	,
		 CRT_USER	,	CITNBR	,			MITNBR	,			MCVCOD	,			MDCVCOD	,			KNAME	,				LANE	,
		 PRONO	,		ALCCODE	)
		VALUES    
		(:gs_sabu	,	:ls_data[1],		:ls_data[2],		:ls_data[3],		:ls_data[5],		:ls_data[7]	,		:ls_data[8]	,
		 :ls_data[4],	:ls_data[9],		:ls_data[10],		:ls_data[11],		:ls_data[12],		:ls_data[13],		:ls_data[14]	,
		 :ls_data[15],	:ls_data[16],		:ls_data[17],		:ls_data[18],		NULL,					:ls_data[19],		:ls_data[20]	,
		 :ls_data[21],	:ls_data[23],		:ls_data[24],		:ls_data[25],		:ls_data[26],		:ls_crt_date	,	:ls_crt_time,	
		 :ls_crt_user,	NULL	,				:ls_mitnbr, 		:ls_mcvcod, 		:ls_mdcvcod,		:ls_data[22],		NULL,
		 NULL,			:ls_data[6]	) ;
	
		if sqlca.sqlcode <> 0 then	 
			st_state.Visible = False
			wf_error(arg_gubun,li_data,ls_data[1],ls_data[3],ls_data[4],sqlca.sqlerrText+" 입력에러가 발생했습니다." + '[열위치:'+string(li_data)+']')
			Rollback;
			FileClose(li_FileNum)
			return -3
		end if
		il_succeed++
	End If
	
	st_state.Text = "파일명: "+Right(arg_file_name,9) +"  라인수 :" +String(li_data)
	
Loop

FileClose(li_FileNum)
commit;

st_state.Visible = False
return li_data

end function

public function integer wf_erp_p6 (string arg_gubun, string arg_file_name);integer 	li_FileNum, li_data, li_rtn, li_cnt
string 	ls_data[], ls_crt_date, ls_crt_time, ls_crt_user, ls_Input_Data, ls_saupj
string	ls_mitnbr, ls_mcvcod, ls_mdcvcod

//현재일자,시간
ls_crt_date = string(today(),'yyyymmdd')
ls_crt_time = string(today(),'hhmm')
ls_crt_user = gs_userid 

li_FileNum = FileOpen(arg_file_name,LineMode!,Read!)
if li_FileNum = -1 then
	wf_error(arg_gubun,li_cnt,'','','',"["+arg_file_name+"]"+" VAN자료가 없습니다.!!")
	FileClose(li_FileNum)
	return -1
end if

li_data = 0
il_err = 0
st_state.Visible = True
st_state.Text = '데이타를 읽는 중입니다...'

Do While	FileRead(li_FileNum, ls_Input_Data) <> -100	
	li_data++
	
	li_rtn = wf_csv_split(ls_Input_Data, ls_data, 75)

	if gs_saupj = '10' then
		ls_saupj = 'U904'
	else
		ls_saupj = 'R081'
	end if
	
	If ls_data[4] = '' Or isNull(ls_data[4]) Then ls_data[4] = ls_saupj

	If li_data = 1 Then
		//기등록자료CHECK
		SELECT COUNT(*) INTO :li_cnt
		  FROM VAN_ERPP6
		 WHERE SABU		= :gs_sabu
			AND DOCCODE = :ls_data[1] ;
		If li_cnt > 0 Then
			st_state.Visible = False
			wf_error(arg_gubun,li_data,ls_data[1],ls_data[12],ls_data[11],'기처리된 문서번호입니다.')
			FileClose(li_FileNum)
			return -3
		End If
	End If

	If li_rtn > 0 And li_cnt = 0 Then
		//참조값(품번,거래처)가져오기
		if wf_ref_code(arg_gubun, ls_data[4], ls_data[12], ls_data[11], ls_mitnbr, ls_mcvcod, ls_mdcvcod) = -1 then
			wf_error(arg_gubun,li_data,ls_data[1],ls_data[12],ls_data[11],'참조코드가 없습니다.')
			il_err++
			Continue ;
		end if

		INSERT INTO VAN_ERPP6
		(SABU	,					DOCCODE	,			CUSTCD	,				FILEID	,				PROCESGB	,				PLANGB	,			MANAGEGB	,	
		 DATAGB	,				ITEMSER	,			ITEMNAME	,				ITEMCODE	,				WORKGB	,				FACTORY	,			TRIM_RESULT	,
		 PBS	,					PAINT_REJ	,		WBS	,					D_SCH1	,				D_SCH2	,				D_SCH3	,			D_SCH4	,
		 D_SCH5	,				D_SCH6	,			D_SCH7	,				D_SCH8	,				D_SCH9	,				D_SCH10	,			DSCHED_TOT	,
		 D1_SCH1	,				D1_SCH2	,			D1_SCH3	,				D1_SCH4	,				D1_SCH5	,				D1_SCH6	,			D1_SCH7	,
		 D1_SCH8	,				D1_SCH9	,			D1_SCH10	,				D1SCHED_TOT	,			D2_SCH1	,				D2_SCH2	,			D2_SCH3	,
		 D2_SCH4	,				D2_SCH5	,			D2_SCH6	,				D2_SCH7	,				D2_SCH8	,				D2_SCH9	,			D2_SCH10	,
		 D2SCHED_TOT,			D3_SCH1	,			D3_SCH2	,				D3_SCH3	,				D3_SCH4	,				D3_SCH5	,			D3_SCH6	,
		 D3_SCH7	,				D3_SCH8	,			D3_SCH9	,				D3_SCH10	,				D3SCHED_TOT	,			D4_SCH1	,			D4_SCH2	,
		 D4_SCH3	,				D4_SCH4	,			D4_SCH5	,				D4_SCH6	,				D4_SCH7	,				D4_SCH8	,			D4_SCH9	,
		 D4_SCH10	,			D4SCHED_TOT	,		REMAIN_QTY	,			TOTAL_QTY	,			CONF_TQTY	,			MODEL_CODE	,		RSV	,
		 CRT_DATE	,			CRT_TIME	,			CRT_USER	,				CITNBR	,				MITNBR	,				MCVCOD	,			MDCVCOD	)		
		VALUES    
		(:gs_sabu	,			:ls_data[1],		:ls_data[4],			:ls_data[5],			:ls_data[2],			:ls_data[3]	,		:ls_data[6]	,
		 :ls_data[7],			:ls_data[8],		:ls_data[9],			:ls_data[11],			:ls_data[10],			:ls_data[12],		:ls_data[13]	,
		 :ls_data[14],			:ls_data[15],		:ls_data[16],			:ls_data[17],			:ls_data[18],			:ls_data[19],		:ls_data[20]	,
		 :ls_data[21],			:ls_data[22],		:ls_data[23],			:ls_data[24],			:ls_data[25],			:ls_data[26],		:ls_data[27]	,
		 :ls_data[28],			:ls_data[29],		:ls_data[30],			:ls_data[31],			:ls_data[32],			:ls_data[33],		:ls_data[34]	,
		 :ls_data[35],			:ls_data[36],		:ls_data[37],			:ls_data[38],			:ls_data[39],			:ls_data[40],		:ls_data[41]	,
		 :ls_data[42],			:ls_data[43],		:ls_data[44],			:ls_data[45],			:ls_data[46],			:ls_data[47],		:ls_data[48]	,
		 :ls_data[49],			:ls_data[50],		:ls_data[51],			:ls_data[52],			:ls_data[53],			:ls_data[54],		:ls_data[55]	,
		 :ls_data[56],			:ls_data[57],		:ls_data[58],			:ls_data[59],			:ls_data[60],			:ls_data[61],		:ls_data[62]	,
		 :ls_data[63],			:ls_data[64],		:ls_data[65],			:ls_data[66],			:ls_data[67],			:ls_data[68],		:ls_data[69]	,
		 :ls_data[70],			:ls_data[71],		:ls_data[72],			:ls_data[73],			NULL,						:ls_data[74],		:ls_data[75]	,
		 :ls_crt_date	,		:ls_crt_time,		:ls_crt_user,			NULL	,	 				:ls_mitnbr, 			:ls_mcvcod, 		:ls_mdcvcod	) ;
	
		if sqlca.sqlcode <> 0 then	 
			st_state.Visible = False
			wf_error(arg_gubun,li_data,ls_data[1],ls_data[12],ls_data[11],sqlca.sqlerrText+" 입력에러가 발생했습니다." + '[열위치:'+string(li_data)+']')
			Rollback;
			FileClose(li_FileNum)
			return -3
		end if
		il_succeed++
	End If
	
	st_state.Text = "파일명: "+Right(arg_file_name,9) +"  라인수 :" +String(li_data)
	
Loop

FileClose(li_FileNum)
commit;

st_state.Visible = False
return li_data

end function

public function integer wf_erp_p7 (string arg_gubun, string arg_file_name);integer 	li_FileNum, li_data, li_rtn, li_cnt
string 	ls_data[], ls_crt_date, ls_crt_time, ls_crt_user, ls_Input_Data, ls_saupj
string	ls_mitnbr, ls_mcvcod, ls_mdcvcod

//현재일자,시간
ls_crt_date = string(today(),'yyyymmdd')
ls_crt_time = string(today(),'hhmm')
ls_crt_user = gs_userid 

li_FileNum = FileOpen(arg_file_name,LineMode!,Read!)
if li_FileNum = -1 then
	wf_error(arg_gubun,li_cnt,'','','',"["+arg_file_name+"]"+" VAN자료가 없습니다.!!")
	FileClose(li_FileNum)
	return -1
end if

li_data = 0
il_err = 0
st_state.Visible = True
st_state.Text = '데이타를 읽는 중입니다...'

Do While	FileRead(li_FileNum, ls_Input_Data) <> -100	
	li_data++
	
	li_rtn = wf_csv_split(ls_Input_Data, ls_data, 38)

	if gs_saupj = '10' then
		ls_saupj = 'U904'
	else
		ls_saupj = 'R081'
	end if
	
	If ls_data[4] = '' Or isNull(ls_data[4]) Then ls_data[4] = ls_saupj


	If li_data = 1 Then
		//기등록자료CHECK
		SELECT COUNT(*) INTO :li_cnt
		  FROM VAN_ERPP7
		 WHERE SABU		= :gs_sabu
			AND DOCCODE = :ls_data[1] ;
		If li_cnt > 0 Then
			st_state.Visible = False
			wf_error(arg_gubun,li_data,ls_data[1],ls_data[12],ls_data[11],'기처리된 문서번호입니다.')
			FileClose(li_FileNum)
			return -3
		End If
	End If

	If li_rtn > 0 And li_cnt = 0 Then
		//참조값(품번,거래처)가져오기
		if wf_ref_code(arg_gubun, ls_data[4], ls_data[12], ls_data[11], ls_mitnbr, ls_mcvcod, ls_mdcvcod) = -1 then
			wf_error(arg_gubun,li_data,ls_data[1],ls_data[12],ls_data[11],'참조코드가 없습니다.')
			il_err++
			Continue ;
		end if

		INSERT INTO VAN_ERPP7
		(SABU	,			DOCCODE	,			CUSTCD	,			FILEID	,			PROCESGB	,			PLANGB	,			MANAGEGB	,
		 DATAGB	,		ITEMSER	,			ITEMNAME	,			ITEMCODE	,			WORKGB	,			FACTORY	,			TRIM_RESULT	,
		 PBS	,			PAINT_REJ	,		WBS	,				D12SCHED1	,		D12SCHED2	,		D12SCHED3	,		D12SCHED4	,
		 D12SCHED5	,	D12SCHED6	,		D12SCHED7	,		D12SCHED8	,		D12SCHED9	,		D12SCHED10	,		D12SCHED11	,
		 D12SCHED12	,	D12SCHED13	,		REMAIN_QTY	,		CONF_TQTY	,		MITU	,				PRESEQ	,			MON_MIJAN	,
		 NMON_PRORDER,	MON_TOTAL	,		MODEL_CODE	,		RSV	,				CRT_DATE	,			CRT_TIME	,			CRT_USER	,
		 CITNBR	,		MITNBR	,			MCVCOD	,			MDCVCOD	)
		VALUES    
		(:gs_sabu	,	:ls_data[1],		:ls_data[4],		:ls_data[5],		:ls_data[2],		:ls_data[3]	,		:ls_data[6]	,
		 :ls_data[7],	:ls_data[8],		:ls_data[9],		:ls_data[11],		:ls_data[10],		:ls_data[12],		:ls_data[13]	,
		 :ls_data[14],	:ls_data[15],		:ls_data[16],		:ls_data[17],		:ls_data[18],		:ls_data[19],		:ls_data[20]	,
		 :ls_data[21],	:ls_data[22],		:ls_data[23],		:ls_data[24],		:ls_data[25],		:ls_data[26],		:ls_data[27]	,
		 :ls_data[28],	:ls_data[29],		:ls_data[30],		:ls_data[31],		:ls_data[32],		:ls_data[33],		:ls_data[34]	,			
		 :ls_data[35],	:ls_data[36],		:ls_data[37],		:ls_data[38],		:ls_crt_date	,	:ls_crt_time,		:ls_crt_user,	
		 NULL	,		 	:ls_mitnbr, 		:ls_mcvcod, 		:ls_mdcvcod	) ;
	
		if sqlca.sqlcode <> 0 then	 
			st_state.Visible = False
			wf_error(arg_gubun,li_data,ls_data[1],ls_data[12],ls_data[11],sqlca.sqlerrText+" 입력에러가 발생했습니다." + '[열위치:'+string(li_data)+']')
			Rollback;
			FileClose(li_FileNum)
			return -3
		end if
		il_succeed++
	End If
	
	st_state.Text = "파일명: "+Right(arg_file_name,9) +"  라인수 :" +String(li_data)
	
Loop

FileClose(li_FileNum)
commit;

st_state.Visible = False
return li_data

end function

public function integer wf_ref_code (string arg_gubun, string arg_custcd, string arg_factory, string arg_itnbr, ref string ref_mitnbr, ref string ref_mcvcod, ref string ref_mdcvcod);//ref_mcvcod = 'S00110'
//ref_mdcvcod = 'S00110'
//

//공장별 거래처 읽어오기
select nvl(decode(:arg_custcd ,'U904',SUBSTR(TRIM(RFNA2),1,6),SUBSTR(TRIM(RFNA2),-6,6) ),''),
		 nvl(RFNA3,'')
  into :ref_mcvcod , :ref_mdcvcod
  from reffpf
 where sabu  = :gs_sabu
	and rfcod = '2A'
	and rfgub = :arg_factory ;
		
if sqlca.sqlcode <> 0 or &
	trim(ref_mcvcod)	= '' or trim(ref_mcvcod) = '' or &
	isNull(ref_mcvcod)	 or isNull(ref_mcvcod) then
	return -1
end if



////대체품번(KIA CKD는 글로비스로 입고. 글로비스는 마감에서 기타업체 처리. 2006.09.21. 이수철
//select count(*) into :il_cnt
//  from itemas_alt
// where itnbr = :ls_itnbr
//	and saupj = :ls_custcd	 ;
//
//if il_cnt > 0 then
//	if trim(mid(ls_factory,1,1)) = 'L' then
//		select citnbr into :ls_itnbr 
//					from itemas_alt
//				  where itnbr = :ls_itnbr
//					 and saupj = :ls_custcd;
//	else		
//		select citnbr into :ls_itnbr 
//					from itemas_alt
//				  where itnbr = :ls_itnbr
//					 and saupj = :ls_custcd
//					 and gubun = :ls_mdcvcod;
//	end if
//end if
//

if arg_gubun <> 'ERPP6' and arg_gubun <> 'ERPP7' then
	//자체품번 읽어오기(자체거래처코드)
	//사용중인 품번으로 조회 되도록 요청함 김태훈 차장 - By shjeon 20101228
	select itnbr
	  into :ref_mitnbr
	  from itemas
	 where replace(itnbr,'-','') = :arg_itnbr and useyn = '0' ; 
	
	if sqlca.sqlcode <> 0 or trim(ref_mitnbr) = '' or isNull(ref_mitnbr) then	
		return -1
	end iF
end if

ref_mitnbr = trim(ref_mitnbr)
ref_mcvcod = trim(ref_mcvcod)
ref_mdcvcod = trim(ref_mdcvcod)

return 1
end function

public function integer wf_ckd_d68 (string arg_gubun, string arg_file_name);integer 	li_FileNum, li_data, li_rtn, li_cnt
string 	ls_data[], ls_crt_date, ls_crt_time, ls_crt_user, ls_Input_Data
string	ls_mitnbr, ls_mcvcod, ls_mdcvcod

//현재일자,시간
ls_crt_date = string(today(),'yyyymmdd')
ls_crt_time = string(today(),'hhmm')
ls_crt_user = gs_userid 

li_FileNum = FileOpen(arg_file_name,LineMode!,Read!)
if li_FileNum = -1 then
	wf_error(arg_gubun,li_cnt,'','','',"["+arg_file_name+"]"+" VAN자료가 없습니다.!!")
	FileClose(li_FileNum)
	return -1
end if

li_data = 0
il_err = 0
st_state.Visible = True
st_state.Text = '데이타를 읽는 중입니다...'

Do While	FileRead(li_FileNum, ls_Input_Data) <> -100	
	li_data++
	
	li_rtn = wf_csv_split(ls_Input_Data, ls_data, 43)

	//기등록자료CHECK
	SELECT COUNT(*) INTO :li_cnt
	  FROM VAN_CKDD68
    WHERE SABU		= :gs_sabu
	 	AND DOCCODE = :ls_data[1]
	 	AND PDNO 	= :ls_data[2]
		AND CUSTCD  = :ls_data[7] ;
		
	If li_rtn > 0 And li_cnt = 0 Then
		//참조값(품번,거래처)가져오기
		if wf_ref_code(arg_gubun, ls_data[7], ls_data[4], ls_data[6], ls_mitnbr, ls_mcvcod, ls_mdcvcod) = -1 then
			wf_error(arg_gubun,li_data,ls_data[1],ls_data[4],ls_data[6],'참조코드가 없습니다.')
			il_err++
			Continue ;
		end if

		INSERT INTO VAN_CKDD68
		(SABU	,			DOCCODE	,				PDNO	,				SANG_CD	,				PLANT	,				JAJEUG	,
		 JAJENO	,		CUSTCD	,				PALNT_IM	,			UNMSR	,					CALC_QTY	,			PLAN_DQTY	,
		 PODATE	,		NAPDATE	,				POJANGG	,			SALEGBN	,				SALEDOC	,			SDITNO	,
		 POBATCH	,		SALEDOF	,				SALEDOT	,			NADIL_CD	,				MODEL_CD	,			CASE_TYP	,
		 CASE_NO	,		RELATION	,				JUGPO_QTY	,		SOURGBN	,				SAGBN	,				JIKGBN	,
		 IPGO_USER	,	BUNHAL_NAP	,			CUR_STOCK	,		PREV_RESULT	,			POJAN_QTY	,		BALJU_YN	,
		 GUMENO	,		GUITNO	,				GUJB_DATE	,		MTEXT	,					JAJEGBN	,			CTCOD	,
		 POJALINE	,	IPQTY	,					CRT_DATE	,			CRT_TIME	,				CRT_USER	,			CITNBR	,
		 MITNBR	,		MCVCOD	,				MDCVCOD	)
		VALUES    
		(:gs_sabu	,	:ls_data[1],			:ls_data[2],		:ls_data[3],			:ls_data[4],		:ls_data[5]	,	
		 :ls_data[6],  :ls_data[7],			:ls_data[8],		:ls_data[9],			:ls_data[10],		:ls_data[11],
		 :ls_data[12],	:ls_data[13],			:ls_data[14],		:ls_data[15],			:ls_data[16],		:ls_data[17],
		 :ls_data[18],	:ls_data[19],			:ls_data[20],		:ls_data[21],			:ls_data[22],		:ls_data[23],
		 :ls_data[24],	:ls_data[25],			:ls_data[26],		:ls_data[27],			:ls_data[28],		:ls_data[29],
		 :ls_data[30],	:ls_data[31],			:ls_data[32],		:ls_data[33],			:ls_data[34],		:ls_data[35],
		 :ls_data[36],	:ls_data[37],			:ls_data[38],		:ls_data[39],			:ls_data[40],		:ls_data[41],
		 :ls_data[42], :ls_data[43], 		 	:ls_crt_date	,	:ls_crt_time,			:ls_crt_user,		NULL	,		 		
		 :ls_mitnbr, 	:ls_mcvcod, 			:ls_mdcvcod	) ;
	
		if sqlca.sqlcode <> 0 then	 
			st_state.Visible = False
			wf_error(arg_gubun,li_data,ls_data[1],ls_data[3],ls_data[4],sqlca.sqlerrText+" 입력에러가 발생했습니다." + '[열위치:'+string(li_data)+']')
			Rollback;
			FileClose(li_FileNum)
			return -3
		end if
		il_succeed++
	End If
	
	st_state.Text = "파일명: "+Right(arg_file_name,9) +"  라인수 :" +String(li_data)
	
Loop

FileClose(li_FileNum)
commit;

st_state.Visible = False
return li_data

end function

public function integer wf_ckd_d2 (string arg_gubun, string arg_file_name);integer 	li_FileNum, li_data, li_rtn, li_cnt, li_cnt2
string 	ls_data[], ls_crt_date, ls_crt_time, ls_crt_user, ls_Input_Data
string	ls_mitnbr, ls_mcvcod, ls_mdcvcod

//현재일자,시간
ls_crt_date = string(today(),'yyyymmdd')
ls_crt_time = string(today(),'hhmm')
ls_crt_user = gs_userid 

li_FileNum = FileOpen(arg_file_name,LineMode!,Read!)
if li_FileNum = -1 then
	wf_error(arg_gubun,li_cnt,'','','',"["+arg_file_name+"]"+" VAN자료가 없습니다.!!")
	FileClose(li_FileNum)
	return -1
end if

li_data = 0
il_err = 0
st_state.Visible = True
st_state.Text = '데이타를 읽는 중입니다...'

Do While	FileRead(li_FileNum, ls_Input_Data) <> -100	
	li_data++
	
	li_rtn = wf_csv_split(ls_Input_Data, ls_data, 43)

	//기등록자료CHECK : 2010.09.17 shjeon
	SELECT COUNT(*) INTO :li_cnt2
	  FROM VAN_CKDD2
    WHERE SABU		= :gs_sabu
	 	AND PDNO 	= :ls_data[2]
		AND CUSTCD  = :ls_data[7]
		AND PLANT = :ls_data[4]
		AND JAJENO = :ls_data[6]
		AND SALEDOC = :ls_data[16]
		AND NAPDATE = :ls_data[13];
		
	//기 등록자료 확인 - BY SHINGOON 2009.11.11
	SELECT COUNT('X')
	  INTO :li_cnt
	  FROM VAN_CKDD2
	 WHERE SABU    = :gs_sabu
	   AND MITNBR  = :ls_mitnbr
		AND PDNO    = :ls_data[2]
		AND POBATCH = :ls_data[18];
	
	//If li_rtn > 0 And li_cnt = 0 AND li_cnt2 = 0 Then
	If li_cnt = 0 AND li_cnt2 = 0 Then
		//참조값(품번,거래처)가져오기
		if wf_ref_code(arg_gubun, ls_data[7], ls_data[4], ls_data[6], ls_mitnbr, ls_mcvcod, ls_mdcvcod) = -1 then
			wf_error(arg_gubun,li_data,ls_data[1],ls_data[4],ls_data[6],'참조코드가 없습니다.')
			il_err++
			Continue ;
		end if

		INSERT INTO VAN_CKDD2
		(SABU	,			DOCCODE	,				PDNO	,				SANG_CD	,				PLANT	,				JAJEUG	,
		 JAJENO	,		CUSTCD	,				PALNT_IM	,			UNMSR	,					CALC_QTY	,			PLAN_DQTY	,
		 PODATE	,		NAPDATE	,				POJANGG	,			SALEGBN	,				SALEDOC	,			SDITNO	,
		 POBATCH	,		SALEDOF	,				SALEDOT	,			NADIL_CD	,				MODEL_CD	,			CASE_TYP	,
		 CASE_NO	,		RELATION	,				JUGPO_QTY	,		SOURGBN	,				SAGBN	,				JIKGBN	,
		 IPGO_USER	,	BUNHAL_NAP	,			CUR_STOCK	,		PREV_RESULT	,			POJAN_QTY	,		BALJU_YN	,
		 GUMENO	,		GUITNO	,				GUJB_DATE	,		MTEXT	,					JAJEGBN	,			CTCOD	,
		 POJALINE	,	IPQTY	,					CRT_DATE	,			CRT_TIME	,				CRT_USER	,			CITNBR	,
		 MITNBR	,		MCVCOD	,				MDCVCOD	)
		VALUES    
		(:gs_sabu	,	:ls_data[1],			:ls_data[2],		:ls_data[3],			:ls_data[4],		:ls_data[5]	,	
		 :ls_data[6],  :ls_data[7],			:ls_data[8],		:ls_data[9],			:ls_data[10],		:ls_data[11],
		 :ls_data[12],	:ls_data[13],			:ls_data[14],		:ls_data[15],			:ls_data[16],		:ls_data[17],
		 :ls_data[18],	:ls_data[19],			:ls_data[20],		:ls_data[21],			:ls_data[22],		:ls_data[23],
		 :ls_data[24],	:ls_data[25],			:ls_data[26],		:ls_data[27],			:ls_data[28],		:ls_data[29],
		 :ls_data[30],	:ls_data[31],			:ls_data[32],		:ls_data[33],			:ls_data[34],		:ls_data[35],
		 :ls_data[36],	:ls_data[37],			:ls_data[38],		:ls_data[39],			:ls_data[40],		:ls_data[41],
		 :ls_data[42], :ls_data[43], 		 	:ls_crt_date	,	:ls_crt_time,			:ls_crt_user,		NULL	,		 		
		 :ls_mitnbr, 	:ls_mcvcod, 			:ls_mdcvcod	) ;
	
		if sqlca.sqlcode <> 0 then	 
			st_state.Visible = False
			wf_error(arg_gubun,li_data,ls_data[1],ls_data[3],ls_data[4],sqlca.sqlerrText+" 입력에러가 발생했습니다." + '[열위치:'+string(li_data)+']')
			Rollback;
			FileClose(li_FileNum)
			return -3
		end if
		il_succeed++
	End If
	
	st_state.Text = "파일명: "+Right(arg_file_name,9) +"  라인수 :" +String(li_data)
	
Loop

FileClose(li_FileNum)
commit;

st_state.Visible = False
return li_data

end function

on w_sm10_0030_asan.create
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
this.tab_1=create tab_1
this.pb_2=create pb_2
this.p_excel=create p_excel
this.dw_d2_detail=create dw_d2_detail
this.st_caption=create st_caption
this.p_mod=create p_mod
this.dw_dc=create dw_dc
this.dw_ckd1=create dw_ckd1
this.dw_ckd9=create dw_ckd9
this.dw_ckd0=create dw_ckd0
this.dw_ckd68=create dw_ckd68
this.dw_ckd2=create dw_ckd2
this.cb_d9_et=create cb_d9_et
this.cb_1=create cb_1
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
this.Control[iCurrent+16]=this.tab_1
this.Control[iCurrent+17]=this.pb_2
this.Control[iCurrent+18]=this.p_excel
this.Control[iCurrent+19]=this.dw_d2_detail
this.Control[iCurrent+20]=this.st_caption
this.Control[iCurrent+21]=this.p_mod
this.Control[iCurrent+22]=this.dw_dc
this.Control[iCurrent+23]=this.dw_ckd1
this.Control[iCurrent+24]=this.dw_ckd9
this.Control[iCurrent+25]=this.dw_ckd0
this.Control[iCurrent+26]=this.dw_ckd68
this.Control[iCurrent+27]=this.dw_ckd2
this.Control[iCurrent+28]=this.cb_d9_et
this.Control[iCurrent+29]=this.cb_1
end on

on w_sm10_0030_asan.destroy
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
destroy(this.tab_1)
destroy(this.pb_2)
destroy(this.p_excel)
destroy(this.dw_d2_detail)
destroy(this.st_caption)
destroy(this.p_mod)
destroy(this.dw_dc)
destroy(this.dw_ckd1)
destroy(this.dw_ckd9)
destroy(this.dw_ckd0)
destroy(this.dw_ckd68)
destroy(this.dw_ckd2)
destroy(this.cb_d9_et)
destroy(this.cb_1)
end on

event open;Integer  li_idx

li_idx = w_mdi_frame.dw_listbar.InsertRow(0)
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_id',Upper(This.ClassName()))
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_name',Upper(This.Title))
w_mdi_frame.Postevent("ue_barrefresh")

is_today = f_today()
is_totime = f_totime()
is_window_id = this.ClassName()

w_mdi_frame.st_window.Text = Upper(is_window_id)

SELECT "SUB2_T"."OPEN_HISTORY", "SUB2_T"."UPMU"  
  INTO :is_usegub,  :is_upmu 
  FROM "SUB2_T"  
 WHERE "SUB2_T"."WINDOW_NAME" = :is_window_id  ;

IF is_usegub = 'Y' THEN
   INSERT INTO "PGM_HISTORY"  
	 		 ( "L_USERID",   "CDATE",       "STIME",      "WINDOW_NAME",   "EDATE",   
			   "ETIME",      "IPADD",       "USER_NAME" )  
   VALUES ( :gs_userid,   :is_today,     :is_totime,   :is_window_id,   NULL, 
	   		NULL,         :gs_ipaddress, :gs_comname )  ;

   IF SQLCA.SQLCODE = 0 THEN 
	   COMMIT;
   ELSE 	  
	   ROLLBACK;
   END IF	  
END IF	  

dw_ip.SetTransObject(SQLCA)
dw_ip.Reset()
dw_ip.InsertRow(0)

dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)
/*
IF is_upmu = 'A' THEN //회계인 경우
   int iRtnVal 

	IF Upper(Mid(is_window_id,4,2)) = 'BG' THEN							   /*예산*/
		IF F_Valid_EmpNo(Gs_EmpNo) = 'N' THEN							/*권한 체크- 현업 여부*/
			dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
			
			dw_ip.Modify("saupj.protect = 1")
		ELSE
			dw_ip.Modify("saupj.protect = 0")
		END IF
	ELSE
		IF Upper(Mid(is_window_id,4,2)) = 'FI' THEN							/*자금*/
			iRtnVal = F_Authority_Fund_Chk(Gs_Dept)	
		ELSE
			iRtnVal = F_Authority_Chk(Gs_Dept)
		END IF
		IF iRtnVal = -1 THEN							/*권한 체크- 현업 여부*/
			dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
			
			dw_ip.Modify("saupj.protect = 1")
		ELSE
			dw_ip.Modify("saupj.protect = 0")
		END IF	
	END IF
END IF
*/
//dw_print.object.datawindow.print.preview = "yes"	
//
//dw_print.ShareData(dw_list)

PostEvent('ue_open')

dw_ip.Object.jisi_date[1] = is_today
dw_ip.Object.jisi_date2[1] = is_today

dw_d0.SetTransObject(SQLCA)
dw_d2.SetTransObject(SQLCA)
dw_dC.SetTransObject(SQLCA)
dw_d68.SetTransObject(SQLCA)
dw_gi.SetTransObject(SQLCA)
dw_dh.SetTransObject(SQLCA)
dw_p6.SetTransObject(SQLCA)
dw_p7.SetTransObject(SQLCA)
dw_d1.SetTransObject(SQLCA)
dw_d9.SetTransObject(SQLCA)
dw_d3.SetTransObject(SQLCA)
dw_ckd0.SetTransObject(SQLCA)
dw_ckd1.SetTransObject(SQLCA)
dw_ckd2.SetTransObject(SQLCA)
dw_ckd68.SetTransObject(SQLCA)
dw_ckd9.SetTransObject(SQLCA)

dw_d2_detail.SetTransObject(SQLCA)

dw_d0.Titlebar = False
dw_d2.Titlebar = False
dw_ckd2.Titlebar = False
dw_dC.Titlebar = False
dw_d68.Titlebar = False
dw_ckd68.Titlebar = False
dw_gi.Titlebar = False
dw_ckd0.Titlebar = False
dw_dh.Titlebar = False
dw_p6.Titlebar = False
dw_p7.Titlebar = False
dw_d1.Titlebar = False
dw_d9.Titlebar = False
dw_d3.Titlebar = False
dw_ckd1.Titlebar = False
dw_ckd9.Titlebar = False

dw_d2_detail.visible = False
	
setnull(gs_code)
If f_check_saupj() = 1 Then
	dw_ip.SetItem(1, 'saupj', gs_code)
//   if gs_code <> '%' then
//   	dw_ip.Modify("saupj.protect=1")
//   End if
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

dw_ip.Object.gubun[1] = 'AL'

dw_d0.GetChild("newits", idwc_d0)

idwc_d0.SetTransObject(SQLCA)

idwc_d0.Retrieve("%")

//Tab_1.Tabpage_2.Enabled = False






end event

type p_xls from w_standard_print`p_xls within w_sm10_0030_asan
end type

type p_sort from w_standard_print`p_sort within w_sm10_0030_asan
end type

type p_preview from w_standard_print`p_preview within w_sm10_0030_asan
boolean visible = false
integer x = 4087
integer y = 228
end type

event p_preview::clicked;//if dw_1.visible then
//	OpenWithParm(w_print_preview, dw_1)
//	dw_1.visible = FALSE
//	dw_list.visible = TRUE
//
//	p_retrieve.triggerevent('clicked')
//else
//	OpenWithParm(w_print_preview, dw_print)
//end if

end event

type p_exit from w_standard_print`p_exit within w_sm10_0030_asan
end type

event p_exit::clicked;close(parent)

end event

type p_print from w_standard_print`p_print within w_sm10_0030_asan
boolean visible = false
integer x = 4261
integer y = 228
end type

event p_print::clicked;//IF dw_1.visible then
//	OpenWithParm(w_print_options,dw_1)
//	dw_1.visible = FALSE
//	dw_list.visible = TRUE
//
//	p_retrieve.triggerevent('clicked')
//ELSE
//	IF dw_print.rowcount() > 0 then 
//		gi_page = dw_print.GetItemNumber(1,"last_page")
//	ELSE
//		gi_page = 1
//	END IF
//	OpenWithParm(w_print_options, dw_print)
//END IF
end event

type p_retrieve from w_standard_print`p_retrieve within w_sm10_0030_asan
integer x = 4096
end type







type st_10 from w_standard_print`st_10 within w_sm10_0030_asan
end type



type dw_print from w_standard_print`dw_print within w_sm10_0030_asan
integer x = 3525
integer y = 136
string dataobject = "d_van_t_10020_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sm10_0030_asan
integer x = 23
integer y = 28
integer width = 3314
integer height = 356
string dataobject = "d_sm10_0030_asan_1"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;call super::itemchanged;String ls_col , ls_value, ls_itnbr_t, ls_itnbr_f

ls_col = GetColumnName()
ls_value = Trim(GetText())

Choose Case ls_col
	Case "gubun"
		If ls_value > '' Then
			Object.filename[1] = ' '+ wf_choose(ls_value)
		End If		
	Case "itnbr_from"
		ls_itnbr_t = Trim(This.GetItemString(row, 'itnbr_to'))
		if IsNull(ls_itnbr_t) or ls_itnbr_t = '' then
			This.SetItem(row, 'itnbr_to', ls_value)
	   end if
	Case "itnbr_to"
		ls_itnbr_f = Trim(This.GetItemString(row, 'itnbr_from'))
		if IsNull(ls_itnbr_f) or ls_itnbr_f = '' then
			This.SetItem(row, 'itnbr_from', ls_value)
	   end if
	
END CHOOSE

if ls_value = 'AL' Then st_caption.Text = ' '
if ls_value = 'D0' Then st_caption.Text = '품목정보'
if ls_value = 'CKD0' Then st_caption.Text = 'CKD품목정보'
if ls_value = 'D1' Then st_caption.Text = '검수합격통보서(DOC코드기준)'
if ls_value = 'CKD1' Then st_caption.Text = 'CKD검수합격통보서(DOC코드기준)'
if ls_value = 'D2' Then st_caption.Text = '주간(부품) 소요량'
if ls_value = 'CKD2' Then st_caption.Text = 'CKD주간(부품) 소요량'
if ls_value = 'D6' Then st_caption.Text = '일별.주간 납입지시(정규발주)'
if ls_value = 'D8' Then st_caption.Text = '일별.주간 납입지시 변동분(추가,분납,삭제)'
if ls_value = 'CKD6' Then st_caption.Text = 'CKD일별.주간 납입지시(정규발주)'
if ls_value = 'CKD8' Then st_caption.Text = 'CKD일별.주간 납입지시 변동분(추가,분납,삭제)'
if ls_value = 'D9' Then st_caption.Text = '검수합격통보서(월집계표)'
if ls_value = 'CKD9' Then st_caption.Text = 'CKD검수합격통보서(월집계표)'
if ls_value = 'DH' Then st_caption.Text = 'HPC-CODE 기초정보'
if ls_value = 'P6' Then st_caption.Text = '서열부품집계표(상세용)'
if ls_value = 'P7' Then st_caption.Text = '서열부품집계표(종합용)'
end event

type dw_list from w_standard_print`dw_list within w_sm10_0030_asan
integer x = 59
integer y = 532
integer width = 4503
integer height = 1752
string dataobject = "d_sm10_0030_asan_a"
boolean border = false
end type

event dw_list::clicked;f_multi_select(this)
end event

event dw_list::rowfocuschanged;//
end event

type p_search from uo_picture within w_sm10_0030_asan
integer x = 3575
integer y = 24
integer width = 178
integer taborder = 90
boolean bringtotop = true
string pointer = "C:\erpman\cur\create2.cur"
string picturename = "C:\erpman\image\생성_up.gif"
end type

event clicked;call super::clicked;Long ll_cnt
string ls_filename , ls_gubun , ls_reg_gb

If dw_ip.AcceptText() < 1 Then Return
If dw_ip.AcceptText() < 1 Then Return
If dw_ip.RowCount() < 1 Then Return

ls_gubun = Trim(dw_ip.Object.gubun[1])


pointer oldpointer
oldpointer = SetPointer(HourGlass!)

dw_list.reset()

Choose Case ls_gubun
	Case "D0"
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "ERPD0"
		ls_filename = "C:\HKC\VAN\ERPD0_HMC.CSV"
		ll_cnt = wf_erp_d0(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		ls_filename = "C:\HKC\VAN\ERPD0_KMC.CSV"
		ll_cnt = wf_erp_d0(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
	Case "CKD0"
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "CKDD0"
		ls_filename = "C:\HKC\VAN\CKDD0_HMC.CSV"
		ll_cnt = wf_ckd_d0(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		ls_filename = "C:\HKC\VAN\CKDD0_KMC.CSV"
		ll_cnt = wf_ckd_d0(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
	Case "D1"
	   il_succeed = 0
		ll_cnt=0
		ls_gubun = "ERPD1"
		ls_filename = "C:\HKC\VAN\ERPD1_HMC.CSV"
		ll_cnt = wf_erp_d1(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		ls_filename = "C:\HKC\VAN\ERPD1_KMC.CSV"
		ll_cnt = wf_erp_d1(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
	Case "CKD1"
	   il_succeed = 0
		ll_cnt=0
		ls_gubun = "CKDD1"
		ls_filename = "C:\HKC\VAN\CKDD1_HMC.CSV"
		ll_cnt = wf_ckd_d1(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		ls_filename = "C:\HKC\VAN\CKDD1_KMC.CSV"
		ll_cnt = wf_ckd_d1(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
	Case "D2"
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "ERPD2"
		ls_filename = "C:\HKC\VAN\ERPD2_HMC.CSV"
		ll_cnt = wf_erp_d2(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		il_succeed = 0
		ll_cnt=0
		ls_filename = "C:\HKC\VAN\ERPD2_KMC.CSV"
		ll_cnt = wf_erp_d2(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if		
	Case "CKD2"
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "CKDD2"
		ls_filename = "C:\HKC\VAN\CKDD2_HMC.CSV"
		ll_cnt = wf_ckd_d2(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		ls_filename = "C:\HKC\VAN\CKDD2_KMC.CSV"
		ll_cnt = wf_ckd_d2(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
	Case "D6"
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "ERPD6"
		ls_filename = "C:\HKC\VAN\ERPD6_HMC.CSV"
		ll_cnt = wf_erp_d68(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		ls_filename = "C:\HKC\VAN\ERPD6_KMC.CSV"
		ll_cnt = wf_erp_d68(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
	Case "D8"
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "ERPD8"
		ls_filename = "C:\HKC\VAN\ERPD8_HMC.CSV"
		ll_cnt = wf_erp_d68(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		ls_filename = "C:\HKC\VAN\ERPD8_KMC.CSV"
		ll_cnt = wf_erp_d68(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
	Case "CKD6"
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "CKDD6"
		ls_filename = "C:\HKC\VAN\CKDD6_HMC.CSV"
		ll_cnt = wf_ckd_d68(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		ls_filename = "C:\HKC\VAN\CKDD6_KMC.CSV"
		ll_cnt = wf_ckd_d68(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
	Case "CKD8"
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "CKDD8"
		ls_filename = "C:\HKC\VAN\CKDD8_HMC.CSV"
		ll_cnt = wf_ckd_d68(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		ls_filename = "C:\HKC\VAN\CKDD8_KMC.CSV"
		ll_cnt = wf_ckd_d68(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
	Case "D9"
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "ERPD9"
		ls_filename = "C:\HKC\VAN\ERPD9_HMC.CSV"
		ll_cnt = wf_erp_d9(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		ls_filename = "C:\HKC\VAN\ERPD9_KMC.CSV"
		ll_cnt = wf_erp_d9(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
	Case "CKD9"
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "CKDD9"
		ls_filename = "C:\HKC\VAN\CKDD9_HMC.CSV"
		ll_cnt = wf_ckd_d9(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		ls_filename = "C:\HKC\VAN\CKDD9_KMC.CSV"
		ll_cnt = wf_ckd_d9(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
	Case "DH"
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "ERPDH"
		ls_filename = "C:\HKC\VAN\ERPDH_HMC.CSV"
		ll_cnt = wf_erp_dh(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		ls_filename = "C:\HKC\VAN\ERPDH_KMC.CSV"
		ll_cnt = wf_erp_dh(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
	Case "P6"
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "ERPP6"
		ls_filename = "C:\HKC\VAN\ERPP6_HMC.CSV"
		ll_cnt = wf_erp_p6(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		ls_filename = "C:\HKC\VAN\ERPP6_KMC.CSV"
		ll_cnt = wf_erp_p6(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
	Case "P7"
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "ERPP7"
		ls_filename = "C:\HKC\VAN\ERPP7_HMC.CSV"
		ll_cnt = wf_erp_P7(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		ls_filename = "C:\HKC\VAN\ERPP7_KMC.CSV"
		ll_cnt = wf_erp_P7(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
	Case Else
	// "D0"
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "ERPD0"
		ls_filename = "C:\HKC\VAN\ERPD0_HMC.CSV"
		ll_cnt = wf_erp_d0(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		ls_filename = "C:\HKC\VAN\ERPD0_KMC.CSV"
		ll_cnt = wf_erp_d0(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
	// "CKD0"
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "CKDD0"
		ls_filename = "C:\HKC\VAN\CKDD0_HMC.CSV"
		ll_cnt = wf_ckd_d0(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		ls_filename = "C:\HKC\VAN\CKDD0_KMC.CSV"
		ll_cnt = wf_ckd_d0(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
	// "D1"
	   il_succeed = 0
		ll_cnt=0
		ls_gubun = "ERPD1"
		ls_filename = "C:\HKC\VAN\ERPD1_HMC.CSV"
		ll_cnt = wf_erp_d1(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		ls_filename = "C:\HKC\VAN\ERPD1_KMC.CSV"
		ll_cnt = wf_erp_d1(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
	// "CKD1"
	   il_succeed = 0
		ll_cnt=0
		ls_gubun = "CKDD1"
		ls_filename = "C:\HKC\VAN\CKDD1_HMC.CSV"
		ll_cnt = wf_ckd_d1(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		ls_filename = "C:\HKC\VAN\CKDD1_KMC.CSV"
		ll_cnt = wf_ckd_d1(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
	// "D2"
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "ERPD2"
		ls_filename = "C:\HKC\VAN\ERPD2_HMC.CSV"
		ll_cnt = wf_erp_d2(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		ls_filename = "C:\HKC\VAN\ERPD2_KMC.CSV"
		ll_cnt = wf_erp_d2(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
	// "CKD2"
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "CKDD2"
		ls_filename = "C:\HKC\VAN\CKDD2_HMC.CSV"
		ll_cnt = wf_ckd_d2(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		ls_filename = "C:\HKC\VAN\CKDD2_KMC.CSV"
		ll_cnt = wf_ckd_d2(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
	// "D6"
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "ERPD6"
		ls_filename = "C:\HKC\VAN\ERPD6_HMC.CSV"
		ll_cnt = wf_erp_d68(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		ls_filename = "C:\HKC\VAN\ERPD6_KMC.CSV"
		ll_cnt = wf_erp_d68(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
	// "D8"
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "ERPD8"
		ls_filename = "C:\HKC\VAN\ERPD8_HMC.CSV"
		ll_cnt = wf_erp_d68(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		ls_filename = "C:\HKC\VAN\ERPD8_KMC.CSV"
		ll_cnt = wf_erp_d68(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
	// "CKD6"
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "CKDD6"
		ls_filename = "C:\HKC\VAN\CKDD6_HMC.CSV"
		ll_cnt = wf_ckd_d68(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		ls_filename = "C:\HKC\VAN\CKDD6_KMC.CSV"
		ll_cnt = wf_ckd_d68(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
	// "CKD8"
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "CKDD8"
		ls_filename = "C:\HKC\VAN\CKDD8_HMC.CSV"
		ll_cnt = wf_ckd_d68(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		ls_filename = "C:\HKC\VAN\CKDD8_KMC.CSV"
		ll_cnt = wf_ckd_d68(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
	// "D9"
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "ERPD9"
		ls_filename = "C:\HKC\VAN\ERPD9_HMC.CSV"
		ll_cnt = wf_erp_d9(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		ls_filename = "C:\HKC\VAN\ERPD9_KMC.CSV"
		ll_cnt = wf_erp_d9(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
	// "CKD9"
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "CKDD9"
		ls_filename = "C:\HKC\VAN\CKDD9_HMC.CSV"
		ll_cnt = wf_ckd_d9(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		ls_filename = "C:\HKC\VAN\CKDD9_KMC.CSV"
		ll_cnt = wf_ckd_d9(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
	// "DH"
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "ERPDH"
		ls_filename = "C:\HKC\VAN\ERPDH_HMC.CSV"
		ll_cnt = wf_erp_dh(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		ls_filename = "C:\HKC\VAN\ERPDH_KMC.CSV"
		ll_cnt = wf_erp_dh(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
	// "P6"
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "ERPP6"
		ls_filename = "C:\HKC\VAN\ERPP6_HMC.CSV"
		ll_cnt = wf_erp_p6(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		ls_filename = "C:\HKC\VAN\ERPP6_KMC.CSV"
		ll_cnt = wf_erp_p6(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
	// "P7"
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "ERPP7"
		ls_filename = "C:\HKC\VAN\ERPP7_HMC.CSV"
		ll_cnt = wf_erp_P7(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		ls_filename = "C:\HKC\VAN\ERPP7_KMC.CSV"
		ll_cnt = wf_erp_P7(ls_gubun,ls_filename)
		If ll_cnt > 0 Then
			wf_error(ls_gubun,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		
End Choose

SetPointer(oldpointer)

If ll_cnt > 0 Then
	p_print.Enabled =True
	p_print.PictureName = 'C:\erpman\image\인쇄_up.gif'

	p_preview.enabled = True
	p_preview.PictureName = 'C:\erpman\image\미리보기_up.gif'
Else
	p_print.Enabled =False
	p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
End If	
SetPointer(Arrow!)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\생성_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\생성_up.gif"
end event

type p_delrow from uo_picture within w_sm10_0030_asan
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 3922
integer y = 24
integer width = 178
integer taborder = 40
boolean bringtotop = true
string pointer = "C:\erpman\cur\delrow.cur"
string picturename = "C:\erpman\image\행삭제_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\행삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\행삭제_up.gif"
end event

event clicked;call super::clicked;Long i ,ll_rcnt
string ls_gubun ,ls_saupj , ls_cvcod ,ls_date , ls_saupj_cust 
DataWindow ldw_x

if dw_ip.AcceptText() = -1 then return -1
if dw_ip.rowcount() <= 0 then return -1

ls_gubun = Trim(dw_ip.Object.gubun[1]) 
ls_saupj = Trim(dw_ip.Object.saupj[1])
ls_cvcod = Trim(dw_ip.Object.mcvcod[1])

ls_date = Trim(dw_ip.Object.jisi_date[1])

SetNull(ls_saupj_cust)

select fun_get_reffpf_value('AD',:ls_saupj,'4') Into :ls_saupj_cust
  from dual ;
If sqlca.sqlcode <> 0 Or ls_saupj_cust = '' Or isNull(ls_saupj_cust) Then
	MessageBox('확인','사업장을 선택하세요')
	Return -1
End If
	
If Tab_1.SelectedTab = 1 Then
	ldw_x = dw_list

Else
	Choose Case ls_gubun 
		Case 'D0'
			ldw_x = dw_d0
		Case 'CKD0'
			ldw_x = dw_ckd0
		Case 'D1'
			ldw_x = dw_d1
		Case 'CKD1'
			ldw_x = dw_ckd1
		Case 'D2'
			ldw_x = dw_d2
		Case 'CKD2'
			ldw_x = dw_ckd2
		Case 'D6'
			ldw_x = dw_d68
		Case 'D8'
			ldw_x = dw_d68
		Case 'D9'
			ldw_x = dw_d9
		Case 'CKD9'
			ldw_x = dw_ckd9
		Case 'DH'
			ldw_x = dw_dh
		Case 'P6'
			ldw_x = dw_p6
		Case 'P7'
			ldw_x = dw_p7
		
	End Choose
	
End IF


ll_rcnt = ldw_x.RowCount()

If ll_rcnt < 1 Then 
	MessageBox('확인','삭제할 데이타가 존재하지 않습니다.')
	Return
End IF
if f_msg_delete() = -1 then return

ldw_x.SetRedraw(FALSE)

String ls_citnbr

For i = ll_rcnt To 1 Step -1
	If ldw_x.isSelected(i) Then
		
		If ls_gubun = 'D6' or ls_gubun = 'D8' or ls_gubun = 'GI' or ls_gubun = 'GC' Then
			ls_citnbr =  Trim(ldw_x.Object.citnbr[i])
			
			If ls_citnbr = '1' or ls_citnbr = '2' Then 
				MessageBox('확인','출하등록 완료된 상태입니다. 삭제불가능합니다.')
				Return
			End iF
		End iF
		
		ldw_x.ScrollToRow(i)
		ldw_x.DeleteRow(i)
	End iF
Next

if ldw_x.Update() = 1 then
	
	commit ;
	sle_msg.text =	"모든자료를 삭제하였습니다!!"	
else
	rollback ;
   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
end if	
ldw_x.SetRedraw(TRUE)


end event

type p_delrow_all from uo_picture within w_sm10_0030_asan
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 3749
integer y = 24
integer width = 178
integer taborder = 90
boolean bringtotop = true
string pointer = "C:\erpman\cur\create2.cur"
string picturename = "C:\erpman\image\전체삭제_up.gif"
end type

event clicked;call super::clicked;Long i ,ll_rcnt
string ls_gubun ,ls_saupj , ls_cvcod ,ls_date , ls_saupj_cust
DataWindow ldw_x

if dw_ip.AcceptText() = -1 then return -1
if dw_ip.rowcount() <= 0 then return -1

ls_gubun = Trim(dw_ip.Object.gubun[1]) 
ls_saupj = Trim(dw_ip.Object.saupj[1])
ls_cvcod = Trim(dw_ip.Object.mcvcod[1])

ls_date = Trim(dw_ip.Object.jisi_date[1])

SetNull(ls_saupj_cust)

select fun_get_reffpf_value('AD',:ls_saupj,'4') Into :ls_saupj_cust
  from dual ;
If sqlca.sqlcode <> 0 Or ls_saupj_cust = '' Or isNull(ls_saupj_cust) Then
	MessageBox('확인','사업장을 선택하세요')
	Return -1
End If
	
If Tab_1.SelectedTab = 1 Then
	ldw_x = dw_list

Else
	Choose Case ls_gubun 
		Case 'D0'
			ldw_x = dw_d0
		Case 'CKD0'
			ldw_x = dw_ckd0
		Case 'D1'
			ldw_x = dw_d1
		Case 'CKD1'
			ldw_x = dw_ckd1
		Case 'D2'
			ldw_x = dw_d2
		Case 'CKD2'
			ldw_x = dw_ckd2
		Case 'D6'
			ldw_x = dw_d68
		Case 'D8'
			ldw_x = dw_d68
		Case 'D9'
			ldw_x = dw_d9
		Case 'CKD9'
			ldw_x = dw_ckd9
		Case 'DH'
			ldw_x = dw_dh
		Case 'P6'
			ldw_x = dw_p6
		Case 'P7'
			ldw_x = dw_p7
		
	End Choose
	
End IF


ll_rcnt = ldw_x.RowCount()

If ll_rcnt < 1 Then 
	MessageBox('확인','삭제할 데이타가 존재하지 않습니다.')
	Return
End IF
if f_msg_delete() = -1 then return

ldw_x.SetRedraw(FALSE)

String ls_citnbr

For i = ll_rcnt To 1 Step -1
	
	If ls_gubun = 'D6' or ls_gubun = 'D8' or ls_gubun = 'GI' or ls_gubun = 'GC'Then
		ls_citnbr =  Trim(ldw_x.Object.citnbr[i])
		
		If ls_citnbr = '1' or ls_citnbr = '2' Then 
			MessageBox('확인','출하등록 완료된 상태입니다. 삭제불가능합니다.')
			Return
		End iF
	End iF
	
	ldw_x.ScrollToRow(i)
	ldw_x.DeleteRow(i)
	
Next

if ldw_x.Update() = 1 then
	
	commit ;
	sle_msg.text =	"모든자료를 삭제하였습니다!!"	
else
	rollback ;
   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
end if	
ldw_x.SetRedraw(TRUE)




end event

type pb_1 from u_pb_cal within w_sm10_0030_asan
integer x = 663
integer y = 292
integer height = 76
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('jisi_date')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'jisi_date', gs_code)

end event

type dw_d2 from datawindow within w_sm10_0030_asan
integer x = 882
integer y = 1172
integer width = 686
integer height = 400
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "D2"
string dataobject = "d_sm10_0030_asan_d2"
boolean controlmenu = true
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
ls_sabu    = This.GetItemString(This.GetRow(), "van_hkcd2_sabu")
ls_doccode = This.GetItemString(This.GetRow(), "van_hkcd2_doccode")
ls_custcd  = This.GetItemString(This.GetRow(), "van_hkcd2_custcd")
ls_factory = This.GetItemString(This.GetRow(), "van_hkcd2_factory")
ls_itnbr   = This.GetItemString(This.GetRow(), "van_hkcd2_itnbr")

dw_d2_detail.Visible = True

dw_d2_detail.Retrieve(ls_sabu, ls_doccode, ls_custcd, ls_factory, ls_itnbr)
end event

type dw_d0 from datawindow within w_sm10_0030_asan
integer x = 174
integer y = 1172
integer width = 686
integer height = 400
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "D0"
string dataobject = "d_sm10_0030_asan_d0"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;f_multi_select(this)
end event

event itemfocuschanged;
If row < 1 Then Return

String ls_factory

ls_factory  = Trim(object.factory[row])

idwc_d0.Retrieve(ls_factory)
end event

type dw_d68 from datawindow within w_sm10_0030_asan
integer x = 1591
integer y = 1176
integer width = 686
integer height = 400
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "D68"
string dataobject = "d_sm10_0030_asan_d68"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;f_multi_select(this)
end event

type dw_gi from datawindow within w_sm10_0030_asan
integer x = 2309
integer y = 1184
integer width = 686
integer height = 400
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "긴급"
string dataobject = "d_sm10_0030_asan_d0"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;f_multi_select(this)
end event

type dw_dh from datawindow within w_sm10_0030_asan
integer x = 3022
integer y = 1188
integer width = 686
integer height = 400
integer taborder = 70
boolean bringtotop = true
boolean titlebar = true
string title = "DH"
string dataobject = "d_sm10_0030_asan_dh"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;f_multi_select(this)
end event

type dw_p6 from datawindow within w_sm10_0030_asan
integer x = 183
integer y = 1624
integer width = 686
integer height = 400
integer taborder = 70
boolean bringtotop = true
boolean titlebar = true
string title = "P6"
string dataobject = "d_sm10_0030_asan_p6"
boolean controlmenu = true
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

type dw_p7 from datawindow within w_sm10_0030_asan
integer x = 878
integer y = 1628
integer width = 686
integer height = 400
integer taborder = 80
boolean bringtotop = true
boolean titlebar = true
string title = "P7"
string dataobject = "d_sm10_0030_asan_p7"
boolean controlmenu = true
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

type dw_d1 from datawindow within w_sm10_0030_asan
integer x = 1573
integer y = 1628
integer width = 686
integer height = 400
integer taborder = 90
boolean bringtotop = true
boolean titlebar = true
string title = "D1"
string dataobject = "d_sm10_0030_asan_d1"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;f_multi_select(this)
end event

type dw_d9 from datawindow within w_sm10_0030_asan
integer x = 2299
integer y = 1632
integer width = 686
integer height = 400
integer taborder = 100
boolean bringtotop = true
boolean titlebar = true
string title = "D9"
string dataobject = "d_sm10_0030_asan_d9"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;f_multi_select(this)
end event

type dw_d3 from datawindow within w_sm10_0030_asan
integer x = 3031
integer y = 1632
integer width = 686
integer height = 400
integer taborder = 80
boolean bringtotop = true
boolean titlebar = true
string title = "D3"
string dataobject = "d_sm10_0030_asan_d0"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;f_multi_select(this)
end event

type st_state from statictext within w_sm10_0030_asan
boolean visible = false
integer x = 1691
integer y = 936
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

type tab_1 from tab within w_sm10_0030_asan
integer x = 18
integer y = 396
integer width = 4594
integer height = 1932
integer taborder = 70
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean raggedright = true
boolean focusonbuttondown = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.Control[]={this.tabpage_1,&
this.tabpage_2}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
end on

event selectionchanged;String ls_gubun , ls_jisi_date , ls_jisi_date2
dw_ip.AcceptText()
ls_gubun = Trim(dw_ip.Object.gubun[1])
ls_jisi_date = Trim(dw_ip.Object.jisi_date[1])
ls_jisi_date2 = Trim(dw_ip.Object.jisi_date2[1])
IF newindex = 1 Then
	
	dw_ip.DataObject = "d_sm10_0030_asan_1"
	
	dw_d0.visible = False
	dw_ckd0.visible = False				
	dw_d1.visible = False
	dw_ckd1.visible = false
	dw_d2.visible = False
	dw_ckd2.visible = False
	dw_d68.visible = False
	dw_d9.visible = False
	dw_ckd9.visible = false
	dw_dh.visible = False
	dw_p6.visible = False
	dw_p7.visible = False
	
	dw_list.visible = True
//	p_excel.visible = True
	pb_2.visible = False
	p_search.visible = True
	cb_d9_et.visible = True

Else

	dw_ip.DataObject = "d_sm10_0030_asan_2"
//	p_excel.visible = False
	pb_2.visible = True
	p_search.visible = False
	cb_d9_et.visible = False

	Choose Case ls_gubun
		Case 'D0'			
				dw_d0.x = dw_list.x
				dw_d0.y = dw_list.y
				dw_d0.width  = dw_list.width
				dw_d0.height = dw_list.height				
				dw_list.visible = False
				
				dw_d0.visible = True
				dw_ckd0.visible = False				
				dw_d1.visible = False
				dw_ckd1.visible = false
				dw_d2.visible = False
				dw_ckd2.visible = False
				dw_d68.visible = False
				dw_ckd68.visible = False
				dw_d9.visible = False
				dw_ckd9.visible = false
				dw_dh.visible = False
				dw_p6.visible = False
				dw_p7.visible = False
			
		Case 'CKD0'			
				dw_ckd0.x = dw_list.x
				dw_ckd0.y = dw_list.y
				dw_ckd0.width  = dw_list.width
				dw_ckd0.height = dw_list.height				
				dw_list.visible = False
				
				dw_d0.visible = False
				dw_ckd0.visible = True				
				dw_d1.visible = False
				dw_ckd1.visible = false
				dw_d2.visible = False
				dw_ckd2.visible = False
				dw_d68.visible = False
				dw_ckd68.visible = False
				dw_d9.visible = False
				dw_ckd9.visible = false
				dw_dh.visible = False
				dw_p6.visible = False
				dw_p7.visible = False

		Case 'D1'			
				dw_d1.x = dw_list.x
				dw_d1.y = dw_list.y
				dw_d1.width  = dw_list.width
				dw_d1.height = dw_list.height				
				dw_list.visible = False
				
				dw_d0.visible = False
				dw_ckd0.visible = False				
				dw_d1.visible = True
				dw_ckd1.visible = false
				dw_d2.visible = False
				dw_ckd2.visible = False
				dw_d68.visible = False
				dw_ckd68.visible = False
				dw_d9.visible = False
				dw_ckd9.visible = false
				dw_dh.visible = False
				dw_p6.visible = False
				dw_p7.visible = False
			
		Case 'CKD1'			
				dw_ckd1.x = dw_list.x
				dw_ckd1.y = dw_list.y
				dw_ckd1.width  = dw_list.width
				dw_ckd1.height = dw_list.height				
				dw_list.visible = False
				
				dw_d0.visible = False
				dw_ckd0.visible = False				
				dw_d1.visible = False
				dw_ckd1.visible = True
				dw_d2.visible = False
				dw_ckd2.visible = False
				dw_d68.visible = False
				dw_ckd68.visible = False
				dw_d9.visible = False
				dw_ckd9.visible = false
				dw_dh.visible = False
				dw_p6.visible = False
				dw_p7.visible = False

		Case 'D2'			
				dw_d2.x = dw_list.x
				dw_d2.y = dw_list.y
				dw_d2.width  = dw_list.width
				dw_d2.height = dw_list.height				
				dw_list.visible = False
				
				dw_d0.visible = False
				dw_ckd0.visible = False				
				dw_d1.visible = False
				dw_ckd1.visible = false
				dw_d2.visible = True
				dw_ckd2.visible = False
				dw_d68.visible = False
				dw_ckd68.visible = False
				dw_d9.visible = False
				dw_ckd9.visible = false
				dw_dh.visible = False
				dw_p6.visible = False
				dw_p7.visible = False

		Case 'CKD2'			
				dw_ckd2.x = dw_list.x
				dw_ckd2.y = dw_list.y
				dw_ckd2.width  = dw_list.width
				dw_ckd2.height = dw_list.height				
				dw_list.visible = False
				
				dw_d0.visible = False
				dw_ckd0.visible = False				
				dw_d1.visible = False
				dw_ckd1.visible = false
				dw_d2.visible = false
				dw_ckd2.visible = True
				dw_d68.visible = False
				dw_ckd68.visible = False
				dw_d9.visible = False
				dw_ckd9.visible = false
				dw_dh.visible = False
				dw_p6.visible = False
				dw_p7.visible = False

		Case 'D6','D8'			
				dw_d68.x = dw_list.x
				dw_d68.y = dw_list.y
				dw_d68.width  = dw_list.width
				dw_d68.height = dw_list.height				
				dw_list.visible = False
				
				dw_d0.visible = False
				dw_ckd0.visible = False				
				dw_d1.visible = False
				dw_ckd1.visible = false
				dw_d2.visible = False
				dw_ckd2.visible = False
				dw_d68.visible = True
				dw_ckd68.visible = False
				dw_d9.visible = False
				dw_ckd9.visible = false
				dw_dh.visible = False
				dw_p6.visible = False
				dw_p7.visible = False
			
		Case 'CKD6','CKD8'			
				dw_ckd68.x = dw_list.x
				dw_ckd68.y = dw_list.y
				dw_ckd68.width  = dw_list.width
				dw_ckd68.height = dw_list.height				
				dw_list.visible = False
				
				dw_d0.visible = False
				dw_ckd0.visible = False				
				dw_d1.visible = False
				dw_ckd1.visible = false
				dw_d2.visible = False
				dw_ckd2.visible = False
				dw_d68.visible = False
				dw_ckd68.visible = True
				dw_d9.visible = False
				dw_ckd9.visible = false
				dw_dh.visible = False
				dw_p6.visible = False
				dw_p7.visible = False
			
		Case 'D9'			
				dw_d9.x = dw_list.x
				dw_d9.y = dw_list.y
				dw_d9.width  = dw_list.width
				dw_d9.height = dw_list.height
				dw_list.visible = False
				
				dw_d0.visible = False
				dw_ckd0.visible = False				
				dw_d1.visible = False
				dw_ckd1.visible = false
				dw_d2.visible = False
				dw_ckd2.visible = False
				dw_d68.visible = False
				dw_ckd68.visible = False
				dw_d9.visible = True
				dw_ckd9.visible = false
				dw_dh.visible = false
				dw_p6.visible = False
				dw_p7.visible = False

		Case 'CKD9'			
				dw_ckd9.x = dw_list.x
				dw_ckd9.y = dw_list.y
				dw_ckd9.width  = dw_list.width
				dw_ckd9.height = dw_list.height
				dw_list.visible = False
				
				dw_d0.visible = False
				dw_ckd0.visible = False				
				dw_d1.visible = False
				dw_ckd1.visible = false
				dw_d2.visible = False
				dw_ckd2.visible = False
				dw_d68.visible = False
				dw_ckd68.visible = False
				dw_d9.visible = False
				dw_ckd9.visible = True
				dw_dh.visible = false
				dw_p6.visible = False
				dw_p7.visible = False

		Case 'DH'			
				dw_dh.x = dw_list.x
				dw_dh.y = dw_list.y
				dw_dh.width  = dw_list.width
				dw_dh.height = dw_list.height
				dw_list.visible = False
				
				dw_d0.visible = False
				dw_ckd0.visible = False				
				dw_d1.visible = False
				dw_ckd1.visible = false
				dw_d2.visible = False
				dw_ckd2.visible = False
				dw_d68.visible = False
				dw_ckd68.visible = False
				dw_d9.visible = False
				dw_ckd9.visible = false
				dw_dh.visible = True
				dw_p6.visible = False
				dw_p7.visible = False
			
		Case 'P6'			
				dw_p6.x = dw_list.x
				dw_p6.y = dw_list.y
				dw_p6.width  = dw_list.width
				dw_p6.height = dw_list.height
				dw_list.visible = False
				
				dw_d0.visible = False
				dw_ckd0.visible = False				
				dw_d1.visible = False
				dw_ckd1.visible = false
				dw_d2.visible = False
				dw_ckd2.visible = False
				dw_d68.visible = False
				dw_ckd68.visible = False
				dw_d9.visible = False
				dw_ckd9.visible = false
				dw_dh.visible = False
				dw_p6.visible = True
				dw_p7.visible = False
			
		Case 'P7'			
				dw_p7.x = dw_list.x
				dw_p7.y = dw_list.y
				dw_p7.width  = dw_list.width
				dw_p7.height = dw_list.height
				dw_list.visible = False
				
				dw_d0.visible = False
				dw_ckd0.visible = False				
				dw_d1.visible = False
				dw_ckd1.visible = false
				dw_d2.visible = False
				dw_ckd2.visible = False
				dw_d68.visible = False
				dw_ckd68.visible = False
				dw_d9.visible = False
				dw_ckd9.visible = false
				dw_dh.visible = False
				dw_p6.visible = False
				dw_p7.visible = True
		
	End Choose	
End If

dw_ip.SetTransObject(SQLCA)
dw_ip.InsertRow(0)
setnull(gs_code)
If f_check_saupj() = 1 Then
	dw_ip.SetItem(1, 'saupj', gs_code)
   if (gs_dept = '6LB2') or (gs_dept = '2F00') then
   	dw_ip.Modify("saupj.protect=0")
	else
   	dw_ip.Modify("saupj.protect=1")	
   End if
End If

dw_ip.Object.jisi_date[1] = ls_jisi_date
dw_ip.Object.jisi_date2[1] = ls_jisi_date2

IF newindex = 1 Then
	
	If ls_gubun = '' Or isNull(ls_gubun) Then
		ls_gubun ='AL'
	End If
   
	dw_ip.Object.gubun[1] = ls_gubun
	
Else
	If ls_gubun = 'AL' Then 
		dw_ip.Object.gubun[1] = 'D1'
		wf_choose('D1')
	Else
		dw_ip.Object.gubun[1] =  ls_gubun
	End iF
End if
end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 4558
integer height = 1804
long backcolor = 32106727
string text = " VAN 자료 생성"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
string picturename = "Compile!"
long picturemaskcolor = 536870912
rr_1 rr_1
end type

on tabpage_1.create
this.rr_1=create rr_1
this.Control[]={this.rr_1}
end on

on tabpage_1.destroy
destroy(this.rr_1)
end on

type rr_1 from roundrectangle within tabpage_1
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 9
integer y = 16
integer width = 4535
integer height = 1780
integer cornerheight = 40
integer cornerwidth = 55
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 4558
integer height = 1804
long backcolor = 32106727
string text = " VAN 자료 조회"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
string picturename = "Asterisk!"
long picturemaskcolor = 536870912
rr_2 rr_2
end type

on tabpage_2.create
this.rr_2=create rr_2
this.Control[]={this.rr_2}
end on

on tabpage_2.destroy
destroy(this.rr_2)
end on

type rr_2 from roundrectangle within tabpage_2
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 9
integer y = 16
integer width = 4535
integer height = 1780
integer cornerheight = 40
integer cornerwidth = 55
end type

type pb_2 from u_pb_cal within w_sm10_0030_asan
boolean visible = false
integer x = 1147
integer y = 292
integer height = 76
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('jisi_date2')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'jisi_date2', gs_code)

end event

type p_excel from uo_picture within w_sm10_0030_asan
integer x = 4443
integer y = 228
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\엑셀변환_up.gif"
end type

event clicked;call super::clicked;//If dw_list.RowCount() < 1 Then Return
//If Tab_1.SelectedTab <> 1 Then Return
//string ls_path, ls_file
//int li_rc
//
//li_rc = GetFileSaveName ( "Select File", ls_path, ls_file, "XLS", "Excel Files (*.xls),*.xls",'C:\', 32770)
//dw_list.SaveAs(ls_path, Excel!, FALSE)

String ls_gubun
DataWindow ldw_x

if dw_ip.AcceptText() = -1 then return -1
if dw_ip.rowcount() <= 0 then return -1

If Tab_1.SelectedTab = 1 Then
	ldw_x = dw_list
Else
	ls_gubun = Trim(dw_ip.Object.gubun[1]) 
	Choose Case ls_gubun 
		Case 'D0'
			ldw_x = dw_d0
		Case 'CKD0'
			ldw_x = dw_ckd0
		Case 'D1'
			ldw_x = dw_d1
		Case 'CKD1'
			ldw_x = dw_ckd1
		Case 'D2'
			ldw_x = dw_d2
		Case 'CKD2'
			ldw_x = dw_ckd2
		Case 'D6'
			ldw_x = dw_d68
		Case 'D8'
			ldw_x = dw_d68
		Case 'CKD6'
			ldw_x = dw_ckd68
			ls_gubun = 'D6'
		Case 'CKD8'
			ldw_x = dw_ckd68
		Case 'D9'
			ldw_x = dw_d9
		Case 'CKD9'
			ldw_x = dw_ckd9
		Case 'DH'
			ldw_x = dw_dh
		Case 'P6'
			ldw_x = dw_p6
			ls_gubun = 'P6'
		Case 'P7'
			ldw_x = dw_p7
		
	End Choose
End if
string ls_path, ls_file
int li_rc

If ldw_x.RowCount() < 1 Then Return
If this.Enabled Then wf_excel_down(ldw_x)
//li_rc = GetFileSaveName ( "Select File", ls_path, ls_file, "XLS", "Excel Files (*.xls),*.xls",'C:\HKC\', 32770)
//ldw_x.SaveAs(ls_path, Excel!, FALSE)
end event

type dw_d2_detail from datawindow within w_sm10_0030_asan
boolean visible = false
integer x = 114
integer y = 656
integer width = 3621
integer height = 196
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "소요량 상세"
string dataobject = "d_sm10_p0030_d2_detail"
boolean border = false
boolean livescroll = true
end type

event buttonclicked;This.Visible = False
end event

type st_caption from statictext within w_sm10_0030_asan
integer x = 1207
integer y = 416
integer width = 1902
integer height = 80
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

type p_mod from uo_picture within w_sm10_0030_asan
integer x = 4270
integer y = 24
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;call super::clicked;If Tab_1.SelectedTab = 2 Then
	
	If dw_ip.AcceptText() < 1 Then Return
	
	If Trim(dw_ip.Object.gubun[1]) = "D0" Then
		
	   if f_msg_update() < 1 Then Return
		
		If dw_d0.AcceptText() < 1 Then Return
		
		If dw_d0.Update() < 1 Then
			MessageBox("DB ERROR",sqlca.sqlerrText)
			Rollback;
			Return
		Else
			Commit;
		End iF
	End IF

Else
	MessageBox('확인','조회 상태에만 저장 가능합니다.')
	Return
End IF
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type dw_dc from datawindow within w_sm10_0030_asan
integer x = 882
integer y = 784
integer width = 686
integer height = 400
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "DC"
string dataobject = "d_sm10_0030_asan_d0"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;f_multi_select(this)
end event

event doubleclicked;/*
String ls_sabu, ls_doccode, ls_custcd, ls_factory, ls_itnbr
			
//DataWindow 크기 재정의			
dw_d2_detail.x = 443
dw_d2_detail.y = 1196
dw_d2_detail.Width = 3621
dw_d2_detail.Height = 1144

//DoubleClick한 Row의 PK 값을 받아온다
ls_sabu    = This.GetItemString(This.GetRow(), "van_hkcdC_sabu")
ls_doccode = This.GetItemString(This.GetRow(), "van_hkcdC_doccode")
ls_custcd  = This.GetItemString(This.GetRow(), "van_hkcdC_custcd")
ls_factory = This.GetItemString(This.GetRow(), "van_hkcdC_factory")
ls_itnbr   = This.GetItemString(This.GetRow(), "van_hkcd_itnbr")

dw_d2_detail.Visible = True

dw_d2_detail.Retrieve(ls_sabu, ls_doccode, ls_custcd, ls_factory, ls_itnbr)
*/
end event

type dw_ckd1 from datawindow within w_sm10_0030_asan
integer x = 1573
integer y = 784
integer width = 686
integer height = 400
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "CKD1"
string dataobject = "d_sm10_0030_asan_ckd1"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;f_multi_select(this)
end event

type dw_ckd9 from datawindow within w_sm10_0030_asan
integer x = 2290
integer y = 792
integer width = 686
integer height = 400
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "CKD9"
string dataobject = "d_sm10_0030_asan_ckd9"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;f_multi_select(this)
end event

type dw_ckd0 from datawindow within w_sm10_0030_asan
integer x = 3026
integer y = 780
integer width = 686
integer height = 400
integer taborder = 70
boolean bringtotop = true
boolean titlebar = true
string title = "CKD0"
string dataobject = "d_sm10_0030_asan_ckd0"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;f_multi_select(this)
end event

type dw_ckd68 from datawindow within w_sm10_0030_asan
integer x = 174
integer y = 752
integer width = 686
integer height = 400
integer taborder = 80
boolean bringtotop = true
boolean titlebar = true
string title = "CKD68"
string dataobject = "d_sm10_0030_asan_ckd68"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

type dw_ckd2 from datawindow within w_sm10_0030_asan
integer x = 3749
integer y = 776
integer width = 686
integer height = 400
integer taborder = 80
boolean bringtotop = true
boolean titlebar = true
string title = "CKD2"
string dataobject = "d_sm10_0030_asan_ckd2"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

type cb_d9_et from commandbutton within w_sm10_0030_asan
integer x = 3333
integer y = 236
integer width = 544
integer height = 128
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "월검수등록(기타)"
end type

event clicked;uo_xlobject uo_xl , uo_xltemp
string ls_doccode, ls_ipsource, ls_ipgubun
string ls_mitnbr, ls_mcvcod, ls_mdcvcod, ls_citnbr, ls_CRT_DATE, ls_CRT_TIME
String ls_saupj , ls_itnbr , ls_ymd ,ls_plant,ls_factory ,ls_cvcod ,ls_btime , ls_arrymd , ls_arrtime
string ls_docname, ls_named[] ,ls_line 
Long   ll_xl_row , ll_r , ix ,i , ll_cnt=0 , ll_c , ll_value , iii=0
Long   ll_err , ll_succeed  
String ls_file , ls_orderno
Long ll_seq , ll_jpno  , ll_count
String ls_custcd , ls_iojpno[]
double ld_IPTQTY,ld_IPTAMT,ld_PACKTAMT

If dw_ip.AcceptText() <> 1 Then Return

ls_saupj = Trim(dw_ip.Object.saupj[1]) 


// 엘셀 IMPORT ***************************************************************
ll_value = GetFileOpenName("일일 납품실적 데이타 가져오기", ls_docname, ls_named[], & 
             "XLS", "XLS Files (*.XLS),*.XLS,")
If ll_value <> 1 Then Return

Setpointer(Hourglass!)

ll_err = 0
ll_succeed = 0
ll_cnt = 0

If  FileExists('c:\erpman\bin\date_conv.xls') = False Then
	MessageBox('확인','date_conv.xls'+' 파일이 존재하지 않습니다.')
	Return
End If 

uo_xltemp = create uo_xlobject
uo_xltemp.uf_excel_connect('c:\erpman\bin\date_conv.xls', false , 3)
uo_xltemp.uf_selectsheet(1)
uo_xltemp.uf_set_format(1,1, '@' + space(30))

st_state.visible = True

Select fun_get_reffpf_value('AD' , :ls_saupj , 4 ) Into :ls_custcd from dual ; 

For ix = 1 To UpperBound(ls_named)
	
	If UpperBound(ls_named) = 1 Then
		ls_file = ls_docname
	else
		ls_file = ls_docname +'\'+ ls_named[ix]
	end if
	
	st_state.text = ls_file + " 파일을 읽고 있습니다."
	
	If  FileExists(ls_file) = False Then
		MessageBox('확인',ls_file+' 파일이 존재하지 않습니다.')
		st_state.visible = false
		Return
	End If 
	
			
	//엑셀과 연결
	uo_xl = create uo_xlobject
	uo_xl.uf_excel_connect(ls_file, false , 3)
	uo_xl.uf_selectsheet(1)
	
	ll_cnt = 0
	//Data 시작 Row Setting
	ll_xl_row = 6		

	Do While(True)
		
		//Data가 없을경우엔 Return...........
		if isnull(uo_xl.uf_gettext(ll_xl_row,2)) or trim(uo_xl.uf_gettext(ll_xl_row,2)) = '' then exit
		
		For i =1 To 15
			uo_xl.uf_set_format(ll_xl_row,i, '@' + space(30))
		Next
		
		SetNull(ls_mitnbr)
		SetNull(ls_mcvcod)
		SetNull(ls_mdcvcod)
		SetNull(ls_citnbr)
		
		ll_cnt ++
		yield()
	
		ls_doccode = Trim(uo_xl.uf_gettext(ll_xl_row,2))
		ls_custcd  = ls_custcd
		ls_factory = Trim(uo_xl.uf_gettext(ll_xl_row,3))
		ls_itnbr   = Trim(uo_xl.uf_gettext(ll_xl_row,4))
		ls_ipsource= 'V'
		ls_ipgubun = 'A'
		
		st_state.text =String(ll_xl_row) +" 행의 " +ls_itnbr+ ' 품번을 읽고 있습니다.'
	
		If isNull(ls_ipsource)  Or ls_ipsource = "" Then ls_ipsource = "."	
		If isNull(ls_ipgubun)  Or ls_ipgubun = "" Then  ls_ipgubun = "." 
	
		ld_iptqty  = Long(Trim(uo_xl.uf_gettext(ll_xl_row,7)))
		ld_iptamt  = Long(Trim(uo_xl.uf_gettext(ll_xl_row,8)))
		ld_packtamt= 0
		
		
		//공장별 거래처 읽어오기
		select fun_get_scvcod( :ls_factory , :ls_mitnbr ,''  ),
				 nvl(RFNA3,'')
		  Into :ls_mcvcod , :ls_mdcvcod
		  from reffpf 
		where sabu = :gs_sabu and
				rfcod = '2A' and
				rfgub = :ls_factory;
				
		if sqlca.sqlcode <> 0 or &
			trim(ls_mcvcod)	= '' or trim(ls_mdcvcod) = '' or &
			isNull(ls_mcvcod)	 or isNull(ls_mdcvcod) then
			wf_error(ls_file,ll_cnt,ls_doccode,ls_factory,ls_itnbr,'참조테이블에(REFFPF) 납품공장-거래처 코드가 없습니다.')
			ll_err++
			Continue ;
		end if
		
		ls_mcvcod = trim(ls_mcvcod)
		ls_mdcvcod = trim(ls_mdcvcod)
	
		// 한텍 요청 //////////////////////////////////////////////////////
		ll_cnt = 0 
		select count(*) Into :ll_cnt
		  from VAN_ERPD9
		 where SABU=   :gs_SABU
			and DOCCODE = :ls_DOCCODE   
			and CUSTCD = :ls_CUSTCD  
			and FACTORY = :ls_FACTORY 
			and ITNBR = :ls_ITNBR 
			and IPSOURCE = :ls_ipsource 
			and IPGUBUN = :ls_ipgubun ;
			
		If ll_cnt > 0 Then
			wf_error(ls_file,ll_cnt,ls_doccode,ls_factory,ls_itnbr," 이미 입력된 데이타입니다.(계속진행..)" + '[열위치:'+string(ll_cnt)+']')
			ll_xl_row ++		
			ll_succeed++
			Continue ;
		end if
		
	
		/////////////////////////////////////////////////////////
		insert into VAN_ERPD9(SABU,DOCCODE,CUSTCD,FACTORY,ITNBR,IPSOURCE,IPGUBUN,IPTQTY,IPTAMT,PACKTAMT,CRT_DATE,CRT_TIME,CRT_USER,CITNBR,
													MITNBR,MCVCOD,MDCVCOD)       
						values(:gs_SABU,:ls_DOCCODE,:ls_CUSTCD,:ls_FACTORY,:ls_ITNBR,:ls_IPSOURCE,:ls_IPGUBUN,:ld_IPTQTY,:ld_IPTAMT,:ld_PACKTAMT,:ls_CRT_DATE,:ls_CRT_TIME,:gs_empno,NULL,
									  :ls_ITNBR,:ls_MCVCOD,:ls_MDCVCOD);
	
		if sqlca.sqlcode <> 0 then		
			wf_error(ls_file,ll_cnt,ls_doccode,ls_factory,ls_itnbr,sqlca.sqlerrText+" 입력에러가 발생했습니다." + '[열위치:'+string(ll_cnt)+']')
			rollback;
			uo_xltemp.uf_excel_Disconnect()
			uo_xl.uf_excel_Disconnect()
			st_state.visible = false
			return
		end if

		ll_xl_row ++		
		ll_succeed++
		
		w_mdi_frame.sle_msg.text = ls_named[ix]+ ' 파일의 '+String(ll_xl_row) + '행을 읽고 있습니다.'
		
	Loop
	
	uo_xl.uf_excel_Disconnect()
	// 엘셀 IMPORT  END ***************************************************************

Next

//st_state.text =' 데이타를 저장 중입니다.'

commit;

st_state.visible = false
uo_xltemp.uf_excel_Disconnect()
messagebox('확인','데이타 접수완료!!!')
st_state.text =''
end event

type cb_1 from commandbutton within w_sm10_0030_asan
integer x = 3886
integer y = 236
integer width = 544
integer height = 132
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "일검수등록(기타)"
end type

event clicked;uo_xlobject uo_xl , uo_xltemp
string ls_doccode, ls_ipsource, ls_ipgubun
string ls_mitnbr, ls_mcvcod, ls_mdcvcod, ls_citnbr, ls_CRT_DATE, ls_CRT_TIME, ls_crt_user
String ls_saupj , ls_itnbr , ls_ymd ,ls_plant,ls_factory ,ls_cvcod ,ls_btime , ls_arrymd , ls_arrtime
string ls_docname, ls_named[] ,ls_line 
Long   ll_xl_row , ll_r , ix ,i , ll_cnt=0 , ll_c , ll_value , iii=0
Long   ll_err , ll_succeed  
String ls_file , ls_orderno
Long ll_seq , ll_jpno  , ll_count
String ls_custcd , ls_iojpno[]
double ld_IPTQTY,ld_IPTAMT,ld_PACKTAMT, ld_ipdan
String ls_ipdate

If dw_ip.AcceptText() <> 1 Then Return

ls_saupj = Trim(dw_ip.Object.saupj[1]) 


//현재일자,시간
ls_crt_date = string(today(),'yyyymmdd')
ls_crt_time = string(today(),'hhmm')
ls_crt_user = gs_userid 


// 엘셀 IMPORT ***************************************************************
ll_value = GetFileOpenName("일일 납품실적 데이타 가져오기", ls_docname, ls_named[], & 
             "XLS", "XLS Files (*.XLS),*.XLS,")
If ll_value <> 1 Then Return

Setpointer(Hourglass!)

ll_err = 0
ll_succeed = 0
ll_cnt = 0

If  FileExists('c:\erpman\bin\date_conv.xls') = False Then
	MessageBox('확인','date_conv.xls'+' 파일이 존재하지 않습니다.')
	Return
End If 

uo_xltemp = create uo_xlobject
uo_xltemp.uf_excel_connect('c:\erpman\bin\date_conv.xls', false , 3)
uo_xltemp.uf_selectsheet(1)
uo_xltemp.uf_set_format(1,1, '@' + space(30))

st_state.visible = True

Select fun_get_reffpf_value('AD' , :ls_saupj , 4 ) Into :ls_custcd from dual ; 

For ix = 1 To UpperBound(ls_named)
	
	If UpperBound(ls_named) = 1 Then
		ls_file = ls_docname
	else
		ls_file = ls_docname +'\'+ ls_named[ix]
	end if
	
	st_state.text = ls_file + " 파일을 읽고 있습니다."
	
	If  FileExists(ls_file) = False Then
		MessageBox('확인',ls_file+' 파일이 존재하지 않습니다.')
		st_state.visible = false
		Return
	End If 
	
			
	//엑셀과 연결
	uo_xl = create uo_xlobject
	uo_xl.uf_excel_connect(ls_file, false , 3)
	uo_xl.uf_selectsheet(1)
	
	ll_cnt = 0
	//Data 시작 Row Setting
	ll_xl_row = 6		

	Do While(True)
		
		//Data가 없을경우엔 Return...........
		if isnull(uo_xl.uf_gettext(ll_xl_row,2)) or trim(uo_xl.uf_gettext(ll_xl_row,2)) = '' then exit
		
		For i =1 To 15
			uo_xl.uf_set_format(ll_xl_row,i, '@' + space(30))
		Next
		
		SetNull(ls_mitnbr)
		SetNull(ls_mcvcod)
		SetNull(ls_mdcvcod)
		SetNull(ls_citnbr)
		
		ll_cnt ++
		yield()
	
		ls_doccode = Trim(uo_xl.uf_gettext(ll_xl_row,2))
		ls_custcd  = ls_custcd
		ls_factory = Trim(uo_xl.uf_gettext(ll_xl_row,3))
		ls_itnbr   = Trim(uo_xl.uf_gettext(ll_xl_row,4))
		ls_ipsource= 'V'
		ls_ipgubun = 'A'
		
		st_state.text =String(ll_xl_row) +" 행의 " +ls_itnbr+ ' 품번을 읽고 있습니다.'
	
		If isNull(ls_ipsource)  Or ls_ipsource = "" Then ls_ipsource = "."	
		If isNull(ls_ipgubun)  Or ls_ipgubun = "" Then  ls_ipgubun = "." 
	
		ld_iptqty  = Long(Trim(uo_xl.uf_gettext(ll_xl_row,7)))
		ld_iptamt  = Long(Trim(uo_xl.uf_gettext(ll_xl_row,8)))
		ld_ipdan  = Long(Trim(uo_xl.uf_gettext(ll_xl_row,9)))
		If isNull(ld_ipdan) or ld_ipdan = 0 Then
			ld_ipdan = ld_iptamt / ld_iptqty
		End If
		ls_ipdate = Trim(uo_xl.uf_gettext(ll_xl_row,10))
		ld_packtamt= 0
		
		
		//공장별 거래처 읽어오기
		select fun_get_scvcod( :ls_factory , :ls_mitnbr ,''  ),
				 nvl(RFNA3,'')
		  Into :ls_mcvcod , :ls_mdcvcod
		  from reffpf 
		where sabu = :gs_sabu and
				rfcod = '2A' and
				rfgub = :ls_factory;
				
		if sqlca.sqlcode <> 0 or &
			trim(ls_mcvcod)	= '' or trim(ls_mdcvcod) = '' or &
			isNull(ls_mcvcod)	 or isNull(ls_mdcvcod) then
			wf_error(ls_file,ll_cnt,ls_doccode,ls_factory,ls_itnbr,'참조테이블에(REFFPF) 납품공장-거래처 코드가 없습니다.')
			ll_err++
			Continue ;
		end if
		
		ls_mcvcod = trim(ls_mcvcod)
		ls_mdcvcod = trim(ls_mdcvcod)
	
		// 한텍 요청 //////////////////////////////////////////////////////
		ll_cnt = 0 
//		select count(*) Into :ll_cnt
//		  from VAN_ERPD9
//		 where SABU=   :gs_SABU
//			and DOCCODE = :ls_DOCCODE   
//			and CUSTCD = :ls_CUSTCD  
//			and FACTORY = :ls_FACTORY 
//			and ITNBR = :ls_ITNBR 
//			and IPSOURCE = :ls_ipsource 
//			and IPGUBUN = :ls_ipgubun ;
		//기등록자료CHECK
		SELECT COUNT(*) INTO :ll_cnt
		  FROM VAN_ERPD1
		 WHERE SABU		= :gs_sabu
			AND DOCCODE = :ls_DOCCODE
			AND CUSTCD  = :ls_CUSTCD
			AND FACTORY = :ls_FACTORY
			AND ITNBR   = :ls_ITNBR
			AND IPSOURCE = :ls_ipsource
			//AND IPGUBUN = :ls_data[9] PK값이 아님. - BY SHINGOON 2013.11.05
//			AND JAJENO  = :ls_data[25]
//			AND JAITNO  = :ls_data[26] ;
			;
		If ll_cnt > 0 Then
			wf_error(ls_file,ll_cnt,ls_doccode,ls_factory,ls_itnbr," 이미 입력된 데이타입니다.(계속진행..)" + '[열위치:'+string(ll_cnt)+']')
			Continue ;
		end if
		
	
		/////////////////////////////////////////////////////////
		insert into VAN_ERPD1(SABU,DOCCODE,CUSTCD,FACTORY,ITNBR,IPSOURCE,IPGUBUN,IPQTY,IPAMT,CRT_DATE,CRT_TIME,CRT_USER,CITNBR,
													MITNBR,MCVCOD,MDCVCOD,JAJENO,JAITNO,IPHDATE,IPDATE, IPHQTY, IPDAN)       
						values(:gs_SABU,:ls_DOCCODE,:ls_CUSTCD,:ls_FACTORY,:ls_ITNBR,:ls_IPSOURCE,:ls_IPGUBUN,:ld_IPTQTY,:ld_IPTAMT,:ls_CRT_DATE,:ls_CRT_TIME,:ls_crt_user,NULL,
									  :ls_ITNBR,:ls_MCVCOD,:ls_MDCVCOD,'.',0, :ls_ipdate, :ls_ipdate,:ld_IPTQTY, :ld_ipdan);
	
		if sqlca.sqlcode <> 0 then		
			wf_error(ls_file,ll_cnt,ls_doccode,ls_factory,ls_itnbr,sqlca.sqlerrText+" 입력에러가 발생했습니다." + '[열위치:'+string(ll_cnt)+']')
			rollback;
			uo_xltemp.uf_excel_Disconnect()
			uo_xl.uf_excel_Disconnect()
			st_state.visible = false
			return
		end if

		ll_xl_row ++		
		ll_succeed++
		
		w_mdi_frame.sle_msg.text = ls_named[ix]+ ' 파일의 '+String(ll_xl_row) + '행을 읽고 있습니다.'
		
	Loop
	
	uo_xl.uf_excel_Disconnect()
	// 엘셀 IMPORT  END ***************************************************************

Next

//st_state.text =' 데이타를 저장 중입니다.'

commit;

st_state.visible = false
uo_xltemp.uf_excel_Disconnect()
messagebox('확인','데이타 접수완료!!!')
st_state.text =''
end event

