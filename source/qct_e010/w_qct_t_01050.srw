$PBExportHeader$w_qct_t_01050.srw
$PBExportComments$업체별 CLAIM공제현황
forward
global type w_qct_t_01050 from w_standard_print
end type
type rr_2 from roundrectangle within w_qct_t_01050
end type
end forward

global type w_qct_t_01050 from w_standard_print
integer width = 4640
string title = "업체별 CLAIM공제현황"
rr_2 rr_2
end type
global w_qct_t_01050 w_qct_t_01050

type variables
String is_date
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();//String syymm, scvcod, sempno, smm, scvnas
//
//dw_ip.Accepttext()
//syymm = dw_ip.getitemstring(1, "edate")
//smm   = Mid(syymm,5,2)
//if isnull(syymm) or syymm = "" then
//	f_message_chk(30,'[실사년월]')
//	return -1
//end if	
//
//scvcod = dw_ip.getitemstring(1, "vendor") 
//scvnas = dw_ip.getitemstring(1, "vendorname")  
//If Isnull(scvcod) or scvcod = '' then
//	scvcod = '%'
//	scvnas = ''
//End if
//
//if dw_list.Retrieve(gs_sabu, syymm, scvcod) <= 0 then
//	f_message_chk(50,'[업체별 CLAIM공제]')
//	dw_ip.Setfocus()
//	return -1
//end if

//dw_print.sharedata(dw_list)
//
///* 거래처명 & 공제 월 set */
//dw_print.Object.t_4.text = scvnas
//dw_print.Object.t_5.text = smm

return 1

end function

on w_qct_t_01050.create
int iCurrent
call super::create
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
end on

on w_qct_t_01050.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
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

dw_ip.SetTransObject(SQLCA)
dw_ip.Reset()
dw_ip.InsertRow(0)

dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)

is_today = f_today()
is_totime = f_totime()

is_Date = Mid(f_Today(),1,6)
dw_ip.SetItem(1, "edate", is_Date)
dw_ip.SetColumn("edate")
dw_ip.SetFocus()


end event

event activate;w_mdi_frame.st_window.Text = Upper(is_window_id)
end event

event closequery;string s_frday, s_frtime

IF is_usegub = 'Y' THEN
	s_frday = f_today()
	
	s_frtime = f_totime()

   UPDATE "PGM_HISTORY"  
      SET "EDATE" = :s_frday,   
          "ETIME" = :s_frtime  
    WHERE ( "PGM_HISTORY"."L_USERID" = :gs_userid ) AND  
          ( "PGM_HISTORY"."CDATE" = :is_today ) AND  
          ( "PGM_HISTORY"."STIME" = :is_totime ) AND  
          ( "PGM_HISTORY"."WINDOW_NAME" = :is_window_id )   ;

	IF SQLCA.SQLCODE = 0 THEN 
	   COMMIT;
   ELSE 	  
	   ROLLBACK;
   END IF	  
END IF	  

w_mdi_frame.st_window.Text = ''

long li_index

li_index = w_mdi_frame.dw_listbar.Find("window_id = '" + Upper(This.ClassName()) + "'", 1, w_mdi_frame.dw_listbar.RowCount())

w_mdi_frame.dw_listbar.DeleteRow(li_index)
w_mdi_frame.Postevent("ue_barrefresh")
end event

