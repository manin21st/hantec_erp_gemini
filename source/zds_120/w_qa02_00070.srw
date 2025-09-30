$PBExportHeader$w_qa02_00070.srw
$PBExportComments$사내 검사 등록
forward
global type w_qa02_00070 from window
end type
type p_mod1 from uo_picture within w_qa02_00070
end type
type p_ins1 from uo_picture within w_qa02_00070
end type
type p_del1 from uo_picture within w_qa02_00070
end type
type dw_insert_dtl from u_d_select_sort within w_qa02_00070
end type
type p_del2 from uo_picture within w_qa02_00070
end type
type p_ins2 from uo_picture within w_qa02_00070
end type
type dw_insert from u_d_select_sort within w_qa02_00070
end type
type pb_3 from u_pb_cal within w_qa02_00070
end type
type pb_2 from u_pb_cal within w_qa02_00070
end type
type p_exit from uo_picture within w_qa02_00070
end type
type p_can from uo_picture within w_qa02_00070
end type
type p_mod2 from uo_picture within w_qa02_00070
end type
type p_inq from uo_picture within w_qa02_00070
end type
type p_search from uo_picture within w_qa02_00070
end type
type dw_list from u_d_select_sort within w_qa02_00070
end type
type cb_1 from commandbutton within w_qa02_00070
end type
type cb_cancel from commandbutton within w_qa02_00070
end type
type cb_retrieve from commandbutton within w_qa02_00070
end type
type cb_exit from commandbutton within w_qa02_00070
end type
type cb_save from commandbutton within w_qa02_00070
end type
type rr_2 from roundrectangle within w_qa02_00070
end type
type rr_3 from roundrectangle within w_qa02_00070
end type
type dw_1 from datawindow within w_qa02_00070
end type
type rr_1 from roundrectangle within w_qa02_00070
end type
type rr_4 from roundrectangle within w_qa02_00070
end type
end forward

shared variables

end variables

global type w_qa02_00070 from window
integer width = 4795
integer height = 2868
boolean titlebar = true
string title = "사내 검사 등록"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
p_mod1 p_mod1
p_ins1 p_ins1
p_del1 p_del1
dw_insert_dtl dw_insert_dtl
p_del2 p_del2
p_ins2 p_ins2
dw_insert dw_insert
pb_3 pb_3
pb_2 pb_2
p_exit p_exit
p_can p_can
p_mod2 p_mod2
p_inq p_inq
p_search p_search
dw_list dw_list
cb_1 cb_1
cb_cancel cb_cancel
cb_retrieve cb_retrieve
cb_exit cb_exit
cb_save cb_save
rr_2 rr_2
rr_3 rr_3
dw_1 dw_1
rr_1 rr_1
rr_4 rr_4
end type
global w_qa02_00070 w_qa02_00070

type variables
char  ic_status

String     is_today              //시작일자
String     is_totime             //시작시간
String     is_window_id      //윈도우 ID
String     is_usegub           //이력관리 여부

String     is_ispec,  is_jijil 

String ls_dwchk		//선택한 데이터윈도우 구분
end variables

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

///////////////////////////////////////////////////////////////////////////
dw_1.settransobject(sqlca)
dw_list.settransobject(sqlca)
dw_insert.settransobject(sqlca)
dw_insert_dtl.settransobject(sqlca)

p_can.TriggerEvent("clicked")

f_child_saupj(dw_1, 'pdtgu', gs_saupj)
end event

on w_qa02_00070.create
this.p_mod1=create p_mod1
this.p_ins1=create p_ins1
this.p_del1=create p_del1
this.dw_insert_dtl=create dw_insert_dtl
this.p_del2=create p_del2
this.p_ins2=create p_ins2
this.dw_insert=create dw_insert
this.pb_3=create pb_3
this.pb_2=create pb_2
this.p_exit=create p_exit
this.p_can=create p_can
this.p_mod2=create p_mod2
this.p_inq=create p_inq
this.p_search=create p_search
this.dw_list=create dw_list
this.cb_1=create cb_1
this.cb_cancel=create cb_cancel
this.cb_retrieve=create cb_retrieve
this.cb_exit=create cb_exit
this.cb_save=create cb_save
this.rr_2=create rr_2
this.rr_3=create rr_3
this.dw_1=create dw_1
this.rr_1=create rr_1
this.rr_4=create rr_4
this.Control[]={this.p_mod1,&
this.p_ins1,&
this.p_del1,&
this.dw_insert_dtl,&
this.p_del2,&
this.p_ins2,&
this.dw_insert,&
this.pb_3,&
this.pb_2,&
this.p_exit,&
this.p_can,&
this.p_mod2,&
this.p_inq,&
this.p_search,&
this.dw_list,&
this.cb_1,&
this.cb_cancel,&
this.cb_retrieve,&
this.cb_exit,&
this.cb_save,&
this.rr_2,&
this.rr_3,&
this.dw_1,&
this.rr_1,&
this.rr_4}
end on

