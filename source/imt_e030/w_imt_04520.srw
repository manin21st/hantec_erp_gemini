$PBExportHeader$w_imt_04520.srw
$PBExportComments$품목분류별 매입금액 현황(상세-출력)
forward
global type w_imt_04520 from w_standard_print
end type
type pb_1 from u_pb_cal within w_imt_04520
end type
type pb_2 from u_pb_cal within w_imt_04520
end type
type rr_1 from roundrectangle within w_imt_04520
end type
end forward

global type w_imt_04520 from w_standard_print
string title = "품목분류별 매입금액 현황"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_imt_04520 w_imt_04520

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string   s_frmipgo, s_toipgo, s_frmitcls, s_toitcls, s_ipgogbn, s_ittyp, swaigu , s_saupj

if dw_ip.AcceptText() = -1 then return -1

s_saupj    = dw_ip.GetItemString(1,"saupj")
s_frmipgo  = trim(dw_ip.GetItemString(1,"frmipgo"))
s_toipgo   = trim(dw_ip.GetItemString(1,"toipgo"))
s_frmitcls = trim(dw_ip.GetItemString(1,"frmitcls"))
s_toitcls  = trim(dw_ip.GetItemString(1,"toitcls"))
s_ipgogbn  = dw_ip.GetItemString(1,"ipgogbn")
s_ittyp    = dw_ip.GetItemString(1,"ittypcod")
swaigu     = dw_ip.GetItemString(1,"maip")

IF (IsNull(s_frmipgo) OR s_frmipgo = "") then s_frmipgo = '10000101'

IF (IsNull(s_toipgo) OR s_toipgo = "")   then s_toipgo = '99991231'
 
if	(IsNull(s_ittyp) OR s_ittyp = "")   THEN 
	f_message_chk(30,"[품목구분]")
	dw_ip.SetColumn('ittypcod')
	dw_ip.SetFocus()
	return -1
END IF

if (IsNull(s_saupj) or s_saupj = "" ) then 
	f_message_chk(30, "[사업장]" )
	dw_ip.SetColumn('saupj')
	dw_ip.Setfocus()
	return -1
end if

//품목분류범위
IF (IsNull(s_frmitcls) OR s_frmitcls = "") THEN	s_frmitcls = "."
IF (IsNull(s_toitcls) OR s_toitcls = "")  THEN	s_toitcls  = "9999999"

IF (IsNull(s_ipgogbn) OR s_ipgogbn = "") THEN s_ipgogbn = "%"

/* filtering */
IF s_frmitcls = '.' and s_toitcls = '9999999' then 
	dw_PRINT.setfilter("")
ELSE
	dw_PRINT.setfilter("filname >= '"+ s_frmitcls +"' and filname <= '"+ s_toitcls +"'")
END IF
dw_PRINT.filter()

dw_PRINT.Retrieve(gs_sabu, s_frmipgo, s_toipgo, s_ipgogbn, s_ittyp, swaigu , s_saupj) 

dw_PRINT.ShareData(dw_LIST)

if dw_list.rowcount() < 1 then
	f_message_chk(50, "[품목분류별 매입금액 현황(상세)]")
	dw_ip.SetColumn('frmipgo')
	dw_ip.SetFocus()
	return -1
END IF

Return 1

end function

on w_imt_04520.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_1
end on

on w_imt_04520.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;is_window_id = Message.StringParm	
is_today = f_today()
is_totime = f_totime()


st_window.Text = is_window_id

SELECT "SUB2_T"."OPEN_HISTORY"  
  INTO :is_usegub 
  FROM "SUB2_T"  
 WHERE "SUB2_T"."WINDOW_NAME" = :is_window_id   ;

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
datawindowchild dws
dw_ip.getchild("ipgogbn", dws)
dws.settransobject(sqlca)
dws.retrieve(gs_sabu, '007')	/* 매입분만 출력 */


dw_ip.Reset()
dw_ip.InsertRow(0)

dw_PRINT.settransobject(sqlca)

//sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 가로방향"
string  s_today, s_frmipgo, s_toipgo

s_frmipgo = Mid(f_today(),1,6) + "01"
s_toipgo  = f_today()

//초기화
dw_ip.SetItem(1, "frmipgo", s_frmipgo)		
dw_ip.SetItem(1, "toipgo", s_toipgo)

end event

