$PBExportHeader$w_pu01_00011.srw
$PBExportComments$** 년 구매계획 마감처리
forward
global type w_pu01_00011 from w_inherite
end type
type rr_3 from roundrectangle within w_pu01_00011
end type
type p_1 from picture within w_pu01_00011
end type
type p_2 from picture within w_pu01_00011
end type
type dw_1 from datawindow within w_pu01_00011
end type
type dw_insert2 from datawindow within w_pu01_00011
end type
type dw_7 from datawindow within w_pu01_00011
end type
type st_2 from statictext within w_pu01_00011
end type
type rr_2 from roundrectangle within w_pu01_00011
end type
type rr_1 from roundrectangle within w_pu01_00011
end type
end forward

global type w_pu01_00011 from w_inherite
integer width = 5865
integer height = 2424
string title = "년 구매계획 확정"
rr_3 rr_3
p_1 p_1
p_2 p_2
dw_1 dw_1
dw_insert2 dw_insert2
dw_7 dw_7
st_2 st_2
rr_2 rr_2
rr_1 rr_1
end type
global w_pu01_00011 w_pu01_00011

forward prototypes
public function integer wf_taborder_zero ()
public function integer wf_initial ()
end prototypes

public function integer wf_taborder_zero ();dw_insert.settaborder("pu01_yearplan_qty_01",0)
dw_insert.settaborder("pu01_yearplan_qty_02",0)
dw_insert.settaborder("pu01_yearplan_qty_03",0)
dw_insert.settaborder("pu01_yearplan_qty_04",0)
dw_insert.settaborder("pu01_yearplan_qty_05",0)
dw_insert.settaborder("pu01_yearplan_qty_06",0)
dw_insert.settaborder("pu01_yearplan_qty_07",0)
dw_insert.settaborder("pu01_yearplan_qty_08",0)
dw_insert.settaborder("pu01_yearplan_qty_09",0)
dw_insert.settaborder("pu01_yearplan_qty_10",0)
dw_insert.settaborder("pu01_yearplan_qty_11",0)
dw_insert.settaborder("pu01_yearplan_qty_12",0)

return 1
end function

public function integer wf_initial ();dw_1.Reset()
dw_7.Reset()
dw_insert.Reset()
dw_insert2.Reset()

//dw_7.insertrow(0)
//dw_7.setitem(1,'gubun','1')
//dw_7.triggerevent(itemchanged!)

dw_1.insertrow(0)

string	smaxyyyy

select max(yyyy) into :smaxyyyy from pu01_yearplan ;
if isnull(smaxyyyy) or smaxyyyy = '' then
	dw_1.setitem(1,'yyyy',left(f_today(),4))
else	
	dw_1.setitem(1,'yyyy',smaxyyyy)
end if
dw_1.triggerevent(itemchanged!)
dw_1.setfocus()

return 1
end function

on w_pu01_00011.create
int iCurrent
call super::create
this.rr_3=create rr_3
this.p_1=create p_1
this.p_2=create p_2
this.dw_1=create dw_1
this.dw_insert2=create dw_insert2
this.dw_7=create dw_7
this.st_2=create st_2
this.rr_2=create rr_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_3
this.Control[iCurrent+2]=this.p_1
this.Control[iCurrent+3]=this.p_2
this.Control[iCurrent+4]=this.dw_1
this.Control[iCurrent+5]=this.dw_insert2
this.Control[iCurrent+6]=this.dw_7
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.rr_2
this.Control[iCurrent+9]=this.rr_1
end on

