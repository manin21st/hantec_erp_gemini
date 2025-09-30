$PBExportHeader$w_sys_005.srw
$PBExportComments$** 환경설정
forward
global type w_sys_005 from window
end type
type p_save from uo_picture within w_sys_005
end type
type p_delete from uo_picture within w_sys_005
end type
type p_insert from uo_picture within w_sys_005
end type
type p_cancel from uo_picture within w_sys_005
end type
type p_exit from uo_picture within w_sys_005
end type
type p_itemdel from uo_picture within w_sys_005
end type
type p_itemname from uo_picture within w_sys_005
end type
type p_print from uo_picture within w_sys_005
end type
type dw_detail1 from datawindow within w_sys_005
end type
type dw_detail2 from datawindow within w_sys_005
end type
type rr_1 from roundrectangle within w_sys_005
end type
type rr_2 from roundrectangle within w_sys_005
end type
type rr_3 from roundrectangle within w_sys_005
end type
type dw_list from datawindow within w_sys_005
end type
end forward

global type w_sys_005 from window
integer width = 4658
integer height = 2440
boolean titlebar = true
string title = "환경 설정"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
p_save p_save
p_delete p_delete
p_insert p_insert
p_cancel p_cancel
p_exit p_exit
p_itemdel p_itemdel
p_itemname p_itemname
p_print p_print
dw_detail1 dw_detail1
dw_detail2 dw_detail2
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
dw_list dw_list
end type
global w_sys_005 w_sys_005

type variables
char c_status

// 자료변경여부 검사
Boolean ib_any_typing     
String	is_window_id
String     is_today              //시작일자
String     is_totime             //시작시간
String     sModStatus
String     is_usegub           //이력관리 여부

/* 이미지 저장 */
Windowobject winobject[]
String is_picutre[]
String is_picutername_base[]
String is_picutername_on[]
end variables

forward prototypes
public function integer wf_err_check ()
public function integer wf_warndataloss (string as_titletext)
public subroutine wf_cb_enabled (boolean pa)
end prototypes

public function integer wf_err_check ();long    row_count, find_count, seek_count
string  line_check 

FOR row_count= 1 TO dw_list.rowcount()
    // 코드 check
    if dw_list.getitemstring(row_count, "lineno") = "" or &       
       isnull(dw_list.getitemstring(row_count, "lineno")) then
       dw_list.setcolumn("lineno")
       dw_list.setrow(row_count)
       messagebox("코드", "코드 입력하십시요", stopsign!)
       dw_list.setfocus()
       return -1
    end if
    // 구분명 check
    if dw_list.getitemstring(row_count, "titlename") = "" or &       
       isnull(dw_list.getitemstring(row_count, "titlename")) then
       dw_list.setcolumn("titlename")
       dw_list.setrow(row_count)
       messagebox("구분명", "구분명을 입력하십시요", stopsign!)
       dw_list.setfocus()
       return -1
    end if
NEXT

FOR row_count=1 TO dw_list.rowcount() - 1
    seek_count = row_count + 1
    line_check = dw_list.getitemstring(row_count, "lineno")    
    find_count  = dw_list.find("lineno = '" + line_check + "'", seek_count, dw_list.rowcount())    
    if find_count > 0 then  /* duplicate */
       messagebox("코드", "동일한 코드가 발생하였읍니다.", stopsign!)
       dw_list.setcolumn("lineno")
       dw_list.setrow(find_count)
       dw_list.setfocus()
       return -1
    end if
NEXT

return 0


end function

public function integer wf_warndataloss (string as_titletext);/*===================================================================
 1. window-level user function : 종료, 등록, 조회시 호출됨
    dw_detail, dw_list 의 typing(datawindow) 변경사항 검사

 2. 계속진행할 경우 변경사항이 저장되지 안음을 경고                                                               

 3. Argument:  as_titletext (warning messagebox)                                                                          
    Return values:                                                   
                                                                  
      *  1 : 변경사항을 저장하지 않고 계속 진행할 경우.
		* -1 : 진행을 중단할 경우.                      
=====================================================================*/
if ib_any_typing = true then 			// EditChanged event(dw_detail)의 typing 상태확인
	Beep(1)
	ib_any_typing = False
	if MessageBox("확인 : " + as_titletext , &
		 "저장하지 않은 값이 있습니다. ~r변경사항을 저장하시겠습니까?", &
		 question!, yesno!) = 1 then
		p_save.SetFocus()
		p_save.TriggerEvent(Clicked!)
		return -1
	end if
