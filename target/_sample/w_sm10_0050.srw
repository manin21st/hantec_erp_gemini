$PBExportHeader$w_sm10_0050.srw
$PBExportComments$VAN ����
forward
global type w_sm10_0050 from w_inherite
end type
type p_1 from uo_picture within w_sm10_0050
end type
type p_dellrow_all from uo_picture within w_sm10_0050
end type
type rb_1 from radiobutton within w_sm10_0050
end type
type rb_2 from radiobutton within w_sm10_0050
end type
type gb_1 from groupbox within w_sm10_0050
end type
type pb_1 from u_pic_cal within w_sm10_0050
end type
type pb_2 from u_pic_cal within w_sm10_0050
end type
type p_2 from picture within w_sm10_0050
end type
end forward

global type w_sm10_0050 from w_inherite
string title = "MOBIS AUTO VAN ���"
p_1 p_1
p_dellrow_all p_dellrow_all
rb_1 rb_1
rb_2 rb_2
gb_1 gb_1
pb_1 pb_1
pb_2 pb_2
p_2 p_2
end type
global w_sm10_0050 w_sm10_0050

type variables
Long il_succeed , il_err
end variables

forward prototypes
public function string wf_choose (string as_gubun)
public function integer wf_sch (string as_file)
public function integer wf_sil (string as_file)
public subroutine wf_init ()
public function long wf_itnbr_insert (string ar_itnbr, string ar_itdsc)
public function integer wf_ckd_b (string as_file)
public function integer wf_ckd_b_wp (string as_file)
public subroutine wf_excel_down (datawindow adw_excel)
end prototypes

public function string wf_choose (string as_gubun);Choose Case as_gubun
	Case '1'
		
		dw_insert.DataObject = 'd_sm10_0050_sch'
		dw_insert.SetTransObject(SQLCA)
		If rb_2.Checked Then
			dw_input.Modify("t_hi.visible = 1 ")
			dw_input.Modify("jisi_date.visible = 1")
			dw_input.Modify("jisi_date2.visible = 1")
			dw_input.Modify("jisi_mon.visible = 0")
			
			pb_1.visible = True
			pb_2.visible = True
		End If

		return 'C:\MOBIS\�ҿ��ȹ.XLS'
	Case '2'
		
		dw_insert.DataObject = 'd_sm10_0050_sil'
		dw_insert.SetTransObject(SQLCA)
		If rb_2.Checked Then
			dw_input.Modify("t_hi.visible = 0 ")
			dw_input.Modify("jisi_date.visible = 0")
			dw_input.Modify("jisi_date2.visible = 0")
			dw_input.Modify("jisi_mon.visible = 1")
			pb_1.visible = False
			pb_2.visible = False
		End If
		return 'C:\MOBIS\�ϻ������.XLS'
	Case '3'
		
		dw_insert.DataObject = 'd_sm10_0050_ckd_b'
		dw_insert.SetTransObject(SQLCA)
		If rb_2.Checked Then
			dw_input.Modify("t_hi.visible = 1 ")
			dw_input.Modify("jisi_date.visible = 1")
			dw_input.Modify("jisi_date2.visible = 1")
			dw_input.Modify("jisi_mon.visible = 0")
			
			pb_1.visible = True
			pb_2.visible = True
		End If
		return 'C:\MOBIS\CKD������Ȳ.XLS'
	Case '4'
		
		dw_insert.DataObject = 'd_sm10_0050_ckd_b_wp'
		dw_insert.SetTransObject(SQLCA)
		If rb_2.Checked Then
			dw_input.Modify("t_hi.visible = 1")
			dw_input.Modify("jisi_date.visible = 1")
			dw_input.Modify("jisi_date2.visible = 1")
			dw_input.Modify("jisi_mon.visible = 0")
			
			pb_1.visible = True
			pb_2.visible = True
		End If
		Return 'C:\MOBIS\WP������Ȳ.XLS'
		//Return 'C:\MOBIS\���� ���� ��Ȳ.XLS'
End Choose
end function

public function integer wf_sch (string as_file);String ls_saupj , ls_cvcod , ls_ymd ,ls_gubun ,ls_itnbr , ls_mitnbr , ls_itdsc , ls_factory , ls_plant
uo_xlobject uo_xl
string ls_docname, ls_named ,ls_line 
Long   ll_xl_row , ll_r , i , ll_cnt=0 , ll_c

String ls_crt_date , ls_crt_time , ls_crt_user

If dw_input.AcceptText() <> 1 Then Return -1

ls_ymd   = Trim(dw_input.Object.jisi_date[1]) 
//ls_cvcod = Trim(dw_input.Object.mcvcod[1]) 
ls_saupj = Trim(dw_input.Object.saupj[1]) 


ls_crt_date = string(today(),'yyyymmdd')
ls_crt_time = string(today(),'hhmm')
ls_crt_user = gs_userid 

// ���� IMPORT ***************************************************************

//ll_value = GetFileOpenName("������ȹ VAN ����Ÿ ��������", ls_docname, ls_named, & 
//             "XLS", "XLS Files (*.XLS),*.XLS,")
//
//If ll_value <> 1 Then Return


dw_insert.Reset()

w_mdi_frame.sle_msg.text =''

Setpointer(Hourglass!)

uo_xl = create uo_xlobject
		
//������ ����
uo_xl.uf_excel_connect(as_file, false , 3)

uo_xl.uf_selectsheet(1)

//Data ���� Row Setting
ll_xl_row =2

il_err = 0
il_succeed = 0

Integer li_find

Do While(True)
	
	//Data�� ������쿣 Return...........
	if isnull(uo_xl.uf_gettext(ll_xl_row,1)) or trim(uo_xl.uf_gettext(ll_xl_row,1)) = '' then exit
	
	ll_r = dw_insert.InsertRow(0) 
	ll_cnt++
	
	dw_insert.Scrolltorow(ll_r)

	For i =1 To 50
		uo_xl.uf_set_format(ll_xl_row,i, '@' + space(30))
		
	Next
	
	ls_itnbr = Trim(uo_xl.uf_gettext(ll_xl_row,1))
	ls_plant = Trim(uo_xl.uf_gettext(ll_xl_row,2))
	
	if isnull(ls_itnbr) or trim(ls_itnbr) = '' then exit
	 
	Select rfgub, rfna2 Into :ls_factory ,:ls_cvcod 
	  From Reffpf
	 Where rfcod = '2A'
	   and rfgub != '00'
	   and rfgub = 'M'||:ls_plant ;
		
	if sqlca.sqlcode <> 0 or trim(ls_factory) = '' or isNull(ls_factory) then
		
		dw_insert.Object.ITDSC[ll_r]     =    "�̵�� ����"
		il_err++
		ll_xl_row ++
		Continue ;
	Else
		ls_factory = 'M'+ls_plant
	End IF

	select itnbr , itdsc 
	  into :ls_mitnbr , :ls_itdsc
	  from itemas
	 where itnbr = :ls_itnbr ;
//	 where replace(itnbr,'-','') = :ls_itnbr ;
	 
	if sqlca.sqlcode <> 0 or trim(ls_mitnbr) = '' or isNull(ls_mitnbr) then
		
