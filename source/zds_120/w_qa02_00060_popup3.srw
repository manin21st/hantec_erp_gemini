$PBExportHeader$w_qa02_00060_popup3.srw
$PBExportComments$** 매입 클레임 처리 조회 선택
forward
global type w_qa02_00060_popup3 from w_inherite_popup
end type
type rr_1 from roundrectangle within w_qa02_00060_popup3
end type
end forward

global type w_qa02_00060_popup3 from w_inherite_popup
integer x = 46
integer y = 160
integer width = 3145
integer height = 2112
string title = "매입 클레임 처리 조회 선택"
rr_1 rr_1
end type
global w_qa02_00060_popup3 w_qa02_00060_popup3

on w_qa02_00060_popup3.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_qa02_00060_popup3.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)
dw_jogun.Reset()
dw_jogun.InsertRow(0)

dw_jogun.setitem(1, 'fr_date', left(f_today(), 6) )


//dw_1.SetTransObject(sqlca)
//dw_1.SelectRow(0,False)
//dw_1.SelectRow(1,True)
//dw_1.ScrollToRow(1)
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_qa02_00060_popup3
integer x = 23
integer y = 0
integer width = 782
integer height = 180
string dataobject = "d_qa02_00060_popup3_1"
end type

event dw_jogun::rbuttondown;call super::rbuttondown;String sNull

setnull(gs_code); setnull(gs_gubun); setnull(gs_codename); setnull(snull)

IF this.GetColumnName() = "cvcod" THEN
	gs_gubun ='1'
	Open(w_vndmst_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then
		return
   ELSEIF gs_gubun = '3' or gs_gubun = '4' or gs_gubun = '5' then  //3:은행,4:부서,5:창고   
      f_message_chk(70, '[발주처]')
		this.SetItem(1, "cvcod", snull)
		this.SetItem(1, "cvnas", snull)
      return 1  		
   END IF
	this.SetItem(1, "cvcod", gs_Code)
	this.SetItem(1, "cvnas", gs_Codename)
END IF	
end event

event dw_jogun::itemchanged;call super::itemchanged;string snull, sbaljno, get_nm, s_date, s_empno, s_name, s_name2
int    ireturn 

setnull(snull)

IF this.GetColumnName() = "cvcod" THEN
	s_empno = this.GetText()
	
	ireturn = f_get_name2('V1', 'Y', s_empno, get_nm, s_name)
	this.setitem(1, "cvcod", s_empno)	
	this.setitem(1, "cvnas", get_nm)	
	RETURN ireturn
END IF	

end event

type p_exit from w_inherite_popup`p_exit within w_qa02_00060_popup3
integer x = 2871
integer y = 4
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_qa02_00060_popup3
integer x = 2523
integer y = 4
end type

event p_inq::clicked;call super::clicked;String	syymm

IF dw_jogun.AcceptText() = -1 THEN RETURN 

syymm = TRIM(dw_jogun.GetItemString(1,"fr_date"))

IF f_datechk(syymm+'01') = -1 THEN
	f_message_chk(34,'[처리년월]')
	dw_jogun.SetColumn("fr_date")
	dw_jogun.SetFocus()
	Return
END IF

IF dw_1.Retrieve(gs_saupj,syymm) <= 0 THEN
	dw_jogun.SetColumn("fr_date")
	dw_jogun.SetFocus()
	Return
END IF

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type p_choose from w_inherite_popup`p_choose within w_qa02_00060_popup3
integer x = 2697
integer y = 4
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= trim(dw_1.GetItemString(ll_Row, "jpno"))
messagebox('a',gs_code)

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_qa02_00060_popup3
integer x = 37
integer y = 200
integer width = 3035
integer height = 1772
string dataobject = "d_qa02_00060_popup3_2"
boolean hscrollbar = true
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

gs_code= dw_1.GetItemString(Row, "jpno")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_qa02_00060_popup3
boolean visible = false
integer x = 1038
integer y = 2044
integer width = 1001
end type

type cb_1 from w_inherite_popup`cb_1 within w_qa02_00060_popup3
boolean visible = false
integer x = 1170
integer y = 2052
boolean enabled = false
end type

type cb_return from w_inherite_popup`cb_return within w_qa02_00060_popup3
boolean visible = false
integer x = 1792
integer y = 2052
integer taborder = 40
boolean enabled = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_qa02_00060_popup3
boolean visible = false
integer x = 1481
integer y = 2052
integer taborder = 20
boolean enabled = false
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_qa02_00060_popup3
boolean visible = false
integer x = 375
integer y = 2044
integer width = 425
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_qa02_00060_popup3
boolean visible = false
integer x = 105
integer y = 2064
integer width = 251
string text = "품목코드"
alignment alignment = left!
end type

type rr_1 from roundrectangle within w_qa02_00060_popup3
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 188
integer width = 3058
integer height = 1804
integer cornerheight = 40
integer cornerwidth = 55
end type

