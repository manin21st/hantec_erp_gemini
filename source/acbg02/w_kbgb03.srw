$PBExportHeader$w_kbgb03.srw
$PBExportComments$Ư�ν�û ���� ���
forward
global type w_kbgb03 from w_inherite
end type
type dw_ip from datawindow within w_kbgb03
end type
type dw_list from datawindow within w_kbgb03
end type
type rr_1 from roundrectangle within w_kbgb03
end type
end forward

global type w_kbgb03 from w_inherite
string title = "Ư�ν�û ���� ���"
dw_ip dw_ip
dw_list dw_list
rr_1 rr_1
end type
global w_kbgb03 w_kbgb03

forward prototypes
public function integer wf_delete (long arg_row)
public function integer wf_save (long arg_row)
end prototypes

public function integer wf_delete (long arg_row);/***************************************************************************/
/* -- ���� ���� �ڷḦ �о �����������Ÿ�� �� �׸� �����Ѵ�.			*/
/* 1. ó�����п� ���� ó��																*/
/*    ���� ���� ���� ó�� : �����������Ÿ�� ADD(FT_GU = '1')					*/
/*    ���� ���� ���� ��� ó�� : �����������Ÿ�� SUB(FT_GU = '2')			*/
/* 2. �������п� ���� �׸��� ����														*/
/*    - �̿�(20),��ܾ���(��������(30)),����(40)									*/
/*      : ��������(FT_GU)�� ���� �ش��׸� ADD(1), SUB(2) ó���Ѵ�.		*/
/*    - �߰�(50) : �ش��׸� ADD�Ѵ�.													*/
/***************************************************************************/

String sSaupj,sExcDate,sExcGbn,sAddCdept,sSubCdept,sAcc1,sAcc2,sYear,sAddMonth,sSubMonth
Long   lExcNo,iCount
Double dExcAmt

sSaupj   = dw_list.Getitemstring(Arg_Row, "saupj")
sExcDate = dw_list.Getitemstring(Arg_Row, "exe_ymd")
lExcNo   = dw_list.GetitemNumber(Arg_Row, "exe_no")
sExcGbn  = dw_list.Getitemstring(Arg_Row, "exe_gu")
dExcAmt  = dw_list.Getitemnumber(Arg_Row, "exe_amt")
IF IsNull(dExcAmt) THEN dExcAmt =0

sYear = Left(sExcDate,4)

Setpointer(HourGlass!)

SELECT "KFE02OT0"."DEPT_CD",   "KFE02OT0"."ACC_MM",  	/*��������ó�� �� ��ȸ-����*/
		 "KFE02OT0"."ACC1_CD",   "KFE02OT0"."ACC2_CD"      
	INTO :sAddCdept,				 :sAddMonth,
		  :sAcc1, 					 :sAcc2
   FROM "KFE02OT0" 
	WHERE "KFE02OT0"."SAUPJ"  = :sSaupj AND "KFE02OT0"."EXE_YMD" = :sExcDate AND 
			"KFE02OT0"."EXE_NO" = :lExcNo AND "KFE02OT0"."FT_GU"  = '1'  ;
IF SQLCA.SQLCODE <> 0 THEN
	F_MessageChk(14,'[���������ڷ�]')
	Return -1
END IF

SELECT Count(*) 	INTO :iCount					/* ���� ���� ����Ÿ TABLE */
	FROM "KFE01OM0"  
	WHERE "KFE01OM0"."SAUPJ"   = :sSaupj    AND "KFE01OM0"."ACC_YY"  = :sYear AND   
         "KFE01OM0"."ACC_MM"  = :sAddMonth AND "KFE01OM0"."ACC1_CD" = :sAcc1 AND    
         "KFE01OM0"."ACC2_CD" = :sAcc2     AND "KFE01OM0"."DEPT_CD" = :sAddCdept ;
IF SQLCA.SQLCODE <> 0 THEN
	F_MessageChk(14,'[��������ڷ�]')
	Return -1
END IF