//		ls_mitnbr = trim(left(ls_itnbr,5))+'-'+trim(mid(ls_itnbr,6,20))
//		
//		If wf_itnbr_insert( ls_mitnbr , ls_itdsc ) < 0 Then
			il_err++
			ll_xl_row ++
			continue ;
//		end if
	End IF
		
	Select Count(*) Into :ll_c
	  From van_mobis_auto_sch
	  Where saupj = :ls_saupj
		 and sch_ymd = :ls_ymd
		 and factory = :ls_factory
		 and itnbr = :ls_itnbr ;
		 
	If ll_c > 0 Or sqlca.sqlcode <> 0 Then
		MessageBox('Ȯ��','�ش� ��¥�� �̹� ��ϵ� ��ȹ�Դϴ�.')
		w_mdi_frame.sle_msg.text ='�ش� ��¥�� �̹� ��ϵ� ��ȹ�Դϴ�.'
		Return -1
	End If
		
	dw_insert.Object.SAUPJ[ll_r]     =    ls_saupj
	dw_insert.Object.SCH_YMD[ll_r]   =    ls_ymd
	dw_insert.Object.FACTORY[ll_r]   =    ls_factory
	dw_insert.Object.ITNBR[ll_r]     =    ls_itnbr

	dw_insert.Object.DAY_ITEM[ll_r]  =    Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,3))))
	dw_insert.Object.DAY_ITEM1[ll_r] =    Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,4))))
	dw_insert.Object.DAY_ITEM2[ll_r] =    Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,5))))
	dw_insert.Object.DAY_ITEM3[ll_r] =    Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,6))))
	dw_insert.Object.DAY_ITEM4[ll_r] =    Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,7))))
	dw_insert.Object.DAY_ITEM5[ll_r] =    Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,8))))
	dw_insert.Object.DAY_ITEM6[ll_r] =    Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,9))))
	dw_insert.Object.DAY_ITEM7[ll_r] =    Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,10))))
	dw_insert.Object.DAY_ITEM8[ll_r] =    Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,11))))
	dw_insert.Object.DAY_ITEM9[ll_r] =    Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,12))))
	dw_insert.Object.DAY_ITEM10[ll_r] =   Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,13))))
	dw_insert.Object.DAY_ITEM11[ll_r] =   Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,14))))
	dw_insert.Object.CRT_DATE[ll_r]   =   ls_crt_date
	dw_insert.Object.CRT_TIME[ll_r]   =   ls_crt_time
	dw_insert.Object.CRT_USER[ll_r]   =   ls_crt_user
	dw_insert.Object.MITNBR[ll_r]     =   ls_mitnbr
	dw_insert.Object.MCVCOD[ll_r]     =   ls_cvcod
	dw_insert.Object.MDCVCOD [ll_r]   =   ls_cvcod
	
	/* DB�ߺ� �� Excel ������ �ߺ��ڷ�� üũ �����Ǿ� ���� : �����ڷ� �ߺ�Ȯ�� �߰� - by shingoon 2013.02.04 */
	If ll_r > 1 Then
		li_find = dw_insert.Find("saupj = '" + ls_saupj + "' and sch_ymd = '" + ls_ymd + "' and factory = '" + ls_factory + "' and itnbr = '" + ls_itnbr + "'", 1, ll_r - 1)
		If li_find > 0 Then
			MessageBox("���� �ߺ��ڷ� �߻�", String(li_find) + "��� " + String(ll_r) + "���� �ڷᰡ �ߺ��Դϴ�.~r~n���� ������ �ڷḦ Ȯ�� �Ͻð�~r~n�ߺ� �ڷḦ �����Ͻ� �� ���� �Ͻʽÿ�.")
			Return -1
		End If
	End If
	  
	ll_xl_row ++
	
	il_succeed++
	
Loop

dw_insert.AcceptText()

If dw_insert.Update() < 1 Then
	Rollback;
	MessageBox('Ȯ��','�������')
	Return -1
Else
	Commit;
End if

w_mdi_frame.sle_msg.text ='�ѰǼ� :'+String(ll_cnt) + '(���� : '+String(il_err)+',���� :'+String(il_succeed) + ') ����Ÿ ó���� �Ͽ����ϴ�.'
uo_xl.uf_excel_Disconnect()
dw_insert.AcceptText()
// ���� IMPORT  END ***************************************************************

Return ll_cnt
end function

public function integer wf_sil (string as_file);String ls_saupj , ls_cvcod , ls_ymd ,ls_gubun ,ls_itnbr , ls_mitnbr  , ls_itdsc ,ls_factory , ls_plant
uo_xlobject uo_xl
string ls_docname, ls_named ,ls_line, ls_ymd2
Long   ll_xl_row , ll_r , i , ll_cnt=0 ,ll_c

String ls_crt_date , ls_crt_time , ls_crt_user

If dw_input.AcceptText() <> 1 Then Return -1

ls_ymd   = Trim(dw_input.Object.jisi_date[1])

SELECT TO_CHAR((TO_DATE(:ls_ymd,'YYYYMMDD')-1),'YYYYMMDD') INTO :ls_ymd2 FROM dual;

ls_ymd   = Left(ls_ymd2 ,6)

//ls_cvcod = Trim(dw_input.Object.mcvcod[1]) 
ls_saupj = Trim(dw_input.Object.saupj[1]) 

dw_insert.Reset()

w_mdi_frame.sle_msg.text =''

Setpointer(Hourglass!)

uo_xl = create uo_xlobject
		
//������ ����
uo_xl.uf_excel_connect(as_file, false , 3)

uo_xl.uf_selectsheet(1)

//Data ���� Row Setting
ll_xl_row =4

il_err = 0
il_succeed = 0

Do While(True)
	
	For i =1 To 50
		uo_xl.uf_set_format(ll_xl_row,i, '@' + space(30))
		
	Next
	
//	If mod(ll_xl_row,3) = 1 Then

		//Data�� ������쿣 Return...........
		if isnull(uo_xl.uf_gettext(ll_xl_row,1)) or trim(uo_xl.uf_gettext(ll_xl_row,1)) = '' then exit
	
		ll_cnt++
		
		ls_itnbr = Trim(uo_xl.uf_gettext(ll_xl_row,1))
		ls_plant = Trim(uo_xl.uf_gettext(ll_xl_row,2))
		
		Select rfgub ,rfna2 Into :ls_factory ,:ls_cvcod
		  From Reffpf
		 Where rfcod = '2A'
			and rfgub != '00'
			and rfgub = 'M'||:ls_plant ;
			
		if sqlca.sqlcode <> 0 or trim(ls_factory) = '' or isNull(ls_factory) then
			
			//dw_insert.Object.ITDSC[ll_r]     =    "�̵�� ����"
			il_err++
			ll_xl_row ++
			Continue ;
		Else
			ls_factory = 'M'+ls_plant
		End IF
		
		select itnbr , itdsc 
		  into :ls_mitnbr , :ls_itdsc
		  from itemas
		 where itnbr = :ls_itnbr ;
