$PBExportHeader$w_sal_05925.srw
$PBExportComments$�ŷ�ó ���������� ��Ȳ
forward
global type w_sal_05925 from w_standard_print
end type
end forward

global type w_sal_05925 from w_standard_print
string title = "�ŷ�ó �������� ��Ȳ"
long backcolor = 80859087
end type
global w_sal_05925 w_sal_05925

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string	syymm
string   s_year,s_pyear,s_mm
int      ix,iy,nRow,iord
double   pmaechul
dec      ord1,ord2
//////////////////////////////////////////////////////////////////
If dw_ip.accepttext() <> 1 Then Return -1

syymm     = trim(dw_ip.getitemstring(1,'syymm'))
pmaechul  = dw_ip.getitemNumber(1,'dpmaechul')

IF	f_datechk(syymm+'01') <> 1 then
	f_message_chk(1400,'[���Ⱓ]')
	dw_ip.setcolumn('syymm1')
	dw_ip.setfocus()
	Return -1
END IF

If IsNull(pmaechul) Then pmaechul = 0
s_year = Left(syymm,4)
s_pyear = String(Long(s_year) -1)
s_mm   = Right(syymm,2)

////////////////////////////////////////////////////////////////
dw_list.SetRedraw(False)

SetPointer(HourGlass!)

string ls_silgu

SELECT DATANAME
INTO  :ls_silgu
FROM  SYSCNFG
WHERE SYSGU = 'S' AND SERIAL = '8' AND LINENO = '40' ;

nRow = dw_list.retrieve(s_year,s_pyear,s_mm, pmaechul,ls_silgu)
if nRow < 1	then
	f_message_chk(50,"")
	dw_ip.setcolumn('syymm')
	dw_ip.setfocus()
	return -1
end if

/* skip : ���⵵ ����ո������ 1500���� ���� �븮�� ���� : sql where�� ���Ե�*/

/* ���� ��� */
For ix = 1 To ( nRow - 1 )
	For iy = ix + 1 To nRow
		
		 /* ����� */
       ord1 = dw_list.GetItemNumber(ix,'maechul')
       ord2 = dw_list.GetItemNumber(iy,'maechul')
		 
		 Choose Case ( ord1 - ord2 )
			Case is > 0
				iord = dw_list.GetItemNumber(iy,'maechul_order')
				iord += 1
				dw_list.SetItem(iy,'maechul_order',iord)
			Case is < 0
				iord = dw_list.GetItemNumber(ix,'maechul_order')
				iord += 1
				dw_list.SetItem(ix,'maechul_order',iord)
		End Choose

		 /* ������ */
       ord1 = dw_list.GetItemNumber(ix,'sinjangrate')
       ord2 = dw_list.GetItemNumber(iy,'sinjangrate')
		 
		 Choose Case ( ord1 - ord2 )
			Case is > 0
				iord = dw_list.GetItemNumber(iy,'sinjang_order')
				iord += 1
				dw_list.SetItem(iy,'sinjang_order',iord)
			Case is < 0
				iord = dw_list.GetItemNumber(ix,'sinjang_order')
				iord += 1
				dw_list.SetItem(ix,'sinjang_order',iord)
		End Choose

		/* ���ݾ� ,�� �̼����� '-'�̸� �켱 ó�� */
		ord1 = dw_list.GetItemNumber(ix,'misugum')
		ord2 = dw_list.GetItemNumber(iy,'misugum')
		If IsNull(ord1) Then ord1 = 0
		If IsNull(ord2) Then ord2 = 0
			
		/* ��ȣ�� ���� �ݴ��� ��� '-'�� �켱 */
		If ord1 < 0 or ord2 < 0 Then
			If ord1 < 0 and ord2 < 0 Then
				Choose Case ( abs(ord1) - abs(ord2) )
					Case is > 0
						iord = dw_list.GetItemNumber(iy,'sugum_order')
						iord += 1
						dw_list.SetItem(iy,'sugum_order',iord)
					Case is < 0
						iord = dw_list.GetItemNumber(ix,'sugum_order')
						iord += 1
						dw_list.SetItem(ix,'sugum_order',iord)
				End Choose
			ElseIf ord1 < 0 Then
				iord = dw_list.GetItemNumber(iy,'sugum_order')
				iord += 1
				dw_list.SetItem(iy,'sugum_order',iord)
			Else
				iord = dw_list.GetItemNumber(ix,'sugum_order')
				iord += 1
				dw_list.SetItem(ix,'sugum_order',iord)
			End If
		Else
			ord1 = dw_list.GetItemNumber(ix,'maesugum')
			ord2 = dw_list.GetItemNumber(iy,'maesugum')
			
			If IsNull(ord1) Then ord1 = 0
			If IsNull(ord2) Then ord2 = 0
			
			Choose Case ( ord1 - ord2 )
				Case is > 0
					iord = dw_list.GetItemNumber(iy,'sugum_order')
					iord += 1
					dw_list.SetItem(iy,'sugum_order',iord)
				Case is < 0
					iord = dw_list.GetItemNumber(ix,'sugum_order')
					iord += 1
					dw_list.SetItem(ix,'sugum_order',iord)
			End Choose
		End If
	Next
