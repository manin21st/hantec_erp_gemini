$PBExportHeader$w_cic00030.srw
$PBExportComments$���������� ���
forward
global type w_cic00030 from w_inherite
end type
type dw_1 from datawindow within w_cic00030
end type
type dw_2 from u_key_enter within w_cic00030
end type
type rr_2 from roundrectangle within w_cic00030
end type
end forward

global type w_cic00030 from w_inherite
string title = "���������� ���"
dw_1 dw_1
dw_2 dw_2
rr_2 rr_2
end type
global w_cic00030 w_cic00030

forward prototypes
public function integer wf_reqchk (integer curr_row)
public function integer wf_warndataloss (string as_titletext)
end prototypes

public function integer wf_reqchk (integer curr_row);String sItnbr,sNo,sOpseq,sRoslt

dw_1.AcceptText()

sItnbr = dw_1.GetItemString(curr_row,"itnbr")  /*ǰ��*/
//sNo    = dw_1.GetItemString(curr_row,"pordno") /*�۾����ù�ȣ*/
//sOpseq = dw_1.GetItemString(curr_row,"opseq") /*��������*/
//sRoslt = dw_1.GetItemString(curr_row,"roslt") /*�����ڵ�*/

IF sItnbr = '' OR ISNULL(sItnbr) THEN
	f_messagechk(1,'[ǰ��]')
	dw_1.SetColumn("itnbr")
	dw_1.SetFocus()
	Return -1
END IF
//IF sNo = '' OR ISNULL(sNo) THEN
//	f_messagechk(1,'[�۾����ù�ȣ]')
//	dw_1.SetColumn("pordno")
//	dw_1.SetFocus()
//	Return -1
//END IF
//IF sOpseq = '' OR ISNULL(sOpseq) THEN
//	f_messagechk(1,'[��������]')
//	dw_1.SetColumn("opseq")
//	dw_1.SetFocus()
//	Return -1
//END IF
//IF sRoslt = '' OR ISNULL(sRoslt) THEN
//	f_messagechk(1,'[�����ڵ�]')
//	dw_1.SetColumn("roslt")
//	dw_1.SetFocus()
//	Return -1
//END IF


Return  1


end function

public function integer wf_warndataloss (string as_titletext);/*=============================================================================================
		 1. window-level user function : ����, ��Ͻ� ȣ���
		    dw_detail �� typing(datawindow) ������� �˻�

		 2. ��������� ��� ��������� ������� ������ ���                                                               

		 3. Argument:  as_titletext (warning messagebox)                                                                          
		    Return values:                                                   
                                                                  
      	*  1 : ��������� �������� �ʰ� ��� ������ ���.
			* -1 : ������ �ߴ��� ���.                      
=============================================================================================*/

IF ib_any_typing = true THEN  				// EditChanged event(dw_detail)�� typing ����Ȯ��

	Beep(1)
	IF MessageBox("Ȯ�� : " + as_titletext , &
		 "�������� ���� ���� �ֽ��ϴ�. ~r��������� �����Ͻðڽ��ϱ�", &
		 question!, yesno!) = 1 THEN

		dw_1.SetFocus()						// yes �� ���: focus 'dw_detail' 
		RETURN -1									

	END IF

END IF
																
RETURN 1												// (dw_detail) �� ��������� ���ų� no�� ���
														// ��������� �������� �ʰ� ������� 


end function

on w_cic00030.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.rr_2
end on

on w_cic00030.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.rr_2)
end on

event open;dw_1.SetTransObject(sqlca)
dw_2.SetTransObject(sqlca)

dw_2.Reset()
dw_2.InsertRow(0)

dw_2.SetItem(1,"io_yymm", Left(F_Today(),6) )
dw_2.SetItem(1,"io_yymmt", Left(F_Today(),6) )

dw_2.SetColumn("io_yymm")
dw_2.SetFocus()
end event