IF sExcGbn = '20' THEN								/*�����̿�*/
	UPDATE "KFE01OM0"
		SET "BGK_AMT2"  = "BGK_AMT2" - :dExcAmt
	 	WHERE "SAUPJ"   = :sSaupj    AND "ACC_YY"  = :sYear AND   
         	"ACC_MM"  = :sAddMonth AND "ACC1_CD" = :sAcc1 AND    
         	"ACC2_CD" = :sAcc2     AND "DEPT_CD" = :sAddCdept ;	  
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(13,'[�������-�̿�]')
		return -1 
	END IF
ELSEIF sExcGbn = '30' THEN							/* ��ܾ���(��������) */
	UPDATE "KFE01OM0"
		SET "BGK_AMT4"  = "BGK_AMT4" - :dExcAmt
	 	WHERE "SAUPJ"   = :sSaupj    AND "ACC_YY"  = :sYear AND   
         	"ACC_MM"  = :sAddMonth AND "ACC1_CD" = :sAcc1 AND    
         	"ACC2_CD" = :sAcc2     AND "DEPT_CD" = :sAddCdept ;	  
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(13,'[�������-��ܾ���]')
		return -1 
	END IF
ELSEIF sExcGbn = "40" then  						/* ���� */
	UPDATE "KFE01OM0"
		SET "BGK_AMT5"  = "BGK_AMT5" - :dExcAmt
	 	WHERE "SAUPJ"   = :sSaupj    AND "ACC_YY"  = :sYear AND   
         	"ACC_MM"  = :sAddMonth AND "ACC1_CD" = :sAcc1 AND    
         	"ACC2_CD" = :sAcc2     AND "DEPT_CD" = :sAddCdept ;	  
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(13,'[�������-����]')
		return -1 
	END IF
ELSEIF sExcGbn = "50" THEN						  /* �߰� */
	UPDATE "KFE01OM0"
		SET "BGK_AMT6"  = "BGK_AMT6" - :dExcAmt
	 	WHERE "SAUPJ"   = :sSaupj    AND "ACC_YY"  = :sYear AND   
         	"ACC_MM"  = :sAddMonth AND "ACC1_CD" = :sAcc1 AND    
         	"ACC2_CD" = :sAcc2     AND "DEPT_CD" = :sAddCdept ;	  
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(13,'[�������-�߰�]')
		return -1 
	END IF
END IF

