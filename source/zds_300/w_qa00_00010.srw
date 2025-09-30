$PBExportHeader$w_qa00_00010.srw
$PBExportComments$** 품질 기준 정보 등록
forward
global type w_qa00_00010 from window
end type
type p_crt from uo_picture within w_qa00_00010
end type
type dw_history from datawindow within w_qa00_00010
end type
type p_auto from uo_picture within w_qa00_00010
end type
type p_exit from uo_picture within w_qa00_00010
end type
type p_can from uo_picture within w_qa00_00010
end type
type p_mod from uo_picture within w_qa00_00010
end type
type p_inq from uo_picture within w_qa00_00010
end type
type tab_1 from tab within w_qa00_00010
end type
type tabpage_1 from userobject within tab_1
end type
type dw_list1 from datawindow within tabpage_1
end type
type dw_1 from datawindow within tabpage_1
end type
type rr_1 from roundrectangle within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_list1 dw_list1
dw_1 dw_1
rr_1 rr_1
end type
type tabpage_2 from userobject within tab_1
end type
type cb_1 from commandbutton within tabpage_2
end type
type dw_2 from datawindow within tabpage_2
end type
type dw_list2 from datawindow within tabpage_2
end type
type rr_2 from roundrectangle within tabpage_2
end type
type tabpage_2 from userobject within tab_1
cb_1 cb_1
dw_2 dw_2
dw_list2 dw_list2
rr_2 rr_2
end type
type tabpage_3 from userobject within tab_1
end type
type dw_list3 from datawindow within tabpage_3
end type
type dw_3 from datawindow within tabpage_3
end type
type rr_3 from roundrectangle within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_list3 dw_list3
dw_3 dw_3
rr_3 rr_3
end type
type tabpage_4 from userobject within tab_1
end type
type dw_list4 from datawindow within tabpage_4
end type
type dw_4 from datawindow within tabpage_4
end type
type cb_2 from commandbutton within tabpage_4
end type
type rr_4 from roundrectangle within tabpage_4
end type
type tabpage_4 from userobject within tab_1
dw_list4 dw_list4
dw_4 dw_4
cb_2 cb_2
rr_4 rr_4
end type
type tab_1 from tab within w_qa00_00010
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type
end forward

global type w_qa00_00010 from window
integer width = 4658
integer height = 2540
boolean titlebar = true
string title = "검사기준 등록"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
p_crt p_crt
dw_history dw_history
p_auto p_auto
p_exit p_exit
p_can p_can
p_mod p_mod
p_inq p_inq
tab_1 tab_1
end type
global w_qa00_00010 w_qa00_00010

type variables
boolean ib_ItemError, ib_any_typing
char ic_status
string is_Date
int  ii_Last_Jpno

String     is_today              //시작일자
String     is_totime             //시작시간
String     is_window_id      //윈도우 ID
String     is_usegub           //이력관리 여부

str_itnct  lstr_itnct
end variables

forward prototypes
public subroutine wf_init ()
public function integer wf_insert_history (ref datawindow adw)
public subroutine wf_excel_down (datawindow adw_excel)
end prototypes

public subroutine wf_init ();
ib_any_typing = FALSE

tab_1.tabpage_1.dw_1.SetRedraw(false)
tab_1.tabpage_1.dw_1.Reset()
tab_1.tabpage_1.dw_1.InsertRow(0)
tab_1.tabpage_1.dw_list1.Reset()

tab_1.tabpage_1.dw_1.SetRedraw(true)

tab_1.tabpage_2.dw_2.SetRedraw(false)
tab_1.tabpage_2.dw_2.Reset()
tab_1.tabpage_2.dw_2.InsertRow(0)
tab_1.tabpage_2.dw_list2.Reset()

tab_1.tabpage_2.dw_2.SetRedraw(True)

tab_1.tabpage_3.dw_3.SetRedraw(false)
tab_1.tabpage_3.dw_3.Reset()
tab_1.tabpage_3.dw_3.InsertRow(0)
tab_1.tabpage_3.dw_list3.Reset()

tab_1.tabpage_3.dw_3.SetRedraw(True)

tab_1.tabpage_4.dw_4.SetRedraw(false)
tab_1.tabpage_4.dw_4.Reset()
tab_1.tabpage_4.dw_4.InsertRow(0)
tab_1.tabpage_4.dw_list4.Reset()

tab_1.tabpage_4.dw_4.SetRedraw(True)

tab_1.tabpage_1.dw_1.SetColumn("gubun")
tab_1.tabpage_1.dw_1.SetFocus()


// 초기화
//tab_1.SelectedTab = 1


end subroutine

public function integer wf_insert_history (ref datawindow adw);long		lrow, lins, lcnt
string	sCvcod, sItnbr, sOpseq, sGubun, sChgdat, sQcgub, sQcemp, sBigo
decimal	dShare_rate, dAllow_rate, dAssure_term, dMileage
dwItemStatus l_status

//dw_history.reset()
sChgdat = f_today()


for lrow = 1 to adw.rowcount()
	l_status = adw.getitemstatus(lrow, 0, Primary!)
	if l_status = DataModified! then

		sCvcod  = adw.getitemstring(lrow, "cvcod")
		sItnbr  = adw.getitemstring(lrow, "itnbr")
		sOpseq  = adw.getitemstring(lrow, "opseq")
		sGubun  = adw.getitemstring(lrow, "gubun")
		sQcgub  = adw.getitemstring(lrow, "qcgub")
		sQcemp  = adw.getitemstring(lrow, "qcemp")
		sBigo   = adw.getitemstring(lrow, "bigo")

		dShare_rate = adw.getitemnumber(lrow, "share_rate")
		dAllow_rate = adw.getitemnumber(lrow, "allow_rate")
		dAssure_term= adw.getitemnumber(lrow, "assure_term")
		dMileage = adw.getitemnumber(lrow, "mileage")
		
		SELECT COUNT(*) INTO :lcnt
		  FROM ITEMAS_QC_HIST
		 WHERE CVCOD = :sCvcod AND ITNBR = :sItnbr AND OPSEQ = :sOpseq 
		 AND GUBUN = :sGubun AND CHGDAT = :sChgdat ;
		 
		IF lcnt > 0 THEN
			
			UPDATE ITEMAS_QC_HIST
			   SET QCGUB = :sQcgub, QCEMP = :sQcemp, BIGO = :sBigo, SHARE_RATE = :dShare_rate, 
					 ALLOW_RATE = :dAllow_rate, ASSURE_TERM = :DAssure_term, MILEAGE = :dMileage
			 WHERE CVCOD = :sCvcod AND ITNBR = :sItnbr AND OPSEQ = :sOpseq 
			   AND GUBUN = :sGubun AND CHGDAT = :sChgdat ;
				
		ELSE
			INSERT INTO ITEMAS_QC_HIST
			( 	CVCOD,			ITNBR,			OPSEQ,			GUBUN,			QCGUB,			QCEMP,
				CHGDAT,			SHARE_RATE,		ALLOW_RATE,		ASSURE_TERM,	MILEAGE,			BIGO		)
			VALUES
			(	:sCvcod,			:sItnbr,			:sOpseq,			:sGubun,			:sQcgub,			:sQcemp,
				:sChgdat,		:dShare_rate,	:dAllow_rate,	:dAssure_term,	:dMileage,		:sBigo	) ;
				
			if sqlca.sqlcode = 0 then
				COMMIT;
			ELSE
				ROLLBACK;
				f_Rollback()
				return -1
			END IF			 
		END IF
		
	
