$PBExportHeader$w_ittyp_popup.srw
$PBExportComments$** 분류코드 조회 선택(F1 KEY)
forward
global type w_ittyp_popup from w_inherite_popup
end type
type rr_1 from roundrectangle within w_ittyp_popup
end type
end forward

global type w_ittyp_popup from w_inherite_popup
integer x = 581
integer y = 188
integer width = 2985
integer height = 1824
string title = "분류코드 조회"
rr_1 rr_1
end type
global w_ittyp_popup w_ittyp_popup

on w_ittyp_popup.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_ittyp_popup.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;string s_code, s_pdtgu, ls_porgu

dw_jogun.SetTransObject(SQLCA)
dw_jogun.Reset()
dw_jogun.InsertRow(0)

setnull(gs_code)
f_mod_saupj(dw_jogun, 'porgu')

s_code  	= Message.StringParm	
s_pdtgu 	= gs_gubun
ls_porgu	= dw_jogun.GetItemString(1,'porgu')

if 	isnull(s_code) or s_code = "" then 
	s_code = '%' 
else 
	dw_jogun.setitem(1, 'ittyp', s_code)
end if

if 	isnull(s_pdtgu) or s_pdtgu = "" then 
	s_pdtgu = '%' 
else 
	dw_jogun.setitem(1, 'pdtgu', s_pdtgu)
end if
	
dw_1.Retrieve(ls_porgu, s_code, s_pdtgu)

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_ittyp_popup
integer x = 14
integer y = 60
integer width = 1970
integer height = 172
string dataobject = "d_ittyp_popup_a"
end type

event dw_jogun::itemchanged;call super::itemchanged;p_inq.TriggerEvent(Clicked!)
end event

type p_exit from w_inherite_popup`p_exit within w_ittyp_popup
integer x = 2779
integer y = 12
end type

event p_exit::clicked;call super::clicked;str_itnct str_sitnct

setnull(str_sitnct.s_ittyp)

CloseWithReturn(Parent, str_sitnct)
end event

type p_inq from w_inherite_popup`p_inq within w_ittyp_popup
integer x = 2432
integer y = 12
end type

event p_inq::clicked;call super::clicked;String sgu, spdtgu, ls_porgu

if 	dw_jogun.acceptText() = -1 then return 

sgu   	= dw_jogun.GetItemString(1,'ittyp')
spdtgu 	= dw_jogun.GetItemString(1,'pdtgu')
ls_porgu = dw_jogun.GetItemString(1,'porgu')

IF sgu ="" OR IsNull(sgu) THEN sgu ='%'
IF spdtgu ="" OR IsNull(spdtgu) THEN spdtgu ='%'

IF dw_1.Retrieve(sgu, ls_porgu, spdtgu) <= 0 THEN
	f_message_chk(50,'')
	Return
END IF

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()

end event

type p_choose from w_inherite_popup`p_choose within w_ittyp_popup
integer x = 2606
integer y = 12
end type

event p_choose::clicked;call super::clicked;String slag, smid, smal
Long ll_row, lseq
str_itnct str_sitnct

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

str_sitnct.s_ittyp			= dw_1.GetItemString(ll_Row, "ittyp")
str_sitnct.s_sumgub 	= dw_1.GetItemString(ll_Row,"itcls")
str_sitnct.l_seqno 		= dw_1.GetItemNumber(ll_Row,"seq")
str_sitnct.s_titnm 		= dw_1.GetItemString(ll_Row,"titnm")

CloseWithReturn(Parent, str_sitnct)

end event

type dw_1 from w_inherite_popup`dw_1 within w_ittyp_popup
integer x = 27
integer y = 288
integer width = 2926
integer height = 1432
integer taborder = 40
string dataobject = "d_ittyp_popup"
end type

event dw_1::clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

event dw_1::doubleclicked;string slag, smid, smal
long   lseq
str_itnct str_sitnct

IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

str_sitnct.s_ittyp= dw_1.GetItemString(Row, "ittyp")
str_sitnct.s_sumgub = dw_1.GetItemString(Row,"itcls")

str_sitnct.l_seqno = dw_1.GetItemNumber(Row,"seq")
str_sitnct.s_titnm = dw_1.GetItemString(Row,"titnm")

CloseWithReturn(Parent, str_sitnct)

end event

type sle_2 from w_inherite_popup`sle_2 within w_ittyp_popup
boolean visible = false
integer x = 681
integer y = 1828
integer width = 581
integer taborder = 30
end type

type cb_1 from w_inherite_popup`cb_1 within w_ittyp_popup
integer x = 1152
integer y = 1860
integer taborder = 50
end type

type cb_return from w_inherite_popup`cb_return within w_ittyp_popup
integer x = 1783
integer y = 1860
integer taborder = 70
end type

type cb_inq from w_inherite_popup`cb_inq within w_ittyp_popup
integer x = 1467
integer y = 1860
integer height = 72
integer taborder = 60
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_ittyp_popup
boolean visible = false
integer x = 439
integer y = 1828
integer width = 238
integer taborder = 20
integer limit = 7
end type

type st_1 from w_inherite_popup`st_1 within w_ittyp_popup
integer x = 169
integer y = 1824
integer width = 256
string text = "품목분류"
alignment alignment = left!
end type

type rr_1 from roundrectangle within w_ittyp_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 272
integer width = 2944
integer height = 1460
integer cornerheight = 40
integer cornerwidth = 55
end type

