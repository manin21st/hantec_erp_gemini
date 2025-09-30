$PBExportHeader$w_mittyp_popup.srw
$PBExportComments$설비/계측기  대/중/소 분류코드 조회 popup
forward
global type w_mittyp_popup from w_inherite_popup
end type
type dw_2 from datawindow within w_mittyp_popup
end type
type rr_1 from roundrectangle within w_mittyp_popup
end type
type ln_1 from line within w_mittyp_popup
end type
type ln_2 from line within w_mittyp_popup
end type
type rr_2 from roundrectangle within w_mittyp_popup
end type
end forward

global type w_mittyp_popup from w_inherite_popup
integer x = 581
integer y = 188
integer width = 2505
integer height = 1908
string title = "설비/계측기 분류코드 조회(출력물)"
dw_2 dw_2
rr_1 rr_1
ln_1 ln_1
ln_2 ln_2
rr_2 rr_2
end type
global w_mittyp_popup w_mittyp_popup

on w_mittyp_popup.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.rr_1=create rr_1
this.ln_1=create ln_1
this.ln_2=create ln_2
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.rr_1
this.Control[iCurrent+3]=this.ln_1
this.Control[iCurrent+4]=this.ln_2
this.Control[iCurrent+5]=this.rr_2
end on

on w_mittyp_popup.destroy
call super::destroy
destroy(this.dw_2)
destroy(this.rr_1)
destroy(this.ln_1)
destroy(this.ln_2)
destroy(this.rr_2)
end on

event open;call super::open;string s_code

dw_2.SetTransObject(SQLCA)
dw_2.Reset()
dw_2.InsertRow(0)

s_code = gs_gubun

if isnull(s_code) or s_code = "" then
	dw_1.Retrieve('%')
	dw_1.SelectRow(0,False)
	dw_1.SelectRow(1,True)
	dw_1.ScrollToRow(1)
	dw_1.SetFocus()
else
   dw_2.setitem(1, 'kegbn', s_code)
	dw_1.Retrieve(s_code)

//	dw_2.settaborder('kegbn', 0)
//	dw_2.object.kegbn.Background.Color = 79741120
	
	dw_1.SelectRow(0,False)
	dw_1.SelectRow(1,True)
	dw_1.ScrollToRow(1)
	dw_1.SetFocus()
end if	

end event

type dw_jogun from w_inherite_popup`dw_jogun within w_mittyp_popup
integer x = 0
integer y = 5000
end type

type p_exit from w_inherite_popup`p_exit within w_mittyp_popup
integer x = 2286
end type

event p_exit::clicked;call super::clicked;Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_mittyp_popup
integer x = 1938
end type

event p_inq::clicked;call super::clicked;String sgu, scode, sname, sfilter

dw_2.acceptText()

sgu = dw_2.GetItemString(1,'kegbn')

IF sgu ="" OR IsNull(sgu) THEN sgu ='%'

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
	sfilter = "( buncd like '"+ scode +"') "
ELSEIF scode = "" and sname <> "" THEN
	sfilter = "( bunnam like '"+ sname +"') "
ELSE		 
	sfilter = "( buncd like '"+ scode +"') and ( bunnam like '"+ sname +"') "
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

type p_choose from w_inherite_popup`p_choose within w_mittyp_popup
integer x = 2112
end type

event p_choose::clicked;call super::clicked;String slag, smid, smal
Long ll_row, lseq

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code    = dw_1.GetItemString(ll_Row,"buncd")
gs_codename= dw_1.GetItemString(ll_Row,"bunnam")
gs_gubun	= dw_1.GetItemString(ll_Row,"lmsgu")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_mittyp_popup
integer x = 64
integer y = 352
integer width = 2377
integer height = 1452
integer taborder = 40
string dataobject = "d_mittyp_popup"
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

IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF


gs_code = dw_1.GetItemString(Row,"buncd")
gs_codename = dw_1.GetItemString(Row,"bunnam")
gs_gubun = dw_1.GetItemString(Row,"lmsgu")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_mittyp_popup
integer x = 1230
integer y = 220
integer width = 955
integer height = 68
integer taborder = 30
end type

type cb_1 from w_inherite_popup`cb_1 within w_mittyp_popup
integer x = 1815
integer y = 5000
integer taborder = 50
end type

type cb_return from w_inherite_popup`cb_return within w_mittyp_popup
integer x = 2446
integer y = 5000
integer taborder = 70
end type

type cb_inq from w_inherite_popup`cb_inq within w_mittyp_popup
integer x = 2130
integer y = 5000
integer taborder = 60
end type

event cb_inq::clicked;call super::clicked;String sgu, scode, sname, sfilter

dw_2.acceptText()

sgu = dw_2.GetItemString(1,'kegbn')

IF sgu ="" OR IsNull(sgu) THEN sgu ='%'

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
	sfilter = "( buncd like '"+ scode +"') "
ELSEIF scode = "" and sname <> "" THEN
	sfilter = "( bunnam like '"+ sname +"') "
ELSE		 
	sfilter = "( buncd like '"+ scode +"') and ( bunnam like '"+ sname +"') "
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

type sle_1 from w_inherite_popup`sle_1 within w_mittyp_popup
integer x = 891
integer y = 220
integer width = 325
integer height = 68
integer taborder = 20
integer limit = 7
end type

type st_1 from w_inherite_popup`st_1 within w_mittyp_popup
integer x = 663
integer y = 232
integer width = 256
integer weight = 400
long backcolor = 33027312
string text = "분류코드"
alignment alignment = left!
end type

type dw_2 from datawindow within w_mittyp_popup
integer x = 64
integer y = 192
integer width = 581
integer height = 132
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_mittyp_popup1"
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_mittyp_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 50
integer y = 180
integer width = 2414
integer height = 152
integer cornerheight = 40
integer cornerwidth = 55
end type

type ln_1 from line within w_mittyp_popup
integer linethickness = 1
integer beginx = 891
integer beginy = 288
integer endx = 1216
integer endy = 288
end type

type ln_2 from line within w_mittyp_popup
integer linethickness = 1
integer beginx = 1230
integer beginy = 288
integer endx = 2185
integer endy = 288
end type

type rr_2 from roundrectangle within w_mittyp_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 348
integer width = 2409
integer height = 1464
integer cornerheight = 40
integer cornerwidth = 55
end type

