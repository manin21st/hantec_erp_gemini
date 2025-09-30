$PBExportHeader$w_sal_t_10210.srw
$PBExportComments$주간 판매 계획서
forward
global type w_sal_t_10210 from w_standard_print
end type
type pb_1 from u_pb_cal within w_sal_t_10210
end type
type rr_1 from roundrectangle within w_sal_t_10210
end type
end forward

global type w_sal_t_10210 from w_standard_print
integer height = 2440
string title = "주간 판매 계획서"
pb_1 pb_1
rr_1 rr_1
end type
global w_sal_t_10210 w_sal_t_10210

forward prototypes
public function string wf_aftermonth (string syymm, integer n)
public function integer wf_retrieve ()
end prototypes

public function string wf_aftermonth (string syymm, integer n);string stemp

stemp = f_aftermonth(syymm,n)
stemp = Mid(stemp,1,4) + '~r~n' + Right(stemp,2)

return stemp

end function

public function integer wf_retrieve ();string	ls_ymd, ls_cvcod_from, ls_cvcod_to, ls_salegu, ls_porgu, ls_min_date

If dw_ip.accepttext() <> 1 Then Return -1

dw_list.reset()
dw_print.reset()

ls_ymd         = trim(dw_ip.getitemstring(1, 'plan_ymd'))
ls_cvcod_from  = trim(dw_ip.getitemstring(1, 'cvcod_from'))
ls_porgu	      = trim(dw_ip.getitemstring(1, 'porgu'))

If IsNull(ls_cvcod_from)  Then ls_cvcod_from = '%'

IF	f_datechk(ls_ymd) = -1 then
	MessageBox("확인","기준년월을 확인하세요!")
	dw_ip.setcolumn('plan_ymd')
	dw_ip.setfocus()
	Return -1
END IF

dw_print.SetRedraw(False)
dw_list.SetRedraw(False)

if dw_print.retrieve(gs_sabu, ls_cvcod_from, ls_ymd, ls_porgu) < 1	then
	f_message_chk(50," [주간 판매/납품 계획서] ")
	dw_ip.setcolumn('plan_ymd')
	dw_ip.setfocus()
	return -1
end if

select min(plan_weekhist)
into :ls_min_date
from weeksaplan
where plan_ymd= :ls_ymd;

dw_print.Object.t_100.text = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(porgu) ', 1)"))
dw_print.Object.t_50.text = left(ls_min_date,4) + '.' + mid(ls_min_date,5,2) + '.' + right(ls_min_date,2)

dw_list.retrieve(gs_sabu, ls_cvcod_from, ls_ymd, ls_porgu)

dw_print.SetRedraw(True)
dw_list.SetRedraw(True)
//dw_print.sharedata(dw_list)

Return 1
end function

on w_sal_t_10210.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_sal_t_10210.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;Integer  li_idx

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
dw_ip.setitem(1, 'porgu', gs_saupj )

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

dw_ip.SetItem(1,'plan_ymd',Left(f_today(),8))

//사업장 고정
setnull(gs_code)
f_mod_saupj(dw_ip, 'porgu')
sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 가로방향"


end event

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

PostEvent('ue_open')
end event

type p_preview from w_standard_print`p_preview within w_sal_t_10210
end type

type p_exit from w_standard_print`p_exit within w_sal_t_10210
end type

type p_print from w_standard_print`p_print within w_sal_t_10210
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_t_10210
end type

type st_window from w_standard_print`st_window within w_sal_t_10210
boolean visible = true
end type

type sle_msg from w_standard_print`sle_msg within w_sal_t_10210
boolean visible = true
end type

type dw_datetime from w_standard_print`dw_datetime within w_sal_t_10210
boolean visible = true
end type

type st_10 from w_standard_print`st_10 within w_sal_t_10210
boolean visible = true
end type

type gb_10 from w_standard_print`gb_10 within w_sal_t_10210
boolean visible = true
end type

type dw_print from w_standard_print`dw_print within w_sal_t_10210
string dataobject = "d_sal_t_10210_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_t_10210
integer x = 78
integer y = 32
integer width = 3479
integer height = 180
string dataobject = "d_sal_t_10210_h"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String  sIoCust, sIoCustArea, sIoCustName, sDept, sDeptname, ls_saupj
String  sCvcod, scvnas, sarea, steam, sSaupj, sName1
String  sDateFrom, sDateTo, snull, sPrtGbn, sSummary

this.acceptText()

SetNull(snull)

Choose Case GetColumnName() 
	Case"plan_ymd"
		sDateFrom = Trim(this.GetText())
		IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
		
		IF f_datechk(sDateFrom) = -1 THEN
			f_message_chk(35,'[기준일자]')
			this.SetItem(1,"plan_ymd",snull)
			Return 1
		END IF
		
	/* 거래처 */
	Case "cvcod_from"
		sCvcod = this.GetText()
		If 	f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod_from', sNull)
			SetItem(1, 'cvcod_fname', snull)
			Return 1
		ELSE
			ls_saupj = dw_ip.object.porgu[1] 
			if ls_saupj = sSaupj or ls_saupj = '%' then 
				SetItem(1,"cvcod_from",  		sCvcod)
				SetItem(1,"cvcod_fname",		scvnas)
			else
				Messagebox('확인', scvnas + '[ ' + sCvcod +  ' ]에 등록된 사업장 다릅니다. ~n 사업장 정보를 확인하세요' )
				
			End if 
		END IF
	
	case 'porgu' 
		STRING ls_return, ls_sarea , ls_steam  
		ls_saupj = gettext() 
		//거래처
		sCvcod 	= this.object.cvcod_from[1] 
		f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1)
		if ls_saupj <> ssaupj and ls_saupj <> '%' then 
			SetItem(1, 'cvcod_from', sNull)
			SetItem(1, 'cvcod_fname', snull)
		End if 

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

type dw_list from w_standard_print`dw_list within w_sal_t_10210
integer x = 91
integer y = 244
integer width = 4498
integer height = 2000
string dataobject = "d_sal_t_10210_d"
boolean border = false
boolean hsplitscroll = false
end type

event dw_list::retrievestart;This.SetRedraw(False)
end event

event dw_list::retrieveend;This.SetRedraw(True)
end event

type pb_1 from u_pb_cal within w_sal_t_10210
integer x = 827
integer y = 60
integer width = 78
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('plan_ymd')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'plan_ymd', gs_code)

end event

type rr_1 from roundrectangle within w_sal_t_10210
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 78
integer y = 232
integer width = 4530
integer height = 2032
integer cornerheight = 40
integer cornerwidth = 55
end type

