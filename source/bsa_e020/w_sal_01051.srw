$PBExportHeader$w_sal_01051.srw
$PBExportComments$ ===> �� �Ǹ� ��ȹ ���
forward
global type w_sal_01051 from w_inherite
end type
type rr_2 from roundrectangle within w_sal_01051
end type
type rr_3 from roundrectangle within w_sal_01051
end type
type dw_jogun from datawindow within w_sal_01051
end type
type cb_add from commandbutton within w_sal_01051
end type
type dw_update from u_key_enter within w_sal_01051
end type
type rr_1 from roundrectangle within w_sal_01051
end type
end forward

global type w_sal_01051 from w_inherite
integer width = 4649
integer height = 2536
string title = "�� �ǸŰ�ȹ ���"
rr_2 rr_2
rr_3 rr_3
dw_jogun dw_jogun
cb_add cb_add
dw_update dw_update
rr_1 rr_1
end type
global w_sal_01051 w_sal_01051

type variables
str_itnct str_sitnct
string is_yymm
end variables

forward prototypes
public function integer wf_check_itnbr (integer lrow, string sitnbr)
public subroutine wf_setnull ()
end prototypes

public function integer wf_check_itnbr (integer lrow, string sitnbr);String syymm, splnym, ssabu, sNull, sToday, sItdsc, sIspec, sshtnm, scvcod
Double dDanga
Long   cnt, lreturnrow

SetNull(sNull)

if dw_insert.AcceptText() = -1 then return -1

lrow   	= dw_insert.getrow()
syymm  	= dw_insert.getitemstring(lrow, 'yymm')
splnym   = dw_insert.getitemstring(lrow, 'plnyymm')
ssabu   	= dw_insert.getitemstring(lrow, 'sabu')
scvcod	= dw_insert.getitemstring(lrow, 'cvcod')
sitnbr	= dw_insert.getitemstring(lrow, 'itnbr')

/* �߰� ǰ���� �����ϴ��� ���� üũ */
Select count(*) 
  Into :cnt 
  From shortsaplan_dtl
 Where sabu    = :ssabu
   and yymm    = :syymm
   and plnyymm = :splnym 
	and cvcod   = :scvcod 
   and itnbr   = :sitnbr;

if cnt > 0 then
  	MessageBox("�ڷ� Ȯ��", "�ش� ǰ���� ��ȹ�� �̹� �����մϴ�.")
	dw_insert.SetItem(lrow, "itnbr", sNull)
	dw_insert.SetItem(lrow, "itdsc", sNull)
	dw_insert.SetItem(lrow, "ispec", sNull)
	dw_insert.setcolumn("itnbr")
	dw_insert.setfocus()
  	return 1			
end if

//��ü ����Ÿ �����쿡�� ���� ǰ���� üũ
lreturnrow = dw_insert.Find("itnbr = '"+ sitnbr +"'and plnyymm = '" + splnym + "'", 1, dw_insert.RowCount())
IF (lrow <> lreturnrow) and (lreturnrow <> 0)THEN
 	f_message_chk(37,'[ǰ��]') 
	wf_setnull()
	dw_insert.setcolumn("itnbr")
	dw_insert.setfocus()
	RETURN  1
END IF
dw_insert.setcolumn("monqty01")
dw_insert.setfocus()
		
Return 0
end function

public subroutine wf_setnull ();string snull
long   lrow

setnull(snull)

lrow   = dw_insert.getrow()

dw_insert.setitem(lrow, "itnbr", snull)	
dw_insert.setitem(lrow, "itdsc", snull)	
dw_insert.setitem(lrow, "ispec", snull)

dw_insert.setitem(lrow, "monqty01", 0)
dw_insert.setitem(lrow, "monqty02", 0)
dw_insert.setitem(lrow, "monqty03", 0)
dw_insert.setitem(lrow, "monqty04", 0)
dw_insert.setitem(lrow, "monqty05", 0)
dw_insert.setitem(lrow, "monqty06", 0)
dw_insert.setitem(lrow, "monqty07", 0)
dw_insert.setitem(lrow, "monqty08", 0)
dw_insert.setitem(lrow, "monqty09", 0)
dw_insert.setitem(lrow, "monqty10", 0)
dw_insert.setitem(lrow, "monqty11", 0)
dw_insert.setitem(lrow, "monqty12", 0)
dw_insert.setitem(lrow, "monqty13", 0)
dw_insert.setitem(lrow, "monqty14", 0)
dw_insert.setitem(lrow, "monqty15", 0)
dw_insert.setitem(lrow, "monqty16", 0)
dw_insert.setitem(lrow, "monqty17", 0)
dw_insert.setitem(lrow, "monqty18", 0)
dw_insert.setitem(lrow, "monqty19", 0)
dw_insert.setitem(lrow, "monqty20", 0)
dw_insert.setitem(lrow, "monqty21", 0)
dw_insert.setitem(lrow, "monqty22", 0)
dw_insert.setitem(lrow, "monqty23", 0)
dw_insert.setitem(lrow, "monqty24", 0)
dw_insert.setitem(lrow, "monqty25", 0)
dw_insert.setitem(lrow, "monqty26", 0)
dw_insert.setitem(lrow, "monqty27", 0)
dw_insert.setitem(lrow, "monqty28", 0)
dw_insert.setitem(lrow, "monqty29", 0)
dw_insert.setitem(lrow, "monqty30", 0)
dw_insert.setitem(lrow, "monqty31", 0)

end subroutine

on w_sal_01051.create
int iCurrent
call super::create
this.rr_2=create rr_2
this.rr_3=create rr_3
this.dw_jogun=create dw_jogun
this.cb_add=create cb_add
this.dw_update=create dw_update
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
this.Control[iCurrent+2]=this.rr_3
this.Control[iCurrent+3]=this.dw_jogun
this.Control[iCurrent+4]=this.cb_add
this.Control[iCurrent+5]=this.dw_update
this.Control[iCurrent+6]=this.rr_1
end on

on w_sal_01051.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
destroy(this.rr_3)
destroy(this.dw_jogun)
destroy(this.cb_add)
destroy(this.dw_update)
destroy(this.rr_1)
end on

event open;call super::open;PostEvent("ue_open")
end event

event ue_open;call super::ue_open;dw_Jogun.SetTransObject(sqlca)
dw_Insert.Settransobject(sqlca)
dw_Update.Settransobject(sqlca)

dw_Jogun.Insertrow(0)
w_mdi_frame.sle_msg.Text = '���� �ǸŰ�ȹ�� ���� �� ������ ��ȹ����� �Է��ϼ���'

dw_Jogun.SetFocus()
end event

