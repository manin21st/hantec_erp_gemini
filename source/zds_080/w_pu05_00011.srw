$PBExportHeader$w_pu05_00011.srw
$PBExportComments$** 월 외주계획 마감
forward
global type w_pu05_00011 from w_inherite
end type
type p_1 from picture within w_pu05_00011
end type
type dw_7 from datawindow within w_pu05_00011
end type
type dw_1 from datawindow within w_pu05_00011
end type
type dw_insert2 from datawindow within w_pu05_00011
end type
type st_2 from statictext within w_pu05_00011
end type
type pb_1 from u_pb_cal within w_pu05_00011
end type
type p_2 from picture within w_pu05_00011
end type
type rr_2 from roundrectangle within w_pu05_00011
end type
type rr_3 from roundrectangle within w_pu05_00011
end type
type rr_1 from roundrectangle within w_pu05_00011
end type
end forward

global type w_pu05_00011 from w_inherite
integer width = 6034
string title = "월 외주계획 확정"
p_1 p_1
dw_7 dw_7
dw_1 dw_1
dw_insert2 dw_insert2
st_2 st_2
pb_1 pb_1
p_2 p_2
rr_2 rr_2
rr_3 rr_3
rr_1 rr_1
end type
global w_pu05_00011 w_pu05_00011

type variables
str_itnct str_sitnct
end variables

forward prototypes
public function integer wf_initial ()
public function integer wf_taborder_zero ()
public subroutine wf_excel_down (datawindow adw_excel)
end prototypes

public function integer wf_initial ();dw_1.Reset()
dw_7.Reset()
dw_insert.Reset()
dw_insert2.Reset()

dw_7.insertrow(0)
dw_7.setitem(1,'gubun','1')
dw_7.triggerevent(itemchanged!)

dw_1.insertrow(0)

string	smaxyymm

select max(yymm) into :smaxyymm from pu02_monplan
 where waigb = '2' ;
if isnull(smaxyymm) or smaxyymm = '' then
	dw_1.Object.yymm[1] = Left(f_today(),6)
else	
	dw_1.Object.yymm[1] = smaxyymm
end if
dw_1.postevent(itemchanged!)

dw_1.setfocus()

return 1
end function

public function integer wf_taborder_zero ();dw_insert.settaborder("qty_01",0)
dw_insert.settaborder("qty_02",0)
dw_insert.settaborder("qty_03",0)
dw_insert.settaborder("qty_04",0)
dw_insert.settaborder("qty_05",0)
dw_insert.settaborder("qty_06",0)

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

on w_pu05_00011.create
int iCurrent
call super::create
this.p_1=create p_1
this.dw_7=create dw_7
this.dw_1=create dw_1
this.dw_insert2=create dw_insert2
this.st_2=create st_2
this.pb_1=create pb_1
this.p_2=create p_2
this.rr_2=create rr_2
this.rr_3=create rr_3
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_1
this.Control[iCurrent+2]=this.dw_7
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.dw_insert2
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.pb_1
this.Control[iCurrent+7]=this.p_2
this.Control[iCurrent+8]=this.rr_2
this.Control[iCurrent+9]=this.rr_3
this.Control[iCurrent+10]=this.rr_1
end on

on w_pu05_00011.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.p_1)
destroy(this.dw_7)
destroy(this.dw_1)
destroy(this.dw_insert2)
destroy(this.st_2)
destroy(this.pb_1)
destroy(this.p_2)
destroy(this.rr_2)
destroy(this.rr_3)
destroy(this.rr_1)
end on

event open;call super::open;dw_1.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)
dw_insert2.SetTransObject(sqlca)

wf_taborder_zero()
wf_initial()

end event

