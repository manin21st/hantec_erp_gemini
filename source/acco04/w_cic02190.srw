$PBExportHeader$w_cic02190.srw
$PBExportComments$경비집계표(2)
forward
global type w_cic02190 from w_standard_print
end type
type rr_1 from roundrectangle within w_cic02190
end type
end forward

global type w_cic02190 from w_standard_print
string title = "경비집계표(2)"
rr_1 rr_1
end type
global w_cic02190 w_cic02190

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_saupcd, ls_workyear, ls_expgubn, ls_pgubn, ls_bangubn, ls_bungubn, ls_saup

ls_saupcd = dw_ip.GetItemstring(1,"saupcd")
ls_workyear = dw_ip.GetItemstring(1,"workyear")
ls_expgubn = dw_ip.GetItemstring(1,"expgubn")
ls_pgubn = dw_ip.GetItemstring(1,"pgubn")
ls_bangubn = dw_ip.GetItemstring(1,"bangubn")
ls_bungubn = dw_ip.GetItemstring(1,"bungubn")

if ls_saupcd = '' or isnull(ls_saupcd) then
	ls_saupcd = '%'
end if

if ls_workyear = '' or isnull(ls_workyear) then
	messagebox("확인","기준년도는 필수항목입니다.")
	return 1
end if

if ls_expgubn = '' or isnull(ls_expgubn) then
	ls_expgubn = '%'
end if

if ls_pgubn = '1' then
	
	dw_list.DataObject = "d_cic02190_3"
	dw_print.DataObject = "d_cic02190_3_p"
	dw_list.SetTransObject(sqlca)
	dw_print.SetTransObject(sqlca)
	
	if dw_print.retrieve(ls_saupcd, ls_expgubn, ls_workyear, ls_bungubn) < 1 then
		messagebox("확인","조건에 해당하는 자료가 없습니다.")
		return 1
	end if
	
	dw_print.sharedata(dw_list)
	
	if ls_bungubn = '1' then
		dw_list.modify("value1_t.text = '1월'")
		dw_list.modify("value2_t.text = '2월'")
		dw_list.modify("value3_t.text = '3월'")
		
		dw_print.modify("value1_t.text = '1월'")
		dw_print.modify("value2_t.text = '2월'")
		dw_print.modify("value3_t.text = '3월'")
		
	elseif ls_bungubn = '2' then
		dw_list.modify("value1_t.text = '4월'")
		dw_list.modify("value2_t.text = '5월'")
		dw_list.modify("value3_t.text = '6월'")		
		
		dw_print.modify("value1_t.text = '4월'")
		dw_print.modify("value2_t.text = '5월'")
		dw_print.modify("value3_t.text = '6월'")	
		
	elseif ls_bungubn = '3' then
		dw_list.modify("value1_t.text = '7월'")
		dw_list.modify("value2_t.text = '8월'")
		dw_list.modify("value3_t.text = '9월'")
		
		dw_print.modify("value1_t.text = '7월'")
		dw_print.modify("value2_t.text = '8월'")
		dw_print.modify("value3_t.text = '9월'")
		
	else
		dw_list.modify("value1_t.text = '10월'")
		dw_list.modify("value2_t.text = '11월'")
		dw_list.modify("value3_t.text = '12월'")	

		dw_print.modify("value1_t.text = '10월'")
		dw_print.modify("value2_t.text = '11월'")
		dw_print.modify("value3_t.text = '12월'")	
	end if
	
else
	
	dw_list.DataObject = "d_cic02190_2"
	dw_print.DataObject = "d_cic02190_2_p"
	dw_list.SetTransObject(sqlca)
	dw_print.SetTransObject(sqlca)
	
	if dw_print.retrieve(ls_saupcd, ls_expgubn, ls_workyear, ls_bangubn) < 1 then
		messagebox("확인","조건에 해당하는 자료가 없습니다.")
		return 1
	end if
	
	dw_print.sharedata(dw_list)
	
	if ls_bangubn = '1' then
		dw_list.modify("value1_t.text = '1월'")
		dw_list.modify("value2_t.text = '2월'")
		dw_list.modify("value3_t.text = '3월'")
		dw_list.modify("value4_t.text = '4월'")
		dw_list.modify("value5_t.text = '5월'")
		dw_list.modify("value6_t.text = '6월'")

		dw_print.modify("value1_t.text = '1월'")
		dw_print.modify("value2_t.text = '2월'")
		dw_print.modify("value3_t.text = '3월'")
		dw_print.modify("value4_t.text = '4월'")
		dw_print.modify("value5_t.text = '5월'")
		dw_print.modify("value6_t.text = '6월'")
	else
		dw_list.modify("value1_t.text = '7월'")
		dw_list.modify("value2_t.text = '8월'")
		dw_list.modify("value3_t.text = '9월'")
		dw_list.modify("value4_t.text = '10월'")
		dw_list.modify("value5_t.text = '11월'")
		dw_list.modify("value6_t.text = '12월'")
		
		dw_print.modify("value1_t.text = '7월'")
		dw_print.modify("value2_t.text = '8월'")
		dw_print.modify("value3_t.text = '9월'")
		dw_print.modify("value4_t.text = '10월'")
		dw_print.modify("value5_t.text = '11월'")
		dw_print.modify("value6_t.text = '12월'")
	end if

