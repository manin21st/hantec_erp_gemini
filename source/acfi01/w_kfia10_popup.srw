$PBExportHeader$w_kfia10_popup.srw
$PBExportComments$������ǥå �������
forward
global type w_kfia10_popup from window
end type
type p_exit from uo_picture within w_kfia10_popup
end type
type p_can from uo_picture within w_kfia10_popup
end type
type dw_1 from u_key_enter within w_kfia10_popup
end type
type cb_1 from commandbutton within w_kfia10_popup
end type
type dw_update from datawindow within w_kfia10_popup
end type
end forward

global type w_kfia10_popup from window
integer x = 800
integer y = 476
integer width = 1691
integer height = 972
boolean titlebar = true
string title = "����/��ǥå ����"
windowtype windowtype = response!
long backcolor = 32106727
p_exit p_exit
p_can p_can
dw_1 dw_1
cb_1 cb_1
dw_update dw_update
end type
global w_kfia10_popup w_kfia10_popup

type variables
Boolean itemerr =False
s_us_in lstr_us_in                 //������ǥ

end variables

event open;string scv_name, schk_no, scount
long dchk_no, dchk_no1, ilength, ilen

f_window_center_Response(this)

dw_1.SetTransObject(SQLCA)
dw_1.Reset()

dw_1.SetRedraw(False)
   
SELECT MAX("KFM06OT0"."CHECK_NO")  INTO :schk_no  
	FROM "KFM06OT0"  ;

dchk_no = long(schk_no) 
dchk_no1 = long(schk_no) + 1
  
scount=string(dchk_no1)
ilength = 8 - len(scount)
IF ilength <> 0 THEN
	FOR ilen = 1 TO ilength
   	scount = '0' + scount
   NEXT
END IF

dw_1.InsertRow(0)
dw_1.SetItem(dw_1.GetRow(),"check_no1", scount)
dw_1.SetItem(dw_1.GetRow(),"check_no2", scount)
dw_1.SetItem(dw_1.GetRow(),"pur_date",  F_Today())	
dw_1.SetRedraw(True)


dw_1.SetColumn("check_no1")
dw_1.SetFocus()


end event

on w_kfia10_popup.create
this.p_exit=create p_exit
this.p_can=create p_can
this.dw_1=create dw_1
this.cb_1=create cb_1
this.dw_update=create dw_update
this.Control[]={this.p_exit,&
this.p_can,&
this.dw_1,&
this.cb_1,&
this.dw_update}
end on

on w_kfia10_popup.destroy
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.dw_1)
destroy(this.cb_1)
destroy(this.dw_update)
end on

type p_exit from uo_picture within w_kfia10_popup
integer x = 1280
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\create.cur"
string picturename = "C:\erpman\image\ó��_up.gif"
end type

event clicked;call super::clicked;string schk_no, schk_no2, schk_bnk, schk_gu, schk_dat, scount, s_no
long icount, irow, lchk_no, lchk_no2, ilen, ilength, irow_no

dw_update.SetTransObject(SQLCA)

IF dw_1.AcceptText() = -1 then return 

schk_no   = Trim(dw_1.GetitemString(1, "check_no1"))
schk_no2  = Trim(dw_1.GetitemString(1, "check_no2"))
schk_bnk  = dw_1.GetitemString(1, "check_bnk")
schk_gu   = dw_1.GetitemString(1, "check_gu")
schk_dat  = Trim(dw_1.GetitemString(1, "pur_date"))

IF schk_no ="" OR ISNULL(schk_no) THEN
	MessageBox("Ȯ��", "������ȣ�� �Է��Ͻʽÿ�.!!")
   dw_1.SetColumn("check_no1")
   dw_1.SetFocus()
   Return 1
END IF

IF schk_no2 ="" OR ISNULL(schk_no2) THEN
	MessageBox("Ȯ��", "������ȣ�� �Է��Ͻʽÿ�.!!")
   dw_1.SetColumn("check_no2")
   dw_1.SetFocus()
   Return 1
END IF

lchk_no = long(schk_no)
lchk_no2 = long(schk_no2)
IF lchk_no = 0 THEN
	MessageBox("Ȯ��", "������ȣ�� Ȯ���Ͻʽÿ�.!!")
   dw_1.SetColumn("check_no1")
   dw_1.SetFocus()
   Return 1
