$PBExportHeader$w_pdt_05550.srw
$PBExportComments$** 품목별 외주 지급 현황
forward
global type w_pdt_05550 from w_standard_print
end type
type pb_1 from u_pb_cal within w_pdt_05550
end type
type pb_2 from u_pb_cal within w_pdt_05550
end type
end forward

global type w_pdt_05550 from w_standard_print
string title = "품목별 외주 지급 현황"
pb_1 pb_1
pb_2 pb_2
end type
global w_pdt_05550 w_pdt_05550

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string cvcod1, cvcod2, fitnbr, titnbr, sgub, sdate, edate, ls_gubun

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

cvcod1 = trim(dw_ip.object.cvcod1[1])
cvcod2 = trim(dw_ip.object.cvcod2[1])
fitnbr = trim(dw_ip.object.fr_itnbr[1])
titnbr = trim(dw_ip.object.to_itnbr[1])
sgub   = trim(dw_ip.object.sgub[1])
sdate = trim(dw_ip.object.sdate[1])
edate = trim(dw_ip.object.edate[1])
ls_gubun = trim(dw_ip.object.gubun[1])

if (IsNull(cvcod1) or cvcod1 = "")  then cvcod1 = "."
if (IsNull(cvcod2) or cvcod2 = "")  then cvcod2 = "ZZZZZZ"

if (IsNull(fitnbr) or fitnbr = "")  then fitnbr = "."
if (IsNull(titnbr) or titnbr = "")  then titnbr = "zzzzzzzzzzzzzzz"

if (IsNull(sdate) or sdate = "")  then sdate = "10000101"
if (IsNull(edate) or edate = "")  then edate = "99999999"

dw_list.setredraw(false)
if sgub = '1' then //거래처순
   dw_list.DataObject = 'd_pdt_05550_02'
   dw_print.DataObject = 'd_pdt_05550_02_p'
else
   dw_list.DataObject = 'd_pdt_05550_03'
   dw_print.DataObject = 'd_pdt_05550_03_p'  
end if
dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
dw_print.object.txt_ymd.text = String(sdate, "@@@@.@@.@@") + " - " + String(edate, "@@@@.@@.@@")

if dw_print.Retrieve(gs_sabu, sdate, edate, fitnbr, titnbr, cvcod1, cvcod2, ls_gubun) <= 0 then
	f_message_chk(50,'[품목별 외주 지급 현황]')
	dw_ip.Setfocus()
	return -1
Else
	dw_list.Retrieve(gs_sabu, sdate, edate, fitnbr, titnbr, cvcod1, cvcod2, ls_gubun)
end if

dw_list.setredraw(true)
// dw_print.sharedata(dw_list)

return 1
end function

on w_pdt_05550.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
end on

on w_pdt_05550.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.pb_2)
end on

event open;Integer  li_idx

//li_idx = w_mdi_frame.dw_listbar.InsertRow(0)
//w_mdi_frame.dw_listbar.SetItem(li_idx,'window_id',Upper(This.ClassName()))
//w_mdi_frame.dw_listbar.SetItem(li_idx,'window_name',Upper(This.Title))
//w_mdi_frame.Postevent("ue_barrefresh")

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
dw_print.object.datawindow.print.preview = "yes"

dw_ip.setitem(1, 'sdate', left(is_today, 6)+'01')
dw_ip.setitem(1, 'edate', is_today)

end event

type dw_list from w_standard_print`dw_list within w_pdt_05550
integer height = 1964
string dataobject = "d_pdt_05550_02"
end type

type cb_print from w_standard_print`cb_print within w_pdt_05550
end type

type cb_excel from w_standard_print`cb_excel within w_pdt_05550
end type

type cb_preview from w_standard_print`cb_preview within w_pdt_05550
end type

type cb_1 from w_standard_print`cb_1 within w_pdt_05550
end type

type dw_print from w_standard_print`dw_print within w_pdt_05550
integer x = 3662
string dataobject = "d_pdt_05550_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_05550
integer y = 56
integer height = 188
string dataobject = "d_pdt_05550_01"
end type

event dw_ip::itemchanged;string s_cod, s_nam1, s_nam2
integer i_rtn
string  sitnbr, sitdsc, sispec, s_gub, snull
int     ireturn

s_cod = Trim(this.GetText()) 

if this.GetColumnName() = "cvcod1" then
	i_rtn = f_get_name2("V0", "N", s_cod, s_nam1, s_nam2)
	this.SetItem(1,"cvcod1",s_cod)
	this.SetItem(1,"cvnam1",s_nam1)
	return i_rtn 
