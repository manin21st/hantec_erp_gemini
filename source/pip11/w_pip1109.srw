$PBExportHeader$w_pip1109.srw
$PBExportComments$** �޿� ����ڷ� �ϰ�����
forward
global type w_pip1109 from w_inherite_multi
end type
type gb_9 from groupbox within w_pip1109
end type
type gb_6 from groupbox within w_pip1109
end type
type gb_8 from groupbox within w_pip1109
end type
type gb_7 from groupbox within w_pip1109
end type
type gb_3 from groupbox within w_pip1109
end type
type uo_progress from u_progress_bar within w_pip1109
end type
type rb_1 from radiobutton within w_pip1109
end type
type st_2 from statictext within w_pip1109
end type
type rb_2 from radiobutton within w_pip1109
end type
type st_3 from statictext within w_pip1109
end type
type em_ym from editmask within w_pip1109
end type
type dw_allow from datawindow within w_pip1109
end type
type cbx_1 from checkbox within w_pip1109
end type
type cbx_2 from checkbox within w_pip1109
end type
type rb_5 from radiobutton within w_pip1109
end type
type rb_6 from radiobutton within w_pip1109
end type
type rb_7 from radiobutton within w_pip1109
end type
type cbx_add from checkbox within w_pip1109
end type
type cbx_sub from checkbox within w_pip1109
end type
type dw_total from u_d_select_sort within w_pip1109
end type
type dw_personal from u_d_select_sort within w_pip1109
end type
type rb_8 from radiobutton within w_pip1109
end type
type p_1 from picture within w_pip1109
end type
type p_2 from picture within w_pip1109
end type
type st_20 from statictext within w_pip1109
end type
type st_21 from statictext within w_pip1109
end type
type pb_1 from picturebutton within w_pip1109
end type
type pb_2 from picturebutton within w_pip1109
end type
type dw_saup from datawindow within w_pip1109
end type
type gb_4 from groupbox within w_pip1109
end type
type rr_1 from roundrectangle within w_pip1109
end type
type rr_2 from roundrectangle within w_pip1109
end type
type rr_6 from roundrectangle within w_pip1109
end type
type rr_7 from roundrectangle within w_pip1109
end type
end forward

global type w_pip1109 from w_inherite_multi
integer height = 2620
string title = "�޿� ��� �ڷ� �ϰ� ����"
gb_9 gb_9
gb_6 gb_6
gb_8 gb_8
gb_7 gb_7
gb_3 gb_3
uo_progress uo_progress
rb_1 rb_1
st_2 st_2
rb_2 rb_2
st_3 st_3
em_ym em_ym
dw_allow dw_allow
cbx_1 cbx_1
cbx_2 cbx_2
rb_5 rb_5
rb_6 rb_6
rb_7 rb_7
cbx_add cbx_add
cbx_sub cbx_sub
dw_total dw_total
dw_personal dw_personal
rb_8 rb_8
p_1 p_1
p_2 p_2
st_20 st_20
st_21 st_21
pb_1 pb_1
pb_2 pb_2
dw_saup dw_saup
gb_4 gb_4
rr_1 rr_1
rr_2 rr_2
rr_6 rr_6
rr_7 rr_7
end type
global w_pip1109 w_pip1109

type variables
String                sProcYearMonth, sPayGbn,sPTag,sBTag,sProcGbn
DataWindow    dw_Process
Integer              il_rowcount


end variables

forward prototypes
public function string wf_sqlsyntax (string gubun)
end prototypes

public function string wf_sqlsyntax (string gubun);
String  sSqlSyntax,sEmpNo,sSpace
Integer k,lSyntaxLength

sSpace = ' '

IF gubun = '1' THEN
	sSqlSyntax = ' select empno,deptcode,enterdate,retiredate,levelcode,salary,jikjonggubn from p1_master ' 
ELSEIF gubun = '2' THEN
	sSqlSyntax = ' select empno from p1_master ' 
ELSEIF gubun = '3' THEN
	sSqlSyntax = ' select empno,enterdate,retiredate,ssfdate,sstdate,jikjonggubn from p1_master '  	
	
END IF

//sSqlSyntax = sSqlSyntax + ' ("P1_MASTER"."RETIREDATE" = '+ "'"+sSpace +"'"+" ) OR "
//sSqlSyntax = sSqlSyntax + ' (SUBSTR("P1_MASTER"."RETIREDATE",1,6) >= '+ "'"+sprocyearmonth +"'"+" )) AND "
//
sSqlSyntax = sSqlSyntax + 'where '

