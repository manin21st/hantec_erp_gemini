$PBExportHeader$w_itemas_popup2.srw
$PBExportComments$** 품목코드 조회 선택(F2 KEY)완료처리된 품목
forward
global type w_itemas_popup2 from w_inherite_popup
end type
type rr_1 from roundrectangle within w_itemas_popup2
end type
end forward

global type w_itemas_popup2 from w_inherite_popup
integer x = 2025
integer y = 188
integer width = 1358
integer height = 1920
string title = "품목코드 조회"
rr_1 rr_1
end type
global w_itemas_popup2 w_itemas_popup2

type variables
String  is_ittyp,  is_lag_gub, is_mid_gub, is_sml_gub
end variables

on w_itemas_popup2.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_itemas_popup2.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)
dw_1.Retrieve()
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()

end event

type dw_jogun from w_inherite_popup`dw_jogun within w_itemas_popup2
boolean visible = false
integer x = 128
integer y = 1988
integer width = 119
boolean enabled = false
end type

type p_exit from w_inherite_popup`p_exit within w_itemas_popup2
integer x = 1166
integer y = 16
end type

event p_exit::clicked;call super::clicked;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_itemas_popup2
integer x = 265
integer y = 1992
end type

type p_choose from w_inherite_popup`p_choose within w_itemas_popup2
integer x = 992
integer y = 16
end type

event p_choose::clicked;call super::clicked;String ssetting
Long ll_row

ssetting = dw_1.DataObject

if ssetting <> "d_itemas_popup2" then
   messagebox("확 인", "품목만 선택 가능 합니다.!!")
   return 
end if

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "itcls")
gs_codename= dw_1.GetItemString(ll_row,"titnm")
gs_gubun= dw_1.GetItemString(ll_row,"ispec")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_itemas_popup2
integer x = 50
integer y = 184
integer width = 1266
integer height = 1628
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

event dw_1::doubleclicked;string ssetting
ssetting = dw_1.DataObject
if ssetting <> "d_itemas_popup2" then
   messagebox("확 인", "품목만 선택 가능 합니다.!!")
   return 
end if

IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code= dw_1.GetItemString(Row, "itcls")
gs_codename= dw_1.GetItemString(row,"titnm")
gs_gubun= dw_1.GetItemString(row,"ispec")

Close(Parent)

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
		  if ssetting = "d_itemas_popup2" then
			  messagebox("확 인", "품목코드 조회의 끝입니다.!!")
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
		  elseif ssetting = "d_ittyp_popup2_3" then
           if dw_1.rowcount() < 1 then
				  messagebox("확 인", "선택할 자료가 없습니다.!!")
				  return 1
			  end if	  
           is_ittyp = dw_1.getitemstring(dw_1.getrow(), 'ittyp') 
           is_sml_gub = dw_1.getitemstring(dw_1.getrow(), 'itcls') 
			  dw_1.DataObject = "d_itemas_popup2"
			  dw_1.SetTransObject(SQLCA)
			  dw_1.retrieve(is_ittyp, is_sml_gub)
//			  dw_1.retrieve(gs_saupj, is_ittyp, is_lag_gub, is_mid_gub, is_sml_gub)
	     end if
		  return 1
   case KeyLeftArrow!
		  ssetting = dw_1.DataObject
		  if ssetting = "d_ittyp_popup2" then
			  messagebox("확 인", "품목코드 조회의 시작입니다.!!")
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
		  elseif ssetting = "d_itemas_popup2" then
			  dw_1.DataObject = "d_ittyp_popup2_3"
			  dw_1.SetTransObject(SQLCA)
			  dw_1.retrieve(is_ittyp, is_mid_gub)
	     end if
		  return 1
end choose


end event

type sle_2 from w_inherite_popup`sle_2 within w_itemas_popup2
boolean visible = false
integer x = 361
integer y = 1888
integer width = 1006
end type

type cb_1 from w_inherite_popup`cb_1 within w_itemas_popup2
integer x = 667
integer y = 1992
integer taborder = 40
end type

type cb_return from w_inherite_popup`cb_return within w_itemas_popup2
integer x = 983
integer y = 1992
end type

type cb_inq from w_inherite_popup`cb_inq within w_itemas_popup2
integer x = 462
integer y = 1988
end type

type sle_1 from w_inherite_popup`sle_1 within w_itemas_popup2
boolean visible = false
integer x = 2222
integer y = 1360
integer width = 425
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_itemas_popup2
boolean visible = false
integer x = 1925
integer y = 1372
integer width = 251
string text = "품목코드"
alignment alignment = left!
end type

type rr_1 from roundrectangle within w_itemas_popup2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 180
integer width = 1294
integer height = 1644
integer cornerheight = 40
integer cornerwidth = 55
end type