//		 where replace(itnbr,'-','') = :ls_itnbr ;
			
		if sqlca.sqlcode <> 0 or trim(ls_mitnbr) = '' or isNull(ls_mitnbr) then
			
			//dw_insert.Object.ITDSC[ll_r]     =    "�̵�� ǰ��"
			il_err++
			ll_xl_row ++
			Continue ;

		End IF
		
		ll_r = dw_insert.InsertRow(0) 
		dw_insert.Scrolltorow(ll_r)
		
		dw_insert.Object.SAUPJ[ll_r] =       ls_saupj         
		dw_insert.Object.SIL_MON[ll_r] =     ls_ymd
		dw_insert.Object.FACTORY[ll_r] =     ls_factory
		dw_insert.Object.ITNBR[ll_r] =       Trim(uo_xl.uf_gettext(ll_xl_row,1))
		dw_insert.Object.ITDSC[ll_r]  = 		 ls_itdsc
		dw_insert.Object.CRT_DATE[ll_r] =    ls_crt_date
		dw_insert.Object.CRT_TIME[ll_r] =    ls_crt_time
		dw_insert.Object.CRT_USER[ll_r] =    ls_crt_user
		dw_insert.Object.MITNBR[ll_r] =      ls_mitnbr
		dw_insert.Object.MCVCOD[ll_r] =      ls_cvcod
		dw_insert.Object.MDCVCOD [ll_r] =    ls_cvcod
		
		/* SCPORTAL ����Ʈ ���� ���� - 2007.02.09 - �ۺ�ȣ */
		dw_insert.Object.ITEM1[ll_r] =       Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,3))))
		dw_insert.Object.ITEM2[ll_r] =       Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,4))))
		dw_insert.Object.ITEM3[ll_r] =       Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,5))))
		dw_insert.Object.ITEM4[ll_r] =       Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,6))))
		dw_insert.Object.ITEM5[ll_r] =       Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,7))))
		dw_insert.Object.ITEM6[ll_r] =       Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,8))))
		dw_insert.Object.ITEM7[ll_r] =       Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,9))))
		dw_insert.Object.ITEM8[ll_r] =       Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,10))))
		dw_insert.Object.ITEM9[ll_r] =       Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,11))))
		dw_insert.Object.ITEM10[ll_r] =      Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,12))))
		dw_insert.Object.ITEM11[ll_r] =      Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,13))))  
		dw_insert.Object.ITEM12[ll_r] =      Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,14))))  
		dw_insert.Object.ITEM13[ll_r] =      Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,15))))  
		dw_insert.Object.ITEM14[ll_r] =      Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,16))))  
		dw_insert.Object.ITEM15[ll_r] =      Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,17))))  
		dw_insert.Object.ITEM16[ll_r] =      Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,18))))  
		dw_insert.Object.ITEM17[ll_r] =      Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,19))))  
		dw_insert.Object.ITEM18[ll_r] =      Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,20)))) 
		dw_insert.Object.ITEM19[ll_r] =      Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,21)))) 
		dw_insert.Object.ITEM20[ll_r] =      Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,22)))) 
		dw_insert.Object.ITEM21[ll_r] =      Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,23))))  
		dw_insert.Object.ITEM22[ll_r] =      Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,24))))  
		dw_insert.Object.ITEM23[ll_r] =      Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,25))))  
		dw_insert.Object.ITEM24[ll_r] =      Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,26))))  
		dw_insert.Object.ITEM25[ll_r] =      Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,27))))  
		dw_insert.Object.ITEM26[ll_r] =      Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,28))))  
		dw_insert.Object.ITEM27[ll_r] =      Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,29))))  
		dw_insert.Object.ITEM28[ll_r] =      Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,30)))) 
		dw_insert.Object.ITEM29[ll_r] =      Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,31)))) 
		dw_insert.Object.ITEM30[ll_r] =      Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,32)))) 
		dw_insert.Object.ITEM31[ll_r] =      Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,33))))

		il_succeed++
		
//	End If
	
		/* SCPORTAL ����Ʈ ���� ���� - 2007.02.09 - �ۺ�ȣ */
//	If mod(ll_xl_row,3) = 1 and ll_r > 0  Then
//		
//		dw_insert.Object.ITEM1[ll_r] =       Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,3))))
//		dw_insert.Object.ITEM2[ll_r] =       Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,4))))
//		dw_insert.Object.ITEM3[ll_r] =       Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,5))))
//		dw_insert.Object.ITEM4[ll_r] =       Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,6))))
//		dw_insert.Object.ITEM5[ll_r] =       Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,7))))
//		dw_insert.Object.ITEM6[ll_r] =       Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,8))))
//		dw_insert.Object.ITEM7[ll_r] =       Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,9))))
//		dw_insert.Object.ITEM8[ll_r] =       Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,10))))
//		dw_insert.Object.ITEM9[ll_r] =       Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,11))))
//		dw_insert.Object.ITEM10[ll_r] =      Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,12))))
//
//	ElseIf  mod(ll_xl_row,3) = 2 and ll_r > 0   Then
//	
//		dw_insert.Object.ITEM11[ll_r] =      Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,3))))  
//		dw_insert.Object.ITEM12[ll_r] =      Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,4))))  
//		dw_insert.Object.ITEM13[ll_r] =      Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,5))))  
//		dw_insert.Object.ITEM14[ll_r] =      Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,6))))  
//		dw_insert.Object.ITEM15[ll_r] =      Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,7))))  
//		dw_insert.Object.ITEM16[ll_r] =      Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,8))))  
//		dw_insert.Object.ITEM17[ll_r] =      Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,9))))  
//		dw_insert.Object.ITEM18[ll_r] =      Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,10)))) 
//		dw_insert.Object.ITEM19[ll_r] =      Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,11)))) 
//		dw_insert.Object.ITEM20[ll_r] =      Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,12)))) 
//	ElseIf  mod(ll_xl_row,3) = 0  and ll_r > 0   Then
//		
//		dw_insert.Object.ITEM21[ll_r] =      Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,3))))  
//		dw_insert.Object.ITEM22[ll_r] =      Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,4))))  
//		dw_insert.Object.ITEM23[ll_r] =      Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,5))))  
//		dw_insert.Object.ITEM24[ll_r] =      Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,6))))  
//		dw_insert.Object.ITEM25[ll_r] =      Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,7))))  
//		dw_insert.Object.ITEM26[ll_r] =      Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,8))))  
//		dw_insert.Object.ITEM27[ll_r] =      Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,9))))  
//		dw_insert.Object.ITEM28[ll_r] =      Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,10)))) 
//		dw_insert.Object.ITEM29[ll_r] =      Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,11)))) 
//		dw_insert.Object.ITEM30[ll_r] =      Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,12)))) 
//		dw_insert.Object.ITEM31[ll_r] =      Long( Dec(Trim(uo_xl.uf_gettext(ll_xl_row,13))))
//	End If
   
	ll_xl_row ++
	
Loop


Delete From van_mobis_auto_sil 
      Where saupj = :ls_saupj
		  and sil_mon = :ls_ymd ;


If sqlca.sqlcode <> 0 Then
	messagebox('',sqlca.sqlerrtext)
	Rollback;
	MessageBox('Ȯ��','���� ����')
	Return -1
End If

dw_insert.AcceptText()

If dw_insert.Update() < 1 Then
	Rollback;
	MessageBox('Ȯ��','���� ����')
	Return -1
Else
	Commit ;
	
End If