type dw_insert from w_inherite`dw_insert within w_sal_01051
integer x = 23
integer y = 1540
integer width = 4576
integer height = 760
integer taborder = 10
boolean titlebar = true
string dataobject = "d_sal_01051_04"
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::itemchanged;string   snull, sitnbr, sitdsc, sispec, syymm, get_itnbr, splnym, scvcod, ssabu, stoym, stoday, scurr,sgubun
integer  ireturn, iseq
long     lrow, lreturnrow
Double   ddanga, dItemPrice, dDcRate

if this.accepttext() = -1 then return 

setnull(snull)

/* �������� */
select to_char(sysdate,'yyyymmdd')
  into :stoday  
  from dual;
 
stoym = left(stoday,6)
 
lrow   	= this.getrow()
syymm  	= this.getitemstring(lrow, 'yymm')
splnym   = this.getitemstring(lrow, 'plnyymm')
ssabu   	= this.getitemstring(lrow, 'sabu')
scvcod	= this.getitemstring(lrow, 'cvcod')
scurr 	= this.getitemstring(lrow, 'curr')

/* ����(�ܰ������� ���) */
If scurr = 'WON' Then
	sgubun = '1'   //��ȭ
Else
	sgubun = '2'   //��ȭ
End If	

Choose 	Case	this.GetColumnName()
	Case 	"itnbr"
		sItnbr = trim(this.GetText())
		if	sitnbr = "" or isnull(sitnbr) then
			wf_setnull()
			return 
		end if	
		
		//��ü ����Ÿ �����쿡�� ���� ��ȹ����/ǰ���� üũ
		lReturnRow = This.Find("itnbr = '"+ sitnbr +"'and plnyymm = '" + splnym + "'", 1, This.RowCount())
		IF (lRow <> lReturnRow) and (lReturnRow <> 0)		THEN
			f_message_chk(37,'[ǰ��]') 
			wf_setnull()
			RETURN  1
		END IF

		
	  //��ϵ� �ڷῡ�� �ߺ� üũ
	  SELECT itnbr 
		 INTO :get_itnbr  
		 FROM shortsaplan_dtl 
		WHERE sabu    = :ssabu 
		  AND yymm    = :syymm 
		  AND plnyymm = :splnym  
		  AND cvcod   = :scvcod
		  AND itnbr   = :sitnbr ;
	
		if sqlca.sqlcode <> 0 then 
			ireturn = f_get_name2('ǰ��', 'Y', sitnbr, sitdsc, sispec)    //1�̸� ����, 0�� ����	
			this.setitem(lrow, "itnbr", sitnbr)	
			this.setitem(lrow, "itdsc", sitdsc)	
			this.setitem(lrow, "ispec", sispec)
			IF ireturn = 0 then
				//�������� ��Ͽ��� üũ
				SELECT A.ITNBR
				  INTO :get_itnbr  
				  FROM ITEMAS A, 
				       ITNCT  B
				 WHERE A.ITTYP = B.ITTYP
 				   AND A.ITCLS = B.ITCLS
					AND A.ITNBR = :sitnbr 
					AND B.PDTGU = '.'
					AND (B.PORGU = :gs_saupj OR B.PORGU = 'ALL') ;
	
				IF SQLCA.SQLCODE <> 0 THEN 
					messagebox('Ȯ��', 'ǰ���� Ȯ���ϼ���' ) 
					wf_setnull()
					RETURN 1
				END IF				
			END IF
			 /* �ܰ� ��� */
			 sqlca.fun_erp100000016(gs_sabu, stoday, scvcod, sitnbr, '.', scurr, sgubun, dItemPrice, dDcRate)
			
			 /* ������2�ڸ� */
			 dItemPrice = Truncate(dItemPrice , 5) 
		
//			 If sgubun = '2' Then //��ȭ�ΰ�� ��ȭ�ܰ��� ȯ��(����ȯ��)
//				 dItemPrice = sqlca.erp000000090_1(stoym, sitnbr, scurr, dItemPrice, sgubun)		
//				 dItemPrice = Truncate(dItemPrice , 5)
//			 End If	 
			 this.SetItem(lrow, "curr", scurr)             //��ȭ����
			 this.SetItem(lrow, "sales_price", dItemPrice) //�ܰ�
	 
			RETURN ireturn
		else
			f_message_chk(37,'[ǰ��]') 
			wf_setnull()
			RETURN 1
		end if		
	Case 	"itdsc"	
		sItdsc = trim(this.GetText())
		if sitdsc = "" or isnull(sitdsc) then
			wf_setnull()
			return 
		end if	
	
		ireturn = f_get_name2('ǰ��', 'Y', sitnbr, sitdsc, sispec)    //1�̸� ����, 0�� ����	
		this.setitem(lrow, "itnbr", sitnbr)	
		this.setitem(lrow, "itdsc", sitdsc)	
		this.setitem(lrow, "ispec", sispec)
		
		if ireturn = 0 then 
		   //��ü ����Ÿ �����쿡�� ���� ��ȹ����/ǰ���� üũ
  		   lReturnRow = This.Find("itnbr = '"+ sitnbr +"'and plnyymm = '" + splnym + "'", 1, This.RowCount())
			IF (lRow <> lReturnRow) and (lReturnRow <> 0)		THEN
				f_message_chk(37,'[ǰ��]') 
				wf_setnull()
				RETURN  1
			END IF
			
			//��ϵ� �ڷῡ�� �ߺ� üũ
		   SELECT itnbr 
			  INTO :get_itnbr  
			  FROM  shortsaplan_dtl 
			 WHERE sabu    = :ssabu 
			   AND yymm    = :syymm 
			   AND plnyymm = :splnym  
			   AND cvcod   = :scvcod
			   AND itnbr   = :sitnbr ;
	
			if sqlca.sqlcode <> 0 then 
				f_message_chk(37,'[ǰ��]') 
				wf_setnull()
				RETURN 1
			else
				//�������� ��ϵǿ����� üũ
				SELECT A.ITNBR
				  INTO :get_itnbr  
				  FROM ITEMAS A, 
				       ITNCT  B
				 WHERE A.ITTYP = B.ITTYP
 				   AND A.ITCLS = B.ITCLS
					AND A.ITNBR = :sitnbr 
					AND B.PDTGU = '.'
					AND (B.PORGU = :gs_saupj OR B.PORGU = 'ALL') ;
	
				IF SQLCA.SQLCODE <> 0 THEN 
					messagebox('Ȯ��', 'ǰ���� Ȯ���ϼ���' ) 
					wf_setnull()
					RETURN 1
				END IF
			end if	
		end if
		
		/* �ܰ� ��� */
		sqlca.fun_erp100000016(gs_sabu, stoday, scvcod, sitnbr, '.', scurr, sgubun, dItemPrice, dDcRate)
		
		/* ������2�ڸ� */
		dItemPrice = Truncate(dItemPrice , 5) 
	
//		If sgubun = '2' Then //��ȭ�ΰ�� ��ȭ�ܰ��� ȯ��(����ȯ��)
//		   dItemPrice = sqlca.erp000000090_1(stoym, sitnbr, scurr, dItemPrice, sgubun)		
//			dItemPrice = Truncate(dItemPrice , 5)
//		End If	 
		this.SetItem(lrow, "curr", scurr)             //��ȭ����
		this.SetItem(lrow, "sales_price", dItemPrice) //�ܰ�
	 
		RETURN ireturn
	Case "ispec"	
		sIspec = trim(this.GetText())
		if sispec = "" or isnull(sispec) then
			wf_setnull()
			return 
		end if	
	
		ireturn = f_get_name2('�԰�', 'Y', sitnbr, sitdsc, sispec)    //1�̸� ����, 0�� ����	
		this.setitem(lrow, "itnbr", sitnbr)	
		this.setitem(lrow, "itdsc", sitdsc)	
		this.setitem(lrow, "ispec", sispec)
		if ireturn = 0 then 
			//��ü ����Ÿ �����쿡�� ���� ��ȹ����/ǰ���� üũ
  		   lReturnRow = This.Find("itnbr = '"+ sitnbr +"'and plnyymm = '" + splnym + "'", 1, This.RowCount())
			IF (lRow <> lReturnRow) and (lReturnRow <> 0)		THEN
				f_message_chk(37,'[ǰ��]') 
				wf_setnull()
				RETURN  1
			END IF
	
			//��ϵ� �ڷῡ�� �ߺ� üũ
		   SELECT itnbr 
			  INTO :get_itnbr  
			  FROM  shortsaplan_dtl 
			 WHERE sabu    = :ssabu 
			   AND yymm    = :syymm 
			   AND plnyymm = :splnym  
			   AND cvcod   = :scvcod
			   AND itnbr   = :sitnbr ;
		
			if sqlca.sqlcode <> 0 then 
				f_message_chk(37,'[ǰ��]') 
				wf_setnull()
				RETURN 1
			else
				//�������� ��ϵǿ����� üũ
				SELECT A.ITNBR
				  INTO :get_itnbr  
				  FROM ITEMAS A, 
				       ITNCT  B
				 WHERE A.ITTYP = B.ITTYP
 				   AND A.ITCLS = B.ITCLS
					AND A.ITNBR = :sitnbr 
					AND B.PDTGU = '.'
					AND (B.PORGU = :gs_saupj OR B.PORGU = 'ALL') ;
	
				IF SQLCA.SQLCODE <> 0 THEN 
					messagebox('Ȯ��', 'ǰ���� Ȯ���ϼ���' ) 
					wf_setnull()
					RETURN 1
				END IF
			end if	
		end if
		/* �ܰ� ��� */
		sqlca.fun_erp100000016(gs_sabu, stoday, scvcod, sitnbr, '.', scurr, sgubun, dItemPrice, dDcRate)
		
		/* ������2�ڸ� */
		dItemPrice = Truncate(dItemPrice , 5) 
	
//		If sgubun = '2' Then //��ȭ�ΰ�� ��ȭ�ܰ��� ȯ��(����ȯ��)
//		   dItemPrice = sqlca.erp000000090_1(stoym, sitnbr, scurr, dItemPrice, sgubun)		
//			dItemPrice = Truncate(dItemPrice , 5)
//		End If	 
		this.SetItem(lrow, "curr", scurr)             //��ȭ����
		this.SetItem(lrow, "sales_price", dItemPrice) //�ܰ�
		RETURN ireturn
END Choose


end event

event dw_insert::itemerror;return 1
end event

event dw_insert::rbuttondown;call super::rbuttondown;String sCol_Name, stoday, scvcod, sitnbr, scurr, sgubun, stoym
Double dItemPrice, dDcRate
Long   lrow

sCol_Name = GetColumnName()
lrow = GetRow()

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)


/* �������� */
select to_char(sysdate,'yyyymmdd')
  into :stoday  
  from dual;
 
stoym    = left(stoday,6)
scvcod	= this.getitemstring(lrow, 'cvcod')
scurr 	= this.getitemstring(lrow, 'curr')

/* ����(�ܰ������� ���) */
If scurr = 'WON' Then
	sgubun = '1'   //��ȭ
Else
	sgubun = '2'   //��ȭ
End If	

Choose Case sCol_Name
	// ǰ���ڵ� ����Ʈ�� Right ����Ŭ���� Popup ȭ��
	Case "itnbr"
   	Open(w_itemas_popup)
	   IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
      SetItem(lrow,"itnbr",gs_code)
		SetItem(lrow,"itdsc",gs_codename)
		SetItem(lrow,"ispec",gs_gubun)
		
		wf_check_itnbr(lrow, gs_code) 
		/* �ܰ� ��� */
      sqlca.fun_erp100000016(gs_sabu, stoday, scvcod, gs_code, '.', scurr, sgubun, dItemPrice, dDcRate)
	 
	   /* ������2�ڸ� */
	   dItemPrice = Truncate(dItemPrice , 5) 

//  	   If sgubun = '2' Then //��ȭ�ΰ�� ��ȭ�ܰ��� ȯ��(����ȯ��)
//	      dItemPrice = sqlca.erp000000090_1(stoym, gs_code, scurr, dItemPrice, sgubun)		
//		   dItemPrice = Truncate(dItemPrice , 5)
//  	   End If	 
	   this.SetItem(lrow, "curr", scurr)             //��ȭ����
	   this.SetItem(lrow, "sales_price", dItemPrice) //�ܰ�	
	 
		Return 1
	Case "itdsc"
   	gs_codename = GetText()
	
	   open(w_itemas_popup)
   	IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
	   SetItem(lrow,"itnbr",gs_code)
		SetItem(lrow,"itdsc",gs_codename)
		SetItem(lrow,"ispec",gs_gubun)
		
		wf_check_itnbr(lrow, gs_code)
		
		/* �ܰ� ��� */
      sqlca.fun_erp100000016(gs_sabu, stoday, scvcod, gs_code, '.', scurr, sgubun, dItemPrice, dDcRate)
	 
	   /* ������2�ڸ� */
	   dItemPrice = Truncate(dItemPrice , 5) 

//  	   If sgubun = '2' Then //��ȭ�ΰ�� ��ȭ�ܰ��� ȯ��(����ȯ��)
//	      dItemPrice = sqlca.erp000000090_1(stoym, gs_code, scurr, dItemPrice, sgubun)		
//		   dItemPrice = Truncate(dItemPrice , 5)
//  	   End If	 
	   this.SetItem(lrow, "curr", scurr)             //��ȭ����
	   this.SetItem(lrow, "sales_price", dItemPrice) //�ܰ�
		
		Return 1
   Case "ispec"
	   gs_gubun = GetText()
 	
   	open(w_itemas_popup)
	   IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
   	SetItem(lrow,"itnbr",gs_code)
		SetItem(lrow,"itdsc",gs_codename)
		SetItem(lrow,"ispec",gs_gubun)
		wf_check_itnbr(lrow, gs_code)
		
		/* �ܰ� ��� */
      sqlca.fun_erp100000016(gs_sabu, stoday, scvcod, gs_code, '.', scurr, sgubun, dItemPrice, dDcRate)
	 
	   /* ������2�ڸ� */
	   dItemPrice = Truncate(dItemPrice , 5) 

//  	   If sgubun = '2' Then //��ȭ�ΰ�� ��ȭ�ܰ��� ȯ��(����ȯ��)
//	      dItemPrice = sqlca.erp000000090_1(stoym, gs_code, scurr, dItemPrice, sgubun)		
//		   dItemPrice = Truncate(dItemPrice , 5)
//  	   End If	 
	   this.SetItem(lrow, "curr", scurr)             //��ȭ����
	   this.SetItem(lrow, "sales_price", dItemPrice) //�ܰ�	
		
		Return 1
End Choose

end event

type p_delrow from w_inherite`p_delrow within w_sal_01051
boolean visible = false
integer x = 384
integer y = 3152
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_sal_01051
boolean visible = false
integer x = 210
integer y = 3152
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_sal_01051
boolean visible = false
integer x = 3401
integer y = 116
string pointer = "C:\erpman\cur\create2.cur"
string picturename = "C:\erpman\image\����_up.gif"
end type

