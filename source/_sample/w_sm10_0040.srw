$PBExportHeader$w_sm10_0040.srw
$PBExportComments$VAN 접수
forward
global type w_sm10_0040 from w_standard_print
end type
type p_search from uo_picture within w_sm10_0040
end type
type p_delrow from uo_picture within w_sm10_0040
end type
type p_delrow_all from uo_picture within w_sm10_0040
end type
type pb_1 from u_pb_cal within w_sm10_0040
end type
type dw_br from datawindow within w_sm10_0040
end type
type dw_ar from datawindow within w_sm10_0040
end type
type dw_er from datawindow within w_sm10_0040
end type
type dw_fr from datawindow within w_sm10_0040
end type
type dw_nr from datawindow within w_sm10_0040
end type
type dw_or from datawindow within w_sm10_0040
end type
type tab_1 from tab within w_sm10_0040
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
type tab_1 from tab within w_sm10_0040
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type pb_2 from u_pb_cal within w_sm10_0040
end type
type st_ing from statictext within w_sm10_0040
end type
type p_excel from uo_picture within w_sm10_0040
end type
type dw_hr from datawindow within w_sm10_0040
end type
type p_1 from uo_picture within w_sm10_0040
end type
type cb_1 from commandbutton within w_sm10_0040
end type
type lb_1 from listbox within w_sm10_0040
end type
type st_state from statictext within w_sm10_0040
end type
end forward

global type w_sm10_0040 from w_standard_print
integer width = 4677
integer height = 2508
string title = "MOBIS A/S  VAN 접수"
boolean resizable = true
p_search p_search
p_delrow p_delrow
p_delrow_all p_delrow_all
pb_1 pb_1
dw_br dw_br
dw_ar dw_ar
dw_er dw_er
dw_fr dw_fr
dw_nr dw_nr
dw_or dw_or
tab_1 tab_1
pb_2 pb_2
st_ing st_ing
p_excel p_excel
dw_hr dw_hr
p_1 p_1
cb_1 cb_1
lb_1 lb_1
st_state st_state
end type
global w_sm10_0040 w_sm10_0040

type variables
String is_custid , is_path
Long il_err , il_succeed
end variables

forward prototypes
public function integer wf_retrieve ()
public function long wf_van_scan_chk (string arg_value, string arg_value_1)
public function string wf_choose (string as_gubun)
public subroutine wf_error (string as_gubun, long al_line, string as_doccode, string as_factory, string as_itnbr, string as_errtext)
public function double wf_van_scan_chk2 (string arg_gubun, string arg_value, string arg_value_1)
public function integer wf_van_ar (string arg_file_name, string arg_sabu)
public function integer wf_van_br (string arg_file_name, string arg_sabu)
public function integer wf_van_br_new (string arg_file_name, string arg_sabu)
public function integer wf_van_er (string arg_file_name, string arg_sabu)
public function integer wf_van_fr (string arg_file_name, string arg_sabu)
public function integer wf_van_hr (string arg_file_name, string arg_sabu, string as_gubun)
public function integer wf_van_nr (string arg_file_name, string arg_sabu, string as_gubun)
public function integer wf_van_ir (string arg_file_name, string arg_sabu, string as_gubun)
public subroutine wf_process (string process_gb, string process_fname)
public function long wf_itnbr_insert (string ar_itnbr, string ar_itdsc)
public function integer wf_van_nr_new (string arg_file_name, string arg_sabu, string as_gubun)
end prototypes

public function integer wf_retrieve ();Long i ,ll_rcnt
string ls_gubun ,ls_saupj , ls_cvcod ,ls_sdate  ,ls_edate, ls_saupj_cust , ls_itnbr, ls_gub
DataWindow ldw_x

If Tab_1.SelectedTab = 1 Then Return -1
if dw_ip.AcceptText() = -1 then return -1
if dw_ip.rowcount() <= 0 then return -1

ls_gubun = Trim(dw_ip.Object.gubun[1]) 
ls_saupj = Trim(dw_ip.Object.saupj[1])
ls_cvcod = Trim(dw_ip.Object.mcvcod[1])

ls_sdate = Trim(dw_ip.Object.jisi_date[1])
ls_edate = Trim(dw_ip.Object.jisi_date2[1])
ls_gub   = Trim(dw_ip.Object.gub[1])

ls_itnbr = Trim(dw_ip.Object.itnbr[1])

If ls_itnbr = '' Or isNull(ls_itnbr) Then ls_itnbr = '%'

If ls_gub = '' OR IsNull(ls_gub) Then ls_gub = '%'

SetNull(ls_saupj_cust)

//select fun_get_reffpf_value('AD',:ls_saupj,'4') Into :ls_saupj_cust
//  from dual ;
//If sqlca.sqlcode <> 0 Or ls_saupj_cust = '' Or isNull(ls_saupj_cust) Then
//	MessageBox('확인','사업장을 선택하세요')
//	Return -1
//End If

Choose Case ls_gubun 
	Case 'AR'
		ldw_x = dw_ar
		ldw_x.Retrieve(ls_saupj, ls_itnbr )
	Case 'BR'
		ldw_x = dw_br
		ldw_x.Retrieve(ls_saupj, ls_itnbr, ls_gub )		
	Case 'ER'
		ldw_x = dw_er
		ldw_x.Retrieve(ls_saupj, ls_itnbr )		
	Case 'FR'
		ldw_x = dw_fr
		ldw_x.Retrieve(ls_saupj, ls_itnbr )		
	Case 'NR'
		ldw_x = dw_nr
		ldw_x.Retrieve(ls_saupj  , ls_sdate ,ls_edate, ls_itnbr )		
	Case 'OR'
		ldw_x = dw_or
		ldw_x.Retrieve(ls_saupj  , ls_sdate ,ls_edate, ls_itnbr )		
	Case 'HR'
		ldw_x = dw_hr
		ldw_x.Retrieve(ls_saupj  , ls_sdate ,ls_edate, ls_itnbr )		
End Choose

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

public function string wf_choose (string as_gubun);Choose Case as_gubun
	Case 'AR'
		If Tab_1.SelectedTab = 2 Then
			dw_ar.x = dw_list.x
			dw_ar.y = dw_list.y
			dw_ar.width  = dw_list.width
			dw_ar.height = dw_list.height
			
			dw_list.visible = False
			
			dw_ar.visible = True
			dw_br.visible = False
			dw_er.visible = False
			dw_fr.visible = False
			dw_nr.visible = False
			dw_or.visible = False
			dw_hr.visible = False
			
			pb_1.visible = False
			pb_2.visible = False

		End If
		return "C:\PROJECT\HYUNDAI\VAN"
	Case 'BR'
		If Tab_1.SelectedTab = 2 Then
			dw_br.x = dw_list.x 
			dw_br.y = dw_list.y 
			dw_br.width  = dw_list.width
			dw_br.height = dw_list.height
			
			dw_list.visible = False
			
			dw_ar.visible = False
			dw_br.visible = True
			dw_er.visible = False
			dw_fr.visible = False
			dw_nr.visible = False
			dw_or.visible = False
			dw_hr.visible = False
			
			pb_1.visible = False
			pb_2.visible = False
			
		End If
		return "C:\PROJECT\HYUNDAI\VAN"
	Case 'ER'
		If Tab_1.SelectedTab = 2 Then
			dw_er.x = dw_list.x
			dw_er.y = dw_list.y
			dw_er.width  = dw_list.width
			dw_er.height = dw_list.height
			
			dw_list.visible = False
			
			dw_ar.visible = False
			dw_br.visible = False
			dw_er.visible = True
			dw_fr.visible = False
			dw_nr.visible = False
			dw_or.visible = False
			dw_hr.visible = False
			
			pb_1.visible = False
			pb_2.visible = False

			
		End if
		return "C:\PROJECT\HYUNDAI\VAN"
	Case 'FR'
		If Tab_1.SelectedTab = 2 Then
			dw_fr.x = dw_list.x
			dw_fr.y = dw_list.y
			dw_fr.width  = dw_list.width
			dw_fr.height = dw_list.height
			
			dw_list.visible = False
			
			dw_ar.visible = False
			dw_br.visible = False
			dw_er.visible = False
			dw_fr.visible = True
			dw_nr.visible = False
			dw_or.visible = False
			dw_hr.visible = False
			
			pb_1.visible = False
			pb_2.visible = False

			
		End If
		return "C:\PROJECT\HYUNDAI\VAN"
	Case 'NR'
		If Tab_1.SelectedTab = 2 Then
			dw_nr.x = dw_list.x
			dw_nr.y = dw_list.y
			dw_nr.width  = dw_list.width
			dw_nr.height = dw_list.height
			dw_list.visible = False
			
			dw_ar.visible = False
			dw_br.visible = False
			dw_er.visible = False
			dw_fr.visible = False
			dw_nr.visible = True
			dw_or.visible = False
			dw_hr.visible = False
			
			pb_1.visible = True
			pb_2.visible = True

			
		End If
		return "C:\PROJECT\HYUNDAI\VAN"
	Case 'OR'
		If Tab_1.SelectedTab = 2 Then
			dw_or.x = dw_list.x
			dw_or.y = dw_list.y
			dw_or.width  = dw_list.width
			dw_or.height = dw_list.height
			dw_list.visible = False
			
			dw_ar.visible = False
			dw_br.visible = False
			dw_er.visible = False
			dw_fr.visible = False
			dw_nr.visible = False
			dw_or.visible = True
			dw_hr.visible = False
			
			pb_1.visible = True
			pb_2.visible = True
			
		End IF
		return "C:\PROJECT\HYUNDAI\VAN"
	Case 'HR'
		If Tab_1.SelectedTab = 2 Then
			dw_hr.x = dw_list.x
			dw_hr.y = dw_list.y
			dw_hr.width  = dw_list.width
			dw_hr.height = dw_list.height
			dw_list.visible = False
			
			dw_ar.visible = False
			dw_br.visible = False
			dw_er.visible = False
			dw_fr.visible = False
			dw_nr.visible = False
			dw_or.visible = false
			dw_hr.visible = true
			
			pb_1.visible = True
			pb_2.visible = True

			
		End IF
		return "C:\PROJECT\HYUNDAI\VAN"
//	Case 'KR'
//		If Tab_1.SelectedTab = 2 Then
//			dw_hr.x = dw_list.x
//			dw_hr.y = dw_list.y
//			dw_hr.width  = dw_list.width
//			dw_hr.height = dw_list.height
//			dw_list.visible = False
//			
//			dw_ar.visible = False
//			dw_br.visible = False
//			dw_er.visible = False
//			dw_fr.visible = False
//			dw_nr.visible = False
//			dw_or.visible = false
//			dw_hr.visible = false
//
//			
//		End IF
//		return 'C:\MOBIS\AS\'
	Case Else
		
		dw_ar.visible = False
		dw_br.visible = False
		dw_er.visible = False
		dw_fr.visible = False
		dw_nr.visible = False
		dw_or.visible = False
  		dw_hr.visible = False

		
		dw_list.visible = True
		
		pb_1.visible = True
		pb_2.visible = false

		return "C:\PROJECT\HYUNDAI\VAN"
		
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

public function integer wf_van_ar (string arg_file_name, string arg_sabu);string   ls_Input_Data , ls_indate
integer  li_FileNum,li_cnt =0,li_rowcnt , li_cnt2
Long     ll_data = 0  , ll_r 

String   ls_SAUPJ  

String   ls_VNDCD           
String   ls_PTNO            
String   ls_COM_ORD         
String   ls_SRC_CD          
String   ls_PNCCD           
String   ls_CARCD           
String   ls_LEAD_DATE       
String   ls_BOUT_DATE       
String   ls_WHSCD           
String   ls_WHS_INC         
String   ls_STK_WHSCD       
String   ls_PART_TYPE       
String   ls_CMP_KND         
String   ls_MAIN            
String   ls_SUB             
String   ls_DETCD           
String   ls_ITEM_KND        
String   ls_CHAR_KND        
String   ls_LEGAL_CD        
String   ls_DMD_KND         
String   ls_BULKY           
String   ls_JAGT_WHSCD      
String   ls_SHOP_ITEM       
String   ls_DIF_PART        
String   ls_WRONG_KND       
String   ls_KITGB           
String   ls_INC_STOP        
String   ls_CAR             
String   ls_BEF_ITC         
String   ls_BEF_PTNO        
String   ls_AFT_ITC         
String   ls_AFT_PTNO        
Long  	ll_USAGE           
String   ls_MC_CODE         
String   ls_CC_CODE         
String   ls_CLASS           
String   ls_NEW_CLASS       
String   ls_WHS_PER         
String   ls_LEGAL2          
String   ls_FRZCD           
String   ls_STOP_CD         
String   ls_EUCODE          
Long     ll_UIO_QTY         
String   ls_STCD            
String   ls_PROB_KND        
String   ls_BDYCD           
String   ls_PNAME           
String   ls_VNDCD_NO        
Decimal  ld_ORD_RATE        
String   ls_GUMFIL_TYPE     
String   ls_GUMFIL_LOCA     
Long     ll_GUMFIL_USAGE1   
Long     ll_GUMFIL_USAGE2   
Long     ll_JE_WONGA        
String   ls_JE_WONGA_GB     
Long     ll_DO_WONGA        
String   ls_DO_WANGA_GB     
Long     ll_PO_WONGA        
String   ls_PO_WONGA_GB     
Long     ll_KITPO_WONGA     
String   ls_KITPO_WONGA_GB  
String   ls_FIRDD_ORD       
String   ls_FIRDD_INC       
Long     ll_AVL_IPGO_QTY    
Long     ll_MOQ             
String   ls_MOQ_DATE        
String   ls_PAINT_SUNWI     
String   ls_POJANG_SUNWI    
String   ls_LC_GB           
String   ls_MAIN_LOCNO      
String   ls_SUB_LOCNO       
String   ls_BIN_CD          
Long     ll_BIN_QTY         
String   ls_PVN_SUNOP       
String   ls_CREA_DATE       
String   ls_UPDATE_DATE     
String   ls_NATION_CODE     
Long     ll_END_LINE        
String   ls_CRT_DATE        
String   ls_CRT_TIME        
String   ls_CRT_USER        
String   ls_CITNBR          
String   ls_MITNBR          
String   ls_MCVCOD          
String   ls_MDCVCOD         
String   ls_gubun           

//현재 일자,시간 

ls_crt_date = Trim(dw_ip.Object.jisi_date[1])
ls_crt_time = string(today(),'hhmm')
ls_crt_user = gs_userid 

ls_gubun = 'A:품목정보'
ls_saupj = Trim(dw_ip.Object.saupj[1])

li_FileNum = FileOpen(is_path+arg_file_name,LineMode!,Read!)

if li_FileNum = -1 then
	wf_error(arg_file_name,li_cnt,'','','',"["+arg_file_name+"]"+" VAN자료가 없습니다.!!")
	FileClose(li_FileNum)
	return -1
end if


st_state.Visible = True
st_state.Text = '데이타를 읽는 중입니다...'

Do While	FileRead(li_FileNum, ls_Input_Data) <> -100
	
	ls_mitnbr = ''
	ls_mcvcod = ''
	ls_mdcvcod = ''
	ls_citnbr = ''
   li_cnt++
	ll_data ++
	
	yield()
	st_state.Text = "파일명: "+arg_file_name +"  라인수 :" +String(li_cnt)
	
	ls_VNDCD           = Trim(Mid(ls_Input_Data,1,4  ))             
	ls_PTNO            = Trim(Mid(ls_Input_Data,5,18 ))             
	ls_COM_ORD         = Trim(Mid(ls_Input_Data,23,1  ))            
	ls_SRC_CD          = Trim(Mid(ls_Input_Data,24,1  ))            
	ls_PNCCD           = Trim(Mid(ls_Input_Data,25,10 ))            
	ls_CARCD           = Trim(Mid(ls_Input_Data,35,1  ))            
	ls_LEAD_DATE       = Trim(Mid(ls_Input_Data,36,8  ))            
	ls_BOUT_DATE       = Trim(Mid(ls_Input_Data,44,8  ))            
	ls_WHSCD           = Trim(Mid(ls_Input_Data,52,3  ))            
	ls_WHS_INC         = Trim(Mid(ls_Input_Data,55,3  ))            
	ls_STK_WHSCD       = Trim(Mid(ls_Input_Data,58,3  ))            
	ls_PART_TYPE       = Trim(Mid(ls_Input_Data,61,1  ))            
	ls_CMP_KND         = Trim(Mid(ls_Input_Data,62,1  ))            
	ls_MAIN            = Trim(Mid(ls_Input_Data,63,1  ))            
	ls_SUB             = Trim(Mid(ls_Input_Data,64,2  ))            
	ls_DETCD           = Trim(Mid(ls_Input_Data,66,2  ))            
	ls_ITEM_KND        = Trim(Mid(ls_Input_Data,68,1  ))            
	ls_CHAR_KND        = Trim(Mid(ls_Input_Data,69,1  ))            
	ls_LEGAL_CD        = Trim(Mid(ls_Input_Data,70,1  ))            
	ls_DMD_KND         = Trim(Mid(ls_Input_Data,71,1  ))            
	ls_BULKY           = Trim(Mid(ls_Input_Data,72,1  ))            
	ls_JAGT_WHSCD      = Trim(Mid(ls_Input_Data,73,1  ))            
	ls_SHOP_ITEM       = Trim(Mid(ls_Input_Data,74,1  ))            
	ls_DIF_PART        = Trim(Mid(ls_Input_Data,75,1  ))            
	ls_WRONG_KND       = Trim(Mid(ls_Input_Data,76,1  ))            
	ls_KITGB           = Trim(Mid(ls_Input_Data,77,1  ))            
	ls_INC_STOP        = Trim(Mid(ls_Input_Data,78,1  ))            
	ls_CAR             = Trim(Mid(ls_Input_Data,79,3  ))            
	ls_BEF_ITC         = Trim(Mid(ls_Input_Data,82,1  ))            
	ls_BEF_PTNO        = Trim(Mid(ls_Input_Data,83,18 ))            
	ls_AFT_ITC         = Trim(Mid(ls_Input_Data,101,1  ))           
	ls_AFT_PTNO        = Trim(Mid(ls_Input_Data,102,18 ))           
	ll_USAGE           = Long(Trim(Mid(ls_Input_Data,120,3  )))           
	ls_MC_CODE         = Trim(Mid(ls_Input_Data,123,2  ))     
	ls_CC_CODE         = Trim(Mid(ls_Input_Data,125,2  ))           
	ls_CLASS           = Trim(Mid(ls_Input_Data,127,2  ))           
	ls_NEW_CLASS       = Trim(Mid(ls_Input_Data,129,2  ))           
	
	ls_WHS_PER         = Trim(Mid(ls_Input_Data,131,3  ))           
	ls_LEGAL2          = Trim(Mid(ls_Input_Data,134,1  ))           
	ls_FRZCD           = Trim(Mid(ls_Input_Data,135,1  ))           
	ls_STOP_CD         = Trim(Mid(ls_Input_Data,136,1  ))           
	ls_EUCODE          = Trim(Mid(ls_Input_Data,137,1  ))           
	
	ll_UIO_QTY         = Long(Trim(Mid(ls_Input_Data,138,7  )))           
	ls_STCD            = Trim(Mid(ls_Input_Data,145,1  ))     
	ls_PROB_KND        = Trim(Mid(ls_Input_Data,146,1  ))           
	ls_BDYCD           = Trim(Mid(ls_Input_Data,147,1  ))           
	ls_PNAME           = Trim(Mid(ls_Input_Data,148,60 ))           
	ls_VNDCD_NO        = Trim(Mid(ls_Input_Data,208,21 ))           
	ld_ORD_RATE        = Truncate(Double(Trim(Mid(ls_Input_Data,229,5)))*0.01  ,2)           
	ls_GUMFIL_TYPE     = Trim(Mid(ls_Input_Data,234,1  ))            
	ls_GUMFIL_LOCA     = Trim(Mid(ls_Input_Data,235,1  ))            
	ll_GUMFIL_USAGE1   = Long(Trim(Mid(ls_Input_Data,236,3  )))            
	ll_GUMFIL_USAGE2   = Long(Trim(Mid(ls_Input_Data,239,3  )))            
	ll_JE_WONGA        = Long(Trim(Mid(ls_Input_Data,242,7  )))            
	ls_JE_WONGA_GB     = Trim(Mid(ls_Input_Data,249,1  ))            
	ll_DO_WONGA        = Long(Trim(Mid(ls_Input_Data,250,7  )))            
	ls_DO_WANGA_GB     = Trim(Mid(ls_Input_Data,257,1  ))            
	ll_PO_WONGA        = Long(Trim(Mid(ls_Input_Data,258,7  )))            
	ls_PO_WONGA_GB     = Trim(Mid(ls_Input_Data,265,1  ))            
	ll_KITPO_WONGA     = Long(Trim(Mid(ls_Input_Data,266,7  )))            
	ls_KITPO_WONGA_GB  = Trim(Mid(ls_Input_Data,273,1  ))            
	ls_FIRDD_ORD       = Trim(Mid(ls_Input_Data,274,8  ))            
	ls_FIRDD_INC       = Trim(Mid(ls_Input_Data,282,8  ))            
	ll_AVL_IPGO_QTY    = Long(Trim(Mid(ls_Input_Data,290,7  )))            
	ll_MOQ             = Long(Trim(Mid(ls_Input_Data,297,7  )))            
	ls_MOQ_DATE        = Trim(Mid(ls_Input_Data,304,8  ))            
	ls_PAINT_SUNWI     = Trim(Mid(ls_Input_Data,312,1  ))            
	ls_POJANG_SUNWI    = Trim(Mid(ls_Input_Data,313,1  ))            
	ls_LC_GB           = Trim(Mid(ls_Input_Data,314,1  ))            
	ls_MAIN_LOCNO      = Trim(Mid(ls_Input_Data,315,10 ))            
	ls_SUB_LOCNO       = Trim(Mid(ls_Input_Data,325,10 ))            
	ls_BIN_CD          = Trim(Mid(ls_Input_Data,335,3  ))            
	ll_BIN_QTY         = Long(Trim(Mid(ls_Input_Data,338,7  )))            
	ls_PVN_SUNOP       = Trim(Mid(ls_Input_Data,345,1  ))            
	ls_CREA_DATE       = Trim(Mid(ls_Input_Data,346,8 ))           
	ls_UPDATE_DATE     = Trim(Mid(ls_Input_Data,354,8  ))            
	ls_NATION_CODE     = Trim(Mid(ls_Input_Data,362,2  ))            
	ll_END_LINE        = Long(Trim(Mid(ls_Input_Data,364,1  )))   

// 못읽어 오는 데이타 존재한다. 에러사항 아직 찾지 못함 ***********************//

//ll_r = dw_ar.InsertRow(0)
//dw_ar.Object.SAUPJ[ll_r]  =                   ls_saupj            
//  
//dw_ar.Object.VNDCD[ll_r]  =                   ls_VNDCD            
//dw_ar.Object.PTNO[ll_r]  =                    ls_PTNO             
//dw_ar.Object.COM_ORD[ll_r]  =                 ls_COM_ORD          
//dw_ar.Object.SRC_CD[ll_r]  =                  ls_SRC_CD           
//dw_ar.Object.PNCCD[ll_r]  =                   ls_PNCCD            
//dw_ar.Object.CARCD[ll_r]  =                   ls_CARCD            
//dw_ar.Object.LEAD_DATE[ll_r]  =               ls_LEAD_DATE        
//dw_ar.Object.BOUT_DATE[ll_r]  =               ls_BOUT_DATE        
//dw_ar.Object.WHSCD[ll_r]  =                   ls_WHSCD            
//dw_ar.Object.WHS_INC[ll_r]  =                 ls_WHS_INC          
//dw_ar.Object.STK_WHSCD[ll_r]  =               ls_STK_WHSCD        
//dw_ar.Object.PART_TYPE[ll_r]  =               ls_PART_TYPE        
//dw_ar.Object.CMP_KND[ll_r]  =                 ls_CMP_KND          
//dw_ar.Object.MAIN[ll_r]  =                    ls_MAIN             
//dw_ar.Object.SUB[ll_r]  =                     ls_SUB              
//dw_ar.Object.DETCD[ll_r]  =                   ls_DETCD            
//dw_ar.Object.ITEM_KND[ll_r]  =                ls_ITEM_KND         
//dw_ar.Object.CHAR_KND[ll_r]  =                ls_CHAR_KND         
//dw_ar.Object.LEGAL_CD[ll_r]  =                ls_LEGAL_CD         
//dw_ar.Object.DMD_KND[ll_r]  =                 ls_DMD_KND          
//dw_ar.Object.BULKY[ll_r]  =                   ls_BULKY            
//dw_ar.Object.JAGT_WHSCD[ll_r]  =              ls_JAGT_WHSCD       
//dw_ar.Object.SHOP_ITEM[ll_r]  =               ls_SHOP_ITEM        
//dw_ar.Object.DIF_PART[ll_r]  =                ls_DIF_PART         
//dw_ar.Object.WRONG_KND[ll_r]  =               ls_WRONG_KND        
//dw_ar.Object.KITGB[ll_r]  =                   ls_KITGB            
//dw_ar.Object.INC_STOP[ll_r]  =                ls_INC_STOP         
//dw_ar.Object.CAR[ll_r]  =                     ls_CAR              
//dw_ar.Object.BEF_ITC[ll_r]  =                 ls_BEF_ITC          
//dw_ar.Object.BEF_PTNO[ll_r]  =                ls_BEF_PTNO         
//dw_ar.Object.AFT_ITC[ll_r]  =                 ls_AFT_ITC          
//dw_ar.Object.AFT_PTNO[ll_r]  =                ls_AFT_PTNO         
//dw_ar.Object.USAGE[ll_r]  =                   ll_USAGE            
//dw_ar.Object.MC_CODE[ll_r]  =                 ls_MC_CODE          
//dw_ar.Object.CC_CODE[ll_r]  =                 ls_CC_CODE          
//dw_ar.Object.CLASS[ll_r]  =                   ls_CLASS            
//dw_ar.Object.NEW_CLASS[ll_r]  =               ls_NEW_CLASS        
//dw_ar.Object.WHS_PER[ll_r]  =                 ls_WHS_PER          
//dw_ar.Object.LEGAL2[ll_r]  =                  ls_LEGAL2           
//dw_ar.Object.FRZCD[ll_r]  =                   ls_FRZCD            
//dw_ar.Object.STOP_CD[ll_r]  =                 ls_STOP_CD          
//dw_ar.Object.EUCODE[ll_r]  =                  ls_EUCODE           
//dw_ar.Object.UIO_QTY[ll_r]  =                 ll_UIO_QTY          
//dw_ar.Object.STCD[ll_r]  =                    ls_STCD             
//dw_ar.Object.PROB_KND[ll_r]  =                ls_PROB_KND         
//dw_ar.Object.BDYCD[ll_r]  =                   ls_BDYCD            
//dw_ar.Object.PNAME[ll_r]  =                   ls_PNAME            
//dw_ar.Object.VNDCD_NO[ll_r]  =                ls_VNDCD_NO         
//dw_ar.Object.ORD_RATE[ll_r]  =                ld_ORD_RATE         
//dw_ar.Object.GUMFIL_TYPE[ll_r]  =             ls_GUMFIL_TYPE      
//dw_ar.Object.GUMFIL_LOCA[ll_r]  =             ls_GUMFIL_LOCA      
//dw_ar.Object.GUMFIL_USAGE1[ll_r]  =           ll_GUMFIL_USAGE1    
//dw_ar.Object.GUMFIL_USAGE2[ll_r]  =           ll_GUMFIL_USAGE2    
//dw_ar.Object.JE_WONGA[ll_r]  =                ll_JE_WONGA         
//dw_ar.Object.JE_WONGA_GB[ll_r]  =             ls_JE_WONGA_GB      
//dw_ar.Object.DO_WONGA[ll_r]  =                ll_DO_WONGA         
//dw_ar.Object.DO_WANGA_GB[ll_r]  =             ls_DO_WANGA_GB      
//dw_ar.Object.PO_WONGA[ll_r]  =                ll_PO_WONGA         
//dw_ar.Object.PO_WONGA_GB[ll_r]  =             ls_PO_WONGA_GB      
//dw_ar.Object.KITPO_WONGA[ll_r]  =             ll_KITPO_WONGA      
//dw_ar.Object.KITPO_WONGA_GB[ll_r]  =          ls_KITPO_WONGA_GB   
//dw_ar.Object.FIRDD_ORD[ll_r]  =               ls_FIRDD_ORD        
//dw_ar.Object.FIRDD_INC[ll_r]  =               ls_FIRDD_INC        
//dw_ar.Object.AVL_IPGO_QTY[ll_r]  =            ll_AVL_IPGO_QTY     
//dw_ar.Object.MOQ[ll_r]  =                     ll_MOQ              
//dw_ar.Object.MOQ_DATE[ll_r]  =                ls_MOQ_DATE         
//dw_ar.Object.PAINT_SUNWI[ll_r]  =             ls_PAINT_SUNWI      
//dw_ar.Object.POJANG_SUNWI[ll_r]  =            ls_POJANG_SUNWI     
//dw_ar.Object.LC_GB[ll_r]  =                   ls_LC_GB            
//dw_ar.Object.MAIN_LOCNO[ll_r]  =              ls_MAIN_LOCNO       
//dw_ar.Object.SUB_LOCNO[ll_r]  =               ls_SUB_LOCNO        
//dw_ar.Object.BIN_CD[ll_r]  =                  ls_BIN_CD           
//dw_ar.Object.BIN_QTY[ll_r]  =                 ll_BIN_QTY          
//dw_ar.Object.PVN_SUNOP[ll_r]  =               ls_PVN_SUNOP        
//dw_ar.Object.CREA_DATE[ll_r]  =               ls_CREA_DATE        
//dw_ar.Object.UPDATE_DATE[ll_r]  =             ls_UPDATE_DATE      
//dw_ar.Object.NATION_CODE[ll_r]  =             ls_NATION_CODE      
//dw_ar.Object.END_LINE[ll_r]  =                ll_END_LINE         
//dw_ar.Object.CRT_DATE[ll_r]  =                ls_CRT_DATE         
//dw_ar.Object.CRT_TIME[ll_r]  =                ls_CRT_TIME         
//dw_ar.Object.CRT_USER[ll_r]  =                ls_CRT_USER     	   
//dw_ar.Object.CITNBR[ll_r]  =                  ls_CITNBR           
//dw_ar.Object.MITNBR[ll_r]  =                  ls_MITNBR           
//dw_ar.Object.MCVCOD[ll_r]  =                  ls_MCVCOD           
//dw_ar.Object.MDCVCOD[ll_r]  =                 ls_MDCVCOD          
//
//
//공장별 거래처 읽어오기
//	select nvl(RFNA2,''),nvl(RFNA3,'')
//	into :ls_mcvcod,:ls_mdcvcod
//	from reffpf
//	where sabu = :arg_sabu and
//			rfcod = '1G' and
//			rfgub = :ls_factory;
//			
//	if sqlca.sqlcode <> 0 or &
//	   trim(ls_mcvcod)	= '' or trim(ls_mdcvcod) = '' or &
//		isNull(ls_mcvcod)	 or isNull(ls_mdcvcod) then
//		wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,'참조테이블에(REFFPF) 하치장(납품장소) 코드가 없습니다.')
//		
//		Continue ;
//	end if


	
//	자체품번 읽어오기(자체거래처코드)
	SELECT itnbr into :ls_mitnbr
   	 FROM (	SELECT itnbr,ROWNUM RN 
					  FROM itemas
					  WHERE REPLACE(itnbr,'-','') = :ls_PTNO )
  	WHERE RN = 1 ;
	  
	if sqlca.sqlcode <> 0 or trim(ls_mitnbr) = '' or isNull(ls_mitnbr) then
		
		If len(trim(ls_PTNO)) < 10 then
			ls_mitnbr = ls_PTNO
		else
			ls_mitnbr = trim(left(ls_PTNO,5))+'-'+trim(mid(ls_PTNO,6,20))
		end if
			
		If wf_itnbr_insert( ls_mitnbr , ls_PNAME ) < 0 Then
			wf_error(arg_file_name,li_cnt,'',ls_WHSCD,ls_PTNO,'품번마스타에 품번이 등록되지 않았습니다.')
			il_err++
			continue ;
		else
			
			wf_error(arg_file_name,li_cnt,'',ls_WHSCD,ls_PTNO,'품번을 임시로 생성하였습니다.')
		end if
		
	end if
	
