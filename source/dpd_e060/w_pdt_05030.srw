$PBExportHeader$w_pdt_05030.srw
$PBExportComments$외주처 공정 출고 등록
forward
global type w_pdt_05030 from window
end type
type pb_1 from u_pb_cal within w_pdt_05030
end type
type p_print from uo_picture within w_pdt_05030
end type
type p_exit from uo_picture within w_pdt_05030
end type
type p_cancel from uo_picture within w_pdt_05030
end type
type p_delete from uo_picture within w_pdt_05030
end type
type p_save from uo_picture within w_pdt_05030
end type
type p_retrieve from uo_picture within w_pdt_05030
end type
type cbx_1 from checkbox within w_pdt_05030
end type
type dw_print from datawindow within w_pdt_05030
end type
type dw_imhist from datawindow within w_pdt_05030
end type
type rb_delete from radiobutton within w_pdt_05030
end type
type rb_insert from radiobutton within w_pdt_05030
end type
type gb_2 from groupbox within w_pdt_05030
end type
type rr_1 from roundrectangle within w_pdt_05030
end type
type ln_1 from line within w_pdt_05030
end type
type dw_detail from datawindow within w_pdt_05030
end type
type dw_list from datawindow within w_pdt_05030
end type
end forward

global type w_pdt_05030 from window
integer width = 4658
integer height = 2440
boolean titlebar = true
string title = "외주처 공정 출고 등록"
string menuname = "m_shortcut"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
windowstate windowstate = maximized!
long backcolor = 32106727
pb_1 pb_1
p_print p_print
p_exit p_exit
p_cancel p_cancel
p_delete p_delete
p_save p_save
p_retrieve p_retrieve
cbx_1 cbx_1
dw_print dw_print
dw_imhist dw_imhist
rb_delete rb_delete
rb_insert rb_insert
gb_2 gb_2
rr_1 rr_1
ln_1 ln_1
dw_detail dw_detail
dw_list dw_list
end type
global w_pdt_05030 w_pdt_05030

type variables
String  is_ispec, is_jijil
char    ic_status

String     is_today              //시작일자
String     is_totime             //시작시간
String     is_window_id      //윈도우 ID
String     is_usegub           //이력관리 여부


end variables

forward prototypes
public function integer wf_checkrequiredfield ()
public function integer wf_imhist_update ()
public function integer wf_imhist_create ()
public function integer wf_imhist_delete ()
public function integer wf_initial ()
end prototypes

public function integer wf_checkrequiredfield ();//////////////////////////////////////////////////////////////////
//		* 등록모드
//		1. opt check('Y') 인 자료만 처리
//////////////////////////////////////////////////////////////////
dec{3}	dQty
long		lRow,	lCount
String   sOpt

FOR	lRow = 1		TO		dw_list.RowCount()

	dQty  = dw_list.GetItemDecimal(lRow, "ioqty")			// 출고요청수량
   IF isnull(dqty) then dqty = 0

	IF ic_status = '1' THEN
		IF dw_list.getitemstring(lrow, 'opt') = 'Y'		THEN
			IF dQty <= 0  THEN 
				f_message_chk(1400, '[출고수량]')
				RETURN -1
			ELSE
				lCount++
			END IF
		END IF
	Else
		if dQty <= 0 then
			f_message_chk(1400, '[출고수량]')
			return -1
		else
			lCount++
		end if
	END IF

NEXT

IF lCount < 1	THEN
	messagebox('확 인', '처리할 자료를 선택하세요!')
	RETURN -1
end if
RETURN 1

end function

