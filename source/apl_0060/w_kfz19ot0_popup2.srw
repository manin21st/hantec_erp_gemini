$PBExportHeader$w_kfz19ot0_popup2.srw
$PBExportComments$�����û��Ͻ� ������ǥ ��ȸ ����(POPUP)
forward
global type w_kfz19ot0_popup2 from w_inherite_popup
end type
type rr_1 from roundrectangle within w_kfz19ot0_popup2
end type
end forward

global type w_kfz19ot0_popup2 from w_inherite_popup
integer x = 443
integer y = 200
integer width = 2930
integer height = 2004
string title = "������ǥ ��ȸ ����"
rr_1 rr_1
end type
global w_kfz19ot0_popup2 w_kfz19ot0_popup2

type variables

end variables

on w_kfz19ot0_popup2.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kfz19ot0_popup2.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;//��ȸ���� - ��ǥ������, ��������, �ŷ�ó
String  sAccod
//���ް��� �����ڵ�(���� �ΰ��� �ڵ�) �ý��ۿ��� ��������
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

type dw_jogun from w_inherite_popup`dw_jogun within w_kfz19ot0_popup2
boolean visible = false
integer x = 0
integer y = 1956
integer width = 160
boolean enabled = false
end type

type p_exit from w_inherite_popup`p_exit within w_kfz19ot0_popup2
integer x = 2715
integer y = 12
end type

event p_exit::clicked;call super::clicked;
SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_kfz19ot0_popup2
boolean visible = false
integer x = 869
integer y = 1928
end type

type p_choose from w_inherite_popup`p_choose within w_kfz19ot0_popup2
integer x = 2542
integer y = 12
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

sSaupj    = string(dw_1.GetItemString(ll_Row, "saupj"), '00')
Int    iLen
iLen      = len(sSaupj)
if iLen < 1 then 
   MessageBox("Ȯ ��", "������� Ȯ���ϼ���!")
   return
elseif iLen = 1 then //������� 2�ڸ� 
   sSaupj = '0' + sSaupj
end if
	
sAcc_date = dw_1.GetItemString(ll_Row, "acc_date")
sUpmu_gu  = dw_1.GetItemString(ll_Row, "upmu_gu")
sJun_no   = string(dw_1.GetItemNumber(ll_Row, "jun_no"), '0000')
sLin_no   = string(dw_1.GetItemNumber(ll_Row, "lin_no"), '000')
sBal_date = dw_1.GetItemString(ll_Row, "bal_date")
sBjun_no  = string(dw_1.GetItemNumber(ll_Row, "bjun_no"), '0000')

gs_code = sSaupj + sAcc_date + sUpmu_gu + sJun_no + sLin_no + sBal_date + sBjun_no 
gs_codename = string(damt)

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_kfz19ot0_popup2
integer x = 32
integer y = 176
integer width = 2853
integer height = 1724
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
   MessageBox("Ȯ ��", "���ð��� �����ϴ�. �ٽ� �������� ���ù�ư�� �����ʽÿ� !")
   return
END IF

string ssaupj, sacc_date, supmu_gu, sjun_no, slin_no, sbal_date, sbjun_no
dec    damt  //�̹�����

damt      = dw_1.GetItemDecimal(Row, "remain")

sSaupj    = string(dw_1.GetItemString(Row, "saupj"), '00')

Int    iLen
iLen      = len(sSaupj)
if iLen < 1 then 
   MessageBox("Ȯ ��", "������� Ȯ���ϼ���!")
   return
elseif iLen = 1 then //������� 2�ڸ� 
   sSaupj = '0' + sSaupj
end if
	
sAcc_date = dw_1.GetItemString(Row, "acc_date")
sUpmu_gu  = dw_1.GetItemString(Row, "upmu_gu")
sJun_no   = string(dw_1.GetItemNumber(Row, "jun_no"), '0000')
sLin_no   = string(dw_1.GetItemNumber(Row, "lin_no"), '000')
sBal_date = dw_1.GetItemString(Row, "bal_date")
sBjun_no  = string(dw_1.GetItemNumber(Row, "bjun_no"), '0000')

gs_code = sSaupj + sAcc_date + sUpmu_gu + sJun_no + sLin_no + sBal_date + sBjun_no 
gs_codename = string(damt)

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_kfz19ot0_popup2
boolean visible = false
integer x = 416
integer y = 1972
end type

type cb_1 from w_inherite_popup`cb_1 within w_kfz19ot0_popup2
integer x = 1518
integer y = 2000
integer width = 302
integer taborder = 20
end type

type cb_return from w_inherite_popup`cb_return within w_kfz19ot0_popup2
integer x = 1806
integer y = 2000
integer width = 302
integer taborder = 30
end type

type cb_inq from w_inherite_popup`cb_inq within w_kfz19ot0_popup2
boolean visible = false
integer x = 1106
integer y = 1600
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_kfz19ot0_popup2
boolean visible = false
integer x = 233
integer y = 1972
end type

type st_1 from w_inherite_popup`st_1 within w_kfz19ot0_popup2
boolean visible = false
end type

type rr_1 from roundrectangle within w_kfz19ot0_popup2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 172
integer width = 2875
integer height = 1736
integer cornerheight = 40
integer cornerwidth = 55
end type