on w_pu01_00011.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_3)
destroy(this.p_1)
destroy(this.p_2)
destroy(this.dw_1)
destroy(this.dw_insert2)
destroy(this.dw_7)
destroy(this.st_2)
destroy(this.rr_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_insert.SetTransObject(sqlca)
dw_insert2.SetTransObject(sqlca)

//wf_taborder_zero()
wf_initial()

//dw_insert.sharedata(dw_insert2)
end event

type dw_insert from w_inherite`dw_insert within w_pu01_00011
integer x = 64
integer y = 284
integer width = 4485
integer height = 1904
string dataobject = "d_pu01_00011_3"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::doubleclicked;call super::doubleclicked;//if row <= 0 then return
//
//long		lrow
//string	sitnbr, scvcod
//
//sitnbr = this.getitemstring(row,'pu01_yearplan_itnbr')
//scvcod = this.getitemstring(row,'pu01_yearplan_cvcod')
//
//lrow = dw_insert2.find("pu01_yearplan_itnbr='"+sitnbr+"' and "+&
//							 "pu01_yearplan_cvcod='"+scvcod+"'",1,dw_insert2.rowcount())
//if lrow > 0 then
//	dw_7.setitem(1,'gubun','2')
//	dw_7.triggerevent(itemchanged!)
//
//	lrow = dw_insert2.find("pu01_yearplan_itnbr='"+sitnbr+"' and "+&
//							 "pu01_yearplan_cvcod='"+scvcod+"'",1,dw_insert2.rowcount())
//							 
//	this.selectrow(0,false)	
//	dw_insert2.setrow(lrow)
//	dw_insert2.selectrow(0,false)
//	dw_insert2.selectrow(lrow,true)
//	dw_insert2.scrolltorow(lrow)	
//end if
end event

event dw_insert::clicked;call super::clicked;if row <= 0 then return
this.selectrow(0,false)
this.selectrow(row,true)
end event

type p_delrow from w_inherite`p_delrow within w_pu01_00011
boolean visible = false
integer x = 4178
integer y = 2680
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_pu01_00011
boolean visible = false
integer x = 4005
integer y = 2680
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_pu01_00011
integer x = 3717
boolean originalsize = true
string picturename = "C:\erpman\image\확정취소_up.gif"
end type

event p_search::ue_lbuttondown;//PictureName = "C:\erpman\image\마감취소_dn.gif"
end event

event p_search::ue_lbuttonup;//PictureName = "C:\erpman\image\마감취소_UP.gif"
end event

event p_search::clicked;call super::clicked;String syyyy ,ls_confirm_t
Long   ll_cnt 

If dw_1.AcceptText() <> 1 Then Return

syyyy = dw_1.GetItemString(1, 'yyyy')
If IsNull(syyyy) Or syyyy = '' Then Return

SELECT COUNT(*) Into :ll_cnt
  FROM PU01_YEARPLAN
 WHERE SABU = :gs_saupj
   AND yyyy = :syyyy
	AND CNFTIME IS NOT NULL ;
	
If ll_cnt < 1 Then	
	Return
Else
	SELECT COUNT(*) Into :ll_cnt
	  FROM PU01_YEARPLAN A
	 WHERE A.SABU = :gs_saupj
		AND A.YYYY = :syyyy
		AND A.WEBCNF IS NOT NULL ;
	
	if ll_cnt > 0 then
		messagebox('확인','이미 WEB 전송 처리가 완료된 자료입니다.')
		RETURN
	END IF
End If


If  MessageBox("마감", '년구매계획을 확정취소처리 합니다', Exclamation!, OKCancel!, 1) = 2 Then Return

SetNull(ls_confirm_t)

UPDATE PU01_YEARPLAN
   SET CNFTIME = :ls_confirm_t
 WHERE SABU = :gs_saupj
   AND yyyy = :syyyy ; 
	
If SQLCA.SQLCODE <> 0 Then
	MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
	Rollback;
	Return
End If

COMMIT;

MessageBox('확인','정상적으로 확정취소 처리되었습니다.!!')
dw_1.triggerevent(itemchanged!)
end event

type p_ins from w_inherite`p_ins within w_pu01_00011
boolean visible = false
integer x = 3831
integer y = 2680
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_pu01_00011
integer x = 4370
end type

event p_exit::clicked;close(parent)

end event

type p_can from w_inherite`p_can within w_pu01_00011
integer x = 4197
end type

event p_can::clicked;call super::clicked;wf_initial()
end event

type p_print from w_inherite`p_print within w_pu01_00011
boolean visible = false
integer x = 3483
integer y = 2680
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_pu01_00011
integer x = 3360
end type

event p_inq::clicked;string	syyyy, sgubun

dw_1.accepttext()
syyyy = trim(dw_1.getitemstring(1,'yyyy'))
if Isnull(syyyy) or syyyy = '' then
	f_message_chk(1400,'[계획년도]')
	return
end if

sgubun = trim(dw_1.getitemstring(1,'gubun'))

select yyyy into :syyyy from pu01_yearplan
 where sabu = :gs_saupj and yyyy = :syyyy and rownum = 1 ;

if sqlca.sqlcode <> 0 then
	messagebox("확인","해당년도의 구매계획 자료가 없습니다!!!")
	return
end if

setpointer(hourglass!)
If dw_insert.Retrieve(gs_saupj,syyyy,sgubun) <= 0 Then
	f_message_chk(50,'년 구매계획')
End If
//dw_insert2.Retrieve(gs_saupj,syyyy)

//dw_7.setitem(1,'gubun','2')
//dw_7.postevent(itemchanged!)
end event

type p_del from w_inherite`p_del within w_pu01_00011
boolean visible = false
integer x = 4526
integer y = 2680
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_pu01_00011
integer x = 3538
boolean originalsize = true
string picturename = "C:\erpman\image\확정_up.gif"
end type

event p_mod::ue_lbuttondown;//PictureName = "C:\erpman\image\마감처리_dn.gif"
end event

event p_mod::ue_lbuttonup;//PictureName = "C:\erpman\image\마감처리_UP.gif"
end event

event p_mod::clicked;call super::clicked;String syyyy ,ls_confirm_t
Long   ll_cnt ,ll_confirm 

If dw_1.AcceptText() <> 1 Then Return

syyyy = dw_1.GetItemString(1, 'yyyy')
If IsNull(syyyy) Or syyyy = ''Then Return

SELECT COUNT(*) Into :ll_cnt
  FROM PU01_YEARPLAN
 WHERE SABU = :gs_saupj
   AND YYYY = :syyyy	 ;
	
If SQLCA.SQLCODE <> 0 OR ll_cnt < 1 Then
	MessageBox('확인','해당 년도의 구매계획이 존재하지 않습니다.')
	dw_1.setfocus()
	Return
End If

select Count(cnftime) into :ll_confirm 
  from PU01_YEARPLAN
 where sabu = :gs_saupj 
   and yyyy = :syyyy 
	and (CNFTIME IS NOT NULL OR CNFTIME > '' ) ;
	
if ll_confirm > 0 then
	MessageBox('확인','해당 년도의 구매계획이 확정처리 되었습니다.')
	dw_1.setfocus()
	Return
end If

If  MessageBox("마감", '년구매계획을 확정처리 합니다', Exclamation!, OKCancel!, 1) = 2 Then Return

ls_confirm_t = f_today() + ' ' +f_totime()

UPDATE PU01_YEARPLAN
   SET CNFTIME = :ls_confirm_t
 WHERE SABU = :gs_saupj
   AND yyyy = :syyyy
	AND (CNFTIME IS NULL OR CNFTIME = '') ;
	
If SQLCA.SQLCODE <> 0 Then
	MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
	Rollback;
	dw_1.setfocus()
	Return
End If

COMMIT;

MessageBox('확인','정상적으로 확정 처리되었습니다.!!')
dw_1.triggerevent(itemchanged!)
end event

event p_mod::ue_mousemove;//iF flags = 0 Then wf_onmouse(p_mod)
end event

type cb_exit from w_inherite`cb_exit within w_pu01_00011
end type

type cb_mod from w_inherite`cb_mod within w_pu01_00011
end type

type cb_ins from w_inherite`cb_ins within w_pu01_00011
end type

type cb_del from w_inherite`cb_del within w_pu01_00011
end type

type cb_inq from w_inherite`cb_inq within w_pu01_00011
end type

type cb_print from w_inherite`cb_print within w_pu01_00011
end type

type st_1 from w_inherite`st_1 within w_pu01_00011
end type

type cb_can from w_inherite`cb_can within w_pu01_00011
end type

type cb_search from w_inherite`cb_search within w_pu01_00011
end type







type gb_button1 from w_inherite`gb_button1 within w_pu01_00011
end type

type gb_button2 from w_inherite`gb_button2 within w_pu01_00011
end type

type rr_3 from roundrectangle within w_pu01_00011
boolean visible = false
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 4882
integer y = 400
integer width = 151
integer height = 204
integer cornerheight = 40
integer cornerwidth = 55
end type

type p_1 from picture within w_pu01_00011
integer x = 3890
integer y = 24
integer width = 306
integer height = 144
boolean bringtotop = true
string picturename = "C:\erpman\image\WEB.gif"
boolean focusrectangle = false
end type

event clicked;string	syyyy , ls_confirm_t, stemp

If dw_1.AcceptText() <> 1 Then Return
syyyy = trim(dw_1.getitemstring(1,'yyyy'))
if Isnull(syyyy) or syyyy = '' then
	f_message_chk(1400,'[계획년월]')
	return
end if

SELECT CNFTIME INTO :stemp FROM PU01_YEARPLAN
 WHERE SABU = :gs_saupj 
 	AND YYYY = :syyyy 
	AND CNFTIME IS NOT NULL
	AND ROWNUM = 1 ;

IF SQLCA.SQLCODE <> 0 THEN
	MESSAGEBOX('확인','먼저 확정 처리를 하십시오.')
	return
end if


SELECT WEBCNF INTO :stemp FROM PU01_YEARPLAN
 WHERE SABU = :gs_saupj 
 	AND YYYY = :syyyy 
	AND CNFTIME IS NOT NULL
	AND ROWNUM = 1 ;

IF isnull(stemp) or stemp = '' THEN
	If  MessageBox("마감", '년 구매계획을 WEB 전송처리 합니다', Exclamation!, OKCancel!, 1) = 2 Then Return
	setpointer(hourglass!)
	
	ls_confirm_t = f_today() + ' ' +f_totime()
	
	UPDATE PU01_YEARPLAN
		SET WEBCNF = :ls_confirm_t
	 WHERE SABU = :gs_saupj
		AND YYYY = :syyyy
		AND CNFTIME IS NOT NULL ;
		
	If SQLCA.SQLCODE <> 0 Then
		MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
		Rollback;
		Return
	End If
	
	long		lseq
	string	subject, scontent
	
	subject = syyyy + ' 년 구매계획 확정 통보!!!'
	scontent= '년 구매계획이 확정되었습니다.~n업무에 참고하십시오'
	
	select nvl(max(no),0) into :lseq from et_notice
	 where cvcod = 'TOTAL' ;
	
	lseq = lseq + 1
	
	insert into et_notice
	(	no,			subject,				content,				cre_id,				cre_dt,			cvcod	)
	values
	(	:lseq,		:subject,			:scontent,			:gs_userid,			sysdate,			'TOTAL'	) ;
	if sqlca.sqlcode <> 0 then
		Rollback;
		MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
		Return
	End If

	COMMIT;
	
	MessageBox('확인','정상적으로 WEB 전송 처리되었습니다.!!')
	
ELSE	
	If  MessageBox("마감", '년 구매계획을 WEB 전송 취소 처리 합니다', Exclamation!, OKCancel!, 1) = 2 Then Return
	setpointer(hourglass!)
	
	UPDATE PU01_YEARPLAN
		SET WEBCNF = NULL
	 WHERE SABU = :gs_saupj
		AND YYYY = :syyyy
		AND CNFTIME IS NOT NULL ;
		
	If SQLCA.SQLCODE <> 0 Then
		MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
		Rollback;
		Return
	End If
	
	COMMIT;
	
	MessageBox('확인','정상적으로 WEB 전송 취소 처리되었습니다.!!')
END IF
end event

type p_2 from picture within w_pu01_00011
boolean visible = false
integer x = 4887
integer y = 400
integer width = 306
integer height = 144
boolean bringtotop = true
string picturename = "C:\erpman\image\예정통보.gif"
boolean focusrectangle = false
end type

event clicked;string	syyyy , ls_confirm_t, stemp

If dw_1.AcceptText() <> 1 Then Return
syyyy = trim(dw_1.getitemstring(1,'yyyy'))
if Isnull(syyyy) or syyyy = '' then
	f_message_chk(1400,'[계획년월]')
	return
end if

SELECT CNFTIME INTO :stemp FROM PU01_YEARPLAN
 WHERE SABU = :gs_saupj 
 	AND YYYY = :syyyy 
	AND (WEBCNF IS NOT NULL OR CNFTIME IS NOT NULL)
	AND ROWNUM = 1 ;

IF SQLCA.SQLCODE = 0 THEN
	MESSAGEBOX('확인','이미 통보된 자료입니다.')
	return
end if


If  MessageBox("마감", '년 구매계획을 WEB 예정통보 합니다', Exclamation!, OKCancel!, 1) = 2 Then Return
setpointer(hourglass!)

ls_confirm_t = f_today() + ' ' +f_totime()

UPDATE PU01_YEARPLAN
	SET WEBYEBI = :ls_confirm_t
 WHERE SABU = :gs_saupj
	AND YYYY = :syyyy ;
	
If SQLCA.SQLCODE <> 0 Then
	Rollback;
	MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
	Return
End If

long		lseq
string	subject, scontent, stime

select max(no)
  into :lseq
  from et_notice ;
if sqlca.sqlcode = 0 then
	lseq = lseq + 1
else
	lseq = 1
end if

subject = syyyy + ' 년 구매계획 예정 통보!!!'
scontent= '검토하시고 가부판정을 내려 주십시오'

insert into et_notice
(	no,			subject,				content,				cre_id,				cre_dt	)
values
(	:lseq,		:subject,			:scontent,			'bds',				sysdate	) ;
if sqlca.sqlcode <> 0 then
	Rollback;
	MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
	Return
End If

COMMIT;

MessageBox('확인','정상적으로 WEB 전송 처리되었습니다.!!')
end event

type dw_1 from datawindow within w_pu01_00011
integer x = 96
integer y = 92
integer width = 2912
integer height = 108
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_pu01_00010_0"
boolean border = false
boolean livescroll = true
end type

event itemchanged;string	syyyy, scnfirm

syyyy = this.gettext()

select substr(cnftime,1,8) into :scnfirm from pu01_yearplan
 where sabu = :gs_saupj and yyyy = :syyyy and cnftime is not null and rownum = 1 ;

if sqlca.sqlcode = 0 then
	this.setitem(1,'cnfirm','3')
else
	this.setitem(1,'cnfirm','1')
end if
end event

event itemerror;return 1
end event

type dw_insert2 from datawindow within w_pu01_00011
boolean visible = false
integer x = 64
integer y = 284
integer width = 4485
integer height = 1904
integer taborder = 120
boolean bringtotop = true
string title = "none"
string dataobject = "d_pu01_00011_3"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event doubleclicked;//if row <= 0 then return
//
//long		lrow
//string	sitnbr, scvcod
//
//sitnbr = this.getitemstring(row,'pu01_yearplan_itnbr')
//scvcod = this.getitemstring(row,'pu01_yearplan_cvcod')
//
//lrow = dw_insert.find("pu01_yearplan_itnbr='"+sitnbr+"' and "+&
//							 "pu01_yearplan_cvcod='"+scvcod+"'",1,dw_insert.rowcount())
//if lrow > 0 then
//	dw_7.setitem(1,'gubun','1')
//	dw_7.triggerevent(itemchanged!)
//
//	lrow = dw_insert.find("pu01_yearplan_itnbr='"+sitnbr+"' and "+&
//							 "pu01_yearplan_cvcod='"+scvcod+"'",1,dw_insert.rowcount())
//	this.selectrow(0,false)
//	dw_insert.setrow(lrow)
//	dw_insert.selectrow(0,false)
//	dw_insert.selectrow(lrow,true)
//	dw_insert.scrolltorow(lrow)	
//end if
end event

event clicked;if row <= 0 then return
this.selectrow(0,false)
this.selectrow(row,true)
end event

type dw_7 from datawindow within w_pu01_00011
boolean visible = false
integer x = 4942
integer y = 428
integer width = 178
integer height = 148
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_pu01_00011_4"
boolean border = false
boolean livescroll = true
end type

event itemchanged;dw_insert.setredraw(false)
dw_insert2.setredraw(false)

if this.gettext() = '1' then
	st_2.visible = false
	dw_insert.visible = true
	dw_insert2.visible = false
	
else
	st_2.visible = true
	dw_insert.visible = false
	dw_insert2.visible = true
	
end if

dw_insert.setredraw(true)
dw_insert2.setredraw(true)
end event

type st_2 from statictext within w_pu01_00011
integer x = 4096
integer y = 204
integer width = 439
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "(금액단위:천원)"
boolean focusrectangle = false
end type

type rr_2 from roundrectangle within w_pu01_00011
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 40
integer width = 2976
integer height = 204
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_pu01_00011
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 272
integer width = 4507
integer height = 1928
integer cornerheight = 40
integer cornerwidth = 55
end type