//		lins = dw_history.insertrow(0)
//
//		dw_history.setitem(lins, "cvcod",		adw.getitemstring(lrow, "cvcod"))
//		dw_history.setitem(lins, "itnbr",		adw.getitemstring(lrow, "itnbr"))
//		dw_history.setitem(lins, "opseq",		adw.getitemstring(lrow, "opseq"))
//		dw_history.setitem(lins, "gubun",		adw.getitemstring(lrow, "gubun"))
//		dw_history.setitem(lins, "qcgub",		adw.getitemstring(lrow, "qcgub"))
//		dw_history.setitem(lins, "qcemp",		adw.getitemstring(lrow, "qcemp"))
////		dw_history.setitem(lins, "rfgub",		adw.getitemstring(lrow, "rfgub"))
//		dw_history.setitem(lins, "share_rate",	adw.getitemnumber(lrow, "share_rate"))
//		dw_history.setitem(lins, "allow_rate",	adw.getitemnumber(lrow, "allow_rate"))
//		dw_history.setitem(lins, "assure_term",	adw.getitemnumber(lrow, "assure_term"))
//		dw_history.setitem(lins, "mileage",	adw.getitemnumber(lrow, "mileage"))
//		dw_history.setitem(lins, "bigo",			adw.getitemstring(lrow, "bigo"))
//		dw_history.setitem(lins, "chgdat",		sChgdat);

	end if
next 

//IF dw_history.Update() > 0		THEN
//	COMMIT;
//ELSE
//	ROLLBACK;
//	f_Rollback()
//	return -1
//END IF

return 1
end function

public subroutine wf_excel_down (datawindow adw_excel);String	ls_quota_no
integer	li_rc
string	ls_filepath, ls_filename
boolean	lb_fileexist

li_rc = GetFileSaveName("저장할 파일명을 선택하세요." , ls_filepath , &
											  ls_filename , "XLS" , "Excel Files (*.xls),*.xls")												
IF li_rc = 1 THEN
	IF lb_fileexist THEN
		li_rc = MessageBox("파일저장" , ls_filepath + " 파일이 이미 존재합니다.~r~n" + &
												 "기존의 파일을 덮어쓰시겠습니까?" , Question! , YesNo! , 1)
		IF li_rc = 2 THEN 
			w_mdi_frame.sle_msg.text = "자료다운취소!!!"			
			RETURN
		END IF
	END IF
	
	Setpointer(HourGlass!)
	
 	If uf_save_dw_as_excel(adw_excel,ls_filepath) <> 1 Then
		w_mdi_frame.sle_msg.text = "자료다운실패!!!"
		return
	End If

END IF

w_mdi_frame.sle_msg.text = "자료다운완료!!!"
end subroutine

event open;ListviewItem		lvi_Current
lvi_Current.Data = Upper(This.ClassName())
lvi_Current.Label = This.Title
lvi_Current.PictureIndex = 1

w_mdi_frame.lv_open_menu.additem(lvi_Current)

is_window_id = this.ClassName()
is_today = f_today()
is_totime = f_totime()
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

dw_history.SetTransObject(sqlca)
tab_1.tabpage_1.dw_1.SetTransObject(sqlca)
tab_1.tabpage_1.dw_list1.SetTransObject(sqlca)

tab_1.tabpage_2.dw_2.SetTransObject(sqlca)
tab_1.tabpage_2.dw_list2.SetTransObject(sqlca)

tab_1.tabpage_3.dw_3.SetTransObject(sqlca)
tab_1.tabpage_3.dw_list3.SetTransObject(sqlca)

tab_1.tabpage_4.dw_4.SetTransObject(sqlca)
tab_1.tabpage_4.dw_list4.SetTransObject(sqlca)

tab_1.tabpage_1.dw_1.InsertRow(0)
tab_1.tabpage_2.dw_2.InsertRow(0)
tab_1.tabpage_3.dw_3.InsertRow(0)
tab_1.tabpage_4.dw_4.InsertRow(0)
tab_1.tabpage_1.dw_1.setfocus()

is_Date = f_Today()

p_can.TriggerEvent("clicked")

/* 규격,재질 Text 변경 */

If f_change_name('1') = 'Y' Then
	String sIspecText, sJijilText
	
	sIspectext = f_change_name('2')
	sJijilText = f_change_name('3')
	
	tab_1.tabpage_1.dw_list1.Object.ispec_tx.text =  sIspecText 
	tab_1.tabpage_1.dw_list1.object.jijil_tx.text =  sJijilText
	
	tab_1.tabpage_2.dw_list2.Object.ispec_tx.text =  sIspecText 
	tab_1.tabpage_2.dw_list2.object.jijil_tx.text =  sJijilText
End If

end event

on w_qa00_00010.create
this.p_crt=create p_crt
this.dw_history=create dw_history
this.p_auto=create p_auto
this.p_exit=create p_exit
this.p_can=create p_can
this.p_mod=create p_mod
this.p_inq=create p_inq
this.tab_1=create tab_1
this.Control[]={this.p_crt,&
this.dw_history,&
this.p_auto,&
this.p_exit,&
this.p_can,&
this.p_mod,&
this.p_inq,&
this.tab_1}
end on