on w_qa02_00070.destroy
destroy(this.p_mod1)
destroy(this.p_ins1)
destroy(this.p_del1)
destroy(this.dw_insert_dtl)
destroy(this.p_del2)
destroy(this.p_ins2)
destroy(this.dw_insert)
destroy(this.pb_3)
destroy(this.pb_2)
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.p_mod2)
destroy(this.p_inq)
destroy(this.p_search)
destroy(this.dw_list)
destroy(this.cb_1)
destroy(this.cb_cancel)
destroy(this.cb_retrieve)
destroy(this.cb_exit)
destroy(this.cb_save)
destroy(this.rr_2)
destroy(this.rr_3)
destroy(this.dw_1)
destroy(this.rr_1)
destroy(this.rr_4)
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

event activate;w_mdi_frame.st_window.Text = Upper(is_window_id)
end event

event key;Choose Case key
	Case KeyQ!
		p_inq.TriggerEvent(Clicked!)
	Case KeyS!
		p_mod1.TriggerEvent(Clicked!)
	Case KeyC!
		p_can.TriggerEvent(Clicked!)
	Case KeyX!
		p_exit.TriggerEvent(Clicked!)
End Choose
end event

type p_mod1 from uo_picture within w_qa02_00070
integer x = 1431
integer y = 1424
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;call super::clicked;dw_insert.AcceptText()

Long ll_row, ll_inrow
Long li_seq, ll_jpseq
Double ld_qty, ld_histqty, ld_bulqty, ld_insqty
String ls_bulcod, ls_deptcode, ls_emp, ls_balgu, ls_insdate, ls_insstime, ls_insetime

ld_qty = 0
ld_histqty = dw_list.GetItemNumber(dw_list.GetRow(), 'ioqty')

ll_inrow = dw_insert.RowCount()

FOR ll_row = 1 TO ll_inrow	
	ld_qty = ld_qty + dw_insert.GetItemNumber(ll_row, 'insqty')
	
//	ls_balgu = dw_insert.GetItemString(ll_row, 'balgu')	
//	IF IsNull(ls_balgu) OR ls_balgu = "" THEN	
//		MessageBox("확인", "발생구분을 입력해 주십시요.")
//		Return
//	END IF	
	
	ls_insdate = dw_insert.GetItemString(ll_row, 'ins_date')	
	IF IsNull(ls_insdate) OR ls_insdate = "" THEN	
		MessageBox("확인", "검사일자를 입력해 주십시요.")
		Return
	END IF	
	
	ls_insstime = dw_insert.GetItemString(ll_row, 'ins_stime')	
	IF IsNull(ls_insstime) OR ls_insstime = "" THEN	
		MessageBox("확인", "시작시간을 입력해 주십시요.")
		Return
	END IF	
	
	ls_insetime = dw_insert.GetItemString(ll_row, 'ins_etime')		
	IF IsNull(ls_insetime) OR ls_insetime = "" THEN	
		MessageBox("확인", "종료시간을 입력해 주십시요.")
		Return
	END IF	
	
	ld_insqty = dw_insert.GetItemNumber(ll_row, 'insqty')		
	IF IsNull(ld_insqty) OR ld_insqty <= 0 THEN	
		MessageBox("확인", "검사수량을 입력해 주십시요.")
		Return
	END IF	
	
	ls_emp = dw_insert.GetItemString(ll_row, 'ins_emp')		
	IF IsNull(ls_emp) OR ls_emp = "" THEN	
		MessageBox("확인", "검사자를 입력해 주십시요.")
		Return
	END IF	
	
//	ld_bulqty = dw_insert.GetItemNumber(ll_row, 'bulqty')
//	IF ld_bulqty > 0 THEN
//		ls_bulcod = dw_insert.GetItemString(ll_row, 'bulcod')
//		ls_deptcode = dw_insert.GetItemString(ll_row, 'deptcode')
//	
//		IF IsNull(ls_bulcod) OR ls_bulcod = "" THEN	
//			MessageBox("확인", "불량유형을 입력해 주십시요.")
//			Return
//		END IF
//	
//		IF IsNull(ls_deptcode) OR ls_deptcode = "" THEN	
//			MessageBox("확인", "귀책처를 입력해 주십시요.")
//			Return
//		END IF
//	END IF
NEXT

IF ld_qty > ld_histqty THEN
	ROLLBACK;
	MessageBox('확인', '총수량보다 검사 수량이 더 많습니다. 검사수량을 확인해 주십시요.')
	Return	
END IF

FOR  ll_row = 1	TO		ll_inrow
	
	ll_jpseq = dw_insert.GetItemNumber(ll_row, 'jpseq')
	
	IF IsNull(ll_jpseq) OR ll_jpseq <= 0 THEN	
		SELECT ERPMAN.SEQ_IMHFAT_HT_JPSEQ.NEXTVAL
			INTO :li_seq
		FROM DUAL;
		
		dw_insert.SetItem(ll_row, 'jpseq', li_seq)		
	END IF
