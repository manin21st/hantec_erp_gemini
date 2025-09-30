$PBExportHeader$w_sal_04010.srw
$PBExportComments$�������� �����ڷ� ����
forward
global type w_sal_04010 from w_inherite
end type
type gb_4 from groupbox within w_sal_04010
end type
type gb_3 from groupbox within w_sal_04010
end type
type gb_2 from groupbox within w_sal_04010
end type
type st_3 from statictext within w_sal_04010
end type
type st_4 from statictext within w_sal_04010
end type
type st_5 from statictext within w_sal_04010
end type
type st_2 from statictext within w_sal_04010
end type
type st_6 from statictext within w_sal_04010
end type
end forward

global type w_sal_04010 from w_inherite
boolean TitleBar=true
string Title="�������� �����ڷ� ����"
long BackColor=80859087
gb_4 gb_4
gb_3 gb_3
gb_2 gb_2
st_3 st_3
st_4 st_4
st_5 st_5
st_2 st_2
st_6 st_6
end type
global w_sal_04010 w_sal_04010

forward prototypes
public function integer wf_update_hap (string sym)
end prototypes

public function integer wf_update_hap (string sym);sle_msg.Text = '�ŷ�ó�� ������������ ������............'

// �������� ���� ���հ� ���̺� ����
Delete From sugumijasum
Where  sabu = :gs_sabu and ija_yymm = :sYM;

if SQLCA.Sqlcode < 0 then
   messagebox("Ȯ��", "�������� ���� ���հ� ���̺� ���� ����!")
	Rollback;
	return -1
end if

Commit;			

// �ش��������� �ŷ�ó�� ������������ ����
Insert Into sugumijasum
	 Select sabu, substr(ipgum_date,1,6), cvcod, sum(NVL(ija_amt,0)), 'N', '', sum(NVL(ija_jamt,0))
	   From sugumija
	  Where sabu = :gs_sabu and substr(ipgum_date,1,6) = :sYM
	  Group By sabu, substr(ipgum_date,1,6), cvcod;

if SQLCA.Sqlcode < 0 then
   messagebox("Ȯ��", "������������ ���� ����!")
	Rollback;
	return -1
end if

Commit;

Return 0
end function

on w_sal_04010.create
int iCurrent
call super::create
this.gb_4=create gb_4
this.gb_3=create gb_3
this.gb_2=create gb_2
this.st_3=create st_3
this.st_4=create st_4
this.st_5=create st_5
this.st_2=create st_2
this.st_6=create st_6
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_4
this.Control[iCurrent+2]=this.gb_3
this.Control[iCurrent+3]=this.gb_2
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.st_5
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.st_6
end on

on w_sal_04010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_4)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.st_2)
destroy(this.st_6)
end on

event open;call super::open;String sYYmm, sMagamIl

dw_Insert.Settransobject(sqlca)
dw_Insert.InsertRow(0)

/* ���������� */
select to_char(add_months(to_date(nvl( max(ija_yymm),to_char(sysdate,'yyyymm')),'yyyymm') ,1),'yyyymm') 
  into :sYYmm
  from sugumijasum ;

dw_insert.SetItem(1,'ym',syymm)

/* ���ݸ�����  */
select rtrim(dataname) into :sMagamIl
  from syscnfg
 where sysgu = 'S' and
       serial = 3 and
       lineno = 30;
dw_insert.SetItem(1,'magamil',sMagamIl)

If IsNull(sMagamIl) Or Not isNumber(sMagamIl) Then
	MessageBox('Ȯ ��','���ݸ������ڰ� �������� �ʾҽ��ϴ�~n~n������ ���� ȸ������ ������ �ʽ��ϴ�.!!')
	cb_ins.Enabled = False
End If

/* User�� ���ұ��� Setting */
String sarea, steam, saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_insert.SetItem(1, 'sarea', sarea)
	dw_insert.Modify("sarea.protect=1")
	dw_insert.Modify("sarea.background.color = 80859087")
End If

end event