on w_qa00_00010.destroy
destroy(this.p_crt)
destroy(this.dw_history)
destroy(this.p_auto)
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.p_mod)
destroy(this.p_inq)
destroy(this.tab_1)
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

long li_index

li_index = w_mdi_frame.lv_open_menu.FindItem(0,This.Title, TRUE,TRUE)

w_mdi_frame.lv_open_menu.DeleteItem(li_index)
w_mdi_frame.st_window.Text = ""
end event

type p_crt from uo_picture within w_qa00_00010
integer x = 3685
integer y = 12
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\생성_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\생성_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\생성_up.gif"
end event

event clicked;call super::clicked;If MessageBox("확인", '사내 검사 기준 정보가 없는 품목이 생성됩니다.', Exclamation!, OKCancel!, 2) = 2 Then Return

INSERT INTO ITEMAS_QC(CVCOD, ITNBR, OPSEQ, GUBUN, QCEMP, QCGUB)                        
     SELECT F.RFNA2, A.ITNBR, '9999', '3', NULL, '1'
     FROM ITEMAS A, REFFPF E, REFFPF F 
     WHERE A.ITTYP IN ('1', '2')
        AND A.GBGUB = '1'
        AND A.ITGU = '5'
        AND E.RFCOD = '03'
        AND E.RFGUB NOT IN ('00', '99')    
        AND F.RFCOD = 'AD'
        AND F.RFGUB NOT IN ('00', '99') 
        AND E.RFNA2 = F.RFGUB
        AND E.RFGUB = A.PDTGU
        AND A.ITNBR NOT IN (SELECT DISTINCT ITNBR FROM ITEMAS_QC WHERE GUBUN = '3');
		  
IF SQLCA.SQLCODE <> 0 THEN
	RollBack;
	MessageBox("생성 오류", "사내 검사 기준 정보 생성 오류")
END IF

Commit;
end event

type dw_history from datawindow within w_qa00_00010
boolean visible = false
integer x = 1138
integer y = 2312
integer width = 686
integer height = 400
integer taborder = 40
string title = "none"
string dataobject = "d_itemas_qa_hist"
boolean border = false
boolean livescroll = true
end type

type p_auto from uo_picture within w_qa00_00010
integer x = 3470
integer y = 12
integer width = 183
integer taborder = 30
boolean originalsize = true
string picturename = "C:\erpman\image\일괄지정_up.gif"
end type

event clicked;call super::clicked;long	lRow
str_qa_standard lst_qa

IF tab_1.SelectedTab = 1	THEN
	gs_gubun = '1' 
	open(w_qa00_00010_popup)
	
	lst_qa = Message.PowerObjectParm
	
	If IsValid(lst_qa) = False Then Return
	
	SetPointer(HourGlass!)
	FOR lRow = 1	TO		tab_1.tabpage_1.dw_list1.RowCount()
		If isNull(lst_qa.s_gubun) = False Then
			tab_1.tabpage_1.dw_list1.SetItem(lRow, "qcgub", lst_qa.s_gubun)
		End If
		If isNull(lst_qa.s_empno) = False Then
			tab_1.tabpage_1.dw_list1.SetItem(lRow, "qcemp", lst_qa.s_empno)
		End If
	NEXT

ELSEIF tab_1.SelectedTab = 2	THEN
	gs_gubun = '2' 
	open(w_qa00_00010_popup)
	
   
	lst_qa = Message.PowerObjectParm
	
	If IsValid(lst_qa) = False Then Return
	
	SetPointer(HourGlass!)
	FOR lRow = 1	TO		tab_1.tabpage_2.dw_list2.RowCount()
		If isNull(lst_qa.s_gubun) = False Then
			tab_1.tabpage_2.dw_list2.SetItem(lRow, "qcgub", lst_qa.s_gubun)
		End If
		If isNull(lst_qa.s_empno) = False Then
			tab_1.tabpage_2.dw_list2.SetItem(lRow, "qcemp", lst_qa.s_empno)
		End If
		If isNull(lst_qa.s_allow) = False Then
			tab_1.tabpage_2.dw_list2.SetItem(lRow, "allow_rate", lst_qa.s_allow)
		End If
	NEXT

ELSEIF tab_1.SelectedTab = 4	THEN
	gs_gubun = '2' 
	open(w_qa00_00010_popup)	
   
	lst_qa = Message.PowerObjectParm
	
	If IsValid(lst_qa) = False Then Return
	
	SetPointer(HourGlass!)
	FOR lRow = 1	TO		tab_1.tabpage_4.dw_list4.RowCount()
		If isNull(lst_qa.s_gubun) = False Then
			tab_1.tabpage_4.dw_list4.SetItem(lRow, "qcgub", lst_qa.s_gubun)
		End If
		If isNull(lst_qa.s_empno) = False Then
			tab_1.tabpage_4.dw_list4.SetItem(lRow, "qcemp", lst_qa.s_empno)
		End If
		If isNull(lst_qa.s_allow) = False Then
			tab_1.tabpage_4.dw_list4.SetItem(lRow, "allow_rate", lst_qa.s_allow)
		End If
	NEXT

ELSE
	gs_gubun = '3' 
	open(w_qa00_00010_popup)
	
	lst_qa = Message.PowerObjectParm
	
	If IsValid(lst_qa) = False Then Return
	
	SetPointer(HourGlass!)
	FOR lRow = 1	TO		tab_1.tabpage_3.dw_list3.RowCount()		
		If isNull(lst_qa.s_gigan) = False Then
			tab_1.tabpage_3.dw_list3.SetItem(lRow, "assure_term", lst_qa.s_gigan)
		End If
		If isNull(lst_qa.s_range) = False Then
			tab_1.tabpage_3.dw_list3.SetItem(lRow, "mileage", lst_qa.s_range)
		End If
		If isNull(lst_qa.s_gigan2) = False Then
			tab_1.tabpage_3.dw_list3.SetItem(lRow, "assure_term2", lst_qa.s_gigan2)
		End If
		If isNull(lst_qa.s_range2) = False Then
			tab_1.tabpage_3.dw_list3.SetItem(lRow, "mileage2", lst_qa.s_range2)
		End If
		If isNull(lst_qa.s_share) = False Then
			tab_1.tabpage_3.dw_list3.SetItem(lRow, "share_rate", lst_qa.s_share)
		End If
	NEXT