FOR k = 1 TO il_rowcount
	
	sEmpNo = dw_Process.GetItemString(k,"empno")
	
	sSqlSyntax = sSqlSyntax + ' empno =' + "'"+ sEmpNo +"' "+' or'
	
NEXT

lSyntaxLength = len(sSqlSyntax)
sSqlSyntax    = Mid(sSqlSyntax,1,lSyntaxLength - 2)

//sSqlSyntax = sSqlSyntax 

//sSqlSyntax = sSqlSyntax + ' AND ("P1_MASTER"."COMPANYCODE" = ' + "'" + gs_company +"'"+") "
//sSqlSyntax = sSqlSyntax + ' AND ( SUBSTR("P1_MASTER"."ENTERDATE",1,6) <= ' + "'"+sprocyearmonth +"'"+" )"  

IF rb_7.Checked = True THEN
	String sJikGbn = '2'
	
//	sSqlSyntax = sSqlSyntax + ' AND ("P1_MASTER"."JIKJONGGUBN" <> ' + "'"+sJikGbn +"'"+")"
//	+' ORDER BY "P1_MASTER"."RETIREDATE" DSC'  
END IF

Return sSqlSyntax

end function

on w_pip1109.create
int iCurrent
call super::create
this.gb_9=create gb_9
this.gb_6=create gb_6
this.gb_8=create gb_8
this.gb_7=create gb_7
this.gb_3=create gb_3
this.uo_progress=create uo_progress
this.rb_1=create rb_1
this.st_2=create st_2
this.rb_2=create rb_2
this.st_3=create st_3
this.em_ym=create em_ym
this.dw_allow=create dw_allow
this.cbx_1=create cbx_1
this.cbx_2=create cbx_2
this.rb_5=create rb_5
this.rb_6=create rb_6
this.rb_7=create rb_7
this.cbx_add=create cbx_add
this.cbx_sub=create cbx_sub
this.dw_total=create dw_total
this.dw_personal=create dw_personal
this.rb_8=create rb_8
this.p_1=create p_1
this.p_2=create p_2
this.st_20=create st_20
this.st_21=create st_21
this.pb_1=create pb_1
this.pb_2=create pb_2
this.dw_saup=create dw_saup
this.gb_4=create gb_4
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_6=create rr_6
this.rr_7=create rr_7
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_9
this.Control[iCurrent+2]=this.gb_6
this.Control[iCurrent+3]=this.gb_8
this.Control[iCurrent+4]=this.gb_7
this.Control[iCurrent+5]=this.gb_3
this.Control[iCurrent+6]=this.uo_progress
this.Control[iCurrent+7]=this.rb_1
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.rb_2
this.Control[iCurrent+10]=this.st_3
this.Control[iCurrent+11]=this.em_ym
this.Control[iCurrent+12]=this.dw_allow
this.Control[iCurrent+13]=this.cbx_1
this.Control[iCurrent+14]=this.cbx_2
this.Control[iCurrent+15]=this.rb_5
this.Control[iCurrent+16]=this.rb_6
this.Control[iCurrent+17]=this.rb_7
this.Control[iCurrent+18]=this.cbx_add
this.Control[iCurrent+19]=this.cbx_sub
this.Control[iCurrent+20]=this.dw_total
this.Control[iCurrent+21]=this.dw_personal
this.Control[iCurrent+22]=this.rb_8
this.Control[iCurrent+23]=this.p_1
this.Control[iCurrent+24]=this.p_2
this.Control[iCurrent+25]=this.st_20
this.Control[iCurrent+26]=this.st_21
this.Control[iCurrent+27]=this.pb_1
this.Control[iCurrent+28]=this.pb_2
this.Control[iCurrent+29]=this.dw_saup
this.Control[iCurrent+30]=this.gb_4
this.Control[iCurrent+31]=this.rr_1
this.Control[iCurrent+32]=this.rr_2
this.Control[iCurrent+33]=this.rr_6
this.Control[iCurrent+34]=this.rr_7
end on