w_mdi_frame.sle_msg.text ='�ѰǼ� :'+String(ll_cnt) + '(���� : '+String(il_err)+',���� :'+String(il_succeed) + ') ����Ÿ ó���� �Ͽ����ϴ�.'
uo_xl.uf_excel_Disconnect()
dw_insert.AcceptText()
// ���� IMPORT  END ***************************************************************
Return ll_cnt
end function

public subroutine wf_init ();If rb_1.Checked Then
	dw_input.DataObject = "d_sm10_0050_1"
	p_1.visible = True
	pb_2.visible = False
	p_2.visible = false
//	p_search.visible = false
	
Else
	dw_input.DataObject = "d_sm10_0050_2"
	p_1.visible = False
	pb_2.visible = True
	p_2.visible = True
//	p_search.visible = True
End If

dw_input.SetTransObject(SQLCA)

dw_input.Reset()
dw_input.InsertRow(0)
wf_choose('1')
dw_input.Object.jisi_date[1] = is_today
dw_input.Object.jisi_date2[1] = is_today
dw_input.Object.jisi_mon[1] = Left(is_today,6)

setnull(gs_code)
If f_check_saupj() = 1 Then
	dw_input.SetItem(1, 'saupj', gs_code)
   if gs_code <> '%' then
   	dw_input.Modify("saupj.protect=1")
   End if
End If
	
	
end subroutine

public function long wf_itnbr_insert (string ar_itnbr, string ar_itdsc);INSERT INTO ITEMAS
	(	 SABU,   
         ITNBR,   
         ITDSC,   
         ISPEC,   
         JIJIL,   
         ITTYP,   
         ITCLS,   
         LOTGUB,   
         GBWAN,   
         GBDATE,   
         GBGUB,   
         USEYN,   
         PUMSR,   
         CNVFAT,   
         UNMSR,   
         WAGHT,   
         FILSK,   
         ITGU,   
         WONPRC,   
         WONSRC,   
         MLICD,   
         LDTIM,   
         LDTIM2,   
         MINSAF,   
         MIDSAF,   
         MAXSAF,   
         SHRAT,   
         MINQT,   
         MULQT,   
         MAXQT,   
         AUTO,   
         BASEQTY,   
         PACKQTY,   
         AUTOHOLD,   
         LOT,   
         BALRATE,   
         RMARK2	)  
   VALUES ( '1',   
         :AR_ITNBR ,   
         :AR_ITDSC ,   
         NULL,   
         NULL,   
         '1',   
         '9999',   
         'N',   
         'Y',   
         '20060904',   
         '1',   
         '0',   
         'EA',   
         1,   
         'EA',   
         0,   
         'Y',   
         '5',   
         0,    
         0, 
         '1',   
         0,   
         0,   
         0,   
         0,   
         0,   
         0,   
         0,   
         0,   
         0,   
         'N',   
         0,   
         0,   
         'N',   
         'N',   
         0,   
         NULL ) ;
			
If sqlca.sqlcode <> 0 Then
	rollback;
	return -1
end iF

commit;

return 1
end function

public function integer wf_ckd_b (string as_file);String ls_saupj , ls_cvcod , ls_ymd ,ls_gubun ,ls_itnbr , ls_mitnbr  , ls_itdsc ,ls_factory , ls_plant
uo_xlobject uo_xl
string ls_docname, ls_named ,ls_line, ls_ymd2
string ls_balno, ls_balseq, ls_baldate, ls_orderno, ls_ordersq, ls_naparea, ls_yodate, ls_napyn, ls_gadate
string ls_multi_ds, ls_customer, ls_carname, ls_balmemo, ls_status
Long   ll_xl_row , ll_r , i , ll_cnt=0 ,ll_c, ll_balqty, ll_ndate

String ls_crt_date , ls_crt_time , ls_crt_user

If dw_input.AcceptText() <> 1 Then Return -1

ls_ymd   = Trim(dw_input.Object.jisi_date[1])

SELECT TO_CHAR((TO_DATE(:ls_ymd,'YYYYMMDD')-1),'YYYYMMDD') INTO :ls_ymd2 FROM dual;

ls_ymd   = Left(ls_ymd2 ,6)

//ls_cvcod = Trim(dw_input.Object.mcvcod[1]) 
ls_saupj = Trim(dw_input.Object.saupj[1]) 

dw_insert.Reset()

w_mdi_frame.sle_msg.text =''

Setpointer(Hourglass!)

uo_xl = create uo_xlobject
//������ ����
uo_xl.uf_excel_connect(as_file, false , 3)
uo_xl.uf_selectsheet(1)

//Data ���� Row Setting
ll_xl_row =2

il_err = 0
il_succeed = 0

