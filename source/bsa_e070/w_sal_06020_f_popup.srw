$PBExportHeader$w_sal_06020_f_popup.srw
$PBExportComments$P/I 등록(Fuso) Popup
forward
global type w_sal_06020_f_popup from w_inherite_popup
end type
type rr_2 from roundrectangle within w_sal_06020_f_popup
end type
end forward

global type w_sal_06020_f_popup from w_inherite_popup
integer height = 1912
rr_2 rr_2
end type
global w_sal_06020_f_popup w_sal_06020_f_popup

type variables
str_code istr_code
end variables

on w_sal_06020_f_popup.create
int iCurrent
call super::create
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
end on

on w_sal_06020_f_popup.destroy
call super::destroy
destroy(this.rr_2)
end on

event open;call super::open;Long i

string sItnbr

sItnbr = gs_code
SetNull(gs_code)

For i=1 To UpperBound(istr_code.code)
	SetNull(istr_code.code[i])
	SetNull(istr_code.codename[i])
	SetNull(istr_code.dgubun1[i])
	SetNull(istr_code.dgubun2[i])
Next

dw_1.Retrieve(sItnbr)
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_sal_06020_f_popup
boolean visible = false
integer x = 9
integer y = 20
integer width = 709
end type

type p_exit from w_inherite_popup`p_exit within w_sal_06020_f_popup
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Long i

For i=1 To UpperBound(istr_code.code)
	SetNull(istr_code.code[i])
	SetNull(istr_code.codename[i])
	SetNull(istr_code.dgubun1[i])
	SetNull(istr_code.dgubun2[i])
Next

CloseWithReturn(Parent,istr_code)
end event

type p_inq from w_inherite_popup`p_inq within w_sal_06020_f_popup
boolean visible = false
end type

type p_choose from w_inherite_popup`p_choose within w_sal_06020_f_popup
end type

event p_choose::clicked;call super::clicked;Long ll_row , i , ii=0

ll_Row = dw_1.RowCount()

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

For i = 1 To ll_row
	If dw_1.Object.is_check[i] = 'Y' Then
		ii++
		
		istr_code.code[ii]     = dw_1.Object.pono[i]
		istr_code.dgubun1[ii] = dw_1.Object.poseq[i]
		istr_code.dgubun2[ii]  = dw_1.Object.jan_qty[i]
	End If
Next

CloseWithReturn(Parent , istr_code)
end event

type dw_1 from w_inherite_popup`dw_1 within w_sal_06020_f_popup
integer y = 200
string dataobject = "d_sal_06020_f_popup"
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

event dw_1::doubleclicked;call super::doubleclicked;IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

istr_code.code[1]     = dw_1.Object.pono[Row]
istr_code.dgubun1[1]  = dw_1.Object.poseq[Row]
istr_code.dgubun2[1]  = dw_1.Object.jan_qty[Row]

CloseWithReturn(Parent , istr_code)
end event

type sle_2 from w_inherite_popup`sle_2 within w_sal_06020_f_popup
end type

type cb_1 from w_inherite_popup`cb_1 within w_sal_06020_f_popup
end type

type cb_return from w_inherite_popup`cb_return within w_sal_06020_f_popup
end type

type cb_inq from w_inherite_popup`cb_inq within w_sal_06020_f_popup
end type

type sle_1 from w_inherite_popup`sle_1 within w_sal_06020_f_popup
end type

type st_1 from w_inherite_popup`st_1 within w_sal_06020_f_popup
end type

type rr_2 from roundrectangle within w_sal_06020_f_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 192
integer width = 2254
integer height = 1596
integer cornerheight = 40
integer cornerwidth = 55
end type

