$PBExportHeader$w_ittyp_popup3.srw
$PBExportComments$** 분류코드 조회 선택(F2 KEY)-중간 값 선택 가능
forward
global type w_ittyp_popup3 from w_inherite_popup
end type
type rr_1 from roundrectangle within w_ittyp_popup3
end type
end forward

global type w_ittyp_popup3 from w_inherite_popup
integer x = 2025
integer y = 188
integer width = 1385
integer height = 1948
string title = "분류코드 조회"
rr_1 rr_1
end type
global w_ittyp_popup3 w_ittyp_popup3

type variables
String  is_ittyp,  is_lag_gub, is_mid_gub
end variables

on w_ittyp_popup3.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_ittyp_popup3.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;if isnull(gs_code) or gs_code = "" then
	dw_1.DataObject ="d_ittyp_popup2"
	dw_1.SetTransObject(SQLCA)
	dw_1.Retrieve()
	dw_1.SelectRow(0,False)
	dw_1.SelectRow(1,True)
	dw_1.ScrollToRow(1)
	dw_1.SetFocus()
else
	dw_1.DataObject ="d_ittyp_popup2_1"
	dw_1.SetTransObject(SQLCA)
	dw_1.Retrieve(gs_code)
	dw_1.SelectRow(0,False)
	dw_1.SelectRow(1,True)
	dw_1.ScrollToRow(1)
	dw_1.SetFocus()
end if	

end event

type dw_jogun from w_inherite_popup`dw_jogun within w_ittyp_popup3
boolean visible = false
integer x = 233
integer y = 1944
integer width = 69
integer height = 148
boolean enabled = false
end type

type p_exit from w_inherite_popup`p_exit within w_ittyp_popup3
integer x = 1175
integer y = 24
end type

event p_exit::clicked;call super::clicked;str_itnct str_sitnct

setnull(str_sitnct.s_ittyp)

CloseWithReturn(Parent, str_sitnct)
end event

type p_inq from w_inherite_popup`p_inq within w_ittyp_popup3
boolean visible = false
integer x = 453
integer y = 1896
boolean enabled = false
end type

type p_choose from w_inherite_popup`p_choose within w_ittyp_popup3
integer x = 1001
integer y = 24
end type

event p_choose::clicked;call super::clicked;String slag, smid, smal, ssetting
Long ll_row, lseq
str_itnct str_sitnct

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

ssetting = dw_1.DataObject

if ssetting = "d_ittyp_popup2_3" then
	str_sitnct.s_ittyp= dw_1.GetItemString(ll_Row, "ittyp")
	str_sitnct.s_sumgub = dw_1.GetItemString(ll_Row,"itcls")
	str_sitnct.l_seqno = dw_1.GetItemNumber(ll_Row,"seq")
	str_sitnct.s_titnm = dw_1.GetItemString(ll_Row,"titnm")
elseif ssetting = "d_ittyp_popup2" then
	str_sitnct.s_ittyp = dw_1.GetItemString(ll_Row,"itcls")
	str_sitnct.s_sumgub = ""
else	
	str_sitnct.s_ittyp= dw_1.GetItemString(ll_Row, "ittyp")
	str_sitnct.s_sumgub = dw_1.GetItemString(ll_Row,"itcls")
	str_sitnct.s_titnm = dw_1.GetItemString(ll_Row,"titnm")
end if


CloseWithReturn(Parent, str_sitnct)

end event