IF sExcGbn <> "50" THEN   		/*�߰������϶� ���� �׸��� �������� �����Ƿ� �׸� ����ó��*/
	SELECT "KFE02OT0"."DEPT_CD",   "KFE02OT0"."ACC_MM",  	/*��������ó�� �� ��ȸ-����*/
			 "KFE02OT0"."ACC1_CD",   "KFE02OT0"."ACC2_CD"      
		INTO :sSubCdept,				 :sSubMonth,
			  :sAcc1, 					 :sAcc2
		FROM "KFE02OT0" 
		WHERE "KFE02OT0"."SAUPJ"  = :sSaupj AND "KFE02OT0"."EXE_YMD" = :sExcDate AND 
				"KFE02OT0"."EXE_NO" = :lExcNo AND "KFE02OT0"."FT_GU"  = '2'   ;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(14,'[���������ڷ�]')
		Return -1
	END IF
	
	SELECT Count(*) 	INTO :iCount					/* ���� ���� ����Ÿ TABLE */
		FROM "KFE01OM0"  
		WHERE "KFE01OM0"."SAUPJ"   = :sSaupj    AND "KFE01OM0"."ACC_YY"  = :sYear AND   
				"KFE01OM0"."ACC_MM"  = :sSubMonth AND "KFE01OM0"."ACC1_CD" = :sAcc1 AND    
				"KFE01OM0"."ACC2_CD" = :sAcc2     AND "KFE01OM0"."DEPT_CD" = :sSubCdept ;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(14,'[��������ڷ�]')
		Return -1
	END IF

   IF sExcGbn = "20" THEN								/* �̿� */
		UPDATE "KFE01OM0"								/*�����̿��ݾ� = �����̿��ݾ� - �����ݾ�*/
			SET "BGK_AMT3" = "BGK_AMT3" - :dExcAmt
		 	WHERE "SAUPJ"   = :sSaupj    AND "ACC_YY"  = :sYear AND   
				   "ACC_MM"  = :sSubMonth AND "ACC1_CD" = :sAcc1 AND    
				   "ACC2_CD" = :sAcc2     AND "DEPT_CD" = :sSubCdept ;
		IF SQLCA.SQLCODE <> 0 THEN
			F_MessageChk(13,'[�������-�̿�]')
			return -1 
		END IF
	ELSEIF sExcGbn = "30" then   /* ��ܾ���(��������) */
		UPDATE "KFE01OM0"
			SET "BGK_AMT4" = "BGK_AMT4" + :dExcAmt
		 	WHERE "SAUPJ"   = :sSaupj    AND "ACC_YY"  = :sYear AND   
				   "ACC_MM"  = :sSubMonth AND "ACC1_CD" = :sAcc1 AND    
				   "ACC2_CD" = :sAcc2     AND "DEPT_CD" = :sSubCdept ;
		IF SQLCA.SQLCODE <> 0 THEN
			F_MessageChk(13,'[�������-��ܾ���]')
			return -1 
		END IF
	ELSEIF sExcGbn = "40" then  /* ���� */
		UPDATE "KFE01OM0"
			SET "BGK_AMT5" = "BGK_AMT5" + :dExcAmt
		 	WHERE "SAUPJ"   = :sSaupj    AND "ACC_YY"  = :sYear AND   
				   "ACC_MM"  = :sSubMonth AND "ACC1_CD" = :sAcc1 AND    
				   "ACC2_CD" = :sAcc2     AND "DEPT_CD" = :sSubCdept ;
		IF SQLCA.SQLCODE <> 0 THEN
			F_MessageChk(13,'[�������-��ܾ���]')
			return -1 
		END IF	
	END IF
END IF

return 1

end function

public function integer wf_save (long arg_row);/***************************************************************************/
/* -- ���� ���� �ڷḦ �о �����������Ÿ�� �� �׸� �����Ѵ�.			*/
/* 1. ó�����п� ���� ó��																*/
/*    ���� ���� ���� ó�� : �����������Ÿ�� ADD(FT_GU = '1')					*/
/*    ���� ���� ���� ��� ó�� : �����������Ÿ�� SUB(FT_GU = '2')			*/
/* 2. �������п� ���� �׸��� ����														*/
/*    - �̿�(20),��ܾ���(��������(30)),����(40)									*/
/*      : ��������(FT_GU)�� ���� �ش��׸� ADD(1), SUB(2) ó���Ѵ�.		*/
/*    - �߰�(50) : �ش��׸� ADD�Ѵ�.													*/
/***************************************************************************/

String sSaupj,sExcDate,sExcGbn,sAddCdept,sSubCdept,sAcc1,sAcc2,sYear,sAddMonth,sSubMonth
Long   lExcNo,iCount
Double dExcAmt

sSaupj   = dw_list.Getitemstring(Arg_Row, "saupj")
sExcDate = dw_list.Getitemstring(Arg_Row, "exe_ymd")
lExcNo   = dw_list.GetitemNumber(Arg_Row, "exe_no")
sExcGbn  = dw_list.Getitemstring(Arg_Row, "exe_gu")
dExcAmt  = dw_list.Getitemnumber(Arg_Row, "exe_amt")
IF IsNull(dExcAmt) THEN dExcAmt =0

sYear = Left(sExcDate,4)

Setpointer(HourGlass!)

SELECT "KFE02OT0"."DEPT_CD",   "KFE02OT0"."ACC_MM",  	/*��������ó�� �� ��ȸ-����*/
		 "KFE02OT0"."ACC1_CD",   "KFE02OT0"."ACC2_CD"      
	INTO :sAddCdept,				 :sAddMonth,
		  :sAcc1, 					 :sAcc2
   FROM "KFE02OT0" 
	WHERE "KFE02OT0"."SAUPJ"  = :sSaupj AND "KFE02OT0"."EXE_YMD" = :sExcDate AND 
			"KFE02OT0"."EXE_NO" = :lExcNo AND "KFE02OT0"."FT_GU"  = '1'   ;