END IF
IF lchk_no2 = 0 THEN
	MessageBox("Ȯ��", "������ȣ�� Ȯ���Ͻʽÿ�.!!")
   dw_1.SetColumn("check_no2")
   dw_1.SetFocus()
   Return 1
END IF

IF lchk_no > lchk_no2 THEN
	MessageBox("Ȯ��", "������ȣ ������ Ȯ���Ͻʽÿ�.!!")
   dw_1.SetColumn("check_no2")
   dw_1.SetFocus()
   Return 1
END IF

IF schk_bnk ="" OR ISNULL(schk_bnk) THEN
	MessageBox("Ȯ��", "��������� �Է��Ͻʽÿ�.!!")
   dw_1.SetColumn("check_bnk")
   dw_1.SetFocus()
   Return 1
END IF

IF schk_dat ="" OR ISNULL(schk_dat) THEN
	MessageBox("Ȯ��", "�������ڸ� �Է��Ͻʽÿ�.!!")
   dw_1.SetColumn("pur_date")
   dw_1.SetFocus()
   Return 1
END IF         
IF f_datechk(schk_dat) = -1 THEN
	MessageBox("Ȯ��", "�������ڸ� Ȯ���Ͻʽÿ�.!!")
   dw_1.SetColumn("pur_date")
   dw_1.SetFocus()
	Return 1
END IF
FOR icount = lchk_no TO lchk_no2 STEP 1
    scount=string(icount)
	 ilength = 8 - len(scount)
	 IF ilength <> 0 THEN      // ex) 12���̸� '00000012'���� ����� ��
	    FOR ilen = 1 TO ilength
           scount = '0' + scount
       NEXT
	 END IF
	       
	 IF icount = lchk_no THEN  
       lstr_us_in.schk_no1 = scount 
	 END IF	 
	
	SELECT "KFM06OT0"."CHECK_NO"  
    INTO :s_no
	 FROM "KFM06OT0"  
   WHERE "KFM06OT0"."CHECK_NO" = :scount ;

 	IF SQLCA.SQLCODE <> 0 THEN
      irow = dw_update.insertrow(0) 
	   dw_update.SetItem(irow, "check_no", scount)
	   dw_update.SetItem(irow, "check_bnk", schk_bnk)
	   dw_update.SetItem(irow, "check_gu", schk_gu)
	   dw_update.SetItem(irow, "pur_date", schk_dat)
	   dw_update.SetItem(irow, "use_gu", '0') //��뱸���� 0(�̻��)���� setting
	   irow_no = irow_no + 1
   ELSE
		MessageBox("Ȯ��", "������ȣ "+s_no+" ���� �̹� �����մϴ�.!!!")
  	END IF

	NEXT

IF irow_no < 1 THEN
	MessageBox("Ȯ��", "������ǥ���� ������ �����Ͽ����ϴ�.!!!")   
   RETURN
END IF
   
IF dw_update.Update() = 1 THEN
   IF schk_gu = '1' THEN 
      MessageBox("Ȯ��", "��ǥ���� "+string(irow_no)+"���� �����Ǿ����ϴ�.!!!")   
   ELSE
      MessageBox("Ȯ��", "�������� "+string(irow_no)+"���� �����Ǿ����ϴ�.!!!")   
   END IF		
ELSE
	ROLLBACK;
	RETURN
END IF

lstr_us_in.schk_bnk = schk_bnk 
lstr_us_in.schk_bnk2 = schk_bnk 
lstr_us_in.spur_date = schk_dat 
lstr_us_in.spur_date2 = schk_dat 
lstr_us_in.schk_gu = schk_gu 
lstr_us_in.schk_no2 = scount 
lstr_us_in.suse_gu = '0'  
lstr_us_in.flag = '1'  

CloseWithReturn(parent, lstr_us_in)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\ó��_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\ó��_up.gif"
end event

type p_can from uo_picture within w_kfia10_popup
integer x = 1454
integer width = 178
integer taborder = 30
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\���_up.gif"
end type

event clicked;call super::clicked;
lstr_us_in.flag = '2'  
closeWithReturn(parent, lstr_us_in)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\���_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\���_up.gif"
end event

