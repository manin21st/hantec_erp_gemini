$PBExportHeader$w_imt_02680.srw
$PBExportComments$발주 확정 취소 이력 현황
forward
global type w_imt_02680 from w_standard_print
end type
type pb_1 from u_pic_cal within w_imt_02680
end type
type pb_2 from u_pic_cal within w_imt_02680
end type
end forward

global type w_imt_02680 from w_standard_print
string title = "발주 확정 취소 이력 현황"
pb_1 pb_1
pb_2 pb_2
end type
global w_imt_02680 w_imt_02680

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String s_frdate, s_todate, ssaupj
String cvcod1, cvcod2, emp1, emp2
long lcnt

if dw_ip.AcceptText() = -1 then return -1

s_frdate = trim(dw_ip.GetItemString(1, "fr_date"))
s_todate = trim(dw_ip.GetItemString(1, "to_date"))

cvcod1 = trim(dw_ip.GetItemString(1, "cvcod1"))
cvcod2 = trim(dw_ip.GetItemString(1, "cvcod2"))
emp1   = trim(dw_ip.GetItemString(1, "emp1"))
emp2   = trim(dw_ip.GetItemString(1, "emp2"))
ssaupj = dw_ip.GetItemString(1, "saupj")

IF s_frdate = "" OR IsNull(s_frdate) THEN 
	s_frdate = '10000101'
END IF
IF s_todate = "" OR IsNull(s_todate) THEN 
	s_todate = '99991231'
END IF

if s_frdate > s_todate then 
	f_message_chk(34,'[취소일자]')
	dw_ip.Setcolumn('fr_date')
	dw_ip.SetFocus()
	return -1
end if	

IF IsNull(cvcod1) or cvcod1 = "" then cvcod1 = "."
IF IsNull(cvcod2) or cvcod2 = "" then cvcod2 = "ZZZZZZ"
IF IsNull(emp1) or emp1 = "" then emp1 = "."
IF IsNull(emp2) or emp2 = "" then emp2 = "ZZZZZZ"

lcnt =  dw_print.Retrieve(gs_sabu, s_frdate,s_todate, cvcod1, cvcod2, emp1, emp2, ssaupj) 

if lcnt < 1 then
	f_message_chk(50,'')
	dw_ip.Setcolumn('fr_date')
	dw_ip.Setfocus()
	return -1
else
	dw_print.ShareData(dw_list)
end if	

return 1

end function

on w_imt_02680.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
end on

on w_imt_02680.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.pb_2)
end on

event ue_open;call super::ue_open;dw_ip.setitem(1, 'fr_date', left(f_today(), 6) + '01' )
dw_ip.setitem(1, 'to_date', f_today() )

dw_ip.Setfocus()


end event

event open;integer  li_idx

is_today = f_today()
is_totime = f_totime() 

w_mdi_frame.sle_msg.Text = ""

is_window_id = this.ClassName() 

w_mdi_frame.st_window.Text = Upper(is_window_id)

idw_name = dw_list

SELECT nvl(A.OPEN_HISTORY, 'N') as OPEN_HISTORY, 
			A.IO_GUBUN 
  INTO :is_usegub,
  			:is_io_gubun 
  FROM SUB2_T A  
 WHERE A.WINDOW_NAME = :is_window_id;
 
if sqlca.sqlcode <> 0 then
	is_usegub = "N"
	is_io_gubun = ""
end if

IF is_usegub = "Y" THEN
	INSERT INTO PGM_HISTORY  
					(L_USERID,
					CDATE,       STIME,      WINDOW_NAME,
					EDATE,       ETIME,
					IPADD,       USER_NAME)  
		VALUES (:gs_userid,
					:is_today,     :is_totime,   :is_window_id,
					null,           null,
					:gs_ipaddress, :gs_comname);

   if sqlca.sqlcode = 0 then 
	   commit;
   else 	  
	   rollback;
   end if	  
end if

f_child_saupj(dw_ip,'emp1',gs_saupj)
f_child_saupj(dw_ip,'emp2',gs_saupj)

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

dw_print.ShareData(dw_list)

f_mod_saupj(dw_ip,'saupj')
PostEvent('ue_open')
end event

type dw_list from w_standard_print`dw_list within w_imt_02680
integer y = 420
integer width = 3489
integer height = 1964
string dataobject = "d_imt_02680_1"
end type

type cb_print from w_standard_print`cb_print within w_imt_02680
end type

type cb_excel from w_standard_print`cb_excel within w_imt_02680
end type

type cb_preview from w_standard_print`cb_preview within w_imt_02680
end type

type cb_1 from w_standard_print`cb_1 within w_imt_02680
end type

type dw_print from w_standard_print`dw_print within w_imt_02680
string dataobject = "d_imt_02680_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_02680
integer y = 56
integer width = 3489
integer height = 324
integer taborder = 20
string dataobject = "d_imt_02680_a"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::itemchanged;string  s_cod, s_nam1, s_nam2, sdate, snull
integer i_rtn

setnull(snull)
s_cod = trim(this.GetText())

IF this.GetColumnName() = "fr_date"	THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[취소일자 FROM]')
		this.setitem(1, "fr_date", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = "to_date"	THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[취소일자 TO]')
		this.setitem(1, "to_date", sNull)
		return 1
	END IF
elseif this.getcolumnname() = 'cvcod1' then   
	i_rtn = f_get_name2("V0", "N", s_cod, s_nam1, s_nam2)
	this.setitem(1,"cvcod1", s_cod)		
   this.setitem(1,"cvnam1", s_nam1)
	return i_rtn
elseif this.getcolumnname() = 'cvcod2' then   
	i_rtn = f_get_name2("V0", "N", s_cod, s_nam1, s_nam2)
	this.setitem(1,"cvcod2", s_cod)		
   this.setitem(1,"cvnam2", s_nam1)
	return i_rtn
elseif getcolumnname() = 'saupj' then
	s_cod = gettext()
	f_child_saupj(dw_ip,'emp1',gs_saupj)
	f_child_saupj(dw_ip,'emp2',gs_saupj)
END IF
return
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

IF this.getcolumnname() = "cvcod1"	THEN		
	gs_gubun = '1' 
	open(w_vndmst_popup)
	
	if gs_code = '' or isnull(gs_code) then return 
	
	this.SetItem(1, "cvcod1", gs_code)
	this.SetItem(1, "cvnam1", gs_codename)
ELSEIF this.getcolumnname() = "cvcod2"	THEN		
	gs_gubun = '1' 
	open(w_vndmst_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.SetItem(1, "cvcod2", gs_code)
	this.SetItem(1, "cvnam2", gs_codename)
END IF
end event

type r_1 from w_standard_print`r_1 within w_imt_02680
integer y = 416
end type

type r_2 from w_standard_print`r_2 within w_imt_02680
integer height = 332
end type

type pb_1 from u_pic_cal within w_imt_02680
integer x = 1659
integer y = 92
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('fr_date')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'fr_date', gs_code)



end event

type pb_2 from u_pic_cal within w_imt_02680
integer x = 2117
integer y = 92
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('to_date')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'to_date', gs_code)



end event