type dw_insert from w_inherite`dw_insert within w_cic00030
boolean visible = false
integer x = 123
integer y = 2652
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_cic00030
integer x = 4046
integer y = 2996
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_cic00030
integer x = 3872
integer y = 2996
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_cic00030
boolean visible = false
integer x = 3003
integer y = 3216
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_cic00030
integer x = 3749
integer y = 0
integer taborder = 40
string pointer = "C:\erpman\cur\new.cur"
end type

event p_ins::clicked;call super::clicked;Long sTotalRow
Long wfReturn

sTotalRow = dw_1.RowCount()
IF sTotalRow = 0 THEN
	sTotalRow = 1
   wfReturn = 1
ELSE
   sTotalRow = sTotalRow + 1 
	wfReturn  = wf_reqchk(dw_1.GetRow())
END IF	

IF wfReturn = -1 THEN
	Return 
END IF

dw_1.InsertRow(sTotalRow)
dw_1.ScrollToRow(sTotalRow)

dw_1.SetItem(sTotalRow,"flag",'1')
dw_1.SetColumn("itnbr")
dw_1.SetFocus()
end event

type p_exit from w_inherite`p_exit within w_cic00030
integer y = 0
end type

type p_can from w_inherite`p_can within w_cic00030
integer y = 0
end type

event p_can::clicked;call super::clicked;
dw_2.SetFocus()

dw_1.Reset()

p_ins.Enabled = True
p_ins.PictureName = "C:\erpman\image\�߰�_up.gif"

p_mod.Enabled = True
p_mod.PictureName = "C:\erpman\image\����_up.gif"

ib_any_typing = False
end event

type p_print from w_inherite`p_print within w_cic00030
boolean visible = false
integer x = 3177
integer y = 3216
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_cic00030
integer x = 3575
integer y = 0
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;String sYm,sIttyp,sPdtgu,sYmt

dw_2.AcceptText()
sYm    = Trim(dw_2.GetItemString(1,"io_yymm"))
sYmt   = Trim(dw_2.GetItemString(1,"io_yymmt"))
sPdtgu = Trim(dw_2.GetItemString(1,"saupgubn"))
sIttyp = dw_2.GetItemString(1,"ittyp") 

dw_1.Reset()
if dw_1.Retrieve(sYm,sYmt,sPdtGu,sIttyp) <= 0  then
	f_messagechk(14,"") 
	Return 
end if

//em_1.Enabled = False
end event

type p_del from w_inherite`p_del within w_cic00030
integer x = 3922
integer y = 0
integer taborder = 50
end type

event p_del::clicked;call super::clicked;
IF F_DbConFirm('����') = 2 THEN RETURN

dw_1.DeleteRow(dw_1.GetRow())

IF dw_1.Update() = 1 THEN
	commit;
	ib_any_typing = False
	w_mdi_frame.sle_msg.text ="�ڷᰡ �����Ǿ����ϴ�.!!!"
	dw_1.SetColumn("itnbr")
   dw_1.SetFocus()
ELSE
	ROLLBACK;
	f_messagechk(12,'')
END IF

end event

type p_mod from w_inherite`p_mod within w_cic00030
integer x = 4096
integer y = 0
integer taborder = 60
end type

event p_mod::clicked;String   sYm,sYmt
Long     ll_Row,K,sZero

IF F_DbConFirm('����') = 2  THEN RETURN

dw_2.AcceptText()
sYm = Trim(dw_2.GetItemString(1,"io_yymm"))
sYmt = Trim(dw_2.GetItemString(1,"io_yymmt"))
IF sYm = '' OR ISNULL(sYm) THEN
	f_messagechk(1,'[�������]')
	dw_2.SetColumn("io_yymm")
	dw_2.SetFocus()
	Return 
END IF	
IF sYmt = '' OR ISNULL(sYmt) THEN
	f_messagechk(1,'[�������]')
	dw_2.SetColumn("io_yymmt")
	dw_2.SetFocus()
	Return 
END IF	
ll_Row = dw_1.RowCount()
IF ll_Row = 0 THEN RETURN

FOR K = 1  TO  ll_Row
	 dw_1.SetITem(K,"cia22t_io_yymm",   sYm) /*��� Setting*/
	 dw_1.SetITem(K,"cia22t_io_yymmt",  sYmt) /*��� Setting*/
	 dw_1.SetItem(k,"cia22t_pdtgu",     dw_2.GetItemString(1,"saupgubn"))

NEXT	

IF wf_reqchk(dw_1.GetRow()) = -1 THEN
	Return 
