$PBExportHeader$w_sys_help_010.srw
$PBExportComments$ERP유지보수신청등록
forward
global type w_sys_help_010 from w_inherite
end type
type dw_area from u_key_enter within w_sys_help_010
end type
type dw_1 from datawindow within w_sys_help_010
end type
type st_2 from statictext within w_sys_help_010
end type
type p_retrieve from picture within w_sys_help_010
end type
type st_3 from statictext within w_sys_help_010
end type
type st_4 from statictext within w_sys_help_010
end type
type rr_1 from roundrectangle within w_sys_help_010
end type
type rr_2 from roundrectangle within w_sys_help_010
end type
type rr_3 from roundrectangle within w_sys_help_010
end type
end forward

global type w_sys_help_010 from w_inherite
boolean visible = false
integer x = 5
integer y = 4
string title = "ERP 유지보수 신청"
string menuname = ""
boolean resizable = true
dw_area dw_area
dw_1 dw_1
st_2 st_2
p_retrieve p_retrieve
st_3 st_3
st_4 st_4
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
end type
global w_sys_help_010 w_sys_help_010

type variables
Long ilMaxItnbr = 0
String isAdmin = 'N'

end variables

forward prototypes
public subroutine wf_changed_flag (datawindow dw_object)
public function integer wf_taborder ()
end prototypes

public subroutine wf_changed_flag (datawindow dw_object);Return
end subroutine

public function integer wf_taborder ();String sFlag, scallno

dw_area.AcceptText()

sFlag = dw_area.GetItemString(1, 'flag')
scallno = dw_area.GetItemString(1, 'call_No')

If sFlag = '1' Then  //의뢰
	dw_area.Modify('call_dt.protect=0')
	dw_area.Modify('call_dept.protect=0')
	dw_area.Modify('call_emp.protect=0')
	dw_area.Modify('call_part.protect=0')
	dw_area.Modify('call_subject.protect=0')
	dw_area.Modify('call_remk.protect=0')
	
	If isAdmin = 'Y' Then
		dw_area.Modify('ans_dt.protect=0')
		dw_area.Modify('ans_emp.protect=0')
		dw_area.Modify('about_dt.protect=0')
		dw_area.Modify('process_dt.protect=0')
		dw_area.Modify('process_remk.protect=0')
		dw_area.Modify('how_to.protect=0')
	Else
		dw_area.Modify('ans_dt.protect=1')
		dw_area.Modify('ans_emp.protect=1')
		dw_area.Modify('about_dt.protect=1')
		dw_area.Modify('process_dt.protect=1')
		dw_area.Modify('process_remk.protect=1')
		dw_area.Modify('how_to.protect=1')
	End If
Else   //접수, 완료
	dw_area.Modify('call_dt.protect=1')
	dw_area.Modify('call_dept.protect=1')
	dw_area.Modify('call_emp.protect=1')
	dw_area.Modify('call_part.protect=1')
	dw_area.Modify('call_subject.protect=1')
	dw_area.Modify('call_remk.protect=1')
	If isAdmin = 'Y' Then
		dw_area.Modify('ans_dt.protect=0')
		dw_area.Modify('ans_emp.protect=0')
		dw_area.Modify('about_dt.protect=0')
		dw_area.Modify('process_dt.protect=0')
		dw_area.Modify('process_remk.protect=0')
		dw_area.Modify('how_to.protect=0')
	Else
		dw_area.Modify('ans_dt.protect=1')
		dw_area.Modify('ans_emp.protect=1')
		dw_area.Modify('about_dt.protect=1')
		dw_area.Modify('process_dt.protect=1')
		dw_area.Modify('process_remk.protect=1')
		dw_area.Modify('how_to.protect=1')
	End If
End IF

Return 1
end function

event open;call super::open;dw_area.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)
dw_1.InsertRow(0)
dw_area.InsertRow(0)

SELECT NVL(DATANAME,'N') INTO :isAdmin
	FROM SYSCNFG
	WHERE SYSGU = 'C' AND SERIAL = 99 AND LINENO <> '00' 
	AND DATANAME = :gs_userid;
	
If SQLCA.SQLCODE <> 0 Then 
	isAdmin = 'N'
Else
	isAdmin = 'Y'
End IF

dw_area.SetITem(dw_area.GetRow(),'call_dt', is_today)
dw_area.SetITem(dw_area.GetRow(),'call_userid', gs_userid)
dw_area.SetITem(dw_area.GetRow(),'call_dept', gs_deptname)
dw_area.SetITem(dw_area.GetRow(),'call_emp', gs_username)