on w_pip1109.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_9)
destroy(this.gb_6)
destroy(this.gb_8)
destroy(this.gb_7)
destroy(this.gb_3)
destroy(this.uo_progress)
destroy(this.rb_1)
destroy(this.st_2)
destroy(this.rb_2)
destroy(this.st_3)
destroy(this.em_ym)
destroy(this.dw_allow)
destroy(this.cbx_1)
destroy(this.cbx_2)
destroy(this.rb_5)
destroy(this.rb_6)
destroy(this.rb_7)
destroy(this.cbx_add)
destroy(this.cbx_sub)
destroy(this.dw_total)
destroy(this.dw_personal)
destroy(this.rb_8)
destroy(this.p_1)
destroy(this.p_2)
destroy(this.st_20)
destroy(this.st_21)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.dw_saup)
destroy(this.gb_4)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_6)
destroy(this.rr_7)
end on

event open;call super::open;
dw_total.SetTransObject(SQLCA)
dw_total.Reset()

dw_personal.SetTransObject(SQLCA)

dw_allow.SetTransObject(SQLCA)
dw_allow.Reset()
dw_allow.InsertRow(0)

dw_saup.SetTransObject(SQLCA)
dw_saup.InsertRow(0)
f_set_saupcd(dw_saup,'saupcd','1')
is_saupcd = gs_saupcd

em_ym.text = String(f_aftermonth(left(f_today(),6),-1),'@@@@.@@')
em_ym.SetFocus()

rb_1.Checked = True

cbx_add.Checked = True													/*���ޱ���*/
cbx_add.TriggerEvent(Clicked!)

cbx_sub.Checked = True													/*����/��������*/
cbx_sub.TriggerEvent(Clicked!)

cbx_1.Checked = True														/*�޿����뿩��*/
cbx_1.TriggerEvent(Clicked!)

cbx_2.Checked = True														/*�����뿩��*/
cbx_2.TriggerEvent(Clicked!)

rb_5.Checked = True														/*ó������*/
rb_5.TriggerEvent(Clicked!)

uo_progress.Hide()
end event

type p_delrow from w_inherite_multi`p_delrow within w_pip1109
boolean visible = false
integer x = 4114
integer y = 2948
end type

type p_addrow from w_inherite_multi`p_addrow within w_pip1109
boolean visible = false
integer x = 3941
integer y = 2948
end type

type p_search from w_inherite_multi`p_search within w_pip1109
boolean visible = false
integer x = 3246
integer y = 2948
end type

type p_ins from w_inherite_multi`p_ins within w_pip1109
boolean visible = false
integer x = 3767
integer y = 2948
end type

type p_exit from w_inherite_multi`p_exit within w_pip1109
integer x = 4398
end type

type p_can from w_inherite_multi`p_can within w_pip1109
integer x = 4224
end type

event p_can::clicked;call super::clicked;
uo_progress.Hide()

w_mdi_frame.sle_msg.text =""

dw_total.Reset()
dw_personal.Reset()

end event

type p_print from w_inherite_multi`p_print within w_pip1109
boolean visible = false
integer x = 3419
integer y = 2948
end type

type p_inq from w_inherite_multi`p_inq within w_pip1109
integer x = 3877
end type

event p_inq::clicked;call super::clicked;dw_total.Reset()
dw_personal.Reset()

sProcYearMonth = Left(em_ym.text,4) + Right(em_ym.text,2)

IF dw_total.Retrieve(sProcYearMonth, is_saupcd) <=0 THEN
	MessageBox("Ȯ ��","ó���� �ڷᰡ �����ϴ�!!",StopSign!)
	em_ym.SetFocus()
	Return
END IF

dw_Process = dw_total
il_RowCount = dw_total.RowCount()




end event

type p_del from w_inherite_multi`p_del within w_pip1109
boolean visible = false
integer x = 4288
integer y = 2948
end type

type p_mod from w_inherite_multi`p_mod within w_pip1109
integer x = 4050
end type

