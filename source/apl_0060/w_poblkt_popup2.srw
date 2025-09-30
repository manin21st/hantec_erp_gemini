$PBExportHeader$w_poblkt_popup2.srw
$PBExportComments$** 품번으로 발주품목정보 조회 선택
forward
global type w_poblkt_popup2 from w_inherite_popup
end type
type rr_1 from roundrectangle within w_poblkt_popup2
end type
end forward

global type w_poblkt_popup2 from w_inherite_popup
integer x = 357
integer y = 540
integer width = 3291
integer height = 1416
string title = "발주번호 조회 선택"
rr_1 rr_1
end type
global w_poblkt_popup2 w_poblkt_popup2

on w_poblkt_popup2.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_poblkt_popup2.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;///////////////////////////////////////////////////////////////////////////////////
// 발주단위 사용에 따른 화면 변경
sTring sCnvgu, sCnvart

/* 발주단위 사용여부를 환경설정에서 검색함 */
select dataname
  into :sCnvgu
  from syscnfg
 where sysgu = 'Y' and serial = '12' and lineno = '3';
If isNull(sCnvgu) or Trim(sCnvgu) = '' then
	sCnvgu = 'N'
End if

if sCnvgu = 'Y' then // 발주단위 사용시
	dw_1.dataobject = 'd_poblkt_popup2_1'
Else						// 발주단위 사용안함
	dw_1.dataobject = 'd_poblkt_popup2'	
End if

dw_1.SetTransObject(sqlca)

if dw_1.Retrieve(gs_sabu, gs_code) < 1 then 
	f_message_chk(33, "[자료확인]")
	setnull(gs_code)
	setnull(gs_codename)
	setnull(gs_gubun)
	Close(this)
	return 
end if	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_poblkt_popup2
boolean visible = false
integer x = 251
integer y = 1388
boolean enabled = false
end type

type p_exit from w_inherite_popup`p_exit within w_poblkt_popup2
integer x = 3072
integer y = 16
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_poblkt_popup2
integer x = 2533
integer y = 1636
end type

type p_choose from w_inherite_popup`p_choose within w_poblkt_popup2
integer x = 2898
integer y = 16
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "pomast_baljpno")
gs_codename= string(dw_1.GetItemNumber(ll_row,"poblkt_balseq"))

gs_gubun= dw_1.GetItemString(ll_Row, "poblkt_tuncu")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_poblkt_popup2
integer x = 32
integer y = 176
integer width = 3200
integer height = 1132
integer taborder = 10
string dataobject = "d_poblkt_popup2"
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

gs_code= dw_1.GetItemString(Row, "pomast_baljpno")
gs_codename= string(dw_1.GetItemNumber(row,"poblkt_balseq"))

gs_gubun= dw_1.GetItemString(Row, "poblkt_tuncu")
Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_poblkt_popup2
boolean visible = false
integer x = 910
integer y = 1676
integer width = 1001
end type

type cb_1 from w_inherite_popup`cb_1 within w_poblkt_popup2
integer x = 1559
integer y = 636
end type

type cb_return from w_inherite_popup`cb_return within w_poblkt_popup2
integer x = 2199
integer y = 636
end type

type cb_inq from w_inherite_popup`cb_inq within w_poblkt_popup2
integer x = 1957
integer y = 1016
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_poblkt_popup2
boolean visible = false
integer x = 485
integer y = 1676
integer width = 425
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_poblkt_popup2
boolean visible = false
integer x = 187
integer y = 1688
integer width = 251
long backcolor = 12632256
string text = "품목코드"
alignment alignment = left!
end type

type rr_1 from roundrectangle within w_poblkt_popup2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 172
integer width = 3223
integer height = 1144
integer cornerheight = 40
integer cornerwidth = 55
end type

