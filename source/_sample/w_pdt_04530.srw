$PBExportHeader$w_pdt_04530.srw
$PBExportComments$**창고별 재고현황(출력)
forward
global type w_pdt_04530 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdt_04530
end type
end forward

global type w_pdt_04530 from w_standard_print
string title = "창고별 재고현황"
rr_1 rr_1
end type
global w_pdt_04530 w_pdt_04530

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string   s_ittyp, s_itnbr_cod1, s_itnbr_cod2, s_null, s_temp, gubun, s_gubun, s_sysdat, ls_porgu

SetNull(s_null)
dw_ip.AcceptText()

s_ittyp = dw_ip.GetItemString(1, 'ittyp_cod')
IF IsNull(s_ittyp) OR s_ittyp = "" THEN
   f_message_chk(40,"[창고별 재고현황]")
	dw_ip.SetFocus()
	return -1
END IF

s_ittyp      = Trim(dw_ip.GetItemString(1, 'ittyp_cod'))
s_itnbr_cod1 = Trim(dw_ip.GetItemString(1, 'itnbr_cod1'))
s_itnbr_cod2 = Trim(dw_ip.GetItemString(1, 'itnbr_cod2'))
gubun = Trim(dw_ip.object.gubun[1])
ls_porgu = Trim(dw_ip.GetItemString(1, 'porgu'))

//품번조회범위 설정
IF (IsNull(ls_porgu) OR ls_porgu = "" ) THEN ls_porgu = "%"
IF (IsNull(s_itnbr_cod1) OR s_itnbr_cod1 = "" ) THEN s_itnbr_cod1 = "."
IF (IsNull(s_itnbr_cod2) OR s_itnbr_cod2 = "" ) THEN s_itnbr_cod2 = "zzzzzzzzzzzz"
	
if gubun = "1" then
	s_gubun = "현재고"
elseif gubun = "2" then
	s_gubun = "가용재고"
elseif gubun = "3" then
	s_gubun = "예상재고"
end if	
s_sysdat = String(f_today(),"@@@@.@@.@@")

dw_list.SetReDraw(False)
//dw_list.SetFilter("totqty <> 0")
//dw_list.Filter( )

dw_print.object.txt_ymd.text = s_sysdat
dw_print.object.txt_gubun.text = s_gubun

IF dw_list.Retrieve( s_ittyp, s_itnbr_cod1, s_itnbr_cod2, gubun, ls_porgu) < 1 THEN
	f_message_chk(50,"[창고별 재고현황]")
	dw_ip.SetColumn('ittyp_cod')
	dw_ip.SetFocus()
	dw_list.SetReDraw(True)
	return -1
END IF
dw_list.SetReDraw(True)

IF dw_print.Retrieve( s_ittyp, s_itnbr_cod1, s_itnbr_cod2, gubun,ls_porgu) < 1 THEN
//	dw_print.insertrow(0)
	Return -1
END IF

Return 1
end function

on w_pdt_04530.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdt_04530.destroy
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

dw_print.object.datawindow.print.preview = "yes"	

string  snull

SetNull(snull)
dw_ip.SetItem(1, 'ittyp_cod', snull)

setnull(gs_code)
//If f_check_saupj() = 1 Then
//	dw_ip.SetItem(1, 'porgu', gs_code)
//	if gs_code <> '%' then
//		dw_ip.Modify("porgu.protect=1")
//		dw_ip.Modify("porgu.background.color = 80859087")
//	End if
//End If

f_mod_saupj(dw_ip, 'porgu')
end event

type p_preview from w_standard_print`p_preview within w_pdt_04530
end type

type p_exit from w_standard_print`p_exit within w_pdt_04530
end type

type p_print from w_standard_print`p_print within w_pdt_04530
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_04530
end type







type st_10 from w_standard_print`st_10 within w_pdt_04530
end type



type dw_print from w_standard_print`dw_print within w_pdt_04530
string dataobject = "d_pdt_04531_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_04530
integer x = 27
integer y = 0
integer width = 3410
string dataobject = "d_pdt_04530"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;SetNull(gs_Gubun)
SetNull(gs_code)
SetNull(gs_codename)

IF	this.GetColumnName() = "itnbr_cod1"	THEN		
	Open(w_itemas_popup3)
	IF IsNull(gs_code) OR gs_code = "" THEN  return
	this.SetItem(1, "itnbr_cod1", gs_code)
	this.SetItem(1, "itnbr_nam1", gs_codename)
	this.TriggerEvent(itemchanged!)
	return 1
ELSEIF this.GetColumnName() = "itnbr_cod2" THEN		
	Open(w_itemas_popup3)
	IF IsNull(gs_code) OR gs_code = "" THEN  return
	this.SetItem(1, "itnbr_cod2", gs_code)
	this.SetItem(1, "itnbr_nam2", gs_codename)
	this.TriggerEvent(itemchanged!)
	return 1	
END IF

end event

event dw_ip::itemchanged;string s_cod, s_nam1, s_nam2
integer i_rtn

s_cod = Trim(this.GetText())

IF this.GetColumnName() = 'itnbr_cod1' THEN   
	i_rtn = f_get_name2("품번", "N", s_cod, s_nam1, s_nam2)
	this.SetItem(1,"itnbr_cod1", s_cod)		
	this.SetItem(1,"itnbr_nam1", s_nam1)
	return i_rtn
ELSEIF this.GetColumnName() = 'itnbr_cod2' THEN   
	i_rtn = f_get_name2("품번", "N", s_cod, s_nam1, s_nam2)
	this.SetItem(1,"itnbr_cod2", s_cod)		
	this.SetItem(1,"itnbr_nam2", s_nam1)
	return i_rtn
END IF
return
end event

type dw_list from w_standard_print`dw_list within w_pdt_04530
integer x = 46
integer y = 300
integer width = 4539
integer height = 2020
string dataobject = "d_pdt_04531"
boolean border = false
end type

type rr_1 from roundrectangle within w_pdt_04530
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 292
integer width = 4567
integer height = 2040
integer cornerheight = 40
integer cornerwidth = 55
end type