IF SQLCA.SQLCODE <> 0 THEN
	F_MessageChk(14,'[���������ڷ�]')
	Return -1
END IF

SELECT Count(*) 	INTO :iCount					/* ���� ���� ����Ÿ TABLE */
	FROM "KFE01OM0"  
	WHERE "KFE01OM0"."SAUPJ"   = :sSaupj    AND "KFE01OM0"."ACC_YY"  = :sYear AND   
         "KFE01OM0"."ACC_MM"  = :sAddMonth AND "KFE01OM0"."ACC1_CD" = :sAcc1 AND    
         "KFE01OM0"."ACC2_CD" = :sAcc2     AND "KFE01OM0"."DEPT_CD" = :sAddCdept ;
IF SQLCA.SQLCODE <> 0 THEN
	F_MessageChk(14,'[��������ڷ�]')
	Return -1
END IF

IF sExcGbn = '20' THEN								/*�����̿�*/
	UPDATE "KFE01OM0"
		SET "BGK_AMT2"  = "BGK_AMT2" + :dExcAmt
	 	WHERE "SAUPJ"   = :sSaupj    AND "ACC_YY"  = :sYear AND   
         	"ACC_MM"  = :sAddMonth AND "ACC1_CD" = :sAcc1 AND    
         	"ACC2_CD" = :sAcc2     AND "DEPT_CD" = :sAddCdept ;	  
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(13,'[�������-�̿�]')
		return -1 
	END IF
ELSEIF sExcGbn = '30' THEN							/* ��ܾ���(��������) */
	UPDATE "KFE01OM0"
		SET "BGK_AMT4"  = "BGK_AMT4" + :dExcAmt
	 	WHERE "SAUPJ"   = :sSaupj    AND "ACC_YY"  = :sYear AND   
         	"ACC_MM"  = :sAddMonth AND "ACC1_CD" = :sAcc1 AND    
         	"ACC2_CD" = :sAcc2     AND "DEPT_CD" = :sAddCdept ;	  
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(13,'[�������-��ܾ���]')
		return -1 
	END IF
ELSEIF sExcGbn = "40" then  						/* ���� */
	UPDATE "KFE01OM0"
		SET "BGK_AMT5"  = "BGK_AMT5" + :dExcAmt
	 	WHERE "SAUPJ"   = :sSaupj    AND "ACC_YY"  = :sYear AND   
         	"ACC_MM"  = :sAddMonth AND "ACC1_CD" = :sAcc1 AND    
         	"ACC2_CD" = :sAcc2     AND "DEPT_CD" = :sAddCdept ;	  
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(13,'[�������-����]')
		return -1 
	END IF
ELSEIF sExcGbn = "50" THEN						  /* �߰� */
	UPDATE "KFE01OM0"
		SET "BGK_AMT6"  = "BGK_AMT6" + :dExcAmt
	 	WHERE "SAUPJ"   = :sSaupj    AND "ACC_YY"  = :sYear AND   
         	"ACC_MM"  = :sAddMonth AND "ACC1_CD" = :sAcc1 AND    
         	"ACC2_CD" = :sAcc2     AND "DEPT_CD" = :sAddCdept ;	  
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(13,'[�������-�߰�]')
		return -1 
	END IF
END IF

