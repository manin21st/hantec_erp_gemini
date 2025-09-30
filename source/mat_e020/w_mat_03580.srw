$PBExportHeader$w_mat_03580.srw
$PBExportComments$** 창고별 재고금액 현황
forward
global type w_mat_03580 from w_standard_print
end type
type rr_1 from roundrectangle within w_mat_03580
end type
end forward

global type w_mat_03580 from w_standard_print
string title = "창고별 재고금액 현황"
rr_1 rr_1
end type
global w_mat_03580 w_mat_03580

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String  sdepot, sittyp, sgubun, snull

IF dw_ip.AcceptText() = -1 THEN RETURN -1

SetNull(snull)

sdepot = TRIM(dw_ip.GetItemString(1,"depot"))
sittyp = TRIM(dw_ip.GetItemString(1,"ittyp"))
sgubun = TRIM(dw_ip.GetItemString(1,"gubun"))

IF sdepot = "" OR IsNull(sdepot) THEN
	f_message_chk(30,'[기준창고]')
	dw_ip.SetColumn("depot")
	dw_ip.SetFocus()
	Return -1
END IF

IF sittyp = '' or IsNull(sittyp) THEN 
	sittyp = '%'
END IF

//IF dw_list.Retrieve(gs_sabu, sdepot, sittyp, sgubun, f_today() ) < 1 THEN
//	f_message_chk(50,'')
//	dw_ip.Setfocus()
//	return -1
//end if

IF dw_print.Retrieve(gs_sabu, sdepot, sittyp, sgubun, f_today() ) < 1 THEN
	dw_list.Reset()
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

return 1



end function

on w_mat_03580.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_mat_03580.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;dw_ip.SetTransObject(SQLCA)
dw_ip.InsertRow(0)

////창고 
//f_child_saupj(dw_ip, 'depot', '%')

end event

event open;//
Integer  li_idx

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
//
//dw_ip.SetTransObject(SQLCA)
//dw_ip.Reset()
//dw_ip.InsertRow(0)

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

type p_xls from w_standard_print`p_xls within w_mat_03580
end type

type p_sort from w_standard_print`p_sort within w_mat_03580
end type

type p_preview from w_standard_print`p_preview within w_mat_03580
end type

type p_exit from w_standard_print`p_exit within w_mat_03580
end type

type p_print from w_standard_print`p_print within w_mat_03580
end type

type p_retrieve from w_standard_print`p_retrieve within w_mat_03580
end type







type st_10 from w_standard_print`st_10 within w_mat_03580
end type



type dw_print from w_standard_print`dw_print within w_mat_03580
string dataobject = "d_mat_03580_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_mat_03580
integer y = 24
integer width = 2153
integer height = 240
string dataobject = "d_mat_03580_a"
end type

type dw_list from w_standard_print`dw_list within w_mat_03580
integer x = 41
integer y = 292
integer width = 4558
integer height = 2036
string dataobject = "d_mat_03580_1"
boolean border = false
end type

type rr_1 from roundrectangle within w_mat_03580
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 284
integer width = 4571
integer height = 2052
integer cornerheight = 40
integer cornerwidth = 55
end type