end if
return 1	  									// (dw_detail) 에 변경사항이 없거나 no일 경우
												// 변경사항을 저장하지 않고 계속진행 
end function

public subroutine wf_cb_enabled (boolean pa);p_ItemName.Enabled = not pa
p_insert.enabled = pa
p_delete.enabled = pa
p_save.enabled   = pa

IF pa = False THEN
	p_ItemName.PictureName = "C:\ERPMAN\image\추가_up.gif"
	p_insert.PictureName = "C:\ERPMAN\image\행추가_d.gif"
	p_delete.PictureName = "C:\ERPMAN\image\행삭제_d.gif"
	p_save.PictureName   = "C:\ERPMAN\image\저장_d.gif"
ELSE
	p_ItemName.PictureName = "C:\ERPMAN\image\추가_d.gif"
	p_insert.PictureName = "C:\ERPMAN\image\행추가_up.gif"
	p_delete.PictureName = "C:\ERPMAN\image\행삭제_up.gif"
	p_save.PictureName   = "C:\ERPMAN\image\저장_up.gif"
END IF
end subroutine

event open;Integer  li_idx

li_idx = w_mdi_frame.dw_listbar.InsertRow(0)
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_id',Upper(This.ClassName()))
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_name',Upper(This.Title))
w_mdi_frame.Postevent("ue_barrefresh")

is_today = f_today()
is_totime = f_totime()
is_window_id = this.ClassName()

w_mdi_frame.st_window.Text = Upper(is_window_id)

SELECT "SUB2_T"."OPEN_HISTORY"  
  INTO :is_usegub 
  FROM "SUB2_T"  
 WHERE "SUB2_T"."WINDOW_NAME" = :is_window_id   ;

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
dw_detail1.settransobject(sqlca)
dw_detail2.settransobject(sqlca)

ib_any_typing = False
p_itemdel.Enabled = False
p_itemdel.PictureName = "C:\ERPMAN\image\삭제_d.gif"

dw_detail1.reset()
dw_detail1.retrieve()


end event

on w_sys_005.create
this.p_save=create p_save
this.p_delete=create p_delete
this.p_insert=create p_insert
this.p_cancel=create p_cancel
this.p_exit=create p_exit
this.p_itemdel=create p_itemdel
this.p_itemname=create p_itemname
this.p_print=create p_print
this.dw_detail1=create dw_detail1
this.dw_detail2=create dw_detail2
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
this.dw_list=create dw_list
this.Control[]={this.p_save,&
this.p_delete,&
this.p_insert,&
this.p_cancel,&
this.p_exit,&
this.p_itemdel,&
this.p_itemname,&
this.p_print,&
this.dw_detail1,&
this.dw_detail2,&
this.rr_1,&
this.rr_2,&
this.rr_3,&
this.dw_list}
end on

on w_sys_005.destroy
destroy(this.p_save)
destroy(this.p_delete)
destroy(this.p_insert)
destroy(this.p_cancel)
destroy(this.p_exit)
destroy(this.p_itemdel)
destroy(this.p_itemname)
destroy(this.p_print)
destroy(this.dw_detail1)
destroy(this.dw_detail2)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
destroy(this.dw_list)
end on

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

type p_save from uo_picture within w_sys_005
integer x = 4009
integer y = 20
integer width = 178
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\ERPMAN\image\저장_up.gif"
end type

event clicked;call super::clicked;integer f_check

dw_list.AcceptText()

// 입력 error
if wf_err_check() = -1 then return