//
//	if sqlca.sqlcode <> 0 or Trim(ls_mitnbr) = '' or isNull(ls_mitnbr) then
//		
//		wf_error(arg_file_name,li_cnt,'',ls_WHSCD,ls_PTNO,'품번마스타에 품번이 등록되지 않았습니다.')
//		
//		il_err++
//		continue ;
//		
//	End IF 

	ls_mitnbr = trim(ls_mitnbr)
	ls_mcvcod = trim(ls_mcvcod)
	ls_mdcvcod = trim(ls_mdcvcod)
	ls_citnbr = trim(ls_citnbr)
	li_cnt2 = 0 
   SELECT COUNT(*) INTO :li_cnt2
	  FROM VAN_MOBIS_AR
	 WHERE VNDCD = :ls_VNDCD
	   AND PTNO = :ls_PTNO
		AND COM_ORD = :ls_COM_ORD ;
		
	If li_cnt2 <= 0 Then
	
		INSERT INTO  VAN_MOBIS_AR( SAUPJ, 
											VNDCD,   
											PTNO,   
											COM_ORD,   
											SRC_CD,   
											PNCCD,   
											CARCD,   
											LEAD_DATE,   
											BOUT_DATE,   
											WHSCD,   
											WHS_INC,   
											STK_WHSCD,   
											PART_TYPE,   
											CMP_KND,   
											MAIN,   
											SUB,   
											DETCD,   
											ITEM_KND,   
											CHAR_KND,   
											LEGAL_CD,   
											DMD_KND,   
											BULKY,   
											JAGT_WHSCD,   
											SHOP_ITEM,   
											DIF_PART,   
											WRONG_KND,   
											KITGB,   
											INC_STOP,   
											CAR,   
											BEF_ITC,   
											BEF_PTNO,   
											AFT_ITC,   
											AFT_PTNO,   
											USAGE,   
											MC_CODE,   
											CC_CODE,   
											CLASS,   
											NEW_CLASS,   
											WHS_PER,   
											LEGAL2,   
											FRZCD,   
											STOP_CD,   
											EUCODE,   
											UIO_QTY,   
											STCD,   
											PROB_KND,   
											BDYCD,   
											PNAME,   
											VNDCD_NO,   
											ORD_RATE,   
											GUMFIL_TYPE,   
											GUMFIL_LOCA,   
											GUMFIL_USAGE1,   
											GUMFIL_USAGE2,   
											JE_WONGA,   
											JE_WONGA_GB,   
											DO_WONGA,   
											DO_WANGA_GB,   
											PO_WONGA,   
											PO_WONGA_GB,   
											KITPO_WONGA,   
											KITPO_WONGA_GB,   
											FIRDD_ORD,   
											FIRDD_INC,   
											AVL_IPGO_QTY,   
											MOQ,   
											MOQ_DATE,   
											PAINT_SUNWI,   
											POJANG_SUNWI,   
											LC_GB,   
											MAIN_LOCNO,   
											SUB_LOCNO,   
											BIN_CD,   
											BIN_QTY,   
											PVN_SUNOP,   
											CREA_DATE,   
											UPDATE_DATE,   
											NATION_CODE,   
											END_LINE,   
											CRT_DATE,   
											CRT_TIME,   
											CRT_USER,   
											CITNBR,   
											MITNBR,   
											MCVCOD,   
											MDCVCOD                 )
								VALUES ( :ls_saupj               ,
											:ls_VNDCD               ,  
											:ls_PTNO                ,  
											:ls_COM_ORD             ,  
											:ls_SRC_CD              ,  
											:ls_PNCCD               ,  
											:ls_CARCD               ,  
											:ls_LEAD_DATE           ,  
											:ls_BOUT_DATE           ,  
											:ls_WHSCD               ,  
											:ls_WHS_INC             ,  
											:ls_STK_WHSCD           ,  
											:ls_PART_TYPE           ,  
											:ls_CMP_KND             ,  
											:ls_MAIN                ,  
											:ls_SUB                 ,  
											:ls_DETCD               ,  
											:ls_ITEM_KND            ,  
											:ls_CHAR_KND            ,  
											:ls_LEGAL_CD            ,  
											:ls_DMD_KND             ,  
											:ls_BULKY               ,  
											:ls_JAGT_WHSCD          ,  
											:ls_SHOP_ITEM           ,  
											:ls_DIF_PART            ,  
											:ls_WRONG_KND           ,  
											:ls_KITGB               ,  
											:ls_INC_STOP            ,  
											:ls_CAR                 ,  
											:ls_BEF_ITC             ,  
											:ls_BEF_PTNO            ,  
											:ls_AFT_ITC             ,  
											:ls_AFT_PTNO            ,  
											:ll_USAGE               ,  
											:ls_MC_CODE             ,  
											:ls_CC_CODE             ,  
											:ls_CLASS               ,  
											:ls_NEW_CLASS           ,  
											:ls_WHS_PER             ,  
											:ls_LEGAL2              ,  
											:ls_FRZCD               ,  
											:ls_STOP_CD             ,  
											:ls_EUCODE              ,  
											:ll_UIO_QTY             ,  
											:ls_STCD                ,  
											:ls_PROB_KND            ,  
											:ls_BDYCD               ,  
											:ls_PNAME               ,  
											:ls_VNDCD_NO            ,  
											:ld_ORD_RATE            ,  
											:ls_GUMFIL_TYPE         ,  
											:ls_GUMFIL_LOCA         ,  
											:ll_GUMFIL_USAGE1       ,  
											:ll_GUMFIL_USAGE2       ,  
											:ll_JE_WONGA            ,  
											:ls_JE_WONGA_GB         ,  
											:ll_DO_WONGA            ,  
											:ls_DO_WANGA_GB         ,  
											:ll_PO_WONGA            ,  
											:ls_PO_WONGA_GB         ,  
											:ll_KITPO_WONGA         ,  
											:ls_KITPO_WONGA_GB      ,  
											:ls_FIRDD_ORD           ,  
											:ls_FIRDD_INC           ,  
											:ll_AVL_IPGO_QTY        ,  
											:ll_MOQ                 ,  
											:ls_MOQ_DATE            ,  
											:ls_PAINT_SUNWI         ,  
											:ls_POJANG_SUNWI        ,  
											:ls_LC_GB               ,  
											:ls_MAIN_LOCNO          ,  
											:ls_SUB_LOCNO           ,  
											:ls_BIN_CD              ,  
											:ll_BIN_QTY             ,  
											:ls_PVN_SUNOP           ,  
											:ls_CREA_DATE           ,  
											:ls_UPDATE_DATE         ,  
											:ls_NATION_CODE         ,  
											:ll_END_LINE            ,  
											:ls_CRT_DATE            ,  
											:ls_CRT_TIME            ,  
											:ls_CRT_USER     		   ,
											:ls_CITNBR              ,  
											:ls_MITNBR              ,  
											:ls_MCVCOD              ,  
											:ls_MDCVCOD             ) ;
	Else
		
		UPDATE  VAN_MOBIS_AR SET SAUPJ =             :ls_saupj               ,       
										 SRC_CD   =           :ls_SRC_CD              ,          
										 PNCCD   =            :ls_PNCCD               ,          
										 CARCD   =            :ls_CARCD               ,          
										 LEAD_DATE   =        :ls_LEAD_DATE           ,          
										 BOUT_DATE   =        :ls_BOUT_DATE           ,          
										 WHSCD   =            :ls_WHSCD               ,          
										 WHS_INC   =          :ls_WHS_INC             ,          
										 STK_WHSCD   =        :ls_STK_WHSCD           ,          
										 PART_TYPE   =        :ls_PART_TYPE           ,          
										 CMP_KND   =          :ls_CMP_KND             ,          
										 MAIN   =             :ls_MAIN                ,          
										 SUB   =              :ls_SUB                 ,          
										 DETCD   =            :ls_DETCD               ,          
										 ITEM_KND   =         :ls_ITEM_KND            ,          
										 CHAR_KND   =         :ls_CHAR_KND            ,          
										 LEGAL_CD   =         :ls_LEGAL_CD            ,          
										 DMD_KND   =          :ls_DMD_KND             ,          
										 BULKY   =            :ls_BULKY               ,          
										 JAGT_WHSCD   =       :ls_JAGT_WHSCD          ,          
										 SHOP_ITEM   =        :ls_SHOP_ITEM           ,          
										 DIF_PART   =         :ls_DIF_PART            ,          
										 WRONG_KND   =        :ls_WRONG_KND           ,          
										 KITGB   =            :ls_KITGB               ,          
										 INC_STOP   =         :ls_INC_STOP            ,          
										 CAR   =              :ls_CAR                 ,          
										 BEF_ITC   =          :ls_BEF_ITC             ,          
										 BEF_PTNO   =         :ls_BEF_PTNO            ,          
										 AFT_ITC   =          :ls_AFT_ITC             ,          
										 AFT_PTNO   =         :ls_AFT_PTNO            ,          
										 USAGE   =            :ll_USAGE               ,          
										 MC_CODE   =          :ls_MC_CODE             ,          
										 CC_CODE   =          :ls_CC_CODE             ,          
										 CLASS   =            :ls_CLASS               ,          
										 NEW_CLASS   =        :ls_NEW_CLASS           ,          
										 WHS_PER   =          :ls_WHS_PER             ,          
										 LEGAL2   =           :ls_LEGAL2              ,          
										 FRZCD   =            :ls_FRZCD               ,          
										 STOP_CD   =          :ls_STOP_CD             ,          
										 EUCODE   =           :ls_EUCODE              ,          
										 UIO_QTY   =          :ll_UIO_QTY             ,          
										 STCD   =             :ls_STCD                ,          
										 PROB_KND   =         :ls_PROB_KND            ,          
										 BDYCD   =            :ls_BDYCD               ,          
										 PNAME   =            :ls_PNAME               ,          
										 VNDCD_NO   =         :ls_VNDCD_NO            ,          
										 ORD_RATE   =         :ld_ORD_RATE            ,          
										 GUMFIL_TYPE   =      :ls_GUMFIL_TYPE         ,          
										 GUMFIL_LOCA   =      :ls_GUMFIL_LOCA         ,          
										 GUMFIL_USAGE1   =    :ll_GUMFIL_USAGE1       ,          
										 GUMFIL_USAGE2   =    :ll_GUMFIL_USAGE2       ,          
										 JE_WONGA   =         :ll_JE_WONGA            ,          
										 JE_WONGA_GB   =      :ls_JE_WONGA_GB         ,          
										 DO_WONGA   =         :ll_DO_WONGA            ,          
										 DO_WANGA_GB   =      :ls_DO_WANGA_GB         ,          
										 PO_WONGA   =         :ll_PO_WONGA            ,          
										 PO_WONGA_GB   =      :ls_PO_WONGA_GB         ,          
										 KITPO_WONGA   =      :ll_KITPO_WONGA         ,          
										 KITPO_WONGA_GB   =   :ls_KITPO_WONGA_GB      ,          
										 FIRDD_ORD   =        :ls_FIRDD_ORD           ,          
										 FIRDD_INC   =        :ls_FIRDD_INC           ,          
										 AVL_IPGO_QTY   =     :ll_AVL_IPGO_QTY        ,          
										 MOQ   =              :ll_MOQ                 ,          
										 MOQ_DATE   =         :ls_MOQ_DATE            ,          
										 PAINT_SUNWI   =      :ls_PAINT_SUNWI         ,          
										 POJANG_SUNWI   =     :ls_POJANG_SUNWI        ,          
										 LC_GB   =            :ls_LC_GB               ,          
										 MAIN_LOCNO   =       :ls_MAIN_LOCNO          ,          
										 SUB_LOCNO   =        :ls_SUB_LOCNO           ,          
										 BIN_CD   =           :ls_BIN_CD              ,          
										 BIN_QTY   =          :ll_BIN_QTY             ,          
										 PVN_SUNOP   =        :ls_PVN_SUNOP           ,          
										 CREA_DATE   =        :ls_CREA_DATE           ,          
										 UPDATE_DATE   =      :ls_UPDATE_DATE         ,          
										 NATION_CODE   =      :ls_NATION_CODE         ,          
										 END_LINE   =         :ll_END_LINE            ,          
										 CRT_DATE   =         :ls_CRT_DATE            ,          
										 CRT_TIME   =         :ls_CRT_TIME            ,          
										 CRT_USER   =         :ls_CRT_USER     	     ,   
										 CITNBR   =           :ls_CITNBR              ,          
										 MITNBR   =           :ls_MITNBR              ,          
										 MCVCOD   =           :ls_MCVCOD              ,          
										 MDCVCOD  =           :ls_MDCVCOD        
								 WHERE VNDCD = :ls_VNDCD
									AND PTNO = :ls_PTNO
									AND COM_ORD = :ls_COM_ORD ;
	End If
	If sqlca.sqlcode <> 0 Then
		
		st_state.Visible = False
		wf_error(arg_file_name,li_cnt,'',ls_WHSCD,ls_mitnbr,"입력에러가 발생했습니다." +sqlca.sqlerrtext+'[열위치:'+string(li_cnt)+']')
		rollback;
		FileClose(li_FileNum)
		return -3
	Else
		il_succeed++
	End if
	
	
	
Loop


// van file close
FileClose(li_FileNum)

//van 파일명 변경

//li_FileNum = FileCopy(arg_file_name,left(arg_file_name,pos(trim(arg_file_name),".")) + "bak",TRUE)
//if li_FileNum <> 1 then
//	Rollback ;
//	st_state.Visible = False
//	wf_error(ls_gubun,0,'','','',"파일변경에 에러가 발생했습니다."  )
//	
//	return -4
//end if

//van 파일 삭제
//if not FileDelete(arg_file_name) then 
//	Rollback ;
//	st_state.Visible = False
//	messagebox('error','화일삭제 에러입니다.')
//	return -4
//end if

commit;

st_state.Visible = False
return ll_data

end function

public function integer wf_van_br (string arg_file_name, string arg_sabu);string   ls_Input_Data, ls_indate
integer  li_FileNum,li_cnt,li_rowcnt,li_cnt2
Long     ll_data = 0  , ll_r, ll_cnt

String  ls_SAUPJ          
String  ls_BALGB          
String  ls_ORD_YM         
String  ls_ORD_SEQ        
String  ls_ORDNO          
String  ls_VNDCD          
String  ls_PTNO           
String  ls_HKID           
String  ls_VAREA          
String  ls_DEV_PER        
String  ls_CON_PER        
String  ls_STAT_PER       
String  ls_BOUT_CD        
Long    ll_ORD_QTY        
Long    ll_DLVBF_CNL_QTY    
Long    ll_DLVAF_CNL_QTY    
Long    ll_PRE_INC_QTY    
Long    ll_LAST_INC_QTY    
Long    ll_DLVBF_INC_QTY    
Long    ll_DLVAF_INC_QTY    
Long    ll_CLM_QTY        
Decimal  ld_CLM_RATE       
String  ls_OSEQ           
Long    ll_JSEQ           
String  ls_ORD_DATE       
String  ls_DUE_DATE       
String  ls_REQ_DATE       
String  ls_ORDID          
String  ls_ORDPRO         
String  ls_ORD_INF        
String  ls_BEFORE_ORD_INF    
String  ls_WHSCD          
String  ls_WHS_INC        
String  ls_ADVAN_STR      
String  ls_ADVAN_AGN      
Long    ll_DLV_PRICE      
Long    ll_TT_PRICE       
Long    ll_RAW_PRICE      
String  ls_VEN_PRCD       
String  ls_PTNM           
String  ls_SRC            
String  ls_VND_SRC        
String  ls_VHC_KND        
String  ls_CLASS          
String  ls_LACID          
String  ls_PROID          
String  ls_LOCNO          
String  ls_LST_DATE       
String  ls_INSP_NO        
String  ls_FIR_ORDNO      
String  ls_FIR_DUE_DATE    
String  ls_SUN_CD         
Decimal  ld_SUN_RATE       
String  ls_DO_VEND        
String  ls_PO_VEND        
String  ls_EMPNO          
String  ls_REMARK         
String  ls_NATION_CODE    
String  ls_END_LINE      /*: 마직막라인 표시 */ 
String  ls_CRT_DATE       
String  ls_CRT_TIME       
String  ls_CRT_USER       
String  ls_CITNBR         
String  ls_MITNBR         
String  ls_MCVCOD         
String  ls_MDCVCOD
String  ls_gubun

//현재 일자,시간 
Double ld_price ,ld_bprice 
Long   ll_f
String ls_start_date, ls_new


ls_crt_date = Trim(dw_ip.Object.jisi_date[1])
ls_crt_time = string(today(),'hhmm')
ls_crt_user = gs_userid 

ls_gubun = 'B:발주정보'
ls_saupj = Trim(dw_ip.Object.saupj[1])

li_FileNum = FileOpen(is_path+arg_file_name,LineMode!,Read!)

if li_FileNum = -1 then
	wf_error(arg_file_name,li_cnt,'','','',"["+arg_file_name+"]"+" VAN자료가 없습니다.!!")
	FileClose(li_FileNum)
	return -1
end if

delete from van_mobis_br where saupj = :ls_saupj ;
commit;

li_cnt = 0
st_state.Visible = True
st_state.Text = '데이타를 읽는 중입니다...'

Do While	FileRead(li_FileNum, ls_Input_Data) <> -100
	
	ls_mitnbr = ''
	ls_mcvcod = ''
	ls_mdcvcod = ''
	ls_citnbr = ''
	li_cnt ++
	ll_data ++	
	
	yield()
	st_state.Text = "파일명: "+arg_file_name +"  라인수 :" +String(li_cnt)
	
	ls_BALGB            = Trim(Mid(ls_Input_Data,1,2  ))
	ls_ORD_YM           = Trim(Mid(ls_Input_Data,3,6  ))
	ls_ORD_SEQ          = Trim(Mid(ls_Input_Data,9,6  ))
	ls_ORDNO            = Trim(Mid(ls_Input_Data,15,14 ))
	ls_VNDCD            = Trim(Mid(ls_Input_Data,29,4  ))
	ls_PTNO             = Trim(Mid(ls_Input_Data,33,18 ))
	ls_HKID             = Trim(Mid(ls_Input_Data,51,1  ))
	ls_VAREA            = Trim(Mid(ls_Input_Data,52,1  ))
	ls_DEV_PER          = Trim(Mid(ls_Input_Data,53,2  ))
	ls_CON_PER          = Trim(Mid(ls_Input_Data,55,3  ))
	ls_STAT_PER         = Trim(Mid(ls_Input_Data,58,3  ))
	ls_BOUT_CD          = Trim(Mid(ls_Input_Data,61,2  ))
	ll_ORD_QTY          = Long(Trim(Mid(ls_Input_Data,63,7  )))
	ll_DLVBF_CNL_QTY    = Long(Trim(Mid(ls_Input_Data,70,7  ))) 
	ll_DLVAF_CNL_QTY    = Long(Trim(Mid(ls_Input_Data,77,7  ))) 
	ll_PRE_INC_QTY      = Long(Trim(Mid(ls_Input_Data,84,7  ))) 
	ll_LAST_INC_QTY     = Long(Trim(Mid(ls_Input_Data,91,7  ))) 
	ll_DLVBF_INC_QTY    = Long(Trim(Mid(ls_Input_Data,98,7  ))) 
	ll_DLVAF_INC_QTY    = Long(Trim(Mid(ls_Input_Data,105,7  ))) 
	ll_CLM_QTY          = Long(Trim(Mid(ls_Input_Data,112,7  ))) 
	ld_CLM_RATE         = Truncate(Double(Trim(Mid(ls_Input_Data,119,3 )))*0.01 ,2)
	ls_OSEQ             = Trim(Mid(ls_Input_Data,122,3  )) 
	ll_JSEQ             = Long(Trim(Mid(ls_Input_Data,125,3  ))) 
	ls_ORD_DATE         = Trim(Mid(ls_Input_Data,128,8   )) 
	ls_DUE_DATE         = Trim(Mid(ls_Input_Data,136,8   )) 
	ls_REQ_DATE         = Trim(Mid(ls_Input_Data,144,8   )) 
	ls_ORDID            = Trim(Mid(ls_Input_Data,152,1  ))
	ls_ORDPRO           = Trim(Mid(ls_Input_Data,153,1  )) 
	ls_ORD_INF          = Trim(Mid(ls_Input_Data,154,2  ))
	ls_BEFORE_ORD_INF   = Trim(Mid(ls_Input_Data,156,2  ))
	ls_WHSCD            = Trim(Mid(ls_Input_Data,158,3  ))
	ls_WHS_INC          = Trim(Mid(ls_Input_Data,161,3  ))
	ls_ADVAN_STR        = Trim(Mid(ls_Input_Data,164,3  ))
	ls_ADVAN_AGN        = Trim(Mid(ls_Input_Data,167,4  ))
	ll_DLV_PRICE        = Long(Trim(Mid(ls_Input_Data,171,9  )))
	ll_TT_PRICE         = Long(Trim(Mid(ls_Input_Data,180,9  )))
	ll_RAW_PRICE        = Long(Trim(Mid(ls_Input_Data,189,9  )))
	ls_VEN_PRCD         = Trim(Mid(ls_Input_Data,198,21 ))
	ls_PTNM             = Trim(Mid(ls_Input_Data,219,60 ))
	ls_SRC              = Trim(Mid(ls_Input_Data,279,1  ))
	ls_VND_SRC          = Trim(Mid(ls_Input_Data,280,1  ))
	ls_VHC_KND          = Trim(Mid(ls_Input_Data,281,3  ))
	ls_CLASS            = Trim(Mid(ls_Input_Data,284,2  ))
	ls_LACID            = Trim(Mid(ls_Input_Data,286,1  ))
	ls_PROID            = Trim(Mid(ls_Input_Data,287,1  ))
	ls_LOCNO            = Trim(Mid(ls_Input_Data,288,10 ))
	ls_LST_DATE         = Trim(Mid(ls_Input_Data,298,8   ))
	ls_INSP_NO          = Trim(Mid(ls_Input_Data,306,15 ))
	ls_FIR_ORDNO        = Trim(Mid(ls_Input_Data,321,15 ))
	ls_FIR_DUE_DATE     = Trim(Mid(ls_Input_Data,336,8  ))
	ls_SUN_CD           = Trim(Mid(ls_Input_Data,344,1  ))
	ld_SUN_RATE         = Truncate(Double(Trim(Mid(ls_Input_Data,345,7 )))*0.0001 ,4) 
	ls_DO_VEND          = Trim(Mid(ls_Input_Data,352,4  ))
	ls_PO_VEND          = Trim(Mid(ls_Input_Data,356,4  ))
	ls_EMPNO            = Trim(Mid(ls_Input_Data,360,6  ))
	ls_REMARK           = Trim(Mid(ls_Input_Data,366,20 ))
	ls_NATION_CODE      = Trim(Mid(ls_Input_Data,386,2  ))
	ls_END_LINE         = Trim(Mid(ls_Input_Data,388,1  ))
	
      
//
//공장별 거래처 읽어오기
	select nvl(RFNA2,''),nvl(RFNA3,'')
	into :ls_mcvcod,:ls_mdcvcod
	from reffpf
	where sabu = :arg_sabu and
			/*rfcod = '8I' and*/
			rfcod = '2A' and
			rfgub = 'MAS';
			
	if sqlca.sqlcode <> 0 or &
	   trim(ls_mcvcod)	= '' or trim(ls_mdcvcod) = '' or &
		isNull(ls_mcvcod)	 or isNull(ls_mdcvcod) then
		wf_error(arg_file_name,li_cnt,'',ls_WHSCD,ls_PTNO,'참조테이블에(REFFPF) 납품처 공장코드(거래처코드)가 없습니다.')
		
		il_err++
		continue ;
	end if
	
//	자체품번 읽어오기(자체거래처코드)
/* VAN수신 자료 품번 중 끝에 '-AM'이 붙어 들어오는 품목이 있음
   아래 쿼리에서 REPLACE함수로 하이픈을 제거하게 되면 비교값이 'K993061000AM' = 'K993061000-AM' 이렇게 됨.
   품번은 등록 되었으나 하이픈 제거로 비교값 성립되지 않음. 양쪽다 하이픈 제거 후 비교 방식으로 변경 - BY SHINGOON 2007.06.01 */
	SELECT itnbr into :ls_mitnbr
   	 FROM (	SELECT itnbr,ROWNUM RN 
					  FROM itemas
					  WHERE REPLACE(itnbr,'-','') = REPLACE(:ls_PTNO, '-', '') )
  	WHERE RN = 1 ;
