$PBExportHeader$w_qct_04710.srw
$PBExportComments$서비스 접수 대장
forward
global type w_qct_04710 from w_standard_print
end type
type pb_1 from u_pb_cal within w_qct_04710
end type
type pb_2 from u_pb_cal within w_qct_04710
end type
type rr_1 from roundrectangle within w_qct_04710
end type
end forward

global type w_qct_04710 from w_standard_print
string title = "샘플 접수대장"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_qct_04710 w_qct_04710

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sdate, edate, ls_as_jpno1 , ls_as_jpno2

if dw_ip.AcceptText() = -1 then 
	dw_ip.SetFocus()
	return -1
end if	

sdate = Trim(dw_ip.object.sdate[1])
edate = Trim(dw_ip.object.edate[1])
ls_as_jpno1 = Trim(dw_ip.object.as_jpno1[1])
ls_as_jpno2 = Trim(dw_ip.object.as_jpno2[1])

if IsNull(sdate) or sdate = "" then sdate = "10000101"
if IsNull(edate) or edate = "" then edate = "99991231"
if IsNull(ls_as_jpno1) or ls_as_jpno1 = "" then ls_as_jpno1='.'
if IsNull(ls_as_jpno2) or ls_as_jpno2 = "" then ls_as_jpno2='zzzzzzzzzzzz'

//dw_list.object.txt_ymd.text = String(sdate, "@@@@.@@.@@") + " - " + String(edate, "@@@@.@@.@@")

//if dw_list.Retrieve(gs_sabu, sdate, edate, ls_as_jpno1, ls_as_jpno2) <= 0 then
//   f_message_chk(50,'[A/S 접수 대장]')
//   dw_ip.Setfocus()
//   return -1
//end if
	
IF dw_print.Retrieve(gs_sabu, sdate, edate, ls_as_jpno1, ls_as_jpno2) <= 0 then
   f_message_chk(50,'[A/S 접수 대장]')
	dw_list.Reset()
	dw_ip.SetFocus()
   dw_list.SetRedraw(true)
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.object.txt_ymd.text = String(sdate, "@@@@.@@.@@") + " - " + String(edate, "@@@@.@@.@@")
dw_print.ShareData(dw_list)

return 1
end function

on w_qct_04710.create
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

on w_qct_04710.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;string ls_Date
dw_ip.SetTransObject(SQLCA)
dw_ip.Reset()
dw_ip.InsertRow(0)

ls_Date = f_today()
dw_ip.setitem(1,"sdate",Left(ls_Date,6)+'01')
dw_ip.SetItem(1, "edate", ls_Date)
dw_ip.setfocus()

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

type p_preview from w_standard_print`p_preview within w_qct_04710
end type

type p_exit from w_standard_print`p_exit within w_qct_04710
end type

type p_print from w_standard_print`p_print within w_qct_04710
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_04710
end type







type st_10 from w_standard_print`st_10 within w_qct_04710
end type



type dw_print from w_standard_print`dw_print within w_qct_04710
string dataobject = "d_qct_04710_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_04710
integer x = 69
integer y = 44
integer width = 1746
integer height = 220
string dataobject = "d_qct_04710_01"
end type

event dw_ip::rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

if this.getcolumnname() = "as_jpno1" then // A/S 의뢰번호
	open(w_asno_popup)
   this.object.as_jpno1[1] = gs_code
elseif this.getcolumnname() = "as_jpno2" then // A/S 의뢰번호
	open(w_asno_popup)
   this.object.as_jpno2[1] = gs_code
end if	
return
end event

event dw_ip::itemerror;call super::itemerror;RETURN 1
end event

event dw_ip::itemchanged;call super::itemchanged;string s_cod

s_cod = Trim(this.gettext())

if this.GetColumnName() = "sdate" then
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35,"[시작일자]")
		this.object.sdate[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "edate" then
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35,"[끝일자]")
		this.object.edate[1] = ""
		return 1
	end if
end if

end event

type dw_list from w_standard_print`dw_list within w_qct_04710
integer x = 82
integer y = 272
integer width = 4485
integer height = 2032
string dataobject = "d_qct_04710_02"
boolean border = false
end type

type pb_1 from u_pb_cal within w_qct_04710
integer x = 777
integer y = 60
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sdate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sdate', gs_code)
end event

type pb_2 from u_pb_cal within w_qct_04710
integer x = 1207
integer y = 60
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('edate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'edate', gs_code)
end event

type rr_1 from roundrectangle within w_qct_04710
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 69
integer y = 264
integer width = 4517
integer height = 2056
integer cornerheight = 40
integer cornerwidth = 55
end type

