$PBExportHeader$w_box_magam.srw
forward
global type w_box_magam from w_inherite
end type
type em_1 from editmask within w_box_magam
end type
type st_2 from statictext within w_box_magam
end type
type rr_1 from roundrectangle within w_box_magam
end type
end forward

global type w_box_magam from w_inherite
string title = "BOX수불 마감"
em_1 em_1
st_2 st_2
rr_1 rr_1
end type
global w_box_magam w_box_magam

on w_box_magam.create
int iCurrent
call super::create
this.em_1=create em_1
this.st_2=create st_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.rr_1
end on

on w_box_magam.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_1)
destroy(this.st_2)
destroy(this.rr_1)
end on

type dw_insert from w_inherite`dw_insert within w_box_magam
boolean visible = false
integer x = 37
integer y = 32
boolean enabled = false
boolean border = false
boolean livescroll = false
end type

type p_delrow from w_inherite`p_delrow within w_box_magam
boolean visible = false
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_box_magam
boolean visible = false
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_box_magam
integer x = 2597
integer y = 888
string picturename = "C:\erpman\image\마감_up.gif"
end type

event p_search::ue_lbuttondown;//
PictureName = "C:\erpman\image\마감_dn.gif"
end event

event p_search::ue_lbuttonup;//
PictureName = "C:\erpman\image\마감_up.gif"
end event

event p_search::clicked;call super::clicked;//마감 월 확인
String ls_ym

ls_ym = em_1.Text

If MessageBox('마감 확인', ls_ym + ' 마감을 진행 하시겠습니까?', Question!, YesNo!, 2) <> 1 Then Return

SELECT REPLACE(REPLACE(:ls_ym, '월', ''), '년', '')
  INTO :ls_ym
  FROM DUAL;

INSERT INTO BOX_IOSUM
(SAUPJ, YYMM, IWOL, DEPOT, PLTCOD, IQTY, OQTY, JQTY, AMT, CRT_DATE, CRT_TIME, CRT_USER, BIGO)
  SELECT SAUPJ,
			SUBSTR(IO_DATE, 1, 6),
			'A',
			DEPOT,
			PLTCOD,
			SUM(DECODE(IOGBN, 'I', IOQTY, 0)),
			SUM(DECODE(IOGBN, 'O', IOQTY, 0)),
			SUM(DECODE(IOGBN, 'I', IOQTY, 0)) - SUM(DECODE(IOGBN, 'O', IOQTY, 0)),
			0,
			TO_CHAR(SYSDATE, 'YYYYMMDD'),
			TO_CHAR(SYSDATE, 'HH24MISS'),
			:gs_empno,
			:ls_ym||'월 마감'
	 FROM BOX_IO
	WHERE IO_DATE LIKE :ls_ym
GROUP BY SAUPJ, SUBSTR(IO_DATE, 1, 6), DEPOT, PLTCOD;

INSERT INTO BOX_IOSUM_VND
(SAUPJ, YYMM, IWOL, CVCOD, PLTCOD, IQTY, OQTY, JQTY, AMT, CRT_DATE, CRT_TIME, CRT_USER, BIGO)
  SELECT SAUPJ,
			SUBSTR(IO_DATE, 1, 6),
			'A',
			CVCOD,
			PLTCOD,
			SUM(DECODE(IOGBN, 'I', IOQTY, 0)),
			SUM(DECODE(IOGBN, 'O', IOQTY, 0)),
			SUM(DECODE(IOGBN, 'I', IOQTY, 0)) - SUM(DECODE(IOGBN, 'O', IOQTY, 0)),
			0,
			TO_CHAR(SYSDATE, 'YYYYMMDD'),
			TO_CHAR(SYSDATE, 'HH24MISS'),
			:gs_empno,
			:ls_ym||'월 마감'
	 FROM BOX_IO
	WHERE IO_DATE LIKE :ls_ym
GROUP BY SAUPJ, SUBSTR(IO_DATE, 1, 6), CVCOD, PLTCOD;

end event

type p_ins from w_inherite`p_ins within w_box_magam
boolean visible = false
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_box_magam
integer x = 3118
integer y = 888
end type

type p_can from w_inherite`p_can within w_box_magam
boolean visible = false
integer x = 4096
boolean enabled = false
end type

type p_print from w_inherite`p_print within w_box_magam
boolean visible = false
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_box_magam
boolean visible = false
boolean enabled = false
end type

type p_del from w_inherite`p_del within w_box_magam
integer x = 2944
integer y = 888
end type

event p_del::clicked;call super::clicked;//마감 월 확인
String ls_ym

ls_ym = em_1.Text

If MessageBox('삭제 확인', ls_ym + ' 마감을 삭제 하시겠습니까?', Question!, YesNo!, 2) <> 1 Then Return

SELECT REPLACE(REPLACE(:ls_ym, '월', ''), '년', '')
  INTO :ls_ym
  FROM DUAL;

DELETE FROM BOX_IOSUM
 WHERE SAUPJ = :gs_saupj
   AND YYMM  = :ls_ym
	AND IWOL  = 'A' ;
If SQLCA.SQLCODE <> 0 Then
	MessageBox('Box I/O Sum ' + String(SQLCA.SQLCODE), SQLCA.SQLErrText)
	ROLLBACK USING SQLCA;
	MessageBox('삭제 오류', '마감 삭제 중 오류가 발생했습니다.')
	Return
End If

DELETE FROM BOX_IOSUM_VND
 WHERE SAUPJ = :gs_saupj
   AND YYMM  = :ls_ym
	AND IWOL  = 'A' ;
If SQLCA.SQLCODE <> 0 Then
	MessageBox('Box I/O Sum VND ' + String(SQLCA.SQLCODE), SQLCA.SQLErrText)
	ROLLBACK USING SQLCA;
	MessageBox('삭제 오류', '마감 삭제 중 오류가 발생했습니다.')
	Return
Else
	COMMIT USING SQLCA;
	MessageBox('삭제 확인', '자료가 삭제 되었습니다.')
End If
end event

type p_mod from w_inherite`p_mod within w_box_magam
boolean visible = false
boolean enabled = false
end type

type cb_exit from w_inherite`cb_exit within w_box_magam
end type

type cb_mod from w_inherite`cb_mod within w_box_magam
end type

type cb_ins from w_inherite`cb_ins within w_box_magam
end type

type cb_del from w_inherite`cb_del within w_box_magam
end type

type cb_inq from w_inherite`cb_inq within w_box_magam
end type

type cb_print from w_inherite`cb_print within w_box_magam
end type

type st_1 from w_inherite`st_1 within w_box_magam
end type

type cb_can from w_inherite`cb_can within w_box_magam
end type

type cb_search from w_inherite`cb_search within w_box_magam
end type







type gb_button1 from w_inherite`gb_button1 within w_box_magam
end type

type gb_button2 from w_inherite`gb_button2 within w_box_magam
end type

type em_1 from editmask within w_box_magam
integer x = 1330
integer y = 1104
integer width = 795
integer height = 156
integer taborder = 100
boolean bringtotop = true
integer textsize = -20
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 128
long backcolor = 16777215
string text = "none"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "yyyy년mm월"
end type

type st_2 from statictext within w_box_magam
integer x = 2117
integer y = 1104
integer width = 1161
integer height = 156
boolean bringtotop = true
integer textsize = -20
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 32106727
string text = "자료를 마감 합니다."
alignment alignment = center!
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_box_magam
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 1234
integer y = 796
integer width = 2149
integer height = 604
integer cornerheight = 40
integer cornerwidth = 55
end type