event p_search::clicked;call super::clicked;String sYymm, sCvcod

If dw_jogun.AcceptText() = -1 Then Return

sCvcod = Trim(dw_jogun.GetItemString(1, 'fr_itcls'))
sYYMM  = Trim(dw_jogun.GetItemString(1, 'sym'))
If sYYMM = '' or isNull(sYYMM) then
	f_Message_Chk(35, '[��ȹ���]')
	dw_jogun.SetColumn('sym')
	Return 1
End If

If scvcod = '' or isNull(sCvcod) then
	f_Message_Chk(30, '[�ŷ�ó�ڵ�]')
	dw_jogun.SetColumn('fr_itcls')
	Return 1
End If

gs_code = sCvcod	/* �������� */
openwithparm(w_sal_010511, syymm)

/* ��ȸ */
If gs_code <> '0' Then	p_inq.TriggerEvent(Clicked!)

SetNull(Gs_Code)
end event

event p_search::ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\����_dn.gif"
end event

event p_search::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\����_up.gif"
end event

type p_ins from w_inherite`p_ins within w_sal_01051
integer x = 3749
end type

event p_ins::clicked;call super::clicked;String ssabu, syymm, sispec, sitdsc, sitnbr, scvcod, splym, snull, scurr, stoym, stoday, sgubun, sconfirm,syy,smm
Long   lrow, lrowcnt
Int    iplym
Double ddanga, dItemPrice, dDcRate

setnull(snull)


If dw_jogun.AcceptText() <> 1 Then Return

ssabu   = gs_sabu
splym   = trim(dw_jogun.GetItemString(1,'sdate'))

/* �������� */
select to_char(sysdate,'yyyymmdd')
  into :stoday  
  from dual;
 
 stoym = left(stoday,6)
 
/* ���س�� */
if isnull(splym) or splym = "" then
	f_message_chk(30,'[���س��]')
	dw_jogun.Setcolumn('sdate')
	dw_jogun.SetFocus()
	return
end if	

iplym	  = Integer(dw_jogun.Object.sym[1])
/* �ǰ�ȹ��� ��� */
If isNull(iplym) then
	f_message_chk(35,'[��ȹ���]')
	dw_jogun.Setcolumn('sym')
	dw_jogun.SetFocus()
	return 1
else
	syymm = f_aftermonth(splym, iplym)   
end if	

/* �ŷ�ó */
sCvcod = Trim(dw_jogun.GetItemString(1, 'fr_itcls'))
If scvcod = '' or isNull(scvcod) then
	f_Message_Chk(30, '[�ŷ�ó]')
	dw_jogun.SetColumn('fr_itcls')
	dw_jogun.setfocus()
	Return 1
End If

/* ��ȭ���� */
scurr = Trim(dw_jogun.GetItemString(1, 'curr'))
If scurr = '' or isNull(scurr) then
	f_Message_Chk(30, '[��ȭ����]')
	dw_jogun.SetColumn('curr')
	dw_jogun.setfocus()
	Return 1
Else
	If scurr = 'WON' Then
		sgubun = '1'   //��ȭ
   Else
		sgubun = '2'   //��ȭ
	End If	
End If

syy = left(splym,4)
smm = mid(splym,5,2)

/* �������� Ȯ��*/
select DISTINCT NVL(MAFLAG,'N')
  into :sconfirm
  from SHORTSAPLAN_CONFIRM
 where Sabu         = :gs_sabu
   And Plan_yymm    = :splym;

If sconfirm = 'Y' then
	MessageBox('�˸�', syy + '��' + smm + '��'+ '  �� �ǸŰ�ȹ�� �̹� Ȯ�� ó���Ǿ����ϴ�')
	return
End IF	

If dw_update.AcceptText() <> 1 Then Return
lrow = dw_update.GetRow()
If lrow > 0 Then
	sitnbr   = dw_update.GetItemString(lrow, "itnbr")	
	sitdsc   = dw_update.GetItemString(lrow, "itemas_itdsc")
	sispec   = dw_update.GetItemString(lrow, "itemas_ispec")
Else
  lrow = 0
End If

lrowcnt = dw_insert.GetRow()
dw_insert.InsertRow(lrowcnt+1)

If lrowcnt <= 0 then	

	/* �ܰ� ��� */
   sqlca.fun_erp100000016(gs_sabu, stoday, scvcod, sitnbr, '.', scurr, sgubun, dItemPrice, dDcRate)
	
	/* ������2�ڸ� */
	dItemPrice = Truncate(dItemPrice , 5) 

//	If sgubun = '2' Then //��ȭ�ΰ�� ��ȭ�ܰ��� ȯ��(����ȯ��)
//	   dItemPrice = sqlca.erp000000090_1(stoym, sitnbr, scurr, dItemPrice, sgubun)		
//		dItemPrice = Truncate(dItemPrice , 5)
//   End If

	//�����ڷᰡ �������� ������� �ʱ� ǰ������ ����
	dw_insert.SetItem(lrowcnt+1, "yymm", splym)             //���س��(������)
	dw_insert.SetItem(lrowcnt+1, "plnyymm", syymm)          //��ȹ���
	dw_insert.SetItem(lrowcnt+1, "cvcod", scvcod)           //�ŷ�ó
	dw_insert.SetItem(lrowcnt+1, "sabu", ssabu)             //�����
	dw_insert.SetItem(lrowcnt+1, "curr", scurr)             //��ȭ����
	dw_insert.SetItem(lrowcnt+1, "sales_price", dItemPrice) //�ܰ�
	dw_insert.SetItem(lrowcnt+1, "itnbr", sitnbr)           //ǰ��
	dw_insert.SetItem(lrowcnt+1, "itdsc", sitdsc)           //ǰ��
	dw_insert.SetItem(lrowcnt+1, "ispec", sispec)           //�԰�
	
	dw_insert.scrolltorow(lrowcnt+1)
	dw_insert.SetItem(lrowcnt+1, "monqty01", 0)
	dw_insert.setitem(lrowcnt+1, "monqty01", 0)
	dw_insert.setitem(lrowcnt+1, "monqty02", 0)
	dw_insert.setitem(lrowcnt+1, "monqty03", 0)
	dw_insert.setitem(lrowcnt+1, "monqty04", 0)
	dw_insert.setitem(lrowcnt+1, "monqty05", 0)
	dw_insert.setitem(lrowcnt+1, "monqty06", 0)
	dw_insert.setitem(lrowcnt+1, "monqty07", 0)
	dw_insert.setitem(lrowcnt+1, "monqty08", 0)
	dw_insert.setitem(lrowcnt+1, "monqty09", 0)
	dw_insert.setitem(lrowcnt+1, "monqty10", 0)
	dw_insert.setitem(lrowcnt+1, "monqty11", 0)
	dw_insert.setitem(lrowcnt+1, "monqty12", 0)
	dw_insert.setitem(lrowcnt+1, "monqty13", 0)
	dw_insert.setitem(lrowcnt+1, "monqty14", 0)
	dw_insert.setitem(lrowcnt+1, "monqty15", 0)
	dw_insert.setitem(lrowcnt+1, "monqty16", 0)
	dw_insert.setitem(lrowcnt+1, "monqty17", 0)
	dw_insert.setitem(lrowcnt+1, "monqty18", 0)
	dw_insert.setitem(lrowcnt+1, "monqty19", 0)
	dw_insert.setitem(lrowcnt+1, "monqty20", 0)
	dw_insert.setitem(lrowcnt+1, "monqty21", 0)
	dw_insert.setitem(lrowcnt+1, "monqty22", 0)
	dw_insert.setitem(lrowcnt+1, "monqty23", 0)
	dw_insert.setitem(lrowcnt+1, "monqty24", 0)
	dw_insert.setitem(lrowcnt+1, "monqty25", 0)
	dw_insert.setitem(lrowcnt+1, "monqty26", 0)
	dw_insert.setitem(lrowcnt+1, "monqty27", 0)
	dw_insert.setitem(lrowcnt+1, "monqty28", 0)
	dw_insert.setitem(lrowcnt+1, "monqty29", 0)
	dw_insert.setitem(lrowcnt+1, "monqty30", 0)
	dw_insert.setitem(lrowcnt+1, "monqty31", 0)
	
	dw_insert.setcolumn('itnbr')
else	
		
	//�����ڷᰡ �����Ұ�� ǰ�� ������
	dw_insert.SetItem(lrowcnt+1, "yymm", splym)         //���س��(������)
	dw_insert.SetItem(lrowcnt+1, "plnyymm", syymm)      //��ȹ���
	dw_insert.SetItem(lrowcnt+1, "cvcod", scvcod)       //�ŷ�ó
	dw_insert.SetItem(lrowcnt+1, "sabu" , ssabu)        //�����
	dw_insert.SetItem(lrowcnt+1, "curr", scurr)         //��ȭ����
	dw_insert.setitem(lrowcnt+1, "itnbr", snull)	
   dw_insert.setitem(lrowcnt+1, "itdsc", snull)	
   dw_insert.setitem(lrowcnt+1, "ispec", snull)
	
	dw_insert.scrolltorow(lrowcnt+1)
	dw_insert.SetItem(lrowcnt+1, "monqty01", 0)
	dw_insert.setitem(lrowcnt+1, "monqty01", 0)
	dw_insert.setitem(lrowcnt+1, "monqty02", 0)
	dw_insert.setitem(lrowcnt+1, "monqty03", 0)
	dw_insert.setitem(lrowcnt+1, "monqty04", 0)
	dw_insert.setitem(lrowcnt+1, "monqty05", 0)
	dw_insert.setitem(lrowcnt+1, "monqty06", 0)
	dw_insert.setitem(lrowcnt+1, "monqty07", 0)
	dw_insert.setitem(lrowcnt+1, "monqty08", 0)
	dw_insert.setitem(lrowcnt+1, "monqty09", 0)
	dw_insert.setitem(lrowcnt+1, "monqty10", 0)
	dw_insert.setitem(lrowcnt+1, "monqty11", 0)
	dw_insert.setitem(lrowcnt+1, "monqty12", 0)
	dw_insert.setitem(lrowcnt+1, "monqty13", 0)
	dw_insert.setitem(lrowcnt+1, "monqty14", 0)
	dw_insert.setitem(lrowcnt+1, "monqty15", 0)
	dw_insert.setitem(lrowcnt+1, "monqty16", 0)
	dw_insert.setitem(lrowcnt+1, "monqty17", 0)
	dw_insert.setitem(lrowcnt+1, "monqty18", 0)
	dw_insert.setitem(lrowcnt+1, "monqty19", 0)
	dw_insert.setitem(lrowcnt+1, "monqty20", 0)
	dw_insert.setitem(lrowcnt+1, "monqty21", 0)
	dw_insert.setitem(lrowcnt+1, "monqty22", 0)
	dw_insert.setitem(lrowcnt+1, "monqty23", 0)
	dw_insert.setitem(lrowcnt+1, "monqty24", 0)
	dw_insert.setitem(lrowcnt+1, "monqty25", 0)
	dw_insert.setitem(lrowcnt+1, "monqty26", 0)
	dw_insert.setitem(lrowcnt+1, "monqty27", 0)
	dw_insert.setitem(lrowcnt+1, "monqty28", 0)
	dw_insert.setitem(lrowcnt+1, "monqty29", 0)
	dw_insert.setitem(lrowcnt+1, "monqty30", 0)
	dw_insert.setitem(lrowcnt+1, "monqty31", 0)
	
	dw_insert.setcolumn('itnbr')
end if
dw_insert.setfocus()

w_mdi_frame.sle_msg.Text = '���ں� �Ǹ� ��ȹ ����۾� �Դϴ�.'

ib_any_typing = False

end event

type p_exit from w_inherite`p_exit within w_sal_01051
end type