NEXT
//////////////////////////////////////////////////////////////////////

IF dw_insert.Update() = 1 THEN
	COMMIT;
ELSE
	ROLLBACK;
	f_Rollback()
	Return
END IF

dw_insert.Reset()

dw_insert.Retrieve(gs_sabu, dw_list.GetItemString(dw_list.GetRow(), 'iojpno'))

SetPointer(Arrow!)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type p_ins1 from uo_picture within w_qa02_00070
integer x = 1088
integer y = 1424
integer width = 178
integer taborder = 10
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\행추가_up.gif"
end type

event clicked;call super::clicked;Long ll_insrow
String ls_date, ls_iojpno

ll_insrow = dw_insert.InsertRow(0)

ls_date = String(Today(), 'yyyymmdd')
ls_iojpno = dw_list.GetItemString(dw_list.GetRow(), 'iojpno')

dw_insert.SetItem(ll_insrow, 'ins_date', ls_date)
dw_insert.SetItem(ll_insrow, 'sabu', gs_sabu)
dw_insert.SetItem(ll_insrow, 'iojpno', ls_iojpno)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\행추가_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\행추가_up.gif"
end event

type p_del1 from uo_picture within w_qa02_00070
integer x = 1262
integer y = 1424
integer width = 178
integer taborder = 10
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\행삭제_up.gif"
end type

event clicked;call super::clicked;String ls_iojpno
Long ll_jpseq, ll_row, ll_bulcount

ll_row = dw_insert.GetRow()

IF ll_row <= 0 THEN
	MessageBox('확인', '삭제할 행을 선택해 주십시요.')
	Return
END IF

ls_iojpno = dw_insert.GetItemString(ll_row, 'iojpno')
ll_jpseq = dw_insert.GetItemNumber(ll_row, 'jpseq')

SELECT COUNT('X')
	INTO :ll_bulcount
FROM IMHFAT_HT_DTL
WHERE SABU = :gs_sabu
	AND IOJPNO = :ls_iojpno
	AND JPSEQ = :ll_jpseq;

IF IsNull(ll_bulcount) OR ll_bulcount = 0 THEN
	dw_insert.DeleteRow(ll_row)
ELSE
	MessageBox('확인', '불량등록된 자료가 존재합니다.')
	Return
END IF

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\행삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\행삭제_up.gif"
end event

type dw_insert_dtl from u_d_select_sort within w_qa02_00070
event ue_downenter pbm_dwnprocessenter
integer x = 1865
integer y = 1612
integer width = 2693
integer height = 704
integer taborder = 40
string dataobject = "d_qa02_00070_4"
boolean border = false
boolean hsplitscroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemchanged;call super::itemchanged;If row < 1 Then Return

Choose Case dwo.name
	Case 'deptcode'		
		If Trim(data) = '' OR IsNull(data) Then
			This.SetItem(row, 'cvnas', '')
			Return
		End If
		
		This.SetItem(row, 'cvnas', f_get_name5('11', data, ''))
END Choose		
end event

event itemerror;Return 1
end event

event rbuttondown;call super::rbuttondown;If row < 1 Then Return

Choose Case dwo.name		
	Case 'deptcode'
		gs_gubun = '4'
		
		Open(w_vndmst_popup)
		
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
		This.SetItem(row, 'deptcode', gs_code)
		This.SetItem(row, 'cvnas', f_get_name5('11', gs_code, ''))
END Choose
end event

event updatestart;/* Update() function 호출시 user 설정 */
//long k, lRowCount
//
//lRowCount = this.RowCount()
//
//FOR k = 1 TO lRowCount
//   IF NewModified! = this.GetItemStatus(k, 0, Primary!) THEN
// 	   This.SetItem(k,'crt_user',gs_userid)
//   ELSEIF DataModified! = this.GetItemStatus(k, 0, Primary!) THEN 		
//	   This.SetItem(k,'upd_user',gs_userid)
//   END IF	  
//NEXT
//
//
end event

type p_del2 from uo_picture within w_qa02_00070
integer x = 4229
integer y = 1424
integer width = 178
integer taborder = 10
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\행삭제_up.gif"
end type

event clicked;call super::clicked;dw_insert_dtl.DeleteRow(dw_insert_dtl.GetRow())
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\행삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\행삭제_up.gif"
end event

type p_ins2 from uo_picture within w_qa02_00070
integer x = 4055
integer y = 1424
integer width = 178
integer taborder = 10
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\행추가_up.gif"
end type

event clicked;call super::clicked;Long ll_insrow, ll_getins, ll_jpseq
String ls_date, ls_iojpno

ll_getins = dw_insert.GetRow()

IF ll_getins <= 0 THEN
	MessageBox('확인', '불량내역을 등록할 검사 내용을 선택해 주십시요.')
	Return
END IF

ll_insrow = dw_insert_dtl.InsertRow(0)

ls_iojpno = dw_insert.GetItemString(ll_getins, 'iojpno')
ll_jpseq = dw_insert.GetItemNumber(ll_getins, 'jpseq')