END IF

SetPointer(Arrow!)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\일괄지정_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\일괄지정_up.gif"
end event

type p_exit from uo_picture within w_qa00_00010
integer x = 4379
integer y = 12
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;CLOSE(PARENT)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type p_can from uo_picture within w_qa00_00010
integer x = 4206
integer y = 12
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""


wf_init()


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

type p_mod from uo_picture within w_qa00_00010
integer x = 4032
integer y = 12
integer width = 178
integer taborder = 40
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

SetPointer(HourGlass!)

IF f_msg_update() = -1 		THEN	RETURN

Long   ll_no , i
String ls_itnbr 
Dec    ld_gigan , ld_range , ld_share
// 생산품

If Tab_1.SelectedTab = 1 Then
	
	tab_1.tabpage_1.dw_list1.AcceptText()
	
	// 변경이력저장
	if wf_insert_history(tab_1.tabpage_1.dw_list1) = -1 then	return

	IF tab_1.tabpage_1.dw_list1.Update() > 0		THEN
		COMMIT;
	ELSE
		ROLLBACK;
		f_Rollback()
	END IF

ElseIf Tab_1.SelectedTab = 2 Then

	Tab_1.Tabpage_2.dw_list2.AcceptText()

	// 변경이력저장
	if wf_insert_history(tab_1.tabpage_2.dw_list2) = -1 then	return

	IF tab_1.tabpage_2.dw_list2.Update() > 0		THEN
		COMMIT;
	ELSE
		ROLLBACK;
		f_Rollback()
	END IF

ElseIf Tab_1.SelectedTab = 4 Then

	Tab_1.Tabpage_4.dw_list4.AcceptText()

	// 변경이력저장
	if wf_insert_history(tab_1.tabpage_4.dw_list4) = -1 then	return

	IF tab_1.tabpage_4.dw_list4.Update() > 0		THEN
		COMMIT;
	ELSE
		ROLLBACK;
		f_Rollback()
	END IF

Else

	Tab_1.Tabpage_3.dw_list3.AcceptText()

	// 변경이력저장
	if wf_insert_history(tab_1.tabpage_3.dw_list3) = -1 then	return

	IF tab_1.tabpage_3.dw_list3.Update() > 0		THEN
		COMMIT;
	ELSE
		ROLLBACK;
		f_Rollback()
	END IF

End If
p_inq.TriggerEvent("clicked")	

SetPointer(Arrow!)


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type p_inq from uo_picture within w_qa00_00010
integer x = 3858
integer y = 12
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;w_mdi_frame.sle_msg.text =""

string  	sGubun,		&
			sClass,		&
			sItemFrom,	&
			sItemTo,		&
			sCust,		&
			sNull,	spdtgu
STRING ls_ittyp,ls_itcls, sGubun2

SetNull(sNull)

if tab_1.SelectedTab = 1 then
	if tab_1.tabpage_1.dw_1.Accepttext() = -1	then 	return
	if tab_1.tabpage_1.dw_list1.Accepttext() = -1	then 	return
   
	sGubun	= tab_1.tabpage_1.dw_1.GetItemString(1, "gubun")
	sGubun2	= tab_1.tabpage_1.dw_1.GetItemString(1, "gubun2")
	sClass 	= tab_1.tabpage_1.dw_1.GetItemSTring(1, "class")
	sItemFrom= tab_1.tabpage_1.dw_1.GetItemString(1, "itemfrom")
	sItemTo  = tab_1.tabpage_1.dw_1.GetItemString(1, "itemto")
	spdtgu  = tab_1.tabpage_1.dw_1.GetItemString(1, "pdtgu")
   
	IF isnull(sClass) or trim(sClass) = "" 	THEN
		sClass = '%'
	ELSE
		sClass = sClass + '%'
	END IF
	
	IF isnull(sItemFrom) or trim(sItemFrom) = "" 	THEN	sItemFrom = '0'
	IF isnull(sItemTo) 	or trim(sItemTo) = "" 		THEN	sItemTo = 'zzzzzzzzzzzzzzz'
	IF isnull(sGubun2) 	or trim(sGubun2) = "" 		THEN	sGubun2 = '%'
	
	IF tab_1.tabpage_1.dw_list1.Retrieve(sGubun, sItemFrom, sItemTo , sGubun2, spdtgu) < 1	THEN

		f_message_chk(50, '[생산품목현황]')
		tab_1.tabpage_1.dw_1.setcolumn("gubun")
		tab_1.tabpage_1.dw_1.setfocus()
	//	p_can.TriggerEvent("clicked")
		RETURN
	END IF

elseif tab_1.SelectedTab = 2 then
	if tab_1.tabpage_2.dw_2.Accepttext() = -1	then 	return

	sCust		= trim(tab_1.tabpage_2.dw_2.GetItemString(1, "cvcod"))
	ls_ittyp = tab_1.tabpage_2.dw_2.GetItemString(1, "ittyp")
	ls_itcls = tab_1.tabpage_2.dw_2.GetItemString(1, "itcls")  
	sGubun2	= tab_1.tabpage_2.dw_2.GetItemString(1, "gubun2")
	spdtgu	= tab_1.tabpage_2.dw_2.GetItemString(1, "pdtgu")
	sItemTo	= tab_1.tabpage_2.dw_2.GetItemString(1, "itnbr")
	
	If Trim(sItemTo) = '' or IsNull(sItemTo) Then sItemTo = '%'  

	//if isnull(ls_ittyp) or ls_ittyp = "" then ls_ittyp = '%'  필수로 변경 요청 - 20210325 by shingoon
	If Trim(ls_ittyp) = '' OR IsNull(ls_ittyp) Then
		MessageBox('확인', '품목구분을 선택 하십시오!')
		tab_1.tabpage_2.dw_2.SetFocus()
		tab_1.tabpage_2.dw_2.SetColumn('ittyp')
		Return
	End If
	
	if scust="" or isnull(scust) then scust = '%' 
	
	if ls_itcls = "" or isnull(ls_itcls) then 
		ls_itcls = '%'
	else
		ls_itcls = ls_itcls + '%'
	end if

	//IF isnull(sGubun2) 	or trim(sGubun2) = "" 		THEN	sGubun2 = '%'  필수로 변경 요청 - 20210325 by shingoon
	If Trim(sGubun2) = '' OR IsNull(sGubun2) Then
		MessageBox('확인', '조회구분을 선택 하십시오!')
		tab_1.tabpage_2.dw_2.SetFocus()
		tab_1.tabpage_2.dw_2.SetColumn('gubun2')
		Return
	End If
	

	IF	tab_1.tabpage_2.dw_list2.Retrieve(sCust, ls_ittyp, sGubun2, spdtgu, sItemTo) <	1		THEN
		f_message_chk(50, '[구매품목현황]')
		tab_1.tabpage_2.dw_2.setcolumn("ittyp")
		tab_1.tabpage_2.dw_2.setfocus()
		RETURN
	
	END IF

