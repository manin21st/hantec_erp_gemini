$PBExportHeader$w_kglb01g.srw
$PBExportComments$��ǥ ��� : ���� ó��
forward
global type w_kglb01g from window
end type
type cb_c from commandbutton within w_kglb01g
end type
type cb_x from commandbutton within w_kglb01g
end type
type p_exit from uo_picture within w_kglb01g
end type
type p_can from uo_picture within w_kglb01g
end type
type dw_new from datawindow within w_kglb01g
end type
type dw_insert from datawindow within w_kglb01g
end type
type dw_ins from datawindow within w_kglb01g
end type
type dw_disp from datawindow within w_kglb01g
end type
type rr_1 from roundrectangle within w_kglb01g
end type
end forward

global type w_kglb01g from window
integer x = 73
integer y = 112
integer width = 4206
integer height = 2096
boolean titlebar = true
string title = "���� ó��"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
cb_c cb_c
cb_x cb_x
p_exit p_exit
p_can p_can
dw_new dw_new
dw_insert dw_insert
dw_ins dw_ins
dw_disp dw_disp
rr_1 rr_1
end type
global w_kglb01g w_kglb01g

type variables
Boolean ib_changed
String     sModFlag
Integer   iBefCrossCnt                           //���� �Ǽ�
end variables

forward prototypes
public function integer wf_update_crosslst ()
public subroutine wf_display_data ()
public subroutine wf_baebu_sangamt ()
end prototypes

public function integer wf_update_crosslst ();Long    k,iCurRow,iJunNo,iLinNo,iFindRow,iBJunNo
Double  dSangAmt,dSangAmtY
String  sSaupj,sAccDate,sUpmuGbn,sBalDate

FOR k = 1 TO dw_ins.RowCount()
	sSaupj   = dw_ins.GetItemString(k,"saupj")			
	sAccDate = dw_ins.GetItemString(k,"acc_date")
	sUpmuGbn = dw_ins.GetItemString(k,"upmu_gu")
	iJunNo   = dw_ins.GetItemNumber(k,"jun_no")
	iLinNo   = dw_ins.GetItemNumber(k,"lin_no")
	
	sBalDate = dw_ins.GetItemString(k,"bal_date")
	iBJunNo  = dw_ins.GetItemNumber(k,"bjun_no")
		
	IF sModFlag = 'I' THEN												/*�ű��Է�*/
		dSangAmt = dw_ins.GetItemNumber(k,"sangamt")						/*����ϴ� �ݾ�*/
		IF IsNull(dSangAmt) THEN dSangAmt = 0
		IF dSangAmt = 0 THEN CONTINUE
		
		dSangAmtY = dw_ins.GetItemNumber(k,"ysangamt")						/*����ϴ� �ݾ�(��ȭ)*/
		IF IsNull(dSangAmtY) THEN dSangAmtY = 0

	ELSEIF sModFlag = 'M' THEN
		dSangAmt = dw_ins.GetItemNumber(k,"kfz19ot1_amt_s")			/*����ϴ� �ݾ�*/
		IF IsNull(dSangAmt) THEN dSangAmt = 0

		dSangAmtY = dw_ins.GetItemNumber(k,"kfz19ot1_y_amt_s")			/*����ϴ� �ݾ�*/
		IF IsNull(dSangAmtY) THEN dSangAmtY = 0

		/*�̹� ���Ǿ��� �ڷ� ã��*/
		iFindRow = dw_insert.Find("saupj = '" + sSaupj + "' and acc_date = '" + &
				sAccDate + "' and upmu_gu = '" + sUpmuGbn + "' and str_junno ='" + String(iJunNo) + &
				"' and str_linno = '" + String(iLinNo) + "' and jbal_date = '" + sBalDate + &
				"' and str_bjunno = '" + String(iBJunNo) + "' and saupj_s = '" + lstr_jpra.saupjang +&
				"' and bal_date = '" + lstr_jpra.baldate + "' and upmu_gu_s = '" + &
				lstr_jpra.upmugu + "' and str_bjunno_s = '" + String(lstr_jpra.bjunno) + &
				"' and str_linno_s ='" + String(lstr_jpra.sortno) + "'",1,dw_insert.RowCount())
		
		IF dSangAmt = 0 AND iFindRow <=0 THEN CONTINUE
		
		IF dSangAmt = 0 AND iFindRow > 0 THEN									/*�����ǥ ����*/		
			dw_insert.DeleteRow(iFindRow)
			CONTINUE
		END IF

		IF dSangAmt <> 0 AND iFindRow > 0 THEN
			dw_insert.SetItem(iFindRow,"amt_s",  dSangAmt)
			dw_insert.SetItem(iFindRow,"y_amt_s",dSangAmtY)
			CONTINUE
		END IF
	END IF

	iCurRow = dw_insert.InsertRow(0)
	dw_insert.SetItem(iCurRow,"saupj",     sSaupj)
	dw_insert.SetItem(iCurRow,"acc_date",  sAccDate)
	dw_insert.SetItem(iCurRow,"upmu_gu",   sUpmuGbn)
	dw_insert.SetItem(iCurRow,"jun_no",    iJunNo)
	dw_insert.SetItem(iCurRow,"lin_no",    iLinNo)
	
	dw_insert.SetItem(iCurRow,"jbal_date", sBalDate)				
	dw_insert.SetItem(iCurRow,"bjun_no",   iBJunNo)				
	
	dw_insert.SetItem(iCurRow,"saupj_s",   lstr_jpra.saupjang)
	dw_insert.SetItem(iCurRow,"bal_date",  lstr_jpra.baldate)
	dw_insert.SetItem(iCurRow,"upmu_gu_s", lstr_jpra.upmugu)
	dw_insert.SetItem(iCurRow,"bjun_no_s", lstr_jpra.bjunno)
	dw_insert.SetItem(iCurRow,"lin_no_s",  lstr_jpra.sortno)
					
	dw_insert.SetItem(iCurRow,"amt_s",     dSangAmt)
	dw_insert.SetItem(iCurRow,"y_amt_s",   dSangAmtY)
