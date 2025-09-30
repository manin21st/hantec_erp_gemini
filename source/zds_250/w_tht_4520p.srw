$PBExportHeader$w_tht_4520p.srw
$PBExportComments$HMC/KMC공장별 불량현황
forward
global type w_tht_4520p from w_standard_print
end type
type rr_1 from roundrectangle within w_tht_4520p
end type
end forward

global type w_tht_4520p from w_standard_print
integer width = 4667
integer height = 2412
string title = "HMC/KMC공장별 별량현황"
rr_1 rr_1
end type
global w_tht_4520p w_tht_4520p

type variables

end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();dw_ip.AcceptText()

Integer row
row = dw_ip.GetRow()
If row < 1 Then Return 0

String  ls_st
ls_st = dw_ip.GetItemString(row, 'eddy')
If IsNull(ls_st) OR Trim(ls_st) = '' Then
	MessageBox('확인', '기준월을 입력 하십시오.')
	f_setfocus_dw(dw_ip, row, 'eddy')
	Return -1
End If

dw_list.SetRedraw(False)
dw_list.Retrieve(ls_st)
dw_list.SetRedraw(True)

dw_print.SetRedraw(False)
dw_print.Retrieve(ls_st)
dw_print.SetRedraw(True)

// 년간 월별 타이틀 표시
Long		i, j
String 	ls_yymm

for i = -11 to 0
	j++
	ls_yymm = f_aftermonth(ls_st, i)
	dw_list.Modify("ppm"+String(j,'00')+"_t.text='"+Mid(ls_yymm,3,2)+"."+Right(ls_yymm,2)+"'")
	dw_print.Modify("ppm"+String(j,'00')+"_t.text='"+Mid(ls_yymm,3,2)+"."+Right(ls_yymm,2)+"'")
next

Return 1
end function

on w_tht_4520p.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_tht_4520p.destroy
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
string	s_yymm
s_yymm = Left(f_today(), 6)
dw_ip.SetItem(1, 'stdy', f_aftermonth(s_yymm, -11))
dw_ip.SetItem(1, 'eddy', Left(s_yymm, 6))

/* 부가 사업장 */
f_mod_saupj(dw_ip,'saupj')
end event

type p_xls from w_standard_print`p_xls within w_tht_4520p
boolean visible = true
integer x = 3671
integer y = 24
end type

type p_sort from w_standard_print`p_sort within w_tht_4520p
integer x = 3493
integer y = 32
end type

type p_preview from w_standard_print`p_preview within w_tht_4520p
boolean visible = false
end type

type p_exit from w_standard_print`p_exit within w_tht_4520p
end type

type p_print from w_standard_print`p_print within w_tht_4520p
boolean visible = false
end type

type p_retrieve from w_standard_print`p_retrieve within w_tht_4520p
end type







type st_10 from w_standard_print`st_10 within w_tht_4520p
end type



type dw_print from w_standard_print`dw_print within w_tht_4520p
integer x = 3831
integer y = 180
string dataobject = "d_tht_4520p_p"
end type

type dw_ip from w_standard_print`dw_ip within w_tht_4520p
integer x = 37
integer y = 32
integer width = 3433
integer height = 212
string dataobject = "d_tht_4520p_c"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;If row < 1 Then Return

Choose Case dwo.name
	Case 'eddy'
		if f_datechk(data+'01') = -1 then return
		
		this.setitem(row, 'stdy', f_aftermonth(data, -11))
		
End Choose
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

type dw_list from w_standard_print`dw_list within w_tht_4520p
integer x = 50
integer y = 264
integer width = 4544
integer height = 1936
string dataobject = "d_tht_4520p_l"
boolean border = false
end type

type rr_1 from roundrectangle within w_tht_4520p
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