wf_taborder()

ib_any_typing = false
end event

on w_sys_help_010.create
int iCurrent
call super::create
this.dw_area=create dw_area
this.dw_1=create dw_1
this.st_2=create st_2
this.p_retrieve=create p_retrieve
this.st_3=create st_3
this.st_4=create st_4
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_area
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.p_retrieve
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.st_4
this.Control[iCurrent+7]=this.rr_1
this.Control[iCurrent+8]=this.rr_2
this.Control[iCurrent+9]=this.rr_3
end on

on w_sys_help_010.destroy
call super::destroy
destroy(this.dw_area)
destroy(this.dw_1)
destroy(this.st_2)
destroy(this.p_retrieve)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
end on

type dw_insert from w_inherite`dw_insert within w_sys_help_010
boolean visible = false
integer x = 78
integer y = 2292
integer width = 654
integer height = 108
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_sys_help_010
boolean visible = false
integer x = 727
integer y = 2308
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_sys_help_010
boolean visible = false
integer x = 539
integer y = 2308
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_sys_help_010
boolean visible = false
integer x = 5
integer y = 2308
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_sys_help_010
boolean visible = false
integer x = 3008
integer taborder = 10
end type

event p_ins::clicked;call super::clicked;Int    il_currow
String sCode

il_CurRow = dw_area.InsertRow(0)
	
dw_area.ScrollToRow(il_currow)
	
dw_area.setcolumn(1)
dw_area.SetFocus()
	
w_mdi_frame.sle_msg.text = "새로운 자료를 입력하십시요!!"

end event

type p_exit from w_inherite`p_exit within w_sys_help_010
integer x = 4293
integer y = 28
end type

type p_can from w_inherite`p_can within w_sys_help_010
integer x = 4119
integer y = 28
end type

event p_can::clicked;call super::clicked;dw_1.Reset()
dw_area.Reset()
dw_1.InsertRow(0)
dw_area.InsertRow(0)

dw_area.SetITem(1,'call_dt', is_today)
dw_area.SetITem(1,'call_userid', gs_userid)
dw_area.SetITem(1,'call_dept', gs_deptname)
dw_area.SetITem(1,'call_emp', gs_username)
dw_area.SetITem(1,'flag', '1')   //접수

ib_any_typing = false
end event

type p_print from w_inherite`p_print within w_sys_help_010
boolean visible = false
integer x = 178
integer y = 2308
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_sys_help_010
boolean visible = false
integer x = 361
integer y = 2308
integer taborder = 0
end type

type p_del from w_inherite`p_del within w_sys_help_010
integer x = 3945
integer y = 28
end type

event p_del::clicked;call super::clicked;
String sansno
Long llRow

dw_area.AcceptText()
llRow = dw_area.GetRow()
IF llRow <=0 Then Return

sansno = dw_area.GetItemString(llRow, 'ans_no')

If Not (isNull(sansno) Or sansno = '') Then
	messagebox('확인', '이미 접수되거나 완료된 자료는 삭제할 수 없습니다!')
	Return
End If

IF f_msg_delete() = -1 THEN RETURN
	
dw_area.DeleteRow(llRow)

IF dw_area.Update() > 0 THEN
	commit;
	ib_any_typing =False
	messagebox("확인", "자료를 삭제하였습니다!!")
	p_can.TriggerEvent(Clicked!)
ELSE
	rollback;
	ib_any_typing =True
END IF

end event

type p_mod from w_inherite`p_mod within w_sys_help_010
integer x = 3771
integer y = 28
end type

event p_mod::clicked;call super::clicked;Long llRow, llCnt, sSerial
String  sFlag, scallno, spart, ssubject, sansno, sansdt, saboutdt, sprocessdt, sprocessremk

IF dw_area.Accepttext() = -1 THEN 	RETURN

scallno = Trim(dw_area.GetItemString(1, 'call_no'))
sansno = Trim(dw_area.GetItemString(1, 'ans_no'))

IF isNull(scallno) Or scallno = '' THEN
	sFlag = Trim(dw_area.GetItemString(1, 'flag'))
	spart = Trim(dw_area.GetItemString(1, 'call_part'))
	ssubject = Trim(dw_area.GetItemString(1, 'call_subject'))
	
	SELECT TO_NUMBER(NVL(MAX(SUBSTR(CALL_NO,9,4)),0)) INTO :sserial
		FROM SYS_HELPME 
		WHERE CALL_DT = :is_today;
	
	IF SQLCA.SQLCODE <> 0 Or sserial <= 0  THEN
		sserial = 0
	END IF
	sserial = sserial + 1

	dw_area.SetItem(1, 'call_no', is_today + String(sserial,'0000'))
