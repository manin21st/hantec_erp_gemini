$PBExportHeader$w_sal_01070_1.srw
$PBExportComments$�ְ� �ҿ䷮ ����
forward
global type w_sal_01070_1 from window
end type
type dw_excel from datawindow within w_sal_01070_1
end type
type st_1 from statictext within w_sal_01070_1
end type
type sle_msg from singlelineedit within w_sal_01070_1
end type
type p_exit from uo_picture within w_sal_01070_1
end type
type p_mod from uo_picture within w_sal_01070_1
end type
type dw_add from datawindow within w_sal_01070_1
end type
type gb_1 from groupbox within w_sal_01070_1
end type
type rr_1 from roundrectangle within w_sal_01070_1
end type
end forward

global type w_sal_01070_1 from window
integer x = 951
integer y = 336
integer width = 2642
integer height = 2140
boolean titlebar = true
string title = "�ְ� �ҿ䷮ �ڵ�����"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
dw_excel dw_excel
st_1 st_1
sle_msg sle_msg
p_exit p_exit
p_mod p_mod
dw_add dw_add
gb_1 gb_1
rr_1 rr_1
end type
global w_sal_01070_1 w_sal_01070_1

type variables
string is_date
end variables

forward prototypes
public function integer wf_excel_scan (string arg_file_name, string arg_sabu)
end prototypes

public function integer wf_excel_scan (string arg_file_name, string arg_sabu);string ls_Input_Data
integer li_FileNum,li_cnt,li_rowcnt

string ls_DOCCODE,ls_CUSTCD,ls_FACTORY,ls_ITNBR,ls_IPHDATE,ls_IPNO,ls_IPSOURCE,ls_IPGUBUN,ls_IPBAD_CD
string ls_CONFIRM_NO,ls_IPDATE,ls_ORDERNO,ls_LC_CHA,ls_LC_NO,ls_SHOPCODE,ls_FIL,ls_CRT_DATE,ls_CRT_TIME,ls_CRT_USER
long  ll_IPSEQ,ll_SUBSEQ
double ld_IPHQTY,ld_IPQTY,ld_LC_CHAQTY,ld_LC_CHASUM,ld_PACKQTY,ld_IPAMT,ld_IPDAN,ld_PACKDAN
string ls_MITNBR,ls_MCVCOD,ls_MDCVCOD,ls_citnbr
//���� ����,�ð� 

ls_crt_date = string(today(),'yyyymmdd')
ls_crt_time = string(today(),'hhmm')

li_FileNum = FileOpen(arg_file_name,LineMode!,Read!)
if li_FileNum = -1 then
	messagebox("Ȯ��", "["+arg_file_name+"]"+" VAN�ڷᰡ �����ϴ�.!!")
	return -1
end if

li_cnt = 0
Do While	FileRead(li_FileNum, ls_Input_Data) <> -100
	
//	MessageBox("Msg", ls_Input_Data)

//ls_Input_Data

