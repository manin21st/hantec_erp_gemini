$PBExportHeader$w_mm90_00075_csv.srw
$PBExportComments$협력사재고 생성 CSV
forward
global type w_mm90_00075_csv from w_standard_print
end type
type pb_1 from u_pb_cal within w_mm90_00075_csv
end type
type dw_jogun from datawindow within w_mm90_00075_csv
end type
type dw_csv from datawindow within w_mm90_00075_csv
end type
type rr_1 from roundrectangle within w_mm90_00075_csv
end type
end forward

global type w_mm90_00075_csv from w_standard_print
string title = "고객사 재고 CSV생성"
pb_1 pb_1
dw_jogun dw_jogun
dw_csv dw_csv
rr_1 rr_1
end type
global w_mm90_00075_csv w_mm90_00075_csv

type prototypes
 
//temp 폴더 경로 가져오기 
FUNCTION ulong GetTempPath(ulong nBufferLength, ref string lpBuffer) LIBRARY "kernel32" ALIAS FOR "GetTempPathA;Ansi"

end prototypes

type variables
String	ls_tempDir
DataWindowChild	idwc_child
end variables

forward prototypes
public subroutine wf_move (string sitnbr, string sitdsc, string sispec)
public function integer wf_retrieve ()
public function string wf_get_temp_path ()
end prototypes

public subroutine wf_move (string sitnbr, string sitdsc, string sispec);if sitnbr = '' or isnull(sitnbr) then return 

dw_ip.setitem(1, "to_itnbr", sitnbr)	
dw_ip.setitem(1, "to_itdsc", sitdsc)	


end subroutine

public function integer wf_retrieve ();String	ls_plant, ls_sdate, ls_comcd, ls_werks, ls_itnbr, ls_itdsc, ls_carcode, ls_vendcd, ls_empnm, ls_emptel, ls_saupj, ls_err
Long		ll_row, ll_insrow, ll_jego, ll_maxseq

if dw_ip.AcceptText() = -1 then return -1

dw_list.Reset()
dw_jogun.Reset()
ls_saupj	= Trim(dw_ip.GetItemString(1, 'saupj'))
ls_plant = Trim(dw_ip.GetItemString(1, 'plant'))
ls_sdate = Trim(dw_ip.GetItemString(1, 'sdate'))
//ls_comcd = Trim(dw_ip.GetItemString(1, 'com_cd'))
//ls_werks = Trim(dw_ip.GetItemString(1, 'werks'))

if ls_plant = '' or IsNull(ls_plant) then
	MessageBox("확인", "납품공장을 선택하세요!")
	dw_ip.SetFocus()
	dw_ip.SetColumn('plant')
	return -1
end if

if ls_sdate = '' or IsNull(ls_sdate) then
	MessageBox("확인", "생성일자를 입력하세요!")
	dw_ip.SetFocus()
	dw_ip.SetColumn('sdate')
	return -1
end if

// 기본정보값 셋팅을 위한 호출 
setnull(gs_gubun)
setnull(gs_code)
gs_gubun = ls_saupj	//사업장 
gs_code	= ls_plant

Open(w_mm90_00075_csv_popup)
if IsNull(gs_gubun) or gs_gubun = 'N' then return -1
dw_jogun.ImportClipboard() 


ls_comcd = Trim(dw_jogun.GetItemString(1, 'com_cd'))
ls_werks = Trim(dw_jogun.GetItemString(1, 'werks'))
ls_vendcd= Trim(dw_jogun.GetItemString(1, 'vend_cd'))
ls_empnm	= Trim(dw_jogun.GetItemString(1, 'end_ch_nm'))
ls_emptel= Trim(dw_jogun.GetItemString(1, 'end_ch_tel')) 

//전송차수 확인 (전송차수는 무조건 해당일자단위로 1씩 증가 )
select	max(ZSIFNO)
into		:ll_maxseq
from		INF_VEND_INVEN_N
where		REF_DATE = :ls_sdate ;

if sqlca.sqlcode <> 0 or IsNull(ll_maxseq) then 
	ll_maxseq = 0
end if


// 재고 데이터 생성 
ll_maxseq ++
SetPointer(HourGlass!) 
	
ls_err = 'Y'