type dw_insert from w_inherite`dw_insert within w_pu05_00011
integer x = 69
integer y = 280
integer width = 4494
integer height = 1908
string dataobject = "d_pu05_00011_b"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::clicked;call super::clicked;if row <= 0 then return
this.selectrow(0,false)
this.selectrow(row,true)
end event

event dw_insert::doubleclicked;call super::doubleclicked;//if row <= 0 then return
//
//long		lrow
//string	sitnbr, scvcod
//
//sitnbr = this.getitemstring(row,'itnbr')
//scvcod = this.getitemstring(row,'cvcod')
//
//lrow = dw_insert2.find("itnbr='"+sitnbr+"' and "+&
//							 "cvcod='"+scvcod+"'",1,dw_insert2.rowcount())
//if lrow > 0 then
//	dw_7.setitem(1,'gubun','2')
//	dw_7.triggerevent(itemchanged!)
//	
//	lrow = dw_insert2.find("itnbr='"+sitnbr+"' and "+&
//							 "cvcod='"+scvcod+"'",1,dw_insert2.rowcount())
//	
//	this.selectrow(0,false)
//	dw_insert2.setrow(lrow)
//	dw_insert2.selectrow(0,false)
//	dw_insert2.selectrow(lrow,true)
//	dw_insert2.scrolltorow(lrow)	
//end if
end event

type p_delrow from w_inherite`p_delrow within w_pu05_00011
boolean visible = false
integer x = 5280
integer y = 596
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_pu05_00011
boolean visible = false
integer x = 5106
integer y = 596
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_pu05_00011
integer x = 3730
integer y = 28
string picturename = "C:\erpman\image\확정취소_up.gif"
end type

event p_search::ue_lbuttondown;//PictureName = "C:\erpman\image\마감취소_dn.gif"
end event

event p_search::ue_lbuttonup;//PictureName = "C:\erpman\image\마감취소_UP.gif"
end event

event p_search::clicked;call super::clicked;String sYymm ,ls_confirm_t
Long   ll_cnt 

If dw_1.AcceptText() <> 1 Then Return

sYymm = dw_1.GetItemString(1, 'yymm')
If IsNull(sYymm) Or sYymm = '' Then Return

SELECT COUNT(*) Into :ll_cnt
  FROM PU02_MONPLAN
 WHERE SABU = :gs_saupj
   AND YYMM = :sYymm
	AND WAIGB = '2'
	AND CNFTIME IS NOT NULL ;
	
If ll_cnt < 1 Then
	Return
Else
	SELECT COUNT(*) Into :ll_cnt
	  FROM PU02_MONPLAN A
	 WHERE A.SABU = :gs_saupj
		AND A.YYMM = :sYymm
		AND A.WAIGB = '2'
		AND A.WEBCNF IS NOT NULL ;
	
	if ll_cnt > 0 then
		messagebox('확인','이미 WEB 전송 처리가 완료된 자료입니다.')
		RETURN
	END IF
End If


If  MessageBox("확정", '월 외주계획을 확정취소처리 합니다', Exclamation!, OKCancel!, 1) = 2 Then Return

SetNull(ls_confirm_t)

UPDATE PU02_MONPLAN
   SET CNFTIME = :ls_confirm_t
 WHERE SABU = :gs_saupj
   AND YYMM = :sYymm
	AND WAIGB = '2' ;
	
If SQLCA.SQLCODE <> 0 Then
	MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
	Rollback;
	Return
End If

COMMIT;

dw_1.Object.cnfirm[1] = 'N'

MessageBox('확인','정상적으로 확정취소 처리되었습니다.!!')
end event

type p_ins from w_inherite`p_ins within w_pu05_00011
boolean visible = false
integer x = 4933
integer y = 596
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_pu05_00011
integer x = 4384
integer y = 28
end type

event p_exit::clicked;close(parent)

end event

type p_can from w_inherite`p_can within w_pu05_00011
integer x = 4206
integer y = 28
end type

event p_can::clicked;call super::clicked;wf_initial()
end event

type p_print from w_inherite`p_print within w_pu05_00011
boolean visible = false
integer x = 4741
integer y = 604
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_pu05_00011
integer x = 3383
integer y = 28
end type

event p_inq::clicked;call super::clicked;string	syymm, sgubun , scvcod, sitcls, sittyp
String   ls_confirm
Long     ll_cnt

dw_1.accepttext()
syymm = trim(dw_1.getitemstring(1,'yymm'))
if Isnull(syymm) or syymm = '' then
	f_message_chk(1400,'[계획년월]')
	return
end if

sgubun = trim(dw_1.getitemstring(1,'gubun'))
scvcod = trim(dw_1.getitemstring(1,'cvcod'))
If Isnull(scvcod) Then scvcod=''

sitcls = trim(dw_1.getitemstring(1,'itcls'))
If IsNull(sItcls) Then sItcls = ''

sittyp = trim(dw_1.getitemstring(1,'ittyp'))
If IsNull(sittyp) Then sittyp = ''

SELECT COUNT(*) Into :ll_cnt 
  FROM PU02_MONPLAN
  WHERE SABU = :gs_saupj
    AND YYMM = :syymm
	 AND WAIGB = '2' ;

If SQLCA.SQLCODE <> 0 or ll_cnt < 1 Then	
	dw_insert.SetRedraw(false)
	dw_insert.Reset()
	dw_insert.SetRedraw(True)
	f_message_chk(50,'월 외주계획')
	Return
End if

setpointer(hourglass!)
If dw_insert.Retrieve(gs_saupj,syymm,sgubun, sItcls+'%', scvcod+'%', sittyp+'%') <= 0 Then
	f_message_chk(50,'월 외주계획')
End If
end event

type p_del from w_inherite`p_del within w_pu05_00011
boolean visible = false
integer x = 5627
integer y = 596
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_pu05_00011
integer x = 3557
integer y = 28
string picturename = "C:\erpman\image\확정_up.gif"
end type