NEXT

IF dw_insert.Update() <> 1 THEN Return -1

Return 1
end function

public subroutine wf_display_data ();
Integer iRowCount,k,iFindRow,iCurRow
String  sSaupj,sAccDate,sUpmuGu,sJunNo,sLinNo,sBalDate,sBJunNo

//iRowCount = dw_new.Retrieve(Left(lstr_jpra.saupno,6),lstr_jpra.acc1,lstr_jpra.acc2,lstr_jpra.saupjang)	
iRowCount = dw_new.Retrieve(Left(lstr_jpra.saupno,6),lstr_jpra.acc1,lstr_jpra.acc2,'%')	

FOR k = 1 TO dw_new.RowCount()
	sSaupj   = dw_new.GetItemString(k,"saupj")
	sAccDate = dw_new.GetItemString(k,"acc_date") 
	sUpmuGu  = dw_new.GetItemString(k,"upmu_gu") 
	sJunNo   = String(dw_new.GetItemNumber(k,"jun_no"))
	sLinNo   = String(dw_new.GetItemNumber(k,"lin_no"))
	
	sBalDate = dw_new.GetItemString(k,"bal_date") 
	sBJunNo  = String(dw_new.GetItemNumber(k,"bjun_no"))
	
	iFindRow = dw_ins.Find("saupj = '" + sSaupj + "' and acc_date = '" + sAccDate + &
								  "' and upmu_gu = '" + sUpmuGu + "' and str_junno ='" + sJunNo + &
								  "' and str_linno = '" + sLinNo + "' and bal_date = '" + sBalDate + &
								  "' and str_bjunno = '" + sBJunNo + "'",1,dw_ins.RowCount())
	IF iFindRow <= 0 THEN					/*ó���� ���� ������*/
		iCurRow = dw_ins.InsertRow(0)	
		
		/*�� �߻� �ڷ�*/
		dw_ins.SetItem(iCurRow,"saupj",    dw_new.GetItemString(k,"saupj"))
		dw_ins.SetItem(iCurRow,"saupjname",f_get_refferance('AD',dw_new.GetItemString(k,"saupj")))
		dw_ins.SetItem(iCurRow,"acc_date", dw_new.GetItemString(k,"acc_date"))
		dw_ins.SetItem(iCurRow,"upmu_gu",  dw_new.GetItemString(k,"upmu_gu"))
		dw_ins.SetItem(iCurRow,"jun_no",   dw_new.GetItemNumber(k,"jun_no"))
		dw_ins.SetItem(iCurRow,"lin_no",   dw_new.GetItemNumber(k,"lin_no"))
		
		dw_ins.SetItem(iCurRow,"bal_date", dw_new.GetItemString(k,"bal_date"))
		dw_ins.SetItem(iCurRow,"bjun_no",  dw_new.GetItemNumber(k,"bjun_no"))
		
		dw_ins.SetItem(iCurRow,"acc1_cd",  dw_new.GetItemString(k,"acc1_cd"))
		dw_ins.SetItem(iCurRow,"acc2_cd",  dw_new.GetItemString(k,"acc2_cd"))
		dw_ins.SetItem(iCurRow,"accname",  dw_new.GetItemString(k,"kfz01om0_acc2_nm"))
		
		dw_ins.SetItem(iCurRow,"amt",      dw_new.GetItemNumber(k,"amt"))
		dw_ins.SetItem(iCurRow,"cross_amt",dw_new.GetItemNumber(k,"cross_amt"))
		dw_ins.SetItem(iCurRow,"cross_gu", dw_new.GetItemString(k,"cross_gu"))
		
	END IF
