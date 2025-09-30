$PBExportHeader$w_pdt_06043_pop_up.srw
$PBExportComments$수리 의뢰/결과 조회선택
forward
global type w_pdt_06043_pop_up from w_inherite_popup
end type
type dw_2 from datawindow within w_pdt_06043_pop_up
end type
type rr_1 from roundrectangle within w_pdt_06043_pop_up
end type
end forward

global type w_pdt_06043_pop_up from w_inherite_popup
integer x = 960
integer y = 212
integer width = 3090
integer height = 2048
string title = "수리 의뢰/결과 조회선택"
dw_2 dw_2
rr_1 rr_1
end type
global w_pdt_06043_pop_up w_pdt_06043_pop_up

on w_pdt_06043_pop_up.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.rr_1
end on

on w_pdt_06043_pop_up.destroy
call super::destroy
destroy(this.dw_2)
destroy(this.rr_1)
end on

event open;call super::open;string ls_mchnam, sToday

dw_2.insertrow(0)

if not (gs_code = '' or isnull(gs_code)) then 
	select mchnam 
	  into :ls_mchnam
  	  from mchmst
	 where sabu = :gs_sabu and mchno = :gs_code ;
	 
	dw_2.setitem(1, "mchno",  gs_code )
	dw_2.setitem(1, "mchnam", ls_mchnam )
end if


if gs_gubun = '3' THEN  //수리결과 조회인 경우
	dw_2.setitem(1, "gubun", '3')
   if gs_codename = '계측기' then 
       	dw_1.dataobject = 'd_pdt_06043_popup4'
   else
   		dw_1.dataobject = 'd_pdt_06043_popup2'
	end if
ELSE
	dw_2.setitem(1, "gubun", 'W')
   if gs_codename = '계측기' then 
       	dw_1.dataobject = 'd_pdt_06043_popup3'
   else
   		dw_1.dataobject = 'd_pdt_06043_popup'  
	end if
END IF

dw_1.settransobject(sqlca)

if f_datechk(gs_codename) = -1 then
	sToday = f_today()
else
	sToday = gs_codename
end if
dw_2.setitem(1,"from_date", sToday)
dw_2.setitem(1,"to_date", sToday) 


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_pdt_06043_pop_up
integer x = 91
integer y = 5000
end type

type p_exit from w_inherite_popup`p_exit within w_pdt_06043_pop_up
integer x = 2880
integer y = 64
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_pdt_06043_pop_up
integer x = 2533
integer y = 64
end type

event p_inq::clicked;call super::clicked;String sdatef, sdatet, sMchno

IF dw_2.AcceptText() = -1 THEN RETURN 

sdatef = TRIM(dw_2.GetItemString(1,"from_date"))
sdatet = TRIM(dw_2.GetItemString(1,"to_date"))
sMchno = TRIM(dw_2.GetItemString(1,"mchno"))

IF sdatef ="" OR IsNull(sdatef) THEN
	sdatef ='10000101'
END IF

IF sdatet = "" OR IsNull(sdatet) THEN
	sdatet ='99991231'
END IF

IF sMchno ="" OR IsNull(sMchno) THEN
	sMchno ='%'
END IF

IF sdatet < sdatef THEN
	f_message_chk(34,'[기간]')
	dw_2.SetColumn("fr_date")
	dw_2.SetFocus()
	Return
END IF

IF dw_1.Retrieve(gs_sabu, sdatef, sdatet, sMchno) <= 0 THEN
	dw_2.SetColumn("from_date")
	dw_2.SetFocus()
	Return
END IF

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type p_choose from w_inherite_popup`p_choose within w_pdt_06043_pop_up
integer x = 2706
integer y = 64
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code     = dw_1.GetItemstring(ll_row, "mchno") 
gs_codename = dw_1.GetItemstring(ll_row, "mchnam") 
gs_gubun    = dw_1.getitemstring(ll_row, "sidat")
gi_page     = dw_1.GetItemnumber(ll_Row, "seq")
gs_codename2 = dw_1.GetItemString(ll_row, 'status')

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_pdt_06043_pop_up
integer x = 41
integer y = 292
integer width = 2999
integer height = 1628
string dataobject = "d_pdt_06043_popup"
boolean hscrollbar = true
end type

event dw_1::doubleclicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code     = dw_1.GetItemstring(ll_row, "mchno") 
gs_codename = dw_1.GetItemstring(ll_row, "mchnam") 
gs_gubun    = dw_1.getitemstring(ll_row, "sidat")
gi_page     = dw_1.GetItemnumber(ll_Row, "seq")
gs_codename2 = dw_1.GetItemString(ll_row, 'status')

Close(Parent)



end event

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

type sle_2 from w_inherite_popup`sle_2 within w_pdt_06043_pop_up
integer x = 544
integer y = 1976
integer taborder = 30
end type

type cb_1 from w_inherite_popup`cb_1 within w_pdt_06043_pop_up
integer x = 1659
integer y = 5000
integer taborder = 40
end type

type cb_return from w_inherite_popup`cb_return within w_pdt_06043_pop_up
integer x = 2295
integer y = 5000
integer taborder = 60
end type

type cb_inq from w_inherite_popup`cb_inq within w_pdt_06043_pop_up
integer x = 1979
integer y = 5000
integer taborder = 50
end type

type sle_1 from w_inherite_popup`sle_1 within w_pdt_06043_pop_up
integer x = 361
integer y = 1976
end type

type st_1 from w_inherite_popup`st_1 within w_pdt_06043_pop_up
integer x = 82
integer y = 1988
end type

type dw_2 from datawindow within w_pdt_06043_pop_up
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 27
integer y = 32
integer width = 1650
integer height = 240
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_pdt_06043_popup1"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemchanged;string snull, s_name, ls_mchnam

setnull(snull)

IF this.GetColumnName() = 'mchno' THEN
	s_name = this.gettext()
 
   IF s_name = "" OR IsNull(s_name) THEN
		this.object.mchnam[1] = ""
		return 1
   END IF
	
	select mchnam 
	  into :ls_mchnam
	  from mchmst
	 where sabu = :gs_sabu and mchno = :s_name ;
	
	if sqlca.sqlcode <> 0 then
		f_message_chk(33, '[설비번호]' )
		this.setitem(1,"mchno", snull )
		this.setitem(1,"mchnam", snull)
		return 1
	end if
	
	this.setitem(1,"mchnam", ls_mchnam )  

END IF

end event

event itemerror;return 1
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

IF	this.getcolumnname() = "mchno" THEN		
	open(w_mchno_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.SetItem(1, "mchno", gs_code)
	this.SetItem(1, "mchnam", gs_codename)
END IF
end event

type rr_1 from roundrectangle within w_pdt_06043_pop_up
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 284
integer width = 3031
integer height = 1656
integer cornerheight = 40
integer cornerwidth = 55
end type