type dw_insert from w_inherite`dw_insert within w_sal_04010
int X=1093
int Y=396
int Width=1627
int Height=484
int TabOrder=10
string DataObject="d_sal_04010"
end type

event dw_insert::itemchanged;String sNull, sYM
String sarea, steam, sCvcod, scvnas, sSaupj, sName1

SetNull(sNull)

ib_any_typing = False

Choose Case GetColumnName()
	Case "ym"
      sYM = this.GetText()	+ '01'	
      if f_DateChk(Trim(sYM)) = -1 then
   	   f_Message_Chk(35, '[��������]')
	      this.SetItem(1, "ym", sNull)
   	   return 1
      end if
	/* ���ұ��� */
	Case "sarea"
		SetItem(1,"cvcod",sNull)
		SetItem(1,"cvnas",sNull)
	/* �ŷ�ó */
	Case "cvcod"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"cvnas",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'cvnas', snull)
			Return 1
		ELSE		
			SetItem(1,"sarea",   sarea)
			SetItem(1,"cvnas",	scvnas)
		END IF
	/* �ŷ�ó�� */
	Case "cvnas"
		scvnas = Trim(GetText())
		IF scvnas ="" OR IsNull(scvnas) THEN
			SetItem(1,"cvcod",snull)
			Return
		END IF
		
		If f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'cvnas', snull)
			Return 1
		ELSE
			SetItem(1,"sarea",   sarea)
			SetItem(1,'cvcod', sCvcod)
			SetItem(1,"cvnas", scvnas)
			Return 1
		END IF
End Choose
end event

event dw_insert::itemerror;return 1
end event

event dw_insert::rbuttondown;SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case this.GetColumnName() 
	/* �ŷ�ó */
	Case "cvcod", "cvnas"
		gs_gubun = '1'
		If GetColumnName() = "cvnas" then
			gs_codename = Trim(GetText())
		End If
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		SetColumn("cvcod")
		TriggerEvent(ItemChanged!)
END Choose
end event

type cb_exit from w_inherite`cb_exit within w_sal_04010
int X=2240
int Y=1588
int Width=434
int Height=136
int TabOrder=120
string Text="��  ��(&X)"
end type

type cb_mod from w_inherite`cb_mod within w_sal_04010
int TabOrder=60
boolean Visible=false
end type

type cb_ins from w_inherite`cb_ins within w_sal_04010
int X=1088
int Y=1588
int Width=498
int Height=136
int TabOrder=50
string Text="����ó��(&I)"
end type

event cb_ins::clicked;call super::clicked;String sYM, sArea, sCvcod, sSisangOk
Long   nCnt

If dw_insert.AcceptText() <> 1 Then Return

sYM    = dw_Insert.GetItemString(1, 'ym')
sArea  = dw_Insert.GetItemString(1, 'sarea')
sCvcod = dw_Insert.GetItemString(1, 'cvcod')

If sArea  = '00' or isNull(sArea)  then   sArea  = ''
If sCvcod = '' or isNull(sCvcod) then   sCvcod = ''

If sCvcod <> '' Then
	SELECT SISANG_OK INTO :sSisangOk
	  FROM VNDMST
	 WHERE CVCOD = :sCvcod;
	
	If IsNull(sSisangOk) Then sSisangOk = '' 
	
	If sSisangOk <> 'Y' Then
		f_message_chk(57,'~r~r[�������� �ŷ�ó ���θ� Ȯ���ϼ���]')
		Return
	End If
End If

select count(*) into :nCnt 
  from sugumijasum 
 where ija_yymm = :sYM;

If nCnt > 0 Then
	If MessageBox("Ȯ ��", Left(sYm,4)+'�� '+Right(sYm,2)+'�� �������������� �̹� ó�����ֽ��ϴ�.' + '~r~r' + &
								  '������ �ٽ� ó���� �Ͻðڽ��ϱ�?', + &
								  question!,yesno!, 2) = 2 THEN 
		Return
	end if
Else
	If MessageBox("Ȯ ��", Left(sYm,4)+'�� '+Right(sYm,2)+'�� ������ ���������� ó���մϴ�.' + '~r~r' + &
								  '���ݳ���� ��Ȯ�� �Է��ߴ��� Ȯ���ϼ���' + '~r~r' + &
								  '������������ �ϰ� ó���� �Ͻðڽ��ϱ�?', + &
								  question!,yesno!, 2) = 2 THEN 
		Return
	end if
End If

SetPointer(HourGlass!)

sle_msg.Text = '�������� ����ó���� �Դϴ�........'
SQLCA.ERP000000520(gs_sabu, sYM, sArea+'%', sCvcod+'%')

/* ������������ ���հ� */
//wf_update_hap(sYm)

f_message_Chk(202, '[������������ó��]')	
sle_msg.Text = ''
end event