/*	
	select itnbr
	  into :ls_mitnbr
	  from itemas
	 where replace(itnbr,'-','') = :ls_PTNO ;
*/	
	if sqlca.sqlcode <> 0 or Trim(ls_mitnbr) = '' or isNull(ls_mitnbr) then
		
		wf_error(arg_file_name,li_cnt,'',ls_WHSCD,ls_PTNO,'품번마스타에 품번이 등록되지 않았습니다.')
		
		il_err++
		continue ;
		
	End IF


	ls_mitnbr = trim(ls_mitnbr)
	ls_mcvcod = trim(ls_mcvcod)
	ls_mdcvcod = trim(ls_mdcvcod)
	ls_citnbr = trim(ls_citnbr)
	
	INSERT INTO  VAN_MOBIS_BR( SAUPJ,   
										BALGB,   
										ORD_YM,   
										ORD_SEQ,   
										ORDNO,   
										VNDCD,   
										PTNO,   
										HKID,   
										VAREA,   
										DEV_PER,   
										CON_PER,   
										STAT_PER,   
										BOUT_CD,   
										ORD_QTY,   
										DLVBF_CNL_QTY,   
										DLVAF_CNL_QTY,   
										PRE_INC_QTY,   
										LAST_INC_QTY,   
										DLVBF_INC_QTY,   
										DLVAF_INC_QTY,   
										CLM_QTY,   
										CLM_RATE,   
										OSEQ,   
										JSEQ,   
										ORD_DATE,   
										DUE_DATE,
										DUE_DATE_BOOGOOK,  /*DEFAULT로 납품일을 한텍납품일에 입력*/
										REQ_DATE,   
										ORDID,   
										ORDPRO,   
										ORD_INF,   
										BEFORE_ORD_INF,   
										WHSCD,   
										WHS_INC,   
										ADVAN_STR,   
										ADVAN_AGN,   
										DLV_PRICE,   
										TT_PRICE,   
										RAW_PRICE,   
										VEN_PRCD,   
										PTNM,   
										SRC,   
										VND_SRC,   
										VHC_KND,   
										CLASS,   
										LACID,   
										PROID,   
										LOCNO,   
										LST_DATE,   
										INSP_NO,   
										FIR_ORDNO,   
										FIR_DUE_DATE,   
										SUN_CD,   
										SUN_RATE,   
										DO_VEND,   
										PO_VEND,   
										EMPNO,   
										REMARK,   
										NATION_CODE,   
										END_LINE,   
										CRT_DATE,   
										CRT_TIME,   
										CRT_USER,   
										CITNBR,   
										MITNBR,   
										MCVCOD,   
										MDCVCOD  )
							VALUES ( :ls_saupj            ,                
										:ls_BALGB           	,
										:ls_ORD_YM          	,
										:ls_ORD_SEQ         	,
										:ls_ORDNO           	,
										:ls_VNDCD           	,
										:ls_PTNO            	,
										:ls_HKID            	,
										:ls_VAREA           	,
										:ls_DEV_PER         	,
										:ls_CON_PER         	,
										:ls_STAT_PER        	,
										:ls_BOUT_CD         	,
										:ll_ORD_QTY         	,
										:ll_DLVBF_CNL_QTY   	,
										:ll_DLVAF_CNL_QTY   	,
										:ll_PRE_INC_QTY     	,
										:ll_LAST_INC_QTY    	,
										:ll_DLVBF_INC_QTY   	,
										:ll_DLVAF_INC_QTY   	,
										:ll_CLM_QTY         	,
										:ld_CLM_RATE        	,
										:ls_OSEQ            	,
										:ll_JSEQ            	,
										:ls_ORD_DATE        	,
										:ls_DUE_DATE        	,
										:ls_DUE_DATE         , /*DEFAULT로 납품일을 한텍납품일에 입력*/
										:ls_REQ_DATE        	,
										:ls_ORDID           	,
										:ls_ORDPRO          	,
										:ls_ORD_INF         	,
										:ls_BEFORE_ORD_INF  	,
										:ls_WHSCD           	,
										:ls_WHS_INC         	,
										:ls_ADVAN_STR       	,
										:ls_ADVAN_AGN       	,
										:ll_DLV_PRICE       	,
										:ll_TT_PRICE        	,
										:ll_RAW_PRICE       	,
										:ls_VEN_PRCD        	,
										:ls_PTNM            	,
										:ls_SRC             	,
										:ls_VND_SRC         	,
										:ls_VHC_KND         	,
										:ls_CLASS           	,
										:ls_LACID           	,
										:ls_PROID           	,
										:ls_LOCNO           	,
										:ls_LST_DATE        	,
										:ls_INSP_NO         	,
										:ls_FIR_ORDNO       	,
										:ls_FIR_DUE_DATE    	,
										:ls_SUN_CD          	,
										:ld_SUN_RATE        	,
										:ls_DO_VEND         	,
										:ls_PO_VEND         	,
										:ls_EMPNO           	,
										:ls_REMARK          	,
										:ls_NATION_CODE     	,
										:ls_END_LINE        	,
										:ls_CRT_DATE         ,  
										:ls_CRT_TIME         ,  
										:ls_CRT_USER     		,
										:ls_CITNBR           ,  
										:ls_MITNBR           ,  
										:ls_MCVCOD           ,  
										:ls_MDCVCOD        ) ;
										

	If sqlca.sqlcode <> 0 Then
		
		st_state.Visible = False
		wf_error(arg_file_name,li_cnt,'',ls_WHSCD,ls_mitnbr,"입력에러가 발생했습니다." +sqlca.sqlerrtext+'[열위치:'+string(li_cnt)+']')
		rollback;
		FileClose(li_FileNum)
		return -3
	Else
		il_succeed++
	End if

	
	IF ll_DLV_PRICE > 0 THEN
	/* 단가 Update *******************************************************************/
	/* 단가이력 등록 수정 - 2007.01.11 - 송병호 */
		Select fun_vnddan_danga(:ls_ORD_DATE, :ls_mitnbr, :ls_mcvcod)
		  Into :ld_price From dual ;
		  
		if ld_price <> ll_DLV_PRICE then
			ls_new = 'Y'
		else
			ls_new = 'N'
		end if
	
		Select Count(*) Into :ll_cnt From vnddan 
		 Where cvcod = :ls_mcvcod and itnbr = :ls_mitnbr and start_date = :ls_ORD_DATE ; 
	
		If ll_cnt > 0 Then
			ls_new = 'N'
		end if
	
//		Select start_date , Nvl(sales_price,0) , Nvl(broad_price,0)
//		  Into :ls_start_date , :ld_bprice , :ld_bprice
//		  From vnddan
//		 Where cvcod = :ls_mcvcod 
//			and itnbr = :ls_mitnbr
//			and start_date in (Select Max(start_date) 
//										From  vnddan 
//									  Where cvcod = :ls_mcvcod 
//										 and itnbr = :ls_mitnbr ) ;
	
		If ls_new = 'Y' Then
			
			If ls_BALGB = 'DT' Then
				Insert Into vnddan ( CVCOD       ,ITNBR       ,START_DATE  ,  END_DATE ,                                                     
											SALES_PRICE ,CURR ,                                                      
											CRT_DATE    ,CRT_TIME , CRT_USER,
											DANGU       ,BIGO   )                                                           
								values( :ls_mcvcod ,:ls_mitnbr ,:ls_ORD_DATE ,  '99991231',                                             
											:ll_DLV_PRICE ,'WON' ,                                                             
											:is_today ,:is_totime , :gs_userid ,
											'1'         ,'BR VAN 접수 단가' ) ; 
			Else
				Insert Into vnddan ( CVCOD       ,ITNBR       ,START_DATE  ,   END_DATE ,                                                           
											broad_price ,broad_curr ,                                                      
											CRT_DATE    ,CRT_TIME , CRT_USER,
											DANGU       ,BIGO   )                                                           
								values( :ls_mcvcod ,:ls_mitnbr ,:ls_ORD_DATE ,   '99991231',                                             
											:ll_DLV_PRICE ,'WON' ,                                                             
											:is_today ,:is_totime , :gs_userid ,
											'1'         ,'BR VAN 접수 단가' ) ; 
			End if
//		Else
//	
//			If ls_BALGB = 'DT' and (ld_bprice <> ll_DLV_PRICE ) Then
//			
//					Update vnddan Set sales_price = :ll_DLV_PRICE ,
//											curr  = 'WON',
//											upd_date = :is_today ,
//											upd_time = :is_totime ,
//											upd_user = :gs_userid ,
//											Bigo = 'BR VAN 접수 단가'
//									Where cvcod = :ls_mcvcod 
//									  and itnbr = :ls_mitnbr
//									  and start_date = :ls_start_date ;
//			
//			ElseIf ls_BALGB <> 'DT' and (ld_price <> ll_DLV_PRICE ) Then
//				
//					Update vnddan Set broad_price = :ll_DLV_PRICE ,
//											broad_curr  = 'WON',
//											upd_date = :is_today ,
//											upd_time = :is_totime ,
//											upd_user = :gs_userid ,
//											Bigo = 'BR VAN 접수 단가'
//									Where cvcod = :ls_mcvcod 
//									  and itnbr = :ls_mitnbr
//									  and start_date = :ls_start_date ;
//			End if
		End If
		
		If sqlca.sqlcode <> 0 Then
			st_state.Visible = False
			wf_error(ls_gubun,li_cnt,"BR",ls_BALGB,ls_PTNO,"[단가입력 에러]"+sqlca.sqlerrText)
			rollback;
			FileClose(li_FileNum)
			return -3
		end if
	
	/*******************************************************************/
	END IF
	
	
Loop


// van file close
FileClose(li_FileNum)

commit;

st_state.Visible = False
return ll_data

end function

public function integer wf_van_br_new (string arg_file_name, string arg_sabu);// 엑셀 IMPORT ***************************************************************
Long   ll_value
String ls_docname
String ls_named
ll_value = GetFileOpenName("SPIN MOBIS 발주정보 가져오기", ls_docname, ls_named, "XLS", "XLS Files (*.XLS),*.XLS,")
If ll_value <> 1 Then Return 0

If FileExists(ls_docname) = False Then
	MessageBox('확인', ls_docname + ' 파일이 존재하지 않습니다.')
	Return -1
End If

//엑셀과 연결
uo_xlobject uo_xl

uo_xl = Create uo_xlobject
uo_xl.uf_excel_connect(ls_docname, False, 3)
uo_xl.uf_selectsheet(1)
uo_xl.uf_set_format(1, 1, '@' + space(30))

w_mdi_frame.sle_msg.text = ''

Setpointer(Hourglass!)

Long    ll_err     ; ll_err     = 0
Long    ll_succeed ; ll_succeed = 0
Long    ll_cnt     ; ll_cnt     = 0
Long    ll_xl_row  ; ll_xl_row  = 6 //Data 시작 Row Setting
Long    i
String  ls_SAUPJ          
String  ls_BALGB          
String  ls_ORD_YM         
String  ls_ORD_SEQ        
String  ls_ORDNO          
String  ls_VNDCD          
String  ls_PTNO           
String  ls_HKID           
String  ls_VAREA          
String  ls_DEV_PER        
String  ls_CON_PER        
String  ls_STAT_PER       
String  ls_BOUT_CD        
Long    ll_ORD_QTY        
Long    ll_DLVBF_CNL_QTY    
Long    ll_DLVAF_CNL_QTY    
Long    ll_PRE_INC_QTY    
Long    ll_LAST_INC_QTY    
Long    ll_DLVBF_INC_QTY    
Long    ll_DLVAF_INC_QTY    
Long    ll_CLM_QTY        
Decimal ld_CLM_RATE       
String  ls_OSEQ           
Long    ll_JSEQ           
String  ls_ORD_DATE       
String  ls_DUE_DATE       
String  ls_REQ_DATE       
String  ls_ORDID          
String  ls_ORDPRO         
String  ls_ORD_INF        
String  ls_BEFORE_ORD_INF    
String  ls_WHSCD          
String  ls_WHS_INC        
String  ls_ADVAN_STR      
String  ls_ADVAN_AGN      
Long    ll_DLV_PRICE      
Long    ll_TT_PRICE       
Long    ll_RAW_PRICE      
String  ls_VEN_PRCD       
String  ls_PTNM           
String  ls_SRC            
String  ls_VND_SRC        
String  ls_VHC_KND        
String  ls_CLASS          
String  ls_LACID          
String  ls_PROID          
String  ls_LOCNO          
String  ls_LST_DATE       
String  ls_INSP_NO        
String  ls_FIR_ORDNO      
String  ls_FIR_DUE_DATE    
String  ls_SUN_CD         
Decimal ld_SUN_RATE       
String  ls_DO_VEND        
String  ls_PO_VEND        
String  ls_EMPNO          
String  ls_REMARK         
String  ls_NATION_CODE    
String  ls_END_LINE      /*: 마지막라인 표시 */ 
String  ls_CRT_DATE       
String  ls_CRT_TIME       
String  ls_CRT_USER       
String  ls_CITNBR         
String  ls_MITNBR         
String  ls_MCVCOD         
String  ls_MDCVCOD
String  ls_gubun
Long    ll_VOR_QTY
Long    ll_BO_QTY
Integer li_cnt ; li_cnt = 0

ls_saupj = dw_ip.GetItemString(1, 'saupj')

Integer li_err
String  ls_err
DELETE FROM VAN_MOBIS_BR WHERE SAUPJ = :ls_saupj ;
If SQLCA.SQLCODE <> 0 Then
	ls_err = SQLCA.SQLERRTEXT ; li_err = SQLCA.SQLDBCODE
	ROLLBACK USING SQLCA;
	MessageBox(String(li_err), ls_err)
	uo_xl.uf_excel_Disconnect()
	Return -1
End If

COMMIT USING SQLCA;

//현재 일자,시간 
ls_crt_date = String(Today(), 'yyyymmdd')
ls_crt_time = String(Today(), 'hhmm')
ls_crt_user = gs_userid 

st_state.Visible = True

Do While(True)
	li_cnt ++
	
	//Data가 없을경우엔 Return...........
	If IsNull(gf_replace(Trim(uo_xl.uf_gettext(ll_xl_row, 2)), '?', '')) OR gf_replace(Trim(uo_xl.uf_gettext(ll_xl_row, 2)), '?', '') = '' Then Exit
	
	For i = 1 To 15
		uo_xl.uf_set_format(ll_xl_row, i, '@' + space(30))
	Next
	
	ls_BALGB            = gf_replace(Trim(uo_xl.uf_gettext(ll_xl_row, 8)), '?', '')
	Choose Case Trim(ls_BALGB)
		Case '기내'
			ls_BALGB = 'DK'
		Case '기수'
			ls_BALGB = 'EK'
		Case '현내'
			ls_BALGB = 'DH'
		Case '현수'
			ls_BALGB = 'EH'
	End Choose
	
	ls_ORD_YM           = LEFT(dw_ip.GetItemString(1, 'jisi_date'), 6)
	ls_ORD_SEQ          = '00000' /* VAN자료에서 주는 SEQ.가 없어서 그냥 '00000' 처리 (PK) */
	ls_ORDNO            = gf_replace(Trim(uo_xl.uf_gettext(ll_xl_row, 11)), '?', '')
	ls_VNDCD            = gf_replace(Trim(uo_xl.uf_gettext(ll_xl_row, 5)), '?', '')
	
	ls_PTNO             = gf_replace(Trim(uo_xl.uf_gettext(ll_xl_row, 2)), '?', '')
	SELECT REPLACE(:ls_PTNO, ' ', ''), REPLACE(:ls_PTNO, ' ', '-') 
	  INTO :ls_PTNO, :ls_MITNBR FROM DUAL ;
	
	ls_HKID             = RIGHT(ls_BALGB, 1)
	ls_VAREA            = 'U'
	ls_DEV_PER          = 'U1'
	ls_CON_PER          = gf_replace(Trim(uo_xl.uf_gettext(ll_xl_row, 7)), '?', '')
	ls_STAT_PER         = gf_replace(Trim(uo_xl.uf_gettext(ll_xl_row, 6)), '?', '')
	ls_BOUT_CD          = ''
	ll_ORD_QTY          = Long(Trim(uo_xl.uf_gettext(ll_xl_row, 24)))
	ll_DLVBF_CNL_QTY    = Long(Trim(uo_xl.uf_gettext(ll_xl_row, 26))) 
	ll_DLVAF_CNL_QTY    = 0
	ll_PRE_INC_QTY      = Long(Trim(uo_xl.uf_gettext(ll_xl_row, 28))) 
	ll_LAST_INC_QTY     = 0
	ll_DLVBF_INC_QTY    = Long(Trim(uo_xl.uf_gettext(ll_xl_row, 27))) 
	ll_DLVAF_INC_QTY    = Long(Trim(uo_xl.uf_gettext(ll_xl_row, 30))) 
	ll_CLM_QTY          = 0
	ld_CLM_RATE         = 0
	ls_OSEQ             = ''
	ll_JSEQ             = 0
	ls_ORD_DATE         = gf_replace(Trim(uo_xl.uf_gettext(ll_xl_row, 19)), '-', '')
	ls_DUE_DATE         = gf_replace(Trim(uo_xl.uf_gettext(ll_xl_row, 20)), '-', '')
	ls_REQ_DATE         = gf_replace(Trim(uo_xl.uf_gettext(ll_xl_row, 21)), '-', '')
	ls_ORDID            = gf_replace(Trim(uo_xl.uf_gettext(ll_xl_row, 14)), '?', '')
	ls_ORDPRO           = gf_replace(Trim(uo_xl.uf_gettext(ll_xl_row, 13)), '?', '')
	ls_ORD_INF          = gf_replace(Trim(uo_xl.uf_gettext(ll_xl_row, 15)), '?', '')
	ls_BEFORE_ORD_INF   = ''
	ls_WHSCD            = gf_replace(Trim(uo_xl.uf_gettext(ll_xl_row, 9)), '?', '')
	ls_WHS_INC          = gf_replace(Trim(uo_xl.uf_gettext(ll_xl_row, 10)), '?', '')
	ls_ADVAN_STR        = gf_replace(Trim(uo_xl.uf_gettext(ll_xl_row, 22)), '?', '')
	ls_ADVAN_AGN        = gf_replace(Trim(uo_xl.uf_gettext(ll_xl_row, 23)), '?', '')
	ll_DLV_PRICE        = Long(Trim(uo_xl.uf_gettext(ll_xl_row, 29)))
	ll_TT_PRICE         = 0
	ll_RAW_PRICE        = 0
	ls_VEN_PRCD         = ''
	ls_PTNM             = gf_replace(Trim(uo_xl.uf_gettext(ll_xl_row, 4)), '?', '')
	ls_SRC              = '1'
	ls_VND_SRC          = 'L'
	ls_VHC_KND          = ''
	ls_CLASS            = gf_replace(Trim(uo_xl.uf_gettext(ll_xl_row, 17)), '?', '')
	ls_LACID            = ''
	ls_PROID            = ''
	ls_LOCNO            = ''
	ls_LST_DATE         = ls_ORD_DATE
	ls_INSP_NO          = ''
	ls_FIR_ORDNO        = ls_ORDNO
	ls_FIR_DUE_DATE     = ls_DUE_DATE
	ls_SUN_CD           = ''
	ld_SUN_RATE         = 0
	ls_DO_VEND          = ''
	ls_PO_VEND          = ''
	ls_EMPNO            = 'P655'
	ls_REMARK           = gf_replace(Trim(uo_xl.uf_gettext(ll_xl_row, 35)), '?', '') //양단관리 로 사용(양산/단산)
	ls_NATION_CODE      = 'KR'
	ls_END_LINE         = '*'
	ls_CITNBR           = ''//gf_replace(Trim(uo_xl.uf_gettext(ll_xl_row, 24)), '?', '')
	ll_VOR_QTY          = Long(Trim(uo_xl.uf_gettext(ll_xl_row, 38)))
	ll_BO_QTY           = Long(Trim(uo_xl.uf_gettext(ll_xl_row, 25)))
	
	//공장별 거래처 읽어오기
	SELECT NVL(RFNA2, ''), NVL(RFNA3, '')
	  INTO :ls_mcvcod,     :ls_mdcvcod
	  FROM REFFPF
	 WHERE SABU = :arg_sabu AND RFCOD = '2A' AND RFGUB = 'MAS' ;
	If SQLCA.SQLCODE <> 0 OR Trim(ls_mcvcod) = '' OR Trim(ls_mdcvcod) = '' OR IsNull(ls_mcvcod) OR IsNull(ls_mdcvcod) Then
		wf_error(arg_file_name, li_cnt, '', ls_WHSCD, ls_PTNO, '참조테이블에(REFFPF) 납품처 공장코드(거래처코드)가 없습니다.')
		il_err++
		Continue;
	End If
	
	//	자체품번 읽어오기(자체거래처코드)
	/* VAN수신 자료 품번 중 끝에 '-AM'이 붙어 들어오는 품목이 있음
   아래 쿼리에서 REPLACE함수로 하이픈을 제거하게 되면 비교값이 'K993061000AM' = 'K993061000-AM' 이렇게 됨.
   품번은 등록 되었으나 하이픈 제거로 비교값 성립되지 않음. 양쪽다 하이픈 제거 후 비교 방식으로 변경 - BY SHINGOON 2007.06.01 */
	SELECT ITNBR INTO :ls_mitnbr
   	 FROM ( SELECT ITNBR, ROWNUM RN FROM ITEMAS
					  WHERE REPLACE(ITNBR, '-', '') = REPLACE(:ls_PTNO, '-', '') )
  	WHERE RN = 1 ;
	If SQLCA.SQLCODE <> 0 OR Trim(ls_mitnbr) = '' OR IsNull(ls_mitnbr) Then		
		wf_error(arg_file_name, li_cnt, '', ls_WHSCD, ls_PTNO, '품번마스타에 품번이 등록되지 않았습니다.')
		il_err++
		Continue ;
	End If
	
	INSERT INTO VAN_MOBIS_BR (
	SAUPJ        , BALGB        , ORD_YM      , ORD_SEQ       , ORDNO        , VNDCD           , PTNO     , 
	HKID         , VAREA        , DEV_PER     , CON_PER       , STAT_PER     , BOUT_CD         , ORD_QTY  ,
	DLVBF_CNL_QTY, DLVAF_CNL_QTY, PRE_INC_QTY , LAST_INC_QTY  , DLVBF_INC_QTY, DLVAF_INC_QTY   , CLM_QTY  ,
	CLM_RATE     , OSEQ         , JSEQ        , ORD_DATE      , DUE_DATE     , DUE_DATE_BOOGOOK, REQ_DATE ,
	ORDID        ,	ORDPRO       ,	ORD_INF     , BEFORE_ORD_INF, WHSCD        , WHS_INC         , ADVAN_STR,
	ADVAN_AGN    , DLV_PRICE    , TT_PRICE    , RAW_PRICE     , VEN_PRCD     , PTNM            , SRC      ,
	VND_SRC      ,	VHC_KND      , CLASS       , LACID         , PROID        , LOCNO           , LST_DATE ,
	INSP_NO      , FIR_ORDNO    , FIR_DUE_DATE, SUN_CD        , SUN_RATE     , DO_VEND         ,	PO_VEND  ,
	EMPNO        , REMARK       , NATION_CODE , END_LINE      , CRT_DATE     , CRT_TIME        , CRT_USER ,
	CITNBR       , MITNBR       , MCVCOD      , MDCVCOD       , BO_QTY       )
	VALUES (
	:ls_saupj        , :ls_BALGB        , :ls_ORD_YM      , :ls_ORD_SEQ       , :ls_ORDNO        , :ls_VNDCD        , :ls_PTNO     ,
	:ls_HKID         , :ls_VAREA        , :ls_DEV_PER     , :ls_CON_PER       , :ls_STAT_PER     , :ls_BOUT_CD      , :ll_ORD_QTY  ,
	:ll_DLVBF_CNL_QTY, :ll_DLVAF_CNL_QTY, :ll_PRE_INC_QTY , :ll_LAST_INC_QTY  , :ll_DLVBF_INC_QTY, :ll_DLVAF_INC_QTY, :ll_CLM_QTY  ,
	:ld_CLM_RATE     , :ls_OSEQ         , :ll_JSEQ        , :ls_ORD_DATE      , :ls_DUE_DATE     , :ls_DUE_DATE     , :ls_REQ_DATE ,
	:ls_ORDID        , :ls_ORDPRO       , :ls_ORD_INF     , :ls_BEFORE_ORD_INF, :ls_WHSCD        , :ls_WHS_INC      , :ls_ADVAN_STR,
	:ls_ADVAN_AGN    , :ll_DLV_PRICE    , :ll_TT_PRICE    , :ll_RAW_PRICE     , :ls_VEN_PRCD     , :ls_PTNM         , :ls_SRC      ,
	:ls_VND_SRC      , :ls_VHC_KND      , :ls_CLASS       , :ls_LACID         , :ls_PROID        , :ls_LOCNO        , :ls_LST_DATE ,
	:ls_INSP_NO      , :ls_FIR_ORDNO    , :ls_FIR_DUE_DATE, :ls_SUN_CD        , :ld_SUN_RATE     , :ls_DO_VEND      , :ls_PO_VEND  ,
	:ls_EMPNO        , :ls_REMARK       , :ls_NATION_CODE , :ls_END_LINE      , :ls_CRT_DATE     , :ls_CRT_TIME     , :ls_CRT_USER ,
	:ls_CITNBR       , :ls_MITNBR       , :ls_MCVCOD      , :ls_MDCVCOD       , :ll_BO_QTY       ) ;
	If SQLCA.SQLCODE <> 0 Then
		st_state.Visible = False
		wf_error(ls_named, li_cnt, '', ls_WHSCD, ls_mitnbr, "입력에러가 발생했습니다." + SQLCA.SQLERRTEXT + '[열위치:' + String(li_cnt) + ']')
		ROLLBACK USING SQLCA;
		uo_xl.uf_excel_Disconnect()
		return -3
	End If
	
	st_state.Text = '[' + String(li_cnt) + '행] ' + ls_PTNO + ' / ' + ls_ORDNO
	
	ll_xl_row ++
Loop

COMMIT USING SQLCA;
uo_xl.uf_excel_Disconnect()

/* VAN 코멘트 저장용 TABLE에 자료 생성 - 기본값 생성 */
INSERT INTO VAN_MOBIS_BR_REMARK
SELECT A.VNDCD, A.ORDNO, A.ORD_SEQ, '' AS CMMT
  FROM VAN_MOBIS_BR A
 WHERE NOT EXISTS ( SELECT 'X' FROM VAN_MOBIS_BR_REMARK Z
                     WHERE Z.VNDCD = A.VNDCD AND Z.ORDNO = A.ORDNO AND Z.ORD_SEQ = A.ORD_SEQ ) ;
If SQLCA.SQLCODE <> 0 Then
	st_state.Visible = False
//	MessageBox(String(SQLCA.SQLDBCODE), 'Default자료 생성 오류~r~r~n~n' + SQLCA.SQLERRTEXT)
	ROLLBACK USING SQLCA;
	Return -3
End If

COMMIT USING SQLCA;
MessageBox('자료생성', '자료 생성이 완료 되었습니다.')

st_state.Visible = False
Return li_cnt

end function

public function integer wf_van_er (string arg_file_name, string arg_sabu);string   ls_Input_Data , ls_indate, ls_ptnois
integer  li_FileNum,li_cnt,li_rowcnt
Long     ll_data = 0  , ll_r 

String  ls_SAUPJ          
String  ls_PTNO
String  ls_COM_ORD          
Long    ln_VOR_QTY         
Long    ln_AIR_QTY        
Long    ln_SEA_QTY        
Long    ln_BO_QTY
String  ls_VAN_DATE        
Long    ln_END_LINE      /*: 마직막라인 표시 */ 
String  ls_CRT_DATE       
String  ls_CRT_TIME       
String  ls_CRT_USER       
String  ls_CITNBR         
String  ls_MITNBR         
String  ls_MCVCOD         
String  ls_MDCVCOD
String  ls_gubun

//현재 일자,시간 

ls_crt_date = Trim(dw_ip.Object.jisi_date[1])
ls_crt_time = string(today(),'hhmm')
ls_crt_user = gs_userid 

ls_gubun = 'E:BackOrder정보'
ls_saupj = Trim(dw_ip.Object.saupj[1])

li_FileNum = FileOpen(is_path+arg_file_name,LineMode!,Read!)

if li_FileNum = -1 then
	wf_error(arg_file_name,li_cnt,'','','',"["+arg_file_name+"]"+" VAN자료가 없습니다.!!")
	FileClose(li_FileNum)
	return -1
end if

delete from van_mobis_er where saupj = :ls_saupj ;
commit;

li_cnt = 0
st_state.Visible = True
st_state.Text = '데이타를 읽는 중입니다...'

Do While	FileRead(li_FileNum, ls_Input_Data) <> -100 
	
	ls_mitnbr 	= ''
	ls_mcvcod 	= ''
	ls_mdcvcod 	= ''
	ls_citnbr 	= ''
	li_cnt++
	ll_data++
	
	yield()
	st_state.Text = "파일명: "+arg_file_name +"  라인수 :" +String(li_cnt)

	ls_PTNO             = Trim(Mid(ls_Input_Data,1,18 ))
	ls_COM_ORD          = Trim(Mid(ls_Input_Data,19,1 ))
	ln_VOR_QTY          = Long(Trim(Mid(ls_Input_Data,20,7 )))
	ln_AIR_QTY          = Long(Trim(Mid(ls_Input_Data,27,7 )))
	ln_SEA_QTY          = Long(Trim(Mid(ls_Input_Data,34,7 )))
	ln_BO_QTY			  = ln_AIR_QTY + ln_SEA_QTY		
	ls_VAN_DATE         = Trim(Mid(ls_Input_Data,41,8 ))
	ln_END_LINE         = Long(Trim(Mid(ls_Input_Data,49,1 )))
	
      
//
//공장별 거래처 읽어오기
	select nvl(RFNA2,''),nvl(RFNA3,'')
	into :ls_mcvcod,:ls_mdcvcod
	from reffpf
	where sabu = :arg_sabu and
			/*rfcod = '8I' and*/
			rfcod = '2A' and
			rfgub = 'MAS';
			
	if sqlca.sqlcode <> 0 or &
	   trim(ls_mcvcod)	= '' or trim(ls_mdcvcod) = '' or &
		isNull(ls_mcvcod)	 or isNull(ls_mdcvcod) then
		wf_error(arg_file_name,li_cnt,'','',ls_PTNO,'참조테이블에(REFFPF) 납품처 공장코드(거래처코드)가 없습니다.')
		
		il_err++
		continue ;
	end if
	
//	자체품번 읽어오기(자체거래처코드)
/* VAN수신 자료 품번 중 끝에 '-AM'이 붙어 들어오는 품목이 있음
   아래 쿼리에서 REPLACE함수로 하이픈을 제거하게 되면 비교값이 'K993061000AM' = 'K993061000-AM' 이렇게 됨.
   품번은 등록 되었으나 하이픈 제거로 비교값 성립되지 않음. 양쪽다 하이픈 제거 후 비교 방식으로 변경 - BY SHINGOON 2007.06.01 */
	SELECT itnbr into :ls_mitnbr
   	 FROM (	SELECT itnbr,ROWNUM RN 
					  FROM itemas
					  WHERE REPLACE(itnbr,'-','') = REPLACE(:ls_PTNO, '-', '') )
  	WHERE RN = 1 ;
	
	if sqlca.sqlcode <> 0 or Trim(ls_mitnbr) = '' or isNull(ls_mitnbr) then
		
		wf_error(arg_file_name,li_cnt,'','',ls_PTNO,'품번마스타에 품번이 등록되지 않았습니다.')
		
		il_err++
		continue ;
	End IF

	ls_mitnbr = trim(ls_mitnbr)
	ls_mcvcod = trim(ls_mcvcod)
	ls_mdcvcod = trim(ls_mdcvcod)
	ls_citnbr = trim(ls_citnbr)
	
	