end if

if ls_saupcd = '%' then
	ls_saup = '전체'
else
	select rfna1
	into :ls_saup
	from reffpf 
	where rfcod = 'AD' 
	   and  rfgub = :ls_saupcd;
end if

dw_print.modify("t_saupcd.text = '" +ls_saup + "'")
Return 1

	



end function

on w_cic02190.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_cic02190.destroy
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
w_mdi_frame.sle_msg.Text = ""

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

//IF is_upmu = 'A' THEN //회계인 경우
//   int iRtnVal 
//
//	IF Upper(Mid(is_window_id,4,2)) = 'BG' THEN							   /*예산*/
//		IF F_Valid_EmpNo(Gs_EmpNo) = 'N' THEN							/*권한 체크- 현업 여부*/
//			dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
//			
//			dw_ip.Modify("saupj.protect = 1")
//		ELSE
//			dw_ip.Modify("saupj.protect = 0")
//		END IF
//	ELSE
//		IF Upper(Mid(is_window_id,4,2)) = 'FI' THEN							/*자금*/
//			iRtnVal = F_Authority_Fund_Chk(Gs_Dept)	
//		ELSE
//			iRtnVal = F_Authority_Chk(Gs_Dept)
//		END IF
//		IF iRtnVal = -1 THEN							/*권한 체크- 현업 여부*/
//			dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
//			
//			dw_ip.Modify("saupj.protect = 1")
//		ELSE
//			dw_ip.Modify("saupj.protect = 0")
//		END IF	
//	END IF
//END IF
dw_print.object.datawindow.print.preview = "yes"	

dw_print.ShareData(dw_list)

PostEvent('ue_open')

dw_ip.SetItem(1,"saupcd",   Gs_Saupj)
dw_ip.SetItem(1,"workyear", left(f_today(),4) )
end event

type p_xls from w_standard_print`p_xls within w_cic02190
end type

type p_sort from w_standard_print`p_sort within w_cic02190
end type

type p_preview from w_standard_print`p_preview within w_cic02190
end type

type p_exit from w_standard_print`p_exit within w_cic02190
end type

type p_print from w_standard_print`p_print within w_cic02190
end type

type p_retrieve from w_standard_print`p_retrieve within w_cic02190
end type

event p_retrieve::clicked;IF wf_retrieve() = -1 THEN
	p_print.Enabled =False
	p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
	SetPointer(Arrow!)
	Return
Else
	p_print.Enabled =True
	p_print.PictureName =  'C:\erpman\image\인쇄_up.gif'
	p_preview.enabled = true
	p_preview.PictureName = 'C:\erpman\image\미리보기_up.gif'
END IF
dw_list.scrolltorow(1)
dw_list.SetFocus()
SetPointer(Arrow!)
end event







type st_10 from w_standard_print`st_10 within w_cic02190
end type



type dw_print from w_standard_print`dw_print within w_cic02190
string dataobject = "d_cic02190_3_p"
end type

type dw_ip from w_standard_print`dw_ip within w_cic02190
integer x = 9
integer width = 2697
integer height = 304
string dataobject = "d_cic02190_1"
end type

type dw_list from w_standard_print`dw_list within w_cic02190
integer x = 46
integer y = 368
integer width = 4562
integer height = 1876
string dataobject = "d_cic02190_3"
boolean border = false
end type

type rr_1 from roundrectangle within w_cic02190
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 32
integer y = 360
integer width = 4599
integer height = 1908
integer cornerheight = 40
integer cornerwidth = 55
end type