public function integer wf_imhist_update ();//////////////////////////////////////////////////////////////////
//
//		* 수정모드
//		1. 입출고history -> 출고수량 update (출고수량을 변경할 경우에만)
//		2. 기출고수량 + 출고수량 = 요청수량 -> 촐고완료('Y')
//	
//////////////////////////////////////////////////////////////////
//string	sHist_Jpno, sGubun, siodate, sioyn
//dec		dOutQty, dTemp_OutQty
//long		lRow
//
//FOR	lRow = 1		TO		dw_list.RowCount()
//
//	dOutQty      = dw_list.GetItemDecimal(lRow, "outqty")			// 출고수량(입출고history)
//	dTemp_OutQty = dw_list.GetItemDecimal(lRow, "temp_outqty")	// 출고수량(입출고history)
//	sHist_Jpno   = dw_list.GetItemString(lRow, "imhist_iojpno")
//	sGubun		 = dw_list.GetItemString(lRow, "hosts")
//
//   sIoYN        = dw_list.GetItemString(lrow, "io_confirm")
//   sIodate      = dw_list.GetItemString(lrow, "cndate")
//	 
//	/* 상대전표가 승인된 경우(승인일자가 있고 수불승인 여부가 'N') 제외 */
//	if (not isnull(siodate)) AND sioyn = 'N' then continue
//	
//	IF dOutQty <> dTemp_OutQty		THEN
//
//		  UPDATE "IMHIST"  
//			  SET "IOQTY"   = :dOutQty,   
//					"IOREQTY" = :dOutQty,   
//					"IOSUQTY" = :dOutQty,   
//					"OUTCHK" = :sGubun,  
//					"UPD_USER" = :gs_userid  
//			WHERE ( "IMHIST"."SABU" = :gs_sabu ) AND  
//					( "IMHIST"."IOJPNO" = :sHist_Jpno )   ;
//
//		IF SQLCA.SQLNROWS <> 1	THEN
//			ROLLBACK;
//			f_Rollback();
//			RETURN -1
//		END IF
//	
//	END IF
//NEXT
//
//COMMIT;
//
RETURN 1
end function

public function integer wf_imhist_create ();///////////////////////////////////////////////////////////////////////
//	* 등록모드
//	1. 출고HISTORY 생성
//	2. 전표채번구분 = 'C0'
// 3. 전표생성구분 = '028'
///////////////////////////////////////////////////////////////////////
string	sJpno, sProject, sdptno, sOpt, sDate, sQcgub, sEmpno, snull, sopseq
long		lRow, lCOUNT, dSeq, i, k, lrowhist
dec{3}	dOutQty

sDate = trim(dw_detail.GetItemString(1, "edate"))				// 출고일자
dSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'C0')

IF dSeq < 0		THEN	
	rollback;
	RETURN -1
end if

COMMIT;

////////////////////////////////////////////////////////////////////////
sJpno    = sDate + string(dSeq, "0000")
sEmpno   = dw_detail.GetItemString(1, "empno")
sdptno   = dw_detail.GetItemString(1, "dept")

//무검사 데이타 가져오기
SELECT "SYSCNFG"."DATANAME"  
  INTO :sQcgub  
  FROM "SYSCNFG"  
 WHERE ( "SYSCNFG"."SYSGU" = 'Y' ) AND  
		 ( "SYSCNFG"."SERIAL" = 13 ) AND  
		 ( "SYSCNFG"."LINENO" = '2' )   ;
if sqlca.sqlcode <> 0 then
	sQcgub = '1'
end if

i = 0 //출고전표 채번용
k = 0 //채번 순번

lcount = dw_list.RowCount()