//	ls_mitnbr = ''
//	ls_mcvcod = ''
//	ls_mdcvcod = ''
//	ls_citnbr = ''
//	li_cnt ++
//	ls_doccode = trim(mid(ls_Input_Data,1,12))
//	// ȭ�ϸ��� ���� �ʵ尪�� üũ
//	if upper(left(right(arg_file_name,6),2)) <> upper(left(ls_doccode,2)) then
//		rollback;
//		messagebox("Ȯ��", "ȭ�ϸ�� ȭ���� �ʵ尪�� Ʋ���ϴ�.")
//		FileClose(li_FileNum)
//		return -2
//	end if
//
//	ls_custcd = trim(mid(ls_Input_Data,13,4))
//	ls_factory = trim(mid(ls_Input_Data,17,2))
//	ls_itnbr = trim(mid(ls_Input_Data,19,15))
//	ls_iphdate = trim(mid(ls_Input_Data,34,8))
//	ls_ipno =  trim(mid(ls_Input_Data,42,4))
//	ls_ipsource = trim(mid(ls_Input_Data,46,1))
//	ls_ipgubun = trim(mid(ls_Input_Data,47,2))
//	//���ܴ��(�԰���) 'C' 
//	if ld_ipqty = 0 then continue
//	
//	ls_ipbad_cd = trim(mid(ls_Input_Data,74,2))
//	ls_confirm_no = trim(mid(ls_Input_Data,76,7))
//	ls_ipdate = trim(mid(ls_Input_Data,93,8))
//	ls_orderno = trim(mid(ls_Input_Data,101,11))
//	//���ܴ��(�԰���) 'A' �̰� ���ֹ�ȣ�� ���� ��
//	IF ls_ipgubun = 'A' AND (isnull(ls_orderno) OR trim(ls_orderno) = '') then continue
//	//���ܴ��(�԰���) 'EE' �̰� ���ֹ�ȣ�� ���� ��
//	IF ls_ipgubun = 'EE' AND (isnull(ls_orderno) OR trim(ls_orderno) = '') then continue
//	//���ܴ��(�԰���) 'OD'
//	IF ls_ipgubun = 'OD' OR ls_ipgubun = '2D' OR ls_ipgubun = 'VC' OR ls_ipgubun = 'OS' then continue
//	
//	ls_lc_cha = trim(mid(ls_Input_Data,112,2))
//	ls_lc_no = trim(mid(ls_Input_Data,128,13))
//	ls_shopcode = trim(mid(ls_Input_Data,156,2))
//	ll_ipseq = long(mid(ls_Input_Data,158,7))
//	ll_subseq = long(mid(ls_Input_Data,165,1))
//	ls_fil = trim(mid(ls_Input_Data,166,3))
//
//	//��ü�ŷ�ó �о����
//	select nvl(RFNA2,' '),nvl(RFNA3,' ')
//	into :ls_mcvcod,:ls_mdcvcod
//	from reffpf
//	where sabu = :arg_sabu and
//			rfcod = '1G' and
//			rfgub = :ls_factory;
//	if sqlca.sqlcode <> 0 or trim(ls_mcvcod)	= '' or trim(ls_mdcvcod) = '' then
////		if not dw_1.visible then
////			dw_list.visible = FALSE
////			dw_1.visible = TRUE
////		end if
////		li_rowcnt = dw_1.insertrow(0)
////		dw_1.setitem(li_rowcnt,'line',li_cnt)
////		dw_1.setitem(li_rowcnt,'doccode',ls_doccode)
////		dw_1.setitem(li_rowcnt,'factory',ls_factory)
////		dw_1.setitem(li_rowcnt,'itnbr',ls_itnbr)
////		dw_1.setitem(li_rowcnt,'err','�������̺�(REFFPF) �ŷ�ó�ڵ尡 �����ϴ�.')
////		dw_1.scrolltorow(li_rowcnt)
//	end if
//		
//	insert into van_hkcd1(SABU,DOCCODE,CUSTCD,FACTORY,ITNBR,IPHDATE,IPNO,IPSOURCE,IPGUBUN,IPHQTY,IPQTY,IPAMT,
//							IPBAD_CD,CONFIRM_NO,IPDAN,IPDATE,ORDERNO,LC_CHA,LC_CHAQTY,LC_CHASUM,LC_NO,PACKDAN,PACKQTY,
//							SHOPCODE,IPSEQ,SUBSEQ,FIL,CRT_DATE,CRT_TIME,CRT_USER,MITNBR,MCVCOD,MDCVCOD,CITNBR)       
//						values(:arg_SABU,:ls_DOCCODE,:ls_CUSTCD,:ls_FACTORY,:ls_ITNBR,:ls_IPHDATE,:ls_IPNO,:ls_IPSOURCE,:ls_IPGUBUN,:ld_IPHQTY,:ld_IPQTY,:ld_IPAMT,
//							:ls_IPBAD_CD,:ls_CONFIRM_NO,:ld_IPDAN,:ls_IPDATE,:ls_ORDERNO,:ls_LC_CHA,:ld_LC_CHAQTY,:ld_LC_CHASUM,:ls_LC_NO,:ld_PACKDAN,:ld_PACKQTY,
//							:ls_SHOPCODE,:ll_IPSEQ,:ll_SUBSEQ,:ls_FIL,:ls_CRT_DATE,:ls_CRT_TIME,:gs_empno,:ls_MITNBR,:ls_MCVCOD,:ls_MDCVCOD,:ls_citnbr);
//		if sqlca.sqlcode <> 0 then
//			rollback;
//			messagebox("Ȯ��", "�ڷᰡ �����ϰų� �Է¿����� �߻��߽��ϴ�.(INSERT)" + '[����ġ:'+string(li_cnt)+']')
//			FileClose(li_FileNum)
//			return 0
//		end if

Loop

commit;

// Txt file close
FileClose(li_FileNum)