event p_mod::clicked;call super::clicked;/******************************************************************************************/
/*** �޿� �����ڷ� ����																							*/
/*** 1. �޿��׸� table�� �о ó���Ѵ�.																	*/
/*** 2. ����/������ �����Ͽ� �����Ѵ�.(�޿��׸� table�� ���п� ����)							*/
/*** 3. �޿��ڷḦ �����Ѵ�.(�޿��׸� table�� �޿����� = 'Y')										*/
/*** 4. ���ڷḦ �����Ѵ�.(�޿��׸� table�� ������ = 'Y')										*/
/*** 5. �׸� �ڵ�																									*/
/***    5-1.  �⺻��(01)																						*/
/***    5-2.  ��å����(03)																						*/
/***    5-3.  �������������(02)																				*/
/***    5-4.  �ټӼ���(05)																						*/
/***    5-5.  ��������(06)																						*/
/***    5-6.  ��������(07)																						*/
/***    5-7.  ������������(08)																				*/
/***    5-8.  �Ĵ뺸������(09)																				*/
/***    5-9.  ��������(13)																						*/
/***    5-10. ��������(14)																						*/
/***    5-11. ��������(15)																						*/
/***    5-12. ���޼���(16)																						*/
/***    5-13. �߰�����(17)																						*/
/***    5-14. ���ϼ���(18)																						*/
/***    5-15. �������(04)																						*/
/***    5-16. �����������(11)																				*/
/***    5-17. ��������(06),�������(08),�������(07)													*/
/***    5-18. �ǷẸ�����(05)																				*/
/***    5-19. ���ο��ݰ���(04)																				*/
/***    5-20. ������ȯ��()																						*/
/******************************************************************************************/

Int    il_meterPosition,k,il_CurRow,il_Count,i,iRtnValue
String sEmpNo,sEmpNoSql,sAllowCode,allgubn

sProcYearMonth = Left(em_ym.text,4) + Right(em_ym.text,2)

IF rb_1.Checked = True THEN										//��ü
	dw_Process = dw_total
	il_RowCount = dw_total.RowCount()
	allgubn = 'A'	
ELSEIF rb_2.Checked = True THEN									//����
	dw_Process = dw_personal
	il_RowCount = dw_personal.RowCount()
	allgubn = 'P'
END IF

IF il_RowCount <=0 THEN 
	MessageBox("Ȯ ��","ó���� �ڷᰡ �����ϴ�!!")
	Return
END IF

IF dw_allow.AcceptText() = -1 THEN RETURN

sAllowCode = dw_allow.GetItemString(1,"allowcode")
IF sAllowCode = "" OR IsNull(sAllowCode) THEN
	sAllowCode = '%'
END IF

IF cbx_add.Checked = True AND cbx_sub.Checked = True THEN
	sPayGbn = '%'
END IF

IF cbx_1.Checked = True AND cbx_2.Checked = True THEN
	sPTag = '%'
	sBTag = '%'
END IF

DECLARE start_sp_create_fixdata procedure for sp_create_fixdata(:sProcYearMonth,:sPayGbn,&
					:sPTag,:sBTag,:sAllowCode,:sEmpNoSql, :gs_company) ;
DECLARE start_sp_create_exceptdata procedure for sp_create_exceptdata(:sProcYearMonth,:sEmpNoSql, :gs_company,:is_saupcd,:allgubn);
DECLARE start_sp_update_personal procedure for sp_update_personal(:sProcYearMonth,:sEmpNoSql, :gs_company);

IF sProcGbn = 'FIX' THEN		/*�����ڷ�  ����*/
	w_mdi_frame.sle_msg.text = '�޿� �����ڷ� ���� ��......'
	sEmpNoSql = Wf_SqlSyntax('1')												/*ó����� �ο� sql*/
	SetPointer(HourGlass!)
	execute start_sp_create_fixdata ;
	IF TRIM(SQLCA.SQLERRTEXT) <> '' THEN
		MessageBox('DB Procedure Error[�����ڷ����]',SQLCA.SQLERRTEXT)
	END IF

	SetPointer(Arrow!)
	w_mdi_frame.sle_msg.text ='�޿� �����ڷ� ���� �Ϸ�!!'
ELSEIF sProcGbn = 'EXCEPT'	THEN						/*�����ڷ� ����*/
	
	w_mdi_frame.sle_msg.text = '�޿� �����ڷ� ���� ��......'
	sEmpNoSql = Wf_SqlSyntax('3')												/*ó����� �ο� sql*/
	SetPointer(HourGlass!)
	execute start_sp_create_exceptdata ;
	IF TRIM(SQLCA.SQLERRTEXT) <> '' THEN
		MessageBox('DB Procedure Error[�����ڷ����]',SQLCA.SQLERRTEXT)
	END IF	

	SetPointer(Arrow!)
	w_mdi_frame.sle_msg.text ='�޿� �����ڷ� ���� �Ϸ�!!'