if f_msg_update() = -1 then return  //저장 Yes/No ?
if dw_list.Update() = 1 then
	COMMIT;
	w_mdi_frame.sle_msg.text = "저장되었습니다!"	
	ib_any_typing = False
else
	f_message_chk(32,'[자료저장 실패]') 
	ROLLBACK;
   w_mdi_frame.sle_msg.text = "저장작업 실패 하였습니다!"
	return 
end if

end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\ERPMAN\image\저장_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\ERPMAN\image\저장_dn.gif"
end event

type p_delete from uo_picture within w_sys_005
integer x = 3831
integer y = 20
integer width = 178
string pointer = "C:\erpman\cur\delrow.cur"
string picturename = "C:\ERPMAN\image\행삭제_up.gif"
end type

event clicked;call super::clicked;long 	lcRow

if MessageBox("행삭제", "선택한 행을 삭제하시겠습니까 ?", Question!, YesNo!) = 2 then return

lcRow = dw_list.GetRow()
if lcRow <= 0 then 
	f_message_chk(36,'[자료선택]')
	return
end if	
dw_list.DeleteRow(lcRow)
if dw_list.Update() <> 1 then
   f_message_chk(31,'[삭제실패]') 
	ROLLBACK;
	Return
end if
COMMIT;



end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\ERPMAN\image\행삭제_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\ERPMAN\image\행삭제_dn.gif"
end event

type p_insert from uo_picture within w_sys_005
integer x = 3653
integer y = 20
integer width = 178
string pointer = "C:\erpman\cur\addrow.cur"
string picturename = "C:\ERPMAN\image\행추가_up.gif"
end type

event clicked;long lcRow, ldRow

if dw_list.GetRow() > 0 then
	lcRow = dw_list.GetRow() + 1
	dw_list.insertrow(lcRow)
ELSE
	lcRow = dw_list.insertrow(lcRow)
END IF

ldRow = dw_detail2.GetRow()
dw_list.setitem(lcRow, "sysgu", dw_detail2.getitemString(ldRow, "sysgu"))
dw_list.setitem(lcRow, "serial", dw_detail2.getitemNumber(ldRow, "serial"))

dw_list.setcolumn("lineno")
dw_list.setrow(lcRow)
dw_list.scrolltorow(lcRow)
dw_list.setfocus()

end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\ERPMAN\image\행추가_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\ERPMAN\image\행추가_dn.gif"
end event

type p_cancel from uo_picture within w_sys_005
integer x = 4187
integer y = 20
integer width = 178
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\ERPMAN\image\취소_up.gif"
end type

event clicked;Rollback;

dw_detail1.SelectRow(0,False)
dw_detail2.Reset()
dw_list.Reset()

wf_cb_enabled(False)
p_itemdel.Enabled = False
p_itemdel.PictureName = "C:\ERPMAN\image\삭제_d.gif"

end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\ERPMAN\image\취소_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\ERPMAN\image\취소_dn.gif"
end event

type p_exit from uo_picture within w_sys_005
integer x = 4366
integer y = 20
integer width = 178
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\ERPMAN\image\닫기_up.gif"
end type

event clicked;call super::clicked;/*===============================================================                                                                  
  1. DATAWINDOW  dw_detail 에 TYPING 을 했는지 검사 
     저장을 안하고 계속 진행할 경우 DATA lost 임을 경고 
                                                                  
  2. WINDOW LEVEL FUNTION(named wf_warndataloss)
     를 사용한다   
================================================================*/
if wf_warndataloss("종료") = -1 then return
Close(Parent)
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\ERPMAN\image\닫기_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\ERPMAN\image\닫기_dn.gif"
end event

type p_itemdel from uo_picture within w_sys_005
integer x = 3474
integer y = 20
integer width = 178
string pointer = "C:\erpman\cur\delete.cur"
string picturename = "C:\ERPMAN\image\삭제_up.gif"
end type

event clicked;call super::clicked;long 	lcRow

if MessageBox("전산실 확인", "관리구분을 삭제하시겠습니까 ?", Question!, YesNo!) = 2 then return
lcRow = dw_detail2.GetRow()
if lcRow <= 0 then 
	f_message_chk(36,'[자료선택]')
	return