FOR	lRow = 1		TO		lCount 

	sopt = dw_list.GetItemString(lRow, "opt")

	IF sopt = 'Y'		THEN

		lRowHist = dw_imhist.InsertRow(0)
      i++ 		

		dw_imhist.SetItem(lRowHist, "sabu",		gs_sabu)
		dw_imhist.SetItem(lRowHist, "iojpno", 	sJpno + string(i, "000") )
		dw_imhist.SetItem(lRowHist, "iogbn",   'O90') // 수불구분=요청구분
		dw_imhist.SetItem(lRowHist, "jnpcrt",	'028')			// 전표생성구분
		dw_imhist.SetItem(lRowHist, "inpcnf",  'O')				// 입출고구분

		dw_imhist.SetItem(lRowHist, "sudat",	sdate)			// 수불일자=출고일자
		dw_imhist.SetItem(lRowHist, "insdat",	sDate)			// 검사일자=출고일자	
		dw_imhist.SetItem(lRowHist, "io_date",  sDate)	
		
		dOutQty = dw_list.GetItemDecimal(lRow, "ioqty")
		
		dw_imhist.SetItem(lRowHist, "ioqty", dOutQty)
		dw_imhist.SetItem(lRowHist, "iosuqty",	dOutQty) 	// 합격수량=출고수량		
		dw_imhist.SetItem(lRowHist, "ioreqty",	dOutQty) 	// 수불의뢰수량=출고수량		
		
		dw_imhist.SetItem(lRowHist, "io_empno", sempno)	
		dw_imhist.SetItem(lRowHist, "ioreemp", sempno)	
		dw_imhist.SetItem(lRowHist, "ioredept", sdptno)	
		dw_imhist.SetItem(lRowHist, "io_confirm",	'Y')			// 수불승인여부
	
		dw_imhist.SetItem(lRowHist, "itnbr",	dw_list.GetItemString(lRow, "itnbr")) // 품번
		dw_imhist.SetItem(lRowHist, "pspec",	dw_list.GetItemString(lRow, "pspec")) // 사양
		dw_imhist.SetItem(lRowHist, "cvcod",	dw_list.GetItemString(lRow, "wicvcod")) 	// 거래처창고=입고처
		dw_imhist.SetItem(lRowHist, "pdtgu",   dw_list.GetItemString(lRow, "pdtgu")) // 생산팀
		
		sOpseq	= dw_list.GetItemString(lRow, "opseq")
		dw_imhist.SetItem(lRowHist, "opseq", sOpseq) 	// 공정순서
		
		dw_imhist.SetItem(lRowHist, "filsk",   'Y') // 재고관리유무
		dw_imhist.SetItem(lRowHist, "botimh",	'N')				// 동시출고여부
		dw_imhist.SetItem(lRowHist, "jakjino", dw_list.GetItemString(lRow, "pordno"))

		dw_imhist.SetItem(lRowHist, "qcgub",	sQcgub)	

	END IF

NEXT

if dw_imhist.update() <> 1 then
	rollback;
	f_rollback()		
	return -1
end if

commit;

MessageBox("전표번호 확인", "전표번호 : " +sDate+ '-' + string(dSeq,"0000")+		&
									 "~r~r생성되었습니다.")

IF cbx_1.checked Then
	sJpno = sJpno + '%'

   dw_print.Retrieve(gs_sabu, sJpno)
	dw_print.print()
END IF

RETURN 1

end function

public function integer wf_imhist_delete ();///////////////////////////////////////////////////////////////////////
//	1. 입출고HISTORY 삭제
///////////////////////////////////////////////////////////////////////
string	sHist_Jpno
long		lRow, lRowCount, K

if dw_list.accepttext() = -1 then return -1

lRowCount = dw_list.RowCount()

FOR lrow = lRowCount to 1 step -1 
	
	// 삭제표시된 내역만 삭제함
   if dw_list.getitemstring(Lrow, "opt") = 'N' then continue
	k ++ 
	
	dw_list.deleterow(lrow)
			  
Next
////////////////////////////////////////////////////////////////////////

if k < 1 then 
	messagebox('확 인', '삭제할 자료를 선택하세요!')
	return -1
END IF

IF dw_list.Update() = 1 THEN
	COMMIT;
	w_mdi_frame.sle_msg.text ="자료가 삭제되었습니다.!!!"
ELSE
	ROLLBACK;
	f_message_chk(31,'')
	RETURN -1
END IF

RETURN 1

end function

public function integer wf_initial ();dw_detail.setredraw(false)
dw_detail.reset()
dw_list.reset()
dw_imhist.reset()

p_delete.enabled = false
p_delete.PictureName = 'c:\erpman\image\삭제_d.gif'
dw_detail.enabled = TRUE

dw_detail.insertrow(0)

////////////////////////////////////////////////////////////////////////

IF ic_status = '1'	then

	dw_detail.setcolumn("edate")
	dw_detail.SetItem(1, "edate", is_today)
	// 등록시
	dw_detail.settaborder("jpno",  0)
	dw_detail.settaborder("edate", 10)
	dw_detail.settaborder("project", 20)
	dw_detail.settaborder("empno", 30)

	w_mdi_frame.sle_msg.text = "등록"
	p_save.enabled = TRUE
	p_save.PictureName = 'c:\erpman\image\저장_up.gif'
ELSE
	dw_detail.setcolumn("jpno")

	dw_detail.settaborder("jpno",  10)
	dw_detail.settaborder("edate", 0)
	dw_detail.settaborder("project", 0)
	dw_detail.settaborder("empno", 0)

	w_mdi_frame.sle_msg.text = "삭제"
	p_save.enabled = false
	p_save.PictureName = 'c:\erpman\image\저장_d.gif'