NEXT

end subroutine

public subroutine wf_baebu_sangamt ();Double  dRemainSangAmt,dCurAmt,dTmpAmt
Integer k

dCurAmt = lstr_jpra.money

FOR k = 1 TO dw_ins.RowCount()
	dw_ins.SetItem(k,"sangamt",0)
//	dRemainSangAmt = dw_ins.GetItemNumber(k,"remain_sangamt")
//	IF IsNull(dRemainSangAmt) THEN dRemainSangAmt = 0
//	
//	IF dRemainSangAmt >= dCurAmt THEN
//		dw_ins.SetItem(k,"sangamt",dCurAmt)
//		Return
//	ELSEIF dRemainSangAmt < dCurAmt THEN
//		dTmpAmt = dCurAmt - dRemainSangAmt
//		
//		dw_ins.SetItem(k,"sangamt",dRemainSangAmt)
//		dCurAmt = dTmpAmt
//	END IF
NEXT



end subroutine

event open;String  sCvName
Long    iRowCount,iCurRow

f_window_center_Response(this)

dw_new.SetTransObject(SQLCA)									/*���� �� �̻��,�κл�� �ڷ� ��ȸ*/
dw_new.Reset()

dw_insert.SetTransObject(SQLCA)								/*��� �ڷ� ����*/
dw_insert.Reset()

dw_disp.SetTransObject(SQLCA)
dw_disp.Reset()
	
iRowCount = dw_disp.Retrieve(lstr_jpra.saupjang,lstr_jpra.baldate,lstr_jpra.upmugu,&
																		lstr_jpra.bjunno,lstr_jpra.sortno)
IF iRowCount <=0 THEN
	dw_disp.InsertRow(0)

   dw_disp.SetItem(dw_disp.GetRow(),"saupj_s",    lstr_jpra.saupjang)
   dw_disp.SetItem(dw_disp.GetRow(),"bal_date",   lstr_jpra.baldate)
   dw_disp.SetItem(dw_disp.GetRow(),"upmu_gu_s",  lstr_jpra.upmugu)
   dw_disp.SetItem(dw_disp.GetRow(),"bjun_no_s",  lstr_jpra.bjunno)
   dw_disp.SetItem(dw_disp.GetRow(),"lin_no_s",   lstr_jpra.sortno)
	
	sModFlag = 'I'									/*�Է�*/
ELSE
	sModFlag = 'M'									/*����*/