event p_mod::ue_lbuttondown;//PictureName = "C:\erpman\image\마감처리_dn.gif"
end event

event p_mod::ue_lbuttonup;//PictureName = "C:\erpman\image\마감처리_UP.gif"
end event

event p_mod::clicked;call super::clicked;String sYymm ,ls_confirm_t
Long   ll_cnt ,ll_confirm 

If dw_1.AcceptText() <> 1 Then Return

sYymm = dw_1.GetItemString(1, 'yymm')
If IsNull(sYymm) Or sYymm = '' Or f_datechk(syymm+'01') < 0 Then Return

SELECT COUNT(*) Into :ll_cnt
  FROM PU02_MONPLAN
 WHERE SABU = :gs_saupj
   AND YYMM = :sYymm
	AND WAIGB = '2' ;
	
If SQLCA.SQLCODE <> 0 OR ll_cnt < 1 Then
	MessageBox('확인','해당 년월의 구매계획이 존재하지 않습니다.')
	dw_1.SetRedraw(False)
	dw_1.Reset()
	dw_1.InsertRow(0)
	dw_1.SetRedraw(True)
	Return
End If

select Count(cnftime) into :ll_confirm 
  from pu02_monplan
 where sabu = :gs_saupj 
   and yymm = :syymm 
	and waigb = '2'
	and cnftime is not null ;
	
if ll_confirm > 0 then
	MessageBox('확인','해당 년월의 구매계획이 이미 확정되었습니다.')
	dw_1.SetRedraw(False)
	dw_1.Reset()
	dw_1.InsertRow(0)
	dw_1.SetRedraw(True)
	Return
end If

If  MessageBox("확정", '월 구매계획을 확정처리 합니다', Exclamation!, OKCancel!, 1) = 2 Then Return

ls_confirm_t = f_today() + ' ' +f_totime()

UPDATE PU02_MONPLAN
   SET CNFTIME = :ls_confirm_t
 WHERE SABU = :gs_saupj
   AND YYMM = :sYymm
	AND WAIGB = '2' ;
	
If SQLCA.SQLCODE <> 0 Then
	MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
	Rollback;
	Return
End If

COMMIT;

dw_1.Object.cnfirm[1] = 'Y'

MessageBox('확인','정상적으로 확정 처리되었습니다.!!')
end event

event p_mod::ue_mousemove;//iF flags = 0 Then wf_onmouse(p_mod)
end event

type cb_exit from w_inherite`cb_exit within w_pu05_00011
end type

type cb_mod from w_inherite`cb_mod within w_pu05_00011
end type

type cb_ins from w_inherite`cb_ins within w_pu05_00011
end type

type cb_del from w_inherite`cb_del within w_pu05_00011
end type

type cb_inq from w_inherite`cb_inq within w_pu05_00011
end type

type cb_print from w_inherite`cb_print within w_pu05_00011
end type

type st_1 from w_inherite`st_1 within w_pu05_00011
end type

type cb_can from w_inherite`cb_can within w_pu05_00011
end type

type cb_search from w_inherite`cb_search within w_pu05_00011
end type







type gb_button1 from w_inherite`gb_button1 within w_pu05_00011
end type