type p_preview from w_standard_print`p_preview within w_imt_04520
end type

type p_exit from w_standard_print`p_exit within w_imt_04520
end type

type p_print from w_standard_print`p_print within w_imt_04520
end type

type p_retrieve from w_standard_print`p_retrieve within w_imt_04520
end type







type st_10 from w_standard_print`st_10 within w_imt_04520
end type



type dw_print from w_standard_print`dw_print within w_imt_04520
integer x = 4146
integer y = 204
string dataobject = "d_imt_04521_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_04520
integer x = 9
integer y = 12
integer width = 3849
integer height = 324
string dataobject = "d_imt_04520"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;string snull, s_col, s_cod, s_nam

sle_msg.Text = ""
this.AcceptText()
SetNull(snull)

s_col = this.GetColumnName()
if s_col = "frmipgo" then
	if IsNull(trim(this.object.frmipgo[1])) or trim(this.object.frmipgo[1]) = "" then return 
	if f_datechk(trim(this.object.frmipgo[1])) = -1 then
		messagebox("확인","날짜입력에러![" + trim(this.object.frmipgo[1]) + "]")
		this.object.frmipgo[1] = ""
		return 1
	end if
elseif s_col = "toipgo" then
	if IsNull(trim(this.object.toipgo[1])) or trim(this.object.toipgo[1]) = "" then return 
	if f_datechk(trim(this.object.toipgo[1])) = -1 then
		messagebox("확인","날짜입력에러![" + trim(this.object.toipgo[1]) + "]")
		this.object.toipgo[1] = ""
		return 1
	end if
// 
ELSEIF s_col = 'frmitcls' THEN   
	s_cod = Trim(this.GetText())
	IF IsNull(s_cod) OR s_cod = "" THEN 
		this.SetItem(1,"frmitclsnam",snull)		
		this.SetItem(1,"frmitcls",snull)
		return
	END IF
	
	SELECT TITNM
     INTO :s_nam
     FROM ITNCT  
    WHERE ITCLS = :s_cod;                    

	IF sqlca.sqlcode = 0 THEN
		this.SetItem(1,"frmitclsnam",s_nam)
	ELSE
		this.SetItem(1,"frmitclsnam",snull)		
	END IF
	
// 
ELSEIF s_col = 'toitcls' THEN   
	s_cod = Trim(this.GetText())
	IF IsNull(s_cod) OR s_cod = "" THEN
		this.SetItem(1,"frmitcls",snull)
		this.SetItem(1,"frmitclsnam",snull)		
		return
	END IF
	
	SELECT TITNM
     INTO :s_nam
     FROM ITNCT  
    WHERE ITCLS = :s_cod;                    

	IF sqlca.sqlcode = 0 THEN
		this.SetItem(1,"toitclsnam",s_nam)
	ELSE
		this.SetItem(1,"toitclsnam",snull)		
	END IF
END IF	
	
	

end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
gs_gubun = ''
string	sName

str_itnct lstr_sitnct

if this.GetColumnName() = 'frmitcls' then
   this.accepttext()
	
	sname = this.GetItemString(1, 'ittypcod')  // 품목구분 
	OpenWithParm(w_ittyp_popup, sname)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"frmitcls", lstr_sitnct.s_sumgub)
	this.SetItem(1,"frmitclsnam", lstr_sitnct.s_titnm)

end if


if this.GetColumnName() = 'toitcls' then
   this.accepttext()
	sname = this.GetItemString(1, 'ittypcod')
	OpenWithParm(w_ittyp_popup, sname)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"toitcls", lstr_sitnct.s_sumgub)
	this.SetItem(1,"toitclsnam", lstr_sitnct.s_titnm)

end if


end event

type dw_list from w_standard_print`dw_list within w_imt_04520
integer x = 27
integer y = 352
integer width = 4562
integer height = 1980
string dataobject = "d_imt_04521"
boolean border = false
end type

type pb_1 from u_pb_cal within w_imt_04520
integer x = 622
integer y = 204
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('frmipgo')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'frmipgo', gs_code)



end event

type pb_2 from u_pb_cal within w_imt_04520
integer x = 1047
integer y = 204
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('toipgo')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'toipgo', gs_code)



end event

type rr_1 from roundrectangle within w_imt_04520
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 344
integer width = 4594
integer height = 2000
integer cornerheight = 40
integer cornerwidth = 55
end type