ELSEIF sProcGbn = 'PERSONAL' then
	w_mdi_frame.sle_msg.text = '�޿� ���� ���� �ڷ� ���� ��......'
	sEmpNoSql = Wf_SqlSyntax('2')												/*ó����� �ο� sql*/
	SetPointer(HourGlass!)
	execute start_sp_update_personal ;
	IF TRIM(SQLCA.SQLERRTEXT) <> '' THEN
		MessageBox('DB Procedure Error[�����ڷ����]',SQLCA.SQLERRTEXT)
	END IF
	
	SetPointer(Arrow!)
	w_mdi_frame.sle_msg.text ='�޿� ���� ���� �ڷ� ���� �Ϸ�!!'
ELSE
	SetPointer(HourGlass!)
	w_mdi_frame.sle_msg.text = '�޿� �����ڷ� ���� ��......'
	sEmpNoSql = Wf_SqlSyntax('1')												/*ó����� �ο� sql*/

	execute start_sp_create_fixdata ;
	IF TRIM(SQLCA.SQLERRTEXT) <> '' THEN
		MessageBox('DB Procedure Error[�����ڷ����]',SQLCA.SQLERRTEXT)
	END IF

	w_mdi_frame.sle_msg.text ='�޿� �����ڷ� ���� �Ϸ�!!'
	
	w_mdi_frame.sle_msg.text = '�޿� �����ڷ� ���� ��......'
	sEmpNoSql = Wf_SqlSyntax('3')												/*ó����� �ο� sql*/

	execute start_sp_create_exceptdata ;
	IF TRIM(SQLCA.SQLERRTEXT) <> '' THEN
		MessageBox('DB Procedure Error[�����ڷ����]',SQLCA.SQLERRTEXT)
	END IF
	
	w_mdi_frame.sle_msg.text ='�޿� �����ڷ� ���� �Ϸ�!!'

	w_mdi_frame.sle_msg.text = '�޿� ���� ���� �ڷ� ���� ��......'
	sEmpNoSql = Wf_SqlSyntax('2')												/*ó����� �ο� sql*/

	execute start_sp_update_personal ;
	IF TRIM(SQLCA.SQLERRTEXT) <> '' THEN
		MessageBox('DB Procedure Error[�����ڷ����]',SQLCA.SQLERRTEXT)
	END IF
	
	SetPointer(Arrow!)
	w_mdi_frame.sle_msg.text ='�޿� ���� ���� �ڷ� ���� �Ϸ�!!'
	
END IF

Messagebox('Ȯ��','���� �Ϸ�Ǿ����ϴ�!!')
end event

type dw_insert from w_inherite_multi`dw_insert within w_pip1109
boolean visible = false
integer x = 119
integer y = 2820
end type

type st_window from w_inherite_multi`st_window within w_pip1109
boolean visible = false
integer x = 2299
integer y = 2920
end type

type cb_append from w_inherite_multi`cb_append within w_pip1109
boolean visible = false
integer x = 1966
integer y = 2504
integer taborder = 0
end type

type cb_exit from w_inherite_multi`cb_exit within w_pip1109
boolean visible = false
integer taborder = 60
end type

type cb_update from w_inherite_multi`cb_update within w_pip1109
boolean visible = false
integer x = 2482
integer taborder = 40
end type

type cb_insert from w_inherite_multi`cb_insert within w_pip1109
boolean visible = false
integer x = 2331
integer y = 2504
integer taborder = 0
end type

type cb_delete from w_inherite_multi`cb_delete within w_pip1109
boolean visible = false
integer x = 2757
integer y = 2504
integer taborder = 0
end type

type cb_retrieve from w_inherite_multi`cb_retrieve within w_pip1109
boolean visible = false
integer x = 2117
integer taborder = 30
end type

type st_1 from w_inherite_multi`st_1 within w_pip1109
boolean visible = false
end type

type cb_cancel from w_inherite_multi`cb_cancel within w_pip1109
boolean visible = false
end type

type dw_datetime from w_inherite_multi`dw_datetime within w_pip1109
boolean visible = false
end type

type sle_msg from w_inherite_multi`sle_msg within w_pip1109
boolean visible = false
integer x = 498
integer y = 2920
end type

type gb_2 from w_inherite_multi`gb_2 within w_pip1109
boolean visible = false
end type

type gb_1 from w_inherite_multi`gb_1 within w_pip1109
boolean visible = false
integer x = 1554
integer y = 2444
end type

