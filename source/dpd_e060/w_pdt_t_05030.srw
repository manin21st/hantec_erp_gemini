$PBExportHeader$w_pdt_t_05030.srw
$PBExportComments$외주 재고 BOM전개
forward
global type w_pdt_t_05030 from w_standard_print
end type
type p_process from picture within w_pdt_t_05030
end type
type rr_2 from roundrectangle within w_pdt_t_05030
end type
end forward

global type w_pdt_t_05030 from w_standard_print
string title = "외주 재고 BOM전개"
p_process p_process
rr_2 rr_2
end type
global w_pdt_t_05030 w_pdt_t_05030

type variables
String is_date
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String syymm, scvcod, sempno

dw_ip.Accepttext()
syymm  = dw_ip.getitemstring(1, "edate")
if isnull(syymm) or syymm = "" then
	f_message_chk(30,'[실사년월]')
	return -1
end if	

scvcod  = dw_ip.getitemstring(1, "vendor") 
If Isnull(scvcod) or scvcod = '' then
	scvcod = '%'
End if

if dw_print.Retrieve(gs_sabu, syymm, scvcod) <= 0 then
	f_message_chk(50,'[외주 재고 BOM전개]')
	dw_ip.Setfocus()
	return -1
end if

dw_print.sharedata(dw_list)

return 1

end function

on w_pdt_t_05030.create
int iCurrent
call super::create
this.p_process=create p_process
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_process
this.Control[iCurrent+2]=this.rr_2
end on

on w_pdt_t_05030.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.p_process)
destroy(this.rr_2)
end on

event open;call super::open;is_today = f_today()
is_totime = f_totime()

dw_ip.settransobject(sqlca)
dw_list.settransobject(sqlca)

is_Date = Mid(f_Today(),1,6)
dw_ip.SetItem(1, "edate", is_Date)

///* 사업장 체크 */
//setnull(gs_code)
//If f_check_saupj() = 1 Then
//	dw_ip.SetItem(1, 'porgu', gs_code)
//	if gs_code <> '%' then
//		dw_ip.Modify("porgu.protect=1")
//		dw_ip.Modify("porgu.background.color = 80859087")
//	End if
//End If
end event

event activate;call super::activate;w_mdi_frame.st_window.Text = Upper(is_window_id)
end event

event closequery;call super::closequery;//string s_frday, s_frtime
//
//IF is_usegub = 'Y' THEN
//	s_frday = f_today()
//	
//	s_frtime = f_totime()
//
//   UPDATE "PGM_HISTORY"  
//      SET "EDATE" = :s_frday,   
//          "ETIME" = :s_frtime  
//    WHERE ( "PGM_HISTORY"."L_USERID" = :gs_userid ) AND  
//          ( "PGM_HISTORY"."CDATE" = :is_today ) AND  
//          ( "PGM_HISTORY"."STIME" = :is_totime ) AND  
//          ( "PGM_HISTORY"."WINDOW_NAME" = :is_window_id )   ;
//
//	IF SQLCA.SQLCODE = 0 THEN 
//	   COMMIT;
//   ELSE 	  
//	   ROLLBACK;
//   END IF	  
//END IF	  
//
//w_mdi_frame.st_window.Text = ''
//
//long li_index
//
//li_index = w_mdi_frame.dw_listbar.Find("window_id = '" + Upper(This.ClassName()) + "'", 1, w_mdi_frame.dw_listbar.RowCount())
//
//w_mdi_frame.dw_listbar.DeleteRow(li_index)
//w_mdi_frame.Postevent("ue_barrefresh")
end event

type p_preview from w_standard_print`p_preview within w_pdt_t_05030
integer taborder = 40
string pointer = "c:\erpman\cur\preview.cur"
end type

type p_exit from w_standard_print`p_exit within w_pdt_t_05030
integer taborder = 60
string pointer = "c:\erpman\cur\close.cur"
end type