END IF	

IF dw_1.Update() > 0	THEN
	COMMIT ;															 
ELSE
	ROLLBACK ;
	f_messagechk(13,'')
	Return 
END IF
		
w_mdi_frame.sle_msg.text = '�ڷḦ �����Ͽ����ϴ�!!'
ib_any_typing = False
dw_1.Reset()
dw_1.SelectRow(0,False)


end event

type cb_exit from w_inherite`cb_exit within w_cic00030
integer x = 3237
integer y = 2776
end type

type cb_mod from w_inherite`cb_mod within w_cic00030
integer x = 2542
integer y = 2776
end type

type cb_ins from w_inherite`cb_ins within w_cic00030
integer x = 1774
integer y = 2776
integer width = 370
string text = "���߰�(&A)"
end type

type cb_del from w_inherite`cb_del within w_cic00030
integer x = 2158
integer y = 2776
integer width = 370
string text = "�����(&D)"
end type

type cb_inq from w_inherite`cb_inq within w_cic00030
integer x = 165
integer y = 2776
end type

type cb_print from w_inherite`cb_print within w_cic00030
integer y = 2636
end type

type st_1 from w_inherite`st_1 within w_cic00030
end type

type cb_can from w_inherite`cb_can within w_cic00030
integer x = 2889
integer y = 2776
end type

type cb_search from w_inherite`cb_search within w_cic00030
integer y = 2636
end type

type dw_datetime from w_inherite`dw_datetime within w_cic00030
integer x = 2871
end type

type sle_msg from w_inherite`sle_msg within w_cic00030
integer width = 2487
end type



type gb_button1 from w_inherite`gb_button1 within w_cic00030
integer x = 128
integer y = 2720
integer width = 407
end type

type gb_button2 from w_inherite`gb_button2 within w_cic00030
integer x = 1742
integer y = 2720
integer width = 1865
end type

type dw_1 from datawindow within w_cic00030
event ue_enter pbm_dwnprocessenter
integer x = 64
integer y = 172
integer width = 4521
integer height = 2032
integer taborder = 30
boolean bringtotop = true
string dataobject = "dw_cic00030_2"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_enter;Send(Handle(This),256,9,0)
Return 1
end event

event itemerror;Return 1
end event

event rbuttondown;String l_pordno,sYm

SetNull(gs_code)
SetNull(gs_codename)


if This.GetColumnName() = "itnbr" then //ǰ��
	open(w_itemas_popup)
	
	if gs_code = '' or isnull(gs_code) then return
	
	this.SetITem(Row,"itnbr",gs_code)
	this.SetITem(Row,"itemas_itdsc",gs_codename)
end if

end event

event itemchanged;String sItnbr,sName,snull,sRoslt,sYm
Int sCnt
String sPordno,sOpseq

this.AcceptText()

SetNull(snull)

p_ins.Enabled = True
p_ins.PictureName = "C:\erpman\image\�߰�_up.gif"

p_mod.Enabled = True
p_mod.PictureName = "C:\erpman\image\����_up.gif"


IF THIS.GetColumnName() = "itnbr" THEN
   sItnbr = this.GetItemString(dw_1.GetRow(),"itnbr")
	IF sItnbr = '' OR ISNULL(sItnbr) THEN RETURN
	
	SELECT "ITEMAS"."ITDSC"  		 INTO :sName  
		FROM "ITEMAS"  
		WHERE "ITEMAS"."ITNBR" = :sItnbr   ;
		
	IF SQLCA.SQLCODE = 0 THEN
		this.SetITem(Row,"itemas_itdsc",sName)
	ELSE
		f_messagechk(20,'[ǰ��]')
		this.SetItem(Row,"itnbr",snull)
		this.SetItem(Row,"itemas_itdsc",snull)
		Return 1
	END IF	
END IF	  
	
 
  
  
  
  
end event

event editchanged;ib_any_typing = True
end event

type dw_2 from u_key_enter within w_cic00030
integer x = 55
integer width = 2866
integer height = 156
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_cic00030_1"
boolean border = false
end type

type rr_2 from roundrectangle within w_cic00030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 168
integer width = 4553
integer height = 2064
integer cornerheight = 40
integer cornerwidth = 46
end type