type gb_10 from w_inherite_multi`gb_10 within w_pip1109
boolean visible = false
end type

type gb_9 from groupbox within w_pip1109
integer x = 507
integer y = 1376
integer width = 1271
integer height = 280
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 33027312
string text = "ó������"
end type

type gb_6 from groupbox within w_pip1109
integer x = 512
integer y = 1068
integer width = 1271
integer height = 224
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 33027312
string text = "�޿�/�󿩱���"
end type

type gb_8 from groupbox within w_pip1109
integer x = 512
integer y = 1736
integer width = 1271
integer height = 224
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 33027312
string text = "�޿��׸�"
end type

type gb_7 from groupbox within w_pip1109
integer x = 512
integer y = 760
integer width = 1271
integer height = 224
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 33027312
string text = "����/��������"
end type

type gb_3 from groupbox within w_pip1109
integer x = 512
integer y = 108
integer width = 1271
integer height = 276
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 33027312
string text = "����"
end type

type uo_progress from u_progress_bar within w_pip1109
integer x = 599
integer y = 2032
integer width = 1083
integer height = 72
boolean bringtotop = true
end type

on uo_progress.destroy
call u_progress_bar::destroy
end on

type rb_1 from radiobutton within w_pip1109
integer x = 983
integer y = 280
integer width = 247
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "��ü"
boolean checked = true
end type

type st_2 from statictext within w_pip1109
integer x = 690
integer y = 292
integer width = 256
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "�۾����"
boolean focusrectangle = false
end type

type rb_2 from radiobutton within w_pip1109
integer x = 1294
integer y = 280
integer width = 247
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "����"
end type

type st_3 from statictext within w_pip1109
integer x = 690
integer y = 188
integer width = 256
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "ó�����"
boolean focusrectangle = false
end type

type em_ym from editmask within w_pip1109
integer x = 974
integer y = 192
integer width = 247
integer height = 60
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
boolean underline = true
long textcolor = 33554432
long backcolor = 16777215
boolean border = false
alignment alignment = center!
maskdatatype maskdatatype = datemask!
string mask = "yyyy.mm"
end type

event modified;//String sYm
//
//sYm = Left(Trim(em_ym.text),4) + Right(Trim(em_ym.text),2) 
//
//dw_total.Retrieve(sYm)
//dw_personal.Reset()

p_inq.TriggerEvent(Clicked!)

end event

type dw_allow from datawindow within w_pip1109
integer x = 599
integer y = 1828
integer width = 1042
integer height = 92
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_pip1109_3"
boolean border = false
boolean livescroll = true
end type

type cbx_1 from checkbox within w_pip1109
integer x = 713
integer y = 1160
integer width = 247
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 33027312
string text = "�޿�"
boolean checked = true
end type

event clicked;
IF cbx_1.Checked = True THEN
	sPTag = 'Y'											/*�޿�����*/
ELSE
	sPTag = 'N'
END IF
end event

type cbx_2 from checkbox within w_pip1109
integer x = 1285
integer y = 1160
integer width = 247
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 33027312
string text = "��"
boolean checked = true
end type

event clicked;IF cbx_2.Checked = True THEN
	sBTag = 'Y'											/*������*/
ELSE
	sBTag = 'N'
END IF
end event

type rb_5 from radiobutton within w_pip1109
integer x = 603
integer y = 1456
integer width = 489
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 33027312
string text = "�����ڷ� ����"
end type

event clicked;sProcGbn = 'FIX'													/*�����ڷ�*/

cbx_add.Enabled = True
cbx_sub.Enabled = True

cbx_1.Enabled = True
cbx_2.Enabled = True

dw_allow.Enabled = True
end event

type rb_6 from radiobutton within w_pip1109
integer x = 1193
integer y = 1460
integer width = 489
integer height = 84
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 33027312
string text = "�����ڷ� ����"
end type

event clicked;sProcGbn = 'PERSONAL'													/*�����ڷ�*/

cbx_add.Enabled = False
cbx_sub.Enabled = False

cbx_1.Enabled = False
cbx_2.Enabled = False

dw_allow.Enabled = False
end event

type rb_7 from radiobutton within w_pip1109
integer x = 603
integer y = 1548
integer width = 489
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 33027312
string text = "�����ڷ� ����"
end type

event clicked;sProcGbn = 'EXCEPT'													/*�����ڷ�*/

cbx_add.Enabled = False
cbx_sub.Enabled = False

cbx_1.Enabled = False
cbx_2.Enabled = False

dw_allow.Enabled = False

end event

type cbx_add from checkbox within w_pip1109
integer x = 713
integer y = 844
integer width = 247
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 33027312
string text = "����"
boolean checked = true
end type

event clicked;IF cbx_add.Checked = True THEN
	sPayGbn = '1'											/*����*/
ELSE
	sPayGbn = '2'
END IF
end event

type cbx_sub from checkbox within w_pip1109
integer x = 1280
integer y = 844
integer width = 247
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 33027312
string text = "����"
boolean checked = true
end type

event clicked;IF cbx_sub.Checked = True THEN
	sPayGbn = '2'											/*����*/
ELSE
	sPayGbn = '1'
END IF
end event

type dw_total from u_d_select_sort within w_pip1109
integer x = 1993
integer y = 292
integer width = 891
integer height = 1832
integer taborder = 0
boolean bringtotop = true
string dataobject = "d_pip1109_1"
boolean border = false
end type

event clicked;If Row <= 0 then
	b_flag =True
ELSE
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

type dw_personal from u_d_select_sort within w_pip1109
integer x = 3122
integer y = 292
integer width = 891
integer height = 1832
integer taborder = 0
boolean bringtotop = true
string dataobject = "d_pip1109_1"
boolean border = false
end type

event clicked;If Row <= 0 then
	b_flag =True
ELSE
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

type rb_8 from radiobutton within w_pip1109
integer x = 1193
integer y = 1548
integer width = 530
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 33027312
string text = "��ü�ڷ� ����"
boolean checked = true
end type

event clicked;sProcGbn = 'ALL'													/*��ü�ڷ����*/

cbx_add.Enabled = True
cbx_sub.Enabled = True

cbx_1.Enabled = True
cbx_2.Enabled = True

dw_allow.Enabled = True
end event

type p_1 from picture within w_pip1109
boolean visible = false
integer x = 3735
integer y = 2688
integer width = 101
integer height = 80
boolean bringtotop = true
string picturename = "C:\erpman\image\next.gif"
boolean focusrectangle = false
end type

event clicked;String sEmpNo,sEmpName,sJikJongGbn
Long   totRow , sRow,rowcnt
int i

totrow =dw_total.Rowcount()

FOR i = 1 TO totrow 
	sRow = dw_total.getselectedrow(0)
	
	IF sRow <=0 THEN EXIT
	
	sEmpNo      = dw_total.GetItemString(sRow, "empno")
   sEmpName    = dw_total.GetItemString(sRow, "empname")
	sJikJongGbn = dw_total.GetItemString(sRow, "jikjonggubn") 	
	
	rowcnt = dw_personal.RowCount() + 1
	
	dw_personal.insertrow(rowcnt)
	dw_personal.setitem(rowcnt, "empname", sEmpName)
	dw_personal.setitem(rowcnt, "empno", sEmpNo)
	dw_personal.setitem(rowcnt, "jikjonggubn", sJikJongGbn)
	dw_total.deleterow(sRow)
NEXT	

IF dw_personal.RowCount() > 0 THEN
	rb_2.Checked = True
ELSE
	rb_1.Checked = True
END IF	
end event

type p_2 from picture within w_pip1109
boolean visible = false
integer x = 3735
integer y = 2796
integer width = 101
integer height = 80
boolean bringtotop = true
string picturename = "C:\erpman\image\prior.gif"
boolean focusrectangle = false
end type

event clicked;String sEmpNo,sEmpName,sJikJongGbn
Long    rowcnt , totRow , sRow 
int     i

totRow =dw_personal.Rowcount()

FOR i = 1 TO totRow 
	sRow = dw_personal.getselectedrow(0)
	
	IF sRow <=0 THEN EXIT
	
	sEmpNo      = dw_personal.GetItemString(sRow, "empno")
   sEmpName    = dw_personal.GetItemString(sRow, "empname")
	sJikJongGbn = dw_personal.GetItemString(sRow, "jikjonggubn")
	
	rowcnt = dw_total.RowCount() + 1
	
	dw_total.insertrow(rowcnt)
	dw_total.setitem(rowcnt, "empname", sEmpName)
	dw_total.setitem(rowcnt, "empno", sEmpNo)
	dw_total.setitem(rowcnt, "jikjonggubn", sJikJongGbn)
	dw_personal.deleterow(sRow)
NEXT	

IF dw_personal.RowCount() > 0 THEN
	rb_2.Checked = True
ELSE
	rb_1.Checked = True
END IF	
end event

type st_20 from statictext within w_pip1109
integer x = 2034
integer y = 236
integer width = 142
integer height = 56
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long backcolor = 32106727
string text = "��ü"
boolean focusrectangle = false
end type

type st_21 from statictext within w_pip1109
integer x = 3150
integer y = 236
integer width = 142
integer height = 48
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 32106727
string text = "����"
boolean focusrectangle = false
end type

type pb_1 from picturebutton within w_pip1109
integer x = 2944
integer y = 540
integer width = 101
integer height = 88
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string picturename = "C:\erpman\Image\next.gif"
end type

event clicked;String sEmpNo,sEmpName,sJikJongGbn
Long   totRow , sRow,rowcnt
int i

totrow =dw_total.Rowcount()

FOR i = 1 TO totrow 
	sRow = dw_total.getselectedrow(0)
	
	IF sRow <=0 THEN EXIT
	
	sEmpNo      = dw_total.GetItemString(sRow, "empno")
   sEmpName    = dw_total.GetItemString(sRow, "empname")
	sJikJongGbn = dw_total.GetItemString(sRow, "jikjonggubn") 	
	
	rowcnt = dw_personal.RowCount() + 1
	
	dw_personal.insertrow(rowcnt)
	dw_personal.setitem(rowcnt, "empname", sEmpName)
	dw_personal.setitem(rowcnt, "empno", sEmpNo)
	dw_personal.setitem(rowcnt, "jikjonggubn", sJikJongGbn)
	dw_total.deleterow(sRow)
NEXT	

IF dw_personal.RowCount() > 0 THEN
	rb_2.Checked = True
ELSE
	rb_1.Checked = True
END IF	
end event

type pb_2 from picturebutton within w_pip1109
integer x = 2944
integer y = 648
integer width = 101
integer height = 88
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string picturename = "C:\erpman\Image\prior.gif"
end type

event clicked;String sEmpNo,sEmpName,sJikJongGbn
Long    rowcnt , totRow , sRow 
int     i

totRow =dw_personal.Rowcount()

FOR i = 1 TO totRow 
	sRow = dw_personal.getselectedrow(0)
	
	IF sRow <=0 THEN EXIT
	
	sEmpNo      = dw_personal.GetItemString(sRow, "empno")
   sEmpName    = dw_personal.GetItemString(sRow, "empname")
	sJikJongGbn = dw_personal.GetItemString(sRow, "jikjonggubn")
	
	rowcnt = dw_total.RowCount() + 1
	
	dw_total.insertrow(rowcnt)
	dw_total.setitem(rowcnt, "empname", sEmpName)
	dw_total.setitem(rowcnt, "empno", sEmpNo)
	dw_total.setitem(rowcnt, "jikjonggubn", sJikJongGbn)
	dw_personal.deleterow(sRow)
NEXT	

IF dw_personal.RowCount() > 0 THEN
	rb_2.Checked = True
ELSE
	rb_1.Checked = True
END IF	
end event

type dw_saup from datawindow within w_pip1109
integer x = 658
integer y = 548
integer width = 686
integer height = 88
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_saupcd_1"
boolean border = false
boolean livescroll = true
end type

event itemchanged;is_saupcd = data
if IsNull(is_saupcd) or Trim(is_saupcd) = '' then is_saupcd = '%'

p_inq.TriggerEvent(Clicked!)
end event

type gb_4 from groupbox within w_pip1109
integer x = 512
integer y = 456
integer width = 1271
integer height = 224
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 33027312
string text = "����� ����"
end type

type rr_1 from roundrectangle within w_pip1109
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 453
integer y = 56
integer width = 1385
integer height = 2116
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pip1109
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1906
integer y = 208
integer width = 2194
integer height = 1964
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_6 from roundrectangle within w_pip1109
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1979
integer y = 256
integer width = 914
integer height = 1884
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_7 from roundrectangle within w_pip1109
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 3109
integer y = 256
integer width = 914
integer height = 1884
integer cornerheight = 40
integer cornerwidth = 55
end type

