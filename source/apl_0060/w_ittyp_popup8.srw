$PBExportHeader$w_ittyp_popup8.srw
$PBExportComments$** ��/�ߺз� �ڵ� ��ȸ ����(F1 KEY) - Ư�� ǰ�񱸺� ����
forward
global type w_ittyp_popup8 from w_inherite_popup
end type
type rr_1 from roundrectangle within w_ittyp_popup8
end type
end forward

global type w_ittyp_popup8 from w_inherite_popup
integer x = 581
integer y = 188
integer width = 2999
integer height = 1816
string title = "��/�ߺз� �ڵ� ��ȸ"
rr_1 rr_1
end type
global w_ittyp_popup8 w_ittyp_popup8

on w_ittyp_popup8.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_ittyp_popup8.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;string s_code

dw_jogun.SetTransObject(SQLCA)
dw_jogun.Reset()
dw_jogun.InsertRow(0)

s_code = Message.StringParm	

if isnull(s_code) or s_code = "" then s_code = '1'

dw_jogun.setitem(1, 'ittyp', s_code)
dw_1.Retrieve(s_code)

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()

end event

type dw_jogun from w_inherite_popup`dw_jogun within w_ittyp_popup8
integer x = 14
integer y = 24
integer width = 1243
string dataobject = "d_ittyp_popup9"
end type

type p_exit from w_inherite_popup`p_exit within w_ittyp_popup8
integer x = 2789
integer y = 16
end type

event p_exit::clicked;call super::clicked;str_itnct str_sitnct

setnull(str_sitnct.s_ittyp)

CloseWithReturn(Parent, str_sitnct)
end event

type p_inq from w_inherite_popup`p_inq within w_ittyp_popup8
integer x = 2441
integer y = 16
end type

event p_inq::clicked;call super::clicked;String sgu, sname, scode, sfilter

dw_jogun.acceptText()

sgu = dw_jogun.GetItemString(1,'ittyp')

IF sgu ="" OR IsNull(sgu) THEN sgu ='1'

scode  = trim(sle_1.text)
sname  = trim(sle_2.text)

IF IsNull(scode)  THEN 
	scode = ""
ELSEIF scode = "" THEN
	scode = ""
ELSE
	scode = scode + '%'
END IF	
	
IF IsNull(sname)  THEN 
	sname = ""
ELSEIF sname = "" THEN
	sname = ""
ELSE
	sname = sname + '%'
END IF	

IF scode = "" and sname = "" THEN
	sfilter = ""
ELSEIF scode <> "" and sname = "" THEN
	sfilter = "( itcls like '"+ scode +"') "
ELSEIF scode = "" and sname <> "" THEN
	sfilter = "( titnm like '"+ sname +"') "
ELSE		 
	sfilter = "( itcls like '"+ scode +"') and ( titnm like '"+ sname +"') "
END IF
dw_1.SetFilter(sfilter)
dw_1.Filter()

IF dw_1.Retrieve(sgu) <= 0 THEN
	f_message_chk(50,'')
	Return
END IF

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type p_choose from w_inherite_popup`p_choose within w_ittyp_popup8
integer x = 2615
integer y = 16
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

type dw_1 from w_inherite_popup`dw_1 within w_ittyp_popup8
integer x = 37
integer y = 192
integer width = 2926
integer height = 1516
integer taborder = 30
string dataobject = "d_ittyp_popup8"
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

type sle_2 from w_inherite_popup`sle_2 within w_ittyp_popup8
integer x = 1957
integer width = 905
end type

type cb_1 from w_inherite_popup`cb_1 within w_ittyp_popup8
integer x = 1376
integer y = 1892
integer taborder = 40
end type

type cb_return from w_inherite_popup`cb_return within w_ittyp_popup8
integer x = 2007
integer y = 1892
integer taborder = 60
end type

type cb_inq from w_inherite_popup`cb_inq within w_ittyp_popup8
integer x = 1691
integer y = 1892
integer taborder = 50
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_ittyp_popup8
integer x = 1710
integer width = 242
integer limit = 7
end type

type st_1 from w_inherite_popup`st_1 within w_ittyp_popup8
integer x = 1435
integer width = 256
integer height = 60
string text = "ǰ��з�"
alignment alignment = left!
end type

type rr_1 from roundrectangle within w_ittyp_popup8
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 188
integer width = 2944
integer height = 1528
integer cornerheight = 40
integer cornerwidth = 55
end type