END IF
dw_disp.SetItem(dw_disp.GetRow(),"saupno",    lstr_jpra.saupno)
dw_disp.SetItem(dw_disp.GetRow(),"saupname",  F_Get_PersonLst('1',lstr_jpra.saupno,'1'))
dw_disp.SetItem(dw_disp.GetRow(),"amount",   lstr_jpra.money) 

IF iRowCount <=0 THEN
	dw_ins.DataObject = 'dw_kglb01g_2'
	dw_ins.SetTransObject(SQLCA)
	dw_ins.Reset()
		
//	dw_ins.Retrieve(lstr_jpra.saupno,lstr_jpra.acc1,lstr_jpra.acc2,lstr_jpra.saupjang)	
	dw_ins.Retrieve(lstr_jpra.saupno,lstr_jpra.acc1,lstr_jpra.acc2,'%')	
	
	/*���ݾ� ���*/
	Wf_BaeBu_SangAmt()
	
	ib_changed = False
	
	dw_ins.SetColumn("sangamt")
ELSE
	dw_ins.DataObject = 'dw_kglb01g_3'
	dw_ins.SetTransObject(SQLCA)
	dw_ins.Reset()
	
	dw_ins.Retrieve(lstr_jpra.saupjang,lstr_jpra.baldate,lstr_jpra.upmugu,&
																		lstr_jpra.bjunno,lstr_jpra.sortno)		
	
	Wf_Display_data()
	
	ib_changed = False			
	
	dw_ins.SetColumn("kfz19ot1_amt_s")
END IF

dw_ins.SetFocus()




end event

on w_kglb01g.create
this.cb_c=create cb_c
this.cb_x=create cb_x
this.p_exit=create p_exit
this.p_can=create p_can
this.dw_new=create dw_new
this.dw_insert=create dw_insert
this.dw_ins=create dw_ins
this.dw_disp=create dw_disp
this.rr_1=create rr_1
this.Control[]={this.cb_c,&
this.cb_x,&
this.p_exit,&
this.p_can,&
this.dw_new,&
this.dw_insert,&
this.dw_ins,&
this.dw_disp,&
this.rr_1}
end on

on w_kglb01g.destroy
destroy(this.cb_c)
destroy(this.cb_x)
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.dw_new)
destroy(this.dw_insert)
destroy(this.dw_ins)
destroy(this.dw_disp)
destroy(this.rr_1)
end on

type cb_c from commandbutton within w_kglb01g
integer x = 4613
integer y = 444
integer width = 279
integer height = 84
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "���(&C)"
end type

event clicked;p_can.TriggerEvent(Clicked!)
end event

type cb_x from commandbutton within w_kglb01g
integer x = 4613
integer y = 536
integer width = 279
integer height = 84
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "����(&S)"
end type

event clicked;p_exit.TriggerEvent(Clicked!)
end event

type p_exit from uo_picture within w_kglb01g
integer x = 3963
integer y = 4
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\����_up.gif"
end type

event clicked;call super::clicked;Int    iDbCount,k
Double dAmount
String sRtnValue

dw_ins.AcceptText()
IF dw_ins.RowCount() > 0 THEN
	dAmount = dw_ins.GetItemNumber(dw_ins.GetRow(),"sum_sangamt")
	IF IsNull(dAmount) THEN dAmount = 0
			
	IF dAmount <> lstr_jpra.money THEN
		F_MessageChk(37,'[��ǥ�ݾ�/�����ݾ�]')
		Return	
	END IF
		
	IF ib_changed = True THEN	
		IF F_DbConFirm('����') = 2  then return
		
		iBefCrossCnt = dw_insert.Retrieve(lstr_jpra.saupjang,lstr_jpra.baldate,lstr_jpra.upmugu,&
																			lstr_jpra.bjunno,lstr_jpra.sortno)
		IF Wf_Update_CrossLst() = -1 THEN 
			Rollback;
			F_messageChk(13,'')
			Return
		END IF
		
		sRtnValue = '1'
	ELSE
		IF sModFlag = 'M' THEN
			sRtnValue = '1'	
		ELSE
			sRtnValue = '0'	
		END IF
	END IF
ELSE
	sRtnValue = '0'		
END IF

CloseWithReturn(parent,sRtnValue)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\����_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\����_up.gif"
end event