IF sExcGbn <> "50" THEN   		/*�߰������϶� ���� �׸��� �������� �����Ƿ� �׸� ����ó��*/
	SELECT "KFE02OT0"."DEPT_CD",   "KFE02OT0"."ACC_MM",  	/*��������ó�� �� ��ȸ-����*/
			 "KFE02OT0"."ACC1_CD",   "KFE02OT0"."ACC2_CD"      
		INTO :sSubCdept,				 :sSubMonth,
			  :sAcc1, 					 :sAcc2
		FROM "KFE02OT0" 
		WHERE "KFE02OT0"."SAUPJ"  = :sSaupj AND "KFE02OT0"."EXE_YMD" = :sExcDate AND 
				"KFE02OT0"."EXE_NO" = :lExcNo AND "KFE02OT0"."FT_GU"  = '2' ;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(14,'[���������ڷ�]')
		Return -1
	END IF
	
	SELECT Count(*) 	INTO :iCount					/* ���� ���� ����Ÿ TABLE */
		FROM "KFE01OM0"  
		WHERE "KFE01OM0"."SAUPJ"   = :sSaupj    AND "KFE01OM0"."ACC_YY"  = :sYear AND   
				"KFE01OM0"."ACC_MM"  = :sSubMonth AND "KFE01OM0"."ACC1_CD" = :sAcc1 AND    
				"KFE01OM0"."ACC2_CD" = :sAcc2     AND "KFE01OM0"."DEPT_CD" = :sSubCdept ;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(14,'[��������ڷ�]')
		Return -1
	END IF

   IF sExcGbn = "20" THEN								/* �̿� */
		UPDATE "KFE01OM0"								/*�����̿��ݾ� = �����̿��ݾ� - �����ݾ�*/
			SET "BGK_AMT3" = Abs("BGK_AMT3" - :dExcAmt)
		 	WHERE "SAUPJ"   = :sSaupj    AND "ACC_YY"  = :sYear AND   
				   "ACC_MM"  = :sSubMonth AND "ACC1_CD" = :sAcc1 AND    
				   "ACC2_CD" = :sAcc2     AND "DEPT_CD" = :sSubCdept ;
		IF SQLCA.SQLCODE <> 0 THEN
			F_MessageChk(13,'[�������-�̿�]')
			return -1 
		END IF
	ELSEIF sExcGbn = "30" then   /* ��ܾ���(��������) */
		UPDATE "KFE01OM0"
			SET "BGK_AMT4" = "BGK_AMT4" - :dExcAmt
		 	WHERE "SAUPJ"   = :sSaupj    AND "ACC_YY"  = :sYear AND   
				   "ACC_MM"  = :sSubMonth AND "ACC1_CD" = :sAcc1 AND    
				   "ACC2_CD" = :sAcc2     AND "DEPT_CD" = :sSubCdept ;
		IF SQLCA.SQLCODE <> 0 THEN
			F_MessageChk(13,'[�������-��ܾ���]')
			return -1 
		END IF
	ELSEIF sExcGbn = "40" then  /* ���� */
		UPDATE "KFE01OM0"
			SET "BGK_AMT5" = "BGK_AMT5" - :dExcAmt
		 	WHERE "SAUPJ"   = :sSaupj    AND "ACC_YY"  = :sYear AND   
				   "ACC_MM"  = :sSubMonth AND "ACC1_CD" = :sAcc1 AND    
				   "ACC2_CD" = :sAcc2     AND "DEPT_CD" = :sSubCdept ;
		IF SQLCA.SQLCODE <> 0 THEN
			F_MessageChk(13,'[�������-��ܾ���]')
			return -1 
		END IF	
	END IF
END IF

return 1

end function

on w_kbgb03.create
int iCurrent
call super::create
this.dw_ip=create dw_ip
this.dw_list=create dw_list
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_ip
this.Control[iCurrent+2]=this.dw_list
this.Control[iCurrent+3]=this.rr_1
end on

on w_kbgb03.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_ip)
destroy(this.dw_list)
destroy(this.rr_1)
end on

event open;call super::open;ListviewItem		lvi_Current
lvi_Current.Data = Upper(This.ClassName())
lvi_Current.Label = This.Title
lvi_Current.PictureIndex = 1

w_mdi_frame.lv_open_menu.additem(lvi_Current)

is_today = f_today()
is_totime = f_totime()
is_window_id = this.ClassName()

w_mdi_frame.st_window.Text = Upper(is_window_id)
dw_ip.SetTransObject(sqlca)
dw_list.SetTransObject(sqlca)

dw_ip.reset()
dw_list.reset()

dw_ip.insertrow(0)