type p_can from w_inherite`p_can within w_sal_01051
end type

event p_can::clicked;call super::clicked;dw_Update.Reset()
dw_Insert.Reset()
dw_Jogun.Reset()

dw_Jogun.InsertRow(0)

ib_any_typing = False
w_mdi_frame.sle_msg.Text = '�� �ǸŰ�ȹ�� ���� �� ������ ��ȹ����� �Է��ϼ���'

/* ��� */
dw_update.Modify("DataWindow.Header.Height=80")	
dw_update.Modify("DataWindow.Detail.Height=72")

/* Protect */
dw_jogun.Modify("sdate.protect = 0")
dw_jogun.Modify("curr.protect = 0")
dw_jogun.Modify("fr_itcls.protect = 0")

/* background */
dw_jogun.Object.sdate.background.color    = rgb(255,255,255) 
dw_jogun.Object.curr.background.color     = rgb(255,255,255) 
dw_jogun.Object.fr_itcls.background.color = rgb(255,255,255)  

dw_Jogun.SetFocus()
dw_Jogun.SetColumn("sdate")
end event

type p_print from w_inherite`p_print within w_sal_01051
boolean visible = false
integer x = 594
integer y = 3164
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_sal_01051
integer x = 3575
end type

event p_inq::clicked;call super::clicked;String  sNull, syymm, ssym, seym, sjsym, sjeym, scvcod, splym, sym, scurr
Int	  cnt, iplym