type p_preview from w_standard_print`p_preview within w_qct_t_01050
string pointer = "c:\erpman\cur\preview.cur"
boolean enabled = true
string picturename = "C:\erpman\image\미리보기_up.gif"
end type

event p_preview::clicked;String syymm, scvcod, sempno, smm, scvnas, schk, ssudat, sitnbr, sitdsc, sbulsan, sseq, sseq2
Long   ll_row, ll_cnt, lioqty, lbulqty, lclaim, lclaim2

dw_ip.Accepttext()
syymm = dw_ip.getitemstring(1, "edate")
smm   = Mid(syymm,5,2)
if isnull(syymm) or syymm = "" then
	f_message_chk(30,'[실사년월]')
	return -1
end if	

scvcod = dw_ip.getitemstring(1, "vendor") 
scvnas = dw_ip.getitemstring(1, "vendorname")  
If Isnull(scvcod) or scvcod = '' then
	scvcod = '%'
	scvnas = ''
End if

if dw_print.Retrieve(gs_sabu, syymm, scvcod) <= 0 then
	f_message_chk(50,'[업체별 CLAIM공제]')
	dw_ip.Setfocus()
	return -1
end if

dw_list.AcceptText()
For ll_row = 1 to dw_list.RowCount()
	 schk   = dw_list.GetItemString(ll_row, "import")
	 ssudat = dw_list.GetItemString(ll_row, "imhist_sudat")
	 sitnbr = dw_list.GetItemString(ll_row, "imhist_itnbr")
	 sitdsc = dw_list.GetItemString(ll_row, "itdsc")
	 lioqty = dw_list.GetItemNumber(ll_row, "imhist_ioqty")
	 lbulqty= dw_list.GetItemNumber(ll_row, "imhfat_bulqty")
	 sbulsan= dw_list.GetItemString(ll_row, "imhfat_bulsan")
	 lclaim = dw_list.GetItemNumber(ll_row, "imhfat_claim_amt")
	 
	 if schk = 'Y' then
		 dw_list.SetItem(ll_row, "seq", "1")
	 else
		 dw_list.SetItem(ll_row, "seq", "")
	 end if 
Next


For ll_row = 1 to dw_list.RowCount()
	schk   = dw_list.GetItemString(ll_row, "import")

	if IsNull(schk) or SCHK <> 'Y' THEN CONTINUE
	sseq	= '1'
	lclaim = dw_list.GetItemNumber(ll_row, "imhfat_claim_amt")

	For ll_cnt = 1 to dw_list.RowCount()
		 schk   = dw_list.GetItemString(ll_cnt, "import")
	 	 if IsNull(schk) or SCHK <> 'Y' THEN CONTINUE

		 lclaim2 = dw_list.GetItemNumber(ll_cnt, "imhfat_claim_amt") 
		 if lclaim2 > lclaim then
			 sseq = String(Long(sseq) + 1)
		 end if
	Next
	dw_list.SetItem(ll_row, "seq", sseq)
Next

For ll_row = 1 to dw_list.RowCount()
	 schk   = dw_list.GetItemString(ll_row, "import")
	 sseq   = dw_list.GetItemString(ll_row, "seq")
	 ssudat = dw_list.GetItemString(ll_row, "imhist_sudat")
	 sitnbr = dw_list.GetItemString(ll_row, "imhist_itnbr")
	 sitdsc = dw_list.GetItemString(ll_row, "itdsc")
	 lioqty = dw_list.GetItemNumber(ll_row, "imhist_ioqty")
	 lbulqty= dw_list.GetItemNumber(ll_row, "imhfat_bulqty")
	 sbulsan= dw_list.GetItemString(ll_row, "imhfat_bulsan")
	 lclaim = dw_list.GetItemNumber(ll_row, "imhfat_claim_amt")
	 
	 if schk = 'Y' and sseq='1' then
		 dw_print.Object.t_19.text = ssudat
		 dw_print.Object.t_20.text = sitnbr
		 dw_print.Object.t_21.text = sitdsc
		 dw_print.Object.t_22.text = string(lioqty)
		 dw_print.Object.t_23.text = string(lbulqty)
		 dw_print.Object.t_24.text = sbulsan
		 dw_print.Object.t_25.text = string(lclaim)
		 
	 elseif schk = 'Y' and sseq='2' then
		 dw_print.Object.t_28.text = ssudat
		 dw_print.Object.t_29.text = sitnbr
		 dw_print.Object.t_30.text = sitdsc
		 dw_print.Object.t_31.text = string(lioqty)
		 dw_print.Object.t_32.text = string(lbulqty)
		 dw_print.Object.t_33.text = sbulsan
		 dw_print.Object.t_34.text = string(lclaim)
		 
	 elseif schk = 'Y' and sseq='3' then
		 dw_print.Object.t_36.text = ssudat
		 dw_print.Object.t_37.text = sitnbr
		 dw_print.Object.t_38.text = sitdsc
		 dw_print.Object.t_39.text = string(lioqty)
		 dw_print.Object.t_40.text = string(lbulqty)
		 dw_print.Object.t_41.text = sbulsan
		 dw_print.Object.t_42.text = string(lclaim)
		 
	 elseif schk = 'Y' and sseq='4' then
	    dw_print.Object.t_44.text = ssudat
		 dw_print.Object.t_45.text = sitnbr
		 dw_print.Object.t_46.text = sitdsc
		 dw_print.Object.t_47.text = string(lioqty)
		 dw_print.Object.t_48.text = string(lbulqty)
		 dw_print.Object.t_49.text = sbulsan
		 dw_print.Object.t_50.text = string(lclaim)
		 
	 elseif schk = 'Y' and sseq='5' then
		 dw_print.Object.t_52.text = ssudat
		 dw_print.Object.t_53.text = sitnbr
		 dw_print.Object.t_54.text = sitdsc
		 dw_print.Object.t_55.text = string(lioqty)
		 dw_print.Object.t_56.text = string(lbulqty)
		 dw_print.Object.t_57.text = sbulsan
		 dw_print.Object.t_58.text = string(lclaim)
	 end if 
Next

/* 거래처명 & 공제월 setting */
dw_print.Object.t_4.text = scvnas
dw_print.Object.t_5.text = smm

OpenWithParm(w_print_preview, dw_print)
end event

type p_exit from w_standard_print`p_exit within w_qct_t_01050
string pointer = "c:\erpman\cur\close.cur"
end type