end if	
dw_detail2.DeleteRow(lcRow)
if dw_detail2.Update() <> 1 then
   f_message_chk(31,'[삭제실패]') 
	ROLLBACK;
	Return
end if
COMMIT;
p_itemdel.Enabled = False
p_itemdel.PictureName = "C:\ERPMAN\image\삭제_d.gif"

end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\ERPMAN\image\삭제_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\ERPMAN\image\삭제_dn.gif"
end event

type p_itemname from uo_picture within w_sys_005
integer x = 3296
integer y = 20
integer width = 178
string pointer = "C:\erpman\cur\add.cur"
string picturename = "C:\ERPMAN\image\추가_up.gif"
end type

event clicked;long lcRow
int ii
String pa1, pa2, pa3, srtn_msg

lcRow = dw_detail1.GetRow()
pa1 = mid(dw_detail1.object.rfgub[lcRow],1,1)
pa2 = dw_detail1.object.rfna1[lcRow]
OpenWithParm(w_sys_0051, pa1 + pa2)

srtn_msg = message.StringParm
if srtn_msg <> "ERROR" then
	pa1 = mid(srtn_msg,1,1)
	pa2 = mid(srtn_msg,2,2)
	pa3 = mid(srtn_msg,4,50)
	lcRow = dw_detail2.Find("serial > " + pa2, &
									1, dw_detail2.RowCount())
   dw_detail2.insertrow(lcRow)
	if lcRow = 0 then //맨마지막에 추가
	   lcRow = dw_detail2.RowCount()
	end if	
	dw_detail2.setitem(lcRow, "sysgu", pa1)
   dw_detail2.setitem(lcRow, "serial", Integer(pa2))
	dw_detail2.setitem(lcRow, "titlename", pa3)
	dw_detail2.ScrollToRow (lcRow)
end if

end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\ERPMAN\image\추가_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\ERPMAN\image\추가_dn.gif"
end event

type p_print from uo_picture within w_sys_005
integer x = 3118
integer y = 20
integer width = 178
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\ERPMAN\image\조회_up.gif"
end type

event clicked;call super::clicked;//m_sys_001_mdi.m_system.m_system_p.triggerevent(clicked!)
//OpenSheet(w_sys_p_005,  w_sys_005, 0, Layered!)

Opensheet(w_sys_p_005, w_mdi_frame, 0, Layered!)
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\ERPMAN\image\조회_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\ERPMAN\image\조회_dn.gif"
end event

type dw_detail1 from datawindow within w_sys_005
integer x = 96
integer y = 200
integer width = 2167
integer height = 780
string dataobject = "d_sys_0051"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;if wf_warndataloss("종료") = -1 then return

SelectRow(0,False)
dw_detail2.Reset()
dw_list.Reset()
wf_cb_enabled(False)

if Row > 0 then
	SelectRow(Row,TRUE)
   dw_detail2.Retrieve(this.object.rfgub[Row])	
end if
end event

event getfocus;p_itemdel.Enabled = False
p_itemdel.PictureName = ""
end event

type dw_detail2 from datawindow within w_sys_005
integer x = 2354
integer y = 200
integer width = 2176
integer height = 780
string dataobject = "d_sys_0052"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;long lRow

if wf_warndataloss("종료") = -1 then return

SelectRow(0,False)
dw_list.Reset()

if Row > 0 then
	SelectRow(Row,TRUE)
   lRow = dw_list.Retrieve(this.object.sysgu[Row], this.object.serial[Row])
	wf_cb_enabled(True)
	dw_list.Enabled = True
	if lRow = 0 then
		p_itemdel.Enabled = True
		P_itemdel.PictureName = "C:\ERPMAN\image\삭제_up.gif"
	else	
		p_itemdel.Enabled = False
		P_itemdel.PictureName = "C:\ERPMAN\image\삭제_d.gif"
	end if	
end if
end event