type p_print from w_standard_print`p_print within w_pdt_t_05030
integer taborder = 50
string pointer = "c:\erpman\cur\print.cur"
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_t_05030
integer taborder = 20
string pointer = "c:\erpman\cur\retrieve.cur"
end type







type st_10 from w_standard_print`st_10 within w_pdt_t_05030
end type



type dw_print from w_standard_print`dw_print within w_pdt_t_05030
integer x = 3570
integer y = 44
string dataobject = "d_pdt_t_05030_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_t_05030
integer x = 411
integer y = 40
integer width = 2729
integer height = 140
integer taborder = 10
string dataobject = "d_pdt_t_05030"
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

event dw_ip::rbuttondown;//SetNull(gs_gubun)
//SetNull(gs_code)
//SetNull(gs_codename)
//
//if rb_item.checked then
//   IF	this.getcolumnname() = "cod1"	THEN		
//	   open(w_itemas_popup)
//	   this.SetItem(1, "cod1", gs_code)
//	   this.SetItem(1, "nam1", gs_codename)
//		return
//   ELSEIF this.getcolumnname() = "cod2" THEN		
//	   open(w_itemas_popup)
//	   this.SetItem(1, "cod2", gs_code)
//	   this.SetItem(1, "nam2", gs_codename)
//		return
//   END IF
//else
//   IF	this.getcolumnname() = "cod1"	THEN		
//	   open(w_workplace_popup)
//	   this.SetItem(1, "cod1", gs_code)
//	   this.SetItem(1, "nam1", gs_codename)
//		return
//   ELSEIF this.getcolumnname() = "cod2" THEN		
//	   open(w_workplace_popup)
//	   this.SetItem(1, "cod2", gs_code)
//	   this.SetItem(1, "nam2", gs_codename)
//		return
//   END IF
//end if	
end event

event dw_ip::itemerror;return 1
end event

event dw_ip::ue_key;call super::ue_key;//SetNull(gs_code)
//SetNull(gs_codename)
//if rb_item.Checked = False then return
//IF keydown(keyF2!) THEN
//   IF	this.getcolumnname() = "cod1"	THEN		
//	   open(w_itemas_popup2)
//	   this.SetItem(1, "cod1", gs_code)
//	   this.SetItem(1, "nam1", gs_codename)
//	   return 
//   ELSEIF this.getcolumnname() = "cod2" THEN		
//	   open(w_itemas_popup2)
//	   this.SetItem(1, "cod2", gs_code)
//	   this.SetItem(1, "nam2", gs_codename)
//	   return 
//   END IF
//END IF  
end event

type dw_list from w_standard_print`dw_list within w_pdt_t_05030
integer x = 73
integer y = 212
integer width = 4485
integer height = 2092
integer taborder = 30
string dataobject = "d_pdt_t_05030_1"
boolean border = false
end type

type p_process from picture within w_pdt_t_05030
integer x = 78
integer y = 24
integer width = 178
integer height = 144
integer taborder = 70
boolean bringtotop = true
string picturename = "C:\erpman\image\처리_up.gif"
boolean focusrectangle = false
end type

event clicked;String syymm, scvcod, sempno
dw_list.Reset()

if dw_ip.AcceptText() = -1 then return 

syymm  = dw_ip.getitemstring(1, "edate")
if isnull(syymm) or syymm = "" then
	f_message_chk(30,'[실사년월]')
	return
end if	

scvcod  = dw_ip.getitemstring(1, "vendor") + '%'
If Isnull(scvcod) or scvcod = '' then
	scvcod = '%'
End if

if messagebox("확 인", '외주재고를 BOM에의해 전개하시겠습니까?', &
              Question!, YesNo!, 2) = 2 then return   

SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text = "외주 재고 자료 생성 中 .......... "

sqlca.ERP000002010(gs_sabu, syymm, scvcod)

w_mdi_frame.sle_msg.text = "외주 재고 자료 완료!!!"



end event

type rr_2 from roundrectangle within w_pdt_t_05030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 200
integer width = 4517
integer height = 2116
integer cornerheight = 40
integer cornerwidth = 55
end type