END IF

IF sFlag = '2' Then
	saboutdt = Trim(dw_area.GetItemString(1, 'about_dt'))
	sansdt = Trim(dw_area.GetItemString(1, 'ans_dt'))

	IF isNull(sansno) Or sansno = '' THEN
		SELECT TO_NUMBER(NVL(MAX(SUBSTR(ANS_NO,9,4)),0)) INTO :sserial
			FROM SYS_HELPME 
			WHERE ANS_DT = :is_today;
	
		IF SQLCA.SQLCODE <> 0 Or sserial <= 0  THEN
			sserial = 0
		END IF
		sserial = sserial + 1
		dw_area.SetItem(1, 'ans_no', is_today + String(sserial,'0000'))
	End If
End If

IF sFlag = '3' Then
	sprocessdt = Trim(dw_area.GetItemString(1, 'process_dt'))
	sprocessremk = Trim(dw_area.GetItemString(1, 'process_remk'))
	If isNull(sprocessdt) Or sprocessdt = '' Then
		messagebox("확인", "완료일자는 반드시 입력하세요!")
		Return
	End If
	If isNull(sprocessremk) Or sprocessremk = '' Then
		messagebox("확인", "처리결과는 반드시 입력하세요!")
		Return
	End If
End If

IF dw_area.Update() > 0 THEN			
	COMMIT;
	ib_any_typing =False

	messagebox("확인", "자료를 저장하였습니다!!")
ELSE
	ROLLBACK;
	ib_any_typing = True
	messagebox("확인", "자료 저장에 실패하였습니다!!")
	Return
END IF

p_retrieve.TriggerEvent(Clicked!)
end event

type cb_exit from w_inherite`cb_exit within w_sys_help_010
integer x = 3145
integer y = 2604
end type

type cb_mod from w_inherite`cb_mod within w_sys_help_010
integer x = 2089
integer y = 2604
end type

type cb_ins from w_inherite`cb_ins within w_sys_help_010
integer x = 1746
integer y = 2608
string text = "추가(&I)"
end type

type cb_del from w_inherite`cb_del within w_sys_help_010
integer x = 2441
integer y = 2604
end type

type cb_inq from w_inherite`cb_inq within w_sys_help_010
integer x = 544
integer y = 2608
end type

type cb_print from w_inherite`cb_print within w_sys_help_010
integer x = 1390
integer y = 2608
end type

event cb_print::clicked;call super::clicked;//IF MessageBox("확인", "출력하시겠습니까?", question!, yesno!) = 2	THEN	RETURN
//
//dw_1.print()
end event

type st_1 from w_inherite`st_1 within w_sys_help_010
integer x = 46
integer y = 2908
integer width = 320
end type

type cb_can from w_inherite`cb_can within w_sys_help_010
integer x = 2793
integer y = 2604
end type

type cb_search from w_inherite`cb_search within w_sys_help_010
integer x = 896
integer y = 2608
end type

type dw_datetime from w_inherite`dw_datetime within w_sys_help_010
integer x = 2789
integer y = 2908
integer width = 741
integer height = 84
end type

type sle_msg from w_inherite`sle_msg within w_sys_help_010
integer y = 2908
integer width = 2418
end type

type gb_10 from w_inherite`gb_10 within w_sys_help_010
integer x = 23
integer y = 2856
integer width = 3525
end type

type gb_button1 from w_inherite`gb_button1 within w_sys_help_010
end type

type gb_button2 from w_inherite`gb_button2 within w_sys_help_010
end type

type dw_area from u_key_enter within w_sys_help_010
event ue_key pbm_dwnkey
integer x = 64
integer y = 240
integer width = 4507
integer height = 2032
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_sys_help_010"
boolean border = false
end type

event ue_key;//

end event

event editchanged;ib_any_typing =True
end event

event itemerror;Return 1
end event

event itemchanged;string sCode,snull,sDeptCode,sDeptname, sAreaCode, sareaname
Int    lReturnRow,lRow

SetNull(snull)

ib_any_typing =True
end event

event ue_pressenter;Choose Case This.GetColumnName()
		Case 'call_remk','process_remk','how_to'
	     return 0
	Case Else
        Send(Handle(this),256,9,0)
		  Return 1
End Choose
end event