dw_ip.SetItem(1, 'exe_symd', string(today(), 'YYYYMM') + '01')
dw_ip.SetItem(1, 'exe_eymd', string(today(), 'YYYYMMDD'))
dw_ip.SetItem(1, 'dept_cd', Gs_Dept)

dw_ip.setcolumn('exe_symd')
dw_ip.setfocus()
end event

type dw_insert from w_inherite`dw_insert within w_kbgb03
boolean visible = false
integer x = 1856
integer y = 2884
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kbgb03
boolean visible = false
integer x = 3579
integer y = 3004
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kbgb03
boolean visible = false
integer x = 3406
integer y = 3004
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kbgb03
boolean visible = false
integer x = 2711
integer y = 3004
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_kbgb03
boolean visible = false
integer x = 3232
integer y = 3004
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kbgb03
integer y = 0
integer taborder = 50
end type

type p_can from w_inherite`p_can within w_kbgb03
boolean visible = false
integer x = 4101
integer y = 3004
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_kbgb03
boolean visible = false
integer x = 2885
integer y = 3004
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kbgb03
integer x = 4096
integer y = 0
end type

event p_inq::clicked;call super::clicked;string ls_saupj, ls_sdate, ls_edate, ls_dept_cd, ls_gbn

if dw_ip.AcceptText() = -1 then return
if dw_list.AcceptText() = -1 then return

ls_saupj = '%'

ls_dept_cd = dw_ip.GetItemString(1, 'dept_cd')       // ����μ�
ls_sdate = dw_ip.GetItemString(1, 'exe_symd')        // ������û��������
ls_edate = dw_ip.GetItemString(1, 'exe_eymd')        // ������û��������
ls_gbn = dw_ip.GetItemString(1, 'exe_alc')           // ó������

IF isnull(ls_dept_cd) or trim(ls_dept_cd) = "" then 
	ls_dept_cd = "" + '%'
end if 

// ��û���� ���� ���ϱ�
if isnull(ls_sdate) or trim(ls_sdate) = "" then
	F_MessageChk(1, "[��û ��������]")
	dw_ip.setcolumn('exe_symd')
	dw_ip.setfocus()
	return 
elseif f_datechk(ls_sdate) = -1 then 
	F_MessageChk(21, "[��û ��������]")
	dw_ip.setcolumn('exe_symd')
	dw_ip.setfocus()
	return 
end if

// �������� ���� ���ϱ�
if isnull(ls_edate) or trim(ls_edate) = "" then
	F_MessageChk(1, "[��û ��������]")
	dw_ip.setcolumn('exe_eymd')
	dw_ip.setfocus()
	return 
elseif f_datechk(ls_edate) = -1 then 
	F_MessageChk(21, "[��û ��������]")
	dw_ip.setcolumn('exe_eymd')
	dw_ip.setfocus()
	return 
end if

// ����������ڿ� ������������ ���ϱ�
if ls_sdate > ls_edate then
	MessageBox("Ȯ ��", "��û �������ڰ� ��û �������ں��� ~r~r Ŭ �� �����ϴ�.!!")
	dw_ip.setcolumn('exe_eymd')
	dw_ip.setfocus()
	return 
end if

dw_list.SetRedraw(false)
if dw_list.retrieve(ls_saupj, ls_sdate, ls_edate, ls_dept_cd, ls_gbn) < 1 then 
	F_MessageChk(14, "")	
	dw_ip.Setcolumn('exe_symd')
	dw_ip.Setfocus()
	dw_list.SetRedraw(true)
   return 
end if
dw_list.SetRedraw(true)
w_mdi_frame.sle_msg.text = "�ڷᰡ ��ȸ�Ǿ����ϴ�.!!"
end event