SetNull(sNull)
//��ȸDataWindow �ʱ�
dw_update.reset()
dw_insert.reset()

If dw_jogun.AcceptText() = -1 Then Return

splym = trim(dw_jogun.GetItemString(1,'sdate'))

/* ���س�� */
if isnull(splym) or splym = "" then
	f_message_chk(30,'[���س��]')
	dw_jogun.Setcolumn('sdate')
	dw_jogun.SetFocus()
	return
end if	
  
/* �ǰ�ȹ��� ��� */
iplym	  = Integer(dw_jogun.Object.sym[1])
If isNull(iplym) then
	f_message_chk(35,'[��ȹ���]')
	dw_jogun.Setcolumn('sym')
	dw_jogun.SetFocus()
	return 1
else
	syymm = f_aftermonth(splym, iplym)   
end if	

/* �ŷ�ó */
sCvcod = Trim(dw_jogun.GetItemString(1, 'fr_itcls'))
If scvcod = '' or isNull(scvcod) then
	f_Message_Chk(30, '[�ŷ�ó]')
	dw_jogun.SetColumn('fr_itcls')
	Return 1
End If

/* ��ȭ���� */
scurr = Trim(dw_jogun.GetItemString(1, 'curr'))
If scurr = '' or isNull(scurr) then
	f_Message_Chk(30, '[��ȭ����]')
	dw_jogun.SetColumn('curr')
	dw_jogun.setfocus()
	Return 1