IF IsNull(ls_iojpno) OR ls_iojpno = '' OR IsNull(ll_jpseq) THEN
	MessageBox('확인', '검사 내용을 우선 저장 후 등록 가능합니다.')
	Return
END IF

dw_insert_dtl.SetItem(ll_insrow, 'ins_date', ls_date)
dw_insert_dtl.SetItem(ll_insrow, 'sabu', gs_sabu)
dw_insert_dtl.SetItem(ll_insrow, 'iojpno', ls_iojpno)
dw_insert_dtl.SetItem(ll_insrow, 'jpseq', ll_jpseq)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\행추가_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\행추가_up.gif"
end event

type dw_insert from u_d_select_sort within w_qa02_00070
event ue_downenter pbm_dwnprocessenter
integer x = 41
integer y = 1612
integer width = 1783
integer height = 704
integer taborder = 30
string dataobject = "d_qa02_00070_3"
boolean border = false
boolean hsplitscroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemerror;Return 1
end event

event updatestart;/* Update() function 호출시 user 설정 */
//long k, lRowCount
//
//lRowCount = this.RowCount()
//
//FOR k = 1 TO lRowCount
//   IF NewModified! = this.GetItemStatus(k, 0, Primary!) THEN
// 	   This.SetItem(k,'crt_user',gs_userid)
//   ELSEIF DataModified! = this.GetItemStatus(k, 0, Primary!) THEN 		
//	   This.SetItem(k,'upd_user',gs_userid)
//   END IF	  
//NEXT
//
//
end event

event rbuttondown;call super::rbuttondown;If row < 1 Then Return

Choose Case dwo.name		
	Case 'deptcode'
		gs_gubun = '4'
		
		Open(w_vndmst_popup)
		
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
		This.SetItem(row, 'deptcode', gs_code)
		This.SetItem(row, 'cvnas', f_get_name5('11', gs_code, ''))
END Choose		
end event

event itemchanged;call super::itemchanged;If row < 1 Then Return

Choose Case dwo.name
	Case 'deptcode'		
		If Trim(data) = '' OR IsNull(data) Then
			This.SetItem(row, 'cvnas', '')
			Return
		End If
		
		This.SetItem(row, 'cvnas', f_get_name5('11', data, ''))
END Choose
end event

event doubleclicked;call super::doubleclicked;If row < 1 Then Return

String ls_iojpno
Long ll_jpseq

ls_iojpno = dw_insert.GetItemString(row, 'iojpno')
ll_jpseq = dw_insert.GetItemNumber(row, 'jpseq')

dw_insert_dtl.Retrieve(gs_sabu, ls_iojpno, ll_jpseq)
end event

type pb_3 from u_pb_cal within w_qa02_00070
integer x = 2254
integer y = 216
integer taborder = 40
end type

event clicked;call super::clicked;dw_1.Setcolumn('tdate')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_1.SetItem(1, 'tdate', gs_code)
end event

type pb_2 from u_pb_cal within w_qa02_00070
integer x = 1819
integer y = 216
integer taborder = 30
end type

event clicked;call super::clicked;dw_1.Setcolumn('idate')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_1.SetItem(1, 'idate', gs_code)
end event

type p_exit from uo_picture within w_qa02_00070
integer x = 4411
integer y = 16
integer width = 178
integer taborder = 80
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;w_mdi_frame.sle_msg.text =""
//IF wf_warndataloss("종료") = -1 THEN  	RETURN

close(parent)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type p_can from uo_picture within w_qa02_00070
integer x = 4238
integer y = 16
integer width = 178
integer taborder = 70
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

string	sToday, sHouse
sToday = f_Today()

dw_1.SetRedraw(false)

dw_1.Reset()
dw_list.Reset()
dw_insert.Reset()
dw_insert_dtl.Reset()

dw_1.InsertRow(0)
dw_1.SetItem(1, "idate", sToday)
dw_1.SetItem(1, "tdate", sToday)
dw_1.SetItem(1, "edate", sToday)

// 부가세 사업장 설정
//f_mod_saupj(dw_1, 'saupj')
dw_1.SetItem(1, 'saupj', gs_saupj)
f_child_saupj(dw_1,'house', gs_saupj)

//제품창고 지정
  SELECT CVCOD
    INTO :sHouse
	 FROM VNDMST
	WHERE CVGU      = '5'
     AND JUPROD    = '1'
     AND SOGUAN    = '1'
     AND JUMAECHUL = '2'
     AND CVSTATUS  = '0'
     AND JUHANDLE  = '1'
     AND EMAIL     = 'Y'
     AND HOMEPAGE  = 'N'
	  AND IPJOGUN   = :gs_saupj;
dw_1.SetItem(1, "house", sHouse)

dw_1.SetRedraw(true)

////////////////////////////////////////////////////////
//p_mod.enabled = false
//p_mod.picturename = "C:\erpman\image\저장_d.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