Do While(True)
	
	For i =1 To 50
		uo_xl.uf_set_format(ll_xl_row,i, '@' + space(30))		
	Next
	
	//Data�� ������쿣 Return...........
	if isnull(uo_xl.uf_gettext(ll_xl_row,1)) or trim(uo_xl.uf_gettext(ll_xl_row,1)) = '' then exit

	ll_cnt++
	
	ls_baldate	= Trim(uo_xl.uf_gettext(ll_xl_row,1))
	ls_balno		= Trim(uo_xl.uf_gettext(ll_xl_row,2))
	ls_balseq	= Trim(uo_xl.uf_gettext(ll_xl_row,3))
	ls_orderno	= Trim(uo_xl.uf_gettext(ll_xl_row,4))
	ls_ordersq	= Trim(uo_xl.uf_gettext(ll_xl_row,5))
	ls_itnbr		= Trim(uo_xl.uf_gettext(ll_xl_row,6))
	ls_itdsc		= Trim(uo_xl.uf_gettext(ll_xl_row,7))
	ll_balqty	= Long(Trim(uo_xl.uf_gettext(ll_xl_row,8)))
	ls_naparea	= Trim(uo_xl.uf_gettext(ll_xl_row,9))
	ls_yodate	= Trim(uo_xl.uf_gettext(ll_xl_row,10))
	ls_napyn		= Trim(uo_xl.uf_gettext(ll_xl_row,11))
	ls_gadate	= Trim(uo_xl.uf_gettext(ll_xl_row,12))
	ls_multi_ds	= Trim(uo_xl.uf_gettext(ll_xl_row,13))
	ll_ndate		= Long(Trim(uo_xl.uf_gettext(ll_xl_row,14)))
	ls_customer	= Trim(uo_xl.uf_gettext(ll_xl_row,15))
	ls_carname	= Trim(uo_xl.uf_gettext(ll_xl_row,16))
	ls_balmemo	= Trim(uo_xl.uf_gettext(ll_xl_row,17))
	ls_status	= Trim(uo_xl.uf_gettext(ll_xl_row,18))
	
	if ls_baldate > '.' then ls_baldate	= Mid(ls_baldate,1,4)+Mid(ls_baldate,6,2)+Mid(ls_baldate,9,2)
	if ls_yodate > '.' then ls_yodate	= Mid(ls_yodate,1,4)+Mid(ls_yodate,6,2)+Mid(ls_yodate,9,2)
	if ls_gadate > '.' then ls_gadate	= Mid(ls_gadate,1,4)+Mid(ls_gadate,6,2)+Mid(ls_gadate,9,2)
	
	
	// ���Ͽ��� Ȯ��
	Select count(*) Into :ll_c From van_mobis_ckd_b 
		 Where balno = :ls_balno And balseq = :ls_balseq ;
		if ll_c = 0 then
			ll_c = dw_insert.Find("balno='"+ls_balno+"' and balseq='"+ls_balseq+"'", 1, dw_insert.rowcount())
		end if
	
	
	IF ll_c = 0 THEN
		
		Select rfgub ,rfna2 Into :ls_factory ,:ls_cvcod
		  From Reffpf
		 Where rfcod = '2A'
			and rfgub != '00'
			and rfgub = 'M1' ;
			
		if sqlca.sqlcode <> 0 or trim(ls_factory) = '' or isNull(ls_factory) then			
			//dw_insert.Object.ITDSC[ll_r]     =    "�̵�� ����"
			il_err++
			ll_xl_row ++
			Continue ;
		End IF
		
		select itnbr
		  into :ls_mitnbr
		  from itemas
		 where itnbr = :ls_itnbr ;
			
		if sqlca.sqlcode <> 0 or trim(ls_mitnbr) = '' or isNull(ls_mitnbr) then
			//dw_insert.Object.ITDSC[ll_r]     =    "�̵�� ǰ��"
			il_err++
			ll_xl_row ++
			Continue ;
		End IF
		
		ll_r = dw_insert.InsertRow(0) 
		dw_insert.Scrolltorow(ll_r)
		
		dw_insert.Object.balno[ll_r]		=    ls_balno
		dw_insert.Object.balseq[ll_r] 	=    ls_balseq
		dw_insert.Object.baldate[ll_r] 	=    ls_baldate
		dw_insert.Object.orderno[ll_r] 	=    ls_orderno
		dw_insert.Object.ordersq[ll_r] 	=    ls_ordersq
		dw_insert.Object.itnbr[ll_r] 		=    ls_itnbr
		dw_insert.Object.itdsc[ll_r] 		=    ls_itdsc
		dw_insert.Object.balqty[ll_r]		=    ll_balqty
		dw_insert.Object.naparea[ll_r] 	=    ls_naparea
		dw_insert.Object.yodate[ll_r] 	=    ls_yodate
		dw_insert.Object.napyn[ll_r] 		=    ls_napyn
		dw_insert.Object.gadate[ll_r] 	=    ls_gadate
		dw_insert.Object.multi_ds[ll_r]	=    ls_multi_ds
		dw_insert.Object.ndate[ll_r]		=    ll_ndate
		dw_insert.Object.customer[ll_r]	=    ls_customer
		dw_insert.Object.carname[ll_r]	=    ls_carname
		dw_insert.Object.balmemo[ll_r]	=    ls_balmemo
		dw_insert.Object.status[ll_r]		=    ls_status
	
		dw_insert.Object.factory[ll_r]	=    ls_factory
		dw_insert.Object.mitnbr[ll_r]		=    ls_mitnbr
		dw_insert.Object.mcvcod[ll_r]		=    ls_cvcod
		
		dw_insert.Object.CRT_DATE[ll_r] 	=    ls_crt_date
		dw_insert.Object.CRT_TIME[ll_r] 	=    ls_crt_time
		dw_insert.Object.CRT_USER[ll_r] 	=    ls_crt_user
		
		il_succeed++
	
	END IF
	
	ll_xl_row ++
	
Loop


dw_insert.AcceptText()

If dw_insert.Update() < 1 Then
	Rollback;
	MessageBox('Ȯ��','���� ����')
	Return -1
Else
	Commit ;
	
End If

w_mdi_frame.sle_msg.text ='�ѰǼ� :'+String(ll_cnt) + '(���� : '+String(il_err)+',���� :'+String(il_succeed) + ') ����Ÿ ó���� �Ͽ����ϴ�.'
uo_xl.uf_excel_Disconnect()
dw_insert.AcceptText()
// ���� IMPORT  END ***************************************************************
Return ll_cnt
end function

public function integer wf_ckd_b_wp (string as_file);String ls_saupj , ls_cvcod , ls_ymd ,ls_gubun ,ls_itnbr , ls_mitnbr  , ls_itdsc ,ls_factory , ls_plant
uo_xlobject uo_xl
string ls_docname, ls_named ,ls_line, ls_ymd2
string ls_balno, ls_balseq, ls_baldate, ls_orderno, ls_ordersq, ls_naparea, ls_yodate, ls_napyn, ls_gadate
string ls_multi_ds, ls_customer, ls_carname, ls_balmemo, ls_status, ls_ordergb, ls_napdat, ls_podat, ls_mcvcod
Long   ll_xl_row , ll_r , i , ll_cnt=0 ,ll_c, ll_balqty, ll_ndate

String ls_crt_date , ls_crt_time , ls_crt_user

If dw_input.AcceptText() <> 1 Then Return -1

ls_ymd   = Trim(dw_input.Object.jisi_date[1])

SELECT TO_CHAR((TO_DATE(:ls_ymd,'YYYYMMDD')-1),'YYYYMMDD') INTO :ls_ymd2 FROM dual;

ls_ymd   = Left(ls_ymd2 ,6)

//ls_cvcod = Trim(dw_input.Object.mcvcod[1]) 
ls_saupj = Trim(dw_input.Object.saupj[1]) 

dw_insert.Reset()

w_mdi_frame.sle_msg.text =''

Setpointer(Hourglass!)

uo_xl = create uo_xlobject
//������ ����
uo_xl.uf_excel_connect(as_file, false , 3)
uo_xl.uf_selectsheet(1)

//Data ���� Row Setting
//ll_xl_row = 9
ll_xl_row = 2

il_err = 0
il_succeed = 0