type dw_1 from u_key_enter within w_kfia10_popup
integer y = 152
integer width = 1646
integer height = 676
integer taborder = 10
string dataobject = "dw_kfia10_popup"
boolean border = false
end type

type cb_1 from commandbutton within w_kfia10_popup
boolean visible = false
integer x = 946
integer y = 1340
integer width = 247
integer height = 108
integer textsize = -12
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = roman!
string facename = "����ü"
string text = "none"
end type

event clicked;//Long ll_udchk,ll_vuga_no,ll_sortno,chk
//Double ldb_sum, ldb_amt
//String ls_saupno, ls_taxno, ls_iogu,ls_date,save_date,save_geyyy,save_geymm,save_geydd
//
//save_geyyy  = Trim(dw_1.GetItemString(dw_1.GetRow(), "kfz17ot0_gey_yy"))
//save_geymm  = Trim(dw_1.GetItemString(dw_1.GetRow(), "kfz17ot0_gey_mm"))
//save_geydd  = Trim(dw_1.GetItemString(dw_1.GetRow(), "kfz17ot0_gey_dd"))
//
//dw_1.AcceptText()
//ll_sortno = dw_1.GetItemNumber(dw_1.GetRow(),"kfz17ot0_lin_no")
//ldb_sum   = dw_1.GetItemNumber(dw_1.GetRow(),"kfz17ot0_vat_amt")
//ldb_amt   = dw_1.GetItemNumber(dw_1.GetRow(), "kfz17ot0_gon_amt")
//ls_geyyy  = Trim(dw_1.GetItemString(dw_1.GetRow(), "kfz17ot0_gey_yy"))
//ls_geymm  = Trim(dw_1.GetItemString(dw_1.GetRow(), "kfz17ot0_gey_mm"))
//ls_geydd  = Trim(dw_1.GetItemString(dw_1.GetRow(), "kfz17ot0_gey_dd"))
//ls_saupno = Trim(dw_1.GetItemString(dw_1.GetRow(), "saup_no2"))
//ls_taxno  = dw_1.GetItemString(dw_1.GetRow(), "kfz17ot0_tax_no")
//ls_iogu   = dw_1.GetItemString(dw_1.GetRow(), "kfz17ot0_io_gu")
//
//save_date =save_geyyy+"/"+save_geymm+"/"+save_geydd
//ls_date =ls_geyyy+"/"+ls_geymm+"/"+ls_geydd
//IF is_button_chk ="��ȸ" AND gl_yymm ="����" THEN
//	IF save_date <> ls_date THEN
//		MessageBox("Ȯ  ��","��꼭���ڴ� ������ �� �����ϴ�.!!!")
//		dw_1.SetItem(dw_1.GetRow(),"kfz17ot0_gey_yy",save_geyyy)
//		dw_1.SetItem(dw_1.GetRow(),"kfz17ot0_gey_mm",save_geymm)
//		dw_1.SetItem(dw_1.GetRow(),"kfz17ot0_gey_dd",save_geydd)
//		dw_1.SetColumn("kfz17ot0_tax_no")
//		dw_1.SetFocus()
//   	return	
//	END IF
//END IF	
//IF ls_geyyy = "" OR IsNull(ls_geyyy) THEN
//   MessageBox("�Է�Ȯ��", "��꼭���ڸ� �Է��Ͻʽÿ�")
//	dw_1.SetColumn("kfz17ot0_gey_yy")
//	dw_1.SetFocus()
//   return
//END IF
//IF ls_geymm = "" OR IsNull(ls_geymm) THEN
//   MessageBox("�Է�Ȯ��", "��꼭���ڸ� �Է��Ͻʽÿ�")
//	dw_1.SetColumn("kfz17ot0_gey_mm")
//	dw_1.SetFocus()
//   return
//END IF
//IF ls_geydd = "" OR IsNull(ls_geydd) THEN
//   MessageBox("�Է�Ȯ��", "��꼭���ڸ� �Է��Ͻʽÿ�")
//	dw_1.SetColumn("kfz17ot0_gey_dd")
//	dw_1.SetFocus()
//   return
//END IF
//
//IF IsDate(ls_date) THEN
//ELSE
//   MessageBox("�Է�Ȯ��", "��꼭���ڸ� Ȯ���Ͻʽÿ�")
//	dw_1.SetColumn("kfz17ot0_gey_yy")
//	dw_1.SetFocus()
//   return
//END IF
//
//IF is_button_chk ="��ȸ" THEN					//��ǥ�� ��ưüũ
//	IF gl_yymm ="����" THEN						//�ΰ����� ��ưüũ	
//  		SELECT "KFZ17OT0"."SEQ_NO"  
//    		INTO :get_vuga_no
//    		FROM "KFZ17OT0"  
//   		WHERE ( "KFZ17OT0"."SAUPJ" = :lstr_jpra.saupjang ) AND  
//         		( "KFZ17OT0"."BAL_YY" = :lstr_jpra.publyy ) AND  
//         		( "KFZ17OT0"."BAL_MM" = :lstr_jpra.publmm ) AND  
//         		( "KFZ17OT0"."BAL_DD" = :lstr_jpra.publdd ) AND  
//         		( "KFZ17OT0"."UPMU_GU" = :lstr_jpra.jonpoyno2 ) AND  
//         		( "KFZ17OT0"."JUN_NO" = :lstr_jpra.jonpoyno1 ) AND  
//         		( "KFZ17OT0"."LIN_NO" = :lstr_jpra.sortno )   ;
//  		IF SQLCA.SQLCODE =0 THEN
//  		ELSE
//			MessageBox("Ȯ  ��","�ΰ��� ��ȣ�� ã�� �� �����ϴ�.!!!")
//			Return
//		END IF	
//	END IF
//ELSE
//  SELECT MAX("KFZ17OT0"."SEQ_NO")  
//    INTO :get_vuga_no  
//    FROM "KFZ17OT0"  
//    WHERE "KFZ17OT0"."BAL_YY" = :lstr_jpra.publyy;
//  IF SQLCA.SQLCODE =0 THEN
//		IF IsNull(get_vuga_no) OR get_vuga_no =0 THEN
//			get_vuga_no =1
//		ELSE
//			get_vuga_no =get_vuga_no + 1
//		END IF
//  END IF
//  chk =get_vuga_no
//  SELECT "KFZ17OT0"."SEQ_NO"  
//    INTO :ll_vuga_no  
//    FROM "KFZ17OT0"  
//   WHERE ( "KFZ17OT0"."SAUPJ" = :lstr_jpra.saupjang ) AND  
//         ( "KFZ17OT0"."BAL_YY" = :lstr_jpra.publyy ) AND  
//         ( "KFZ17OT0"."BAL_MM" = :lstr_jpra.publmm ) AND  
//         ( "KFZ17OT0"."BAL_DD" = :lstr_jpra.publdd ) AND  
//         ( "KFZ17OT0"."UPMU_GU" = :lstr_jpra.jonpoyno2 ) AND  
//         ( "KFZ17OT0"."JUN_NO" = :lstr_jpra.jonpoyno1 ) AND  
//         ( "KFZ17OT0"."LIN_NO" = :lstr_jpra.sortno )   ;
//  IF SQLCA.SQLCODE =0 THEN
//		MessageBox("Ȯ  ��","��꼭����,��꼭��ȣ�� �ߺ��Ǿ����ϴ�.!!")
//		dw_1.SetColumn("kfz17ot0_gey_yy")
//		dw_1.SetFocus()
//		Return
//	ELSE
//		INSERT INTO "KFZ17OT0"  
//         	(  "GEY_YY",   
//           		"GEY_MM",   
//           		"GEY_DD",   
//           		"SEQ_NO",
//					"SAUP_NO",
//					"BAL_YY")  
//  		VALUES ( :ls_geyyy,   
//           		:ls_geymm,   
//           		:ls_geydd,   
//           		:get_vuga_no,
//					:lstr_jpra.saupno, 
//					:lstr_jpra.publyy);
//		IF SQLCA.SQLCODE <> 0 THEN
//			MessageBox("Ȯ ��","�ΰ��� ��ȣ ä���� �����߽��ϴ�.!!!")
//			ROLLBACK;
//			dw_1.SetColumn("kfz17ot0_gey_yy")	
//			dw_1.SetFocus()
//			Return
//		END IF		
//  END IF
//END IF
//
//IF ls_taxno = "" OR IsNull(ls_taxno) THEN
//   MessageBox("�Է�Ȯ��", "�ΰ��������� �Է��Ͻʽÿ�")
//	cb_return.TriggerEvent("ue_vugano_delete")
//	dw_1.SetColumn("kfz17ot0_tax_no")
//	dw_1.SetFocus()
//   return
//END IF
//
//IF ldb_sum =0 AND ls_taxno = "01"THEN
//  	MessageBox("�Է�Ȯ��", "������ �Է��Ͻʽÿ�")
//	cb_return.TriggerEvent("ue_vugano_delete")
//	dw_1.SetColumn("kfz17ot0_tax_no")
//	dw_1.SetFocus()
//   return
//END IF	
//IF ldb_sum <> 0 AND ls_taxno ="03" THEN
//  	MessageBox("�Է�Ȯ��", "�ΰ��������� �������̸� ������ 0 �Դϴ�.!")
//	cb_return.TriggerEvent("ue_vugano_delete")
//	dw_1.SetColumn("kfz17ot0_tax_no")
//	dw_1.SetFocus()
//   return
//END IF
//
//IF ldb_sum <> lstr_jpra.money and ls_taxno = "01" THEN
//   MessageBox("Ȯ ��", "�ΰ����װ� ��ǥ�ۼ����� �ݾ��� �ٸ��ϴ� !")
//	cb_return.TriggerEvent("ue_vugano_delete")
//	dw_1.SetColumn("kfz17ot0_vat_amt")
//	dw_1.SetFocus()
//   return
//END IF
//
//IF ldb_amt = 0  THEN
//   MessageBox("�Է�Ȯ��", "���ް����� �Է��Ͻʽÿ�")
//	cb_return.TriggerEvent("ue_vugano_delete")
//	dw_1.SetColumn("kfz17ot0_gon_amt")
//	dw_1.SetFocus()
//   return
//END IF
//
////IF ldb_sum > ldb_amt  THEN
////   MessageBox("Ȯ ��", "�ΰ������� ���ް��׺��� Ů�ϴ�. !")
////	cb_return.TriggerEvent("ue_vugano_delete")
////	dw_1.SetColumn("kfz17ot0_gon_amt")
////	dw_1.SetFocus()
////   return
////END IF
//	
//UPDATE "KFZ17OT0"  
//	SET "GON_AMT" 	= :ldb_amt,   
//       "VAT_AMT" 	= :ldb_sum,   
//       "TAX_NO" 	= :ls_taxno,   
//       "IO_GU"		= :ls_iogu,   
//       "SAUP_NO2" = :ls_saupno,   
//       "SAUPJ" 	= :lstr_jpra.saupjang,   
//       "BAL_YY" 	= :lstr_jpra.publyy,   
//       "BAL_MM" 	= :lstr_jpra.publmm,   
//       "BAL_DD" 	= :lstr_jpra.publdd,   
//       "UPMU_GU" 	= :lstr_jpra.jonpoyno2,   
//       "JUN_NO" 	= :lstr_jpra.jonpoyno1,   
//       "LIN_NO" 	= :ll_sortno,   
//       "ACC1_CD" 	= :lstr_jpra.gaejung1,   
//       "ACC2_CD" 	= :lstr_jpra.gaejung2,   
//       "DESCR" 	= :lstr_jpra.desc  
//   WHERE ( "KFZ17OT0"."GEY_YY" = :ls_geyyy ) AND  
//         ( "KFZ17OT0"."GEY_MM" = :ls_geymm ) AND  
//         ( "KFZ17OT0"."GEY_DD" = :ls_geydd ) AND  
//         ( "KFZ17OT0"."SEQ_NO" = :get_vuga_no )   ;
//IF SQLCA.SQLCODE <> 0 THEN
//   MessageBox("����Ȯ��","������ �����ʾҽ��ϴ� !")
//	ROLLBACK;
//	dw_1.SetColumn("gey_yy")
//	dw_1.SetFocus()
//   return
//END IF
//
//lstr_jpra.flag_buga = "Y"
//gl_yymm =""
//close(parent)
//
//
end event

type dw_update from datawindow within w_kfia10_popup
boolean visible = false
integer x = 64
integer y = 1064
integer width = 690
integer height = 160
boolean titlebar = true
string title = "������ǥå�Է�"
string dataobject = "dw_kfia10_popup1"
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
end type

