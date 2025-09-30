$PBExportHeader$w_tht_4510p.srw
$PBExportComments$CLAIM 집계표
forward
global type w_tht_4510p from w_standard_print
end type
type rr_1 from roundrectangle within w_tht_4510p
end type
end forward

global type w_tht_4510p from w_standard_print
integer width = 4667
integer height = 2412
string title = "CLAIM 집계표"
rr_1 rr_1
end type
global w_tht_4510p w_tht_4510p

type variables

end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();dw_ip.AcceptText()

Integer row
row = dw_ip.GetRow()
If row < 1 Then Return 0

String  ls_saupj
ls_saupj = dw_ip.GetItemString(row, 'saupj')
If IsNull(ls_saupj) OR Trim(ls_saupj) = '' Then ls_saupj = '%'

String  ls_st
ls_st = dw_ip.GetItemString(row, 'stdy')
If IsNull(ls_st) OR Trim(ls_st) = '' Then
	MessageBox('확인', '기준월을 입력 하십시오.')
	f_setfocus_dw(dw_ip, row, 'stdy')
	Return -1
End If

String  ls_gbn
ls_gbn = dw_ip.GetItemString(row, 'gbn')

String  ls_typ
ls_typ = dw_ip.GetItemString(row, 'typ')

dw_list.SetRedraw(False)
dw_list.Retrieve(ls_saupj, ls_st, ls_gbn, ls_typ)
dw_list.SetRedraw(True)

dw_print.SetRedraw(False)
dw_print.Retrieve(ls_saupj, ls_st, ls_gbn, ls_typ)
dw_print.SetRedraw(True)

Return 1
end function

on w_tht_4510p.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_tht_4510p.destroy
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

PostEvent('ue_open')

//초기화
dw_ip.SetItem(1, "stdy", String(TODAY(), 'yyyymm'))

/* 부가 사업장 */
f_mod_saupj(dw_ip,'saupj')
end event

type p_xls from w_standard_print`p_xls within w_tht_4510p
boolean visible = true
integer x = 3671
integer y = 32
end type

type p_sort from w_standard_print`p_sort within w_tht_4510p
integer x = 3493
integer y = 32
end type

type p_preview from w_standard_print`p_preview within w_tht_4510p
boolean visible = false
end type

type p_exit from w_standard_print`p_exit within w_tht_4510p
end type

type p_print from w_standard_print`p_print within w_tht_4510p
boolean visible = false
end type

type p_retrieve from w_standard_print`p_retrieve within w_tht_4510p
end type







type st_10 from w_standard_print`st_10 within w_tht_4510p
end type



type dw_print from w_standard_print`dw_print within w_tht_4510p
integer x = 3831
integer y = 180
string dataobject = "d_tht_4510p_p"
end type

type dw_ip from w_standard_print`dw_ip within w_tht_4510p
integer x = 37
integer y = 32
integer width = 3433
integer height = 212
string dataobject = "d_tht_4510p_c"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;string snull, s_col, s_cod, s_nam

sle_msg.Text = ""
SetNull(snull)

s_col = this.GetColumnName()

if s_col = 'frmvnd' then   
	s_cod = Trim(this.GetText())
	if IsNull(s_cod) or s_cod = "" then 
		this.SetItem(1,"frmvbdnam",snull)		
		this.SetItem(1,"frmvnd",snull)
		return
	end if
	
	SELECT CVNAS
     INTO :s_nam
     FROM VNDMST  
    WHERE CVCOD = :s_cod;                    

	if sqlca.sqlcode = 0 then
		this.SetItem(1,"frmvndnam",s_nam)
	else
		this.SetItem(1,"frmvndnam",snull)		
	end if
 
elseif s_col = 'tovnd' then   
	s_cod = Trim(this.GetText())
	if IsNull(s_cod) or s_cod = "" then
		this.SetItem(1,"tovndnam",snull)		
		return
	end if
	
	SELECT CVNAS
     INTO :s_nam
     FROM VNDMST  
    WHERE CVCOD = :s_cod;                    

	if sqlca.sqlcode = 0 then
		this.SetItem(1,"tovndnam",s_nam)
	else
		this.SetItem(1,"tovndnam",snull)		
	end if
elseif getcolumnname() = 'saupj' then
	s_cod = gettext()
	f_child_saupj(dw_ip,'empno',s_cod)

elseif getcolumnname() = 'gubun' then
//	s_cod = gettext()
//   if s_cod = '1' then 
//		dw_list.DataObject = "d_imt_04551_th"
//		dw_print.DataObject = "d_imt_04551_th_p"
////		dw_list2.DataObject = "d_imt_04552_th"
//   elseif s_cod = '2' then
//		dw_list.DataObject = "d_imt_04551"
//		dw_print.DataObject = "d_imt_04551_p"
////		dw_list2.DataObject = "d_imt_04552"
//   end if		
//
//	dw_list.SetTransObject(SQLCA)
////	dw_list2.SetTransObject(SQLCA)
//	dw_print.SetTransObject(SQLCA)

end if	

	

end event

event dw_ip::rbuttondown;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

IF	this.GetColumnName() = "frmvnd"	THEN		
	Open(w_vndmst_popup)
	IF IsNull(gs_code) OR gs_code = "" THEN  return
	this.SetItem(1, "frmvnd", gs_code)
	this.SetItem(1, "frmvndnam", gs_codename)
	this.TriggerEvent(itemchanged!)
	return 1
ELSEIF this.GetColumnName() = "tovnd" THEN		
	Open(w_vndmst_popup)
	IF IsNull(gs_code) OR gs_code = "" THEN  return
	this.SetItem(1, "tovnd", gs_code)
	this.SetItem(1, "tovndnam", gs_codename)
	this.TriggerEvent(itemchanged!)
	return 1	

END IF




end event

type dw_list from w_standard_print`dw_list within w_tht_4510p
integer x = 50
integer y = 264
integer width = 4544
integer height = 1936
string dataobject = "d_tht_4510p_l"
boolean border = false
end type

type rr_1 from roundrectangle within w_tht_4510p
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 256
integer width = 4576
integer height = 1956
integer cornerheight = 40
integer cornerwidth = 55
end type