type p_mod2 from uo_picture within w_qa02_00070
integer x = 4402
integer y = 1424
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;call super::clicked;dw_insert_dtl.AcceptText()

Long ll_row, ll_inrow
Int li_seq, ll_bulseq
Double ld_qty, ld_histqty, ld_bulqty, ld_insqty
String ls_bulcod, ls_deptcode, ls_emp, ls_balgu, ls_insdate, ls_insstime, ls_insetime

ld_qty = 0
ld_histqty = dw_list.GetItemNumber(dw_list.GetRow(), 'ioqty')

ll_inrow = dw_insert_dtl.RowCount()

FOR ll_row = 1 TO ll_inrow	
	ld_qty = ld_qty + dw_insert_dtl.GetItemNumber(ll_row, 'insqty')
	
	ls_balgu = dw_insert_dtl.GetItemString(ll_row, 'balgu')	
	IF IsNull(ls_balgu) OR ls_balgu = "" THEN	
		MessageBox("확인", "발생구분을 입력해 주십시요.")
		Return
	END IF	
	
	ls_bulcod = dw_insert_dtl.GetItemString(ll_row, 'bulcod')
	ls_deptcode = dw_insert_dtl.GetItemString(ll_row, 'deptcode')

	IF IsNull(ls_bulcod) OR ls_bulcod = "" THEN	
		MessageBox("확인", "불량유형을 입력해 주십시요.")
		Return
	END IF

	IF IsNull(ls_deptcode) OR ls_deptcode = "" THEN	
		MessageBox("확인", "귀책처를 입력해 주십시요.")
		Return
	END IF
NEXT

FOR  ll_row = 1	TO		ll_inrow
	
	ll_bulseq = dw_insert_dtl.GetItemNumber(ll_row, 'bulseq')
	
	IF IsNull(ll_bulseq) OR ll_bulseq <= 0 THEN	
		SELECT SEQ_IMHFAT_HT_DTL_JPSEQ.NEXTVAL
			INTO :ll_bulseq
		FROM DUAL;
		
		dw_insert_dtl.SetItem(ll_row, 'bulseq', ll_bulseq)		
	END IF
NEXT
//////////////////////////////////////////////////////////////////////

IF dw_insert_dtl.Update() = 1 THEN
	COMMIT;
ELSE
	ROLLBACK;
	f_Rollback()
	Return
END IF

dw_insert_dtl.Reset()

dw_insert_dtl.Retrieve(gs_sabu, dw_insert.GetItemString(dw_insert.GetRow(), 'iojpno'), dw_insert.GetItemNumber(dw_insert.GetRow(), 'jpseq'))

SetPointer(Arrow!)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type p_inq from uo_picture within w_qa02_00070
integer x = 4064
integer y = 16
integer width = 178
integer taborder = 10
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

string	sHouse, sGubun, sDate, sTitle, siogbn, pdtgu, sidate, stdate, sempno, sCvcod, sItnbr

if dw_1.accepttext() = -1 then return 

sHouse = dw_1.GetItemString(1, "house")
sDate  = trim(dw_1.GetItemString(1, "edate"))
siDate  = trim(dw_1.GetItemString(1, "idate"))
stDate  = trim(dw_1.GetItemString(1, "tdate"))
siogbn = dw_1.GetItemString(1, "iogbn")
pdtgu = Trim(dw_1.GetItemString(1, "pdtgu"))
sempno = Trim(dw_1.GetItemString(1, "empno"))
sCvcod = Trim(dw_1.GetItemString(1, "cvcod"))
sItnbr = Trim(dw_1.GetItemString(1, "itnbr"))

IF isnull(sHouse) or sHouse = "" 	THEN
	f_message_chk(30,'[창고]')
	dw_1.SetColumn("house")
	dw_1.SetFocus()
	RETURN
END IF

//IF isnull(sEmpno) or sEmpno = "" 	THEN
//	f_message_chk(30,'[승인자]')
//	dw_1.SetColumn("empno")
//	dw_1.SetFocus()
//	RETURN
//END IF

IF isnull(sidate) or sidate = "" 	THEN  sidate = '10000101'
IF isnull(stdate) or stdate = "" 	THEN  stdate = '99991231'

IF isnull(siogbn) or siogbn = "" 	THEN
	siogbn = '%'
END IF

If sCvcod = '' OR IsNull(sCvcod) Then sCvcod = '%'
If sItnbr = '' OR IsNull(sItnbr) Then sItnbr = '%'

/////////////////////////////////////////////////////
// 입고미승인 내역
/////////////////////////////////////////////////////
SetPointer(HourGlass!)

long	lRowCount

dw_list.SetRedraw(False)
dw_list.SetFilter("")
if not(IsNull(pdtgu) or pdtgu = "") then
	dw_list.SetFilter("pdtgu = '" + pdtgu + "'")
end if
dw_list.Filter( )


sGubun = 'Y'
sTitle = '[입고승인내역]'
lRowCount = dw_list.Retrieve(gs_sabu, sHouse, siDate, stdate, siogbn, sempno, gs_saupj, sCvcod, sItnbr)