type p_del from w_inherite`p_del within w_kbgb03
boolean visible = false
integer x = 3927
integer y = 3004
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kbgb03
integer x = 4270
integer y = 0
integer taborder = 40
end type

event p_mod::clicked;call super::clicked;String   sProcGbn
Integer  iRowCount,i

if dw_ip.AcceptText() = -1 then return 
if dw_list.AcceptText() = -1 then return 

iRowCount = dw_list.Rowcount()
if iRowCount <= 0 then return  

sProcGbn = dw_ip.GetItemString(1, 'exe_alc')       /* ó������ */

if MessageBox("��  ��", "�ڷḦ �����Ͻðڽ��ϱ�", QUESTION!, YesNo!) = 2 then return 

FOR i = 1 TO iRowCount
	IF sProcGbn = 'Y' THEN 									/*���� ���*/
		IF dw_list.GetItemString(i, 'exe_alc')	='Y'  then Continue
		IF wf_delete(i) = -1 THEN
			Setpointer(Arrow!)
			RollBack;
			Return
		END IF
	ELSEIF sProcGbn = 'N' then 						/*���� ó��*/
		IF dw_list.GetItemString(i, 'exe_alc')	= 'N' then Continue
		IF wf_save(i) = -1 THEN
			Setpointer(Arrow!)
			Rollback;
			Return
		END IF
	End if
NEXT

IF dw_list.Update() <> 1 THEN
	F_MessageChk(13,'')
	Setpointer(Arrow!)
	Rollback;
	Return
END IF

Commit;

Setpointer(Arrow!)
w_mdi_frame.sle_msg.text = "�ڷᰡ ����Ǿ����ϴ�.!!"

p_inq.TriggerEvent(Clicked!)
end event

type cb_exit from w_inherite`cb_exit within w_kbgb03
boolean visible = false
integer x = 3771
integer y = 2876
end type

type cb_mod from w_inherite`cb_mod within w_kbgb03
boolean visible = false
integer x = 3401
integer y = 2876
end type

type cb_ins from w_inherite`cb_ins within w_kbgb03
boolean visible = false
integer x = 1225
integer y = 2948
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_kbgb03
boolean visible = false
integer x = 1577
integer y = 2944
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_kbgb03
boolean visible = false
integer x = 3049
integer y = 2876
end type

type cb_print from w_inherite`cb_print within w_kbgb03
boolean visible = false
integer x = 1934
integer y = 2940
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_kbgb03
boolean visible = false
end type

type cb_can from w_inherite`cb_can within w_kbgb03
boolean visible = false
integer x = 2295
integer y = 2936
boolean enabled = false
end type

type cb_search from w_inherite`cb_search within w_kbgb03
boolean visible = false
integer x = 2656
integer y = 2944
boolean enabled = false
end type

type dw_datetime from w_inherite`dw_datetime within w_kbgb03
boolean visible = false
end type

type sle_msg from w_inherite`sle_msg within w_kbgb03
boolean visible = false
end type

type gb_10 from w_inherite`gb_10 within w_kbgb03
boolean visible = false
end type

type gb_button1 from w_inherite`gb_button1 within w_kbgb03
boolean visible = false
boolean enabled = false
end type

type gb_button2 from w_inherite`gb_button2 within w_kbgb03
boolean visible = false
integer x = 2843
integer y = 2716
integer width = 1125
end type

type dw_ip from datawindow within w_kbgb03
event ue_enterkey pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 46
integer y = 12
integer width = 3141
integer height = 132
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_kbgb03_1"
boolean border = false
boolean livescroll = true
end type

event ue_enterkey;send(handle(this), 256, 9, 0)

return 1

end event

event ue_key;IF keydown(keyF1!) or keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;string ls_sdate, ls_edate, ls_dept_cd, get_code, get_name, &
       snull
		 
SetNull(snull)

if this.GetColumnName() = 'exe_alc' then return 

if this.GetColumnName() = 'exe_symd' then 
	
	if isnull(data) or trim(data) = "" then 
   	F_MessageChk(1, "[��û ��������]")											
		return 1
	end if
	if f_datechk(data) = -1 then 
   	F_MessageChk(21, "[��û ��������]")											
		return 1
	end if
end if