//	BackOrder  등록되어 있으면 Update
	select ptno
	  into :ls_ptnois
	  from van_mobis_er
	 where PTNO = :ls_PTNO 
	  AND COM_ORD = :ls_COM_ORD
	  AND VOR_QTY = :ln_VOR_QTY 
	  AND AIR_QTY = :ln_AIR_QTY 
	  AND SEA_QTY = :ln_SEA_QTY ;
	  
	  
	if ln_vor_qty = 0 and ln_bo_qty = 0 then
		continue;
	end if
	
	if sqlca.sqlcode <> 0 or Trim(ls_ptnois) = '' or isNull(ls_ptnois) then
  		INSERT INTO  VAN_MOBIS_ER( SAUPJ,   
										PTNO,   
										COM_ORD,   
										VOR_QTY,   
										AIR_QTY,   
										SEA_QTY,   
										VAN_DATE,   
										END_LINE,   
										CRT_DATE,   
										CRT_TIME,   
										CRT_USER,   
										CITNBR,   
										MITNBR,   
										MCVCOD,   
										MDCVCOD  )
							VALUES ( :ls_saupj               ,                
										:ls_PTNO           	   ,
										:ls_COM_ORD         	   ,
										:ln_VOR_QTY        	   ,
										:ln_AIR_QTY         	   ,
										:ln_SEA_QTY         	   ,
										:ls_VAN_DATE        	   ,
										:ln_END_LINE        	   ,
										:ls_CRT_DATE            ,  
										:ls_CRT_TIME            ,  
										:ls_CRT_USER     		   ,
										:ls_CITNBR              ,  
										:ls_MITNBR              ,  
										:ls_MCVCOD              ,  
										:ls_MDCVCOD             ); 
   else
  		UPDATE VAN_MOBIS_ER SET
		  			 				   SAUPJ   	  = :ls_saupj               ,                
										COM_ORD    = :ls_COM_ORD         	 ,
										VOR_QTY    = :ln_VOR_QTY        	    ,
										AIR_QTY    = :ln_AIR_QTY         	 ,
										SEA_QTY    = :ln_SEA_QTY         	 ,
										VAN_DATE   = :ls_VAN_DATE        	 ,
										END_LINE   = :ln_END_LINE        	 ,
										CRT_DATE   = :ls_CRT_DATE            ,  
										CRT_TIME   = :ls_CRT_TIME            ,  
										CRT_USER   = :ls_CRT_USER     		 ,
										CITNBR     = :ls_CITNBR              ,  
										MITNBR     = :ls_MITNBR              ,  
										MCVCOD     = :ls_MCVCOD              ,  
										MDCVCOD    = :ls_MDCVCOD              
							     WHERE 
									  		PTNO 		  = :ls_PTNO           	   
									  AND COM_ORD = :ls_com_ord
									  AND VOR_QTY = :ln_VOR_QTY 
									  AND AIR_QTY = :ln_AIR_QTY 
									  AND SEA_QTY = :ln_SEA_QTY ;
										  
	End IF

		UPDATE VAN_MOBIS_BR SET
		  			 				   SAUPJ   	  = :ls_saupj               	,                
										VOR_QTY    = :ln_VOR_QTY        	    	,
										BO_QTY     = :ln_BO_QTY						,
										CITNBR     = :ls_CITNBR              	,  
										MITNBR     = :ls_MITNBR              	,  
										MCVCOD     = :ls_MCVCOD              	,  
										MDCVCOD    = :ls_MDCVCOD              
							     WHERE PTNO	  = :ls_PTNO 
								     AND SAUPJ   = :ls_saupj
									  AND DECODE(BALGB,'EH','H','EK','K','DT','D') = :ls_com_ord ;
		


	if sqlca.sqlcode <> 0 then
		st_state.Visible = False
		wf_error(arg_file_name,li_cnt,'','',ls_mitnbr,"입력에러가 발생했습니다." +sqlca.sqlerrtext+'[열위치:'+string(li_cnt)+']')
		rollback;
		FileClose(li_FileNum)
		return -3
	Else
		il_succeed++
	End if

	Commit;	
	
Loop

// van file close
FileClose(li_FileNum)

//van 파일명 변경

//li_FileNum = FileCopy(arg_file_name,left(arg_file_name,pos(trim(arg_file_name),".")) + "bak",TRUE)
//if li_FileNum <> 1 then
//	Rollback ;
//	st_state.Visible = False
//	wf_error(ls_gubun,0,'','','',"파일변경에 에러가 발생했습니다."  )
//	
//	return -4
//end if

//van 파일 삭제
//if not FileDelete(arg_file_name) then 
//	Rollback ;
//	st_state.Visible = False
//	messagebox('error','화일삭제 에러입니다.')
//	return -4
//end if

//	발주정보에 등록 Update (VOR B/0 및 AIR/SEA 합친 B/O 수량)


st_state.Visible = False
return ll_data

end function

public function integer wf_van_fr (string arg_file_name, string arg_sabu);string   ls_Input_Data , ls_indate, ls_mspc_ptnois
integer  li_FileNum,li_cnt,li_rowcnt
Long     ll_data = 0  , ll_r 


String	ls_SAUPJ           
String	ls_MSPC_PTNO	
String	ls_MSPC_HK_ED	
String	ls_MSPC_CP_ID	
String	ls_MSPC_END_DATE	
String	ls_MSPC_PHSEQ	
String	ls_MSPC_VAN_DATE	
String	ls_MSPC_VAN_TIME	
String	ls_MSPC_PAK_CLASS	
String	ls_MSPC_APP_DATE	
Long		ll_MSPC_NET_LEN	
Long		ll_MSPC_NET_WID	
Long		ll_MSPC_NET_HEI	
Long		ll_MSPC_NET_WEI	
String	ls_MSPC_NET_MAT	
String	ls_MSPC_LABEL	
Long		ll_MSPC_QFP	
Long		ll_MSPC_FIR_QFP	
Long		ll_MSPC_QUP	
String	ls_MSPC_VIN_CD	
Long		ll_MSPC_VIN_UNIT	
String	ls_MSPC_VIN_QALTY	
Long		ll_MSPC_VIN_LENTH	
Long		ll_MSPC_VIN_WIDE	
Long		ll_MSPC_VIN_WEIGH	
String	ls_MSPC_VIN_TYPE	
String	ls_MSPC_CAR_CD	
Long		ll_MSPC_CAT_UNIT	
String	ls_MSPC_CAT_QALTY	
Long		ll_MSPC_CAT_LENTH	
Long		ll_MSPC_CAT_WIDE	
Long		ll_MSPC_CAT_HEIGH	
Long		ll_MSPC_CAT_WEIGH	
String	ls_MSPC_CAT_TYPE	
String	ls_MSPC_CAT_LOGO	
String	ls_MSPC_ARU_CD	
Long		ll_MSPC_ARU_UNIT	
String	ls_MSPC_ARU_QALTY	
Long		ll_MSPC_ARU_LENTH	
Long		ll_MSPC_ARU_WIDE	
Long		ll_MSPC_ARU_HEIGH	
Long		ll_MSPC_ARU_QTY	
Long		ll_MSPC_ARU_WEIGH	
String	ls_MSPC_CUS_CD	
Long		ll_MSPC_CUS_UNIT	
String	ls_MSPC_CUS_QALTY	
Long		ll_MSPC_CUS_LENTH	
Long		ll_MSPC_CUS_WIDE	
Long		ll_MSPC_CUS_HEIGH	
Long		ll_MSPC_CUS_QTY	
Long		ll_MSPC_CUS_WEIGH	
String	ls_MSPC_MID_CD	
Long		ll_MSPC_MID_UNIT	
String	ls_MSPC_MID_QALTY	
Long		ll_MSPC_MID_LENTH	
Long		ll_MSPC_MID_WIDE	
Long		ll_MSPC_MID_HEIGH	
Long		ll_MSPC_MID_WEIGH	
String	ls_MSPC_MID_TYPE	
String	ls_MSPC_MID_LOGO	
String	ls_MSPC_OUT_CD	
Long		ll_MSPC_OUT_UNIT	
String	ls_MSPC_OUT_QALTY	
Long		ll_MSPC_OUT_LENTH	
Long		ll_MSPC_OUT_WIDE	
Long		ll_MSPC_OUT_HEIGH	
Long		ll_MSPC_OUT_WEIGH	
String	ls_MSPC_OUT_TYPE	
String	ls_MSPC_OUT_LOGO	
String	ls_MSPC_WOD_CD	
Long		ll_MSPC_WOD_UNIT	
String	ls_MSPC_WOD_QALTY	
Long		ll_MSPC_WOD_LENTH	
Long		ll_MSPC_WOD_WIDE	
Long		ll_MSPC_WOD_HEIGH	
Long		ll_MSPC_WOD_WEIGH	
String	ls_MSPC_WOD_TYPE	
String	ls_MSPC_WOD_LOGO	
String	ls_MSPC_INS_DATE	
Long		ll_END_LINE	
String	ls_CRT_DATE        
String	ls_CRT_TIME        
String	ls_CRT_USER        
String	ls_CITNBR          
String	ls_MITNBR          
String	ls_MCVCOD          
String	ls_MDCVCOD         
String   ls_gubun           

//현재 일자,시간 

ls_crt_date = Trim(dw_ip.Object.jisi_date[1])
ls_crt_time = string(today(),'hhmm')
ls_crt_user = gs_userid 

ls_gubun 			= 'F:SPEC정보'
ls_saupj 			= Trim(dw_ip.Object.saupj[1])
//ls_input_date     = Trim(dw_ip.Object.jisi_date[1])

li_FileNum = FileOpen(is_path+arg_file_name,LineMode!,Read!)

if li_FileNum = -1 then
	wf_error(arg_file_name,li_cnt,'','','',"["+arg_file_name+"]"+" VAN자료가 없습니다.!!")
	FileClose(li_FileNum)
	return -1
end if

li_cnt = 0
st_state.Visible = True
st_state.Text = '데이타를 읽는 중입니다...'

Do While	FileRead(li_FileNum, ls_Input_Data) <> -100
	
	ls_mitnbr = ''
	ls_mcvcod = ''
	ls_mdcvcod = ''
	ls_citnbr = ''
	li_cnt ++
	ll_data ++
	
	yield()
	st_state.Text = "파일명: "+arg_file_name +"  라인수 :" +String(li_cnt)

	ls_MSPC_PTNO			= Trim(Mid(ls_Input_Data,1,18  ))                 
	ls_MSPC_HK_ED			= Trim(Mid(ls_Input_Data,19,1  ))                 
	ls_MSPC_CP_ID			= Trim(Mid(ls_Input_Data,20,1  ))                 
	ls_MSPC_END_DATE		= Trim(Mid(ls_Input_Data,21,8  ))                 
	ls_MSPC_PHSEQ			= Trim(Mid(ls_Input_Data,29,3  ))             	
	ls_MSPC_VAN_DATE		= Trim(Mid(ls_Input_Data,32,8  ))                 
	ls_MSPC_VAN_TIME		= Trim(Mid(ls_Input_Data,40,8  ))             	
	ls_MSPC_PAK_CLASS		= Trim(Mid(ls_Input_Data,48,1  ))             	
	ls_MSPC_APP_DATE		= Trim(Mid(ls_Input_Data,49,8  ))             	
	ll_MSPC_NET_LEN		= Long(Trim(Mid(ls_Input_Data,57,7  )))             	    
	ll_MSPC_NET_WID		= Long(Trim(Mid(ls_Input_Data,64,7  )))               
	ll_MSPC_NET_HEI		= Long(Trim(Mid(ls_Input_Data,71,7  )))               
	ll_MSPC_NET_WEI		= Long(Trim(Mid(ls_Input_Data,78,7  )))               
	ls_MSPC_NET_MAT		= Trim(Mid(ls_Input_Data,85,2  ))           
	ls_MSPC_LABEL			= Trim(Mid(ls_Input_Data,87,1  ))                 
	ll_MSPC_QFP				= Long(Trim(Mid(ls_Input_Data,88,3  )))                     
	ll_MSPC_FIR_QFP		= Long(Trim(Mid(ls_Input_Data,91,3  )))               
	ll_MSPC_QUP				= Long(Trim(Mid(ls_Input_Data,94,5  )))               
	ls_MSPC_VIN_CD			= Trim(Mid(ls_Input_Data,99,7  ))           
	ll_MSPC_VIN_UNIT		= Long(Trim(Mid(ls_Input_Data,106,7  )))                     	
	ls_MSPC_VIN_QALTY		= Trim(Mid(ls_Input_Data,113,3  ))          
	ll_MSPC_VIN_LENTH		= Long(Trim(Mid(ls_Input_Data,116,7  )))             	     	
	ll_MSPC_VIN_WIDE		= Long(Trim(Mid(ls_Input_Data,123,7  )))               	
	ll_MSPC_VIN_WEIGH		= Long(Trim(Mid(ls_Input_Data,130,7  )))               	
	ls_MSPC_VIN_TYPE		= Trim(Mid(ls_Input_Data,137,1  ))          
	ls_MSPC_CAR_CD			= Trim(Mid(ls_Input_Data,138,7  ))             	
	ll_MSPC_CAT_UNIT		= Long(Trim(Mid(ls_Input_Data,145,7  )))                     	
	ls_MSPC_CAT_QALTY		= Trim(Mid(ls_Input_Data,152,3  ))          
	ll_MSPC_CAT_LENTH		= Long(Trim(Mid(ls_Input_Data,155,7  )))             	     	
	ll_MSPC_CAT_WIDE		= Long(Trim(Mid(ls_Input_Data,162,7  )))               	
	ll_MSPC_CAT_HEIGH		= Long(Trim(Mid(ls_Input_Data,169,7  )))               	
	ll_MSPC_CAT_WEIGH		= Long(Trim(Mid(ls_Input_Data,176,7  )))               	
                                                                        
	ls_MSPC_CAT_TYPE		= Trim(Mid(ls_Input_Data,183,1  ))          
	ls_MSPC_CAT_LOGO		= Trim(Mid(ls_Input_Data,184,2  ))             	
	ls_MSPC_ARU_CD			= Trim(Mid(ls_Input_Data,186,7  ))             	
	ll_MSPC_ARU_UNIT		= Long(Trim(Mid(ls_Input_Data,193,7  )))                     	
	ls_MSPC_ARU_QALTY		= Trim(Mid(ls_Input_Data,200,3  ))            
	ll_MSPC_ARU_LENTH		= Long(Trim(Mid(ls_Input_Data,203,7  )))             	   	
	ll_MSPC_ARU_WIDE		= Long(Trim(Mid(ls_Input_Data,210,7  )))               	
	ll_MSPC_ARU_HEIGH		= Long(Trim(Mid(ls_Input_Data,217,7  )))               	
	ll_MSPC_ARU_QTY		= Long(Trim(Mid(ls_Input_Data,224,7  )))               
	ll_MSPC_ARU_WEIGH		= Long(Trim(Mid(ls_Input_Data,231,7  )))               	
	ls_MSPC_CUS_CD			= Trim(Mid(ls_Input_Data,238,7  ))            
	ll_MSPC_CUS_UNIT		= Long(Trim(Mid(ls_Input_Data,245,7  )))                     	
	ls_MSPC_CUS_QALTY		= Trim(Mid(ls_Input_Data,252,3  ))            
	ll_MSPC_CUS_LENTH		= Long(Trim(Mid(ls_Input_Data,255,7  )))             	   	
	ll_MSPC_CUS_WIDE		= Long(Trim(Mid(ls_Input_Data,262,7  )))               	
	ll_MSPC_CUS_HEIGH		= Long(Trim(Mid(ls_Input_Data,269,7  )))               	
	ll_MSPC_CUS_QTY		= Long(Trim(Mid(ls_Input_Data,276,7  )))               
	ll_MSPC_CUS_WEIGH		= Long(Trim(Mid(ls_Input_Data,283,7  )))               	
	ls_MSPC_MID_CD			= Trim(Mid(ls_Input_Data,290,7  ))            
	ll_MSPC_MID_UNIT		= Long(Trim(Mid(ls_Input_Data,297,7  )))                     	
	ls_MSPC_MID_QALTY		= Trim(Mid(ls_Input_Data,304,3  ))            
	ll_MSPC_MID_LENTH		= Long(Trim(Mid(ls_Input_Data,307,7  )))             	   	
	ll_MSPC_MID_WIDE		= Long(Trim(Mid(ls_Input_Data,314,7  )))               	
	ll_MSPC_MID_HEIGH		= Long(Trim(Mid(ls_Input_Data,321,7  )))               	
	ll_MSPC_MID_WEIGH		= Long(Trim(Mid(ls_Input_Data,328,7  )))               	
	ls_MSPC_MID_TYPE		= Trim(Mid(ls_Input_Data,335,1  ))            
	ls_MSPC_MID_LOGO		= Trim(Mid(ls_Input_Data,336,2  ))             	
	ls_MSPC_OUT_CD			= Trim(Mid(ls_Input_Data,338,7  ))             	
	ll_MSPC_OUT_UNIT		= Long(Trim(Mid(ls_Input_Data,345,7  )))                     	
	ls_MSPC_OUT_QALTY		= Trim(Mid(ls_Input_Data,352,3  ))            
	ll_MSPC_OUT_LENTH		= Long(Trim(Mid(ls_Input_Data,355,7  )))             	   	
	ll_MSPC_OUT_WIDE		= Long(Trim(Mid(ls_Input_Data,362,7  )))               	
	ll_MSPC_OUT_HEIGH		= Long(Trim(Mid(ls_Input_Data,369,7  )))               	
	ll_MSPC_OUT_WEIGH		= Long(Trim(Mid(ls_Input_Data,376,7  )))               	
	ls_MSPC_OUT_TYPE		= Trim(Mid(ls_Input_Data,383,1  ))            
                                                                        
	ls_MSPC_OUT_LOGO		= Trim(Mid(ls_Input_Data,384,2  ))             	
	ls_MSPC_WOD_CD			= Trim(Mid(ls_Input_Data,386,7  ))             	
	ll_MSPC_WOD_UNIT		= Long(Trim(Mid(ls_Input_Data,393,7  )))                     	
	ls_MSPC_WOD_QALTY		= Trim(Mid(ls_Input_Data,400,3  ))            
	ll_MSPC_WOD_LENTH		= Long(Trim(Mid(ls_Input_Data,403,7  )))             	   	
	ll_MSPC_WOD_WIDE		= Long(Trim(Mid(ls_Input_Data,410,7  )))               	
	ll_MSPC_WOD_HEIGH		= Long(Trim(Mid(ls_Input_Data,417,7  )))               	
	ll_MSPC_WOD_WEIGH		= Long(Trim(Mid(ls_Input_Data,424,7  )))               	
	ls_MSPC_WOD_TYPE		= Trim(Mid(ls_Input_Data,431,1  ))            
	ls_MSPC_WOD_LOGO		= Trim(Mid(ls_Input_Data,432,2  ))             	
	ls_MSPC_INS_DATE		= Trim(Mid(ls_Input_Data,434,8  ))             	
	ll_END_LINE				= Long(Trim(Mid(ls_Input_Data,442,1  )))             	
	
	
//
//공장별 거래처 읽어오기
//	select nvl(RFNA2,''),nvl(RFNA3,'')
//	into :ls_mcvcod,:ls_mdcvcod
//	from reffpf
//	where sabu = :arg_sabu and
//			rfcod = '1G' and
//			rfgub = :ls_factory;
//			
//	if sqlca.sqlcode <> 0 or &
//	   trim(ls_mcvcod)	= '' or trim(ls_mdcvcod) = '' or &
//		isNull(ls_mcvcod)	 or isNull(ls_mdcvcod) then
//		wf_error(arg_file_name,li_cnt,ls_doccode,ls_factory,ls_itnbr,'참조테이블에(REFFPF) 하치장(납품장소) 코드가 없습니다.')
//		
//		Continue ;
//	end if

//	자체품번 읽어오기(자체거래처코드)
/* VAN수신 자료 품번 중 끝에 '-AM'이 붙어 들어오는 품목이 있음
   아래 쿼리에서 REPLACE함수로 하이픈을 제거하게 되면 비교값이 'K993061000AM' = 'K993061000-AM' 이렇게 됨.
   품번은 등록 되었으나 하이픈 제거로 비교값 성립되지 않음. 양쪽다 하이픈 제거 후 비교 방식으로 변경 - BY SHINGOON 2007.06.01 */
	SELECT itnbr into :ls_mitnbr
   	 FROM (	SELECT itnbr,ROWNUM RN 
					  FROM itemas
					  WHERE REPLACE(itnbr,'-','') = REPLACE(:ls_MSPC_PTNO, '-', '') )
  	WHERE RN = 1 ;	
	

	if sqlca.sqlcode <> 0 or Trim(ls_mitnbr) = '' or isNull(ls_mitnbr) then
		
		wf_error(arg_file_name,li_cnt,'','',ls_mspc_PTNO,'품번마스타에 품번이 등록되지 않았습니다.')
		
		il_err++
		continue ;
		
	End IF 

	ls_mitnbr = trim(ls_mitnbr)
	ls_mcvcod = trim(ls_mcvcod)
	ls_mdcvcod = trim(ls_mdcvcod)
	ls_citnbr = trim(ls_citnbr)