type dw_1 from w_inherite_popup`dw_1 within w_ittyp_popup3
integer x = 32
integer y = 196
integer width = 1294
integer height = 1636
integer taborder = 30
string dataobject = "d_ittyp_popup2"
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

event dw_1::doubleclicked;string slag, smid, smal, ssetting
long   lseq
str_itnct str_sitnct

IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

ssetting = dw_1.DataObject

if ssetting = "d_ittyp_popup2_3" then
	str_sitnct.s_ittyp= dw_1.GetItemString(Row, "ittyp")
	str_sitnct.s_sumgub = dw_1.GetItemString(Row,"itcls")
	str_sitnct.l_seqno = dw_1.GetItemNumber(Row,"seq")
	str_sitnct.s_titnm = dw_1.GetItemString(Row,"titnm")
elseif ssetting = "d_ittyp_popup2" then
	str_sitnct.s_ittyp = dw_1.GetItemString(Row,"itcls")
	str_sitnct.s_sumgub = ""
else	
	str_sitnct.s_ittyp= dw_1.GetItemString(Row, "ittyp")
	str_sitnct.s_sumgub = dw_1.GetItemString(Row,"itcls")
	str_sitnct.s_titnm = dw_1.GetItemString(Row,"titnm")
end if

CloseWithReturn(Parent, str_sitnct)

end event

event dw_1::ue_key;string ssetting

choose case key
	case keypageup!
		dw_1.scrollpriorpage()
	case keypagedown!
		dw_1.scrollnextpage()
	case keyhome!
		dw_1.scrolltorow(1)
	case keyend!
		dw_1.scrolltorow(dw_1.rowcount())
   case KeyRightArrow!
   	  ssetting = dw_1.DataObject
		  if ssetting = "d_ittyp_popup2_3" then
			  messagebox("확 인", "분류코드 조회의 끝입니다.!!")
			  return 1
		  elseif ssetting = "d_ittyp_popup2" then
           if dw_1.rowcount() < 1 then
				  messagebox("확 인", "선택할 자료가 없습니다.!!")
				  return 1
			  end if	  
			  is_ittyp = dw_1.getitemstring(dw_1.getrow(), 'itcls') 
			  dw_1.DataObject = "d_ittyp_popup2_1"
			  dw_1.SetTransObject(SQLCA)
			  dw_1.retrieve(is_ittyp)
		  elseif ssetting = "d_ittyp_popup2_1" then
           if dw_1.rowcount() < 1 then
				  messagebox("확 인", "선택할 자료가 없습니다.!!")
				  return 1
			  end if	  
           is_ittyp = dw_1.getitemstring(dw_1.getrow(), 'ittyp') 
           is_lag_gub = dw_1.getitemstring(dw_1.getrow(), 'itcls') 
			  dw_1.DataObject = "d_ittyp_popup2_2"
			  dw_1.SetTransObject(SQLCA)
			  dw_1.retrieve(is_ittyp, is_lag_gub)
		  elseif ssetting = "d_ittyp_popup2_2" then
           if dw_1.rowcount() < 1 then
				  messagebox("확 인", "선택할 자료가 없습니다.!!")
				  return 1
			  end if	  
           is_ittyp = dw_1.getitemstring(dw_1.getrow(), 'ittyp') 
           is_mid_gub = dw_1.getitemstring(dw_1.getrow(), 'itcls') 
			  dw_1.DataObject = "d_ittyp_popup2_3"
			  dw_1.SetTransObject(SQLCA)
			  dw_1.retrieve(is_ittyp, is_mid_gub)
	     end if
		  return 1
   case KeyLeftArrow!
		  ssetting = dw_1.DataObject
		  if ssetting = "d_ittyp_popup2" then
			  messagebox("확 인", "분류코드 조회의 시작입니다.!!")
			  return 1
		  elseif ssetting = "d_ittyp_popup2_1" then
			  dw_1.DataObject = "d_ittyp_popup2"
			  dw_1.SetTransObject(SQLCA)
			  dw_1.retrieve()
		  elseif ssetting = "d_ittyp_popup2_2" then
			  dw_1.DataObject = "d_ittyp_popup2_1"
			  dw_1.SetTransObject(SQLCA)
			  dw_1.retrieve(is_ittyp)
		  elseif ssetting = "d_ittyp_popup2_3" then
			  dw_1.DataObject = "d_ittyp_popup2_2"
			  dw_1.SetTransObject(SQLCA)
			  dw_1.retrieve(is_ittyp, is_lag_gub)
	     end if
		  return 1
end choose


end event

type sle_2 from w_inherite_popup`sle_2 within w_ittyp_popup3
boolean visible = false
integer x = 722
integer y = 1932
integer width = 69
end type

type cb_1 from w_inherite_popup`cb_1 within w_ittyp_popup3
integer x = 795
integer y = 1944
integer taborder = 40
end type

type cb_return from w_inherite_popup`cb_return within w_ittyp_popup3
integer x = 1111
integer y = 1944
end type

type cb_inq from w_inherite_popup`cb_inq within w_ittyp_popup3
integer x = 800
integer y = 2048
end type

type sle_1 from w_inherite_popup`sle_1 within w_ittyp_popup3
boolean visible = false
integer x = 297
integer y = 1932
integer width = 425
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_ittyp_popup3
boolean visible = false
integer y = 1944
integer width = 251
string text = "품목코드"
alignment alignment = left!
end type

type rr_1 from roundrectangle within w_ittyp_popup3
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 192
integer width = 1321
integer height = 1644
integer cornerheight = 40
integer cornerwidth = 55
end type