END IF

dw_detail.setfocus()

dw_detail.setredraw(true)

return  1


end function

event open;Integer  li_idx

li_idx = w_mdi_frame.dw_listbar.InsertRow(0)
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_id',Upper(This.ClassName()))
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_name',Upper(This.Title))
w_mdi_frame.Postevent("ue_barrefresh")

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


dw_list.settransobject(sqlca)
dw_imhist.settransobject(sqlca)
dw_print.settransobject(sqlca)

//규격,재질 
If f_change_name('1') = 'Y' Then
	is_ispec = f_change_name('2')
	is_jijil = f_change_name('3')
else
	is_ispec = '규격'
	is_jijil = '재질'
End If

rb_insert.TriggerEvent("clicked")
end event

on w_pdt_05030.create
if this.MenuName = "m_shortcut" then this.MenuID = create m_shortcut
this.pb_1=create pb_1
this.p_print=create p_print
this.p_exit=create p_exit
this.p_cancel=create p_cancel
this.p_delete=create p_delete
this.p_save=create p_save
this.p_retrieve=create p_retrieve
this.cbx_1=create cbx_1
this.dw_print=create dw_print
this.dw_imhist=create dw_imhist
this.rb_delete=create rb_delete
this.rb_insert=create rb_insert
this.gb_2=create gb_2
this.rr_1=create rr_1
this.ln_1=create ln_1
this.dw_detail=create dw_detail
this.dw_list=create dw_list
this.Control[]={this.pb_1,&
this.p_print,&
this.p_exit,&
this.p_cancel,&
this.p_delete,&
this.p_save,&
this.p_retrieve,&
this.cbx_1,&
this.dw_print,&
this.dw_imhist,&
this.rb_delete,&
this.rb_insert,&
this.gb_2,&
this.rr_1,&
this.ln_1,&
this.dw_detail,&
this.dw_list}
end on

on w_pdt_05030.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.p_print)
destroy(this.p_exit)
destroy(this.p_cancel)
destroy(this.p_delete)
destroy(this.p_save)
destroy(this.p_retrieve)
destroy(this.cbx_1)
destroy(this.dw_print)
destroy(this.dw_imhist)
destroy(this.rb_delete)
destroy(this.rb_insert)
destroy(this.gb_2)
destroy(this.rr_1)
destroy(this.ln_1)
destroy(this.dw_detail)
destroy(this.dw_list)
end on

event closequery;

string s_frday, s_frtime

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
	Case KeyW!
		p_print.TriggerEvent(Clicked!)
	Case KeyQ!
		p_retrieve.TriggerEvent(Clicked!)
	Case KeyS!
		p_save.TriggerEvent(Clicked!)
	Case KeyD!
		p_delete.TriggerEvent(Clicked!)
	Case KeyC!
		p_canCEL.TriggerEvent(Clicked!)
	Case KeyX!
		p_exit.TriggerEvent(Clicked!)
End Choose
end event

type pb_1 from u_pb_cal within w_pdt_05030
integer x = 832
integer y = 44
integer taborder = 20
end type

event clicked;call super::clicked;dw_detail.Setcolumn('edate')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_detail.SetItem(1, 'edate', gs_code)
end event

type p_print from uo_picture within w_pdt_05030
integer x = 4119
integer y = 432
integer width = 475
integer height = 100
boolean enabled = false
boolean originalsize = true
string picturename = "c:\erpman\image\출고증출력_d.gif"
end type

event clicked;if dw_detail.Accepttext() = -1	then 	return

string  	sOutJpno

IF rb_delete.checked Then
   sOutJpno = dw_detail.getitemstring(1, "jpno")		// 출고번호

	IF isnull(sOutJpno) or sOutJpno = "" 	THEN
		f_message_chk(30,'[출고번호]')
		dw_detail.SetColumn("jpno")
		dw_detail.SetFocus()
		RETURN
	END IF

	sOutJpno = sOutJpno + '%'

	IF	dw_print.Retrieve(gs_sabu, sOutjpno) <	1		THEN
		f_message_chk(50, '[외주공정출고]')
		dw_detail.setcolumn("jpno")
		dw_detail.setfocus()
		return
	END IF
	
	dw_print.print()