if this.GetColumnName() = 'exe_eymd' then 
	ls_sdate = trim(this.GetItemString(row, 'exe_symd'))
	ls_edate = this.GetText()
	if isnull(ls_edate) or trim(ls_edate) = "" then 
   	F_MessageChk(1, "[��û ��������]")											
		return 	1
	end if

	if f_datechk(ls_edate) = -1 then 
   	F_MessageChk(1, "[��û ��������]")											
		return 1
	end if
	
	if ls_sdate > ls_edate then
		MessageBox("Ȯ ��", "��û �������ڰ� ��û �������ں��� ~r~r Ŭ �� �����ϴ�.!!")
		return 1
	end if

end if	

if this.GetColumnName() = 'dept_cd' then
	ls_dept_cd = this.GetText()
	
	if isnull(ls_dept_cd) or trim(ls_dept_cd) = "" then return
	
	SELECT "KFE03OM0"."DEPTNAME"  
		 INTO :get_name  
		 FROM "KFE03OM0"  
		WHERE "KFE03OM0"."DEPTCODE" = :ls_dept_cd   ;
	if sqlca.sqlcode = 0 then 	
			this.SetItem(1, 'dept_cd', ls_dept_cd)
	end if
end if

end event

event itemerror;return 1
end event

event itemfocuschanged;//Long wnd
//
//wnd =Handle(this)
//
//f_toggle_eng(wnd)
//
end event

type dw_list from datawindow within w_kbgb03
event ue_key pbm_dwnkey
event ue_enterkey pbm_dwnprocessenter
integer x = 73
integer y = 164
integer width = 4530
integer height = 2136
integer taborder = 30
boolean bringtotop = true
string dataobject = "dw_kbgb03_2"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_key;choose case key
	case keypageup!
		this.scrollpriorpage()
	case keypagedown!
		this.scrollnextpage()
	case keyhome!
		this.scrolltorow(1)
	case keyend!
		this.scrolltorow(this.rowcount())
end choose

end event

event ue_enterkey;send(handle(this), 256, 9, 0)

return 1
end event

event clicked;if row <= 0 then
	this.SelectRow(0, FALSE)
else
	this.SelectRow(0, FALSE)
	this.SelectRow(row, TRUE)
	this.ScrollToRow(row)
end if


end event

event rowfocuschanged;//this.SetRowFocusIndicator(Hand!)

this.SelectRow(0,False)
this.SelectRow(currentrow,True)

this.ScrollToRow(currentrow)
  

end event

event editchanged;ib_any_typing = true
end event

event doubleclicked;string ls_saupj, ls_exe_ymd, ls_exe_gu, ls_tot
long ll_exe_no

SetNull(gs_code)
SetNull(gs_codename)
SetNull(ls_tot)

//if dwo.selected and dwo.type = 'column' then  
if dwo.type = 'column' then  
	
	if row < 1 then return 
//	if this.AcceptText() = -1 then return 
	
   ls_saupj = this.GetItemString(row, 'saupj')	 
	ls_exe_ymd = this.GetItemString(row, 'exe_ymd')  
	ls_exe_gu = this.GetItemString(row, 'exe_gu')  
	ll_exe_no = this.GetItemNumber(row, 'exe_no')
	if trim(ls_saupj) = '' or isnull(ls_saupj) then 
		f_MessageChk(1, "[�����]")
		return 
	end if
	
	if trim(ls_exe_ymd) = '' or isnull(ls_exe_ymd) then 
		f_MessageChk(1, "[��������]")
		return 
	end if

	if trim(ls_exe_gu) = '' or isnull(ls_exe_gu) then 
		f_MessageChk(1, "[��������]")
		return 
	end if
	
	if trim(string(ll_exe_no)) = '' or isnull(ll_exe_no) then 
		f_MessageChk(1, "[������ȣ]")
		return 
	end if
	
	ls_tot = ls_saupj + ls_exe_ymd + ls_exe_gu + string(ll_exe_no, '0000')

	OpenWithParm(w_kbgb01b, ls_tot) 
end if

end event

event itemerror;return 1
end event

type rr_1 from roundrectangle within w_kbgb03
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 156
integer width = 4558
integer height = 2152
integer cornerheight = 40
integer cornerwidth = 55
end type

