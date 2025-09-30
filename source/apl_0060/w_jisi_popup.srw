$PBExportHeader$w_jisi_popup.srw
$PBExportComments$작업지시 조회 선택
forward
global type w_jisi_popup from w_inherite_popup
end type
type pb_1 from u_pb_cal within w_jisi_popup
end type
type pb_2 from u_pb_cal within w_jisi_popup
end type
type rr_1 from roundrectangle within w_jisi_popup
end type
end forward

global type w_jisi_popup from w_inherite_popup
integer x = 96
integer y = 160
integer width = 3941
integer height = 2072
string title = "작업지시 조회"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_jisi_popup w_jisi_popup

on w_jisi_popup.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_1
end on

on w_jisi_popup.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)

f_child_saupj(dw_jogun, 'pdtgu', gs_saupj)

dw_jogun.Reset()
dw_jogun.InsertRow(0)

//IF gs_gubun >= '10' AND gs_gubun < '99' then
//	dw_jogun.setitem(1, 'sgub2', gs_gubun )
//END IF

IF gs_code = '대기' THEN 
	dw_jogun.setitem(1, 'matchk', '1' )
ELSEIF gs_code = '전체' THEN 
	dw_jogun.setitem(1, 'matchk', '%' )
END IF

//dw_jogun.setitem(1, 'fr_date', left(f_today(), 6) + '01' )
dw_jogun.setitem(1, 'fr_date', f_today() )
dw_jogun.setitem(1, 'to_date', f_today())
dw_jogun.SetFocus()
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)

/* User별 사업장 Setting */
setnull(gs_code)
If 	f_check_saupj() = 1 Then
	dw_jogun.SetItem(1, 'saupj', gs_code)
	if 	gs_code <> '%' then
		dw_jogun.setItem(1, 'saupj', gs_code)
        	dw_jogun.Modify("saupj.protect=1")
		dw_jogun.Modify("saupj.background.color = 80859087")
	End if
End If

String  ls_pdtgu
SELECT RFGUB INTO :ls_pdtgu FROM REFFPF
 WHERE SABU = :gs_sabu AND RFCOD = '03' AND RFNA2 = :gs_saupj ;
dw_jogun.SetItem(1, 'pdtgu', ls_pdtgu)
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_jisi_popup
integer y = 160
integer width = 2711
integer height = 276
string dataobject = "d_jisi_popup1"
end type

event dw_jogun::rbuttondown;call super::rbuttondown;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Choose Case 	this.getcolumnname()
	Case 		"mchno"		//설비번호
		gs_gubun = 'ALL'
	
		open(w_mchno_popup)
		this.SetItem(1, "mchno", gs_code)
		this.SetItem(1, "mchnam", gs_codename)
		return
End  Choose
end event

event dw_jogun::itemchanged;call super::itemchanged;String s_cod, s_nam

s_cod = Trim(this.GetText())

if	this.getcolumnname() = "mchno" then
	select mchnam into :s_nam from mchmst
	 where sabu = :gs_sabu and mchno = :s_cod;
	 
	if sqlca.sqlcode <> 0 then
		dw_1.reset()
		f_message_chk(33,"[관리번호]")
		this.object.mchno[1] = ""
		this.object.mchnam[1] = ""
		return 1
	else	
		this.object.mchnam[1] = s_nam
	end if
end if


end event