DECLARE start_sp_crt_vendor_jego  PROCEDURE FOR sp_crt_vendor_jego(:ls_saupj, :ls_sdate, :ll_maxseq, :ls_comcd, :ls_werks, :ls_vendcd, :ls_empnm, :ls_emptel ) ;
EXECUTE start_sp_crt_vendor_jego;
If SQLCA.SQLCODE < 0 Then
	MessageBox("확인", "재고정보 생성오류!!!" + SQLCA.SQLERRTEXT)	// 자료를 처리할 수 없습니다.
	CLOSE start_sp_crt_vendor_jego ;
	RollBack;
	Return -1
End If

FETCH start_sp_crt_vendor_jego INTO :ls_err;
If SQLCA.SQLCODE < 0 Then
	MessageBox("확인", "재고정보 생성오류!!!" + SQLCA.SQLERRTEXT)	// 자료를 처리할 수 없습니다.
//	f_message_chk(240, "~r~n~r~n[FETCH sp_crt_vendor_jego]~r~n~r~n" + SQLCA.SQLERRTEXT)	// 자료를 처리할 수 없습니다.
	CLOSE start_sp_crt_vendor_jego;
	RollBack ;
	Return -1
End If

if ls_err = 'Y'  then
	rollback ;
	messagebox('확인', '고객 재고자료 생성 실패하였습니다.')
	CLOSE start_sp_crt_vendor_jego;		 
	return -1
end if
CLOSE start_sp_crt_vendor_jego;		 
commit ;  
dw_ip.SetItem(1, 'chasu', ll_maxseq)
dw_ip.SetItem(1, 'plant', ls_werks)

if dw_list.Retrieve(ls_sdate, ll_maxseq, ls_werks) <= 0 then
	MessageBox("확인","해당조건의 재고 정보가 존재하지 않습니다.")
else
	dw_csv.Retrieve(ls_sdate, ll_maxseq, ls_werks)
end if

return 1
end function

public function string wf_get_temp_path ();
Long		ll_bufferlength = 256

ls_tempDir = SPACE(ll_bufferLength)

If GetTempPath(ll_bufferLength, ls_tempDir) = 0 Then
	ls_tempDir = "C:\"
End If

return ls_tempDir  
end function

on w_mm90_00075_csv.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.dw_jogun=create dw_jogun
this.dw_csv=create dw_csv
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.dw_jogun
this.Control[iCurrent+3]=this.dw_csv
this.Control[iCurrent+4]=this.rr_1
end on

on w_mm90_00075_csv.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.dw_jogun)
destroy(this.dw_csv)
destroy(this.rr_1)
end on

event open;String	ls_plant
Integer  li_idx, ll_maxseq

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

dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)



dw_ip.SetTransObject(SQLCA)
dw_ip.GetChild('plant', idwc_child)  //해당사업장의 관련 납품공장 코드 dddw 
idwc_child.SetTransObject(SQLCA) 
idwc_child.Retrieve(gs_saupj)

ls_plant = idwc_child.GetItemString(1, 'rfgub') //해당사업장의 관련 납품공장 코드 

dw_ip.Reset()
dw_ip.InsertRow(0)
dw_ip.SetItem(1, 'saupj', gs_saupj)
dw_ip.SetItem(1, 'plant', ls_plant)
dw_ip.SetItem(1, 'sdate', is_today)


//전송차수 확인 
select	max(ZSIFNO)
into		:ll_maxseq
from		INF_VEND_INVEN_N
where		REF_DATE = :is_today 
and		WERKS	like :ls_plant ;

if sqlca.sqlcode <> 0 or IsNull(ll_maxseq) then 
	ll_maxseq = 0
end if


dw_ip.SetItem(1, 'chasu', ll_maxseq) 

 
dw_list.Retrieve(is_today, ll_maxseq, ls_plant)
end event

type p_xls from w_standard_print`p_xls within w_mm90_00075_csv
end type

type p_sort from w_standard_print`p_sort within w_mm90_00075_csv
end type

type p_preview from w_standard_print`p_preview within w_mm90_00075_csv
boolean visible = false
integer x = 3886
integer y = 48
integer taborder = 0
end type

type p_exit from w_standard_print`p_exit within w_mm90_00075_csv
integer x = 4430
integer y = 32
integer taborder = 0
end type