type p_can from uo_picture within w_kglb01g
integer x = 3790
integer y = 4
integer width = 178
integer taborder = 30
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\���_up.gif"
end type

event clicked;call super::clicked;String  sRtnValue
Integer k

iBefCrossCnt = dw_insert.Retrieve(lstr_jpra.saupjang,lstr_jpra.baldate,lstr_jpra.upmugu,&
																			lstr_jpra.bjunno,lstr_jpra.sortno)
IF iBefCrossCnt > 0 THEN
	FOR k = iBefCrossCnt TO 1 STEP -1
		dw_insert.DeleteRow(k)
	NEXT
	IF dw_insert.Update() <> 1 THEN
		Rollback;
		F_messageChk(12,'')
		Return
	END IF
END IF

sRtnValue = '0'
CloseWithReturn(parent,sRtnValue)


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\���_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\���_up.gif"
end event

type dw_new from datawindow within w_kglb01g
integer x = 1330
integer y = 2048
integer width = 795
integer height = 100
boolean titlebar = true
string title = "�̻��,�κл�� �ڷ� ��ȸ"
string dataobject = "dw_kglb01g_2"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_insert from datawindow within w_kglb01g
integer x = 526
integer y = 2048
integer width = 791
integer height = 100
boolean titlebar = true
string title = "���ó�� ��ȸ,����"
string dataobject = "dw_kglb01g_4"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_ins from datawindow within w_kglb01g
event ue_key pbm_dwnkey
event ue_enterkey pbm_dwnprocessenter
integer x = 50
integer y = 220
integer width = 4082
integer height = 1728
integer taborder = 10
string dataobject = "dw_kglb01g_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_enterkey;Send(Handle(this),256,9,0)
Return 1
end event

event editchanged;ib_changed = True
end event

event getfocus;
this.AcceptText()
end event

event itemerror;Double dnull

SetNull(dnull)

this.SetItem(this.GetRow(),"sangamt",dnull)

Return 1
end event

event itemchanged;Double dSangAmtNew,dSangAmtOld,dNull,dRemain

SetNull(dNull)

IF this.GetColumnName() = "sangamt" THEN
	dSangAmtOld = this.GetItemNumber(this.GetRow(),"sangamt")
	IF IsNull(dSangAmtOld) THEN dSangAmtOld = 0
	
	dSangAmtNew = Double(this.GetText())
	IF IsNull(dSangAmtNew) OR dSangAmtNew = 0 THEN Return
	
	dRemain = this.GetItemNumber(this.GetRow(),"remain_sangamt")
	IF Isnull(dRemain) THEN dRemain = 0
	
	IF Abs(dRemain) + Abs(dSangAmtOld) - Abs(dSangAmtNew) < 0 THEN
		F_MessageChk(37,'[�̹�����/���ݾ�]')
		this.SetItem(this.GetRow(),"sangamt",dnull)
		Return 1	
	END IF
END IF

IF this.GetColumnName() = "kfz19ot1_amt_s" THEN
	dSangAmtOld = this.GetItemNumber(this.GetRow(),"kfz19ot1_amt_s")
	IF IsNull(dSangAmtOld) THEN dSangAmtOld = 0
	
	dSangAmtNew = Double(this.GetText())
	IF IsNull(dSangAmtNew) OR dSangAmtNew = 0 THEN Return
	
	dRemain = this.GetItemNumber(this.GetRow(),"remain_sangamt")
	IF Isnull(dRemain) THEN dRemain = 0
	
	IF dRemain + dSangAmtOld - dSangAmtNew < 0 THEN
		F_MessageChk(37,'[�̹�����/���ݾ�]')
		this.SetItem(this.GetRow(),"kfz19ot1_amt_s",dnull)
		Return 1	
	END IF
END IF


end event

type dw_disp from datawindow within w_kglb01g
integer x = 23
integer width = 2830
integer height = 212
string dataobject = "dw_kglb01g_1"
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_kglb01g
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 212
integer width = 4110
integer height = 1744
integer cornerheight = 40
integer cornerwidth = 55
end type