elseif tab_1.SelectedTab = 4 then
	if tab_1.tabpage_4.dw_4.Accepttext() = -1	then 	return

	sCust		= trim(tab_1.tabpage_4.dw_4.GetItemString(1, "cvcod"))
	ls_ittyp = tab_1.tabpage_4.dw_4.GetItemString(1, "ittyp")
	ls_itcls = tab_1.tabpage_4.dw_4.GetItemString(1, "itcls")  
	sGubun2	= tab_1.tabpage_4.dw_4.GetItemString(1, "gubun2")
	spdtgu	= tab_1.tabpage_4.dw_4.GetItemString(1, "pdtgu")
	sItemFrom = tab_1.tabpage_4.dw_4.GetItemString(1, "itnbr")
	
	If Trim(sItemFrom) = '' OR IsNull(sItemFrom) Then
		sItemFrom = '%'
	Else
		sITemFrom = sItemFrom + '%'
	End If

	if isnull(ls_ittyp) or ls_ittyp = "" then ls_ittyp = '%'
	if scust="" or isnull(scust) then scust = '%' 
	
	if ls_itcls = "" or isnull(ls_itcls) then 
		ls_itcls = '%'
	else
		ls_itcls = ls_itcls + '%'
	end if

	IF isnull(sGubun2) 	or trim(sGubun2) = "" 		THEN	sGubun2 = '%'

	IF	tab_1.tabpage_4.dw_list4.Retrieve(sItemFrom, sCust, ls_ittyp, sGubun2, spdtgu) <	1		THEN
		f_message_chk(50, '[구매품목현황]')
		tab_1.tabpage_4.dw_4.setcolumn("ittyp")
		tab_1.tabpage_4.dw_4.setfocus()
		RETURN
	
	END IF

else
	if tab_1.tabpage_3.dw_3.Accepttext() = -1	then 	return

	ls_ittyp	= trim(tab_1.tabpage_3.dw_3.GetItemString(1, "ittyp"))
	ls_itcls = trim(tab_1.tabpage_3.dw_3.GetItemString(1, "itcls"))

	if isnull(ls_ittyp) or ls_ittyp = "" then ls_ittyp = '%'
	if ls_itcls="" or isnull(ls_itcls) then ls_itcls = '%' 


	IF	tab_1.tabpage_3.dw_list3.Retrieve(ls_ittyp, ls_itcls) <	1		THEN
		f_message_chk(50, '[출하품목현황]')
		tab_1.tabpage_3.dw_3.setcolumn("cvcod")
		tab_1.tabpage_3.dw_3.setfocus()
		RETURN
	
	END IF
end if

//////////////////////////////////////////////////////////////////////////

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

type tab_1 from tab within w_qa00_00010
event create ( )
event destroy ( )
integer x = 23
integer y = 100
integer width = 4530
integer height = 2204
integer taborder = 10
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean raggedright = true
integer selectedtab = 2
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
end on

event selectionchanged;/* 규격,재질 Text 변경 */

If f_change_name('1') = 'Y' Then
	String sIspecText, sJijilText
	
	sIspectext = f_change_name('2')
	sJijilText = f_change_name('3')
	
	tab_1.tabpage_1.dw_list1.Object.ispec_tx.text =  sIspecText 
	tab_1.tabpage_1.dw_list1.object.jijil_tx.text =  sJijilText
	
	tab_1.tabpage_2.dw_list2.Object.ispec_tx.text =  sIspecText 
	tab_1.tabpage_2.dw_list2.object.jijil_tx.text =  sJijilText
End If

IF tab_1.SelectedTab = 4 THEN
	p_crt.Visible = True
ELSE
	p_crt.Visible = False
END IF
end event

type tabpage_1 from userobject within tab_1
event create ( )
event destroy ( )
boolean visible = false
integer x = 18
integer y = 96
integer width = 4494
integer height = 2092
long backcolor = 32106727
string text = "제품검사"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_list1 dw_list1
dw_1 dw_1
rr_1 rr_1
end type

on tabpage_1.create
this.dw_list1=create dw_list1
this.dw_1=create dw_1
this.rr_1=create rr_1
this.Control[]={this.dw_list1,&
this.dw_1,&
this.rr_1}
end on

on tabpage_1.destroy
destroy(this.dw_list1)
destroy(this.dw_1)
destroy(this.rr_1)
end on

type dw_list1 from datawindow within tabpage_1
event ue_pressenter pbm_dwnprocessenter
integer x = 23
integer y = 160
integer width = 4434
integer height = 1908
integer taborder = 30
string dataobject = "d_qa00_00010_a1_new"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;
IF this.GetColumnName() = 'qcrmks'	THEN	RETURN 1
Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemchanged;string	sCode, sName, sNull
long		lRow

lRow = this.GetRow()
SetNull(sNull)

// 검사담당자
IF this.GetColumnName() = 'qcemp' THEN

	sCode = this.gettext()
	
	if scode = '' or isnull(scode) then return 
  SELECT "REFFPF"."RFNA1"  
    INTO :sName  
    FROM "REFFPF"  
   WHERE ( "REFFPF"."RFCOD" = '45' ) AND  
         ( "REFFPF"."RFGUB" = :sCode ) AND 
         ( "REFFPF"."RFGUB" <> '00' ) ;
	 
	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[검사담당자]')
		this.setitem(lrow, "qcemp", sNull)
		return 1
	end if
	 
// 검사방법
ELSEIF this.GetColumnName() = 'qcgub' THEN

	sCode = this.gettext()
	if sCode = '1' then	// 무검사
		this.setitem(lRow,'qcemp',sNull)
	end if
	
