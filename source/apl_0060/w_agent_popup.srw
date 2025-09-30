$PBExportHeader$w_agent_popup.srw
$PBExportComments$** 대리점 조회 선택
forward
global type w_agent_popup from w_inherite_popup
end type
type rr_1 from roundrectangle within w_agent_popup
end type
end forward

global type w_agent_popup from w_inherite_popup
integer x = 1285
integer y = 148
integer width = 2222
integer height = 1996
string title = "대리점 조회 선택"
rr_1 rr_1
end type
global w_agent_popup w_agent_popup

on w_agent_popup.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_agent_popup.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;String sgubun,scode,sname, sgubun2

dw_jogun.SetTransObject(SQLCA)
dw_jogun.Reset()
dw_jogun.InsertRow(0)

IF gs_gubun ="" OR IsNull(gs_gubun) THEN
	sgubun = '%'
ELSE
	dw_jogun.SetItem(1,"code1",gs_gubun)
	sgubun = dw_jogun.GetItemString(1,"code1")
END IF

//IF gi_page = -1 then  // A/S쪽은 관할구역이 필요없슴(A/S의뢰 등록에서만 사용)
sgubun2 = '%'
//ELSE
//	IF gs_area ="" OR IsNull(gs_area) THEN
//		sgubun2 = '%'
//	ELSE
//		dw_jogun.SetItem(1,"code2",gs_area)
//		sgubun2 = dw_jogun.GetItemString(1,"code2")
//	END IF
//END IF	

IF IsNull(gs_code) THEN gs_code =""

dw_jogun.SetItem(1, 'code', gs_code)
dw_jogun.SetItem(1, 'code', gs_codename)

sle_1.text = gs_code
sle_2.text = gs_codename

scode = sle_1.text
sname = sle_2.text

IF IsNull(scode) THEN
	scode ="%"
ELSE 
	scode = scode + '%'
END IF

IF IsNull(sname) THEN
	sname ="%"
ELSE 
	sname = "%" + sname + '%'
END IF

dw_1.Retrieve(scode, sname, sgubun, sgubun2)
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
IF gi_page = -1 then  // A/S쪽은 명으로 찾을 려고 함
   sle_2.SetFocus()
ELSE
	dw_1.setfocus()
END IF

end event

type dw_jogun from w_inherite_popup`dw_jogun within w_agent_popup
integer y = 12
integer width = 1641
integer height = 216
string dataobject = "d_agent_popup1"
end type

event dw_jogun::itemchanged;call super::itemchanged;String scode, s_name, snull

setnull(snull)

IF this.GetColumnName() ="code2" THEN
	scode = this.GetText()

   IF scode = "" OR IsNull(scode) THEN RETURN
	
    SELECT "SAREA"."SAREA"  
      INTO :s_name  
      FROM "SAREA"  
     WHERE "SAREA"."SAREA" = :scode   ;

	if isnull(s_name) or s_name="" then
		f_message_chk(33,'[관할구역]')
		this.SetItem(1,'code2', snull)
		return 1
   end if	
	
//	gs_area = scode
	
END IF
end event

event dw_jogun::itemerror;call super::itemerror;return 1
end event

type p_exit from w_inherite_popup`p_exit within w_agent_popup
integer x = 2021
integer y = 16
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_agent_popup
integer x = 1673
integer y = 16
end type

event p_inq::clicked;call super::clicked;String scode,sname,sgubun, sgubun2 

if dw_jogun.AcceptText() = -1 then return 

sgubun = dw_jogun.GetItemString(1,"code1")
sgubun2 = dw_jogun.GetItemString(1,"code2")
scode = dw_jogun.GetItemString(1,"code")
sname = dw_jogun.GetItemString(1,"name")

IF sgubun ="" OR IsNull(sgubun) THEN
	sgubun ='%'
END IF

IF sgubun2 ="" OR IsNull(sgubun2) THEN
	sgubun2 ='%'
END IF

IF IsNull(scode) THEN
	scode ="%"
ELSE 
	scode = scode + '%'
END IF

IF IsNull(sname) THEN
	sname ="%"
ELSE 
	sname = "%" + sname + '%'
END IF

dw_1.Retrieve(scode, sname, sgubun, sgubun2)
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.setfocus()


end event

type p_choose from w_inherite_popup`p_choose within w_agent_popup
integer x = 1847
integer y = 16
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

IF dw_1.getitemstring(ll_row, "cvstatus") = '2' then
   MessageBox("확 인", "거래종료인 자료는 선택할 수 없습니다.")
   return
END IF

gs_gubun= dw_1.GetItemString(ll_Row, "cvgu")
gs_code= dw_1.GetItemString(ll_Row, "cvcod")
gs_codename= dw_1.GetItemString(ll_row,"cvnas2")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_agent_popup
integer x = 41
integer y = 252
integer width = 2135
integer height = 1620
integer taborder = 40
string dataobject = "d_agent_popup"
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

IF dw_1.getitemstring(row, "cvstatus") = '2' then 
   MessageBox("확 인", "거래종료인 자료는 선택할 수 없습니다.")
   return
END IF

gs_gubun= dw_1.GetItemString(Row, "cvgu")
gs_code= dw_1.GetItemString(Row, "cvcod")
gs_codename= dw_1.GetItemString(row,"cvnas2")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_agent_popup
boolean visible = false
integer x = 430
integer y = 2148
integer width = 1271
integer taborder = 30
boolean enabled = false
end type

type cb_1 from w_inherite_popup`cb_1 within w_agent_popup
integer x = 1097
integer y = 2064
integer taborder = 50
end type

type cb_return from w_inherite_popup`cb_return within w_agent_popup
integer x = 1719
integer y = 2064
integer taborder = 70
end type

type cb_inq from w_inherite_popup`cb_inq within w_agent_popup
integer x = 1408
integer y = 2064
integer taborder = 60
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_agent_popup
boolean visible = false
integer x = 233
integer y = 2148
integer width = 197
integer taborder = 20
boolean enabled = false
integer limit = 6
end type

type st_1 from w_inherite_popup`st_1 within w_agent_popup
boolean visible = false
integer x = 128
integer y = 2148
integer width = 315
string text = "대리점코드"
end type

type rr_1 from roundrectangle within w_agent_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 240
integer width = 2162
integer height = 1648
integer cornerheight = 40
integer cornerwidth = 55
end type