END IF

end event

event ue_lbuttonup;call super::ue_lbuttonup;picturename = 'c:\erpman\image\출고증출력_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;picturename = 'c:\erpman\image\출고증출력_dn.gif'
end event

type p_exit from uo_picture within w_pdt_05030
integer x = 4407
integer y = 24
integer width = 178
string picturename = "c:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;CLOSE(PARENT)
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'c:\erpman\image\닫기_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'c:\erpman\image\닫기_dn.gif'
end event

type p_cancel from uo_picture within w_pdt_05030
integer x = 4233
integer y = 24
integer width = 178
string picturename = "c:\erpman\image\취소_up.gif"
end type

event clicked;
rb_insert.checked = true

rb_insert.TriggerEvent("clicked")


end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'c:\erpman\image\취소_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'c:\erpman\image\취소_dn.gif'
end event

type p_delete from uo_picture within w_pdt_05030
integer x = 4059
integer y = 24
integer width = 178
boolean enabled = false
string picturename = "c:\erpman\image\삭제_d.gif"
end type

event clicked;//////////////////////////////////////////////////////////////////
///	* 입고내역 삭제
//////////////////////////////////////////////////////////////////

IF f_msg_delete() = -1 THEN	RETURN
	
IF wf_Imhist_Delete() = -1		THEN	
	rollback;
	RETURN
end if

COMMIT;

p_cancel.TriggerEvent("clicked")
	
	

end event

event ue_lbuttonup;call super::ue_lbuttonup;picturename = 'c:\erpman\image\삭제_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;picturename = 'c:\erpman\image\삭제_dn.gif'
end event

type p_save from uo_picture within w_pdt_05030
integer x = 3886
integer y = 24
integer width = 178
string picturename = "c:\erpman\image\저장_up.gif"
end type

event clicked;SetPointer(HourGlass!)

IF dw_list.RowCount() < 1			THEN 	RETURN 
IF dw_detail.AcceptText() = -1	THEN	RETURN
IF dw_list.AcceptText() = -1		THEN	RETURN

string	sDate, sarg_sdate
long	dSeq

sdate  = trim(dw_detail.GetItemstring(1, "Edate"))			

IF	wf_CheckRequiredField() = -1		THEN	RETURN 

IF f_msg_update() = -1 	THEN	RETURN

/////////////////////////////////////////////////////////////////////////
//	1. 등록시 전표번호 생성
/////////////////////////////////////////////////////////////////////////

IF ic_status = '1'	THEN

	if wf_imhist_create() = -1 then return
	
//ELSE
//
//	IF wf_imhist_update() = -1	THEN	RETURN

END IF

////////////////////////////////////////////////////////////////////////

p_cancel.TriggerEvent("clicked")	

SetPointer(Arrow!)


end event

event ue_lbuttondown;call super::ue_lbuttondown;picturename = 'c:\erpman\image\저장_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;picturename = 'c:\erpman\image\저장_up.gif'
end event

type p_retrieve from uo_picture within w_pdt_05030
integer x = 3712
integer y = 24
integer width = 178
boolean originalsize = true
string picturename = "c:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;if dw_detail.Accepttext() = -1	then 	return

string  	sProject,	&
			sOutJpno,	&
			sDate,		&
			sEmpno,	&
			sNull
SetNull(sNull)

SetPointer(HourGlass!)

IF rb_insert.checked Then
	sDate	   = trim(dw_detail.getitemstring(1, "edate"))	 // 출고일자
	sEmpno  	= trim(dw_detail.getitemstring(1, "empno"))	 // 담당자
	sProject = trim(dw_detail.getitemstring(1, "project")) // 작업지시번호

	IF isnull(sDate) or sDate = "" 	THEN
		f_message_chk(30,'[출고일자]')
		dw_detail.SetColumn("edate")
		dw_detail.SetFocus()
		RETURN
	END IF

	IF isnull(sProject) or sProject = "" 	THEN
		f_message_chk(30,'[작업지시번호]')
		dw_detail.SetColumn("project")
		dw_detail.SetFocus()
		RETURN
	END IF

	IF isnull(sEmpno) or sEmpno = "" 	THEN
		f_message_chk(30,'[담당자]')
		dw_detail.SetColumn("empno")
		dw_detail.SetFocus()
		RETURN
	END IF

	IF	dw_list.Retrieve(gs_sabu, sProject) <	1		THEN
		f_message_chk(50, '[외주공정]')
		dw_detail.setcolumn("Project")
		dw_detail.setfocus()
		return
	END IF