ELSEIF this.GetColumnName() = 'chgbn' THEN

	sCode = this.gettext()
	if scode = '' or isnull(scode) then return 
	
  SELECT "REFFPF"."RFNA1"  
    INTO :sName  
    FROM "REFFPF"  
   WHERE ( "REFFPF"."RFCOD" = '45' ) AND  
         ( "REFFPF"."RFGUB" = :sCode ) AND 
         ( "REFFPF"."RFGUB" <> '00' ) ;
	 
	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[특채담당자]')
		this.setitem(lrow, "chgbn", sNull)
		return 1
	end if
	 
END IF

end event

event itemerror;return 1
end event

event updatestart;///* Update() function 호출시 user 설정 */
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

event clicked;If row > 0 Then
	If isSelected(row) Then
		SelectRow(row, False)
	Else
		SelectRow(0, False)
		SelectRow(row, True)
	End If
End If
end event

event buttonclicked;If row < 1 Then Return

SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Choose Case dwo.name
	Case 'b_1'
		gs_gubun		= '1'
//		gs_code     = Trim(Object.cvcod[row])
		gs_codename = Trim(Object.itnbr[row])
		
		Open(w_qa00_00010_popup2)
End Choose
end event

type dw_1 from datawindow within tabpage_1
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 5
integer y = 8
integer width = 3776
integer height = 128
integer taborder = 20
string dataobject = "d_qa00_00010_1"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;
IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;return 1
end event

event rbuttondown;gs_code = ''
gs_codename = ''
gs_gubun = ''

string	sItem

IF this.GetColumnName() = 'class' 	THEN

	sItem = this.GetItemString(1, 'gubun')
	OpenWithParm(w_ittyp_popup, sItem)
	
   lstr_itnct = Message.PowerObjectParm	
	
	if isnull(lstr_itnct.s_ittyp) or lstr_itnct.s_ittyp = "" then return 
	
	this.SetItem(1,"gubun",	lstr_itnct.s_ittyp)
	this.SetItem(1,"class", lstr_itnct.s_sumgub)

END IF


// 품목
IF this.GetColumnName() = 'itemfrom' THEN

	open(w_itemas_popup3)
	if isnull(gs_code) or gs_code = "" then return
	this.SetItem(1,"itemfrom",gs_code)

END IF

// 품목
IF this.GetColumnName() = 'itemto' THEN

	open(w_itemas_popup3)
	if isnull(gs_code) or gs_code = "" then return
	this.SetItem(1,"itemto",gs_code)

END IF

end event

type rr_1 from roundrectangle within tabpage_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 148
integer width = 4466
integer height = 1932
integer cornerheight = 40
integer cornerwidth = 55
end type

type tabpage_2 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 96
integer width = 4494
integer height = 2092
long backcolor = 32106727
string text = "수입검사"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
cb_1 cb_1
dw_2 dw_2
dw_list2 dw_list2
rr_2 rr_2
end type

on tabpage_2.create
this.cb_1=create cb_1
this.dw_2=create dw_2
this.dw_list2=create dw_list2
this.rr_2=create rr_2
this.Control[]={this.cb_1,&
this.dw_2,&
this.dw_list2,&
this.rr_2}
end on

on tabpage_2.destroy
destroy(this.cb_1)
destroy(this.dw_2)
destroy(this.dw_list2)
destroy(this.rr_2)
end on

type cb_1 from commandbutton within tabpage_2
integer x = 3794
integer y = 20
integer width = 672
integer height = 104
integer taborder = 40
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "Excel File Download"
end type

event clicked;If this.Enabled Then wf_excel_down(tab_1.tabpage_2.dw_list2)
end event

type dw_2 from datawindow within tabpage_2
event ue_keyenter pbm_dwnprocessenter
integer x = 5
integer y = 8
integer width = 3410
integer height = 136
integer taborder = 20
string dataobject = "d_qa00_00010_2"
boolean border = false
boolean livescroll = true
end type

event ue_keyenter;Send(Handle(this),256,9,0)
Return 1
end event

event rbuttondown;
string	sItem,sNull

setnull(snull)
setnull(gs_code)
setnull(gs_codename)

