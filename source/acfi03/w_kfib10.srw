$PBExportHeader$w_kfib10.srw
$PBExportComments$년도별 장기차입금 상환계획표 조회출력
forward
global type w_kfib10 from w_standard_print
end type
type rr_1 from roundrectangle within w_kfib10
end type
end forward

global type w_kfib10 from w_standard_print
integer x = 0
integer y = 0
string title = "년도별 차입금 상환계획표 조회출력"
rr_1 rr_1
end type
global w_kfib10 w_kfib10

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sdate1, sdate2, sdate3, sdate4, sdate5, sGbn, sdate

IF dw_ip.AcceptText() = -1 THEN RETURN -1

sdate1 = Trim(dw_ip.GetItemString(1,"gijun_date"))
sGbn   = dw_ip.GetItemString(1,"sGbn")

If sdate1 = '' or IsNull(sdate1)  then
	F_MessageChk(1,'[기준년도]')
	Return -1
End If

sdate2 = String(long(sdate1) + 1 )
sdate3 = String(long(sdate2) + 1 )
sdate4 = String(long(sdate3) + 1 )
sdate5 = String(long(sdate4) + 1 )

//2001.04.06 전년말잔액 수정본
sdate = sdate1 + "0100"
	
IF dw_list.Retrieve(sabu_f, sabu_t, sdate1, sdate2, sdate3, sdate4, sdate5, sGbn, sdate) < 1 THEN
	dw_list.insertrow(0)
	f_messagechk(14, "")
	dw_ip.SetFocus()
	Return -1
   
END IF

//dw_print.sharedata(dw_list)
dw_print.Retrieve(sabu_f, sabu_t, sdate1, sdate2, sdate3, sdate4, sdate5, sGbn, sdate)

Return 1


end function

on w_kfib10.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kfib10.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;ListviewItem		lvi_Current
lvi_Current.Data = Upper(This.ClassName())
lvi_Current.Label = This.Title
lvi_Current.PictureIndex = 1

w_mdi_frame.lv_open_menu.additem(lvi_Current)

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

string s_gidate

s_gidate = left(f_today(), 4)

dw_ip.setitem(1, "gijun_date", s_gidate)
end event

type p_preview from w_standard_print`p_preview within w_kfib10
end type

type p_exit from w_standard_print`p_exit within w_kfib10
end type

type p_print from w_standard_print`p_print within w_kfib10
end type

event p_print::clicked;//IF dw_list.rowcount() > 0 then 
//	gi_page = dw_list.GetItemNumber(1,"last_page")
//ELSE
//	gi_page = 1
//END IF
OpenWithParm(w_print_options, dw_list)
end event

type p_retrieve from w_standard_print`p_retrieve within w_kfib10
end type







type st_10 from w_standard_print`st_10 within w_kfib10
end type



type dw_print from w_standard_print`dw_print within w_kfib10
string dataobject = "d_kfib10_4_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfib10
integer x = 59
integer y = 32
integer width = 1179
integer height = 208
string dataobject = "d_kfib10_1"
end type

event dw_ip::itemchanged;string ls_gijun_date

if this.GetColumnName() = 'gijun_date' then
	ls_gijun_date = this.GetText()
	if trim(ls_gijun_date) = '' or isnull(ls_gijun_date) then 
		F_MessageChk(1, "[기준년도]")
		return 1
	else
		if F_dateChk(ls_gijun_date +'0101') = -1 then 
			MessageBox("확 인", "유효한 기준년도가 아닙니다.!!")
			return 1
		end if
	end if
end if
end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_kfib10
integer x = 78
integer y = 272
integer width = 4517
integer height = 1952
string dataobject = "d_kfib10_4"
boolean border = false
end type

type rr_1 from roundrectangle within w_kfib10
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 256
integer width = 4549
integer height = 1980
integer cornerheight = 40
integer cornerwidth = 55
end type