ELSE
   sOutJpno = dw_detail.getitemstring(1, "jpno")		// 출고번호

	IF isnull(sOutJpno) or sOutJpno = "" 	THEN
		f_message_chk(30,'[출고번호]')
		dw_detail.SetColumn("jpno")
		dw_detail.SetFocus()
		RETURN
	END IF

	sOutJpno = sOutJpno + '%'

	IF	dw_list.Retrieve(gs_sabu, sOutjpno) <	1		THEN
		f_message_chk(50, '[외주공정출고]')
		dw_detail.setcolumn("jpno")
		dw_detail.setfocus()
		return
	END IF

	// 삭제모드에서만 삭제가능
	p_delete.enabled = true	
	p_delete.PictureName = 'c:\erpman\image\삭제_up.gif'
	
END IF
//////////////////////////////////////////////////////////////////////////
dw_detail.enabled = false

dw_list.SetFocus()

end event

event ue_lbuttonup;call super::ue_lbuttonup;picturename = 'c:\erpman\image\조회_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;picturename = 'c:\erpman\image\조회_dn.gif'
end event

type cbx_1 from checkbox within w_pdt_05030
integer x = 2542
integer y = 52
integer width = 549
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "출고증 자동출력"
boolean checked = true
end type

type dw_print from datawindow within w_pdt_05030
boolean visible = false
integer x = 1403
integer y = 2352
integer width = 494
integer height = 360
boolean titlebar = true
string dataobject = "d_pdt_05030_3"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_imhist from datawindow within w_pdt_05030
boolean visible = false
integer x = 96
integer y = 2324
integer width = 494
integer height = 212
boolean titlebar = true
string title = "입출고HISTORY"
string dataobject = "d_pdt_imhist"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
end type

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

type rb_delete from radiobutton within w_pdt_05030
integer x = 3246
integer y = 136
integer width = 224
integer height = 72
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "수정"
end type

event clicked;ic_status = '2'

dw_list.DataObject = 'd_pdt_05030_1'
dw_list.SetTransObject(sqlca)

wf_Initial()

//규격,재질 
If f_change_name('1') = 'Y' Then
	dw_list.Object.ispec_t.text =  is_ispec
	dw_list.Object.jijil_t.text =  is_jijil
End If

cbx_1.visible = false
p_print.enabled  = true
p_print.PictureName = 'c:\erpman\image\출고증출력_up.gif'


end event

type rb_insert from radiobutton within w_pdt_05030
integer x = 3246
integer y = 60
integer width = 224
integer height = 72
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "등록"
boolean checked = true
end type

event clicked;ic_status = '1'	// 등록

dw_list.DataObject = 'd_pdt_05030'
dw_list.SetTransObject(sqlca)

wf_Initial()

//규격,재질 
If f_change_name('1') = 'Y' Then
	dw_list.Object.ispec_t.text =  is_ispec
	dw_list.Object.jijil_t.text =  is_jijil
End If

cbx_1.visible = true 
p_print.enabled  = false
p_print.PictureName = 'c:\erpman\image\출고증출력_d.gif'
end event

type gb_2 from groupbox within w_pdt_05030
integer x = 3168
integer width = 375
integer height = 236
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 32106727
borderstyle borderstyle = styleraised!
end type

type rr_1 from roundrectangle within w_pdt_05030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 556
integer width = 4558
integer height = 1668
integer cornerheight = 40
integer cornerwidth = 55
end type

type ln_1 from line within w_pdt_05030
long linecolor = 28144969
integer linethickness = 1
integer beginx = 402
integer beginy = 904
integer endx = 567
integer endy = 1048
end type