type gb_button2 from w_inherite`gb_button2 within w_pu05_00011
end type

type p_1 from picture within w_pu05_00011
integer x = 3899
integer y = 28
integer width = 306
integer height = 144
boolean bringtotop = true
string picturename = "C:\erpman\image\WEB.gif"
boolean focusrectangle = false
end type

event clicked;string	syymm , ls_confirm_t, stemp

If dw_1.AcceptText() <> 1 Then Return
syymm = trim(dw_1.getitemstring(1,'yymm'))
if Isnull(syymm) or syymm = '' then
	f_message_chk(1400,'[계획년월]')
	return
end if

SELECT CNFTIME INTO :stemp FROM PU02_MONPLAN
 WHERE SABU = :gs_saupj 
 	AND YYMM = :syymm 
	AND WAIGB = '2' 
	AND CNFTIME IS NOT NULL
	AND ROWNUM = 1 ;

IF SQLCA.SQLCODE <> 0 THEN
	MESSAGEBOX('확인','먼저 확정 처리를 하십시오.')
	return
end if


SELECT MIN(WEBCNF) INTO :stemp FROM PU02_MONPLAN
 WHERE SABU = :gs_saupj 
 	AND YYMM = :syymm 
	AND WAIGB = '2' 
	AND CNFTIME IS NOT NULL;

IF isnull(stemp) or stemp = '' THEN
	If  MessageBox("확정", '월 외주계획을 WEB 전송처리 합니다', Exclamation!, OKCancel!, 1) = 2 Then Return
	setpointer(hourglass!)
	
	ls_confirm_t = f_today() + ' ' +f_totime()
	
	UPDATE PU02_MONPLAN
		SET WEBCNF = :ls_confirm_t
	 WHERE SABU = :gs_saupj
		AND YYMM = :sYymm
		AND WAIGB = '2'
		AND CNFTIME IS NOT NULL ;
		
	If SQLCA.SQLCODE <> 0 Then
		MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
		Rollback;
		Return
	End If
	
	COMMIT;
	MessageBox('확인','정상적으로 WEB 전송 처리되었습니다.!!')
ELSE
	If  MessageBox("확정", '월 외주계획을 WEB 전송 취소 처리 합니다', Exclamation!, OKCancel!, 1) = 2 Then Return
	setpointer(hourglass!)
	
	UPDATE PU02_MONPLAN
		SET WEBCNF = NULL
	 WHERE SABU = :gs_saupj
		AND YYMM = :sYymm
		AND WAIGB = '2'
		AND CNFTIME IS NOT NULL ;
		
	If SQLCA.SQLCODE <> 0 Then
		MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
		Rollback;
		Return
	End If
	
	COMMIT;
	MessageBox('확인','정상적으로 WEB 전송 취소 처리되었습니다.!!')
end if
end event

type dw_7 from datawindow within w_pu05_00011
boolean visible = false
integer x = 4919
integer y = 272
integer width = 453
integer height = 148
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_pu05_00011_2"
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

type dw_1 from datawindow within w_pu05_00011
integer x = 110
integer y = 40
integer width = 2729
integer height = 168
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "d_pu05_00011_1"
boolean border = false
boolean livescroll = true
end type

event itemchanged;string	syymm, scnfirm, sm, sm1, sm2, s_empno, s_name, get_nm
Integer	ireturn

IF this.GetColumnName() = "cvcod" THEN
	s_empno = this.GetText()
	s_name  = this.getitemstring(1,"cvcod")
	
	ireturn = f_get_name2('V1', 'Y', s_empno, get_nm, s_name)
	this.setitem(1, "cvcod", s_empno)	
	this.setitem(1, "cvnas", get_nm)
	
	if isnull(s_name) or s_name = '' then
		this.setitem(1, "cvcod", s_empno)	
		this.setitem(1, "cvnas", get_nm)
	end if
	RETURN ireturn
	
/* 품목분류 지정 */
ElseIF this.GetColumnName() = "itcls" THEN
	string	s_ittyp, s_itcls, s_titnm
	s_ittyp = trim(this.getitemstring(1,'ittyp'))
	if isnull(s_ittyp) or s_ittyp = '' then
		messagebox('확인','품목구분을 지정하세요!!!')
		this.setitem(1,'itcls','')
		this.setitem(1,'titnm','')
		return 1
	end if
	s_itcls = trim(this.gettext())
	if isnull(s_itcls) or s_itcls = '' then
		messagebox('확인','품목분류를 지정하세요!!!')
		this.setitem(1,'itcls','')
		this.setitem(1,'titnm','')
		return 1
	end if
	select titnm into :s_titnm from itnct where ittyp = :s_ittyp and itcls = :s_itcls ;
	if sqlca.sqlcode <> 0 then
		messagebox('확인','품목분류를 확인하세요!!!')
		this.setitem(1,'itcls','')
		this.setitem(1,'titnm','')
		return 1
	end if
	this.setitem(1,'titnm',s_titnm)

ElseIF this.GetColumnName() = "yymm" THEN	
	syymm = trim(this.gettext())
	
	select substr(cnftime,1,8) into :scnfirm from pu02_monplan
	 where sabu = :gs_saupj and yymm = :syymm and waigb = '2'
		and cnftime is not null and rownum = 1 ;
	
	if sqlca.sqlcode = 0 then 
		this.setitem(1,'cnfirm','Y')
	else
		this.setitem(1,'cnfirm','N')
	end if
End If
end event

event itemerror;return 1
end event

event rbuttondown;String sNull, sdate

setnull(gs_code)
setnull(gs_gubun)
setnull(gs_codename)
setnull(snull)


IF this.GetColumnName() = "cvcod" THEN
	gs_gubun ='1'
	Open(w_vndmst_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then	return
	this.SetItem(1, "cvcod", gs_Code)
	this.triggerevent(itemchanged!)
End If

IF this.GetColumnName() = "itcls" Then
	 OpenWithParm(w_ittyp_popup, this.getitemstring(1,'ittyp'))
    str_sitnct = Message.PowerObjectParm	
	 IF str_sitnct.s_ittyp ="" OR IsNull(str_sitnct.s_ittyp) THEN RETURN
	 
	 this.SetItem(1,"ittyp",str_sitnct.s_ittyp)
	 this.SetItem(1,"itcls",str_sitnct.s_sumgub)
	 this.SetItem(1,"titnm", str_sitnct.s_titnm)
End If
end event

type dw_insert2 from datawindow within w_pu05_00011
boolean visible = false
integer x = 69
integer y = 256
integer width = 4494
integer height = 1932
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_pu05_00011_b"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;if row <= 0 then return
this.selectrow(0,false)
this.selectrow(row,true)
end event

event doubleclicked;//if row <= 0 then return
//
//long		lrow
//string	sitnbr, scvcod
//
//sitnbr = this.getitemstring(row,'itnbr')
//scvcod = this.getitemstring(row,'cvcod')
//
//lrow = dw_insert.find("itnbr='"+sitnbr+"' and "+&
//							 "cvcod='"+scvcod+"'",1,dw_insert.rowcount())
//if lrow > 0 then
//	dw_7.setitem(1,'gubun','1')
//	dw_7.triggerevent(itemchanged!)
//	
//	lrow = dw_insert.find("itnbr='"+sitnbr+"' and "+&
//							 "cvcod='"+scvcod+"'",1,dw_insert.rowcount())
//
//	this.selectrow(0,false)
//	dw_insert.setrow(lrow)
//	dw_insert.selectrow(0,false)
//	dw_insert.selectrow(lrow,true)
//	dw_insert.scrolltorow(lrow)	
//end if
end event

type st_2 from statictext within w_pu05_00011
boolean visible = false
integer x = 4101
integer y = 188
integer width = 430
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

type pb_1 from u_pb_cal within w_pu05_00011
integer x = 645
integer y = 40
integer taborder = 71
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_1.SetColumn('yymm')
IF IsNull(gs_code) THEN Return 
dw_1.SetItem(1, 'yymm', left(gs_code,6))
dw_1.triggerevent(itemchanged!)

//post wf_set_magamyn()
end event

type p_2 from picture within w_pu05_00011
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 2907
integer y = 28
integer width = 178
integer height = 144
boolean bringtotop = true
string picturename = "C:\erpman\image\엑셀변환_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;This.PictureName = 'C:\erpman\image\엑셀변환_dn.gif'
end event

event ue_lbuttonup;This.PictureName = 'C:\erpman\image\엑셀변환_up.gif'
end event

event clicked;If this.Enabled Then wf_excel_down(dw_insert)
end event

type rr_2 from roundrectangle within w_pu05_00011
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 24
integer width = 2839
integer height = 204
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_pu05_00011
boolean visible = false
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 4914
integer y = 244
integer width = 471
integer height = 204
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_pu05_00011
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 248
integer width = 4507
integer height = 1952
integer cornerheight = 40
integer cornerwidth = 55
end type