dw_list.SetRedraw(True)

IF lRowCount < 1	THEN
	f_message_chk(50, sTitle)
	dw_1.SetColumn("house")
	dw_1.SetFocus()
	RETURN
END IF

//p_mod.enabled = true
//p_mod.picturename = "C:\erpman\image\저장_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

type p_search from uo_picture within w_qa02_00070
boolean visible = false
integer x = 3173
integer y = 4
integer width = 178
integer taborder = 90
string picturename = "C:\erpman\image\선택_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

Long i, lcount
string sinsdat, sio_date

IF dw_1.accepttext() = -1 THEN RETURN 

SetPointer(HourGlass!)

lCount = dw_list.RowCount()


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\button_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\button_up.gif"
end event

type dw_list from u_d_select_sort within w_qa02_00070
event ue_downenter pbm_dwnprocessenter
integer x = 41
integer y = 440
integer width = 4517
integer height = 944
integer taborder = 20
string dataobject = "d_qa02_00070_2"
boolean border = false
boolean hsplitscroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemerror;Return 1
end event

event updatestart;/* Update() function 호출시 user 설정 */
long k, lRowCount

lRowCount = this.RowCount()

FOR k = 1 TO lRowCount
   IF NewModified! = this.GetItemStatus(k, 0, Primary!) THEN
 	   This.SetItem(k,'crt_user',gs_userid)
   ELSEIF DataModified! = this.GetItemStatus(k, 0, Primary!) THEN 		
	   This.SetItem(k,'upd_user',gs_userid)
   END IF	  
NEXT


end event

event clicked;call super::clicked;If row < 1 Then Return

String ls_iojpno

ls_iojpno = This.GetItemString(row, 'iojpno')

dw_insert.Retrieve(gs_sabu, ls_iojpno)
end event

type cb_1 from commandbutton within w_qa02_00070
boolean visible = false
integer x = 3776
integer y = 2472
integer width = 311
integer height = 92
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "일괄선택"
end type

type cb_cancel from commandbutton within w_qa02_00070
boolean visible = false
integer x = 2135
integer y = 2668
integer width = 608
integer height = 92
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취소(&C)"
boolean cancel = true
end type

event clicked;string	sToday
sToday = f_Today()

dw_1.SetRedraw(false)

dw_1.Reset()
dw_list.Reset()

dw_1.InsertRow(0)
dw_1.SetItem(1, "edate", sToday)

dw_1.SetRedraw(true)

////////////////////////////////////////////////////////
cb_save.enabled = False
end event

type cb_retrieve from commandbutton within w_qa02_00070
boolean visible = false
integer x = 242
integer y = 2668
integer width = 608
integer height = 92
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "조회(&R)"
end type

event clicked;string	sHouse, sGubun, sDate, sTitle, siogbn, pdtgu, sidate, stdate, sempno

if dw_1.accepttext() = -1 then return 

sHouse = dw_1.GetItemString(1, "house")
sDate  = trim(dw_1.GetItemString(1, "edate"))
siDate  = trim(dw_1.GetItemString(1, "idate"))
stDate  = trim(dw_1.GetItemString(1, "tdate"))
siogbn = dw_1.GetItemString(1, "iogbn")
pdtgu = Trim(dw_1.GetItemString(1, "pdtgu"))
sempno = Trim(dw_1.GetItemString(1, "empno"))

IF isnull(sHouse) or sHouse = "" 	THEN
	f_message_chk(30,'[창고]')
	dw_1.SetColumn("house")
	dw_1.SetFocus()
	RETURN
END IF

IF isnull(sEmpno) or sEmpno = "" 	THEN
	f_message_chk(30,'[승인자]')
	dw_1.SetColumn("house")
	dw_1.SetFocus()
	RETURN
END IF

IF isnull(sidate) or sidate = "" 	THEN  sidate = '10000101'
IF isnull(stdate) or stdate = "" 	THEN  stdate = '99991231'

IF isnull(siogbn) or siogbn = "" 	THEN
	siogbn = '%'
END IF

/////////////////////////////////////////////////////
// 입고미승인 내역
/////////////////////////////////////////////////////
SetPointer(HourGlass!)

long	lRowCount

dw_list.SetRedraw(False)
dw_list.SetFilter("")
if not(IsNull(pdtgu) or pdtgu = "") then
	dw_list.SetFilter("pdtgu = '" + pdtgu + "'")
end if
dw_list.Filter( )

sGubun = 'Y'
sTitle = '[입고승인현황]'
lRowCount = dw_list.Retrieve(gs_sabu, sHouse, siDate, stdate, siogbn, sempno)

dw_list.SetRedraw(True)

IF lRowCount < 1	THEN
	f_message_chk(50, sTitle)
	dw_1.SetColumn("house")
	dw_1.SetFocus()
	RETURN
END IF

cb_save.enabled = true


end event