type dw_detail from datawindow within w_pdt_05030
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 46
integer y = 28
integer width = 3077
integer height = 220
integer taborder = 10
string dataobject = "d_pdt_05030_a"
boolean border = false
boolean livescroll = true
end type

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;
IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;string	sDate, sConfirm,		&
			sDept, sDeptName, 	&
			sEmpno,sEmpname,		&
			sHist_jpno,	&
			sProject,				&
			sNull, scode, sname, sname2
int      ireturn 			

SetNull(sNull)

/////////////////////////////////////////////////////////////////////////////
IF this.GetColumnName() = 'edate' THEN

	sDate = trim(this.gettext())
	
	if isnull(sDate) or sDate = '' then return 
	
	IF f_datechk(sDate) = -1	then
		f_message_chk(35,'[출고일자]')
		this.setitem(1, "edate", sNull)
		return 1
	END IF
	
ELSEIF this.getcolumnname() = "project"	then

	sProject = trim(this.gettext()) 
	
	if sProject = '' or isnull(sProject) then return 

   SELECT "MOMAST"."PDSTS"
     INTO :sConfirm  
     FROM "MOMAST"  
    WHERE ( "MOMAST"."SABU" 	= :gs_sabu ) AND  
          ( "MOMAST"."PORDNO"  = :sProject ) ;   
//          ( "MOMAST"."PDSTS" in ('1','2') )   ;

   If sqlca.sqlcode <> 0 then
		Messagebox("확인","작업지시 내역이 없읍니다.")
		this.setitem(1, "project", sNull)
		return 1		
	END IF
	
ELSEIF this.GetColumnName() = 'empno' THEN
	scode = this.GetText()								
   if scode = '' 	or isnull(scode) then 
		this.setitem(1, 'name', sNull)
		this.setitem(1, 'dept', sNull)
		this.setitem(1, 'deptname', sNull)
      return 
   end if
   ireturn = f_get_name2('사번', 'Y', scode, sname, sname2) //1이면 실패, 0이 성공	
	this.setitem(1, 'empno', scode)
	this.setitem(1, 'name', sname)
	IF ireturn <> 1 then 
		SELECT "P0_DEPT"."DEPTCODE", "P0_DEPT"."DEPTNAME"  
		  INTO :sdept, :sdeptname  
		  FROM "P1_MASTER", "P0_DEPT"  
		 WHERE ( "P1_MASTER"."COMPANYCODE" = "P0_DEPT"."COMPANYCODE" ) and  
				 ( "P1_MASTER"."DEPTCODE" = "P0_DEPT"."DEPTCODE" ) and  
				 ( ( "P1_MASTER"."EMPNO" = :scode ) )   ;
   
		this.setitem(1, 'dept', sdept)
		this.setitem(1, 'deptname', sdeptname)
	ELSE
		this.setitem(1, 'dept', sNull)
		this.setitem(1, 'deptname', sNull)
	END IF	
   return ireturn 
ELSEIF this.getcolumnname() = "jpno"	then
	sHist_Jpno = trim(this.GetText())	

	if sHist_Jpno = '' or isnull(sHist_Jpno) then 
		this.SetItem(1, "edate",  snull)
		this.SetItem(1, "empno", snull)
		this.SetItem(1, "name", snull)
		this.setitem(1, 'dept', sNull)
		this.setitem(1, 'deptname', sNull)
		this.setitem(1, 'project', sNull)
		return 
   end if		

   SELECT A.INSDAT, A.IOREEMP, B.EMPNAME, A.IOREDEPT, FUN_GET_CVNAS(A.IOREDEPT), JAKJINO
 	  INTO :sDate,   :sEmpno,   :sEmpname, :sDept,     :sDeptName,             :sProject
	  FROM IMHIST A, P1_MASTER B
	 WHERE A.SABU	 = :gs_sabu	
	   AND A.IOJPNO LIKE :sHist_Jpno||'%' 	
	   AND A.JNPCRT LIKE '028' 
		AND A.IOREEMP = B.EMPNO(+)
		AND ROWNUM = 1	;
	
	if sqlca.sqlcode <> 0 	then
		f_message_chk(33,'[출고번호]')

		this.SetItem(1, "jpno",  snull)
		this.SetItem(1, "edate",  snull)
		this.SetItem(1, "empno", snull)
		this.SetItem(1, "name", snull)
		this.setitem(1, 'dept', sNull)
		this.setitem(1, 'deptname', sNull)
		this.setitem(1, 'project', sNull)
		return 1
	end if

	this.SetItem(1, "edate",  sDate)
	this.SetItem(1, "empno",  sEmpno)
	this.SetItem(1, "name",   sEmpname)
	this.SetItem(1, "dept",   sDept)
	this.SetItem(1, "deptname",sDeptName)
	this.setitem(1, 'project', sProject)
