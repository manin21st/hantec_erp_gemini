$PBExportHeader$w_pdt_10005.srw
$PBExportComments$주간 생산 계획서
forward
global type w_pdt_10005 from w_standard_print
end type
type pb_1 from u_pb_cal within w_pdt_10005
end type
type rr_1 from roundrectangle within w_pdt_10005
end type
end forward

global type w_pdt_10005 from w_standard_print
string title = "주간 생산 계획서"
pb_1 pb_1
rr_1 rr_1
end type
global w_pdt_10005 w_pdt_10005

forward prototypes
public function string wf_aftermonth (string syymm, integer n)
public function integer wf_retrieve ()
end prototypes

public function string wf_aftermonth (string syymm, integer n);string stemp

stemp = f_aftermonth(syymm,n)
stemp = Mid(stemp,1,4) + '~r~n' + Right(stemp,2)

return stemp

end function

public function integer wf_retrieve ();string	ls_ymd, ls_porgu, ls_pdtgu

If dw_ip.accepttext() <> 1 Then Return -1

dw_list.reset()
dw_print.reset()

ls_ymd         = trim(dw_ip.getitemstring(1, 'prod_ymd'))
ls_porgu	      = trim(dw_ip.getitemstring(1, 'porgu'))
ls_pdtgu	      = trim(dw_ip.getitemstring(1, 'pdtgu'))

IF	f_datechk(ls_ymd) = -1 then
	MessageBox("확인","기준년월을 확인하세요!")
	dw_ip.setcolumn('prod_ymd')
	dw_ip.setfocus()
	Return -1
END IF

/* 생산팀 구분 */
if Isnull(ls_pdtgu) or ls_pdtgu = '' then
	ls_pdtgu = '%'
end if

dw_print.SetRedraw(False)
dw_list.SetRedraw(False)

if dw_print.retrieve(gs_sabu, ls_ymd, ls_porgu, ls_pdtgu) < 1	then
	f_message_chk(50," [주간 생산 계획서] ")
	dw_ip.setcolumn('prod_ymd')
	dw_ip.setfocus()
	return -1
end if

dw_print.Object.t_100.text = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(porgu) ', 1)"))

dw_list.retrieve(gs_sabu, ls_ymd, ls_porgu, ls_pdtgu)

dw_print.SetRedraw(True)
dw_list.SetRedraw(True)
//dw_print.sharedata(dw_list)

Return 1
end function

on w_pdt_10005.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_pdt_10005.destroy
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

dw_ip.SetItem(1,'prod_ymd',Left(f_today(),8))

///* 부가 사업장 */
//setnull(gs_code)
//If f_check_saupj() = 1 Then
//	dw_ip.SetItem(1, 'porgu', gs_code)
//	if gs_code <> '%' then
//		dw_ip.Modify("porgu.protect=1")
//		dw_ip.Modify("porgu.background.color = 80859087")
//	End if
//End If

f_mod_saupj(dw_ip, 'porgu')
f_child_saupj(dw_ip, 'pdtgu', dw_ip.getitemstring(1,'porgu'))

sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 가로방향"
end event

type p_preview from w_standard_print`p_preview within w_pdt_10005
integer x = 4073
end type

type p_exit from w_standard_print`p_exit within w_pdt_10005
integer x = 4421
end type

type p_print from w_standard_print`p_print within w_pdt_10005
integer x = 4247
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_10005
integer x = 3899
end type







type st_10 from w_standard_print`st_10 within w_pdt_10005
end type



type dw_print from w_standard_print`dw_print within w_pdt_10005
integer x = 3707
string dataobject = "d_pdt_10005_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_10005
integer x = 55
integer y = 32
integer width = 2642
integer height = 164
string dataobject = "d_pdt_10005_h"
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
		f_child_saupj(dw_ip, 'pdtgu', gettext())
	/* 거래처 From */
//	Case "cvcod_from"
//		sIoCust = this.GetText()
//		IF sIoCust ="" OR IsNull(sIoCust) THEN
////			this.SetItem(1,"cvcod_from",snull)
//			this.SetItem(1,"cvcod_fname",snull)
//			Return
//		END IF
//		
//		SELECT "VNDMST"."CVNAS2"
//		  INTO :sIoCustName
//		  FROM "VNDMST"
//		 WHERE "VNDMST"."CVCOD" = :sIoCust;
//		IF SQLCA.SQLCODE <> 0 THEN
//			this.TriggerEvent(RbuttonDown!)
//			Return 2
//		ELSE
//			this.SetItem(1,"cvcod_fname",  sIoCustName)
//		END IF

END Choose
end event

event dw_ip::rbuttondown;string sIoCustName,sIoCustArea,sDept

SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case this.GetColumnName() 
	/* 거래처 */
	Case "cvcod_from"
		gs_gubun = '1'
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		this.SetItem(1,"cvcod_from",gs_code)
		this.SetItem(1,"cvcod_fname", gs_codename)
END Choose

end event

event dw_ip::ue_key;call super::ue_key;choose case key
	case keyenter!
		p_retrieve.TriggerEvent(Clicked!)
end choose
end event

type dw_list from w_standard_print`dw_list within w_pdt_10005
integer x = 69
integer y = 244
integer width = 4498
integer height = 2000
string dataobject = "d_pdt_10005_d"
boolean border = false
boolean hsplitscroll = false
end type

event dw_list::retrievestart;This.SetRedraw(False)
end event

event dw_list::retrieveend;This.SetRedraw(True)
end event

type pb_1 from u_pb_cal within w_pdt_10005
integer x = 1769
integer y = 64
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.Setcolumn('prod_ymd')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_ip.SetItem(1, 'prod_ymd', gs_code)
end event

type rr_1 from roundrectangle within w_pdt_10005
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