End If

/* �Ⱓ �˻� */
select to_char(add_months(to_date(:syymm,'yyyymm'),-3),'yyyymm') ,
		 to_char(add_months(to_date(:syymm,'yyyymm'),-1),'yyyymm') ,
		 to_char(add_months(to_date(:syymm,'yyyymm'),-15),'yyyymm') ,
		 to_char(add_months(to_date(:syymm,'yyyymm'),-13),'yyyymm') 
  into :ssym, :seym,:sjsym, :sjeym from dual;

/* ��ȸ */
If dw_Update.Retrieve(gs_sabu, splym, ssym, seym, sjsym, sjeym, scvcod, gs_saupj) > 0 Then
	sle_msg.Text = '��ȸ �Ϸ�.  �����۾��� �ϼ���.'
Else
	MessageBox('Ȯ ��', '��ȹ����� ���ǸŰ�ȹ�� �������� �ʽ��ϴ�.' + '~r~r' + &
							  '�ű� �Է��ϼ���')
	sle_msg.Text = 'Ȯ ��.  ��ȸ ���� ����.'						  
	Return
End If

/* ��� */
dw_update.Modify("DataWindow.Header.Height=80")	
dw_update.Modify("DataWindow.Detail.Height=72")

/* Protect */
dw_jogun.Modify("sdate.protect = 1")
dw_jogun.Modify("curr.protect = 1")
dw_jogun.Modify("fr_itcls.protect = 1")

/* background */
dw_jogun.Object.sdate.background.color    = rgb(192,192,192) 
dw_jogun.Object.curr.background.color     = rgb(192,192,192) 
dw_jogun.Object.fr_itcls.background.color = rgb(192,192,192) 

dw_Update.SetFocus() 

Return
end event

type p_del from w_inherite`p_del within w_sal_01051
end type

event p_del::clicked;call super::clicked;String ssabu, syymm, splnyymm, sitnbr, scvcod, sitdsc, sconfirm, splym, syy, smm
Long   lrow

If dw_insert.AcceptText() <> 1 Then Return
If dw_jogun.AcceptText() <> 1 Then Return

lrow = dw_insert.GetRow()
If lrow <= 0 Then Return

splym = trim(dw_jogun.GetItemString(1,'sdate'))
syy   = left(splym,4)
smm   = mid(splym,5,2)

/* �������� Ȯ��*/
select DISTINCT NVL(MAFLAG,'N')
  into :sconfirm
  from SHORTSAPLAN_CONFIRM
 where Sabu         = :gs_sabu
   And Plan_yymm    = :splym;

If sconfirm = 'Y' then
	MessageBox('�˸�', syy + '��' + smm + '��'+ '  �� �ǸŰ�ȹ�� �̹� Ȯ�� ó���Ǿ����ϴ�')
	return
End IF	

ssabu    = dw_insert.GetItemString(lrow, 'sabu')
syymm    = dw_insert.GetItemString(lrow, 'yymm')
splnyymm = dw_insert.GetItemString(lrow, 'plnyymm')
sitnbr   = dw_insert.GetItemString(lrow, 'itnbr')
scvcod   = dw_insert.GetItemString(lrow, 'cvcod')
sitdsc   = dw_insert.GetItemString(lrow, 'itdsc')

Beep (1)
if MessageBox("���� Ȯ��", sitdsc + "�� �����Ͻðڽ��ϱ�? ",question!,yesno!, 2) = 2 THEN Return
dw_insert.DeleteRow(lrow)

// �����ǸŰ�ȹ �ش��ȹ����� ǰ�� ����Ÿ ����
Delete From shortsaplan_dtl
Where sabu    = :ssabu
  And yymm    = :syymm
  And cvcod   = :scvcod 
  And plnyymm = :splnyymm
  And itnbr   = :sitnbr;

If SQLCA.SqlCode < 0 then
   f_Message_Chk(31, '[����Ȯ��]')
	Rollback;
	Return
Else
   Commit;
End If

ib_any_typing = False
dw_insert.reset()

return
end event

type p_mod from w_inherite`p_mod within w_sal_01051
end type

event p_mod::clicked;call super::clicked;String sitnbr, sconfirm, splym, syy, smm
Long   lrow, l_cnt
Int    i

If dw_insert.AcceptText() <> 1 Then Return
If dw_jogun.AcceptText() <> 1 Then Return

splym   = trim(dw_jogun.GetItemString(1,'sdate'))

lrow = dw_insert.GetRow()
If lrow <= 0 Then Return

syy = left(splym,4)
smm = mid(splym,5,2)

