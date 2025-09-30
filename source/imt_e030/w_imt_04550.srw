$PBExportHeader$w_imt_04550.srw
$PBExportComments$업체별 매입금액 실적집계 현황
forward
global type w_imt_04550 from w_standard_print
end type
type dw_list2 from datawindow within w_imt_04550
end type
type rr_1 from roundrectangle within w_imt_04550
end type
type rr_2 from roundrectangle within w_imt_04550
end type
end forward

global type w_imt_04550 from w_standard_print
string title = "업체별 매입금액 실적집계 현황"
dw_list2 dw_list2
rr_1 rr_1
rr_2 rr_2
end type
global w_imt_04550 w_imt_04550

type variables

end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string   s_stdy, s_frmvnd, s_tovnd, s_empno, s_empnam, s_temp, sgubun, swaigu , s_saupj, smro
long     l_retriv1, l_retriv2

if dw_ip.AcceptText() = -1 then return -1

s_saupj  = dw_ip.GetItemString(1,"saupj")
s_stdy   = trim(dw_ip.GetItemString(1,"stdy"))
s_frmvnd = dw_ip.GetItemString(1,"frmvnd")
s_tovnd  = dw_ip.GetItemString(1,"tovnd")
s_empno  = dw_ip.GetItemString(1,"empno")
sgubun   = dw_ip.GetItemString(1,"gubun")
swaigu   = dw_ip.GetItemString(1,"maip")
smro     = dw_ip.GetItemString(1,"mro")

IF (IsNull(s_stdy) OR s_stdy = "") THEN
   f_message_chk(40,"[기준년도]")
	dw_ip.SetColumn('stdy')
	dw_ip.SetFocus()
	return -1
ELSE
	IF LEN(s_stdy) < 4 then 
		f_message_chk(35,"[기준년도]")
		dw_ip.SetColumn('stdy')
		dw_ip.SetFocus()
		return -1
	END IF
END IF

if ( IsNull(s_saupj) or s_saupj = "" ) then s_saupj = '%'
//	 f_message_chk(30,"[사업장]")
//	 dw_ip.SetColumn('saupj')
//	 dw_ip.Setfocus()
//	 return -1
//end if

//거래처
IF ( IsNull(s_frmvnd) OR s_frmvnd = "" ) AND ( IsNull(s_tovnd) OR s_tovnd = "" ) THEN
   s_frmvnd = '.'
	s_tovnd  = 'zzzzzz'
ELSEIF IsNull(s_frmvnd) OR s_frmvnd = "" THEN
	s_frmvnd = '.'
ELSEIF IsNull(s_tovnd) OR s_tovnd = "" THEN
	s_tovnd = 'zzzzzz'
END IF

IF IsNull(s_empno) OR s_empno = "" THEN
	s_empno = '%'
end if

//거래처 순서결정
IF s_frmvnd > s_tovnd THEN
	s_temp   = s_frmvnd
	s_frmvnd = s_tovnd
	s_tovnd  = s_temp
END IF

l_retriv1 = dw_print.Retrieve(gs_sabu, s_stdy, s_frmvnd, s_tovnd, s_empno, sgubun, swaigu , s_saupj, smro )
dw_print.ShareData(dw_list)
l_retriv2 = dw_list2.Retrieve(gs_sabu, s_stdy, s_frmvnd, s_tovnd, s_empno, sgubun, swaigu , s_saupj, smro )

IF  l_retriv1 < 1 OR l_retriv2 < 1 THEN
	f_message_chk(50,"업체별 매입금액 현황")
	dw_ip.SetColumn('stdy')
	dw_ip.SetFocus()
	return -1
END IF

Return 1
end function

on w_imt_04550.create
int iCurrent
call super::create
this.dw_list2=create dw_list2
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list2
this.Control[iCurrent+2]=this.rr_1
this.Control[iCurrent+3]=this.rr_2
end on

on w_imt_04550.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_list2)
destroy(this.rr_1)
destroy(this.rr_2)
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

f_child_saupj(dw_ip,'empno',gs_saupj)

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

dw_print.ShareData(dw_list)

PostEvent('ue_open')





string  s_stdy

s_stdy = Mid(f_today(),1,4)

//초기화
dw_ip.SetItem(1, "stdy", s_stdy)		

dw_list2.settransobject(sqlca)

///* 부가 사업장 */
//f_mod_saupj(dw_ip,'saupj')
end event

type p_xls from w_standard_print`p_xls within w_imt_04550
end type

type p_sort from w_standard_print`p_sort within w_imt_04550
end type

type p_preview from w_standard_print`p_preview within w_imt_04550
end type

type p_exit from w_standard_print`p_exit within w_imt_04550
end type

type p_print from w_standard_print`p_print within w_imt_04550
end type

type p_retrieve from w_standard_print`p_retrieve within w_imt_04550
end type







type st_10 from w_standard_print`st_10 within w_imt_04550
end type



type dw_print from w_standard_print`dw_print within w_imt_04550
string dataobject = "d_imt_04551_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_04550
integer x = 0
integer y = 0
integer width = 3127
integer height = 304
string dataobject = "d_imt_04550"
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

type dw_list from w_standard_print`dw_list within w_imt_04550
integer x = 14
integer y = 316
integer height = 900
string dataobject = "d_imt_04551"
boolean border = false
end type

type dw_list2 from datawindow within w_imt_04550
integer x = 905
integer y = 1252
integer width = 2807
integer height = 1060
integer taborder = 20
string dataobject = "d_imt_04552"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_imt_04550
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer y = 308
integer width = 4622
integer height = 920
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_imt_04550
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 16777215
integer x = 805
integer y = 1236
integer width = 3013
integer height = 1092
integer cornerheight = 40
integer cornerwidth = 55
end type