type p_print from w_standard_print`p_print within w_qct_t_01050
string pointer = "c:\erpman\cur\print.cur"
boolean enabled = true
string picturename = "C:\erpman\image\인쇄_up.gif"
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_t_01050
string pointer = "c:\erpman\cur\retrieve.cur"
end type

event p_retrieve::clicked;String syymm, scvcod, sempno, smm, scvnas

dw_ip.Accepttext()
syymm = dw_ip.getitemstring(1, "edate")
smm   = Mid(syymm,5,2)
if isnull(syymm) or syymm = "" then
	f_message_chk(30,'[실사년월]')
	return -1
end if	

scvcod = dw_ip.getitemstring(1, "vendor") 
scvnas = dw_ip.getitemstring(1, "vendorname")  
If Isnull(scvcod) or scvcod = '' then
	scvcod = '%'
	scvnas = ''
End if

if dw_list.Retrieve(gs_sabu, syymm, scvcod) <= 0 then
	f_message_chk(50,'[업체별 CLAIM공제]')
	dw_ip.Setfocus()
	return -1
end if
end event







type st_10 from w_standard_print`st_10 within w_qct_t_01050
end type



type dw_print from w_standard_print`dw_print within w_qct_t_01050
integer x = 3570
integer y = 44
string dataobject = "d_qct_t_01050_p"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_t_01050
integer x = 73
integer y = 40
integer width = 2779
integer height = 140
string dataobject = "d_qct_t_01050"
end type

event dw_ip::itemchanged;
string	sCode, sName,	sname2,	&
			sNull, s_date
int      ireturn 
SetNull(sNull)

// 거래처
IF this.GetColumnName() = "vendor" THEN

	scode = this.GetText()								
	
   ireturn = f_get_name2('V1', 'Y', scode, sname, sname2)    //1이면 실패, 0이 성공	

	this.setitem(1, 'vendor'    , scode)
	this.setitem(1, 'vendorname', sName)
   return ireturn 
	
END IF
end event

event dw_ip::rbuttondown;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

IF	this.getcolumnname() = "vendor"	THEN		
	open(w_vndmst_popup)
	this.SetItem(1, "vendor"    , gs_code)
	this.SetItem(1, "vendorname", gs_codename)
	return
	
ELSEIF this.getcolumnname() = "empno" then
	open(w_sawon_popup)
	this.SetItem(1, "empno"  , gs_code)
	this.SetItem(1, "empname", gs_codename)
	return
END IF	
end event

event dw_ip::itemerror;return 1
end event

event dw_ip::ue_key;SetNull(gs_code)
SetNull(gs_codename)

IF keydown(keyF1!) THEN
	IF	this.getcolumnname() = "vendor"	THEN		
		open(w_vndmst_popup)
		this.SetItem(1, "vendor"    , gs_code)
		this.SetItem(1, "vendorname", gs_codename)
		return
		
	ELSEIF this.getcolumnname() = "empno" then
		open(w_sawon_popup)
		this.SetItem(1, "empno"  , gs_code)
		this.SetItem(1, "empname", gs_codename)
		return
	END IF	
END IF
end event

type dw_list from w_standard_print`dw_list within w_qct_t_01050
integer x = 73
integer y = 204
integer width = 4485
integer height = 2048
string dataobject = "d_qct_t_01050_1"
boolean border = false
end type

event dw_list::itemchanged;string schk
long   ll_row, ll_cnt=1

dw_list.AcceptText()
For ll_row = 1 to dw_list.RowCount()
	 schk   = dw_list.GetItemString(ll_row, "import")
	 if schk = 'Y' then
		 ll_cnt ++
	end if 
Next

if ll_cnt > 5 then
	For ll_row = 1 to dw_list.RowCount()
		 dw_list.SetItem(ll_row, "import", 'N')
	Next
	Messagebox("확인","중요불량내역은 5개만 선택이 가능합니다", StopSign!)
	return
end if
end event

event dw_list::itemfocuschanged;//string schk
//long   ll_row, ll_cnt=1
//
//dw_list.AcceptText()
//For ll_row = 1 to dw_list.RowCount()
//	 schk   = dw_list.GetItemString(ll_row, "import")
//	 if schk = 'Y' then
//		 ll_cnt ++
//	end if 
//Next
//
//if ll_cnt > 5 then
//	For ll_row = 1 to dw_list.RowCount()
//		 dw_list.SetItem(ll_row, "import", 'N')
//	Next
//	Messagebox("확인","중요불량내역은 5개만 선택이 가능합니다", StopSign!)
//	return
//end if
end event

type rr_2 from roundrectangle within w_qct_t_01050
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 200
integer width = 4517
integer height = 2072
integer cornerheight = 40
integer cornerwidth = 55
end type