type rr_1 from roundrectangle within w_sys_005
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 82
integer y = 192
integer width = 2194
integer height = 796
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_sys_005
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2345
integer y = 192
integer width = 2194
integer height = 796
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_sys_005
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 82
integer y = 1028
integer width = 4457
integer height = 1260
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_list from datawindow within w_sys_005
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 91
integer y = 1036
integer width = 4439
integer height = 1244
integer taborder = 20
string dataobject = "d_sys_0053"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_downenter;if dw_list.getcolumnname() = "dataname" and &
    dw_list.rowcount() = dw_list.getrow() then
   if p_save.Enabled then p_save.SetFocus()
else
	Send(Handle(this), 256, 9, 0 )
end if
Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;RETURN 1
end event

event editchanged;ib_any_typing = true
end event

event rowfocuschanged;//this.SetRowFocusIndicator(HAND!)

end event

event itemfocuschanged;Long wnd
String ls_data

wnd =Handle(this)

If This.accepttext() = -1 Then Return

IF dwo.name ="titlename" THEN
	f_toggle_kor(wnd)
ELSE
	f_toggle_eng(wnd)
END IF

end event

event itemchanged;String sColName, sData, ls_data
long lcRow, lrRow

lcRow  = GetRow()	
sColName = GetColumnName()
sData = Trim(GetText())
If This.accepttext() = -1 Then Return

if sColName = "lineno" then
	if IsNull(sData) or sData = "" then 
		f_message_chk(1400,'[필수입력]') 
		p_save.Enabled = False
		p_save.PictureName = "C:\ERPMAN\image\저장_d.gif"
		return 1		
	else
		p_save.Enabled = True
		p_save.PictureName = "C:\ERPMAN\image\저장_up.gif"
	end if	
	lrRow = Find("lineno = '" + sData + "'", 1, RowCount())
	if (lcRow <> lrRow) and (lrRow <> 0) then
	   f_message_chk(1,'[자료중복]') 
		p_save.Enabled = False
		p_save.PictureName = "C:\ERPMAN\image\저장_d.gif"
		return 1		
	else
		p_save.Enabled = True
		p_save.PictureName = "C:\ERPMAN\image\저장_up.gif"
	end if
elseif sColName = "titlename" then
	if IsNull(sData) or sData = "" then 
		f_message_chk(1400,'[필수입력]') 
		p_save.Enabled = False
		p_save.PictureName = "C:\ERPMAN\image\저장_d.gif"
		return 1		
	else
		p_save.Enabled = True
		p_save.PictureName = "C:\ERPMAN\image\저장_up.gif"
	end if
end if
return


end event

event getfocus;p_itemdel.Enabled = False
p_itemdel.PictureName = "C:\ERPMAN\image\삭제_d.gif"
end event

event rbuttondown;string sGubun, sRfcod
long	 lRow

lRow  = this.GetRow()	

gs_code = ''
gs_codename = ''
gs_gubun = ''

IF this.GetColumnName() = 'dataname'	THEN
   sGubun = this.getitemstring(lRow, 'gubun') 

   if sGubun = '1' then //국내거래처
	   gs_gubun = '1'
		open(w_vndmst_popup)
	elseif sGubun = '2' then //부서
		open(w_vndmst_4_popup)
	elseif sGubun = '3' then //사번
		Open(w_sawon_popup)
	elseif sGubun = '4' then //창고
		open(w_vndmst_46_popup)
	elseif sGubun = '5' then //품번
		open(w_itemas_popup)
	elseif sGubun = '6' then //계정과목
	elseif sGubun = '7' then //은행코드
	   gs_gubun = '3'
		open(w_vndmst_popup)
	elseif sGubun = '8' then //자금코드
	elseif sGubun = '9' then //참조코드
	   gs_code = this.getitemstring(lRow, 'rfcod')
		
		if gs_code = '' or isnull(gs_code) then 
			messagebox('확 인', '참조구분을 먼저 선택하세요!')
			return 1
		end if
		open(w_reffpf_all_popup)
	end if
	
	IF gs_code = '' or isnull(gs_code) then return 
	
	SetItem(lRow,"dataname",gs_code)

END IF


end event

