$PBExportHeader$w_qa02_00050_popup4.srw
$PBExportComments$** ���� ���հ� ó�� ��ȸ ����
forward
global type w_qa02_00050_popup4 from w_inherite_popup
end type
type rr_1 from roundrectangle within w_qa02_00050_popup4
end type
end forward

global type w_qa02_00050_popup4 from w_inherite_popup
integer x = 46
integer y = 160
integer width = 3145
integer height = 2112
string title = "���� ���հ� ó�� ��ȸ ����"
rr_1 rr_1
end type
global w_qa02_00050_popup4 w_qa02_00050_popup4

on w_qa02_00050_popup4.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_qa02_00050_popup4.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)
dw_jogun.Reset()
dw_jogun.InsertRow(0)

dw_jogun.setitem(1, 'fr_date', left(f_today(), 6) + '01' )
dw_jogun.setitem(1, 'to_date', f_today())

//dw_1.SetTransObject(sqlca)
//dw_1.SelectRow(0,False)
//dw_1.SelectRow(1,True)
//dw_1.ScrollToRow(1)
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_qa02_00050_popup4
integer x = 23
integer y = 12
integer width = 2254
integer height = 224
string dataobject = "d_qa02_00050_popup4_1"
end type

event dw_jogun::rbuttondown;call super::rbuttondown;String sNull

setnull(gs_code); setnull(gs_gubun); setnull(gs_codename); setnull(snull)

IF this.GetColumnName() = "cvcod" THEN
	gs_gubun ='1'
	Open(w_vndmst_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then
		return
   ELSEIF gs_gubun = '3' or gs_gubun = '4' or gs_gubun = '5' then  //3:����,4:�μ�,5:â��   
      f_message_chk(70, '[����ó]')
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
	
ELSEIF this.GetColumnName() = "gubun" THEN
	s_empno = this.GetText()
	
	if s_empno = '1' then
		dw_1.setfilter("qaqty > 0")
	else
		dw_1.setfilter("")
	end if
	dw_1.filter()
	
END IF	

end event

type p_exit from w_inherite_popup`p_exit within w_qa02_00050_popup4
integer x = 2871
integer y = 48
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_qa02_00050_popup4
integer x = 2523
integer y = 48
end type

event p_inq::clicked;call super::clicked;String	sdatef,sdatet,spdtgu,sgubun

IF dw_jogun.AcceptText() = -1 THEN RETURN 

sdatef = TRIM(dw_jogun.GetItemString(1,"fr_date"))
sdatet = TRIM(dw_jogun.GetItemString(1,"to_date"))
spdtgu = dw_jogun.GetItemString(1,"pdtgu")
sgubun = dw_jogun.GetItemString(1,"gubun")

IF sdatef ="" OR IsNull(sdatef) THEN
	sdatef ='.'
END IF

IF sdatet = "" OR IsNull(sdatet) THEN
	sdatet ='99999999'
END IF

IF sdatet < sdatef THEN
	f_message_chk(34,'[�Ⱓ]')
	dw_jogun.SetColumn("fr_date")
	dw_jogun.SetFocus()
	Return
END IF

if sgubun = '1' then
	dw_1.setfilter("qaqty > 0")
else
	dw_1.setfilter("")
end if
dw_1.filter()
	
IF dw_1.Retrieve(gs_saupj,sdatef,sdatet,spdtgu) <= 0 THEN
	dw_jogun.SetColumn("fr_date")
	dw_jogun.SetFocus()
	Return
END IF

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type p_choose from w_inherite_popup`p_choose within w_qa02_00050_popup4
integer x = 2697
integer y = 48
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "crjpno")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_qa02_00050_popup4
integer x = 37
integer y = 256
integer width = 3035
integer height = 1716
string dataobject = "d_qa02_00050_popup4_2"
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
   MessageBox("Ȯ ��", "���ð��� �����ϴ�. �ٽ� �������� ���ù�ư�� �����ʽÿ� !")
   return
END IF

gs_code= dw_1.GetItemString(Row, "crjpno")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_qa02_00050_popup4
boolean visible = false
integer x = 1038
integer y = 2044
integer width = 1001
end type

type cb_1 from w_inherite_popup`cb_1 within w_qa02_00050_popup4
boolean visible = false
integer x = 1170
integer y = 2052
boolean enabled = false
end type

type cb_return from w_inherite_popup`cb_return within w_qa02_00050_popup4
boolean visible = false
integer x = 1792
integer y = 2052
integer taborder = 40
boolean enabled = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_qa02_00050_popup4
boolean visible = false
integer x = 1481
integer y = 2052
integer taborder = 20
boolean enabled = false
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_qa02_00050_popup4
boolean visible = false
integer x = 375
integer y = 2044
integer width = 425
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_qa02_00050_popup4
boolean visible = false
integer x = 105
integer y = 2064
integer width = 251
string text = "ǰ���ڵ�"
alignment alignment = left!
end type

type rr_1 from roundrectangle within w_qa02_00050_popup4
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 248
integer width = 3058
integer height = 1744
integer cornerheight = 40
integer cornerwidth = 55
end type

