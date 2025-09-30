$PBExportHeader$w_imt_10020.srw
$PBExportComments$주간 구매 계획서
forward
global type w_imt_10020 from w_standard_print
end type
type pb_1 from u_pb_cal within w_imt_10020
end type
type rr_1 from roundrectangle within w_imt_10020
end type
end forward

global type w_imt_10020 from w_standard_print
string title = "주간 구매 계획서"
pb_1 pb_1
rr_1 rr_1
end type
global w_imt_10020 w_imt_10020

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string	ls_ymd, ls_porgu, ls_cvcod1, ls_cvcod2, ls_empno

If dw_ip.accepttext() <> 1 Then Return -1

dw_list.reset()
dw_print.reset()

ls_ymd         = trim(dw_ip.getitemstring(1, 'prod_ymd'))
ls_porgu	      = trim(dw_ip.getitemstring(1, 'porgu'))
ls_cvcod1	   = trim(dw_ip.getitemstring(1, 'cvcod1'))
ls_cvcod2      = trim(dw_ip.getitemstring(1, 'cvcod2'))
ls_empno	      = trim(dw_ip.getitemstring(1, 'empno'))

IF	f_datechk(ls_ymd) = -1 then
	MessageBox("확인","기준년월을 확인하세요!")
	dw_ip.setcolumn('prod_ymd')
	dw_ip.setfocus()
	Return -1
END IF

if isnull( Ls_Cvcod1 ) or Trim( Ls_Cvcod1 ) = '' then
	ls_cvcod1 = '.'
End if

if isnull( Ls_Cvcod2 ) or Trim( Ls_Cvcod2 ) = '' then
	ls_cvcod2 = 'ZZZZZZ'
End if

if isnull( Ls_empno ) or Trim( Ls_empno ) = '' then
	ls_empno = '%'
End if


if dw_print.retrieve(gs_sabu, ls_ymd, ls_porgu, ls_cvcod1, ls_cvcod2, ls_empno) < 1	then
	f_message_chk(50," [주간 구매 계획서] ")
	dw_ip.setcolumn('prod_ymd')
	dw_ip.setfocus()
	return -1
end if

dw_list.retrieve(gs_sabu, ls_ymd, ls_porgu, ls_cvcod1, ls_cvcod2, ls_empno)


Return 1
end function

on w_imt_10020.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_imt_10020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
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

f_child_saupj(dw_ip,'empno', gs_Saupj)

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
			
			dw_ip.Modify("porgu.protect = 1")
		ELSE
			dw_ip.Modify("porgu.protect = 0")
		END IF	
	END IF
END IF

dw_print.object.datawindow.print.preview = "yes"	
//dw_print.ShareData(dw_list)

dw_ip.SetItem(1,'prod_ymd',Left(f_today(),8))

/* 부가 사업장 */
f_mod_saupj(dw_ip,'porgu')

postevent('ue_open')
end event

type p_preview from w_standard_print`p_preview within w_imt_10020
integer x = 4073
end type

type p_exit from w_standard_print`p_exit within w_imt_10020
integer x = 4421
end type

type p_print from w_standard_print`p_print within w_imt_10020
integer x = 4247
end type

type p_retrieve from w_standard_print`p_retrieve within w_imt_10020
integer x = 3899
end type







type st_10 from w_standard_print`st_10 within w_imt_10020
end type



type dw_print from w_standard_print`dw_print within w_imt_10020
integer x = 3707
string dataobject = "d_imt_10020_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_10020
integer x = 55
integer y = 32
integer width = 3383
integer height = 164
string dataobject = "d_imt_10020_h"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String  sIoCust, sIoCustArea, sIoCustName, sDept, sDeptname
String  sDateFrom, sDateTo, snull, sPrtGbn, sSummary

this.acceptText()

SetNull(snull)

Choose Case GetColumnName() 
	Case"prod_ymd"
		sDateFrom = Trim(this.GetText())
		IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
		
		IF f_datechk(sDateFrom) = -1 THEN
			f_message_chk(30,'[ 기준일자 ]')
			this.SetItem(1,"prod_ymd",snull)
			Return 1
		END IF
	case "porgu"
		sdatefrom = gettext()
		f_child_saupj(dw_ip,'empno',sdatefrom)
END Choose
end event

event dw_ip::rbuttondown;string sIoCustName,sIoCustArea,sDept

SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case this.GetColumnName() 
	/* 거래처 */
	Case "cvcod1"
		gs_gubun = '1'
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		this.SetItem(1,"cvcod1",gs_code)
	Case "cvcod2"
		gs_gubun = '1'
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		this.SetItem(1,"cvcod2",gs_code)
END Choose

end event

event dw_ip::ue_key;call super::ue_key;choose case key
	case keyenter!
		p_retrieve.TriggerEvent(Clicked!)
end choose
end event

type dw_list from w_standard_print`dw_list within w_imt_10020
integer x = 69
integer y = 244
integer width = 4498
integer height = 2000
string dataobject = "d_imt_10020_d"
boolean border = false
boolean hsplitscroll = false
end type

event dw_list::retrievestart;This.SetRedraw(False)
end event

event dw_list::retrieveend;This.SetRedraw(True)
end event

type pb_1 from u_pb_cal within w_imt_10020
integer x = 718
integer y = 52
integer taborder = 10
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('prod_ymd')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'prod_ymd', gs_code)



end event

type rr_1 from roundrectangle within w_imt_10020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 232
integer width = 4530
integer height = 2032
integer cornerheight = 40
integer cornerwidth = 55
end type