/* �������� Ȯ��*/
select DISTINCT NVL(MAFLAG,'N')
  into :sconfirm
  from SHORTSAPLAN_CONFIRM
 where Sabu         = :gs_sabu
   And Plan_yymm    = :splym;

If sconfirm = 'Y' then
	MessageBox('�˸�', syy + '��' + smm + '��'+ '  �� �ǸŰ�ȹ�� �̹� Ȯ�� ó���Ǿ����ϴ�')
	return
End IF	

w_mdi_frame.sle_msg.Text = '����Ÿ�� �����մϴ�. ��� ��ٷ� �ּ���!!!'
SetPointer(HourGlass!)	

//ǰ���� ������� �ش� ROW ������ ����
FOR i = 1 TO dw_insert.rowcount()
    sitnbr = dw_insert.Object.itnbr[i]	 
	 IF sitnbr = '' OR isnull(sitnbr) THEN		 
		 dw_Insert.Deleterow(i)
	 END	IF
NEXT	

/* Ȯ�� �ڷ�(SHORTSAPLAN_CONFIRM ���̺�) Insert & Update */
select count(*)
  into :l_cnt
  from SHORTSAPLAN_CONFIRM
 where Sabu       = :gs_sabu
   and Plan_yymm  = :splym;
	
If l_cnt = 0 Then
	Insert Into SHORTSAPLAN_CONFIRM
	       ( Sabu, Plan_yymm, Maflag)
	   Values
		    ( :gs_sabu, :splym, 'N');
End If	

If dw_insert.rowcount() > 0 Then
	If dw_insert.Update() <> 1 Then
		RollBack;
		f_message_chk(32,'')
		SetPointer(Arrow!)
		ib_any_typing = False
		return
	Else
		Commit;
		MessageBox('Ȯ ��','�� �Ǹ� ��ȹ ���� �Ϸ�!!')
		p_inq.TriggerEvent(Clicked!)
		SetPointer(Arrow!)
		ib_any_typing = False
		return
	End If	
Else
	RollBack;
	MessageBox('Ȯ ��','������ �ڷᰡ �����ϴ�')
	ib_any_typing = False
	return
End If	
	

end event

type cb_exit from w_inherite`cb_exit within w_sal_01051
integer x = 3182
integer y = 3352
integer taborder = 140
end type

type cb_mod from w_inherite`cb_mod within w_sal_01051
integer x = 2459
integer y = 3352
integer taborder = 80
end type

type cb_ins from w_inherite`cb_ins within w_sal_01051
integer x = 1102
integer y = 3352
integer taborder = 70
string text = "����(&I)"
end type

type cb_del from w_inherite`cb_del within w_sal_01051
integer x = 741
integer y = 3352
integer taborder = 90
string text = "����(&E)"
end type

type cb_inq from w_inherite`cb_inq within w_sal_01051
integer x = 18
integer y = 3352
integer taborder = 100
end type

type cb_print from w_inherite`cb_print within w_sal_01051
integer x = 1527
integer y = 3156
integer taborder = 110
end type

type st_1 from w_inherite`st_1 within w_sal_01051
end type

type cb_can from w_inherite`cb_can within w_sal_01051
integer x = 2825
integer y = 3352
integer taborder = 120
end type

type cb_search from w_inherite`cb_search within w_sal_01051
integer x = 1957
integer y = 3152
integer taborder = 130
end type







type gb_button1 from w_inherite`gb_button1 within w_sal_01051
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_01051
end type

type rr_2 from roundrectangle within w_sal_01051
integer linethickness = 1
long fillcolor = 33027312
integer x = 50
integer y = 512
integer width = 3365
integer height = 256
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_sal_01051
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 292
integer width = 4599
integer height = 2044
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_jogun from datawindow within w_sal_01051
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 32
integer y = 56
integer width = 3314
integer height = 188
integer taborder = 60
boolean bringtotop = true
string dataobject = "d_sal_01051"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_key;if key = keyf1! then
	triggerevent(rbuttondown!)
End if
end event

event itemchanged;String  sNull, sdata, sname, sname1, splym, syymm, scvcod, scurr
Long    nRow, ireturn
Integer is_plym

nRow = GetRow()
If nRow <= 0 Then Return

SetNull(sNull)

Choose Case GetColumnName()
	/* ��ȹ�⵵ */
   Case 'sdate'
		splym = gettext()
		
		scvcod  = trim(GetItemString(1,'fr_itcls'))
		is_plym = Integer(GetItemString(1,'sym'))
  	   syymm   = f_aftermonth(splym, is_plym)
		  
		//������ �ڷᰡ �����Ұ�� ��ȭ���� ����
		select distinct curr
		  into :scurr
		  from shortsaplan_dtl
		 where sabu    = :gs_sabu
         and yymm    = :splym
			and plnyymm = :syymm
			and cvcod   = :scvcod;
			
		If scurr = '' or isnull(scurr) then
			Modify("curr.protect = 0")
			This.Object.curr.background.color = rgb(255,255,255) 
		else	
		   setitem(1, "curr", scurr)
		   Modify("curr.protect = 1")
			This.Object.curr.background.color = rgb(192,192,192) 
		end if	  
		  
	Case 'sym'
		is_yymm = gettext()
		is_plym = integer(gettext())
		dw_insert.reset()
     
	   
	   splym   = trim(GetItemString(1,'sdate'))
		scvcod  = trim(GetItemString(1,'fr_itcls'))
  	   syymm   = f_aftermonth(splym, is_plym)   
      
		//������ �ڷᰡ �����Ұ�� ��ȭ���� ����
		select distinct curr
		  into :scurr
		  from shortsaplan_dtl
		 where sabu    = :gs_sabu
         and yymm    = :splym
//			and plnyymm = :syymm
			and cvcod   = :scvcod;
			
		If scurr = '' or isnull(scurr) then
			Modify("curr.protect = 0")
			This.Object.curr.background.color = rgb(255,255,255) 
		else	
		   setitem(1, "curr", scurr)
		   Modify("curr.protect = 1")
			This.Object.curr.background.color = rgb(192,192,192) 
		end if	
		
	/* �ŷ�ó */
	Case "fr_itcls"
		sData = gettext()
		ireturn = f_get_name2("V1", 'Y', sdata, sname, sname1)
		if ireturn = 0 then
			setitem(1, "fr_itclsnm", sName)
			
			splym   = trim(GetItemString(1,'sdate'))
		   is_plym = Integer(GetItemString(1,'sym'))
  	      syymm   = f_aftermonth(splym, is_plym)   
      
			//������ �ڷᰡ �����Ұ�� ��ȭ���� ����
			select distinct curr
			  into :scurr
			  from shortsaplan_dtl
			 where sabu    = :gs_sabu
				and yymm    = :splym
				and plnyymm = :syymm
				and cvcod   = :sData;
         

			If scurr = '' or isnull(scurr) then
			   Modify("curr.protect = 0")
				This.Object.curr.background.color = rgb(255,255,255) 
		   else	
		      setitem(1, "curr", scurr)
		      Modify("curr.protect = 1")
				This.Object.curr.background.color = rgb(192,192,192) 
		   end if	
		Else
			setitem(1, "fr_itcls",   sNull)
			setitem(1, "fr_itclsnm", sNull)
			return 1
		End if
		
	/* ���/�󼼱��� */
	Case "to_itcls"
		sData = gettext()
		If Sdata = '1' then
			dw_update.Modify("DataWindow.Header.Height=80")	
			dw_update.Modify("DataWindow.Detail.Height=72")
		Else
			dw_update.Modify("DataWindow.Header.Height=156")	
			dw_update.Modify("DataWindow.Detail.Height=150")
		End if