type cb_exit from commandbutton within w_qa02_00070
boolean visible = false
integer x = 2766
integer y = 2668
integer width = 608
integer height = 92
integer taborder = 70
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "종료(&X)"
boolean cancel = true
end type

event clicked;
close(parent)


end event

type cb_save from commandbutton within w_qa02_00070
boolean visible = false
integer x = 873
integer y = 2668
integer width = 608
integer height = 92
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "승인저장(&S)"
end type

event clicked;
if dw_1.AcceptText() = -1 then return
if dw_list.AcceptText() = -1 then return

IF dw_list.RowCount() < 1	THEN	RETURN

////////////////////////////////////////////////////////
string	sDate, sEmpno, sHouse, sCheck, sNull, sSalegu
dec{3}	dQty
dec{5}   dPrice
long		lRow

sHouse = dw_1.GetItemString(1, "house")
sDate  = trim(dw_1.GetItemString(1, "edate"))
sEmpno = dw_1.GetItemString(1, "empno")

IF isnull(sHouse) or sHouse = "" 	THEN
	f_message_chk(30,'[창고]')
	dw_1.SetColumn("house")
	dw_1.SetFocus()
	RETURN
END IF

IF isnull(sDate) or sDate = "" 	THEN
	f_message_chk(30,'[입고승인일]')
	dw_1.SetColumn("edate")
	dw_1.SetFocus()
	RETURN
END IF

SetNull(sNull)
////////////////////////////////////////////////////////

IF f_msg_update() = -1 	THEN	RETURN

SetPointer(HourGlass!)

FOR  lRow = 1	TO		dw_list.RowCount()
NEXT


//////////////////////////////////////////////////////////////////////

IF dw_list.Update() = 1 THEN
	COMMIT;
ELSE
	ROLLBACK;
	f_Rollback()
	Return
END IF

dw_list.Reset()
cb_save.enabled = False

SetPointer(Arrow!)

end event

type rr_2 from roundrectangle within w_qa02_00070
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 37
integer y = 180
integer width = 4535
integer height = 216
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_3 from roundrectangle within w_qa02_00070
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 416
integer width = 4544
integer height = 984
integer cornerheight = 40
integer cornerwidth = 46
end type

type dw_1 from datawindow within w_qa02_00070
event ue_downenter pbm_dwnprocessenter
event ud_downkey pbm_dwnkey
integer x = 78
integer y = 192
integer width = 4421
integer height = 192
integer taborder = 10
string dataobject = "d_qa02_00070_1"
boolean border = false
boolean livescroll = true
end type

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ud_downkey;
IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF

if keydown(keydelete!) and this.getcolumnname() = 'iogbn' then
	string snull
	setnull(snull)
	setitem(1, "iogbn", snull)
end if
end event

event rbuttondown;string shouse, sPass, snull
SetNull(snull)
gs_code = ''
gs_codename = ''
gs_gubun = ''