END IF

end event

event itemerror;RETURN 1
end event

event losefocus;this.accepttext()
end event

event rbuttondown;gs_code = ''
gs_codename = ''
gs_gubun = ''

// 출고승인담당자
IF this.GetColumnName() = 'empno'	THEN
   
	Open(w_sawon_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"empno",gs_code)
   this.triggerEvent(itemchanged!)	
elseif this.getcolumnname() = "jpno" 	then
	gs_gubun = '028'
	open(w_chulgo_popup3)
	if isnull(gs_code)  or  gs_code = ''	then	return
	this.setitem(1, "jpno", Left(gs_code,12))
	this.triggerevent("itemchanged")
	RETURN 1
// 작업지시번호
elseif this.getcolumnname() = "project" 	then

	open(w_jisi_popup)
	if isnull(gs_code)  or  gs_code = ''	then	return
	this.setitem(1, "project", gs_code)
	this.triggerevent("itemchanged")
	RETURN 1
end if

end event

type dw_list from datawindow within w_pdt_05030
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 50
integer y = 236
integer width = 4128
integer height = 1968
integer taborder = 20
string dataobject = "d_pdt_05030"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;string	sNull, sCheck, ls_project
long		lRow, ll_estima
dec{3}	dOutQty, dioQty, dTempQty, dijun_qty 
SetNull(sNull)

lRow  = this.GetRow()	

///////////////////////////////////////////////////////////////////////////
//  등록에서는 출고수량 > 이전공정수량 + 기출고수량 이면 ERROR
//  수정에서는 출고수량 > 이전공정수량 + 기출고수량 - 자기자신 이면 ERROR
///////////////////////////////////////////////////////////////////////////
IF this.GetColumnName() = "ioqty" THEN

	dioQty = dec(this.GetText())  // 출고요청수량

	if isnull(dioQty) or dioQty = 0 then return 

	dOutQty   = this.GetItemDecimal(lRow, "out_qty")  //기출고수량
	dijun_qty = this.GetItemDecimal(lRow, "ijun_qty")  //전공정실적수량

	ls_project 	= dw_detail.getItemString(1,'project')
	ll_estima		= this.GetItemDecimal(lRow, "VNqty")  //발주 수량
	
//			select sum(estima.vnqty)
//			into :ll_estima
//			from estima
//			where estima.pordno is not null
//			and estima.blynd = '3'
//			and estima.pordno =:ls_project;
			

	IF ic_status = '2'	THEN
		dTempQty 	= this.GetItemDecimal(lRow, "temp_ioqty")
		dOutQty  		= dOutQty - dTempQty
	Else 		// -- 신규 등록.
		If	dioQty >  dijun_qty     	then     //-- (출고요청수량 > 전공정실적수량)
			dijun_qty	=	 ll_estima - dijun_qty         // 전공정실적수량 = 발주수량 - 전공정실적수량
		End If
	END IF

	If dw_list.RowCount() = 1 Then

	Else
		IF   dioQty > dijun_qty - dOutQty THEN
				MessageBox("확인", "출고수량은 이전공정수량 - 기출고수량 보다 클 수 없습니다.")
				this.SetItem(lRow, "ioqty", 0)
				RETURN 1
		END IF
	End If
ELSEIF this.GetColumnName() = "opt" and ic_status = '1'	THEN
   sCheck = this.GetText()	
	
	if scheck = 'Y' then 
		dOutQty   = this.GetItemDecimal(lRow, "out_qty")  //기출고수량
		dijun_qty = this.GetItemDecimal(lRow, "ijun_qty")  //전공정실적수량
		
		this.SetItem(lRow, "ioqty", dijun_qty - doutqty)
	else
		this.SetItem(lRow, "ioqty", 0)
	end if
END IF

end event

event itemerror;RETURN 1
	
	
end event

event losefocus;this.AcceptText()
end event