//	Spec  등록되어 있으면 Update
	select mspc_ptno
	  into :ls_mspc_ptnois
	  from van_mobis_fr
	 where replace(mspc_ptno,'-','') = :ls_mspc_PTNO and MSPC_HK_ED = :ls_MSPC_HK_ED  ;
	
	if sqlca.sqlcode <> 0 or Trim(ls_mspc_ptnois) = '' or isNull(ls_mspc_ptnois) then
	
	
		INSERT INTO  VAN_MOBIS_FR( SAUPJ, 
										MSPC_PTNO,	
										MSPC_HK_ED,	
										MSPC_CP_ID,	
										MSPC_END_DATE,	
										MSPC_PHSEQ,	
										MSPC_VAN_DATE,	
										MSPC_VAN_TIME,	
										MSPC_PAK_CLASS,	
										MSPC_APP_DATE,	
										MSPC_NET_LEN,	
										MSPC_NET_WID,	
										MSPC_NET_HEI,	
										MSPC_NET_WEI,	
										MSPC_NET_MAT,	
										MSPC_LABEL,	
										MSPC_QFP,	
										MSPC_FIR_QFP,	
										MSPC_QUP,	
										MSPC_VIN_CD,	
										MSPC_VIN_UNIT,	
										MSPC_VIN_QALTY,	
										MSPC_VIN_LENTH,	
										MSPC_VIN_WIDE,	
										MSPC_VIN_WEIGH,	
										MSPC_VIN_TYPE,	
										MSPC_CAR_CD,	
										MSPC_CAT_UNIT,	
										MSPC_CAT_QALTY,	
										MSPC_CAT_LENTH,	
										MSPC_CAT_WIDE,	
										MSPC_CAT_HEIGH,	
										MSPC_CAT_WEIGH,	
										MSPC_CAT_TYPE,	
										MSPC_CAT_LOGO,	
										MSPC_ARU_CD,	
										MSPC_ARU_UNIT,	
										MSPC_ARU_QALTY,	
										MSPC_ARU_LENTH,	
										MSPC_ARU_WIDE,	
										MSPC_ARU_HEIGH,	
										MSPC_ARU_QTY,	
										MSPC_ARU_WEIGH,	
										MSPC_CUS_CD,	
										MSPC_CUS_UNIT,	
										MSPC_CUS_QALTY,	
										MSPC_CUS_LENTH,	
										MSPC_CUS_WIDE,	
										MSPC_CUS_HEIGH,	
										MSPC_CUS_QTY,	
										MSPC_CUS_WEIGH,	
										MSPC_MID_CD,	
										MSPC_MID_UNIT,	
										MSPC_MID_QALTY,	
										MSPC_MID_LENTH,	
										MSPC_MID_WIDE,	
										MSPC_MID_HEIGH,	
										MSPC_MID_WEIGH,	
										MSPC_MID_TYPE,	
										MSPC_MID_LOGO,	
										MSPC_OUT_CD,	
										MSPC_OUT_UNIT,	
										MSPC_OUT_QALTY,	
										MSPC_OUT_LENTH,	
										MSPC_OUT_WIDE,	
										MSPC_OUT_HEIGH,	
										MSPC_OUT_WEIGH,	
										MSPC_OUT_TYPE,	
										MSPC_OUT_LOGO,	
										MSPC_WOD_CD,	
										MSPC_WOD_UNIT,	
										MSPC_WOD_QALTY,
										MSPC_WOD_LENTH,	
										MSPC_WOD_WIDE,	
										MSPC_WOD_HEIGH,
										MSPC_WOD_WEIGH,	
										MSPC_WOD_TYPE,	
										MSPC_WOD_LOGO,	
										MSPC_INS_DATE,	
										END_LINE, 
										CRT_DATE,   
										CRT_TIME,   
										CRT_USER,   
										CITNBR,   
										MITNBR,   
										MCVCOD,   
										MDCVCOD                 )
							VALUES ( :ls_saupj               ,
										:ls_MSPC_PTNO				,
										:ls_MSPC_HK_ED				,		
										:ls_MSPC_CP_ID				,
										:ls_MSPC_END_DATE			,
										:ls_MSPC_PHSEQ				,
										:ls_MSPC_VAN_DATE			,
										:ls_MSPC_VAN_TIME			,
										:ls_MSPC_PAK_CLASS		,
										:ls_MSPC_APP_DATE			,
										:ll_MSPC_NET_LEN			,	
										:ll_MSPC_NET_WID			,	
										:ll_MSPC_NET_HEI			,	
										:ll_MSPC_NET_WEI			,	
										:ls_MSPC_NET_MAT			,	
										:ls_MSPC_LABEL				,
										:ll_MSPC_QFP				,         
										:ll_MSPC_FIR_QFP			,	
										:ll_MSPC_QUP				,         
										:ls_MSPC_VIN_CD			,	
										:ll_MSPC_VIN_UNIT	 		, 	
										:ls_MSPC_VIN_QALTY		,	
										:ll_MSPC_VIN_LENTH		,	  	
										:ll_MSPC_VIN_WIDE	 		, 	
										:ll_MSPC_VIN_WEIGH		,  	
										:ls_MSPC_VIN_TYPE			,
										:ls_MSPC_CAR_CD			,	
										:ll_MSPC_CAT_UNIT			,	  	
										:ls_MSPC_CAT_QALTY		,	
										:ll_MSPC_CAT_LENTH		,	  	
										:ll_MSPC_CAT_WIDE	 		, 	
										:ll_MSPC_CAT_HEIGH		,	  	
										:ll_MSPC_CAT_WEIGH		,	  	
                                
										:ls_MSPC_CAT_TYPE			,
										:ls_MSPC_CAT_LOGO			,
										:ls_MSPC_ARU_CD			,	
										:ll_MSPC_ARU_UNIT	 		, 	
										:ls_MSPC_ARU_QALTY		,	
										:ll_MSPC_ARU_LENTH		,		
										:ll_MSPC_ARU_WIDE			,  	
										:ll_MSPC_ARU_HEIGH		,	  	
										:ll_MSPC_ARU_QTY			,	
										:ll_MSPC_ARU_WEIGH		,	  	
										:ls_MSPC_CUS_CD			,	
										:ll_MSPC_CUS_UNIT			,  	
										:ls_MSPC_CUS_QALTY		,	
										:ll_MSPC_CUS_LENTH		,		
										:ll_MSPC_CUS_WIDE	 		, 	
										:ll_MSPC_CUS_HEIGH		,	  	
										:ll_MSPC_CUS_QTY			,	
										:ll_MSPC_CUS_WEIGH		,	  	
										:ls_MSPC_MID_CD			,	
										:ll_MSPC_MID_UNIT			,  	
										:ls_MSPC_MID_QALTY		,	
										:ll_MSPC_MID_LENTH		,		
										:ll_MSPC_MID_WIDE			,  	
										:ll_MSPC_MID_HEIGH		,	  	
										:ll_MSPC_MID_WEIGH		,	  	
										:ls_MSPC_MID_TYPE			,
										:ls_MSPC_MID_LOGO			,
										:ls_MSPC_OUT_CD			,	
										:ll_MSPC_OUT_UNIT	 		, 	
										:ls_MSPC_OUT_QALTY		,	
										:ll_MSPC_OUT_LENTH		,		
										:ll_MSPC_OUT_WIDE	 		, 	
										:ll_MSPC_OUT_HEIGH		,	  	
										:ll_MSPC_OUT_WEIGH		,	  	
										:ls_MSPC_OUT_TYPE			,
                                
										:ls_MSPC_OUT_LOGO			,
										:ls_MSPC_WOD_CD			,	
										:ll_MSPC_WOD_UNIT			,  	
										:ls_MSPC_WOD_QALTY		,	
										:ll_MSPC_WOD_LENTH		,		
										:ll_MSPC_WOD_WIDE			,  	
										:ll_MSPC_WOD_HEIGH		,	  	
										:ll_MSPC_WOD_WEIGH		,	  			
										:ls_MSPC_WOD_TYPE			,
										:ls_MSPC_WOD_LOGO			,
										:ls_MSPC_INS_DATE	      ,
										:ll_END_LINE            ,  
										:ls_CRT_DATE            ,  
										:ls_CRT_TIME            ,  
										:ls_CRT_USER     		   ,
										:ls_CITNBR              ,  
										:ls_MITNBR              ,  
										:ls_MCVCOD              ,  
										:ls_MDCVCOD             ) ;
	else										
  		UPDATE VAN_MOBIS_FR SET
		  			 				   SAUPJ   	  					= :ls_saupj         			,
										MSPC_HK_ED	         	= :ls_MSPC_HK_ED		 		,
										MSPC_CP_ID	         	= :ls_MSPC_CP_ID		 		,
										MSPC_END_DATE	         = :ls_MSPC_END_DATE	 		,		                       
										MSPC_PHSEQ	         	= :ls_MSPC_PHSEQ		 		,	                       
										MSPC_VAN_DATE	         = :ls_MSPC_VAN_DATE	 		,		                       
										MSPC_VAN_TIME	         = :ls_MSPC_VAN_TIME	 		,		                       
										MSPC_PAK_CLASS	         = :ls_MSPC_PAK_CLASS	 		,	                               
										MSPC_APP_DATE	         = :ls_MSPC_APP_DATE	 		,		                       
										MSPC_NET_LEN	         = :ll_MSPC_NET_LEN	 		,			                
										MSPC_NET_WID	         = :ll_MSPC_NET_WID	 		,			                
										MSPC_NET_HEI	         = :ll_MSPC_NET_HEI	 		,			                
										MSPC_NET_WEI	         = :ll_MSPC_NET_WEI	 		,			                
										MSPC_NET_MAT	         = :ls_MSPC_NET_MAT	 		,			                
										MSPC_LABEL	         	= :ls_MSPC_LABEL		 		,		                       
										MSPC_QFP	         		= :ll_MSPC_QFP			 		,	                       
										MSPC_FIR_QFP	         = :ll_MSPC_FIR_QFP	 		,			                
										MSPC_QUP	         		= :ll_MSPC_QUP			 		,	                       
										MSPC_VIN_CD	         	= :ls_MSPC_VIN_CD		 		,		                        
										MSPC_VIN_UNIT	         = :ll_MSPC_VIN_UNIT	 		, 		 	                
										MSPC_VIN_QALTY	         = :ls_MSPC_VIN_QALTY	 		,		                        
										MSPC_VIN_LENTH	         = :ll_MSPC_VIN_LENTH	 		,		  	                
										MSPC_VIN_WIDE	         = :ll_MSPC_VIN_WIDE	 		, 		 	                
										MSPC_VIN_WEIGH	         = :ll_MSPC_VIN_WEIGH	 		,	  	                        
										MSPC_VIN_TYPE	         = :ls_MSPC_VIN_TYPE	 		,		                       
										MSPC_CAR_CD	         	= :ls_MSPC_CAR_CD		 		,		                        
										MSPC_CAT_UNIT	         = :ll_MSPC_CAT_UNIT	 		,			  	        
										MSPC_CAT_QALTY	         = :ls_MSPC_CAT_QALTY	 		,		                        
										MSPC_CAT_LENTH	         = :ll_MSPC_CAT_LENTH	 		,		  	                
										MSPC_CAT_WIDE	         = :ll_MSPC_CAT_WIDE	  		,		 	                
										MSPC_CAT_HEIGH	         = :ll_MSPC_CAT_HEIGH	 		,		  	                
										MSPC_CAT_WEIGH	         = :ll_MSPC_CAT_WEIGH	 		,		  	                
										MSPC_CAT_TYPE	         = :ls_MSPC_CAT_TYPE	  		,                                                                
										MSPC_CAT_LOGO	         = :ls_MSPC_CAT_LOGO	 		,		                       
										MSPC_ARU_CD	         	= :ls_MSPC_ARU_CD		 		,		                       
										MSPC_ARU_UNIT	         = :ll_MSPC_ARU_UNIT	 		,		                        
										MSPC_ARU_QALTY	         = :ls_MSPC_ARU_QALTY	  		,		 	                
										MSPC_ARU_LENTH	         = :ll_MSPC_ARU_LENTH	 		,		                        
										MSPC_ARU_WIDE	         = :ll_MSPC_ARU_WIDE	 		,			                
										MSPC_ARU_HEIGH	         = :ll_MSPC_ARU_HEIGH	 		,	  	                
										MSPC_ARU_QTY	         = :ll_MSPC_ARU_QTY	 		,		  	                
										MSPC_ARU_WEIGH	         = :ll_MSPC_ARU_WEIGH	 		,			                
										MSPC_CUS_CD	         	= :ls_MSPC_CUS_CD		 		,		  	                
										MSPC_CUS_UNIT	         = :ll_MSPC_CUS_UNIT	 		,		                        
										MSPC_CUS_QALTY	         = :ls_MSPC_CUS_QALTY	 		,		  	                
										MSPC_CUS_LENTH	         = :ll_MSPC_CUS_LENTH	 		,		                        
										MSPC_CUS_WIDE	         = :ll_MSPC_CUS_WIDE	 		,			                
										MSPC_CUS_HEIGH	         = :ll_MSPC_CUS_HEIGH	  		,		 	                
										MSPC_CUS_QTY	         = :ll_MSPC_CUS_QTY	 		,		  	                
										MSPC_CUS_WEIGH	         = :ll_MSPC_CUS_WEIGH	 		,			                
										MSPC_MID_CD	         	= :ls_MSPC_MID_CD		 		,		  	                
										MSPC_MID_UNIT	         = :ll_MSPC_MID_UNIT	 		,		                        
										MSPC_MID_QALTY	         = :ls_MSPC_MID_QALTY	 		,		  	                
										MSPC_MID_LENTH	         = :ll_MSPC_MID_LENTH	 		,		                        
										MSPC_MID_WIDE	         = :ll_MSPC_MID_WIDE	 		,			                
										MSPC_MID_HEIGH	         = :ll_MSPC_MID_HEIGH	 		,		  	                
										MSPC_MID_WEIGH	         = :ll_MSPC_MID_WEIGH	 		,		  	                
										MSPC_MID_TYPE	         = :ls_MSPC_MID_TYPE	 		,		  	                
										MSPC_MID_LOGO	         = :ls_MSPC_MID_LOGO	 		,		                       
										MSPC_OUT_CD	         	= :ls_MSPC_OUT_CD		 		,		                       
										MSPC_OUT_UNIT	         = :ll_MSPC_OUT_UNIT	 		,		                        
										MSPC_OUT_QALTY	         = :ls_MSPC_OUT_QALTY	  		,		 	                
										MSPC_OUT_LENTH	         = :ll_MSPC_OUT_LENTH	 		,		                        
										MSPC_OUT_WIDE	         = :ll_MSPC_OUT_WIDE	 		,			                
										MSPC_OUT_HEIGH	         = :ll_MSPC_OUT_HEIGH	 		, 		 	                
										MSPC_OUT_WEIGH	         = :ll_MSPC_OUT_WEIGH	 		,		  	                
										MSPC_OUT_TYPE	         = :ls_MSPC_OUT_TYPE	 		,		  	                
										MSPC_OUT_LOGO	         = :ls_MSPC_OUT_LOGO			,				                       
										MSPC_WOD_CD	            = :ls_MSPC_WOD_CD		 		,		                                                                 
										MSPC_WOD_UNIT	         = :ll_MSPC_WOD_UNIT	 		,		                       
										MSPC_WOD_QALTY          = :ls_MSPC_WOD_QALTY	 		,		                        
										MSPC_WOD_LENTH	         = :ll_MSPC_WOD_LENTH	 		,		  	                
										MSPC_WOD_WIDE	         = :ll_MSPC_WOD_WIDE	 		,		                        
										MSPC_WOD_HEIGH          = :ll_MSPC_WOD_HEIGH	 		,			                
										MSPC_WOD_WEIGH	         = :ll_MSPC_WOD_WEIGH	 		,		  	                
										MSPC_WOD_TYPE	         = :ls_MSPC_WOD_TYPE	 		,		  	                
										MSPC_WOD_LOGO	         = :ls_MSPC_WOD_LOGO	 		,	  			
										MSPC_INS_DATE	         = :ls_MSPC_INS_DATE	 		,                               
										END_LINE 					= :ll_END_LINE        		,             	                       
										CRT_DATE   					= :ls_CRT_DATE        		,                                                  
										CRT_TIME   					= :ls_CRT_TIME        		,                                                  
										CRT_USER   					= :ls_CRT_USER     	 		,	                                     	
										CITNBR   					= :ls_CITNBR          		,                                                  
										MITNBR   					= :ls_MITNBR          		,                                                    
										MCVCOD     					= :ls_MCVCOD          		,                                                          
										MDCVCOD                 = :ls_MDCVCOD        		 		  
							     WHERE MSPC_PTNO 		      = :ls_MSPC_PTNO
								    AND SAUPJ                 = :ls_saupj;
	end if
										
										
	commit;										

	If sqlca.sqlcode <> 0 Then
		
		st_state.Visible = False
		wf_error(arg_file_name,li_cnt,'','',ls_mitnbr,"입력에러가 발생했습니다." +sqlca.sqlerrtext+'[열위치:'+string(li_cnt)+']')
		rollback;
		FileClose(li_FileNum)
		return -3
	Else
		il_succeed++
	End if
	
Loop


// van file close
FileClose(li_FileNum)

//van 파일명 변경

//li_FileNum = FileCopy(arg_file_name,left(arg_file_name,pos(trim(arg_file_name),".")) + "bak",TRUE)
//if li_FileNum <> 1 then
//	Rollback ;
//	st_state.Visible = False
//	wf_error(ls_gubun,0,'','','',"파일변경에 에러가 발생했습니다."  )
//	
//	return -4
//end if

//van 파일 삭제
//if not FileDelete(arg_file_name) then 
//	Rollback ;
//	st_state.Visible = False
//	messagebox('error','화일삭제 에러입니다.')
//	return -4
//end if


st_state.Visible = False
return ll_data

end function

public function integer wf_van_hr (string arg_file_name, string arg_sabu, string as_gubun);string   ls_Input_Data , ls_indate
integer  li_FileNum,li_cnt,li_rowcnt,li_cnt2
Long     ll_data = 0  , ll_r 

String	ls_SAUPJ        
String	ls_CMD_KND	
String	ls_YYMM         
String	ls_RONO         
String	ls_VINNO        
String	ls_PTNO         
String	ls_CASCD        
String	ls_VLPCD        
String	ls_VHC_KND      
String	ls_PRDT         
String	ls_SALE_DATE    
String	ls_JBDT         
Long		ll_ODMT         
String	ls_BFRP         
String	ls_BFOD         
String	ls_BFRO         
String	ls_COLR         
Long		ll_BRPM         
Long		ll_BSBM         
String	ls_OPCD         
String	ls_EGNO         
String	ls_TMNO         
String	ls_ACTY         
String	ls_EGTY         
String	ls_TMTY         
String	ls_RTDT		
Long		ll_EXRT		
Long		ll_VND_RATE     
Long		ll_PART_AMT     
Long		ll_REQ_AMT      
String	ls_FIX_VNDCD    
String	ls_INS_DATE     
String	ls_REQ_DATE     
String	ls_UPD_DATE	
String	ls_EX_KR	
Long		ll_END_LINE	
String 	ls_CRT_DATE       
String  	ls_CRT_TIME       
String  	ls_CRT_USER       
String  	ls_CITNBR         
String  	ls_MITNBR         
String  	ls_MCVCOD         
String  	ls_MDCVCOD
String  	ls_gubun

//현재 일자,시간 

ls_crt_date = Trim(dw_ip.Object.jisi_date[1])
ls_crt_time = string(today(),'hhmm')
ls_crt_user = gs_userid 


if as_gubun = 'HR' then
	ls_gubun = 'H:크래임-내수'
else
	ls_gubun = 'K:크래임-해외'	
end if

ls_saupj = Trim(dw_ip.Object.saupj[1])

li_FileNum = FileOpen(is_path+arg_file_name,LineMode!,Read!)

if li_FileNum = -1 then
	wf_error(arg_file_name,li_cnt,'','','',"["+arg_file_name+"]"+" VAN자료가 없습니다.!!")
	FileClose(li_FileNum)
	return -1
end if

li_cnt = 0
st_state.Visible = True
st_state.Text = '데이타를 읽는 중입니다...'

Do While	FileRead(li_FileNum, ls_Input_Data) <> -100
	
	ls_mitnbr = ''
	ls_mcvcod = ''
	ls_mdcvcod = ''
	ls_citnbr = ''
	li_cnt ++
	ll_data ++
	
	yield()
	st_state.Text = "파일명: "+arg_file_name +"  라인수 :" +String(li_cnt)
	
	ls_CMD_KND			= 	Trim(Mid(ls_Input_Data,1,1))        
	ls_YYMM				= 	Trim(Mid(ls_Input_Data,2,6))        
	ls_RONO				= 	Trim(Mid(ls_Input_Data,8,19  ))        
	ls_VINNO				= 	Trim(Mid(ls_Input_Data,27,17  ))        
	ls_PTNO				= 	Trim(Mid(ls_Input_Data,44,18  ))        
	ls_CASCD				= 	Trim(Mid(ls_Input_Data,62,3  ))        
	ls_VLPCD				= 	Trim(Mid(ls_Input_Data,65,3  ))        
	ls_VHC_KND			= 	Trim(Mid(ls_Input_Data,68,4  ))        
	ls_PRDT				= 	Trim(Mid(ls_Input_Data,72,8  ))        
	ls_SALE_DATE		= 	Trim(Mid(ls_Input_Data,80,8  ))        
	ls_JBDT				= 	Trim(Mid(ls_Input_Data,88,8  ))        
	ll_ODMT				= 	Long(Trim(Mid(ls_Input_Data,96,7  )))        
	ls_BFRP				= 	Trim(Mid(ls_Input_Data,103,8  ))        
	ls_BFOD				= 	Trim(Mid(ls_Input_Data,111,7  ))        
	ls_BFRO				= 	Trim(Mid(ls_Input_Data,118,19  ))        
	ls_COLR				= 	Trim(Mid(ls_Input_Data,137,2  ))        
	ll_BRPM				= 	Long(Trim(Mid(ls_Input_Data,139,9  )))        
	ll_BSBM				= 	Long(Trim(Mid(ls_Input_Data,148,9  )))        
	ls_OPCD				= 	Trim(Mid(ls_Input_Data,157,9  ))        
	ls_EGNO				= 	Trim(Mid(ls_Input_Data,166,12  ))        
	ls_TMNO				= 	Trim(Mid(ls_Input_Data,178,11  ))  
if as_gubun = 'HR' then	
	ls_ACTY				= 	Trim(Mid(ls_Input_Data,189,1  ))        
	ls_EGTY				= 	Trim(Mid(ls_Input_Data,190,4  ))        
	ls_TMTY				= 	Trim(Mid(ls_Input_Data,194,1  ))        
	ls_RTDT				= 	''
	ll_EXRT				= 	0
	ll_VND_RATE			= 	Truncate(Double(Trim(Mid(ls_Input_Data,195,5)))*0.01  ,2)           	
	ll_PART_AMT			= 	Long(Trim(Mid(ls_Input_Data,200,9  )))        
	ll_REQ_AMT			= 	Long(Trim(Mid(ls_Input_Data,209,9  )))        
	ls_FIX_VNDCD		= 	Trim(Mid(ls_Input_Data,218,4  ))        
	ls_INS_DATE			= 	Trim(Mid(ls_Input_Data,222,8  ))        
	ls_REQ_DATE			= 	Trim(Mid(ls_Input_Data,230,8  ))        
	ls_UPD_DATE			= 	Trim(Mid(ls_Input_Data,238,8  ))        
	ll_END_LINE			=	Long(Trim(Mid(ls_Input_Data,246,1	)))
else
	ls_ACTY				= 	''
	ls_EGTY				= 	''
	ls_TMTY				= 	''
	ls_RTDT				= 	Trim(Mid(ls_Input_Data,189,8  ))        
	ll_EXRT				= 	Truncate(Double(Trim(Mid(ls_Input_Data,197,7)))*0.01  ,2)           	
	ll_VND_RATE			= 	Truncate(Double(Trim(Mid(ls_Input_Data,204,5)))*0.01  ,2)           	
	ll_PART_AMT			= 	Long(Trim(Mid(ls_Input_Data,209,9  )))        
	ll_REQ_AMT			= 	Long(Trim(Mid(ls_Input_Data,218,9  )))        
	ls_FIX_VNDCD		= 	Trim(Mid(ls_Input_Data,227,4  ))        
	ls_INS_DATE			= 	Trim(Mid(ls_Input_Data,231,8  ))        
	ls_REQ_DATE			= 	Trim(Mid(ls_Input_Data,239,8  ))        
	ls_UPD_DATE			= 	Trim(Mid(ls_Input_Data,247,8  ))        
	ll_END_LINE			=	Long(Trim(Mid(ls_Input_Data,255,1	)))
end if   

//
//공장별 거래처 읽어오기
//	select nvl(RFNA2,''),nvl(RFNA3,'')
//	into :ls_mcvcod,:ls_mdcvcod
//	from reffpf
//	where sabu = :arg_sabu and
//			rfcod = '1G' and
//			rfgub = :ls_factory;
//			
//	if sqlca.sqlcode <> 0 or &
//	   trim(ls_mcvcod)	= '' or trim(ls_mdcvcod) = '' or &
//		isNull(ls_mcvcod)	 or isNull(ls_mdcvcod) then
//		wf_error(arg_file_name,li_cnt,ls_doccode,ls_factory,ls_itnbr,'참조테이블에(REFFPF) 하치장(납품장소) 코드가 없습니다.')
//		
//		Continue ;
//	end if
	
//	자체품번 읽어오기(자체거래처코드)
/*	select itnbr
	  into :ls_mitnbr
	  from itemas
	 where replace(itnbr,'-','') = :ls_PTNO ;
	
	if sqlca.sqlcode <> 0 or Trim(ls_mitnbr) = '' or isNull(ls_mitnbr) then
		
		wf_error(arg_file_name,li_cnt,'','',ls_PTNO,'품번마스타에 품번이 등록되지 않았습니다.')

		il_err++
		continue ;
		
	End IF
*/
	ls_mitnbr = trim(ls_PTNO)
	ls_mcvcod = trim(ls_mcvcod)
	ls_mdcvcod = trim(ls_mdcvcod)
	ls_citnbr = trim(ls_citnbr)
	li_cnt2 = 0 

   SELECT COUNT(*) INTO :li_cnt2
	  FROM VAN_MOBIS_HR
	 WHERE CMD_KND = :ls_CMD_KND
	   AND YYMM = :ls_YYMM
		AND RONO = :ls_RONO ;

	if as_gubun = 'HR' then
		ls_EX_KR			= 	'내수'
	else
		ls_EX_KR			= 	'수출'
	end if	
		
	If li_cnt2 <= 0 Then
	
	INSERT INTO  VAN_MOBIS_HR( SAUPJ			  ,   
										CMD_KND       ,
										YYMM          ,
										RONO          ,
										VINNO         ,
										PTNO          ,
										CASCD         ,  
										VLPCD         ,  
										VHC_KND       ,  
										PRDT          ,  
										SALE_DATE     ,  
										JBDT          ,  
										ODMT          ,  
										BFRP          ,  
										BFOD          ,  
										BFRO          ,  
										COLR          ,  
										BRPM          ,  
										BSBM          ,  
										OPCD          ,  
										EGNO          ,  
										TMNO          ,  
										ACTY          ,  
										EGTY          ,  
										TMTY          ,  
										RTDT          ,  
										EXRT          ,  
										VND_RATE      ,  
										PART_AMT      ,  
										REQ_AMT       ,  
										FIX_VNDCD     ,  
										INS_DATE      ,  
										REQ_DATE      ,  
										UPD_DATE      ,  
										EX_KR         ,  
										END_LINE      ,  
										CRT_DATE	  	  ,   
										CRT_TIME		  ,   
										CRT_USER		  ,   
										CITNBR		  ,   
										MITNBR		  ,   
										MCVCOD		  ,   
										MDCVCOD  )
							VALUES ( :ls_saupj		  ,
										:ls_CMD_KND		  ,
										:ls_YYMM	        ,
										:ls_RONO	        ,
										:ls_VINNO	     ,
										:ls_PTNO	        ,
										:ls_CASCD	     ,
										:ls_VLPCD	     ,
										:ls_VHC_KND	     ,
										:ls_PRDT	     	  ,
										:ls_SALE_DATE	  ,
										:ls_JBDT	        ,
										:ll_ODMT	        ,
										:ls_BFRP	        ,
										:ls_BFOD	        ,
										:ls_BFRO	        ,
										:ls_COLR	        ,
										:ll_BRPM	        ,
										:ll_BSBM	        ,
										:ls_OPCD	        ,
										:ls_EGNO	        ,
										:ls_TMNO	        ,
										:ls_ACTY	        ,
										:ls_EGTY	        ,
										:ls_TMTY	        ,
										:ls_RTDT	        ,
										:ll_EXRT	        ,
										:ll_VND_RATE	  ,   
										:ll_PART_AMT	  ,   
										:ll_REQ_AMT		  ,   
										:ls_FIX_VNDCD	  ,
										:ls_INS_DATE	  ,
										:ls_REQ_DATE	  ,
										:ls_UPD_DATE	  ,
										:LS_EX_KR        ,  										
										:ll_END_LINE	  ,
										:ls_CRT_DATE     ,  
										:ls_CRT_TIME     ,  
										:ls_CRT_USER	  ,
										:ls_CITNBR	     ,  
										:ls_MITNBR	     ,  
										:ls_MCVCOD	     ,  
										:ls_MDCVCOD		) ;
		Else
		
		UPDATE VAN_MOBIS_HR SET SAUPJ 			 =       :ls_saupj         ,       
										CMD_KND    		 =			:ls_CMD_KND			,	           
										YYMM            =       :ls_YYMM				,                
										RONO            =       :ls_RONO				,                
										VINNO           =       :ls_VINNO			,                
										PTNO            =       :ls_PTNO				,                
										CASCD           =       :ls_CASCD			,                
										VLPCD           =       :ls_VLPCD			,                
										VHC_KND         =       :ls_VHC_KND			,                
										PRDT            =       :ls_PRDT				,     	        
										SALE_DATE       =       :ls_SALE_DATE		,                
										JBDT            =       :ls_JBDT				,                
										ODMT            =       :ll_ODMT				,                
										BFRP            =       :ls_BFRP				,                
										BFOD            =       :ls_BFOD				,                
										BFRO            =       :ls_BFRO				,                
										COLR            =       :ls_COLR				,                
										BRPM            =       :ll_BRPM				,                
										BSBM            =       :ll_BSBM				,                
										OPCD            =       :ls_OPCD				,                
										EGNO            =       :ls_EGNO				,                
										TMNO            =       :ls_TMNO				,                
										ACTY            =       :ls_ACTY				,                
										EGTY            =       :ls_EGTY				,                
										TMTY            =       :ls_TMTY				,                
										RTDT            =       :ls_RTDT				,                
										EXRT            =       :ll_EXRT				,                
										VND_RATE        =       :ll_VND_RATE		,                
										PART_AMT        =       :ll_PART_AMT		,                
										REQ_AMT         =       :ll_REQ_AMT			,	        
										FIX_VNDCD       =       :ls_FIX_VNDCD		,                
										INS_DATE        =       :ls_INS_DATE		,                
										REQ_DATE        =       :ls_REQ_DATE		,                
										UPD_DATE        =       :ls_UPD_DATE		,                
										EX_KR           =       :LS_EX_KR     	 	,   		
										END_LINE        =       :ll_END_LINE		,                
										CRT_DATE			 =  		:ls_CRT_DATE    	,                     
										CRT_TIME			 =			:ls_CRT_TIME    	,                     
										CRT_USER			 =			:ls_CRT_USER		,                     
										CITNBR			 =       :ls_CITNBR			,                
										MITNBR			 =       :ls_MITNBR			,                
										MCVCOD			 =       :ls_MCVCOD			,                
										MDCVCOD         =       :ls_MDCVCOD				
										
							 	WHERE CMD_KND  = :ls_CMD_KND
									   AND YYMM = :ls_YYMM
										AND RONO = :ls_RONO ;
		
	END IF

	If sqlca.sqlcode <> 0 Then
		
		st_state.Visible = False
		wf_error(arg_file_name,li_cnt,'','',ls_mitnbr,"입력에러가 발생했습니다." +sqlca.sqlerrtext+'[열위치:'+string(li_cnt)+']')
		rollback;
		FileClose(li_FileNum)
		return -3
	Else
		il_succeed++
	End if
	

Loop


// van file close
FileClose(li_FileNum)

//van 파일명 변경

//li_FileNum = FileCopy(arg_file_name,left(arg_file_name,pos(trim(arg_file_name),".")) + "bak",TRUE)
//if li_FileNum <> 1 then
//	Rollback ;
//	st_state.Visible = False
//	wf_error(ls_gubun,0,'','','',"파일변경에 에러가 발생했습니다."  )
//	
//	return -4
//end if

//van 파일 삭제
//if not FileDelete(arg_file_name) then 
//	Rollback ;
//	st_state.Visible = False
//	messagebox('error','화일삭제 에러입니다.')
//	return -4
//end if

commit;

st_state.Visible = False
return ll_data


end function

public function integer wf_van_nr (string arg_file_name, string arg_sabu, string as_gubun);string   ls_Input_Data , ls_indate
integer  li_FileNum,li_cnt,li_rowcnt, li_cnt2
Long     ll_data = 0  , ll_r 

String  	ls_SAUPJ   
String	ls_MINC_BRNCD		
String	ls_MINC_IN_YM		
String	ls_MINC_IN_SEQ		
String	ls_MINC_INSP_NO		
String	ls_MINC_PTNO		
String	ls_MINC_VNDCD		
String	ls_MINC_SRC		
String	ls_MINC_LEP		
String	ls_MINC_VHC_KND		
String	ls_MINC_PTNM		
String	ls_MINC_CLASS		
String	ls_MINC_HK_ED		
String	ls_MINC_VAN_DATE	
String	ls_MINC_VAN_TIME	
String	ls_MINC_DEV_PER		
String	ls_MINC_VAREA		
String	ls_MINC_WHS_ORD		
String	ls_MINC_WHS_INC		
String	ls_MINC_ADV_BRN		
String	ls_MINC_ADV_AGN		
Long		ll_MINC_CNCL_QTY	
Long		ll_MINC_RAW_PRICE	
Long		ll_MINC_CUS_PRICE	
String	ls_orgprc	/* 단가기호 적용 - 2007.02.09 - 송병호 */
String	ls_chgprc	/* 단가기호 적용 - 2007.02.09 - 송병호 */
String	ls_orgqty	/* 수량기호 적용 - 2007.03.15 - 송병호 */
String	ls_chgqty	/* 수량기호 적용 - 2007.03.15 - 송병호 */
Long		ll_MINC_INDLV_PRICE	
String	ls_MINC_INCOT_YES	
String	ls_MINC_INPAC_YES	
Long		ll_MINC_INCUS_PRICE	
Long		ll_MINC_OKQTY		
String	ls_MINC_RINSP_NO	
String	ls_MINC_CERCD		
Long		ll_MINC_CER_QTY		
String	ls_MINC_ACC_DATE	
String	ls_MINC_IN_DATE		
String	ls_MINC_DLV_DATE	
String	ls_MINC_PDT_DATE	
String	ls_MINC_ORDID		
String	ls_MINC_ORD_PRO		
String	ls_MINC_INID		
String	ls_MINC_ORD_INF		
String	ls_MINC_PRO_CESS1	
String	ls_MINC_PRO_CESS2	
String	ls_MINC_INC_INF		
String	ls_MINC_IWA_INF		
String	ls_MINC_BRNCD_WHS	
String	ls_MINC_BRNCD_RAW	
String	ls_MINC_CHG_PTNO	
String	ls_MINC_FIR_ORDNO	
String	ls_MINC_ORDNO		
String	ls_MINC_RAW_ORDNO	
String	ls_MINC_LC_ID		
String	ls_MINC_OINSP_NO	
String	ls_MINC_EMPNO		
Long		ll_MINC_ORD_QTY		
Long		ll_END_LINE		
String 	ls_CRT_DATE       
String  	ls_CRT_TIME       
String  	ls_CRT_USER       
String  	ls_CITNBR         
String  	ls_MITNBR         
String  	ls_MCVCOD         
String  	ls_MDCVCOD
String  	ls_gubun
String  	ll_day_month

//현재 일자,시간 

ls_crt_date = Trim(dw_ip.Object.jisi_date[1])
ls_crt_time = string(today(),'hhmm')
ls_crt_user = gs_userid 

if as_gubun = 'NR' then	
	ls_gubun = 'N:일일입고'
else
	ls_gubun = 'O:월마감'	
end if


ls_saupj = Trim(dw_ip.Object.saupj[1])

li_FileNum = FileOpen(is_path+arg_file_name,LineMode!,Read!)

if li_FileNum = -1 then
	wf_error(arg_file_name,li_cnt,'','','',"["+arg_file_name+"]"+" VAN자료가 없습니다.!!")
	FileClose(li_FileNum)
	return -1
end if

li_cnt = 0
st_state.Visible = True
st_state.Text = '데이타를 읽는 중입니다...'

