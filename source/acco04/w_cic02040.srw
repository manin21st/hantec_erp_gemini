$PBExportHeader$w_cic02040.srw
$PBExportComments$입고집계표
forward
global type w_cic02040 from w_standard_print
end type
end forward

global type w_cic02040 from w_standard_print
string title = "입고집계표"
end type
global w_cic02040 w_cic02040

type variables
string is_fyymm, is_tyymm, is_saupj
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string snull,   is_gubun, is_ki, is_ittyp
SetNull(snull)

if dw_ip.Accepttext() = -1 then return -1

is_fyymm = dw_ip.GetItemString(1,"yymm")
is_saupcd = dw_ip.GetItemString(1,"saupj")
is_gubun = dw_ip.GetItemString(1,"gubun")
is_ittyp = dw_ip.GetItemString(1,"ittyp")


if is_ittyp = '1' then
	is_ki = dw_ip.GetItemString(1,"bunki")
	if is_ki = '1' then
		dw_print.Modify('itemas_itdsc_t.text = "1월"')
		dw_print.Modify('t_21.text = "2월"')
		dw_print.Modify('t_25.text = "3월"')
		dw_list.Modify('itemas_itdsc_t.text = "1월"')
		dw_list.Modify('t_21.text = "2월"')
		dw_list.Modify('t_25.text = "3월"')		
	elseif is_ki = '2' then
		dw_print.Modify('itemas_itdsc_t.text = "4월"')
		dw_print.Modify('t_21.text = "5월"')
		dw_print.Modify('t_25.text = "6월"')
		dw_list.Modify('itemas_itdsc_t.text = "4월"')
		dw_list.Modify('t_21.text = "5월"')
		dw_list.Modify('t_25.text = "6월"')
	elseif is_ki = '3' then
		dw_print.Modify('itemas_itdsc_t.text = "7월"')
		dw_print.Modify('t_21.text = "8월"')
		dw_print.Modify('t_25.text = "9월"')
		dw_list.Modify('itemas_itdsc_t.text = "7월"')
		dw_list.Modify('t_21.text = "8월"')
		dw_list.Modify('t_25.text = "9월"')
	elseif is_ki = '4' then
		dw_print.Modify('itemas_itdsc_t.text = "10월"')
		dw_print.Modify('t_21.text = "11월"')
		dw_print.Modify('t_25.text = "12월"')	
		dw_list.Modify('itemas_itdsc_t.text = "10월"')
		dw_list.Modify('t_21.text = "11월"')
		dw_list.Modify('t_25.text = "12월"')
	end if	
elseif is_ittyp = '2' then
	is_ki = dw_ip.GetItemString(1,"banki")
	if is_ki = '1' then
		dw_print.Modify('itemas_itdsc_t.text = "1분기"')
		dw_print.Modify('t_21.text = "2분기"')
		dw_list.Modify('itemas_itdsc_t.text = "1분기"')
		dw_list.Modify('t_21.text = "2분기"')
	elseif is_ki = '2' then
		dw_print.Modify('itemas_itdsc_t.text = "3분기"')
		dw_print.Modify('t_21.text = "4분기"')
		dw_list.Modify('itemas_itdsc_t.text = "3분기"')
		dw_list.Modify('t_21.text = "4분기"')
	end if
end if

if IsNull(is_fyymm) or is_fyymm = ""  then
	 messagebox("확인","조회년도를 입력하세요!")
	 dw_ip.SetColumn("yymm")
	 dw_ip.Setfocus()
	 return -1
end if

if IsNull(is_gubun) or is_gubun = "" then is_gubun = '%'
if IsNull(is_saupcd) or is_saupcd = "" then is_saupcd = '%'

if dw_print.Retrieve(is_saupcd, is_ki, is_fyymm,  is_gubun) < 1 then
	 w_mdi_frame.sle_msg.text = "조회할 자료가 없습니다!"
   return -1
end if

dw_print.sharedata(dw_list)

return 1
end function

on w_cic02040.create
call super::create
end on