Do While(True)
	
	For i =1 To 50
		if i = 20 or i = 22 then										// ��ǰ��, ������ ��¥ ���� �״�� �޴´�
			uo_xl.uf_set_format(ll_xl_row,i, 'yyyy-mm-dd')		// ��¥ ������ ������ �� ���� ��ȯ�ϸ� ���� �����ʹ� 2011-05-05 00:00:00 ���� ���´�
		else
			uo_xl.uf_set_format(ll_xl_row,i, '@' + space(30))	
		end if
	Next
	
	//PO Data�� ������쿣 Return...........
	if isnull(uo_xl.uf_gettext(ll_xl_row,2)) or trim(uo_xl.uf_gettext(ll_xl_row,2)) = '' then exit	

	ll_cnt++
	
	/* 
		���� 1,3,5,6,7,12,15 �� �����͸� ���
 ��� �ٲ� 2,3,6,7,9,20,22 �� �����͸� ��� - 20110427 By shjeon
	*/
	ls_itnbr   = Trim(uo_xl.uf_gettext(ll_xl_row, 3))			//ǰ��
	//ǰ�� ���� ���ڸ��� 'A'�ڵ尡 ���� ���� �������� CKD���� - 'A'�ڵ� ������ �������� ǰ���ڵ�
	//"A"�ڵ�(CKD�ڷ�)�� ���
	If LEFT(ls_itnbr, 1) = 'A' Then
		ls_itnbr   = MID(ls_itnbr, 2, LEN(ls_itnbr))
		ls_ordergb = 'A'
		
		SELECT ITNBR, ITDSC
		  INTO :ls_itnbr, :ls_itdsc
		  FROM ITEMAS
		 WHERE REPLACE(ITNBR, '-', '') = :ls_itnbr ;
		if sqlca.sqlcode <> 0 or trim(ls_itnbr) = '' or isNull(ls_itnbr) then
			//dw_insert.Object.ITDSC[ll_r]     =    "�̵�� ǰ��"
			il_err++
			ll_xl_row ++
			Continue ;
		End IF
	Else
		il_err++
		ll_xl_row ++
		Continue ;		
	End If
	
	ls_orderno = Trim(uo_xl.uf_gettext(ll_xl_row, 2))			//���ֹ�ȣ
	ls_napdat  = LEFT(Trim(uo_xl.uf_getvalue(ll_xl_row, 20)),10)			//��ǰ��
	ls_podat   = LEFT(Trim(uo_xl.uf_getvalue(ll_xl_row, 22)),10)			//������
	//���ֹ�ȣ "4500720111(00010)" -> 4500720111, 00010�������� ����
	//��ǰ�� "2009-05-28" -> "20090528" �������� ����
	//������ "2009-05-28" -> "20090528" �������� ����
	SELECT SUBSTR(REPLACE(REPLACE(:ls_orderno, '(', ''), ')', ''), 1, 10),
          SUBSTR(REPLACE(REPLACE(:ls_orderno, '(', ''), ')', ''), 11, 5),
			 REPLACE(:ls_napdat, '-', ''),
			 REPLACE(:ls_podat , '-', '')
	  INTO :ls_balno, :ls_balseq, :ls_napdat, :ls_podat //���ֹ�ȣ, ���ּ���, ��ǰ��, ������
	  FROM DUAL ;
	
	//ls_factory = Trim(uo_xl.uf_gettext(ll_xl_row, 5))			//����
	ls_factory = 'WP'			//���� - 6 ���� �����ڵ尡 ��� ���� ���� By 20110427 shjeon
	SELECT RFNA2
	  INTO :ls_mcvcod
     FROM REFFPF
    WHERE RFCOD = '2A'
      AND RFGUB = :ls_factory ;
	if sqlca.sqlcode <> 0 or trim(ls_mcvcod) = '' or isNull(ls_mcvcod) then			
		//dw_insert.Object.ITDSC[ll_r]     =    "�̵�� ����"
		il_err++
		ll_xl_row ++
		Continue ;
	End IF
		
	ll_balqty  = Long(Trim(uo_xl.uf_gettext(ll_xl_row, 9)))	//���ּ���
	ls_naparea = Trim(uo_xl.uf_gettext(ll_xl_row, 7))			//������ġ
	
	ls_crt_date = String(TODAY(), 'yyyymmdd')
	ls_crt_time = String(TODAY(), 'hhmmdd')
	ls_crt_user = gs_empno
	
	// ���Ͽ��� Ȯ��
	Select count(*) Into :ll_c From van_mobis_ckd_b 
	 Where balno = :ls_balno And balseq = :ls_balseq ;
	if ll_c = 0 then
		ll_c = dw_insert.Find("balno='"+ls_balno+"' and balseq='"+ls_balseq+"'", 1, dw_insert.rowcount())
	end if	
	
	IF ll_c = 0 THEN
		
		Select rfgub ,rfna2 Into :ls_factory ,:ls_cvcod
		  From Reffpf
		 Where rfcod =  '2A'
			and rfgub != '00'
			and rfgub =  'WP' ;
			
		if sqlca.sqlcode <> 0 or trim(ls_factory) = '' or isNull(ls_factory) then			
			//dw_insert.Object.ITDSC[ll_r]     =    "�̵�� ����"
			il_err++
			ll_xl_row ++
			Continue ;
		End IF
			
		
		ll_r = dw_insert.InsertRow(0) 
		dw_insert.Scrolltorow(ll_r)
		
		dw_insert.Object.balno[ll_r]		=    ls_balno
		dw_insert.Object.balseq[ll_r] 	=    ls_balseq
		dw_insert.Object.baldate[ll_r] 	=    ls_podat
		dw_insert.Object.orderno[ll_r] 	=    ls_balno
		dw_insert.Object.ordersq[ll_r] 	=    ls_balseq
		dw_insert.Object.itnbr[ll_r] 		=    ls_itnbr
		dw_insert.Object.itdsc[ll_r] 		=    ls_itdsc
		dw_insert.Object.balqty[ll_r]		=    ll_balqty
		dw_insert.Object.naparea[ll_r] 	=    ls_naparea
		dw_insert.Object.yodate[ll_r] 	=    ls_napdat
		dw_insert.Object.napyn[ll_r] 		=    'N'
		dw_insert.Object.gadate[ll_r] 	=    ls_napdat
		//dw_insert.Object.multi_ds[ll_r]	=    ls_multi_ds
		//dw_insert.Object.ndate[ll_r]		=    ll_ndate
		dw_insert.Object.customer[ll_r]	=    '��������'
		//dw_insert.Object.carname[ll_r]	=    ls_carname
		//dw_insert.Object.balmemo[ll_r]	=    ls_balmemo
		//dw_insert.Object.status[ll_r]		=    ls_status
	
		dw_insert.Object.factory[ll_r]	=    ls_factory
		dw_insert.Object.mitnbr[ll_r]		=    ls_itnbr
		dw_insert.Object.mcvcod[ll_r]		=    ls_mcvcod
		
		dw_insert.Object.CRT_DATE[ll_r] 	=    ls_crt_date
		dw_insert.Object.CRT_TIME[ll_r] 	=    ls_crt_time
		dw_insert.Object.CRT_USER[ll_r] 	=    ls_crt_user
		
		il_succeed++
	
	END IF
	
	ll_xl_row ++
	
Loop


dw_insert.AcceptText()

If dw_insert.Update() < 1 Then
	Rollback;
	MessageBox('Ȯ��','���� ����')
	Return -1
Else
	Commit ;
	//Rollback;
	MessageBox('Ȯ��', '���� ����')
End If

w_mdi_frame.sle_msg.text ='�ѰǼ� :'+String(ll_cnt) + '(���� : '+String(il_err)+',���� :'+String(il_succeed) + ') ����Ÿ ó���� �Ͽ����ϴ�.'
uo_xl.uf_excel_Disconnect()
dw_insert.AcceptText()
// ���� IMPORT  END ***************************************************************
Return ll_cnt
end function

public subroutine wf_excel_down (datawindow adw_excel);String	ls_quota_no
integer	li_rc
string	ls_filepath, ls_filename
boolean	lb_fileexist

li_rc = GetFileSaveName("������ ���ϸ��� �����ϼ���." , ls_filepath , &
											  ls_filename , "XLS" , "Excel Files (*.xls),*.xls")												
IF li_rc = 1 THEN
	IF lb_fileexist THEN
		li_rc = MessageBox("��������" , ls_filepath + " ������ �̹� �����մϴ�.~r~n" + &
												 "������ ������ ����ðڽ��ϱ�?" , Question! , YesNo! , 1)
		IF li_rc = 2 THEN 
			w_mdi_frame.sle_msg.text = "�ڷ�ٿ����!!!"			
			RETURN
		END IF
	END IF
	
	Setpointer(HourGlass!)
	
 	If uf_save_dw_as_excel(adw_excel,ls_filepath) <> 1 Then
		w_mdi_frame.sle_msg.text = "�ڷ�ٿ����!!!"
		return
	End If

