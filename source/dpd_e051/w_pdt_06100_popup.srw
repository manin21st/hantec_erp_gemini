$PBExportHeader$w_pdt_06100_popup.srw
$PBExportComments$설비점검 기준자료 조회선택
forward
global type w_pdt_06100_popup from w_inherite_popup
end type
type rr_1 from roundrectangle within w_pdt_06100_popup
end type
end forward

global type w_pdt_06100_popup from w_inherite_popup
integer x = 663
integer y = 136
integer width = 3241
integer height = 1932
string title = "설비점검 기준자료 조회선택"
rr_1 rr_1
end type
global w_pdt_06100_popup w_pdt_06100_popup

type variables
string  is_code , is_codename 
end variables

on w_pdt_06100_popup.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdt_06100_popup.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;is_code = gs_code

sle_1.text = is_code

if IsNull(is_code) or is_code = "" then 
     dw_1.retrieve( gs_sabu, '%', '%')
else
     dw_1.retrieve( gs_sabu, is_code, '%' )
end if
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_pdt_06100_popup
integer x = 91
integer y = 5000
end type

type p_exit from w_inherite_popup`p_exit within w_pdt_06100_popup
integer x = 3008
integer y = 24
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_pdt_06100_popup
integer x = 2661
integer y = 24
end type

event p_inq::clicked;call super::clicked;string sdate, edate, scode ,sname

scode = trim(sle_1.text)
sname = trim(sle_2.text)

IF IsNull(scode) or scode = "" THEN 
	scode = '%'
ELSE
	scode = scode + '%'
END IF
	
IF IsNull(sname) OR sname = "" THEN 
	sName = '%'
ELSE
	sName = sname + '%'
END IF
	
dw_1.Retrieve(gs_sabu, scode, sname)
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type p_choose from w_inherite_popup`p_choose within w_pdt_06100_popup
integer x = 2834
integer y = 24
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code     = dw_1.GetItemString(ll_Row, "mchno")
gs_codename = dw_1.GetItemString(ll_Row, "mchnam")
gi_page     = dw_1.GetItemnumber(ll_Row, "seq")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_pdt_06100_popup
integer x = 50
integer y = 200
integer width = 3109
integer height = 1612
string dataobject = "d_pdt_06100_popup"
end type

event dw_1::clicked;call super::clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag = False
END IF

CALL SUPER ::CLICKED

end event

event dw_1::doubleclicked;IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code     = dw_1.GetItemString(Row, "mchno")
gs_codename = dw_1.GetItemString(Row, "mchnam")
gi_page     = dw_1.GetItemnumber(row, "seq")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_pdt_06100_popup
integer x = 558
end type

type cb_1 from w_inherite_popup`cb_1 within w_pdt_06100_popup
integer x = 1687
integer y = 5000
end type

type cb_return from w_inherite_popup`cb_return within w_pdt_06100_popup
integer x = 2322
integer y = 5000
end type

type cb_inq from w_inherite_popup`cb_inq within w_pdt_06100_popup
integer x = 2002
integer y = 5000
end type

type sle_1 from w_inherite_popup`sle_1 within w_pdt_06100_popup
integer width = 242
integer limit = 6
end type

type st_1 from w_inherite_popup`st_1 within w_pdt_06100_popup
long textcolor = 128
long backcolor = 12632256
string text = "설 비 :"
end type

type rr_1 from roundrectangle within w_pdt_06100_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 188
integer width = 3163
integer height = 1640
integer cornerheight = 40
integer cornerwidth = 55
end type

