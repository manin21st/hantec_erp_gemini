$PBExportHeader$w_pig5010b.srw
$PBExportComments$교육계획 등록-자료 복사
forward
global type w_pig5010b from window
end type
type dw_2 from datawindow within w_pig5010b
end type
type p_5 from uo_picture within w_pig5010b
end type
type p_4 from uo_picture within w_pig5010b
end type
type p_3 from uo_picture within w_pig5010b
end type
type p_2 from uo_picture within w_pig5010b
end type
type p_1 from uo_picture within w_pig5010b
end type
type dw_1 from u_d_popup_sort within w_pig5010b
end type
type rr_2 from roundrectangle within w_pig5010b
end type
end forward

global type w_pig5010b from window
integer x = 1294
integer y = 160
integer width = 4050
integer height = 2008
boolean titlebar = true
string title = "교육계획 선택"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
dw_2 dw_2
p_5 p_5
p_4 p_4
p_3 p_3
p_2 p_2
p_1 p_1
dw_1 dw_1
rr_2 rr_2
end type
global w_pig5010b w_pig5010b

type variables
str_edu  istr_edu
end variables

on w_pig5010b.create
this.dw_2=create dw_2
this.p_5=create p_5
this.p_4=create p_4
this.p_3=create p_3
this.p_2=create p_2
this.p_1=create p_1
this.dw_1=create dw_1
this.rr_2=create rr_2
this.Control[]={this.dw_2,&
this.p_5,&
this.p_4,&
this.p_3,&
this.p_2,&
this.p_1,&
this.dw_1,&
this.rr_2}
end on

on w_pig5010b.destroy
destroy(this.dw_2)
destroy(this.p_5)
destroy(this.p_4)
destroy(this.p_3)
destroy(this.p_2)
destroy(this.p_1)
destroy(this.dw_1)
destroy(this.rr_2)
end on

event open;
f_Window_Center_Response(This)

string sgbn, ls_empname

istr_edu = Message.PowerObjectParm

dw_2.SetTransObject(SQLCA)
dw_2.Reset()
dw_2.InsertRow(0)
dw_2.SetItem(1,"ekind",    istr_edu.str_egubn)
dw_2.SetItem(1,"deptcode", istr_edu.str_dept)
dw_2.SetItem(1,"eduyear",  istr_edu.str_eduyear)

dw_1.SetTransObject(SQLCA)

dw_1.Retrieve(Gs_Company,istr_edu.str_dept,istr_edu.str_egubn,istr_edu.str_eduyear)
end event

event key;choose case key
	case keypageup!
		dw_1.scrollpriorpage()
	case keypagedown!
		dw_1.scrollnextpage()
	case keyhome!
		dw_1.scrolltorow(1)
	case keyend!
		dw_1.scrolltorow(dw_1.rowcount())
end choose
end event

type dw_2 from datawindow within w_pig5010b
integer x = 37
integer y = 8
integer width = 2766
integer height = 136
integer taborder = 10
string title = "none"
string dataobject = "d_pig5010b1"
boolean border = false
boolean livescroll = true
end type

type p_5 from uo_picture within w_pig5010b
integer x = 3840
integer width = 178
boolean originalsize = true
string picturename = "C:\Erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;SetNull(istr_edu.str_empno)
SetNull(istr_edu.str_eduyear)
SetNull(istr_edu.str_empseq)
SetNull(istr_edu.str_gbn)

istr_edu.str_flag = '0'
Closewithreturn(Parent, istr_edu)

end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

type p_4 from uo_picture within w_pig5010b
boolean visible = false
integer x = 2930
integer width = 178
boolean originalsize = true
string picturename = "C:\Erpman\image\조회_up.gif"
end type

