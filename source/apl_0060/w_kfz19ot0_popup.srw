$PBExportHeader$w_kfz19ot0_popup.srw
$PBExportComments$회계자료전송시 반제전표 조회 선택(POPUP)
forward
global type w_kfz19ot0_popup from w_inherite_popup
end type
type st_2 from statictext within w_kfz19ot0_popup
end type
type st_amt from statictext within w_kfz19ot0_popup
end type
type rr_1 from roundrectangle within w_kfz19ot0_popup
end type
type rr_2 from roundrectangle within w_kfz19ot0_popup
end type
end forward

global type w_kfz19ot0_popup from w_inherite_popup
integer x = 443
integer y = 200
integer width = 2921
integer height = 1904
string title = "반제전표 조회 선택"
st_2 st_2
st_amt st_amt
rr_1 rr_1
rr_2 rr_2
end type
global w_kfz19ot0_popup w_kfz19ot0_popup

type variables
dec   id_amt    //총금액(공급가 + 부가세)
end variables

on w_kfz19ot0_popup.create
int iCurrent
call super::create
this.st_2=create st_2
this.st_amt=create st_amt
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.st_amt
this.Control[iCurrent+3]=this.rr_1
this.Control[iCurrent+4]=this.rr_2
end on

on w_kfz19ot0_popup.destroy
call super::destroy
destroy(this.st_2)
destroy(this.st_amt)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;//조회조건 - 전표종료일, 계정과목, 거래처(
id_amt = Message.DoubleParm	

st_amt.text = string(id_amt, '###,###,###,##0')

String  sAccod
//공급가액 제외코드(수입 부가세 코드) 시스템에서 가져오기
SELECT DATANAME  
  INTO :sAccod
  FROM SYSCNFG  
 WHERE SYSGU = 'A' AND SERIAL = 13 AND LINENO = '01' ;

IF isnull(sAccod) then sAccod = ' ' 

dw_1.Retrieve(gs_gubun, gs_codename, gs_code, sAccod)
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_kfz19ot0_popup
boolean visible = false
integer x = 0
integer y = 1968
integer width = 558
boolean enabled = false
end type

type p_exit from w_inherite_popup`p_exit within w_kfz19ot0_popup
integer x = 2720
integer y = 8
end type

event p_exit::clicked;call super::clicked;
SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_kfz19ot0_popup
boolean visible = false
integer x = 1431
integer y = 1972
boolean enabled = false
end type

type p_choose from w_inherite_popup`p_choose within w_kfz19ot0_popup
integer x = 2546
integer y = 8
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

string ssaupj, sacc_date, supmu_gu, sjun_no, slin_no, sbal_date, sbjun_no
dec    damt

damt      = dw_1.GetItemDecimal(ll_Row, "remain")
IF id_amt > damt THEN
   MessageBox("확 인", "미반제액이 계산서금액 보다 적으니 금액을 확인하세요!")
   return
END IF

sSaupj    = dw_1.GetItemString(ll_Row, "saupj")

Int    iLen
iLen      = len(sSaupj)
if iLen < 1 then 
   MessageBox("확 인", "사업장을 확인하세요!")
   return
elseif iLen = 1 then //사업장은 2자리 
   sSaupj = '0' + sSaupj
end if

sAcc_date = dw_1.GetItemString(ll_Row, "acc_date")
sUpmu_gu  = dw_1.GetItemString(ll_Row, "upmu_gu")
sJun_no   = string(dw_1.GetItemNumber(ll_Row, "jun_no"), '0000')
sLin_no   = string(dw_1.GetItemNumber(ll_Row, "lin_no"), '000')
sBal_date = dw_1.GetItemString(ll_Row, "bal_date")
sBjun_no  = string(dw_1.GetItemNumber(ll_Row, "bjun_no"), '0000')

gs_code = sSaupj + sAcc_date + sUpmu_gu + sJun_no + sLin_no + sBal_date + sBjun_no 

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_kfz19ot0_popup
integer x = 37
integer y = 176
integer width = 2853
integer height = 1620
integer taborder = 10
string dataobject = "dw_kfz19ot0_popup"
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

string ssaupj, sacc_date, supmu_gu, sjun_no, slin_no, sbal_date, sbjun_no
dec    damt  //미반제액

damt      = dw_1.GetItemDecimal(Row, "remain")
IF id_amt > damt THEN
   MessageBox("확 인", "미반제액이 계산서 금액 보다 적으니 금액을 확인하세요!")
   return
END IF

sSaupj    = dw_1.GetItemString(Row, "saupj") 

Int    iLen
iLen      = len(sSaupj)
if iLen < 1 then 
   MessageBox("확 인", "사업장을 확인하세요!")
   return
elseif iLen = 1 then //사업장은 2자리 
   sSaupj = '0' + sSaupj
end if
	
sAcc_date = dw_1.GetItemString(Row, "acc_date")
sUpmu_gu  = dw_1.GetItemString(Row, "upmu_gu")
sJun_no   = string(dw_1.GetItemNumber(Row, "jun_no"), '0000')
sLin_no   = string(dw_1.GetItemNumber(Row, "lin_no"), '000')
sBal_date = dw_1.GetItemString(Row, "bal_date")
sBjun_no  = string(dw_1.GetItemNumber(Row, "bjun_no"), '0000')

gs_code = sSaupj + sAcc_date + sUpmu_gu + sJun_no + sLin_no + sBal_date + sBjun_no 

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_kfz19ot0_popup
boolean visible = false
integer x = 183
integer y = 1972
end type

type cb_1 from w_inherite_popup`cb_1 within w_kfz19ot0_popup
integer x = 1138
integer y = 1920
integer width = 302
integer taborder = 20
end type

type cb_return from w_inherite_popup`cb_return within w_kfz19ot0_popup
integer x = 1458
integer y = 1920
integer width = 302
integer taborder = 30
end type

type cb_inq from w_inherite_popup`cb_inq within w_kfz19ot0_popup
boolean visible = false
integer x = 1106
integer y = 1600
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_kfz19ot0_popup
boolean visible = false
integer x = 0
integer y = 1972
end type

type st_1 from w_inherite_popup`st_1 within w_kfz19ot0_popup
boolean visible = false
end type

type st_2 from statictext within w_kfz19ot0_popup
integer x = 87
integer y = 56
integer width = 421
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "계산서 금액 : "
boolean focusrectangle = false
end type

type st_amt from statictext within w_kfz19ot0_popup
integer x = 517
integer y = 56
integer width = 626
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean underline = true
long backcolor = 33027312
boolean enabled = false
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_kfz19ot0_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 27
integer y = 20
integer width = 1253
integer height = 124
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_kfz19ot0_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 172
integer width = 2871
integer height = 1632
integer cornerheight = 40
integer cornerwidth = 55
end type