Do While	FileRead(li_FileNum, ls_Input_Data) <> -100
	
	ls_mitnbr = ''
	ls_mcvcod = ''
	ls_mdcvcod = ''
	ls_citnbr = ''
	li_cnt ++
	ll_data ++
	
	yield()
	st_state.Text = "파일명: "+arg_file_name +"  라인수 :" +String(li_cnt)
	
	ls_MINC_BRNCD		= Trim(Mid(ls_Input_Data,1,3  ))        
	ls_MINC_IN_YM		= Trim(Mid(ls_Input_Data,4,6  ))        
	ls_MINC_IN_SEQ		= Trim(Mid(ls_Input_Data,10,6  ))       
	ls_MINC_INSP_NO	= Trim(Mid(ls_Input_Data,16,15  ))      
	ls_MINC_PTNO		= Trim(Mid(ls_Input_Data,31,18  ))      
	ls_MINC_VNDCD		= Trim(Mid(ls_Input_Data,49,4  ))       
	ls_MINC_SRC			= Trim(Mid(ls_Input_Data,53,1  ))       
	ls_MINC_LEP			= Trim(Mid(ls_Input_Data,54,1  ))       
	ls_MINC_VHC_KND	= Trim(Mid(ls_Input_Data,55,3  ))       
	ls_MINC_PTNM		= Trim(Mid(ls_Input_Data,58,20  ))      
	ls_MINC_CLASS		= Trim(Mid(ls_Input_Data,78,2  ))       
	ls_MINC_HK_ED		= Trim(Mid(ls_Input_Data,80,1  ))       
	ls_MINC_VAN_DATE	= Trim(Mid(ls_Input_Data,81,8  ))       
	ls_MINC_VAN_TIME	= Trim(Mid(ls_Input_Data,89,8  ))       
	ls_MINC_DEV_PER	= Trim(Mid(ls_Input_Data,97,2  ))       
	ls_MINC_VAREA		= Trim(Mid(ls_Input_Data,99,1  ))       
	ls_MINC_WHS_ORD	= Trim(Mid(ls_Input_Data,100,3  ))      
	ls_MINC_WHS_INC	= Trim(Mid(ls_Input_Data,103,3  ))      
	ls_MINC_ADV_BRN	= Trim(Mid(ls_Input_Data,106,3  ))      
	ls_MINC_ADV_AGN	= Trim(Mid(ls_Input_Data,109,4  ))      
	ll_MINC_CNCL_QTY	= Long(Trim(Mid(ls_Input_Data,113,7  )))
	ll_MINC_RAW_PRICE	= Long(Trim(Mid(ls_Input_Data,120,9  )))
	ll_MINC_CUS_PRICE	= Long(Trim(Mid(ls_Input_Data,129,9  )))
	/* 단가기호 적용 - 2007.02.09 - 송병호 */
	ls_orgprc = Trim(Mid(ls_Input_Data,138,9))
	ls_chgprc = f_replace_a(ls_orgprc, '}JKLMNOPQR', '0123456789')
	ll_MINC_INDLV_PRICE = Long(ls_chgprc)
	if ls_orgprc <> ls_chgprc then
		ll_MINC_INDLV_PRICE = ll_MINC_INDLV_PRICE * -1
	end if
	ls_MINC_INCOT_YES	= Trim(Mid(ls_Input_Data,147,1  ))      
	ls_MINC_INPAC_YES	= Trim(Mid(ls_Input_Data,148,1  ))      
	ll_MINC_INCUS_PRICE	= Long(Trim(Mid(ls_Input_Data,149,9  )))
	/* 수량기호 적용 - 2007.03.15 - 송병호 */
	ls_orgqty = Trim(Mid(ls_Input_Data,158,7))
	ls_chgqty = f_replace_a(ls_orgqty, '}JKLMNOPQR', '0123456789')
	ll_MINC_OKQTY = Long(ls_chgqty)
	if ls_orgqty <> ls_chgqty then
		ll_MINC_OKQTY = ll_MINC_OKQTY * -1
	end if
	ls_MINC_RINSP_NO	= Trim(Mid(ls_Input_Data,165,15  ))     
	ls_MINC_CERCD		= Trim(Mid(ls_Input_Data,180,1  ))      
	ll_MINC_CER_QTY	= Long(Trim(Mid(ls_Input_Data,181,7  )))
	ls_MINC_ACC_DATE	= Trim(Mid(ls_Input_Data,188,8  ))      
	ls_MINC_IN_DATE	= Trim(Mid(ls_Input_Data,196,8  ))      
	ls_MINC_DLV_DATE	= Trim(Mid(ls_Input_Data,204,8  ))      
	ls_MINC_PDT_DATE	= Trim(Mid(ls_Input_Data,212,8  ))      
	ls_MINC_ORDID		= Trim(Mid(ls_Input_Data,220,1  ))      
	ls_MINC_ORD_PRO	= Trim(Mid(ls_Input_Data,221,1  ))      
	ls_MINC_INID		= Trim(Mid(ls_Input_Data,222,1  ))      
	ls_MINC_ORD_INF	= Trim(Mid(ls_Input_Data,223,2  ))      
	ls_MINC_PRO_CESS1	= Trim(Mid(ls_Input_Data,225,1  ))      
	ls_MINC_PRO_CESS2	= Trim(Mid(ls_Input_Data,226,1  ))      
	ls_MINC_INC_INF	= Trim(Mid(ls_Input_Data,227,2  ))      
	ls_MINC_IWA_INF	= Trim(Mid(ls_Input_Data,229,2  ))      
	ls_MINC_BRNCD_WHS	= Trim(Mid(ls_Input_Data,231,3  ))      
	ls_MINC_BRNCD_RAW	= Trim(Mid(ls_Input_Data,234,3  ))      
	ls_MINC_CHG_PTNO	= Trim(Mid(ls_Input_Data,237,18  ))     
	ls_MINC_FIR_ORDNO	= Trim(Mid(ls_Input_Data,255,15  ))     
	ls_MINC_ORDNO		= Trim(Mid(ls_Input_Data,270,15  ))     
	ls_MINC_RAW_ORDNO	= Trim(Mid(ls_Input_Data,285,15  ))     
	ls_MINC_LC_ID		= Trim(Mid(ls_Input_Data,300,1  ))      
	ls_MINC_OINSP_NO	= Trim(Mid(ls_Input_Data,301,1  ))      
	ls_MINC_EMPNO		= Trim(Mid(ls_Input_Data,322,7  ))      
	ll_MINC_ORD_QTY	= Long(Trim(Mid(ls_Input_Data,329,7  )))
	ll_END_LINE			= Long(Trim(Mid(ls_Input_Data,336,1  )))

//
//공장별 거래처 읽어오기
//	select nvl(RFNA2,''),nvl(RFNA3,'')
//	into :ls_mcvcod,:ls_mdcvcod
//	from reffpf
//	where sabu = :arg_sabu and
//			rfcod = '1G' and
//			rfgub = :ls_factory;
//			
//	if sqlca.sqlcode <> 0 or &
//	   trim(ls_mcvcod)	= '' or trim(ls_mdcvcod) = '' or &
//		isNull(ls_mcvcod)	 or isNull(ls_mdcvcod) then
//		wf_error(arg_file_name,li_cnt,ls_doccode,ls_factory,ls_itnbr,'참조테이블에(REFFPF) 하치장(납품장소) 코드가 없습니다.')
//		
//		Continue ;
//	end if

//	자체품번 읽어오기(자체거래처코드)
/* VAN수신 자료 품번 중 끝에 '-AM'이 붙어 들어오는 품목이 있음
   아래 쿼리에서 REPLACE함수로 하이픈을 제거하게 되면 비교값이 'K993061000AM' = 'K993061000-AM' 이렇게 됨.
   품번은 등록 되었으나 하이픈 제거로 비교값 성립되지 않음. 양쪽다 하이픈 제거 후 비교 방식으로 변경 - BY SHINGOON 2007.06.01 */
	SELECT itnbr into :ls_mitnbr
   	 FROM (	SELECT itnbr,ROWNUM RN 
					  FROM itemas
					  WHERE REPLACE(itnbr,'-','') = REPLACE(:ls_MINC_PTNO, '-', ''))
  	WHERE RN = 1 ;	
	
	if sqlca.sqlcode <> 0 or Trim(ls_mitnbr) = '' or isNull(ls_mitnbr) then
		
		wf_error(arg_file_name,li_cnt,'','',ls_MINC_PTNO,'품번마스타에 품번이 등록되지 않았습니다.')

		il_err++
		continue ;
		
	End IF

	ls_mitnbr = trim(ls_mitnbr)
	ls_mcvcod = trim(ls_mcvcod)
	ls_mdcvcod = trim(ls_mdcvcod)
	ls_citnbr = trim(ls_citnbr)
	li_cnt2 = 0 

   SELECT COUNT(*) INTO :li_cnt2
	  FROM VAN_MOBIS_OR
	 WHERE MINC_BRNCD = :ls_MINC_BRNCD
	   AND MINC_IN_YM = :ls_MINC_IN_YM
		AND MINC_IN_SEQ = :ls_MINC_IN_SEQ ;

	if as_gubun = 'NR' then
		ll_DAY_MONTH = '1'
	else
		ll_DAY_MONTH = '2'
	end if	

	If li_cnt2 <= 0 Then

	INSERT INTO  VAN_MOBIS_OR( SAUPJ,   
										MINC_BRNCD,
										MINC_IN_YM,
										MINC_IN_SEQ,        
										MINC_INSP_NO,       
										MINC_PTNO,          
										MINC_VNDCD,         
										MINC_SRC,           
										MINC_LEP,           
										MINC_VHC_KND,       
										MINC_PTNM,          
										MINC_CLASS,         
										MINC_HK_ED,         
										MINC_VAN_DATE,      
										MINC_VAN_TIME,      
										MINC_DEV_PER,       
										MINC_VAREA,         
										MINC_WHS_ORD,       
										MINC_WHS_INC,       
										MINC_ADV_BRN,       
										MINC_ADV_AGN,       
										MINC_CNCL_QTY,      
										MINC_RAW_PRICE,     
										MINC_CUS_PRICE,     
										MINC_INDLV_PRICE,   
										MINC_INCOT_YES,     
										MINC_INPAC_YES,     
										MINC_INCUS_PRICE,   
										MINC_OKQTY,         
										MINC_RINSP_NO,      
										MINC_CERCD,         
										MINC_CER_QTY,       
										MINC_ACC_DATE,      
										MINC_IN_DATE,       
										MINC_DLV_DATE,      
										MINC_PDT_DATE,      
										MINC_ORDID,         
										MINC_ORD_PRO,       
										MINC_INID,          
										MINC_ORD_INF,       
										MINC_PRO_CESS1,     
										MINC_PRO_CESS2,     
										MINC_INC_INF,       
										MINC_IWA_INF,       
										MINC_BRNCD_WHS,     
										MINC_BRNCD_RAW,     
										MINC_CHG_PTNO,      
										MINC_FIR_ORDNO,     
										MINC_ORDNO,         
										MINC_RAW_ORDNO,     
										MINC_LC_ID,         
										MINC_OINSP_NO,      
										MINC_EMPNO,         
										MINC_ORD_QTY,       
										END_LINE,           
										DAY_MONTH,
										CRT_DATE,   
										CRT_TIME,   
										CRT_USER,   
										CITNBR,   
										MITNBR,   
										MCVCOD,   
										MDCVCOD  )
							VALUES ( :ls_saupj,
										:ls_MINC_BRNCD,
										:ls_MINC_IN_YM,
										:ls_MINC_IN_SEQ,        
										:ls_MINC_INSP_NO,       
										:ls_MINC_PTNO,          
										:ls_MINC_VNDCD,         
										:ls_MINC_SRC,           
										:ls_MINC_LEP,           
										:ls_MINC_VHC_KND,       
										:ls_MINC_PTNM,          
										:ls_MINC_CLASS,         
										:ls_MINC_HK_ED,         
										:ls_MINC_VAN_DATE,      
										:ls_MINC_VAN_TIME,      
										:ls_MINC_DEV_PER,       
										:ls_MINC_VAREA,         
										:ls_MINC_WHS_ORD,       
										:ls_MINC_WHS_INC,       
										:ls_MINC_ADV_BRN,       
										:ls_MINC_ADV_AGN,       
										:ll_MINC_CNCL_QTY,      
										:ll_MINC_RAW_PRICE,     
										:ll_MINC_CUS_PRICE,     
										:ll_MINC_INDLV_PRICE,   
										:ls_MINC_INCOT_YES,     
										:ls_MINC_INPAC_YES,     
										:ll_MINC_INCUS_PRICE,   
										:ll_MINC_OKQTY,         
										:ls_MINC_RINSP_NO,      
										:ls_MINC_CERCD,         
										:ll_MINC_CER_QTY,       
										:ls_MINC_ACC_DATE,      
										:ls_MINC_IN_DATE,       
										:ls_MINC_DLV_DATE,      
										:ls_MINC_PDT_DATE,      
										:ls_MINC_ORDID,         
										:ls_MINC_ORD_PRO,       
										:ls_MINC_INID,          
										:ls_MINC_ORD_INF,       
										:ls_MINC_PRO_CESS1,     
										:ls_MINC_PRO_CESS2,     
										:ls_MINC_INC_INF,       
										:ls_MINC_IWA_INF,       
										:ls_MINC_BRNCD_WHS,     
										:ls_MINC_BRNCD_RAW,     
										:ls_MINC_CHG_PTNO,      
										:ls_MINC_FIR_ORDNO,     
										:ls_MINC_ORDNO,         
										:ls_MINC_RAW_ORDNO,     
										:ls_MINC_LC_ID,         
										:ls_MINC_OINSP_NO,      
										:ls_MINC_EMPNO,         
										:ll_MINC_ORD_QTY,       
										:ll_END_LINE, 
										:ll_DAY_MONTH,
										:ls_CRT_DATE,  
										:ls_CRT_TIME,  
										:ls_CRT_USER,
										:ls_CITNBR,  
										:ls_MITNBR,  
										:ls_MCVCOD,  
										:ls_MDCVCOD		) ;
	Else
		
		UPDATE  VAN_MOBIS_OR SET SAUPJ 				=  	  :ls_saupj          	,       
										 MINC_INSP_NO	   =       :ls_MINC_INSP_NO		,
										 MINC_PTNO			=       :ls_MINC_PTNO			,
										 MINC_VNDCD			=       :ls_MINC_VNDCD			,
										 MINC_SRC			=       :ls_MINC_SRC				,
										 MINC_LEP			=       :ls_MINC_LEP				,
										 MINC_VHC_KND	   =       :ls_MINC_VHC_KND		,
										 MINC_PTNM			=       :ls_MINC_PTNM			,
										 MINC_CLASS			=       :ls_MINC_CLASS			,
										 MINC_HK_ED			=       :ls_MINC_HK_ED			,
										 MINC_VAN_DATE	   =       :ls_MINC_VAN_DATE		,
										 MINC_VAN_TIME	   =       :ls_MINC_VAN_TIME		,
										 MINC_DEV_PER	   =       :ls_MINC_DEV_PER		,
										 MINC_VAREA			=       :ls_MINC_VAREA			,
										 MINC_WHS_ORD	   =       :ls_MINC_WHS_ORD		,
										 MINC_WHS_INC	   =       :ls_MINC_WHS_INC		,
										 MINC_ADV_BRN	   =       :ls_MINC_ADV_BRN		,
										 MINC_ADV_AGN	   =       :ls_MINC_ADV_AGN		,
										 MINC_CNCL_QTY	   =       :ll_MINC_CNCL_QTY		,
										 MINC_RAW_PRICE	=       :ll_MINC_RAW_PRICE		,
										 MINC_CUS_PRICE	=       :ll_MINC_CUS_PRICE		,
										 MINC_INDLV_PRICE	=       :ll_MINC_INDLV_PRICE	,
										 MINC_INCOT_YES	=       :ls_MINC_INCOT_YES		,
										 MINC_INPAC_YES	=       :ls_MINC_INPAC_YES		,
										 MINC_INCUS_PRICE	=       :ll_MINC_INCUS_PRICE	,
										 MINC_OKQTY			=       :ll_MINC_OKQTY			,
										 MINC_RINSP_NO	   =       :ls_MINC_RINSP_NO		,
										 MINC_CERCD			=       :ls_MINC_CERCD			,
										 MINC_CER_QTY	   =       :ll_MINC_CER_QTY		,
										 MINC_ACC_DATE	   =       :ls_MINC_ACC_DATE		,
										 MINC_IN_DATE	   =       :ls_MINC_IN_DATE		,
										 MINC_DLV_DATE	   =       :ls_MINC_DLV_DATE		,
										 MINC_PDT_DATE	   =       :ls_MINC_PDT_DATE		,
										 MINC_ORDID			=       :ls_MINC_ORDID			,
										 MINC_ORD_PRO	   =       :ls_MINC_ORD_PRO		,
										 MINC_INID			=       :ls_MINC_INID			,
										 MINC_ORD_INF	   =       :ls_MINC_ORD_INF		,
										 MINC_PRO_CESS1	=       :ls_MINC_PRO_CESS1		,
										 MINC_PRO_CESS2	=       :ls_MINC_PRO_CESS2		,
										 MINC_INC_INF	   =       :ls_MINC_INC_INF		,
										 MINC_IWA_INF	   =       :ls_MINC_IWA_INF		,
										 MINC_BRNCD_WHS	=       :ls_MINC_BRNCD_WHS		,
										 MINC_BRNCD_RAW	=       :ls_MINC_BRNCD_RAW		,
										 MINC_CHG_PTNO	   =       :ls_MINC_CHG_PTNO		,
										 MINC_FIR_ORDNO	=       :ls_MINC_FIR_ORDNO		,
										 MINC_ORDNO			=       :ls_MINC_ORDNO			,
										 MINC_RAW_ORDNO	=       :ls_MINC_RAW_ORDNO		,
										 MINC_LC_ID			=       :ls_MINC_LC_ID			,
										 MINC_OINSP_NO	   =       :ls_MINC_OINSP_NO		,
										 MINC_EMPNO			=       :ls_MINC_EMPNO			,
										 MINC_ORD_QTY	   =       :ll_MINC_ORD_QTY		,
										 END_LINE			=       :ll_END_LINE				,
										 DAY_MONTH			=       :ll_DAY_MONTH			,
										 CRT_DATE			=       :ls_CRT_DATE				,
										 CRT_TIME			=       :ls_CRT_TIME				,
										 CRT_USER			=       :ls_CRT_USER				,
/*										 CITNBR		      =       :ls_CITNBR				,		*/		/* 일검수확정 자료 보존 - 2007.01.25 */
										 MITNBR		      =       :ls_MITNBR				,
										 MCVCOD		      =       :ls_MCVCOD				,
										 MDCVCOD		      =       :ls_MDCVCOD		
										 
										 WHERE MINC_BRNCD = :ls_MINC_BRNCD
										   AND MINC_IN_YM = :ls_MINC_IN_YM
											AND MINC_IN_SEQ = :ls_MINC_IN_SEQ ;										
	End If
	
	If sqlca.sqlcode <> 0 Then
		
		st_state.Visible = False
		wf_error(arg_file_name,li_cnt,'','',ls_mitnbr,"입력에러가 발생했습니다." +sqlca.sqlerrtext+'[열위치:'+string(li_cnt)+']')
		rollback;
		FileClose(li_FileNum)
		return -3
	Else
		il_succeed++
	End if
	
	
Loop


// van file close
FileClose(li_FileNum)

//van 파일명 변경

//li_FileNum = FileCopy(arg_file_name,left(arg_file_name,pos(trim(arg_file_name),".")) + "bak",TRUE)
//if li_FileNum <> 1 then
//	Rollback ;
//	st_state.Visible = False
//	wf_error(ls_gubun,0,'','','',"파일변경에 에러가 발생했습니다."  )
//	
//	return -4
//end if

//van 파일 삭제
//if not FileDelete(arg_file_name) then 
//	Rollback ;
//	st_state.Visible = False
//	messagebox('error','화일삭제 에러입니다.')
//	return -4
//end if

commit;

st_state.Visible = False
return ll_data

end function

public function integer wf_van_ir (string arg_file_name, string arg_sabu, string as_gubun);string   ls_Input_Data , ls_indate
integer  li_FileNum,li_cnt,li_rowcnt,li_cnt2
Long     ll_data = 0  , ll_r 

String	ls_SAUPJ        
String	ls_CMD_KND	
String	ls_YYMM		
String	ls_RONO		
Long		ll_SEQ		
Long		ll_MKUP		
String	ls_OPCD		
String	ls_RPPT		
Long		ll_QTY		
Long		ll_BRPM		
Long		ll_DMD_PRICE	
String	ls_INS_DATE	
String	ls_UPD_DATE	
String	ls_EX_KR	
Long		ll_END_LINE	
String 	ls_CRT_DATE       
String  	ls_CRT_TIME       
String  	ls_CRT_USER       
String  	ls_CITNBR         
String  	ls_MITNBR         
String  	ls_MCVCOD         
String  	ls_MDCVCOD
String  	ls_gubun
String  	ll_day_month

//현재 일자,시간 

ls_crt_date = Trim(dw_ip.Object.jisi_date[1])
ls_crt_time = string(today(),'hhmm')
ls_crt_user = gs_userid 

if as_gubun = 'IR' then	
	ls_gubun = 'I:내수크래임 DETAIL'
else
	ls_gubun = 'L:수출크래임 DETAIL'	
end if


ls_saupj = Trim(dw_ip.Object.saupj[1])

li_FileNum = FileOpen(is_path+arg_file_name,LineMode!,Read!)

if li_FileNum = -1 then
	wf_error(arg_file_name,li_cnt,'','','',"["+arg_file_name+"]"+" VAN자료가 없습니다.!!")
	FileClose(li_FileNum)
	return -1
end if

li_cnt = 0
st_state.Visible = True
st_state.Text = '데이타를 읽는 중입니다...'

Do While	FileRead(li_FileNum, ls_Input_Data) <> -100
	
	ls_mitnbr = ''
	ls_mcvcod = ''
	ls_mdcvcod = ''
	ls_citnbr = ''
	li_cnt ++
	ll_data ++
	
	yield()
	st_state.Text = "파일명: "+arg_file_name +"  라인수 :" +String(li_cnt)
	
	ls_CMD_KND		= Trim(Mid(ls_Input_Data,1,1  ))        
	ls_YYMM			= Trim(Mid(ls_Input_Data,2,6  ))        
	ls_RONO			= Trim(Mid(ls_Input_Data,8,19  ))        
	ll_SEQ			= Long(Trim(Mid(ls_Input_Data,27,5  )))        
if as_gubun = 'IR' then	
	ll_MKUP			= 0
	ls_OPCD			= ''
	ls_RPPT			= Trim(Mid(ls_Input_Data,32,18  ))        
	ll_QTY			= Long(Trim(Mid(ls_Input_Data,50,3  )))        
	ll_BRPM			= Long(Trim(Mid(ls_Input_Data,53,9  )))        
	ll_DMD_PRICE	= Long(Trim(Mid(ls_Input_Data,62,9  )))        
	ls_INS_DATE		= Trim(Mid(ls_Input_Data,71,8  ))        
	ls_UPD_DATE		= Trim(Mid(ls_Input_Data,79,8  ))        
	ll_END_LINE		= Long(Trim(Mid(ls_Input_Data,87,1)))
else
	ll_MKUP			= Truncate(Double(Trim(Mid(ls_Input_Data,30,5)))*0.01  ,2)           	
	ls_OPCD			= Trim(Mid(ls_Input_Data,35,9  ))        
	ls_RPPT			= Trim(Mid(ls_Input_Data,44,18  ))        
	ll_QTY			= Long(Trim(Mid(ls_Input_Data,62,3  )))        
	ll_BRPM			= Long(Trim(Mid(ls_Input_Data,65,9  )))        
	ll_DMD_PRICE	= Long(Trim(Mid(ls_Input_Data,74,9  )))        
	ls_INS_DATE		= Trim(Mid(ls_Input_Data,83,8  ))        
	ls_UPD_DATE		= Trim(Mid(ls_Input_Data,91,8  ))        
	ll_END_LINE		= Long(Trim(Mid(ls_Input_Data,99,1)))
end if	

//
//공장별 거래처 읽어오기
//	select nvl(RFNA2,''),nvl(RFNA3,'')
//	into :ls_mcvcod,:ls_mdcvcod
//	from reffpf
//	where sabu = :arg_sabu and
//			rfcod = '1G' and
//			rfgub = :ls_factory;
//			
//	if sqlca.sqlcode <> 0 or &
//	   trim(ls_mcvcod)	= '' or trim(ls_mdcvcod) = '' or &
//		isNull(ls_mcvcod)	 or isNull(ls_mdcvcod) then
//		wf_error(arg_file_name,li_cnt,ls_doccode,ls_factory,ls_itnbr,'참조테이블에(REFFPF) 하치장(납품장소) 코드가 없습니다.')
//		
//		Continue ;
//	end if
	
//	크레임 Head에 RONO(보상번호) 있는거만 입력 되도록 함
	select rono
	  into :ls_rono
	  from van_mobis_hr
	 where rono = :ls_rono;
	
	if sqlca.sqlcode <> 0 or Trim(ls_rono) = '' or isNull(ls_rono) then
		
		wf_error(arg_file_name,li_cnt,'','',ls_rono,'Claim Head에 보상번호가 등록되지 않았습니다.')

		il_err++
		continue ;
		
	End IF

	ls_mitnbr = trim(ls_RPPT)
	ls_mcvcod = trim(ls_mcvcod)
	ls_mdcvcod = trim(ls_mdcvcod)
	ls_citnbr = trim(ls_citnbr)
	li_cnt2 = 0 

   SELECT COUNT(*) INTO :li_cnt2
	  FROM VAN_MOBIS_IR
	 WHERE CMD_KND = :ls_CMD_KND
	   AND YYMM   = :ls_YYMM
		AND RONO   = :ls_RONO
		AND SEQ    = :ll_SEQ ;		

	if as_gubun = 'IR' then
		ls_EX_KR = '내수'
	else
		ls_EX_KR = '수출'
	end if	
		
	If li_cnt2 <= 0 Then

	INSERT INTO  VAN_MOBIS_IR( SAUPJ, 
										CMD_KND	,
										YYMM		,
										RONO		,
										SEQ		,
										MKUP		,
										OPCD		,
										RPPT		,
										QTY		,
										BRPM		,
										DMD_PRICE,
										INS_DATE	,
										UPD_DATE	,
										EX_KR		,
										END_LINE	,
										CRT_DATE	,   
										CRT_TIME	,   
										CRT_USER	,   
										CITNBR	,   
										MITNBR	,   
										MCVCOD	,   
										MDCVCOD  )
							VALUES ( :ls_saupj		,
										:ls_CMD_KND		,
										:ls_YYMM			,
										:ls_RONO			,
										:ll_SEQ			,
										:ll_MKUP	   	,
										:ls_OPCD	   	,
										:ls_RPPT			,
										:ll_QTY			,
										:ll_BRPM			,
										:ll_DMD_PRICE	,
										:ls_INS_DATE	,
										:ls_UPD_DATE	,
										:ls_EX_KR		,
										:ll_END_LINE	, 
										:ls_CRT_DATE	,  
										:ls_CRT_TIME	,  
										:ls_CRT_USER	,
										:ls_CITNBR		,  
										:ls_MITNBR		,  
										:ls_MCVCOD		,  
										:ls_MDCVCOD		) ;

		Else
		
		UPDATE VAN_MOBIS_IR SET SAUPJ 		=       :ls_saupj    ,       
										CMD_KND		=		  :ls_CMD_KND	,	
										YYMM			=       :ls_YYMM		,
										RONO			=       :ls_RONO		,
										SEQ			=       :ll_SEQ		,
										MKUP			=       :ll_MKUP		,
										OPCD			=       :ls_OPCD		,
										RPPT			=       :ls_RPPT		,
										QTY			=       :ll_QTY		,
										BRPM			=       :ll_BRPM		,
										DMD_PRICE   =       :ll_DMD_PRICE,
										INS_DATE		=       :ls_INS_DATE	,
										UPD_DATE		=       :ls_UPD_DATE	,
										EX_KR			=       :ls_EX_KR		,
										END_LINE		=       :ll_END_LINE	,
										CRT_DATE		=       :ls_CRT_DATE	,
										CRT_TIME		=       :ls_CRT_TIME	,
										CRT_USER		=       :ls_CRT_USER	,
										CITNBR	   =       :ls_CITNBR	,
										MITNBR	   =       :ls_MITNBR	,
										MCVCOD	   =       :ls_MCVCOD	,
										MDCVCOD     =       :ls_MDCVCOD											
							 WHERE CMD_KND   = :ls_CMD_KND
								   AND YYMM   = :ls_YYMM
									AND RONO   = :ls_RONO
									AND SEQ    = :ll_SEQ ;											
	END IF

	If sqlca.sqlcode <> 0 Then
		
		st_state.Visible = False
		wf_error(arg_file_name,li_cnt,'','',ls_mitnbr,"입력에러가 발생했습니다." +sqlca.sqlerrtext+'[열위치:'+string(li_cnt)+']')
		rollback;
		FileClose(li_FileNum)
		return -3
	Else
		il_succeed++
	End if
	

Loop


// van file close
FileClose(li_FileNum)

//van 파일명 변경

//li_FileNum = FileCopy(arg_file_name,left(arg_file_name,pos(trim(arg_file_name),".")) + "bak",TRUE)
//if li_FileNum <> 1 then
//	Rollback ;
//	st_state.Visible = False
//	wf_error(ls_gubun,0,'','','',"파일변경에 에러가 발생했습니다."  )
//	
//	return -4
//end if

//van 파일 삭제
//if not FileDelete(arg_file_name) then 
//	Rollback ;
//	st_state.Visible = False
//	messagebox('error','화일삭제 에러입니다.')
//	return -4
//end if

commit;

st_state.Visible = False
return ll_data

end function

public subroutine wf_process (string process_gb, string process_fname);Long ll_cnt

il_err = 0 
il_succeed = 0 
ll_cnt=0

Choose Case process_gb
	Case "AR"
