$PBExportHeader$w_sal_04060.srw
$PBExportComments$수금계획 대비 실적현황
forward
global type w_sal_04060 from w_standard_print
end type
type pb_1 from u_pb_cal within w_sal_04060
end type
type pb_2 from u_pb_cal within w_sal_04060
end type
type rr_1 from roundrectangle within w_sal_04060
end type
end forward

global type w_sal_04060 from w_standard_print
string title = "수금계획 대 실적현황"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_sal_04060 w_sal_04060

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_fdate, ls_tdate, ls_saupj, tx_name

If dw_ip.accepttext() <> 1 Then Return -1

ls_fdate  = Trim(dw_ip.getitemstring(1,"sdate"))
ls_tdate  = Trim(dw_ip.getitemstring(1,"edate"))
ls_saupj  = Trim(dw_ip.getitemstring(1,'saupj'))

//필수입력항목 체크///////////////////////////////////
If ls_saupj = "" Or Isnull(ls_saupj) Then 
	f_message_chk(30,'[사업장]')
end if
	
If ls_fdate = "" Or Isnull(ls_fdate) Then 	
	ls_fdate = '00000000'
end if	

If ls_tdate = "" Or Isnull(ls_tdate) Then 	
	ls_tdate = '99999999'
end if	

dw_list.SetRedraw(False)

IF dw_print.retrieve(gs_sabu, ls_saupj, ls_fdate, ls_tdate) <= 0 THEN
   f_message_chk(50,'['+This.title+']')
	dw_print.reset()
	dw_list.reset()
	dw_ip.setfocus()
	SetPointer(Arrow!)
	Return -1
END IF

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_saupj.text = '"+tx_name+"'")

dw_print.ShareData(dw_list)
dw_list.Modify("tx_saupj.text = '"+tx_name+"'")

dw_list.SetRedraw(True)

Return 0
end function

on w_sal_04060.create
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

on w_sal_04060.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;/* User별 관할구역 Setting */
String sarea, steam, saupj
Long   rtncode
datawindowchild state_child 

f_mod_saupj(dw_ip, 'saupj')

dw_ip.reset() 
dw_ip.insertrow(0) 
dw_ip.setitem(1, 'saupj', gs_saupj )

dw_ip.setitem(1,'sdate',left(f_today(),6) + '01')
dw_ip.setitem(1,'edate',left(f_today(),8))



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

type p_preview from w_standard_print`p_preview within w_sal_04060
string picturename = "C:\ERPMAN\image\미리보기_d.gif"
end type

type p_exit from w_standard_print`p_exit within w_sal_04060
string picturename = "C:\ERPMAN\image\닫기_up.gif"
end type

type p_print from w_standard_print`p_print within w_sal_04060
string picturename = "C:\ERPMAN\image\인쇄_d.gif"
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_04060
string picturename = "C:\ERPMAN\image\조회_up.gif"
end type







type st_10 from w_standard_print`st_10 within w_sal_04060
end type



type dw_print from w_standard_print`dw_print within w_sal_04060
integer x = 3607
string dataobject = "d_sal_04060_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_04060
integer x = 46
integer y = 24
integer width = 3374
integer height = 228
string dataobject = "d_sal_04060"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String  sDateFrom, sDateTo, snull, sPrtGbn, ls_saupj, ls_emp_id
Long    rtncode 
datawindowchild state_child 

SetNull(snull)

Choose Case GetColumnName() 
	Case "sdate"
		sDateFrom = Trim(this.GetText())
		IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
		
		IF f_datechk(sDateFrom) = -1 THEN
			f_message_chk(35,'시작일자]')
			this.SetItem(1,"sdate",snull)
			Return 1
		END IF
	Case "edate"
		sDateFrom = Trim(this.GetText())
		IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
		
		IF f_datechk(sDateFrom) = -1 THEN
			f_message_chk(35,'종료일자]')
			this.SetItem(1,"edate",snull)
			Return 1
		END IF
END Choose
end event

type dw_list from w_standard_print`dw_list within w_sal_04060
integer x = 59
integer y = 264
integer width = 4535
integer height = 2060
string dataobject = "d_sal_04060_p"
boolean border = false
end type

type pb_1 from u_pb_cal within w_sal_04060
integer x = 1632
integer y = 52
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer weight = 700
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sdate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sdate', gs_code)

end event

type pb_2 from u_pb_cal within w_sal_04060
integer x = 2089
integer y = 52
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer weight = 700
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('edate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'edate', gs_code)

end event

type rr_1 from roundrectangle within w_sal_04060
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 256
integer width = 4562
integer height = 2080
integer cornerheight = 40
integer cornerwidth = 55
end type