End Choose
end event

event itemerror;return 1
end event

event rbuttondown;String sEmpId, sSaupj

SetNull(Gs_Code)
SetNull(Gs_gubun)
SetNull(Gs_CodeName)

Choose Case GetColumnName()
	/* �ŷ�ó */
	Case "fr_itcls"
		Open(w_vndmst_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN 2
		
		SetItem(1, 'fr_itcls', gs_code)
		TriggerEvent(ItemChanged!)
END Choose

end event

type cb_add from commandbutton within w_sal_01051
integer x = 379
integer y = 3352
integer width = 334
integer height = 108
integer taborder = 150
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "�߰�(&A)"
end type

type dw_update from u_key_enter within w_sal_01051
event ue_key pbm_dwnkey
integer x = 23
integer y = 312
integer width = 4571
integer height = 1224
integer taborder = 40
string dataobject = "d_sal_01051_03"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event ue_key;//if key = keyf1! then
//	triggerevent(rbuttondown!)
//end if
end event

event clicked;call super::clicked;String  ssabu, syymm, scvcod, splanyymm, sitnbr, stoday, stoym, scurr, sgubun
Double  dItemPrice, dDcRate
Integer iplym


if this.accepttext() = -1 then return 
if dw_jogun.accepttext() = -1 then return 

/* �������� */
select to_char(sysdate,'yyyymmdd')
  into :stoday  
  from dual;
 
 stoym = left(stoday,6)


/* ��ȭ���� */
scurr = Trim(dw_jogun.GetItemString(1, 'curr'))
If scurr = 'WON' Then
	sgubun = '1'   //��ȭ
Else
	sgubun = '2'   //��ȭ
End If

If row <= 0 Then 
	SelectRow(0,false)
	sItnbr = ''
Else
	SelectRow(0,false)
	SelectRow(row,true)
	scvcod    = GetItemString(row, 'cvcod')
	syymm     = GetItemString(row, 'plan_yymm')
	sItnbr    = GetItemString(row, 'itnbr')	
End If

/* �ǰ�ȹ��� ��� */
iplym	  = Integer(dw_jogun.Object.sym[1])
If isNull(iplym) then
	f_message_chk(35,'[��ȹ���]')
	dw_jogun.Setcolumn('sym')
	dw_jogun.SetFocus()
	return 1
else
	splanyymm = f_aftermonth(syymm, iplym)   
end if	

dw_insert.SetFilter("itnbr = '" + sItnbr + "'")
dw_insert.Filter()

dw_insert.Retrieve(gs_sabu, syymm, scvcod, splanyymm, sitnbr)

/* �ܰ� ��� */
sqlca.fun_erp100000016(gs_sabu, stoday, scvcod, sitnbr, '.', scurr, sgubun, dItemPrice, dDcRate)

/* ������2�ڸ� */
dItemPrice = Truncate(dItemPrice , 5) 
//If sgubun = '2' Then //��ȭ�ΰ�� ��ȭ�ܰ��� ȯ��(����ȯ��)
//	dItemPrice = sqlca.erp000000090_1(stoym, sitnbr, scurr, dItemPrice, sgubun)		
//	dItemPrice = Truncate(dItemPrice , 5)
//End If

dw_insert.SetItem(1, "curr", scurr)             //��ȭ����
dw_insert.SetItem(1, "sales_price", dItemPrice) //�ܰ�


end event

event rowfocuschanged;call super::rowfocuschanged;String ssabu, syymm, scvcod, splanyymm, sitnbr, stoday, stoym, scurr, sgubun
Double dItemPrice, dDcRate
Integer iplym

if this.accepttext() = -1 then return 
if dw_jogun.accepttext() = -1 then return 

syymm = trim(dw_jogun.GetItemString(1,'sdate'))

/* �������� */
select to_char(sysdate,'yyyymmdd')
  into :stoday  
  from dual;
 
 stoym = left(stoday,6)
 
 
/* ��ȭ���� */
scurr = Trim(dw_jogun.GetItemString(1, 'curr'))
If scurr = 'WON' Then
	sgubun = '1'   //��ȭ
Else
	sgubun = '2'   //��ȭ
End If

If currentrow <= 0 Then 
	SelectRow(0,false)
	sItnbr = ''
Else
	SelectRow(0,false)
	SelectRow(currentrow,true)
	scvcod    = GetItemString(currentrow, 'cvcod')
	syymm     = GetItemString(currentrow, 'plan_yymm')
	sItnbr    = GetItemString(currentrow, 'itnbr')	
End If

/* �ǰ�ȹ��� ��� */
iplym	  = Integer(dw_jogun.Object.sym[1])
If isNull(iplym) then
	f_message_chk(35,'[��ȹ���]')
	dw_jogun.Setcolumn('sym')
	dw_jogun.SetFocus()
	return 1
else
	splanyymm = f_aftermonth(syymm, iplym)   
end if	

dw_insert.SetFilter("itnbr = '" + sItnbr + "'")
dw_insert.Filter()

dw_insert.Retrieve(gs_sabu, syymm, scvcod, splanyymm, sitnbr)

/* �ܰ� ��� */
sqlca.fun_erp100000016(gs_sabu, stoday, scvcod, sitnbr, '.', scurr, sgubun, dItemPrice, dDcRate)

/* ������2�ڸ� */
dItemPrice = Truncate(dItemPrice , 5) 
//If sgubun = '2' Then //��ȭ�ΰ�� ��ȭ�ܰ��� ȯ��(����ȯ��)
//	dItemPrice = sqlca.erp000000090_1(stoym, sitnbr, scurr, dItemPrice, sgubun)		
//	dItemPrice = Truncate(dItemPrice , 5)
//End If

dw_insert.SetItem(1, "curr", scurr)             //��ȭ����
dw_insert.SetItem(1, "sales_price", dItemPrice) //�ܰ�





end event

type rr_1 from roundrectangle within w_sal_01051
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 14
integer y = 40
integer width = 3365
integer height = 232
integer cornerheight = 40
integer cornerwidth = 55
end type