//van ���ϸ� ����
//li_cnt = len(trim(arg_file_name))
//li_FileNum = FileCopy(arg_file_name,left(arg_file_name,pos(trim(arg_file_name),".")) + "bak",TRUE)
//if li_FileNum <> 1 then
//	messagebox('error','ȭ�Ϻ��� �����Դϴ�.')
//	return 2
//end if

//van ���� ����
//if not FileDelete(arg_file_name) then 
//	messagebox('error','ȭ�ϻ��� �����Դϴ�.')
//	return 2
//end if

return 1
end function

on w_sal_01070_1.create
this.dw_excel=create dw_excel
this.st_1=create st_1
this.sle_msg=create sle_msg
this.p_exit=create p_exit
this.p_mod=create p_mod
this.dw_add=create dw_add
this.gb_1=create gb_1
this.rr_1=create rr_1
this.Control[]={this.dw_excel,&
this.st_1,&
this.sle_msg,&
this.p_exit,&
this.p_mod,&
this.dw_add,&
this.gb_1,&
this.rr_1}
end on

on w_sal_01070_1.destroy
destroy(this.dw_excel)
destroy(this.st_1)
destroy(this.sle_msg)
destroy(this.p_exit)
destroy(this.p_mod)
destroy(this.dw_add)
destroy(this.gb_1)
destroy(this.rr_1)
end on

event open;f_window_center_response(this)

dw_add.settransobject(sqlca)
dw_excel.settransobject(sqlca)
dw_add.retrieve()

is_date = gs_code

SetNull(gs_code)
end event

type dw_excel from datawindow within w_sal_01070_1
boolean visible = false
integer x = 2021
integer y = 24
integer width = 165
integer height = 124
integer taborder = 90
string title = "none"
string dataobject = "d_sal_01070_xls"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_sal_01070_1
integer x = 229
integer y = 52
integer width = 1221
integer height = 48
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 32106727
string text = "�ŷ�ó�� ���⿩�� = ~'Y~'�� ��ü�� ��ȸ�˴ϴ�."
boolean focusrectangle = false
end type

type sle_msg from singlelineedit within w_sal_01070_1
integer x = 50
integer y = 1920
integer width = 2487
integer height = 84
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type p_exit from uo_picture within w_sal_01070_1
integer x = 2373
integer y = 12
integer width = 178
integer taborder = 80
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\�ݱ�_up.gif"
end type

event clicked;call super::clicked;CloseWithReturn(parent,-1)	

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\�ݱ�_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\�ݱ�_up.gif"
end event

type p_mod from uo_picture within w_sal_01070_1
integer x = 2199
integer y = 12
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\����_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\����_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\����_up.gif"
end event

event clicked;call super::clicked;Long Lrow, Lcnt, i, j, ll_count
string scvcod, schoi, scvnas, pathname, filename, ls_date1, ls_date2, ls_cvcod1, ls_cvcod2, ls_itnbr1, ls_itnbr2
integer value
int    iRtnValue = -1
double ditemprice,ddcrate,dItemqty,dQtyRate

if dw_add.accepttext()  = -1 then return