this.accepttext() 
// 입고승인담당자
IF this.GetColumnName() = 'empno'	THEN
   gs_gubun = '2' 
	gs_code = this.getitemstring(1, 'house')
	shouse  = gs_code
	Open(w_depot_emp_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

   If isnull(shouse) or shouse = '' or shouse <> gs_gubun then 
		SELECT DAJIGUN
		  INTO :sPass
		  FROM VNDMST
		 WHERE CVCOD = :gs_gubun AND 
				 CVGU = '5'		  AND
				 CVSTATUS = '0' ;
		 
		if sqlca.sqlcode <> 0 	then
			f_message_chk(33,'[출고창고]')
			return 
		end if
	
		IF not (sPass ="" OR IsNull(sPass)) THEN
			OpenWithParm(W_PGM_PASS,spass)
			IF Message.StringParm = "CANCEL" THEN 
				return 
			END IF		
		END IF
   End if
	
	SetItem(1,"house",gs_gubun)
	SetItem(1,"empno",gs_code)
	SetItem(1,"name",gs_codename)

ELSEIF this.GetColumnName() = "cvcod" THEN
	gs_gubun ='1'
	Open(w_vndmst_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then
		return
   ELSEIF gs_gubun = '3' then  //3:은행,4:부서,5:창고   
      f_message_chk(70, '[출고처]')
		this.SetItem(1, "cvcod", snull)
		this.SetItem(1, "cvnas", snull)
      return 1  		
   END IF
	this.SetItem(1, "cvcod", gs_Code)
	this.SetItem(1, "cvnas", gs_Codename)

ELSEIF this.GetColumnName() = "itnbr" THEN

	Open(w_itemas_popup)
	
	If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
	
	This.SetItem(row, 'itnbr', gs_code)
	This.SetItem(row, 'itdsc', f_get_name5('13', gs_code, ''))
	
END IF
end event

event itemerror;return 1
end event

event itemchanged;string	sCode, sName,	&
			sDate, sHouse, &
			sYN,	 sNull, sname2, sPass, ssaupj
int      ireturn 			
long     k

SetNull(sNull)

IF this.GetColumnName() = 'edate' THEN

	sDate = TRIM(this.gettext())
   if ic_status = '1' then 
		For k = 1 to dw_list.RowCount() 
			dw_list.object.io_check[k] = 'N'
		Next	
	end if
	
	IF sdate = '' or isnull(sdate) then return
	
	IF f_datechk(sDate) = -1	then
		f_message_chk(35,'[입고승인일]')
		this.setitem(1, "edate", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = 'idate' THEN

	sDate = TRIM(this.gettext())
	
	IF sdate = '' or isnull(sdate) then return
	
	IF f_datechk(sDate) = -1	then
		f_message_chk(35,'[의뢰일자]')
		this.setitem(1, "idate", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = 'tdate' THEN

	sDate = TRIM(this.gettext())
	
	IF sdate = '' or isnull(sdate) then return
	
	IF f_datechk(sDate) = -1	then
		f_message_chk(35,'[의뢰일자]')
		this.setitem(1, "tdate", sNull)
		return 1
	END IF
// 창고 -> 매출여부 확인
ELSEIF this.GetColumnName() = 'house' THEN

	sHouse = this.gettext()
	
	SELECT HOMEPAGE, DAJIGUN, IPJOGUN
	  INTO :sYN, :sPass, :ssaupj
	  FROM VNDMST
	 WHERE CVCOD = :sHouse AND 
	 		 CVGU = '5'		  AND
			 CVSTATUS = '0' ;
	 
	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[창고]')
		this.setitem(1, "house", sNull)
		this.setitem(1, "empno", sNull)
		this.setitem(1, "name", sNull)
		this.setitem(1, "saupj", sNull)		
		dw_list.reset()
		return 1
	end if

	IF not (sPass ="" OR IsNull(sPass)) THEN
		OpenWithParm(W_PGM_PASS,spass)
		
		IF Message.StringParm = "CANCEL" THEN 
			this.setitem(1, "house", sNull)
			this.setitem(1, "empno", sNull)
			this.setitem(1, "name", sNull)
			this.setitem(1, "saupj", sNull)			
			dw_list.reset()
			return 1
      END IF		
	END IF
	
	this.setitem(1, "empno", sNull)
	this.setitem(1, "name", sNull)
	this.setitem(1, "saupj", ssaupj)
	dw_list.reset()
	
// 입고승인담당자 
ELSEIF this.GetColumnName() = "empno" THEN

	scode = this.GetText()								
	
   if scode = '' 	or isnull(scode) then 
		this.setitem(1, 'name', sname)
      return 
   end if
   this.accepttext()
	
	sname2 = this.getitemstring(1, 'house')
	
	if sname2 = '' or isnull(sname2) then 
	   messagebox("확 인", "창고를 먼저 입력하세요")
		this.setitem(1, "empno", sNull)
		this.setitem(1, "name", sNull)
		return 1
	end if
	
   ireturn = f_get_name2('입고승인자', 'Y', scode, sname, sname2)    //1이면 실패, 0이 성공	

	this.setitem(1, 'empno', scode)
	this.setitem(1, 'name', sname)
   return ireturn 
	
elseif this.getcolumnname() = 'saupj' then 
	scode = this.GetText()								
	f_child_saupj(this, 'house', scode)
	f_child_saupj(this, 'pdtgu', scode)
	
	//SELECT CVCOD INTO :sHouse FROM VNDMST WHERE CVGU = '5' AND INGUAN = 'Y' AND IPJOGUN = :scode;
	//SELECT CVCOD INTO :sHouse FROM VNDMST WHERE CVGU = '5' AND JUPROD = '1' AND IPJOGUN = :scode;
	SELECT CVCOD INTO :sHouse FROM VNDMST
	 WHERE CVGU = '5' AND JUPROD = '1' AND CVGU = '5' AND JUPROD = '1' AND EMAIL = 'Y'
	   AND HOMEPAGE = 'N' AND CVSTATUS = '0' AND JUHANDLE = '1' AND IPJOGUN = :scode;
	this.setitem(1, 'house', sHouse)
ELSEIF this.GetColumnName() = "cvcod" THEN
	scode = this.GetText()
	
	ireturn = f_get_name2('V1', 'Y', scode, sname2, sname)
	this.setitem(1, "cvcod", scode)	
	this.setitem(1, "cvnas", sname2)
	
	RETURN ireturn
ELSEIF this.GetColumnName() = "itnbr" THEN
	
	If Trim(data) = '' OR IsNull(data) Then
		This.SetItem(row, 'itdsc', '')
		Return
	End If
	
	This.SetItem(row, 'itdsc', f_get_name5('13', data, ''))
END IF

end event

event losefocus;dw_1.accepttext()
end event

type rr_1 from roundrectangle within w_qa02_00070
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 1588
integer width = 1810
integer height = 744
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_4 from roundrectangle within w_qa02_00070
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1851
integer y = 1588
integer width = 2720
integer height = 744
integer cornerheight = 40
integer cornerwidth = 46
end type