type cb_del from w_inherite`cb_del within w_sal_04010
int X=1659
int Y=1588
int Width=498
int Height=136
int TabOrder=70
string Text="�������(&D)"
end type

event cb_del::clicked;call super::clicked;String sYM, sArea, sCvcod
Long   nCnt

If dw_insert.AcceptText() <> 1 Then Return

sYM    = dw_Insert.GetItemString(1, 'ym')
sArea  = dw_Insert.GetItemString(1, 'sarea')
sCvcod = dw_Insert.GetItemString(1, 'cvcod')

If sArea  = '00' or isNull(sArea)  then   sArea  = ''
If sCvcod = '' or isNull(sCvcod) then   sCvcod = ''

select count(*) into :nCnt 
  from sugumijasum 
 where ija_yymm = :sYM;

If nCnt > 0 Then
	If MessageBox("Ȯ ��", Left(sYm,4)+'�� '+Right(sYm,2)+'�� �������������� �̹� ó�����ֽ��ϴ�.' + '~r~r' + &
								  '��Ҹ� �Ͻðڽ��ϱ�?', + &
								  question!,yesno!, 2) = 2 THEN 
		Return
	end if
Else
	MessageBox("Ȯ ��","��������ó���� �Ǿ������ʽ��ϴ�")
	Return
End If

SetPointer(HourGlass!)
sle_msg.Text = '�������� ���� ���ó���� �Դϴ�........'

sArea += '%'
sCvcod += '%'
//MessageBox(sym+scvcod,gs_sabu+sarea)
SQLCA.ERP000000525(gs_sabu, sYM, sArea, sCvcod)

If sqlca.sqlcode <> 0 Then
	MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
	RollBack;
	return
End If

commit;

/* ������������ ���հ� */
wf_update_hap(sYm)


f_message_Chk(202, '[������������ ���ó��]')	
sle_msg.Text = ''

end event

type cb_inq from w_inherite`cb_inq within w_sal_04010
int TabOrder=80
boolean Visible=false
end type

type cb_print from w_inherite`cb_print within w_sal_04010
int TabOrder=90
boolean Visible=false
end type

type cb_can from w_inherite`cb_can within w_sal_04010
int TabOrder=100
boolean Visible=false
end type

type cb_search from w_inherite`cb_search within w_sal_04010
int TabOrder=110
boolean Visible=false
end type

type gb_4 from groupbox within w_sal_04010
int X=997
int Y=284
int Width=1829
int Height=636
int TabOrder=20
BorderStyle BorderStyle=StyleRaised!
long TextColor=33554432
long BackColor=67108864
int TextSize=-9
int Weight=400
string FaceName="����ü"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type gb_3 from groupbox within w_sal_04010
int X=997
int Y=896
int Width=1829
int Height=644
int TabOrder=30
BorderStyle BorderStyle=StyleRaised!
long TextColor=33554432
long BackColor=67108864
int TextSize=-9
int Weight=400
string FaceName="����ü"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type gb_2 from groupbox within w_sal_04010
int X=997
int Y=1516
int Width=1829
int Height=260
int TabOrder=40
BorderStyle BorderStyle=StyleRaised!
long TextColor=33554432
long BackColor=67108864
int TextSize=-9
int Weight=400
string FaceName="����ü"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type st_3 from statictext within w_sal_04010
int X=1056
int Y=1032
int Width=1518
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="�� ����ó���� ���ݸ��� �� ó���ϴ°��� ��Ģ������"
boolean FocusRectangle=false
long TextColor=16711680
long BackColor=67108864
int TextSize=-9
int Weight=700
string FaceName="����ü"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type st_4 from statictext within w_sal_04010
int X=1051
int Y=1300
int Width=1737
int Height=68
boolean Enabled=false
boolean BringToTop=true
string Text="�� �̹� �������� ó���� �� �Ŀ� ������ ����, �ű�, ������"
boolean FocusRectangle=false
long TextColor=128
long BackColor=67108864
int TextSize=-9
int Weight=700
string FaceName="����ü"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type st_5 from statictext within w_sal_04010
int X=1047
int Y=1368
int Width=1646
int Height=56
boolean Enabled=false
boolean BringToTop=true
string Text="   ���� ��ü�ŷ�ó ó�� �Ǵ� �ش� Ư���ŷ�ó ���� ó��"
boolean FocusRectangle=false
long TextColor=128
long BackColor=67108864
int TextSize=-9
int Weight=700
string FaceName="����ü"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type st_2 from statictext within w_sal_04010
int X=78
int Y=80
int Width=3488
int Height=1948
boolean Enabled=false
boolean Border=true
BorderStyle BorderStyle=StyleLowered!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-10
int Weight=700
string FaceName="����ü"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

type st_6 from statictext within w_sal_04010
int X=1051
int Y=1168
int Width=1737
int Height=68
boolean Enabled=false
boolean BringToTop=true
string Text="�� ���� ���� ó���ô� ��ü�ŷ�ó(��������ŷ�ó) ����"
boolean FocusRectangle=false
long TextColor=8388736
long BackColor=79741120
int TextSize=-9
int Weight=700
string FaceName="����ü"
FontCharSet FontCharSet=Hangeul!
FontFamily FontFamily=Modern!
FontPitch FontPitch=Fixed!
end type