event buttonclicked;call super::buttonclicked;If dwo.Name = 'b_1' Then  //접수처리
	Long sserial
	String saboutdt, sansdt, sansno
	saboutdt = Trim(dw_area.GetItemString(1, 'about_dt'))
	sansdt = Trim(dw_area.GetItemString(1, 'ans_dt'))

	IF isNull(sansno) Or sansno = '' THEN
		SELECT TO_NUMBER(NVL(MAX(SUBSTR(ANS_NO,9,4)),0)) INTO :sserial
			FROM SYS_HELPME 
			WHERE ANS_DT = :is_today;
	
		IF SQLCA.SQLCODE <> 0 Or sserial <= 0  THEN
			sserial = 0
		END IF
		sserial = sserial + 1
		dw_area.SetItem(1, 'ans_no', is_today + String(sserial,'0000'))
	End If

	dw_area.SetItem(1,'flag', '2')
	dw_area.SetItem(1,'ans_dt', is_today)
	dw_area.SetItem(1,'about_dt', is_today)
	dw_area.SetItem(1,'ans_userid',gs_userid)
	dw_area.SetItem(1,'ans_emp',gs_username)
	Return
End If

If dwo.Name = 'b_2' Then  //완료처리
	String sprocessdt, sprocessremk
	sprocessdt = Trim(dw_area.GetItemString(1, 'process_dt'))
	sprocessremk = Trim(dw_area.GetItemString(1, 'process_remk'))
	If isNull(sprocessdt) Or sprocessdt = '' Then
		messagebox("확인", "완료일자는 반드시 입력하세요!")
		Return
	End If
	If isNull(sprocessremk) Or sprocessremk = '' Then
		messagebox("확인", "처리결과는 반드시 입력하세요!")
		Return
	End If

	dw_area.SetItem(1,'flag', '3')
	dw_area.SetItem(1,'ans_dt', is_today)
	dw_area.SetItem(1,'about_dt', is_today)
	dw_area.SetItem(1,'ans_userid',gs_userid)
	dw_area.SetItem(1,'ans_emp',gs_username)
End If

p_mod.TriggerEvent(Clicked!)
end event

type dw_1 from datawindow within w_sys_help_010
integer x = 498
integer y = 60
integer width = 667
integer height = 100
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_sys_help_011"
boolean border = false
boolean livescroll = true
end type

event itemchanged;p_retrieve.TriggerEvent(Clicked!)
end event

event rbuttondown;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Choose Case GetColumnName() 
	Case "call_no" 
    	Open(w_sys_helpme_popup)
		 
      If IsNull(gs_code) Then Return 1
		
		this.SetItem(1,"call_no",gs_code)
		p_retrieve.TriggerEvent(Clicked!)
		dw_area.SetFocus()
End Choose
end event

type st_2 from statictext within w_sys_help_010
integer x = 146
integer y = 76
integer width = 361
integer height = 64
boolean bringtotop = true
integer textsize = -11
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "의뢰번호"
alignment alignment = center!
boolean focusrectangle = false
end type

type p_retrieve from picture within w_sys_help_010
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
event ue_mousemove pbm_mousemove
integer x = 3598
integer y = 32
integer width = 178
integer height = 144
integer taborder = 20
boolean bringtotop = true
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;PictureName = 'C:\erpman\image\조회_dn.gif'

end event

event ue_lbuttonup;PictureName = 'C:\erpman\image\조회_up.gif'

end event

event clicked;String lscallno

if dw_1.AcceptText() = -1 then return  

lscallno = Trim(dw_1.GetItemString(1,'call_no'))

If isNull(lscallno) Or lscallno = '' Then
	Return
End If

IF dw_area.Retrieve(lscallno, isAdmin) <= 0 THEN
	SetPointer(Arrow!)
	messagebox('확인','등록된 자료가 없습니다!')
	Return
END IF

wf_taborder()

SetPointer(Arrow!)	
end event

type st_3 from statictext within w_sys_help_010
integer x = 1431
integer y = 28
integer width = 2016
integer height = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 32106727
string text = "1. 이곳은 ERP운영중 의문사항이나 수정요청을 하는 곳입니다."
boolean focusrectangle = false
end type

type st_4 from statictext within w_sys_help_010
integer x = 1431
integer y = 96
integer width = 2016
integer height = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 32106727
string text = "2. 아래의 ~"의뢰부서작성~"란 부분만 작성하신 후 저장하십시요."
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_sys_help_010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 232
integer width = 4530
integer height = 2044
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_sys_help_010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 50
integer y = 24
integer width = 1253
integer height = 168
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_sys_help_010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 3479
integer y = 12
integer width = 1102
integer height = 180
integer cornerheight = 40
integer cornerwidth = 55
end type