IF	this.Getcolumnname() = "cvcod"	THEN		
	gs_code = this.GetText()
	IF IsNull(gs_code) THEN 
		this.SetItem(1, "cvcod", snull)
		this.setitem(1, "cvnas", snull)		
	end if
		
	gs_gubun = '1'
	Open(w_vndmst_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then  return

	this.SetItem(1, "cvcod", gs_Code)
	this.setitem(1, "cvnas", gs_CodeName)
END IF

if this.GetColumnName() = 'itcls' then
	sItem = this.GetItemString(1, 'ittyp')
	
	OpenWithParm(w_ittyp_popup, sItem)
	
	lstr_itnct = Message.PowerObjectParm	
	
	if isnull(lstr_itnct.s_ittyp) or lstr_itnct.s_ittyp = "" then return 
	
	this.SetItem(1,"ittyp",	lstr_itnct.s_ittyp)
	this.SetItem(1,"itcls", lstr_itnct.s_sumgub)
end if
end event

event itemchanged;String sCod,sNam,sNam1,snull

scod = this.gettext()
setnull(snull)
IF	this.Getcolumnname() = "cvcod"	THEN		
	f_get_name2("V1", 'Y', scod, snam, snam1)

	this.SetItem(1, "cvcod", scod)
	this.setitem(1, "cvnas", snam)

elseif this.getcolumnname() = 'cvnas' then
	sNam = this.gettext()
	
	if isnull(sNam) or sNam = '' then return
	
	select cvcod, cvnas2 into :sCod, :sNam1 from vndmst
	 where cvnas2 like '%'||:sNam||'%' and rownum = 1 ;
	if sqlca.sqlcode = 0 then
		this.setitem(1,'cvcod',sCod)
		this.setitem(1,'cvnas',sNam1)
	else
		this.setitem(1,'cvcod',snull)
		this.setitem(1,'cvnas',snull)
	end if
	
	return 2
elseif this.getcolumnname() = 'itnbr' then
	if isnull(scod) or scod = '' then return
	
	select itdsc into :sNam from itemas where itnbr = :scod;
	if trim(sNam) = '' or isnull(sNam) or sqlca.sqlcode <> 0 then
		messagebox('확인', '등록된 품번이 아닙니다.')
		return 1
	end if
end if
end event

event itemerror;Return 1
end event

type dw_list2 from datawindow within tabpage_2
event ue_pressenter pbm_dwnprocessenter
integer x = 23
integer y = 160
integer width = 4434
integer height = 1908
integer taborder = 30
string dataobject = "d_qa00_00010_b1_new"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemchanged;
string	sCode, sName, sNull
long		lRow
lRow = this.GetRow()
SetNull(sNull)

// 검사담당자
IF this.GetColumnName() = 'qcemp' THEN

	sCode = this.gettext()
  SELECT "REFFPF"."RFNA1"  
    INTO :sName  
    FROM "REFFPF"  
   WHERE ( "REFFPF"."RFCOD" = '45' ) AND  
         ( "REFFPF"."RFGUB" = :sCode ) AND  
         ( "REFFPF"."RFGUB" <> '00' ) ;
	 
	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[검사담당자]')
		this.setitem(lrow, "qcemp", sNull)
		return 1
	end if
	 
// 검사방법
ELSEIF this.GetColumnName() = 'qcgub' THEN

	sCode = this.gettext()
	if sCode = '1' then	// 무검사
		this.setitem(lRow,'qcemp',sNull)
	end if
	

END IF


string sDate
// 일자
IF this.GetColumnName() = 'danmst_handochdat' THEN
	sDate  = this.gettext()
	IF f_datechk(sDate) = -1	then
		this.setitem(lRow, "danmst_handochdat", sNull)
		return 1
	END IF
END IF


IF this.GetColumnName() = 'danmst_handojidat' THEN
	sDate  = this.gettext()
	IF f_datechk(sDate) = -1	then
		this.setitem(lRow, "danmst_handojidat", sNull)
		return 1
	END IF
END IF

end event

event itemerror;return 1
end event

event updatestart;///* Update() function 호출시 user 설정 */
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

event buttonclicked;If row < 1 Then Return

SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Choose Case dwo.name
	Case 'b_1'
		gs_gubun		= '2'
		gs_code     = Trim(Object.cvcod[row])
		gs_codename = Trim(Object.itnbr[row])
		
		Open(w_qa00_00010_popup2)
End Choose
end event

event clicked;If row > 0 Then
	If isSelected(row) Then
		SelectRow(row, False)
	Else
		SelectRow(0, False)
		SelectRow(row, True)
	End If
End If
end event

type rr_2 from roundrectangle within tabpage_2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 148
integer width = 4466
integer height = 1932
integer cornerheight = 40
integer cornerwidth = 55
end type

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4494
integer height = 2092
long backcolor = 32106727
string text = "클레임정보"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_list3 dw_list3
dw_3 dw_3
rr_3 rr_3
end type

on tabpage_3.create
this.dw_list3=create dw_list3
this.dw_3=create dw_3
this.rr_3=create rr_3
this.Control[]={this.dw_list3,&
this.dw_3,&
this.rr_3}
end on

on tabpage_3.destroy
destroy(this.dw_list3)
destroy(this.dw_3)
destroy(this.rr_3)
end on

type dw_list3 from datawindow within tabpage_3
event ue_pressenter pbm_dwnprocessenter
integer x = 23
integer y = 160
integer width = 4434
integer height = 1908
integer taborder = 40
string dataobject = "d_qa00_00010_c1_new"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemchanged;
string	sCode, sName, sNull
long		lRow
lRow = this.GetRow()
SetNull(sNull)

// 검사담당자
IF this.GetColumnName() = 'qcemp' THEN

	sCode = this.gettext()
  SELECT "REFFPF"."RFNA1"  
    INTO :sName  
    FROM "REFFPF"  
   WHERE ( "REFFPF"."RFCOD" = '45' ) AND  
         ( "REFFPF"."RFGUB" = :sCode ) AND  
         ( "REFFPF"."RFGUB" <> '00' ) ;
	 
	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[검사담당자]')
		this.setitem(lrow, "qcemp", sNull)
		return 1
	end if
	 
END IF


string sDate
// 일자
IF this.GetColumnName() = 'danmst_handochdat' THEN
	sDate  = this.gettext()
	IF f_datechk(sDate) = -1	then
		this.setitem(lRow, "danmst_handochdat", sNull)
		return 1
	END IF
END IF


IF this.GetColumnName() = 'danmst_handojidat' THEN
	sDate  = this.gettext()
	IF f_datechk(sDate) = -1	then
		this.setitem(lRow, "danmst_handojidat", sNull)
		return 1
	END IF
END IF

end event

event itemerror;return 1
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


end event

event buttonclicked;If row < 1 Then Return

SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Choose Case dwo.name
	Case 'b_1'
		gs_gubun		= '3'
		gs_code     = Trim(Object.cvcod[row])
		gs_codename = Trim(Object.itnbr[row])
		
		Open(w_qa00_00010_popup2)
End Choose
end event

event clicked;If row > 0 Then
	If isSelected(row) Then
		SelectRow(row, False)
	Else
		SelectRow(0, False)
		SelectRow(row, True)
	End If
End If
end event

type dw_3 from datawindow within tabpage_3
event ue_keyenter pbm_dwnprocessenter
integer x = 5
integer y = 8
integer width = 1751
integer height = 136
integer taborder = 10
string dataobject = "d_qa00_00010_3"
boolean border = false
boolean livescroll = true
end type

event ue_keyenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;String sCod,sNam,sNam1

scod = this.gettext()
IF	this.Getcolumnname() = "cvcod"	THEN		
	f_get_name2("V1", 'Y', scod, snam, snam1)

	this.SetItem(1, "cvcod", scod)
	this.setitem(1, "cvnas", snam)
end if
end event

event itemerror;Return 1
end event

event rbuttondown;
string	sItem,sNull

setnull(snull)
setnull(gs_code)
setnull(gs_codename)

IF	this.Getcolumnname() = "cvcod"	THEN		
	gs_code = this.GetText()
	IF IsNull(gs_code) THEN 
		this.SetItem(1, "cvcod", snull)
		this.setitem(1, "cvnas", snull)		
	end if
		
	gs_gubun = '1'
	Open(w_vndmst_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then  return

	this.SetItem(1, "cvcod", gs_Code)
	this.setitem(1, "cvnas", gs_CodeName)
END IF

if this.GetColumnName() = 'itcls' then
	sItem = this.GetItemString(1, 'ittyp')
	
	OpenWithParm(w_ittyp_popup, sItem)
	
	lstr_itnct = Message.PowerObjectParm	
	
	if isnull(lstr_itnct.s_ittyp) or lstr_itnct.s_ittyp = "" then return 
	
	this.SetItem(1,"ittyp",	lstr_itnct.s_ittyp)
	this.SetItem(1,"itcls", lstr_itnct.s_sumgub)
end if
end event

type rr_3 from roundrectangle within tabpage_3
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 148
integer width = 4466
integer height = 1932
integer cornerheight = 40
integer cornerwidth = 55
end type

type tabpage_4 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 96
integer width = 4494
integer height = 2092
long backcolor = 32106727
string text = "사내검사"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_list4 dw_list4
dw_4 dw_4
cb_2 cb_2
rr_4 rr_4
end type

on tabpage_4.create
this.dw_list4=create dw_list4
this.dw_4=create dw_4
this.cb_2=create cb_2
this.rr_4=create rr_4
this.Control[]={this.dw_list4,&
this.dw_4,&
this.cb_2,&
this.rr_4}
end on

on tabpage_4.destroy
destroy(this.dw_list4)
destroy(this.dw_4)
destroy(this.cb_2)
destroy(this.rr_4)
end on

type dw_list4 from datawindow within tabpage_4
event ue_pressenter pbm_dwnprocessenter
integer x = 23
integer y = 160
integer width = 4434
integer height = 1908
integer taborder = 40
string dataobject = "d_qa00_00010_d1_new"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event buttonclicked;If row < 1 Then Return

SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Choose Case dwo.name
	Case 'b_1'
		gs_gubun		= '4'
		gs_code     = Trim(Object.cvcod[row])
		gs_codename = Trim(Object.itnbr[row])
		
		Open(w_qa00_00010_popup2)
End Choose
end event

event clicked;If row > 0 Then
	If isSelected(row) Then
		SelectRow(row, False)
	Else
		SelectRow(0, False)
		SelectRow(row, True)
	End If
End If
end event

event itemchanged;
string	sCode, sName, sNull
long		lRow
lRow = this.GetRow()
SetNull(sNull)

// 검사담당자
IF this.GetColumnName() = 'qcemp' THEN

	sCode = this.gettext()
  SELECT "REFFPF"."RFNA1"  
    INTO :sName  
    FROM "REFFPF"  
   WHERE ( "REFFPF"."RFCOD" = '45' ) AND  
         ( "REFFPF"."RFGUB" = :sCode ) AND  
         ( "REFFPF"."RFGUB" <> '00' ) ;
	 
	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[검사담당자]')
		this.setitem(lrow, "qcemp", sNull)
		return 1
	end if
	 
// 검사방법
ELSEIF this.GetColumnName() = 'qcgub' THEN

	sCode = this.gettext()
	if sCode = '1' then	// 무검사
		this.setitem(lRow,'qcemp',sNull)
	end if
	

END IF


string sDate
// 일자
IF this.GetColumnName() = 'danmst_handochdat' THEN
	sDate  = this.gettext()
	IF f_datechk(sDate) = -1	then
		this.setitem(lRow, "danmst_handochdat", sNull)
		return 1
	END IF
END IF


IF this.GetColumnName() = 'danmst_handojidat' THEN
	sDate  = this.gettext()
	IF f_datechk(sDate) = -1	then
		this.setitem(lRow, "danmst_handojidat", sNull)
		return 1
	END IF
END IF

end event

event itemerror;return 1
end event

event updatestart;///* Update() function 호출시 user 설정 */
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

type dw_4 from datawindow within tabpage_4
event ue_keyenter pbm_dwnprocessenter
integer x = 5
integer y = 4
integer width = 3410
integer height = 136
integer taborder = 10
string dataobject = "d_qa00_00010_2_new"
boolean border = false
boolean livescroll = true
end type

event ue_keyenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;String sCod,sNam,sNam1,snull

scod = this.gettext()
setnull(snull)
IF	this.Getcolumnname() = "cvcod"	THEN		
	f_get_name2("V1", 'Y', scod, snam, snam1)

	this.SetItem(1, "cvcod", scod)
	this.setitem(1, "cvnas", snam)

elseif this.getcolumnname() = 'cvnas' then
	sNam = this.gettext()
	
	if isnull(sNam) or sNam = '' then return
	
	select cvcod, cvnas2 into :sCod, :sNam1 from vndmst
	 where cvnas2 like '%'||:sNam||'%' and rownum = 1 ;
	if sqlca.sqlcode = 0 then
		this.setitem(1,'cvcod',sCod)
		this.setitem(1,'cvnas',sNam1)
	else
		this.setitem(1,'cvcod',snull)
		this.setitem(1,'cvnas',snull)
	end if
	
	return 2
	
end if
end event

event itemerror;Return 1
end event

event rbuttondown;
string	sItem,sNull

setnull(snull)
setnull(gs_code)
setnull(gs_codename)

IF	this.Getcolumnname() = "cvcod"	THEN		
	gs_code = this.GetText()
	IF IsNull(gs_code) THEN 
		this.SetItem(1, "cvcod", snull)
		this.setitem(1, "cvnas", snull)		
	end if
		
	gs_gubun = '1'
	Open(w_vndmst_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then  return

	this.SetItem(1, "cvcod", gs_Code)
	this.setitem(1, "cvnas", gs_CodeName)
END IF

if this.GetColumnName() = 'itcls' then
	sItem = this.GetItemString(1, 'ittyp')
	
	OpenWithParm(w_ittyp_popup, sItem)
	
	lstr_itnct = Message.PowerObjectParm	
	
	if isnull(lstr_itnct.s_ittyp) or lstr_itnct.s_ittyp = "" then return 
	
	this.SetItem(1,"ittyp",	lstr_itnct.s_ittyp)
	this.SetItem(1,"itcls", lstr_itnct.s_sumgub)
end if
end event

type cb_2 from commandbutton within tabpage_4
integer x = 3419
integer y = 20
integer width = 672
integer height = 104
integer taborder = 50
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "Excel File Download"
end type

event clicked;If this.Enabled Then wf_excel_down(tab_1.tabpage_2.dw_list2)
end event

type rr_4 from roundrectangle within tabpage_4
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 148
integer width = 4466
integer height = 1932
integer cornerheight = 40
integer cornerwidth = 55
end type