END IF

w_mdi_frame.sle_msg.text = "�ڷ�ٿ�Ϸ�!!!"
end subroutine

on w_sm10_0050.create
int iCurrent
call super::create
this.p_1=create p_1
this.p_dellrow_all=create p_dellrow_all
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_1=create gb_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.p_2=create p_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_1
this.Control[iCurrent+2]=this.p_dellrow_all
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.gb_1
this.Control[iCurrent+6]=this.pb_1
this.Control[iCurrent+7]=this.pb_2
this.Control[iCurrent+8]=this.p_2
end on

on w_sm10_0050.destroy
call super::destroy
destroy(this.p_1)
destroy(this.p_dellrow_all)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_1)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.p_2)
end on

event open;call super::open;wf_init()
end event

event resize;r_detail.width = this.width - 60
r_detail.height = this.height - r_detail.y - 65
dw_insert.width = this.width - 70
dw_insert.height = this.height - dw_insert.y - 70
end event

event activate;gw_window = this

if gs_lang = "CH" then   //// �߹��� ���
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&Q)", true) //// ��ȸ
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("��ʥ(&A)", false) //// �߰�
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?�(&D)", false) //// ����
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?��(&S)", false) //// ����
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("���(&Z)", false) //// ���
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("���(&C)", false) //// �ű�
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&T)", false) //// ã��
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&F)", false) //// ����
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("Excel??(&E)", true) //// �����ٿ�
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?��(&P)", false) //// ���
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&R)", false) //// �̸����� 
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?�?(&G)", true) //// ����
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("PDF") + "(&P)", true)  //// PDF��ȯ
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("����") + "(&C)", true) //// ����
else
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("��ȸ") + "(&Q)", true) //// ��ȸ
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("�߰�") + "(&A)", false) //// �߰�
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("����") + "(&D)", false) //// ����
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("����") + "(&S)", false) //// ����
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("���") + "(&Z)", false) //// ���
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("�ű�") + "(&C)", false) //// �ű�
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("ã��") + "(&T)", false) //// ã��
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("����") + "(&F)",	 false) //// ����
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("������ȯ") + "(&E)", true) //// �����ٿ�
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("���") + "(&P)", false) //// ���
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("�̸�����") + "(&R)", false) //// �̸�����
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("����") + "(&G)", true) //// ����
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("PDF") + "(&P)", true)
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("����") + "(&C)", true)
end if

//// ����Ű Ȱ��ȭ ó��
m_main2.m_window.m_inq.enabled = true //// ��ȸ
m_main2.m_window.m_add.enabled = false //// �߰�
m_main2.m_window.m_del.enabled = false  //// ����
m_main2.m_window.m_save.enabled = false //// ����
m_main2.m_window.m_cancel.enabled = false //// ���
m_main2.m_window.m_new.enabled = false //// �ű�
m_main2.m_window.m_find.enabled = false  //// ã��
m_main2.m_window.m_filter.enabled = false //// ����
m_main2.m_window.m_excel.enabled = true //// �����ٿ�
m_main2.m_window.m_print.enabled = false  //// ���
m_main2.m_window.m_preview.enabled = false //// �̸�����

w_mdi_frame.st_window.Text = Upper(is_window_id)
end event

event ue_retrieve;call super::ue_retrieve;p_inq.TriggerEvent(Clicked!)
end event

type cb_exit from w_inherite`cb_exit within w_sm10_0050
end type

type sle_msg from w_inherite`sle_msg within w_sm10_0050
end type

type dw_datetime from w_inherite`dw_datetime within w_sm10_0050
end type

type st_1 from w_inherite`st_1 within w_sm10_0050
end type

type p_search from w_inherite`p_search within w_sm10_0050
end type

event p_search::ue_lbuttonup;//
PictureName = "..\image\������ȯ_up.gif"
end event

event p_search::ue_lbuttondown;call super::ue_lbuttondown;//
PictureName = "..\image\������ȯ_dn.gif"
end event

event p_search::clicked;call super::clicked;If this.Enabled Then wf_excel_down(dw_insert)
end event

type p_addrow from w_inherite`p_addrow within w_sm10_0050
end type

type p_delrow from w_inherite`p_delrow within w_sm10_0050
integer x = 3653
integer y = 228
end type

event p_delrow::clicked;call super::clicked;Long i ,ll_rcnt
string ls_gubun ,ls_saupj , ls_cvcod ,ls_date , ls_saupj_cust
DataWindow ldw_x

ldw_x = dw_insert

ll_rcnt = ldw_x.RowCount()

If ll_rcnt < 1 Then 
	MessageBox('Ȯ��','������ ����Ÿ�� �������� �ʽ��ϴ�.')
	Return
End IF
if f_msg_delete() = -1 then return

ldw_x.SetRedraw(FALSE)

For i = ll_rcnt To 1 Step -1
	If ldw_x.isSelected(i) Then
		ldw_x.ScrollToRow(i)
		ldw_x.DeleteRow(i)
	End iF
Next


if ldw_x.Update() = 1 then
	
	commit ;
	sle_msg.text =	"����ڷḦ �����Ͽ����ϴ�!!"	
else
	rollback ;
   messagebox("�������", "�ڷῡ ���� ������ �����Ͽ����ϴ�")
end if	
ldw_x.SetRedraw(TRUE)






end event

type p_mod from w_inherite`p_mod within w_sm10_0050
integer y = 3200
end type

type p_del from w_inherite`p_del within w_sm10_0050
integer y = 3200
end type

type p_inq from w_inherite`p_inq within w_sm10_0050
integer y = 3200
end type

event p_inq::clicked;call super::clicked;
String ls_itnbr , ls_ymd , ls_ymd2 , ls_saupj , ls_factory ,ls_gubun

dw_input.AcceptText() 

If rb_2.Checked = False Then Return

ls_saupj = Trim(dw_input.Object.saupj[1])
ls_gubun = Trim(dw_input.Object.gubun[1])
ls_factory =Trim(dw_input.Object.factory[1])
ls_itnbr = Trim(dw_input.Object.itnbr[1])

If ls_gubun = '1' or ls_gubun = '3' or ls_gubun = '4' Then
	ls_ymd = Trim(dw_input.Object.jisi_date[1])
	ls_ymd2 = Trim(dw_input.Object.jisi_date2[1])
	
	dw_insert.Retrieve(ls_saupj , ls_ymd , ls_ymd2, ls_itnbr , ls_factory)
	
Else

	ls_ymd = Trim(dw_input.Object.jisi_mon[1])
	
	dw_insert.Retrieve(ls_saupj , ls_ymd , ls_itnbr , ls_factory)
	
End IF


end event

type p_print from w_inherite`p_print within w_sm10_0050
integer y = 3200
end type

type p_can from w_inherite`p_can within w_sm10_0050
integer y = 3200
end type

type p_exit from w_inherite`p_exit within w_sm10_0050
integer y = 3200
end type

event p_exit::clicked;//
Close(parent)
end event

type p_ins from w_inherite`p_ins within w_sm10_0050
integer y = 3200
end type

