$PBExportHeader$w_sal_05940.srw
$PBExportComments$���� ������ ��Ȳ
forward
global type w_sal_05940 from w_standard_print
end type
type dw_rate from datawindow within w_sal_05940
end type
end forward

global type w_sal_05940 from w_standard_print
string title = "���� ������ ��Ȳ"
long backcolor = 80859087
dw_rate dw_rate
end type
global w_sal_05940 w_sal_05940

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string	syear1,syear2
int      ix,iy,nRow,iord,rcnt,row, jumsu
dec      ord1,ord2
dec      maechul,dals_rate,sungi_rank

//////////////////////////////////////////////////////////////////
If dw_ip.accepttext() <> 1 Then Return -1

syear1  = dw_ip.GetItemString(1,'syear')

IF	IsNull(syear1) or syear1 = '' then
	f_message_chk(1400,'[���س⵵]')
	dw_ip.setcolumn('syear')
	dw_ip.setfocus()
	Return -1
END IF

syear2 = String(long(syear1) -1 )

dw_list.SetRedraw(False)

string ls_silgu

SELECT DATANAME
INTO  :ls_silgu
FROM  SYSCNFG
WHERE SYSGU = 'S' AND SERIAL = '8' AND LINENO = '40' ;

/* �� ����Ÿ ��ȸ */
nRow = dw_list.retrieve(gs_sabu, syear1, syear2,ls_silgu)
If nRow < 1	Then
	f_message_chk(50,"")
	dw_ip.setcolumn('syear')
	dw_ip.setfocus()
	dw_list.SetRedraw(True)
	Return -1
End if


/* ������� */
Rcnt = dw_rate.Retrieve(gs_sabu, syear1,'1') /* �򰡱������� */
For ix = 1 To nRow
	maechul = dw_list.GetItemNumber(ix,'maechul')
   row = dw_rate.Find("par_value <= " + string(maechul),1,Rcnt)	
	
   If Rcnt > 0 and row > 0 Then
   	jumsu = dw_rate.GetItemNumber(row,'par_jumsu')
   Else
   	jumsu = 0
   End If
	dw_list.SetItem(ix,'sales_jumsu',jumsu)
Next

/* ��ǥ�޼��� */
Rcnt = dw_rate.Retrieve(gs_sabu, syear1,'2') /* �򰡱������� */
For ix = 1 To nRow
	dals_rate = dw_list.GetItemNumber(ix,'dals_rate')
	
	dals_rate = Truncate(dals_rate * 100,0)
	/* �޼����� 100%�̻��̸� �ʰ� 1%�� 1���� ���� */
	If dals_rate > 100 Then 
		row = dw_rate.Find("par_value <= " + string(100),1,Rcnt)	
		If Rcnt > 0 and row > 0 Then
			jumsu = dw_rate.GetItemNumber(row,'par_jumsu')
			If IsNull(jumsu ) Then jumsu = 0
			
			jumsu = jumsu + ( dals_rate - 100 )
		Else
			jumsu = 0
		End If
	Else
		row = dw_rate.Find("par_value <= " + string(dals_rate),1,Rcnt)	
		If Rcnt > 0 and row > 0 Then
			jumsu = dw_rate.GetItemNumber(row,'par_jumsu')
		Else
			jumsu = 0
		End If
	End If
	
	dw_list.SetItem(ix,'dals_jumsu',jumsu)
Next

/* ��������� ���� ���� ���� */
For ix = 1 To ( nRow - 1 )
	For iy = ix + 1 To nRow
       ord1 = dw_list.GetItemNumber(ix,'sungj_rate')
       ord2 = dw_list.GetItemNumber(iy,'sungj_rate')
		 
		 Choose Case ( ord1 - ord2 )
			Case is > 0
				iord = dw_list.GetItemNumber(iy,'sungj_rank')
				iord += 1
				dw_list.SetItem(iy,'sungj_rank',iord)
			Case is < 0
				iord = dw_list.GetItemNumber(ix,'sungj_rank')
				iord += 1
				dw_list.SetItem(ix,'sungj_rank',iord)
		End Choose
	Next
Next


Rcnt = dw_rate.Retrieve(gs_sabu, syear1,'3') /* �򰡱������� */
dw_rate.SetSort('par_value')
dw_rate.Sort()

For ix = nRow To 1 Step -1
	sungi_rank = dw_list.GetItemNumber(ix,'sungj_rank')
	
	/* ������������ 20���̸��̸� ���� */
	If sungi_rank > 20 Then 
		dw_list.DeleteRow(ix)
		continue
	End If
	
   row = dw_rate.Find("par_value >= " + string(sungi_rank),1,Rcnt)	
   If Rcnt > 0 and row > 0 Then
   	jumsu = dw_rate.GetItemNumber(row,'par_jumsu')
   Else
   	jumsu = 0
   End If
	dw_list.SetItem(ix,'sungj_jumsu',jumsu)	
Next

/* ���ռ��� ���� */
dw_list.SetSort('tot_jumsu d, maechul d, sungj_rate d')
dw_list.Sort()

For ix = 1 To dw_list.RowCount()
	dw_list.SetItem(ix,'total_rank',ix)
Next

dw_list.SetRedraw(True)

Return 1
end function

on w_sal_05940.create
int iCurrent
call super::create
this.dw_rate=create dw_rate
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_rate
end on

on w_sal_05940.destroy
call super::destroy
destroy(this.dw_rate)
end on

event open;call super::open;dw_ip.SetItem(1,'syear',Left(f_today(),4))

dw_rate.SetTransObject(sqlca)
sle_msg.text = "��¹� - ����ũ�� : A4, ��¹��� : ���ι���"
end event

type p_preview from w_standard_print`p_preview within w_sal_05940
end type

type p_exit from w_standard_print`p_exit within w_sal_05940
end type

type p_print from w_standard_print`p_print within w_sal_05940
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_05940
end type







type st_10 from w_standard_print`st_10 within w_sal_05940
end type



type dw_print from w_standard_print`dw_print within w_sal_05940
end type

type dw_ip from w_standard_print`dw_ip within w_sal_05940
integer x = 37
integer y = 108
integer width = 745
integer height = 176
string dataobject = "d_sal_050702"
end type

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_sal_05940
integer x = 805
integer width = 2807
integer height = 2016
string dataobject = "d_sal_05940"
end type

event dw_list::retrievestart;This.SetRedraw(False)
end event

event dw_list::retrieveend;This.SetRedraw(True)
end event

type dw_rate from datawindow within w_sal_05940
boolean visible = false
integer x = 608
integer y = 2348
integer width = 960
integer height = 360
integer taborder = 70
boolean bringtotop = true
string dataobject = "d_sal_05060"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

