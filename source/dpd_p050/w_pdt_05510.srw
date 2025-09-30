$PBExportHeader$w_pdt_05510.srw
$PBExportComments$** 외주/자재소요현황
forward
global type w_pdt_05510 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdt_05510
end type
end forward

global type w_pdt_05510 from w_standard_print
string title = "외주/자재 소요 현황"
rr_1 rr_1
end type
global w_pdt_05510 w_pdt_05510

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string  ym, cvcod1, cvcod2, fitnbr, titnbr, sgub, ls_gubun

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

cvcod1 = trim(dw_ip.object.cvcod1[1])
cvcod2 = trim(dw_ip.object.cvcod2[1])
fitnbr = trim(dw_ip.object.fr_itnbr[1])
titnbr = trim(dw_ip.object.to_itnbr[1])
sgub   = trim(dw_ip.object.sgub[1])
ym     = Trim(dw_ip.object.ym[1])
ls_gubun   = trim(dw_ip.object.gubun[1])

if (IsNull(ym) or ym = "")  then 
	f_message_chk(30, "[기준년월]")
	dw_ip.SetColumn("ym")
	dw_ip.SetFocus()
	return -1
end if	

if (IsNull(cvcod1) or cvcod1 = "")  then cvcod1 = "."
if (IsNull(cvcod2) or cvcod2 = "")  then cvcod2 = "zzzzzz"

if (IsNull(fitnbr) or fitnbr = "")  then fitnbr = "."
if (IsNull(titnbr) or titnbr = "")  then titnbr = "zzzzzzzzzzzzzzz"

dw_print.setredraw(false)
dw_list.setredraw(false)

if sgub = '1' then //거래처순
   dw_list.DataObject = 'd_pdt_05510_02'
   dw_print.DataObject = 'd_pdt_05510_02_p'
else
   dw_list.DataObject = 'd_pdt_05510_03'
   dw_print.DataObject = 'd_pdt_05510_03_p'  
end if
dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)


if dw_print.Retrieve(gs_sabu, ym, cvcod1, cvcod2, fitnbr, titnbr, ls_gubun) <= 0 then
	f_message_chk(50,"[외주/자재 소요 현황]")
	dw_ip.Setfocus()
	return -1
Else
	dw_list.Retrieve(gs_sabu, ym, cvcod1, cvcod2, fitnbr, titnbr, ls_gubun)
end if

dw_print.setredraw(true)
dw_list.setredraw(true)

//   dw_print.ShareData(dw_list)
   
return 1
end function

on w_pdt_05510.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdt_05510.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
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
dw_print.object.datawindow.print.preview = "yes"	

//dw_print.ShareData(dw_list)
end event

type p_preview from w_standard_print`p_preview within w_pdt_05510
end type

type p_exit from w_standard_print`p_exit within w_pdt_05510
end type

type p_print from w_standard_print`p_print within w_pdt_05510
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_05510
end type







type st_10 from w_standard_print`st_10 within w_pdt_05510
end type



type dw_print from w_standard_print`dw_print within w_pdt_05510
string dataobject = "d_pdt_05510_02_P"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_05510
integer x = 105
integer y = 192
integer width = 4471
integer height = 188
string dataobject = "d_pdt_05510_01"
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
ELSEIF this.GetColumnName() = "ym" then
	IF IsNull(s_cod) or s_cod = "" THEN RETURN 
	
	if f_datechk(s_cod + "01") = -1 then
		f_message_chk(35, "[기준년월]")
		this.object.ym[1] = ""
		return 1
	end if
END IF
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

type dw_list from w_standard_print`dw_list within w_pdt_05510
integer x = 119
integer y = 416
integer width = 4453
integer height = 1880
string dataobject = "d_pdt_05510_02"
boolean border = false
end type

type rr_1 from roundrectangle within w_pdt_05510
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 105
integer y = 404
integer width = 4480
integer height = 1904
integer cornerheight = 40
integer cornerwidth = 55
end type