on w_cic02040.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
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

//SELECT "SUB2_T"."OPEN_HISTORY", "SUB2_T"."UPMU"  
//  INTO :is_usegub,  :is_upmu 
//  FROM "SUB2_T"  
// WHERE "SUB2_T"."WINDOW_NAME" = :is_window_id  ;
//
//IF is_usegub = 'Y' THEN
//   INSERT INTO "PGM_HISTORY"  
//	 		 ( "L_USERID",   "CDATE",       "STIME",      "WINDOW_NAME",   "EDATE",   
//			   "ETIME",      "IPADD",       "USER_NAME" )  
//   VALUES ( :gs_userid,   :is_today,     :is_totime,   :is_window_id,   NULL, 
//	   		NULL,         :gs_ipaddress, :gs_comname )  ;
//
//   IF SQLCA.SQLCODE = 0 THEN 
//	   COMMIT;
//   ELSE 	  
//	   ROLLBACK;
//   END IF	  
//END IF	  

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


dw_ip.Setitem(1,"saupj", gs_saupj)
dw_ip.Setitem(1, "yymm", left(f_today(),4))

is_fyymm = left(f_today(),4)+'0101' 
is_saupj = gs_saupj
end event

type p_xls from w_standard_print`p_xls within w_cic02040
end type

type p_sort from w_standard_print`p_sort within w_cic02040
end type

type p_preview from w_standard_print`p_preview within w_cic02040
end type

type p_exit from w_standard_print`p_exit within w_cic02040
end type

type p_print from w_standard_print`p_print within w_cic02040
end type

type p_retrieve from w_standard_print`p_retrieve within w_cic02040
end type







type st_10 from w_standard_print`st_10 within w_cic02040
end type



type dw_print from w_standard_print`dw_print within w_cic02040
string dataobject = "dw_cic02040_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_cic02040
integer x = 37
integer y = 0
integer width = 3584
integer height = 224
string dataobject = "dw_cic02040_1"
end type

event dw_ip::itemchanged;call super::itemchanged;string snull, ls_ittyp
SetNull(snull)

if dw_ip.Accepttext() = -1 then return

if This.GetColumnName() = "yymm" then
	is_fyymm = This.Gettext()
	if IsNull(is_fyymm) or is_fyymm = "" then 
	 	 messagebox("확인","년도를 입력하세요!")
		 dw_ip.SetItem(1,"yymm", snull)
		 dw_ip.SetColumn("yymm")
		 dw_ip.Setfocus()
		 return
	end if

	if f_datechk(is_fyymm+'0101') = -1 then
		messagebox("확인","년도를 확인하세요!")
		dw_ip.SetItem(1,"yymm", snull)
		dw_ip.SetColumn("yymm")
		dw_ip.Setfocus()
		return
	end if	
end if	

if This.GetColumnName() = "saupj" then
	is_saupj = This.Gettext()
	if IsNull(is_saupj) or is_saupj = "" then is_saupj = '%'
end if

if This.GetColumnName() = 'ittyp' then
	ls_ittyp = This.Gettext()
	if ls_ittyp = '1' then
		dw_ip.Modify('banki.visible = 0')
		dw_ip.Modify('bunki.visible = 1')
		dw_list.dataobject="dw_cic02040_2"
		dw_list.settransobject(sqlca)
		dw_print.dataobject="dw_cic02040_2_p"
		dw_print.settransobject(sqlca)	
		dw_ip.Modify('t_3.text = "분기"')
	elseif ls_ittyp = '2' then
		dw_ip.Modify('banki.visible = 1')
		dw_ip.Modify('bunki.visible = 0')
		dw_list.dataobject="dw_cic02040_3"
		dw_list.settransobject(sqlca)
		dw_print.dataobject="dw_cic02040_3_p"
		dw_print.settransobject(sqlca)
		dw_ip.Modify('t_3.text = "반기"')
	end if
	
	
end if


end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_cic02040
integer y = 232
integer height = 2020
string dataobject = "dw_cic02040_2"
end type