type p_print from w_standard_print`p_print within w_mm90_00075_csv
integer x = 4251
integer y = 32
integer taborder = 0
boolean enabled = true
string picturename = "C:\erpman\image\excel_up.gif"
end type

event p_print::clicked;String	ls_file, ls_path, ls_excelpath
Long		li_exe

if dw_list.RowCount() = 0 then
	MessageBox("확인","조건에 맞는 자료가 존재하지 않습니다.")
	return
end if

if MessageBox("확인","CSV 화일을 생성 하시겠습니까?~r파일저장경로 : C:\xtrus_client\data\file\outbound\INVEN\", Question!, YesNo!)= 2 then return
select to_char(sysdate, 'yyyymmddhh24miss')||'.csv' 
into	:ls_file
from dual ;

//ls_path = wf_get_temp_path() + ls_file

//ls_path = 'c:\erpman\' + ls_file
ls_path = 'C:\xtrus_client\data\file\outbound\INVEN\' + ls_file


//dw_list.SaveAs(ls_path, CSV!, false)  
dw_csv.SaveAs(ls_path, CSV!, false)  
//uf_save_dw_as_excel(dw_csv, ls_path)

/* 2022.07.09 - 파일 생성만 하고 오픈안되도록 수정 */
//RegistryGet("HKEY_CLASSES_ROOT\Excel.Addin\shell\Open\command", "", RegString!, ls_excelpath)
//li_exe = Run(ls_excelpath + ' ' + '"' + ls_path + '"' , Maximized!)
//  if li_exe < 1 then
//	MessageBox("확인" , ls_path + " CSV화일을 여는데 실패 했습니다." , Exclamation!)
//	return 
//end if 
 
end event

event p_print::ue_lbuttondown;call super::ue_lbuttondown;IF p_print.Enabled = True THEN
	PictureName = 'C:\erpman\image\excel_dn.gif'
END IF
end event

event p_print::ue_lbuttonup;call super::ue_lbuttonup;IF p_print.Enabled = True THEN
	PictureName = 'C:\erpman\image\excel_up.gif'
END IF
end event

type p_retrieve from w_standard_print`p_retrieve within w_mm90_00075_csv
integer x = 4073
integer y = 32
integer taborder = 0
string picturename = "C:\erpman\image\생성_up.gif"
end type

event p_retrieve::clicked;//CSV변환
String	ls_path, ls_file, ls_excelpath, ls_objs, ls_object
Int		li_rc, li_exe 
dw_ip.AcceptText()
if wf_retrieve() = -1 then return 

IF dw_list.rowcount() <= 0 then 
	MessageBox('확인', '자료가 없습니다.')
	return 
end if 

p_print.TriggerEvent(clicked!)
end event

event p_retrieve::ue_lbuttondown;PictureName = 'C:\erpman\image\생성_dn.gif'

end event

event p_retrieve::ue_lbuttonup;PictureName = 'C:\erpman\image\생성_up.gif'

end event











type dw_print from w_standard_print`dw_print within w_mm90_00075_csv
string dataobject = "d_mm90_00075_csv_3"
end type

type dw_ip from w_standard_print`dw_ip within w_mm90_00075_csv
integer x = 23
integer y = 24
integer width = 3685
integer height = 244
integer taborder = 0
string dataobject = "d_mm90_00075_csv_1"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::rbuttondown;string sIttyp
str_itnct lstr_sitnct

setnull(gs_gubun)
setnull(gs_code)
setnull(gs_codename)

if this.GetColumnName() = 'fr_itnbr' then
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"fr_itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)
elseif this.GetColumnName() = 'to_itnbr' then
	open(w_itemas_popup)

	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"to_itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)

