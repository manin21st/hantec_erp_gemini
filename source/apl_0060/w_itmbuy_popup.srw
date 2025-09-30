$PBExportHeader$w_itmbuy_popup.srw
$PBExportComments$** 거래처 관리품목 조회 선택
forward
global type w_itmbuy_popup from w_inherite_popup
end type
type dw_2 from datawindow within w_itmbuy_popup
end type
type rr_1 from roundrectangle within w_itmbuy_popup
end type
end forward

global type w_itmbuy_popup from w_inherite_popup
integer x = 169
integer y = 588
integer width = 3442
integer height = 1840
string title = "관리 품목 조회 선택"
dw_2 dw_2
rr_1 rr_1
end type
global w_itmbuy_popup w_itmbuy_popup

on w_itmbuy_popup.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.rr_1
end on

on w_itmbuy_popup.destroy
call super::destroy
destroy(this.dw_2)
destroy(this.rr_1)
end on

event open;call super::open;string sitdsc, sispec, sjijil, scvnas
  
SELECT "ITDSC", "ISPEC", "JIJIL"  
  INTO :sitdsc, :sispec, :sjijil
  FROM "ITEMAS"  
 WHERE "ITNBR" = :gs_code   ;

SELECT CVNAS2 
  INTO :scvnas
  FROM VNDMST
 WHERE CVCOD = :gs_codename ;

dw_2.insertrow(0)
dw_2.setitem(1, 'cvcod', gs_codename)
dw_2.setitem(1, 'cvnas', scvnas)
dw_2.setitem(1, 'itnbr', gs_code)
dw_2.setitem(1, 'itdsc', sitdsc)
dw_2.setitem(1, 'ispec', sispec)
dw_2.setitem(1, 'jijil', sjijil)

dw_1.Retrieve(gs_code, gs_codename)
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_itmbuy_popup
boolean visible = false
integer x = 151
integer y = 1184
integer taborder = 0
end type

type p_exit from w_inherite_popup`p_exit within w_itmbuy_popup
integer x = 3237
integer y = 12
end type

event p_exit::clicked;call super::clicked;
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_itmbuy_popup
boolean visible = false
integer x = 2898
integer y = 12
end type

type p_choose from w_inherite_popup`p_choose within w_itmbuy_popup
integer x = 3063
integer y = 12
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code = string(dw_1.GetItemNumber(ll_Row, "itmbuy_seqno")) 

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_itmbuy_popup
integer x = 59
integer y = 188
integer width = 3346
integer height = 1548
integer taborder = 10
string dataobject = "d_itmbuy_popup"
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

event dw_1::doubleclicked;IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return

END IF

gs_code = string(dw_1.GetItemNumber(Row, "itmbuy_seqno"))

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_itmbuy_popup
boolean visible = false
end type

type cb_1 from w_inherite_popup`cb_1 within w_itmbuy_popup
integer x = 1317
integer y = 1620
end type

type cb_return from w_inherite_popup`cb_return within w_itmbuy_popup
integer x = 1637
integer y = 1628
end type

type cb_inq from w_inherite_popup`cb_inq within w_itmbuy_popup
integer x = 1074
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_itmbuy_popup
boolean visible = false
end type

type st_1 from w_inherite_popup`st_1 within w_itmbuy_popup
boolean visible = false
end type

type dw_2 from datawindow within w_itmbuy_popup
integer x = 37
integer width = 2793
integer height = 176
boolean bringtotop = true
string dataobject = "d_itmbuy_popup1"
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_itmbuy_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 184
integer width = 3378
integer height = 1564
integer cornerheight = 40
integer cornerwidth = 55
end type