//		messagebox('AR','AR')
		ll_cnt = wf_van_ar(process_fname,gs_sabu)
		If ll_cnt > 0 Then
			wf_error(process_fname,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하였습니다.')
		End if

		w_mdi_frame.sle_msg.text ='총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하였습니다.'
	Case "BR"
//		messagebox('BR','BR')		
		//ll_cnt = wf_van_br(process_fname,gs_sabu)
		/* SPIN모비스에서 받은 정보를 UPLOAD - BY SHINGOON 2013.07.04 */
		/* 기존 작업은 현진정보에서 제공되는 TXT파일을 UPLOAD */
		ll_cnt = wf_van_br_new(process_fname, gs_sabu)
		If ll_cnt > 0 Then
			wf_error(process_fname,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하였습니다.')
		End if
		
		w_mdi_frame.sle_msg.text ='총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하였습니다.'
	Case "ER"
//		messagebox('ER','ER')		
		ll_cnt = wf_van_er(process_fname,gs_sabu)
		If ll_cnt > 0 Then
			wf_error(process_fname,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하였습니다.')
		End if
		
		w_mdi_frame.sle_msg.text ='총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하였습니다.'
	Case "FR"
//		messagebox('FR','FR')		
		ll_cnt = wf_van_fr(process_fname,gs_sabu)
		If ll_cnt > 0 Then
			wf_error(process_fname,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하였습니다.')
		End if
		
		w_mdi_frame.sle_msg.text ='총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하였습니다.'
	Case "NR" 
//		messagebox('NR','NR')		
		ll_cnt = wf_van_nr(process_fname,gs_sabu,process_gb)
		/* SPIN모비스에서 받은 정보를 UPLOAD - BY SHINGOON 2013.09.13 */
		/* 기존 작업은 현진정보에서 제공되는 TXT파일을 UPLOAD (일일입고와 월검수는 같은자료를 업로드) */
//		ll_cnt = wf_van_nr_new(process_fname, gs_sabu) --보류
		If ll_cnt > 0 Then
			wf_error(process_fname,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하였습니다.')
		End if
		
		w_mdi_frame.sle_msg.text ='총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하였습니다.'
	Case "OR" 
//		messagebox('OR','OR')		
		ll_cnt = wf_van_nr(process_fname,gs_sabu,process_gb)
		/* SPIN모비스에서 받은 정보를 UPLOAD - BY SHINGOON 2013.09.13 */
		/* 기존 작업은 현진정보에서 제공되는 TXT파일을 UPLOAD (일일입고와 월검수는 같은자료를 업로드) */
//		ll_cnt = wf_van_nr_new(process_fname, gs_sabu) --보류
		If ll_cnt > 0 Then
			wf_error(process_fname,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하였습니다.')
		End if
		
		w_mdi_frame.sle_msg.text ='총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하였습니다.'
	Case "HR" 
//		messagebox('HR','HR')		
		ll_cnt = wf_van_hr(process_fname,gs_sabu,process_gb)
		If ll_cnt > 0 Then
			wf_error(process_fname,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하였습니다.')
		End if
		
		w_mdi_frame.sle_msg.text ='총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하였습니다.'

End Choose
end subroutine

public function long wf_itnbr_insert (string ar_itnbr, string ar_itdsc);INSERT INTO ITEMAS
	(	 SABU,   
         ITNBR,   
         ITDSC,   
         ISPEC,   
         JIJIL,   
         ITTYP,   
         ITCLS,   
         LOTGUB,   
         GBWAN,   
         GBDATE,   
         GBGUB,   
         USEYN,   
         PUMSR,   
         CNVFAT,   
         UNMSR,   
         WAGHT,   
         FILSK,   
         ITGU,   
         WONPRC,   
         WONSRC,   
         MLICD,   
         LDTIM,   
         LDTIM2,   
         MINSAF,   
         MIDSAF,   
         MAXSAF,   
         SHRAT,   
         MINQT,   
         MULQT,   
         MAXQT,   
         AUTO,   
         BASEQTY,   
         PACKQTY,   
         AUTOHOLD,   
         LOT,   
         BALRATE,   
         RMARK2	)  
   VALUES ( '1',   
         :AR_ITNBR ,   
         :AR_ITDSC ,   
         NULL,   
         NULL,   
         '1',   
         '9999',   
         'N',   
         'Y',   
         '20060904',   
         '1',   
         '0',   
         'EA',   
         1,   
         'EA',   
         0,   
         'Y',   
         '5',   
         0,    
         0, 
         '1',   
         0,   
         0,   
         0,   
         0,   
         0,   
         0,   
         0,   
         0,   
         0,   
         'N',   
         0,   
         0,   
         'N',   
         'N',   
         0,   
         NULL ) ;
			
If sqlca.sqlcode <> 0 Then
	rollback;
	return -1
end iF

commit;

return 1
end function

public function integer wf_van_nr_new (string arg_file_name, string arg_sabu, string as_gubun);string   ls_Input_Data , ls_indate
integer  li_FileNum,li_cnt,li_rowcnt, li_cnt2
Long     ll_data = 0  , ll_r 

String  	ls_SAUPJ   
String	ls_MINC_BRNCD		
String	ls_MINC_IN_YM		
String	ls_MINC_IN_SEQ		
String	ls_MINC_INSP_NO		
String	ls_MINC_PTNO		
String	ls_MINC_VNDCD		
String	ls_MINC_SRC		
String	ls_MINC_LEP		
String	ls_MINC_VHC_KND		
String	ls_MINC_PTNM		
String	ls_MINC_CLASS		
String	ls_MINC_HK_ED		
String	ls_MINC_VAN_DATE	
String	ls_MINC_VAN_TIME	
String	ls_MINC_DEV_PER		
String	ls_MINC_VAREA		
String	ls_MINC_WHS_ORD		
String	ls_MINC_WHS_INC		
String	ls_MINC_ADV_BRN		
String	ls_MINC_ADV_AGN		
Long		ll_MINC_CNCL_QTY	
Long		ll_MINC_RAW_PRICE	
Long		ll_MINC_CUS_PRICE	
String	ls_orgprc	/* 단가기호 적용 - 2007.02.09 - 송병호 */
String	ls_chgprc	/* 단가기호 적용 - 2007.02.09 - 송병호 */
String	ls_orgqty	/* 수량기호 적용 - 2007.03.15 - 송병호 */
String	ls_chgqty	/* 수량기호 적용 - 2007.03.15 - 송병호 */
Long		ll_MINC_INDLV_PRICE	
String	ls_MINC_INCOT_YES	
String	ls_MINC_INPAC_YES	
Long		ll_MINC_INCUS_PRICE	
Long		ll_MINC_OKQTY		
String	ls_MINC_RINSP_NO	
String	ls_MINC_CERCD		
Long		ll_MINC_CER_QTY		
String	ls_MINC_ACC_DATE	
String	ls_MINC_IN_DATE		
String	ls_MINC_DLV_DATE	
String	ls_MINC_PDT_DATE	
String	ls_MINC_ORDID		
String	ls_MINC_ORD_PRO		
String	ls_MINC_INID		
String	ls_MINC_ORD_INF		
String	ls_MINC_PRO_CESS1	
String	ls_MINC_PRO_CESS2	
String	ls_MINC_INC_INF		
String	ls_MINC_IWA_INF		
String	ls_MINC_BRNCD_WHS	
String	ls_MINC_BRNCD_RAW	
String	ls_MINC_CHG_PTNO	
String	ls_MINC_FIR_ORDNO	
String	ls_MINC_ORDNO		
String	ls_MINC_RAW_ORDNO	
String	ls_MINC_LC_ID		
String	ls_MINC_OINSP_NO	
String	ls_MINC_EMPNO		
Long		ll_MINC_ORD_QTY		
Long		ll_END_LINE		
String 	ls_CRT_DATE       
String  	ls_CRT_TIME       
String  	ls_CRT_USER       
String  	ls_CITNBR         
String  	ls_MITNBR         
String  	ls_MCVCOD         
String  	ls_MDCVCOD
String  	ls_gubun
String  	ll_day_month

//현재 일자,시간 

ls_crt_date = Trim(dw_ip.Object.jisi_date[1])
ls_crt_time = string(today(),'hhmm')
ls_crt_user = gs_userid 

if as_gubun = 'NR' then	
	ls_gubun = 'N:일일입고'
else
	ls_gubun = 'O:월마감'	
end if


ls_saupj = Trim(dw_ip.Object.saupj[1])

li_FileNum = FileOpen(is_path+arg_file_name,LineMode!,Read!)

if li_FileNum = -1 then
	wf_error(arg_file_name,li_cnt,'','','',"["+arg_file_name+"]"+" VAN자료가 없습니다.!!")
	FileClose(li_FileNum)
	return -1
end if

li_cnt = 0
st_state.Visible = True
st_state.Text = '데이타를 읽는 중입니다...'

Do While	FileRead(li_FileNum, ls_Input_Data) <> -100
	
	ls_mitnbr = ''
	ls_mcvcod = ''
	ls_mdcvcod = ''
	ls_citnbr = ''
	li_cnt ++
	ll_data ++
	
	yield()
	st_state.Text = "파일명: "+arg_file_name +"  라인수 :" +String(li_cnt)
	
	ls_MINC_BRNCD		= Trim(Mid(ls_Input_Data,1,3  ))        
	ls_MINC_IN_YM		= Trim(Mid(ls_Input_Data,4,6  ))        
	ls_MINC_IN_SEQ		= Trim(Mid(ls_Input_Data,10,6  ))       
	ls_MINC_INSP_NO	= Trim(Mid(ls_Input_Data,16,15  ))      
	ls_MINC_PTNO		= Trim(Mid(ls_Input_Data,31,18  ))      
	ls_MINC_VNDCD		= Trim(Mid(ls_Input_Data,49,4  ))       
	ls_MINC_SRC			= Trim(Mid(ls_Input_Data,53,1  ))       
	ls_MINC_LEP			= Trim(Mid(ls_Input_Data,54,1  ))       
	ls_MINC_VHC_KND	= Trim(Mid(ls_Input_Data,55,3  ))       
	ls_MINC_PTNM		= Trim(Mid(ls_Input_Data,58,20  ))      
	ls_MINC_CLASS		= Trim(Mid(ls_Input_Data,78,2  ))       
	ls_MINC_HK_ED		= Trim(Mid(ls_Input_Data,80,1  ))       
	ls_MINC_VAN_DATE	= Trim(Mid(ls_Input_Data,81,8  ))       
	ls_MINC_VAN_TIME	= Trim(Mid(ls_Input_Data,89,8  ))       
	ls_MINC_DEV_PER	= Trim(Mid(ls_Input_Data,97,2  ))       
	ls_MINC_VAREA		= Trim(Mid(ls_Input_Data,99,1  ))       
	ls_MINC_WHS_ORD	= Trim(Mid(ls_Input_Data,100,3  ))      
	ls_MINC_WHS_INC	= Trim(Mid(ls_Input_Data,103,3  ))      
	ls_MINC_ADV_BRN	= Trim(Mid(ls_Input_Data,106,3  ))      
	ls_MINC_ADV_AGN	= Trim(Mid(ls_Input_Data,109,4  ))      
	ll_MINC_CNCL_QTY	= Long(Trim(Mid(ls_Input_Data,113,7  )))
	ll_MINC_RAW_PRICE	= Long(Trim(Mid(ls_Input_Data,120,9  )))
	ll_MINC_CUS_PRICE	= Long(Trim(Mid(ls_Input_Data,129,9  )))
	/* 단가기호 적용 - 2007.02.09 - 송병호 */
	ls_orgprc = Trim(Mid(ls_Input_Data,138,9))
	ls_chgprc = f_replace_a(ls_orgprc, '}JKLMNOPQR', '0123456789')
	ll_MINC_INDLV_PRICE = Long(ls_chgprc)
	if ls_orgprc <> ls_chgprc then
		ll_MINC_INDLV_PRICE = ll_MINC_INDLV_PRICE * -1
	end if
	ls_MINC_INCOT_YES	= Trim(Mid(ls_Input_Data,147,1  ))      
	ls_MINC_INPAC_YES	= Trim(Mid(ls_Input_Data,148,1  ))      
	ll_MINC_INCUS_PRICE	= Long(Trim(Mid(ls_Input_Data,149,9  )))
	/* 수량기호 적용 - 2007.03.15 - 송병호 */
	ls_orgqty = Trim(Mid(ls_Input_Data,158,7))
	ls_chgqty = f_replace_a(ls_orgqty, '}JKLMNOPQR', '0123456789')
	ll_MINC_OKQTY = Long(ls_chgqty)
	if ls_orgqty <> ls_chgqty then
		ll_MINC_OKQTY = ll_MINC_OKQTY * -1
	end if
	ls_MINC_RINSP_NO	= Trim(Mid(ls_Input_Data,165,15  ))     
	ls_MINC_CERCD		= Trim(Mid(ls_Input_Data,180,1  ))      
	ll_MINC_CER_QTY	= Long(Trim(Mid(ls_Input_Data,181,7  )))
	ls_MINC_ACC_DATE	= Trim(Mid(ls_Input_Data,188,8  ))      
	ls_MINC_IN_DATE	= Trim(Mid(ls_Input_Data,196,8  ))      
	ls_MINC_DLV_DATE	= Trim(Mid(ls_Input_Data,204,8  ))      
	ls_MINC_PDT_DATE	= Trim(Mid(ls_Input_Data,212,8  ))      
	ls_MINC_ORDID		= Trim(Mid(ls_Input_Data,220,1  ))      
	ls_MINC_ORD_PRO	= Trim(Mid(ls_Input_Data,221,1  ))      
	ls_MINC_INID		= Trim(Mid(ls_Input_Data,222,1  ))      
	ls_MINC_ORD_INF	= Trim(Mid(ls_Input_Data,223,2  ))      
	ls_MINC_PRO_CESS1	= Trim(Mid(ls_Input_Data,225,1  ))      
	ls_MINC_PRO_CESS2	= Trim(Mid(ls_Input_Data,226,1  ))      
	ls_MINC_INC_INF	= Trim(Mid(ls_Input_Data,227,2  ))      
	ls_MINC_IWA_INF	= Trim(Mid(ls_Input_Data,229,2  ))      
	ls_MINC_BRNCD_WHS	= Trim(Mid(ls_Input_Data,231,3  ))      
	ls_MINC_BRNCD_RAW	= Trim(Mid(ls_Input_Data,234,3  ))      
	ls_MINC_CHG_PTNO	= Trim(Mid(ls_Input_Data,237,18  ))     
	ls_MINC_FIR_ORDNO	= Trim(Mid(ls_Input_Data,255,15  ))     
	ls_MINC_ORDNO		= Trim(Mid(ls_Input_Data,270,15  ))     
	ls_MINC_RAW_ORDNO	= Trim(Mid(ls_Input_Data,285,15  ))     
	ls_MINC_LC_ID		= Trim(Mid(ls_Input_Data,300,1  ))      
	ls_MINC_OINSP_NO	= Trim(Mid(ls_Input_Data,301,1  ))      
	ls_MINC_EMPNO		= Trim(Mid(ls_Input_Data,322,7  ))      
	ll_MINC_ORD_QTY	= Long(Trim(Mid(ls_Input_Data,329,7  )))
	ll_END_LINE			= Long(Trim(Mid(ls_Input_Data,336,1  )))

//
//공장별 거래처 읽어오기
//	select nvl(RFNA2,''),nvl(RFNA3,'')
//	into :ls_mcvcod,:ls_mdcvcod
//	from reffpf
//	where sabu = :arg_sabu and
//			rfcod = '1G' and
//			rfgub = :ls_factory;
//			
//	if sqlca.sqlcode <> 0 or &
//	   trim(ls_mcvcod)	= '' or trim(ls_mdcvcod) = '' or &
//		isNull(ls_mcvcod)	 or isNull(ls_mdcvcod) then
//		wf_error(arg_file_name,li_cnt,ls_doccode,ls_factory,ls_itnbr,'참조테이블에(REFFPF) 하치장(납품장소) 코드가 없습니다.')
//		
//		Continue ;
//	end if

//	자체품번 읽어오기(자체거래처코드)
/* VAN수신 자료 품번 중 끝에 '-AM'이 붙어 들어오는 품목이 있음
   아래 쿼리에서 REPLACE함수로 하이픈을 제거하게 되면 비교값이 'K993061000AM' = 'K993061000-AM' 이렇게 됨.
   품번은 등록 되었으나 하이픈 제거로 비교값 성립되지 않음. 양쪽다 하이픈 제거 후 비교 방식으로 변경 - BY SHINGOON 2007.06.01 */
	SELECT itnbr into :ls_mitnbr
   	 FROM (	SELECT itnbr,ROWNUM RN 
					  FROM itemas
					  WHERE REPLACE(itnbr,'-','') = REPLACE(:ls_MINC_PTNO, '-', ''))
  	WHERE RN = 1 ;	
	
	if sqlca.sqlcode <> 0 or Trim(ls_mitnbr) = '' or isNull(ls_mitnbr) then
		
		wf_error(arg_file_name,li_cnt,'','',ls_MINC_PTNO,'품번마스타에 품번이 등록되지 않았습니다.')

		il_err++
		continue ;
		
	End IF

	ls_mitnbr = trim(ls_mitnbr)
	ls_mcvcod = trim(ls_mcvcod)
	ls_mdcvcod = trim(ls_mdcvcod)
	ls_citnbr = trim(ls_citnbr)
	li_cnt2 = 0 

   SELECT COUNT(*) INTO :li_cnt2
	  FROM VAN_MOBIS_OR
	 WHERE MINC_BRNCD = :ls_MINC_BRNCD
	   AND MINC_IN_YM = :ls_MINC_IN_YM
		AND MINC_IN_SEQ = :ls_MINC_IN_SEQ ;

	if as_gubun = 'NR' then
		ll_DAY_MONTH = '1'
	else
		ll_DAY_MONTH = '2'
	end if	

	If li_cnt2 <= 0 Then

	INSERT INTO  VAN_MOBIS_OR( SAUPJ,   
										MINC_BRNCD,
										MINC_IN_YM,
										MINC_IN_SEQ,        
										MINC_INSP_NO,       
										MINC_PTNO,          
										MINC_VNDCD,         
										MINC_SRC,           
										MINC_LEP,           
										MINC_VHC_KND,       
										MINC_PTNM,          
										MINC_CLASS,         
										MINC_HK_ED,         
										MINC_VAN_DATE,      
										MINC_VAN_TIME,      
										MINC_DEV_PER,       
										MINC_VAREA,         
										MINC_WHS_ORD,       
										MINC_WHS_INC,       
										MINC_ADV_BRN,       
										MINC_ADV_AGN,       
										MINC_CNCL_QTY,      
										MINC_RAW_PRICE,     
										MINC_CUS_PRICE,     
										MINC_INDLV_PRICE,   
										MINC_INCOT_YES,     
										MINC_INPAC_YES,     
										MINC_INCUS_PRICE,   
										MINC_OKQTY,         
										MINC_RINSP_NO,      
										MINC_CERCD,         
										MINC_CER_QTY,       
										MINC_ACC_DATE,      
										MINC_IN_DATE,       
										MINC_DLV_DATE,      
										MINC_PDT_DATE,      
										MINC_ORDID,         
										MINC_ORD_PRO,       
										MINC_INID,          
										MINC_ORD_INF,       
										MINC_PRO_CESS1,     
										MINC_PRO_CESS2,     
										MINC_INC_INF,       
										MINC_IWA_INF,       
										MINC_BRNCD_WHS,     
										MINC_BRNCD_RAW,     
										MINC_CHG_PTNO,      
										MINC_FIR_ORDNO,     
										MINC_ORDNO,         
										MINC_RAW_ORDNO,     
										MINC_LC_ID,         
										MINC_OINSP_NO,      
										MINC_EMPNO,         
										MINC_ORD_QTY,       
										END_LINE,           
										DAY_MONTH,
										CRT_DATE,   
										CRT_TIME,   
										CRT_USER,   
										CITNBR,   
										MITNBR,   
										MCVCOD,   
										MDCVCOD  )
							VALUES ( :ls_saupj,
										:ls_MINC_BRNCD,
										:ls_MINC_IN_YM,
										:ls_MINC_IN_SEQ,        
										:ls_MINC_INSP_NO,       
										:ls_MINC_PTNO,          
										:ls_MINC_VNDCD,         
										:ls_MINC_SRC,           
										:ls_MINC_LEP,           
										:ls_MINC_VHC_KND,       
										:ls_MINC_PTNM,          
										:ls_MINC_CLASS,         
										:ls_MINC_HK_ED,         
										:ls_MINC_VAN_DATE,      
										:ls_MINC_VAN_TIME,      
										:ls_MINC_DEV_PER,       
										:ls_MINC_VAREA,         
										:ls_MINC_WHS_ORD,       
										:ls_MINC_WHS_INC,       
										:ls_MINC_ADV_BRN,       
										:ls_MINC_ADV_AGN,       
										:ll_MINC_CNCL_QTY,      
										:ll_MINC_RAW_PRICE,     
										:ll_MINC_CUS_PRICE,     
										:ll_MINC_INDLV_PRICE,   
										:ls_MINC_INCOT_YES,     
										:ls_MINC_INPAC_YES,     
										:ll_MINC_INCUS_PRICE,   
										:ll_MINC_OKQTY,         
										:ls_MINC_RINSP_NO,      
										:ls_MINC_CERCD,         
										:ll_MINC_CER_QTY,       
										:ls_MINC_ACC_DATE,      
										:ls_MINC_IN_DATE,       
										:ls_MINC_DLV_DATE,      
										:ls_MINC_PDT_DATE,      
										:ls_MINC_ORDID,         
										:ls_MINC_ORD_PRO,       
										:ls_MINC_INID,          
										:ls_MINC_ORD_INF,       
										:ls_MINC_PRO_CESS1,     
										:ls_MINC_PRO_CESS2,     
										:ls_MINC_INC_INF,       
										:ls_MINC_IWA_INF,       
										:ls_MINC_BRNCD_WHS,     
										:ls_MINC_BRNCD_RAW,     
										:ls_MINC_CHG_PTNO,      
										:ls_MINC_FIR_ORDNO,     
										:ls_MINC_ORDNO,         
										:ls_MINC_RAW_ORDNO,     
										:ls_MINC_LC_ID,         
										:ls_MINC_OINSP_NO,      
										:ls_MINC_EMPNO,         
										:ll_MINC_ORD_QTY,       
										:ll_END_LINE, 
										:ll_DAY_MONTH,
										:ls_CRT_DATE,  
										:ls_CRT_TIME,  
										:ls_CRT_USER,
										:ls_CITNBR,  
										:ls_MITNBR,  
										:ls_MCVCOD,  
										:ls_MDCVCOD		) ;
	Else
		
		UPDATE  VAN_MOBIS_OR SET SAUPJ 				=  	  :ls_saupj          	,       
										 MINC_INSP_NO	   =       :ls_MINC_INSP_NO		,
										 MINC_PTNO			=       :ls_MINC_PTNO			,
										 MINC_VNDCD			=       :ls_MINC_VNDCD			,
										 MINC_SRC			=       :ls_MINC_SRC				,
										 MINC_LEP			=       :ls_MINC_LEP				,
										 MINC_VHC_KND	   =       :ls_MINC_VHC_KND		,
										 MINC_PTNM			=       :ls_MINC_PTNM			,
										 MINC_CLASS			=       :ls_MINC_CLASS			,
										 MINC_HK_ED			=       :ls_MINC_HK_ED			,
										 MINC_VAN_DATE	   =       :ls_MINC_VAN_DATE		,
										 MINC_VAN_TIME	   =       :ls_MINC_VAN_TIME		,
										 MINC_DEV_PER	   =       :ls_MINC_DEV_PER		,
										 MINC_VAREA			=       :ls_MINC_VAREA			,
										 MINC_WHS_ORD	   =       :ls_MINC_WHS_ORD		,
										 MINC_WHS_INC	   =       :ls_MINC_WHS_INC		,
										 MINC_ADV_BRN	   =       :ls_MINC_ADV_BRN		,
										 MINC_ADV_AGN	   =       :ls_MINC_ADV_AGN		,
										 MINC_CNCL_QTY	   =       :ll_MINC_CNCL_QTY		,
										 MINC_RAW_PRICE	=       :ll_MINC_RAW_PRICE		,
										 MINC_CUS_PRICE	=       :ll_MINC_CUS_PRICE		,
										 MINC_INDLV_PRICE	=       :ll_MINC_INDLV_PRICE	,
										 MINC_INCOT_YES	=       :ls_MINC_INCOT_YES		,
										 MINC_INPAC_YES	=       :ls_MINC_INPAC_YES		,
										 MINC_INCUS_PRICE	=       :ll_MINC_INCUS_PRICE	,
										 MINC_OKQTY			=       :ll_MINC_OKQTY			,
										 MINC_RINSP_NO	   =       :ls_MINC_RINSP_NO		,
										 MINC_CERCD			=       :ls_MINC_CERCD			,
										 MINC_CER_QTY	   =       :ll_MINC_CER_QTY		,
										 MINC_ACC_DATE	   =       :ls_MINC_ACC_DATE		,
										 MINC_IN_DATE	   =       :ls_MINC_IN_DATE		,
										 MINC_DLV_DATE	   =       :ls_MINC_DLV_DATE		,
										 MINC_PDT_DATE	   =       :ls_MINC_PDT_DATE		,
										 MINC_ORDID			=       :ls_MINC_ORDID			,
										 MINC_ORD_PRO	   =       :ls_MINC_ORD_PRO		,
										 MINC_INID			=       :ls_MINC_INID			,
										 MINC_ORD_INF	   =       :ls_MINC_ORD_INF		,
										 MINC_PRO_CESS1	=       :ls_MINC_PRO_CESS1		,
										 MINC_PRO_CESS2	=       :ls_MINC_PRO_CESS2		,
										 MINC_INC_INF	   =       :ls_MINC_INC_INF		,
										 MINC_IWA_INF	   =       :ls_MINC_IWA_INF		,
										 MINC_BRNCD_WHS	=       :ls_MINC_BRNCD_WHS		,
										 MINC_BRNCD_RAW	=       :ls_MINC_BRNCD_RAW		,
										 MINC_CHG_PTNO	   =       :ls_MINC_CHG_PTNO		,
										 MINC_FIR_ORDNO	=       :ls_MINC_FIR_ORDNO		,
										 MINC_ORDNO			=       :ls_MINC_ORDNO			,
										 MINC_RAW_ORDNO	=       :ls_MINC_RAW_ORDNO		,
										 MINC_LC_ID			=       :ls_MINC_LC_ID			,
										 MINC_OINSP_NO	   =       :ls_MINC_OINSP_NO		,
										 MINC_EMPNO			=       :ls_MINC_EMPNO			,
										 MINC_ORD_QTY	   =       :ll_MINC_ORD_QTY		,
										 END_LINE			=       :ll_END_LINE				,
										 DAY_MONTH			=       :ll_DAY_MONTH			,
										 CRT_DATE			=       :ls_CRT_DATE				,
										 CRT_TIME			=       :ls_CRT_TIME				,
										 CRT_USER			=       :ls_CRT_USER				,
/*										 CITNBR		      =       :ls_CITNBR				,		*/		/* 일검수확정 자료 보존 - 2007.01.25 */
										 MITNBR		      =       :ls_MITNBR				,
										 MCVCOD		      =       :ls_MCVCOD				,
										 MDCVCOD		      =       :ls_MDCVCOD		
										 
										 WHERE MINC_BRNCD = :ls_MINC_BRNCD
										   AND MINC_IN_YM = :ls_MINC_IN_YM
											AND MINC_IN_SEQ = :ls_MINC_IN_SEQ ;										
	End If
	
	If sqlca.sqlcode <> 0 Then
		
		st_state.Visible = False
		wf_error(arg_file_name,li_cnt,'','',ls_mitnbr,"입력에러가 발생했습니다." +sqlca.sqlerrtext+'[열위치:'+string(li_cnt)+']')
		rollback;
		FileClose(li_FileNum)
		return -3
	Else
		il_succeed++
	End if
	
	
Loop


// van file close
FileClose(li_FileNum)

//van 파일명 변경

//li_FileNum = FileCopy(arg_file_name,left(arg_file_name,pos(trim(arg_file_name),".")) + "bak",TRUE)
//if li_FileNum <> 1 then
//	Rollback ;
//	st_state.Visible = False
//	wf_error(ls_gubun,0,'','','',"파일변경에 에러가 발생했습니다."  )
//	
//	return -4
//end if

//van 파일 삭제
//if not FileDelete(arg_file_name) then 
//	Rollback ;
//	st_state.Visible = False
//	messagebox('error','화일삭제 에러입니다.')
//	return -4
//end if

commit;

st_state.Visible = False
return ll_data

end function

on w_sm10_0040.create
int iCurrent
call super::create
this.p_search=create p_search
this.p_delrow=create p_delrow
this.p_delrow_all=create p_delrow_all
this.pb_1=create pb_1
this.dw_br=create dw_br
this.dw_ar=create dw_ar
this.dw_er=create dw_er
this.dw_fr=create dw_fr
this.dw_nr=create dw_nr
this.dw_or=create dw_or
this.tab_1=create tab_1
this.pb_2=create pb_2
this.st_ing=create st_ing
this.p_excel=create p_excel
this.dw_hr=create dw_hr
this.p_1=create p_1
this.cb_1=create cb_1
this.lb_1=create lb_1
this.st_state=create st_state
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_search
this.Control[iCurrent+2]=this.p_delrow
this.Control[iCurrent+3]=this.p_delrow_all
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.dw_br
this.Control[iCurrent+6]=this.dw_ar
this.Control[iCurrent+7]=this.dw_er
this.Control[iCurrent+8]=this.dw_fr
this.Control[iCurrent+9]=this.dw_nr
this.Control[iCurrent+10]=this.dw_or
this.Control[iCurrent+11]=this.tab_1
this.Control[iCurrent+12]=this.pb_2
this.Control[iCurrent+13]=this.st_ing
this.Control[iCurrent+14]=this.p_excel
this.Control[iCurrent+15]=this.dw_hr
this.Control[iCurrent+16]=this.p_1
this.Control[iCurrent+17]=this.cb_1
this.Control[iCurrent+18]=this.lb_1
this.Control[iCurrent+19]=this.st_state
end on

on w_sm10_0040.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.p_search)
destroy(this.p_delrow)
destroy(this.p_delrow_all)
destroy(this.pb_1)
destroy(this.dw_br)
destroy(this.dw_ar)
destroy(this.dw_er)
destroy(this.dw_fr)
destroy(this.dw_nr)
destroy(this.dw_or)
destroy(this.tab_1)
destroy(this.pb_2)
destroy(this.st_ing)
destroy(this.p_excel)
destroy(this.dw_hr)
destroy(this.p_1)
destroy(this.cb_1)
destroy(this.lb_1)
destroy(this.st_state)
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
//dw_print.object.datawindow.print.preview = "yes"	
//
//dw_print.ShareData(dw_list)

PostEvent('ue_open')

dw_ip.Object.jisi_date[1] = is_today
dw_ip.Object.jisi_date2[1] = is_today
/*
ARU904041004.TXT - 품목정보 *
BRU904041004.TXT - 발주정보 *
ERU904041003.TXT - Back order(긴급발주)정보
FRU904041004.TXT - 포장스팩 *
NRU904041003.TXT - 일일입고 *
ORU904040905.TXT - 월마감 *
PRU904041004.TXT - 납입률 <- 참고용으로 Display 및 그래프로 보도록 요망 *

HRU904040925.TXT - 내수 확정 클래임 (Head)
IRU904040925.TXT - 내수 확정 클래임 (body)

KRU904040925.TXT - 수출 확정 클래임 (Head)
LRU904040925.TXT - 수출 확정 클래임 (body)
*/
dw_ar.SetTransObject(SQLCA)
dw_br.SetTransObject(SQLCA)
dw_er.SetTransObject(SQLCA)
dw_fr.SetTransObject(SQLCA)
dw_nr.SetTransObject(SQLCA)
dw_or.SetTransObject(SQLCA)
dw_hr.SetTransObject(SQLCA)

dw_ar.visible = False
dw_br.visible = False
dw_er.visible = False
dw_fr.visible = False
dw_nr.visible = False
dw_or.visible = False
dw_hr.visible = False

dw_ar.Titlebar = False
dw_br.Titlebar = False
dw_er.Titlebar = False
dw_fr.Titlebar = False
dw_nr.Titlebar = False
dw_or.Titlebar = False
dw_hr.Titlebar = False

setnull(gs_code)
If f_check_saupj() = 1 Then
	dw_ip.SetItem(1, 'saupj', gs_code)
   if gs_code <> '%' then
   	dw_ip.Modify("saupj.protect=1")
   End if
End If

// U904 구분 *********************//
Select rfna5 Into :is_custid
  From reffpf
  Where rfcod = 'AD'
    and rfcod != '00' 
	 and rfgub = :gs_code ;
If sqlca.sqlcode <> 0 Then
	f_message_chk(33 ,'[사업장]')
	Return
End If
//************************************

//dw_ip.Object.gubun[1] = 'AL'








end event

type p_xls from w_standard_print`p_xls within w_sm10_0040
end type

type p_sort from w_standard_print`p_sort within w_sm10_0040
end type

type p_preview from w_standard_print`p_preview within w_sm10_0040
boolean visible = false
integer x = 4169
integer y = 332
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

type p_exit from w_standard_print`p_exit within w_sm10_0040
integer x = 4343
end type

event p_exit::clicked;close(parent)

end event

type p_print from w_standard_print`p_print within w_sm10_0040
boolean visible = false
integer x = 4343
integer y = 332
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

type p_retrieve from w_standard_print`p_retrieve within w_sm10_0040
integer x = 3995
end type







type st_10 from w_standard_print`st_10 within w_sm10_0040
end type



type dw_print from w_standard_print`dw_print within w_sm10_0040
string dataobject = "d_van_t_10020_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sm10_0040
integer x = 9
integer y = 20
integer width = 3314
integer height = 436
string dataobject = "d_sm10_0040_1"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;call super::itemchanged;String ls_col , ls_value

ls_col = GetColumnName()
ls_value = Trim(GetText())

Choose Case ls_col
	Case "gubun"
		If ls_value > '' Then
			Object.filename[1] = ' '+ wf_choose(ls_value)
		End If
		
	Case "reg_gb"
		If ls_value = 'Y' Then
			pb_2.visible = True
		Else
			pb_2.visible = False
		End If

END CHOOSE
end event

type dw_list from w_standard_print`dw_list within w_sm10_0040
integer x = 59
integer y = 616
integer width = 4471
integer height = 1616
string dataobject = "d_sm10_0040_a"
boolean border = false
end type

event dw_list::clicked;f_multi_select(this)
end event

event dw_list::rowfocuschanged;//
end event

type p_search from uo_picture within w_sm10_0040
integer x = 3589
integer y = 24
integer width = 178
integer taborder = 90
boolean bringtotop = true
string pointer = "C:\erpman\cur\create2.cur"
string picturename = "C:\erpman\image\생성_up.gif"
end type

event clicked;call super::clicked;Long ll_cnt
string ls_saupj , ls_filename , ls_gubun , ls_reg_gb ,ls_saupj_cust , ls_date , ls_sdate

If Tab_1.SelectedTab = 2 Then Return

If dw_ip.AcceptText() < 1 Then Return
If dw_ip.RowCount() < 1 Then Return

/*
ARU904041004.TXT - 품목정보 *
BRU904041004.TXT - 발주정보 *
ERU904041003.TXT - Back order(긴급발주)정보
FRU904041004.TXT - 포장스팩 *
NRU904041003.TXT - 일일입고 *
ORU904040905.TXT - 월마감 *
PRU904041004.TXT - 납입률 <- 참고용으로 Display 및 그래프로 보도록 요망 *

HRU904040925.TXT - 내수 확정 클래임 (Head)
IRU904040925.TXT - 내수 확정 클래임 (body)

KRU904040925.TXT - 수출 확정 클래임 (Head)
LRU904040925.TXT - 수출 확정 클래임 (body)
*/

//is_path = "c:\erpman\temp\"
is_path = "C:\PROJECT\HYUNDAI\VAN\"

ls_gubun = Trim(dw_ip.Object.gubun[1])
ls_saupj = Trim(dw_ip.Object.saupj[1])
ls_sdate = Trim(dw_ip.Object.jisi_date[1])
ls_date = Right(ls_sdate,6)

select fun_get_reffpf_value('AD',:ls_saupj,'4') Into :ls_saupj_cust
  from dual ;
If sqlca.sqlcode <> 0 Or ls_saupj_cust = '' Or isNull(ls_saupj_cust) Then
	MessageBox('확인','사업장을 선택하세요')
	Return -1
End If

pointer oldpointer
oldpointer = SetPointer(HourGlass!)

dw_list.reset()

//listbox
//VAN 처리시 디렉토리("c:\erpman\as\") 안에꺼 다 처리하도록 수정 2005.01.06. 이수철
if ls_gubun = 'AL' then
	MessageBox('확인', '전체 일 경우 발주정보는 제외 됩니다.~r~n발주정보는 별도로 생성 바랍니다.')
	
//품목정보 AR은 제일 최근꺼만 실행
	lb_1.DirList(is_path+"\MOBISA.*", 0)
	lb_1.sorted = true
	ls_filename = lb_1.Text( lb_1.totalitems() )
	wf_process( mid(ls_filename,1,2), ls_filename )			
	lb_1.reset()
	lb_1.DirList(is_path+"\MOBISB.*", 0)
	lb_1.sorted = true
	ls_filename = lb_1.Text( lb_1.totalitems() )
	wf_process( mid(ls_filename,1,2), ls_filename )			
	lb_1.reset()
	lb_1.DirList(is_path+"\MOBISE.*", 0)
	lb_1.sorted = true
	ls_filename = lb_1.Text( lb_1.totalitems() )
	wf_process( mid(ls_filename,1,2), ls_filename )			
//나머지 처리
	lb_1.reset()
	lb_1.DirList(is_path+"\*.*", 0)
	lb_1.sorted = true
	For ll_cnt = 1 to lb_1.totalitems()
		ls_filename = lb_1.Text(ll_cnt)
		if  mid(ls_filename,1,2) <> 'AR' THEN
			IF  mid(ls_filename,1,2) <> 'BR' THEN
				IF  mid(ls_filename,1,2) <> 'ER' THEN
					wf_process( mid(ls_filename,1,2), ls_filename )
				end if
			end if
		end if
	Next
	

//		wf_process( ls_gubun, 'MOBISA.TXT' )
//
//		wf_process( ls_gubun, 'MOBISB.TXT' )
//
//		wf_process( ls_gubun, 'MOBISE.TXT' )
//
//		wf_process( ls_gubun, 'MOBISN.TXT' )
//
//		wf_process( ls_gubun, 'MOBISO.TXT' )
//
//		wf_process( ls_gubun, 'MOBISF.TXT' )
//		전체일 경우 변수로 하면 안됨. by sHInGooN
      wf_process( 'AR', 'MOBISA.TXT' )

/* 전체 일 경우 발주정보는 제외(파일을 별도로 선택하여 UPLOAD) - BY SHINGOON 2013.09.10 */
//		wf_process( 'BR', 'MOBISB.TXT' )

		wf_process( 'ER', 'MOBISE.TXT' )
		
		wf_process( 'NR', 'MOBISN.TXT' )

		wf_process( 'OR', 'MOBISO.TXT' )

		wf_process( 'FR', 'MOBISF.TXT' )
	
else
	
//	ls_filename = ls_gubun + ls_saupj_cust+ls_date+'.TXT'	
	
	Choose Case ls_gubun
		Case "AR"
			wf_process( ls_gubun, 'MOBISA.TXT' )
		Case "BR"
			wf_process( ls_gubun, 'MOBISB.TXT' )
		Case "ER"
			wf_process( ls_gubun, 'MOBISE.TXT' )
		Case "NR"
			wf_process( ls_gubun, 'MOBISN.TXT' )
		Case "OR"
			wf_process( ls_gubun, 'MOBISO.TXT' )
		Case "FR"
			wf_process( ls_gubun, 'MOBISF.TXT' )
	END CHOOSE
			
end if

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

/*
Long ll_cnt
string ls_saupj , ls_filename , ls_gubun , ls_reg_gb ,ls_saupj_cust , ls_date , ls_sdate

If Tab_1.SelectedTab = 2 Then Return

If dw_ip.AcceptText() < 1 Then Return
If dw_ip.RowCount() < 1 Then Return

//is_path = "c:\erpman\temp\"
is_path = "c:\MOBIS\as\"

ls_gubun = Trim(dw_ip.Object.gubun[1])
ls_saupj = Trim(dw_ip.Object.saupj[1])
ls_sdate = Trim(dw_ip.Object.jisi_date[1])
ls_date = Right(ls_sdate,6)

select fun_get_reffpf_value('AD',:ls_saupj,'4') Into :ls_saupj_cust
  from dual ;
If sqlca.sqlcode <> 0 Or ls_saupj_cust = '' Or isNull(ls_saupj_cust) Then
	MessageBox('확인','사업장을 선택하세요')
	Return -1
End If


pointer oldpointer
oldpointer = SetPointer(HourGlass!)

dw_list.reset()

Choose Case ls_gubun
		
	Case "AR"
		il_err = 0 
		il_succeed = 0 
		ll_cnt=0
		ls_filename = ls_gubun + ls_saupj_cust+ls_date+'.TXT'
		ll_cnt = wf_van_ar(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			wf_error(ls_filename,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		
		w_mdi_frame.sle_msg.text ='총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.'
	Case "BR"
		il_err = 0 
		il_succeed = 0 
		ll_cnt=0
		ls_filename = ls_gubun + ls_saupj_cust+ls_date+'.TXT'
		ll_cnt = wf_van_br(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			wf_error(ls_filename,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		
		w_mdi_frame.sle_msg.text ='총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.'
	Case "ER"
		il_err = 0 
		il_succeed = 0 
		ll_cnt=0
		ls_filename = ls_gubun + ls_saupj_cust+ls_date+'.TXT'
		ll_cnt = wf_van_er(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			wf_error(ls_filename,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		
		w_mdi_frame.sle_msg.text ='총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.'
	Case "FR"
		il_err = 0 
		il_succeed = 0 
		ll_cnt=0
		ls_filename = ls_gubun + ls_saupj_cust+ls_date+'.TXT'
		ll_cnt = wf_van_fr(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			wf_error(ls_filename,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		
		w_mdi_frame.sle_msg.text ='총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.'
	Case "NR" 
		il_err = 0 
		il_succeed = 0 
		ll_cnt=0
		ls_filename = ls_gubun + ls_saupj_cust+ls_date+'.TXT'
		
		ll_cnt = wf_van_nr(ls_filename,gs_sabu,ls_gubun)
		If ll_cnt > 0 Then
			wf_error(ls_filename,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		
		w_mdi_frame.sle_msg.text ='총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.'
	Case "OR" 
		il_err = 0 
		il_succeed = 0 
		ll_cnt=0
		ls_filename = ls_gubun + ls_saupj_cust+ls_date+'.TXT'
		ll_cnt = wf_van_nr(ls_filename,gs_sabu,ls_gubun)
		If ll_cnt > 0 Then
			wf_error(ls_filename,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		
		w_mdi_frame.sle_msg.text ='총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.'
	Case "HR" 
		il_err = 0 
		il_succeed = 0 
		ll_cnt=0
		ls_filename = ls_gubun + ls_saupj_cust+ls_date+'.TXT'
		ll_cnt = wf_van_hr(ls_filename,gs_sabu,ls_gubun)
		If ll_cnt > 0 Then
			wf_error(ls_filename,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		
		w_mdi_frame.sle_msg.text ='총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.'

		ls_gubun = 'KR'
		il_err = 0 
		il_succeed = 0 
		ll_cnt=0
		ls_filename = ls_gubun + ls_saupj_cust+ls_date+'.TXT'
		ll_cnt = wf_van_hr(ls_filename,gs_sabu,ls_gubun)
		If ll_cnt > 0 Then
			wf_error(ls_filename,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		
		w_mdi_frame.sle_msg.text ='총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.'
		
		ls_gubun = 'IR'
		il_err = 0 
		il_succeed = 0 
		ll_cnt=0
		ls_filename = ls_gubun + ls_saupj_cust+ls_date+'.TXT'
		ll_cnt = wf_van_ir(ls_filename,gs_sabu,ls_gubun)
		If ll_cnt > 0 Then
			wf_error(ls_filename,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		
		w_mdi_frame.sle_msg.text ='총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.'

		ls_gubun = 'LR'
		il_err = 0 
		il_succeed = 0 
		ll_cnt=0
		ls_filename = ls_gubun + ls_saupj_cust+ls_date+'.TXT'
		ll_cnt = wf_van_ir(ls_filename,gs_sabu,ls_gubun)
		If ll_cnt > 0 Then
			wf_error(ls_filename,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		
		w_mdi_frame.sle_msg.text ='총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.'
		
		
/*	Case "IR" 
		il_err = 0 
		il_succeed = 0 
		ll_cnt=0
		ls_filename = ls_gubun + ls_saupj_cust+ls_date+'.TXT'
		ll_cnt = wf_van_ir(ls_filename,gs_sabu,ls_gubun)
		If ll_cnt > 0 Then
			wf_error(ls_filename,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		
		w_mdi_frame.sle_msg.text ='총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.'
	Case "LR" 
		il_err = 0 
		il_succeed = 0 
		ll_cnt=0
		ls_filename = ls_gubun + ls_saupj_cust+ls_date+'.TXT'
		ll_cnt = wf_van_ihr(ls_filename,gs_sabu,ls_gubun)
		If ll_cnt > 0 Then
			wf_error(ls_filename,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		
		w_mdi_frame.sle_msg.text ='총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.'
*/
	Case Else
		il_err = 0 
		il_succeed = 0 
		// AR
		ll_cnt=0
		ls_filename = 'AR'+ ls_saupj_cust+ls_date+'.TXT'
		ll_cnt = wf_van_ar(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			wf_error(ls_filename,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		// BR
		il_err = 0 
		il_succeed = 0 
		ls_filename = 'BR' + ls_saupj_cust+ls_date+'.TXT'
		ll_cnt = wf_van_br(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			wf_error(ls_filename,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End If
		// ER
		il_err = 0 
		il_succeed = 0 
		ls_filename = 'ER' + ls_saupj_cust+ls_date+'.TXT'
		ll_cnt = wf_van_er(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			wf_error(ls_filename,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		// FR
		il_err = 0 
		il_succeed = 0 
		ls_filename = 'FR' + ls_saupj_cust+ls_date+'.TXT'
		ll_cnt = wf_van_fr(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			wf_error(ls_filename,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		// NR
		il_err = 0 
		il_succeed = 0 
		
		ls_filename = 'NR' + ls_saupj_cust+ls_date+'.TXT'
		ll_cnt = wf_van_nr(ls_filename,gs_sabu,'NR')
		If ll_cnt > 0 Then
			wf_error(ls_filename,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		
		w_mdi_frame.sle_msg.text ='총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.'
		// OR
		il_err = 0 
		il_succeed = 0 
		ls_filename = 'OR' + ls_saupj_cust+ls_date+'.TXT'
		ll_cnt = wf_van_nr(ls_filename,gs_sabu,'OR')
		If ll_cnt > 0 Then
			wf_error(ls_filename,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		
		w_mdi_frame.sle_msg.text ='총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.'
		// HR
		il_err = 0 
		il_succeed = 0 
		ls_filename = 'HR' + ls_saupj_cust+ls_date+'.TXT'
		ll_cnt = wf_van_hr(ls_filename,gs_sabu,'HR')
		If ll_cnt > 0 Then
			wf_error(ls_filename,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		
		w_mdi_frame.sle_msg.text ='총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.'
		// KR
		il_err = 0 
		il_succeed = 0 
		ls_filename = 'KR' + ls_saupj_cust+ls_date+'.TXT'
		ll_cnt = wf_van_hr(ls_filename,gs_sabu,'KR')
		If ll_cnt > 0 Then
			wf_error(ls_filename,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		
		w_mdi_frame.sle_msg.text ='총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.'
		// IR
		il_err = 0 
		il_succeed = 0 
		ls_filename = 'IR' + ls_saupj_cust+ls_date+'.TXT'
		ll_cnt = wf_van_ir(ls_filename,gs_sabu,'IR')
		If ll_cnt > 0 Then
			wf_error(ls_filename,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		
		w_mdi_frame.sle_msg.text ='총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.'
		// LR
		il_err = 0 
		il_succeed = 0 
		ls_filename = 'LR' + ls_saupj_cust+ls_date+'.TXT'
		ll_cnt = wf_van_ir(ls_filename,gs_sabu,'LR')
		If ll_cnt > 0 Then
			wf_error(ls_filename,ll_cnt,'','','','총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		End if
		
		w_mdi_frame.sle_msg.text ='총건수 :'+String(ll_cnt) + '(에러 : '+String(il_err)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.'
	
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
*/
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\생성_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\생성_up.gif"
end event

type p_delrow from uo_picture within w_sm10_0040
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 4343
integer y = 184
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
		Case 'AR'
			ldw_x = dw_ar
		Case 'BR'
			ldw_x = dw_br
		Case 'ER'
			ldw_x = dw_er
		Case 'FR'
			ldw_x = dw_fr
		Case 'NR'
			ldw_x = dw_nr
		Case 'OR'
			ldw_x = dw_or
	End Choose
	
End IF

ll_rcnt = ldw_x.RowCount()

If ll_rcnt < 1 Then 
	MessageBox('확인','삭제할 데이타가 존재하지 않습니다.')
	Return
End IF
if f_msg_delete() = -1 then return

ldw_x.SetRedraw(FALSE)

For i = ll_rcnt To 1 Step -1
	If ldw_x.isSelected(i) Then
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

type p_delrow_all from uo_picture within w_sm10_0040
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 4169
integer y = 184
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
		Case 'AR'
			ldw_x = dw_ar
		Case 'BR'
			ldw_x = dw_br
		Case 'ER'
			ldw_x = dw_er
		Case 'FR'
			ldw_x = dw_fr
		Case 'NR'
			ldw_x = dw_nr
		
		
	End Choose
	
End IF


ll_rcnt = ldw_x.RowCount()

If ll_rcnt < 1 Then 
	MessageBox('확인','삭제할 데이타가 존재하지 않습니다.')
	Return
End IF
if f_msg_delete() = -1 then return

ldw_x.SetRedraw(FALSE)

For i = ll_rcnt To 1 Step -1
	
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

type pb_1 from u_pb_cal within w_sm10_0040
integer x = 800
integer y = 164
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

type dw_br from datawindow within w_sm10_0040
integer x = 882
integer y = 1172
integer width = 686
integer height = 400
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "BR"
string dataobject = "d_sm10_0040_br"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;f_multi_select(this)
end event

type dw_ar from datawindow within w_sm10_0040
integer x = 174
integer y = 1172
integer width = 686
integer height = 400
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "AR"
string dataobject = "d_sm10_0040_AR"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;f_multi_select(this)
end event

type dw_er from datawindow within w_sm10_0040
integer x = 1591
integer y = 1176
integer width = 686
integer height = 444
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "ER"
string dataobject = "d_sm10_0040_er"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;f_multi_select(this)
end event

type dw_fr from datawindow within w_sm10_0040
integer x = 2309
integer y = 1184
integer width = 686
integer height = 400
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "FR"
string dataobject = "d_sm10_0040_fr"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;f_multi_select(this)
end event

type dw_nr from datawindow within w_sm10_0040
integer x = 3022
integer y = 1188
integer width = 686
integer height = 400
integer taborder = 70
boolean bringtotop = true
boolean titlebar = true
string title = "NR"
string dataobject = "d_sm10_0040_nr"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;f_multi_select(this)
end event

type dw_or from datawindow within w_sm10_0040
integer x = 183
integer y = 1624
integer width = 686
integer height = 400
integer taborder = 70
boolean bringtotop = true
boolean titlebar = true
string title = "OR"
string dataobject = "d_sm10_0040_nr"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;f_multi_select(this)
end event

type tab_1 from tab within w_sm10_0040
integer x = 18
integer y = 480
integer width = 4562
integer height = 1792
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
	dw_ip.DataObject = "d_sm10_0040_1"
	
	dw_list.visible = true
	dw_ar.visible = False
	dw_br.visible = False
	dw_er.visible = False
	dw_fr.visible = False
	dw_nr.visible = False
	dw_or.visible = False
	
	p_excel.visible = True
	pb_1.visible = True
	pb_2.visible = False
	p_search.visible = True 
Else
	dw_ip.DataObject = "d_sm10_0040_2"
	p_excel.visible = False
	
	p_search.visible = False 
	
	pb_1.visible = false
	pb_2.visible = false
	Choose Case ls_gubun
		Case 'AR'
			
				dw_ar.x = dw_list.x
				dw_ar.y = dw_list.y
				dw_ar.width  = dw_list.width
				dw_ar.height = dw_list.height
				
				dw_list.visible = False
				
				dw_ar.visible = True
				dw_br.visible = False
				dw_er.visible = False
				dw_fr.visible = False
				dw_nr.visible = False
				dw_or.visible = False
				dw_hr.visible = false
				
				pb_1.visible = false
				pb_2.visible = false
		
		Case 'BR'
			
				dw_br.x = dw_list.x
				dw_br.y = dw_list.y
				dw_br.width  = dw_list.width
				dw_br.height = dw_list.height
				
				dw_list.visible = False
				
				dw_ar.visible = False
				dw_br.visible = True
				dw_er.visible = False
				dw_fr.visible = False
				dw_nr.visible = False
				dw_or.visible = False
				dw_hr.visible = false	
				
				pb_1.visible = false
				pb_2.visible = false
			
		Case 'ER'
			
				dw_er.x = dw_list.x
				dw_er.y = dw_list.y
				dw_er.width  = dw_list.width
				dw_er.height = dw_list.height
				
				dw_list.visible = False
				
				dw_ar.visible = False
				dw_br.visible = False
				dw_er.visible = True
				dw_fr.visible = False
				dw_nr.visible = False
				dw_or.visible = False
				dw_hr.visible = false
				
				pb_1.visible = false
				pb_2.visible = false
				
				
			
		Case 'FR'
			
				dw_fr.x = dw_list.x
				dw_fr.y = dw_list.y
				dw_fr.width  = dw_list.width
				dw_fr.height = dw_list.height
				
				dw_list.visible = False
				
				dw_ar.visible = False
				dw_br.visible = False
				dw_er.visible = False
				dw_fr.visible = True
				dw_nr.visible = False
				dw_or.visible = False
				dw_hr.visible = false	
				
				pb_1.visible = false
				pb_2.visible = false
			
		Case 'NR'
			
				dw_nr.x = dw_list.x
				dw_nr.y = dw_list.y
				dw_nr.width  = dw_list.width
				dw_nr.height = dw_list.height
				dw_list.visible = False
				
				dw_ar.visible = False
				dw_br.visible = False
				dw_er.visible = False
				dw_fr.visible = False
				dw_nr.visible = True
				dw_or.visible = False
				dw_hr.visible = false
				
				pb_1.visible = true
				pb_2.visible = true
			
		Case 'OR'
			
				dw_or.x = dw_list.x
				dw_or.y = dw_list.y
				dw_or.width  = dw_list.width
				dw_or.height = dw_list.height
				dw_list.visible = False
				
				dw_ar.visible = False
				dw_br.visible = False
				dw_er.visible = False
				dw_fr.visible = False
				dw_nr.visible = False
				dw_or.visible = True
				dw_hr.visible = false
				
				pb_1.visible = true
				pb_2.visible = true
				
		Case 'HR'
			
				dw_hr.x = dw_list.x
				dw_hr.y = dw_list.y
				dw_hr.width  = dw_list.width
				dw_hr.height = dw_list.height
				dw_list.visible = False
				
				dw_ar.visible = False
				dw_br.visible = False
				dw_er.visible = False
				dw_fr.visible = False
				dw_nr.visible = False
				dw_or.visible = false
				dw_hr.visible = true
				
				pb_1.visible = true
				pb_2.visible = true
	
		
	End Choose
End If


dw_ip.SetTransObject(SQLCA)
dw_ip.InsertRow(0)
setnull(gs_code)
If f_check_saupj() = 1 Then
	dw_ip.SetItem(1, 'saupj', gs_code)
   if gs_code <> '%' then
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
		dw_ip.Object.gubun[1] = 'BR'
		wf_choose('BR')
	Else
		dw_ip.Object.gubun[1] =  ls_gubun
	End iF
End if

end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 4526
integer height = 1664
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
integer height = 1636
integer cornerheight = 40
integer cornerwidth = 55
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 4526
integer height = 1664
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
integer height = 1708
integer cornerheight = 40
integer cornerwidth = 55
end type

type pb_2 from u_pb_cal within w_sm10_0040
boolean visible = false
integer x = 1285
integer y = 164
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

type st_ing from statictext within w_sm10_0040
boolean visible = false
integer x = 3479
integer y = 312
integer width = 818
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "Disconnect......"
boolean focusrectangle = false
end type

type p_excel from uo_picture within w_sm10_0040
boolean visible = false
integer x = 3333
integer y = 24
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\엑셀변환_up.gif"
end type

event clicked;call super::clicked;If dw_list.RowCount() < 1 Then Return
If Tab_1.SelectedTab <> 1 Then Return
string ls_path, ls_file
int li_rc

li_rc = GetFileSaveName ( "Select File", ls_path, ls_file, "XLS", "Excel Files (*.xls),*.xls",'C:\', 32770)
dw_list.SaveAs(ls_path, Excel!, FALSE)


end event

type dw_hr from datawindow within w_sm10_0040
integer x = 878
integer y = 1632
integer width = 686
integer height = 400
integer taborder = 70
boolean bringtotop = true
boolean titlebar = true
string title = "HR"
string dataobject = "d_sm10_0040_hr"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;f_multi_select(this)
end event

type p_1 from uo_picture within w_sm10_0040
integer x = 4169
integer y = 24
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;call super::clicked;If dw_ip.AcceptText() < 1 Then Return

String ls_gubun

ls_gubun = Trim(dw_ip.Object.gubun[1])

If ls_gubun <> 'BR' Then Return

If f_msg_update() < 1 Then Return

dw_br.AcceptText() 

If dw_br.Update() < 1 Then
	Rollback;
	MessageBox('확인','발주정보 저장실패')
	Return
Else
	Commit;
End if


	
end event

type cb_1 from commandbutton within w_sm10_0040
boolean visible = false
integer x = 3333
integer y = 192
integer width = 672
integer height = 120
integer taborder = 90
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "MOBIS VAN 수신"
end type

event clicked;//open(w_anftp2)
//ShellExecuteA(0, "open", "VAN.exe", "", "", 4)
//run("C:\erpman\bin\van.exe")

//p_search.triggerevent(clicked!)
end event

type lb_1 from listbox within w_sm10_0040
boolean visible = false
integer x = 3305
integer y = 352
integer width = 878
integer height = 160
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_state from statictext within w_sm10_0040
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