ELSEIF this.GetColumnName() = "cvcod" THEN
   gs_gubun = '1'	
	Open(w_vndmst_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then  return

	this.SetItem(1, "cvcod", gs_Code)
	this.SetItem(1, "cvnas", gs_Codename)
end if	

end event

event dw_ip::itemchanged;string s_cod, ls_plant, ls_null, ls_Date
int     li_maxseq

SetNull(ls_null)

s_cod = Trim(this.GetText()) 

dw_list.Reset() 

if this.GetColumnName() = "saupj" then
	if idwc_child.Retrieve(s_cod) = 0 then
		SetItem(1, 'plant', ls_null)
		return 0
	end if
	ls_plant	= idwc_child.GetItemString(1, 'rfgub')
	
	SetItem(1, 'plant', ls_plant)
	
	ls_date = GetItemString(1, 'sdate') 
	//전송차수 확인 
	select	max(ZSIFNO)
	into		:li_maxseq
	from		INF_VEND_INVEN_N
	where		REF_DATE = :ls_date 
	AND		WERKS like :ls_plant ;
	
	if sqlca.sqlcode <> 0 or IsNull(li_maxseq) then 
		li_maxseq = 0
	end if 
	this.SetItem(1, 'chasu', li_maxseq) 
	
	dw_list.Retrieve(ls_date, li_maxseq, ls_plant)
	
end if


if this.GetColumnName() = "plant" then
	ls_date = GetItemString(1, 'sdate') 
	//전송차수 확인 
	select	max(ZSIFNO)
	into		:li_maxseq
	from		INF_VEND_INVEN_N
	where		REF_DATE = :ls_date 
	AND		WERKS like :s_cod ;
	
	if sqlca.sqlcode <> 0 or IsNull(li_maxseq) then 
		li_maxseq = 0
	end if 
	this.SetItem(1, 'chasu', li_maxseq) 
	
	dw_list.Retrieve(ls_date, li_maxseq, s_cod)
end if

if this.GetColumnName() = "sdate" then
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[생성일자]")
		this.object.sdate[1] = ""
		return 1
	end if 
	 
	ls_plant	= GeTItemString(1, 'plant')
	 
	//전송차수 확인 
	select	max(ZSIFNO)
	into		:li_maxseq
	from		INF_VEND_INVEN_N
	where		REF_DATE = :s_cod 
	AND		WERKS like :ls_plant ;
	
	if sqlca.sqlcode <> 0 or IsNull(li_maxseq) then 
		li_maxseq = 0
	end if 
	this.SetItem(1, 'chasu', li_maxseq) 
	
	dw_list.Retrieve(s_cod, li_maxseq, ls_plant)
end if
end event

type dw_list from w_standard_print`dw_list within w_mm90_00075_csv
integer x = 55
integer y = 280
integer width = 4535
integer height = 1972
integer taborder = 0
string dataobject = "d_mm90_00075_csv_2"
boolean border = false
end type

type pb_1 from u_pb_cal within w_mm90_00075_csv
integer x = 2729
integer y = 76
integer taborder = 10
boolean bringtotop = true
end type

event clicked;call super::clicked;//if gs_saupj = '20' then
	dw_ip.Setcolumn('sdate')
	IF gs_code = '' Or IsNull(gs_code) THEN Return
	dw_ip.SetItem(1, 'sdate', gs_code)
	
	Int li_maxseq	
	String ls_plant
	 
	//전송차수 확인 
	select	max(ZSIFNO)
	into		:li_maxseq
	from		INF_VEND_INVEN_N
	where		REF_DATE = :gs_code ;
	
	if sqlca.sqlcode <> 0 or IsNull(li_maxseq) then 
		li_maxseq = 0
	end if 
	dw_ip.SetItem(1, 'chasu', li_maxseq) 
	
	ls_plant = dw_ip.GetItemString(1, 'plant') 
	
	if dw_list.Retrieve(gs_code, li_maxseq, ls_plant) > 0 then
		dw_csv.Retrieve(gs_code, li_maxseq, ls_plant)
	end if
//end if	
end event

type dw_jogun from datawindow within w_mm90_00075_csv
boolean visible = false
integer x = 2555
integer y = 848
integer width = 686
integer height = 400
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_mm90_00075_csv_popup_1"
boolean livescroll = true
end type

type dw_csv from datawindow within w_mm90_00075_csv
boolean visible = false
integer x = 1275
integer y = 844
integer width = 686
integer height = 400
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_mm90_00075_csv_2_1"
boolean border = false
boolean livescroll = true
end type

event constructor;this.SetTransObject(sqlca)
end event

type rr_1 from roundrectangle within w_mm90_00075_csv
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 268
integer width = 4576
integer height = 1996
integer cornerheight = 40
integer cornerwidth = 55
end type