Next

// Total rank
For ix = 1 To ( nRow - 1 )
	For iy = ix + 1 To nRow
       ord1 = dw_list.GetItemNumber(ix,'sum_order')
       ord2 = dw_list.GetItemNumber(iy,'sum_order')
		 
		 Choose Case ( ord1 - ord2 )
			Case is > 0
				iord = dw_list.GetItemNumber(ix,'total_order')
				iord += 1
				dw_list.SetItem(ix,'total_order',iord)
			Case is < 0
				iord = dw_list.GetItemNumber(iy,'total_order')
				iord += 1
				dw_list.SetItem(iy,'total_order',iord)
			/* ������ ��� ������ �켱 */	
			Case  0
				 ord1 = dw_list.GetItemNumber(ix,'sinjangrate')
				 ord2 = dw_list.GetItemNumber(iy,'sinjangrate')
				 
				 Choose Case ( ord1 - ord2 )
					Case is > 0
						iord = dw_list.GetItemNumber(iy,'total_order')
						iord += 1
						dw_list.SetItem(iy,'total_order',iord)
					Case is < 0
						iord = dw_list.GetItemNumber(ix,'total_order')
						iord += 1
						dw_list.SetItem(ix,'total_order',iord)
				End Choose
		End Choose
	Next
Next

dw_list.SetSort('total_order ')
dw_list.Sort()

dw_list.SetRedraw(True)
Return 1


end function

on w_sal_05925.create
call super::create
end on

on w_sal_05925.destroy
call super::destroy
end on

event open;call super::open;String sPMaechulAmt
Double dPMaechulAmt

select Rtrim(dataname) into :sPMaechulAmt
  from syscnfg
 where sysgu = 'S' and
       serial = 4 and
       lineno = 30;

If IsNumber(sPMaechulAmt) Then 
	dPMaechulAmt = Double(sPMaechulAmt)
Else
	dPMaechulAmt = 15000000
End If

dw_ip.SetItem(1,'syymm',Left(f_today(),6))
dw_ip.SetItem(1,'dpmaechul',dPMaechulAmt)

sle_msg.text = "��¹� - ����ũ�� : A4, ��¹��� : ���ι���"
end event

type p_preview from w_standard_print`p_preview within w_sal_05925
end type

type p_exit from w_standard_print`p_exit within w_sal_05925
end type

type p_print from w_standard_print`p_print within w_sal_05925
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_05925
end type







type st_10 from w_standard_print`st_10 within w_sal_05925
end type



type dw_print from w_standard_print`dw_print within w_sal_05925
end type

type dw_ip from w_standard_print`dw_ip within w_sal_05925
integer x = 37
integer y = 108
integer width = 745
integer height = 508
string dataobject = "d_sal_05925_01"
end type

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_sal_05925
integer x = 805
integer width = 2807
integer height = 2056
string dataobject = "d_sal_05925"
end type

event dw_list::retrievestart;This.SetRedraw(False)
end event

event dw_list::retrieveend;This.SetRedraw(True)
end event

