$PBExportHeader$w_ittyp_popup4.srw
$PBExportComments$** ��/��/�� �з��ڵ� ��ȸ ����(F1 KEY)
forward
global type w_ittyp_popup4 from w_inherite_popup
end type
type rr_1 from roundrectangle within w_ittyp_popup4
end type
end forward

global type w_ittyp_popup4 from w_inherite_popup
integer x = 581
integer y = 188
integer width = 3003
integer height = 1836
string title = "�з��ڵ� ��ȸ"
rr_1 rr_1
end type
global w_ittyp_popup4 w_ittyp_popup4

on w_ittyp_popup4.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_ittyp_popup4.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;string s_code, s_pdtgu, ls_porgu

dw_jogun.SetTransObject(SQLCA)
dw_jogun.Reset()
dw_jogun.InsertRow(0)

s_code  	= Message.StringParm	
s_pdtgu 	= gs_gubun
ls_porgu	= '%' 

if isnull(s_code) or s_code = "" then 
	s_code = '%' 
else 
	dw_jogun.setitem(1, 'ittyp', s_code)
end if
if isnull(s_pdtgu) or s_pdtgu = "" then 
	s_pdtgu = '%' 
else 
	dw_jogun.setitem(1, 'pdtgu', s_pdtgu)
end if
	
dw_1.Retrieve(s_code, s_pdtgu, ls_porgu)

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()

setnull(gs_code)
f_mod_saupj(dw_jogun, 'porgu')
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_ittyp_popup4
integer x = 23
integer y = 32
integer width = 2011
integer height = 240
string dataobject = "d_ittyp_popup_a"
end type

type p_exit from w_inherite_popup`p_exit within w_ittyp_popup4
integer x = 2793
integer y = 24
end type

event p_exit::clicked;call super::clicked;str_itnct str_sitnct

setnull(str_sitnct.s_ittyp)

CloseWithReturn(Parent, str_sitnct)
end event

type p_inq from w_inherite_popup`p_inq within w_ittyp_popup4
integer x = 2446
integer y = 24
end type

event p_inq::clicked;call super::clicked;String sgu, spdtgu, ls_porgu

if dw_jogun.acceptText() = -1 then return 

sgu    	= dw_jogun.GetItemString(1,'ittyp')
spdtgu 	= dw_jogun.GetItemString(1,'pdtgu')
ls_porgu = dw_jogun.GetItemString(1,'porgu')

IF sgu ="" OR IsNull(sgu) THEN sgu ='%'
IF spdtgu ="" OR IsNull(spdtgu) THEN spdtgu ='%'

IF dw_1.Retrieve(sgu, spdtgu, ls_porgu) <= 0 THEN
	f_message_chk(50,'')
	Return
END IF

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()

end event

type p_choose from w_inherite_popup`p_choose within w_ittyp_popup4
integer x = 2619
integer y = 24
end type

event p_choose::clicked;call super::clicked;String slag, smid, smal
Long ll_row, lseq
str_itnct str_sitnct

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

str_sitnct.s_ittyp= dw_1.GetItemString(ll_Row, "ittyp")
str_sitnct.s_sumgub = dw_1.GetItemString(ll_Row,"itcls")
str_sitnct.l_seqno = dw_1.GetItemNumber(ll_Row,"seq")
str_sitnct.s_titnm = dw_1.GetItemString(ll_Row,"titnm")

CloseWithReturn(Parent, str_sitnct)

end event

type dw_1 from w_inherite_popup`dw_1 within w_ittyp_popup4
integer x = 41
integer y = 300
integer width = 2926
integer height = 1424
integer taborder = 40
string dataobject = "d_ittyp_popup4"
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
   MessageBox("Ȯ ��", "���ð��� �����ϴ�. �ٽ� �������� ���ù�ư�� �����ʽÿ� !")
   return
END IF

str_sitnct.s_ittyp= dw_1.GetItemString(Row, "ittyp")
str_sitnct.s_sumgub = dw_1.GetItemString(Row,"itcls")

str_sitnct.l_seqno = dw_1.GetItemNumber(Row,"seq")
str_sitnct.s_titnm = dw_1.GetItemString(Row,"titnm")

CloseWithReturn(Parent, str_sitnct)

end event

type sle_2 from w_inherite_popup`sle_2 within w_ittyp_popup4
integer x = 311
integer y = 1844
integer width = 608
integer taborder = 30
end type

type cb_1 from w_inherite_popup`cb_1 within w_ittyp_popup4
integer x = 192
integer y = 1888
integer taborder = 50
end type

type cb_return from w_inherite_popup`cb_return within w_ittyp_popup4
integer x = 823
integer y = 1888
integer taborder = 70
end type

type cb_inq from w_inherite_popup`cb_inq within w_ittyp_popup4
integer x = 507
integer y = 1888
integer taborder = 60
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_ittyp_popup4
integer x = 960
integer y = 1872
integer width = 210
integer taborder = 20
integer limit = 7
end type

type st_1 from w_inherite_popup`st_1 within w_ittyp_popup4
integer x = 2592
integer y = 36
integer width = 256
string text = "ǰ��з�"
alignment alignment = left!
end type

type rr_1 from roundrectangle within w_ittyp_popup4
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 284
integer width = 2958
integer height = 1456
integer cornerheight = 40
integer cornerwidth = 55
end type