type p_new from w_inherite`p_new within w_sm10_0050
integer y = 3200
end type

type dw_input from w_inherite`dw_input within w_sm10_0050
integer y = 56
integer width = 3000
integer height = 316
integer taborder = 50
string title = "none"
string dataobject = "d_sm10_0050_1"
end type

event itemchanged;String ls_col , ls_value

ls_col = GetColumnName()
ls_value = Trim(GetText())

Choose Case ls_col
	Case "gubun"
		If ls_value > '' Then
			Object.filename[1] =  wf_choose(ls_value)
		End If
		
		If rb_2.Checked = True Then
			If data = '4' Then
				dw_input.SetItem(1, 'factory', 'WP')
			Else
				dw_input.SetItem(1, 'factory', '%')
			End If
		End If

END CHOOSE
end event

type cb_delrow from w_inherite`cb_delrow within w_sm10_0050
boolean visible = false
integer y = 3400
end type

type cb_addrow from w_inherite`cb_addrow within w_sm10_0050
boolean visible = false
integer y = 3400
end type

type dw_insert from w_inherite`dw_insert within w_sm10_0050
integer x = 37
integer y = 400
integer width = 3489
integer height = 1964
string dataobject = "d_sm10_0050_ckd_b"
end type

event dw_insert::clicked;call super::clicked;

f_multi_select(dw_insert)
end event

type cb_mod from w_inherite`cb_mod within w_sm10_0050
boolean visible = false
integer y = 3400
end type

type cb_ins from w_inherite`cb_ins within w_sm10_0050
boolean visible = false
integer y = 3400
end type

type cb_del from w_inherite`cb_del within w_sm10_0050
boolean visible = false
integer y = 3400
end type

type cb_inq from w_inherite`cb_inq within w_sm10_0050
boolean visible = false
integer y = 3400
end type

type cb_print from w_inherite`cb_print within w_sm10_0050
boolean visible = false
integer y = 3400
end type

type cb_can from w_inherite`cb_can within w_sm10_0050
boolean visible = false
integer y = 3400
end type

type cb_search from w_inherite`cb_search within w_sm10_0050
boolean visible = false
integer y = 3400
end type

type gb_10 from w_inherite`gb_10 within w_sm10_0050
end type

type gb_button1 from w_inherite`gb_button1 within w_sm10_0050
end type

type gb_button2 from w_inherite`gb_button2 within w_sm10_0050
end type

type r_head from w_inherite`r_head within w_sm10_0050
integer width = 3008
integer height = 324
end type

type r_detail from w_inherite`r_detail within w_sm10_0050
integer y = 396
end type

type p_1 from uo_picture within w_sm10_0050
integer x = 3479
integer y = 60
integer width = 178
boolean bringtotop = true
string picturename = "..\image\����_up.gif"
end type

event clicked;call super::clicked;String ls_saupj , ls_cvcod , ls_ymd ,ls_gubun ,ls_itnbr , ls_mitnbr , ls_filename , ls_itdsc
uo_xlobject uo_xl
string ls_docname, ls_named ,ls_line 
Long   ll_xl_row , ll_r , i , ll_cnt=0

String ls_crt_date , ls_crt_time , ls_crt_user

If dw_input.AcceptText() <> 1 Then Return

ls_ymd   = Trim(dw_input.Object.jisi_date[1]) 

ls_saupj = Trim(dw_input.Object.saupj[1]) 
ls_gubun = Trim(dw_input.Object.gubun[1])
ls_filename = Trim(dw_input.Object.filename[1])

If IsNull(ls_ymd) Or ls_ymd = '' Then
	f_message_chk(1400,'[�������]')
	Return
End If


Choose Case ls_gubun 
	Case '1' // �ϳ�ǰ ��ȹ 
		wf_sch(ls_filename)
	Case '2'
		wf_sil(ls_filename)
/* CKD�� CKD VAN���� ȭ�鿡�� �ϰ� ���� �� - BY SHINGOON 2013.11.06
	Case '3'
		wf_ckd_b(ls_filename)
	Case '4' //�������� CKD - by shingoon 2009.06.01
		wf_ckd_b_wp(ls_filename)
*/
End Choose 
end event

type p_dellrow_all from uo_picture within w_sm10_0050
integer x = 3479
integer y = 228
integer width = 178
boolean bringtotop = true
string picturename = "..\image\��ü����_up.gif"
end type

event clicked;call super::clicked;Long i ,ll_rcnt
string ls_gubun ,ls_saupj , ls_cvcod ,ls_date , ls_saupj_cust
DataWindow ldw_x

ldw_x = dw_insert

ll_rcnt = ldw_x.RowCount()

If ll_rcnt < 1 Then 
	MessageBox('Ȯ��','������ ����Ÿ�� �������� �ʽ��ϴ�.')
	Return
End IF
if f_msg_delete() = -1 then return

ldw_x.SetRedraw(FALSE)

For i = ll_rcnt To 1 Step -1
	
	ldw_x.ScrollToRow(i)
	ldw_x.DeleteRow(i)
	
Next

if ldw_x.Update() = 1 then
	
	commit ;
	sle_msg.text =	"����ڷḦ �����Ͽ����ϴ�!!"	
else
	rollback ;
   messagebox("�������", "�ڷῡ ���� ������ �����Ͽ����ϴ�")
end if	
ldw_x.SetRedraw(TRUE)
end event

type rb_1 from radiobutton within w_sm10_0050
integer x = 3122
integer y = 120
integer width = 274
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 16777215
string text = "���"
boolean checked = true
end type

event clicked;wf_init()
end event

type rb_2 from radiobutton within w_sm10_0050
integer x = 3122
integer y = 244
integer width = 274
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 16777215
string text = "��ȸ"
end type

event clicked;wf_init()
end event

type gb_1 from groupbox within w_sm10_0050
integer x = 3072
integer y = 40
integer width = 379
integer height = 324
integer taborder = 100
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 16777215
end type

type pb_1 from u_pic_cal within w_sm10_0050
integer x = 823
integer y = 176
integer height = 76
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;//�ش� �÷� ����
dw_input.SetColumn('jisi_date')

//GS�ڵ尡 Null �̸� ����
IF IsNull(gs_code) THEN Return 

//Gs Code�� ������ ��¥ �� ����
dw_input.SetItem(1, 'jisi_date', gs_code)

end event

type pb_2 from u_pic_cal within w_sm10_0050
boolean visible = false
integer x = 1326
integer y = 176
integer height = 76
integer taborder = 80
boolean bringtotop = true
end type

event clicked;call super::clicked;//�ش� �÷� ����
dw_input.SetColumn('jisi_date2')

//GS�ڵ尡 Null �̸� ����
IF IsNull(gs_code) THEN Return 

//Gs Code�� ������ ��¥ �� ����
dw_input.SetItem(1, 'jisi_date2', gs_code)

end event

type p_2 from picture within w_sm10_0050
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 3653
integer y = 60
integer width = 178
integer height = 144
boolean bringtotop = true
string picturename = "..\image\����_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;This.PictureName = '..\image\����_dn.gif'
end event

event ue_lbuttonup;This.PictureName = '..\image\����_up.gif'
end event

event clicked;Openwithparm(w_sort, dw_insert)
end event