For Lrow = 1 to dw_add.rowcount()
	
	Lcnt = 0
	scvcod = dw_add.getitemstring(Lrow, "cvcod")
	scvnas = dw_add.getitemstring(Lrow, "cvnas")
	 
	sle_msg.text = scvnas + " ������"
	 
	schoi =  dw_add.getitemstring(Lrow, "gbn") 
	
	if schoi = '1' then
		Lcnt = sqlca.van_weekplan1(gs_sabu, is_date, scvcod);
	Elseif schoi = '2' then
		Lcnt = sqlca.van_weekplan2(gs_sabu, is_date, scvcod);
	ElseIf schoi ='4' Then

		value = GetFileOpenName("����", pathname, filename, "Text","Text Files (*.txt),*.txt")
		
		if value = 0 THEN return

		if value <> 1 then
			MessageBox("���� ������ ����","����Ƿ� ���� �ϼ���!")
			sle_msg.text = " ��������"
	   	return
		end if
	
		dw_excel.ImportFile(pathname,2)	

		For i = 1 to dw_excel.Rowcount()
			
			ls_date1  = dw_excel.GetItemString( i, "plan_ymd")
			ls_cvcod1 = dw_excel.GetItemString( i, "cvcod")
			ls_itnbr1 = dw_excel.GetItemString( i, "itnbr")
			
			If IsNull(ls_date1) or ls_date1 = '' Then 
				MessageBox("Error", String(i + 1) + ' Line�� ��ȹ ������� �����ϴ�.')
				sle_msg.text = " ������ Error �߻�"
				return
			End If

			If IsNull(ls_cvcod1) or ls_cvcod1 = '' Then 
				MessageBox("Error", String(i + 1) + ' Line�� �ŷ�ó �ڵ尡 �����ϴ�.')
				sle_msg.text = " ������ Error �߻�"
				return
			End If
			
			If IsNull(ls_itnbr1) or ls_itnbr1 = '' Then 
				MessageBox("Error", String(i + 1) + ' Line�� ��ǰ���� �����ϴ�.')
				sle_msg.text = " ������ Error �߻�"
				return
			End If
			
			Select Count(*) Into :ll_count
			From WEEKSAPLAN
			Where sabu    =  :gs_sabu 
			and   plan_ymd = :ls_date1
			and   cvcod    = :ls_cvcod1
			and   itnbr    = :ls_itnbr1;
			
			If ll_count > 0 Then
				Delete From WEEKSAPLAN
				Where sabu    =  :gs_sabu 
				and   plan_ymd = :ls_date1
				and   cvcod    = :ls_cvcod1
				and   itnbr    = :ls_itnbr1;
			End If
			
			iRtnValue  = sqlca.Fun_Erp100000016(gs_sabu, ls_date1, ls_cvcod1, ls_itnbr1, & 
															'.', 'WON','1', dItemPrice, dDcRate)

			/* Ư��ܰ��� �ŷ�ó�ܰ��ϰ�� ������ �������� ������� */
			If iRtnValue = 1 Or iRtnValue = 3 Then		dQtyRate = 0

			/* �⺻������ ����ܰ� * ������ ������ */
			If dQtyRate <> 0 Then
				dItemPrice = dItemPrice * (100 - dQtyRate)/100
				/* ������5�ڸ� */
				dItemPrice = Truncate(dItemPrice , 5)
			End If
	
			dw_excel.SetItem(i, "sabu", gs_sabu)
			dw_excel.SetItem(i, "wonsrc", dItemPrice)
			dw_excel.SetItem(i, "plan_weekhist", f_today())
			
			For j = i + 1 to dw_excel.Rowcount()
				ls_date2  = dw_excel.GetItemString( j, "plan_ymd")
				ls_cvcod2 = dw_excel.GetItemString( j, "cvcod")
				ls_itnbr2 = dw_excel.GetItemString( j, "itnbr")
				
				If ls_date1 = ls_date2 And ls_cvcod1 = ls_cvcod2 And ls_itnbr1 = ls_itnbr2 Then
					MessageBox("Error", String(j + 1) + ' Line Error �ߺ����� �ֽ��ϴ�.~r~r' + & 
					          "��ȹ���:" + ls_date2 + ", �ŷ�ó �ڵ�:" + ls_cvcod2 + ", ǰ��:" +ls_itnbr2 )
					sle_msg.text = " ������ Error �߻�"
					return
				End If
			Next
		Next
		
		If dw_excel.update() <> 1 Then 
			MessageBox("Ȯ��", "�ڷ� ������ �����߽��ϴ�.")
			sle_msg.text = " ��������"
			ROLLBACK;
			return
		Else
			Commit;
		End If
	End if;

	dw_add.setitem(Lrow, "cnt", Lcnt)
	 	
Next

sle_msg.text = "�����Ϸ�"


end event

type dw_add from datawindow within w_sal_01070_1
event ue_pressenter pbm_dwnprocessenter
integer x = 55
integer y = 188
integer width = 2478
integer height = 1680
integer taborder = 20
string dataobject = "d_sal_01070_1_01"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemerror;return 1
end event

event itemchanged;long   i

For i = 1 to dw_add.rowcount() 
	If row <> i Then
		If data = '4' and dw_add.GetItemString(i,"gbn") = '4' Then
			dw_add.SetItem(i, "gbn" ,'3')
		End If
	End If
Next

end event

type gb_1 from groupbox within w_sal_01070_1
integer x = 41
integer y = 1884
integer width = 2523
integer height = 132
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 32106727
end type

type rr_1 from roundrectangle within w_sal_01070_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 172
integer width = 2523
integer height = 1708
integer cornerheight = 40
integer cornerwidth = 55
end type