event clicked;//String ls_empno, ls_eduyear, ls_gbn
//long ll_seq1, ll_seq2, ls_empseq
//
////ls_empno = sle_empno.text      // 사원번호
//ls_eduyear = trim(em_year.text) +'%'  // 계획년도
//ls_empseq = long(trim(em_seq.text))
//ls_gbn = istr_edu.str_gbn
//
////if ls_empno = '' or IsNull(ls_empno) then ls_empno = '%'
//if IsNull(ls_empseq) or ls_empseq = 0 then
//	ll_seq1 = 1
//	ll_seq2 = 9999
//else
//	ll_seq1 = ls_empseq
//	ll_seq2 = ls_empseq
//end if
//
//IF dw_1.Retrieve(gs_code, '999999' , ls_eduyear, ll_seq1, ll_seq2) <=0 THEN
//	MessageBox("확 인", "검색된 자료가 존재하지 ~r않습니다.!!")
//	Return
//END IF
//
//dw_1.SelectRow(0,False)
//dw_1.SelectRow(1,True)
//dw_1.ScrollToRow(1)
//dw_1.SetFocus()
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

type p_3 from uo_picture within w_pig5010b
integer x = 338
integer y = 1936
end type

type p_2 from uo_picture within w_pig5010b
integer x = 338
integer y = 1936
end type

type p_1 from uo_picture within w_pig5010b
integer x = 3666
integer width = 178
boolean originalsize = true
string picturename = "C:\Erpman\image\선택_up.gif"
end type

event clicked;call super::clicked;Long ll_row	

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. ~r 다시 선택한후 선택버튼을 누르십시오 !!")
   return
END IF

istr_edu.str_eduyear   = dw_1.GetItemString(ll_Row,"eduyear")
istr_edu.str_empseq    = dw_1.GetItemNumber(ll_Row,"empseq")
istr_edu.str_empno     = dw_1.GetItemString(ll_Row,"empno")
istr_edu.str_sdate     = dw_1.GetItemString(ll_Row,"restartdate")
istr_edu.str_edate     = dw_1.GetItemString(ll_Row,"reenddate")

istr_edu.str_empname   = dw_1.GetItemString(ll_Row,"empname")
istr_edu.str_egubn     = dw_1.GetItemString(ll_Row,"ekind")
istr_edu.str_gbn       = dw_1.GetItemString(ll_Row,"egubn")
istr_edu.str_dept		  = dw_1.GetItemString(ll_Row,"deptcode")

istr_edu.str_flag = '1'

Closewithreturn(Parent, istr_edu)
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\선택_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\선택_dn.gif"
end event

type dw_1 from u_d_popup_sort within w_pig5010b
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 64
integer y = 168
integer width = 3927
integer height = 1680
integer taborder = 20
string dataobject = "d_pig5010b2"
boolean vscrollbar = true
boolean border = false
end type

event ue_pressenter;
p_1.TriggerEvent(Clicked!)
end event

event ue_key;choose case key
	case keypageup!
		dw_1.scrollpriorpage()
	case keypagedown!
		dw_1.scrollnextpage()
	case keyhome!
		dw_1.scrolltorow(1)
	case keyend!
		dw_1.scrolltorow(dw_1.rowcount())
end choose
end event

event rowfocuschanged;
dw_1.SelectRow(0,False)
dw_1.SelectRow(currentrow,True)

dw_1.ScrollToRow(currentrow)
end event

event clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag = False

END IF

CALL SUPER ::CLICKED


end event

event doubleclicked;IF Row = 0 THEN
   MessageBox("확 인", "선택값이 없습니다. ~r다시 선택한후 ok 버튼을 누르십시오 !")
   return
END IF

istr_edu.str_eduyear   = dw_1.GetItemString(row,"eduyear")
istr_edu.str_empseq    = dw_1.GetItemNumber(row,"empseq")
istr_edu.str_empno     = dw_1.GetItemString(row,"empno")
istr_edu.str_sdate     = dw_1.GetItemString(row,"restartdate")
istr_edu.str_edate     = dw_1.GetItemString(row,"reenddate")

istr_edu.str_empname   = dw_1.GetItemString(row,"empname")
istr_edu.str_egubn     = dw_1.GetItemString(row,"ekind")
istr_edu.str_gbn       = dw_1.GetItemString(row,"egubn")
istr_edu.str_dept		  = dw_1.GetItemString(row,"deptcode")

istr_edu.str_flag = '1'

Closewithreturn(Parent, istr_edu)

end event

type rr_2 from roundrectangle within w_pig5010b
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 156
integer width = 3954
integer height = 1708
integer cornerheight = 40
integer cornerwidth = 55
end type