type p_exit from w_inherite_popup`p_exit within w_jisi_popup
integer x = 3694
integer y = 8
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_jisi_popup
integer x = 3346
integer y = 8
end type

event p_inq::clicked;call super::clicked;String sdatef,sdatet, sgub1, sgub2, spdtgu, swan, sMatchk, sMogubn
String ls_saupj, ls_mchno

IF dw_jogun.AcceptText() = -1 THEN RETURN 

sdatef 	= TRIM(dw_jogun.GetItemString(1,"fr_date"))
sdatet 	= TRIM(dw_jogun.GetItemString(1,"to_date"))
sgub1  	= TRIM(dw_jogun.GetItemString(1,"sgub"))
sgub2  	= TRIM(dw_jogun.GetItemString(1,"sgub2"))
spdtgu 	= TRIM(dw_jogun.GetItemString(1,"pdtgu"))
swan   	= dw_jogun.GetItemString(1,"bpwan")
smatchk 	= dw_jogun.GetItemString(1,"matchk")
smogubn = dw_jogun.GetItemString(1,"mogubn")
ls_saupj	= dw_jogun.GetItemString(1,"saupj")
ls_mchno = dw_jogun.GetItemString(1,"mchno")

IF 	sdatef ="" OR IsNull(sdatef) THEN
	sdatef ='.'
END IF

IF 	sdatet = "" OR IsNull(sdatet) THEN
	sdatet ='99999999'
END IF

IF 	sdatet < sdatef THEN
	f_message_chk(34,'[기간]')
	dw_jogun.SetColumn("fr_date")
	dw_jogun.SetFocus()
	Return
END IF

IF 	sgub1 = "" OR IsNull(sgub1) THEN
	sgub1 ='%'
END IF

IF 	sgub2 = "" OR IsNull(sgub2) THEN
	sgub2 ='%'
END IF

IF 	spdtgu = "" OR IsNull(spdtgu) THEN
	spdtgu ='%'
END IF

IF 	smogubn = "" OR IsNull(smogubn) THEN
	smogubn ='%'
END IF

IF 	ls_mchno = "" OR IsNull(ls_mchno) THEN
	ls_mchno ='%'
END IF

IF swan = 'Y' then 
	dw_1.SetFilter("bpwan = 'Y'")
ELSEIF swan = 'N' then   
	dw_1.SetFilter("bpwan = 'N'")
ELSE
	dw_1.SetFilter("")
END IF
dw_1.Filter( )

IF 	dw_1.Retrieve(gs_sabu, ls_saupj, sdatef, sdatet, sgub1, spdtgu,sgub2, smatchk, smogubn, ls_mchno) <= 0 THEN
   	messagebox("확인", "조회한 자료가 없습니다!!")
	dw_jogun.SetColumn("fr_date")
	dw_jogun.SetFocus()
	Return
END IF
 
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type p_choose from w_inherite_popup`p_choose within w_jisi_popup
integer x = 3520
integer y = 8
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "momast_pordno")  

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_jisi_popup
integer x = 37
integer y = 456
integer width = 3858
integer height = 1484
string dataobject = "d_jisi_popup"
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

gs_code= dw_1.GetItemString(Row, "momast_pordno")  


Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_jisi_popup
boolean visible = false
integer x = 951
integer y = 2028
integer width = 1001
end type

type cb_1 from w_inherite_popup`cb_1 within w_jisi_popup
boolean visible = false
integer x = 1257
integer y = 2044
boolean enabled = false
end type

type cb_return from w_inherite_popup`cb_return within w_jisi_popup
boolean visible = false
integer x = 1879
integer y = 2044
integer taborder = 40
boolean enabled = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_jisi_popup
boolean visible = false
integer x = 1568
integer y = 2044
integer taborder = 20
boolean enabled = false
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_jisi_popup
boolean visible = false
integer x = 288
integer y = 2028
integer width = 425
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_jisi_popup
boolean visible = false
integer x = 18
integer y = 2048
integer width = 251
string text = "품목코드"
alignment alignment = left!
end type

type pb_1 from u_pb_cal within w_jisi_popup
integer x = 599
integer y = 252
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_jogun.SetColumn('fr_date')
IF Isnull(gs_code) THEN Return
dw_jogun.SetItem(dw_jogun.getrow(), 'fr_date', gs_code)
end event

type pb_2 from u_pb_cal within w_jisi_popup
integer x = 1010
integer y = 252
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_jogun.SetColumn('to_date')
IF Isnull(gs_code) THEN Return
dw_jogun.SetItem(dw_jogun.getrow(), 'to_date', gs_code)
end event

type rr_1 from roundrectangle within w_jisi_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 444
integer width = 3858
integer height = 1508
integer cornerheight = 40
integer cornerwidth = 55
end type