elseif this.GetColumnName() = "cvcod2" then
	i_rtn = f_get_name2("V0", "N", s_cod, s_nam1, s_nam2)
	this.SetItem(1,"cvcod2",s_cod)
	this.SetItem(1,"cvnam2",s_nam1)
	return i_rtn 
ELSEIF this.GetColumnName() = "fr_itnbr"	THEN
	sItnbr = trim(this.GetText())
	ireturn = f_get_name2('품번', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "fr_itnbr", sitnbr)	
	this.setitem(1, "fr_itdsc", sitdsc)	
	this.setitem(1, "fr_ispec", sispec)
	this.setitem(1, "to_itnbr", sitnbr)	
	this.setitem(1, "to_itdsc", sitdsc)	
	this.setitem(1, "to_ispec", sispec)	
	RETURN ireturn
ELSEIF this.GetColumnName() = "fr_itdsc"	THEN
	sItdsc = trim(this.GetText())
	ireturn = f_get_name2('품명', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "fr_itnbr", sitnbr)	
	this.setitem(1, "fr_itdsc", sitdsc)	
	this.setitem(1, "fr_ispec", sispec)
	this.setitem(1, "to_itnbr", sitnbr)	
	this.setitem(1, "to_itdsc", sitdsc)	
	this.setitem(1, "to_ispec", sispec)	
	RETURN ireturn
ELSEIF this.GetColumnName() = "fr_ispec"	THEN
	sIspec = trim(this.GetText())
	ireturn = f_get_name2('규격', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "fr_itnbr", sitnbr)	
	this.setitem(1, "fr_itdsc", sitdsc)	
	this.setitem(1, "fr_ispec", sispec)
	this.setitem(1, "to_itnbr", sitnbr)	
	this.setitem(1, "to_itdsc", sitdsc)	
	this.setitem(1, "to_ispec", sispec)	
	RETURN ireturn
ELSEIF this.GetColumnName() = "to_itnbr"	THEN
	sItnbr = trim(this.GetText())
	ireturn = f_get_name2('품번', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "to_itnbr", sitnbr)	
	this.setitem(1, "to_itdsc", sitdsc)	
	this.setitem(1, "to_ispec", sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "to_itdsc"	THEN
	sItdsc = trim(this.GetText())
	ireturn = f_get_name2('품명', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "to_itnbr", sitnbr)	
	this.setitem(1, "to_itdsc", sitdsc)	
	this.setitem(1, "to_ispec", sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "to_ispec"	THEN
	sIspec = trim(this.GetText())
	ireturn = f_get_name2('규격', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "to_itnbr", sitnbr)	
	this.setitem(1, "to_itdsc", sitdsc)	
	this.setitem(1, "to_ispec", sispec)
	RETURN ireturn
elseif this.GetColumnName() = "sdate" then
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[지급일자 FROM]")
		this.object.sdate[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "edate" then
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[지급일자 TO]")
		this.object.edate[1] = ""
		return 1
	end if
end if


end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;SetNull(gs_Gubun)
SetNull(gs_code)
SetNull(gs_codename)

IF	this.getcolumnname() = "cvcod1"	THEN		
	gs_gubun ='1'
	open(w_vndmst_popup)
   if gs_code = '' or isnull(gs_code) then return 	
	this.SetItem(1, "cvcod1", gs_code)
	this.SetItem(1, "cvnam1", gs_codename)
ELSEIF this.getcolumnname() = "cvcod2"	THEN		
	gs_gubun ='1'
	open(w_vndmst_popup)
   if gs_code = '' or isnull(gs_code) then return 	
	this.SetItem(1, "cvcod2", gs_code)
	this.SetItem(1, "cvnam2", gs_codename)
ELSEif this.GetColumnName() = 'fr_itnbr' then
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"fr_itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)
elseif this.GetColumnName() = 'to_itnbr' then
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"to_itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)
END IF
end event

type r_1 from w_standard_print`r_1 within w_pdt_05550
end type

type r_2 from w_standard_print`r_2 within w_pdt_05550
end type

type pb_1 from u_pb_cal within w_pdt_05550
integer x = 1595
integer y = 48
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.Setcolumn('sdate')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_ip.SetItem(1, 'sdate', gs_code)
end event

type pb_2 from u_pb_cal within w_pdt_05550
integer x = 2030
integer y = 48
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.Setcolumn('edate')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_ip.SetItem(1, 'edate', gs_code)
end event

