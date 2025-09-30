$PBExportHeader$w_pdm_01577.srw
$PBExportComments$생산bom(기술->생산)
forward
global type w_pdm_01577 from window
end type
type p_mod from uo_picture within w_pdm_01577
end type
type p_inq from uo_picture within w_pdm_01577
end type
type p_can from uo_picture within w_pdm_01577
end type
type p_exit from uo_picture within w_pdm_01577
end type
type dw_2 from datawindow within w_pdm_01577
end type
type dw_1 from uo_multi_select within w_pdm_01577
end type
type rr_1 from roundrectangle within w_pdm_01577
end type
end forward

global type w_pdm_01577 from window
integer width = 3698
integer height = 2240
boolean titlebar = true
string title = "기술BOM을 생산BOM으로 복사"
boolean controlmenu = true
boolean minbox = true
windowtype windowtype = popup!
long backcolor = 32106727
p_mod p_mod
p_inq p_inq
p_can p_can
p_exit p_exit
dw_2 dw_2
dw_1 dw_1
rr_1 rr_1
end type
global w_pdm_01577 w_pdm_01577

type variables
string  is_gubun
long   d1_currentRow, d2_currentRow
end variables

forward prototypes
public subroutine wf_server_copy ()
public subroutine wf_save ()
end prototypes

public subroutine wf_server_copy ();//Create or replace Function Eng_bom_copy
//(Arg_itnbr In Varchar2)
//	return Number
//As
//
//Cal_pinbr	Varchar2(15);
//Cal_cinbr	Varchar2(15);
//Cal_usseq	Varchar2(03);
//Cal_qtypr   Number(15,4);
//Cal_adtin   Number(5,0);
//Cal_opsno   Varchar2(4);
//Cal_efrdt   Varchar2(8);
//Cal_eftdt   Varchar2(8);
//Cal_gubun   Varchar2(1);
//Cal_dcinbr  Varchar2(15);
//Cal_pcbloc  Varchar2(50);
//
//Cursor Bom_copy Is
//	Select pinbr, cinbr, usseq, qtypr, adtin, opsno, efrdt, eftdt, gubun, dcinbr, pcbloc
//	  From
//		(select lvlno, pinbr, usseq, cinbr, qtypr, adtin, opsno, 
//					 efrdt, eftdt, gubun, dcinbr, pcbloc
//			from
//				(select level as lvlno, pinbr, usseq, cinbr, qtypr, adtin, opsno, 
//						  efrdt, eftdt, gubun, dcinbr, pcbloc, rownum as row_no /*+ pstruc_i02 */
//						  from estruc
//						 where pinbr like '%'
//						 connect by prior cinbr = pinbr 
//						 start with pinbr = 'A') a,  
//						itemas b 
//			where a.cinbr = b.itnbr (+))
//	group by pinbr, cinbr, usseq, qtypr, adtin, opsno, efrdt, eftdt, gubun, dcinbr, pcbloc;
//	  
//Begin
//		Open bom_copy;
//
//		Loop
//			Fetch Bom_copy Into cal_pinbr, cal_cinbr, cal_usseq, cal_qtypr, cal_adtin, 
//									  cal_opsno, cal_eftdt, cal_eftdt, cal_gubun, cal_dcinbr, cal_pcbloc;
//			EXIT WHEN Bom_copy%NOTFOUND;
//			
//			  INSERT INTO "PSTRUC"  (pinbr, cinbr, usseq, qtypr, adtin, opsno, efrdt, eftdt,
//			  								 gubun, dcinbr, bomend, pcbloc, rmks)
//					Values(cal_pinbr, cal_cinbr, cal_usseq, cal_qtypr, cal_adtin, cal_opsno,
//							 cal_efrdt, cal_eftdt, cal_gubun, cal_dcinbr, 'N', cal_pcbloc, null);
//
//	   End Loop;
//		Commit;
//		Close Bom_copy;
//Return 1;
//Exception
// When Others Then
// 		Close Bom_copy;
// 	   Return -1;
//End;
///
end subroutine

public subroutine wf_save ();Long 		Lrow, Lcnt = 0
Double   Drtn
String	sItnbr, sgbwan

For Lrow = 1 to dw_1.rowcount()
	
	 IF Not dw_1.IsSelected(Lrow) Then
		 Continue
	 End if
	
	 sItnbr = dw_1.Getitemstring(Lrow, "itemas_itnbr")  
	 
	 sgbwan = 'N'
	 Select gbwan into :sgbwan from itemas where itnbr = :sitnbr;
	 If sgbwan = 'Y' then
	 Else
		 Messagebox("개발품목", "현재개발중인 품목이므로 처리할 수 없읍니다" + '~n' + &
		 							   sItnbr, Question!)
		 Continue
	End if
	 
	 Drtn   = 0
	 Drtn   = sqlca.eng_bom_copy_1(sitnbr);
	 
	 If Drtn = 0 Then
		 Messagebox("Bom Copy", "Server Process를 찾을수 없읍니다", stopsign!)
	 ElseIf Drtn = -1 Then
		 Messagebox("Bom Copy", "기술BOM 복사중 오류 발생", stopsign!)
	ELSEIF DRTN = -2	THEN
		Messagebox("Bom Copy", "INSERT ERROR", stopsign!)
	Else
		 Lcnt++
	 End if
		
Next

If Lcnt > 0 Then
	Messagebox("BOM COPY", "기술BOM 복사 완료", information!)
End if



end subroutine

event open;f_window_center_response(this)

dw_1.settransobject(sqlca)
dw_2.settransobject(sqlca)
dw_2.INSERTROW(0)
dw_2.SetFocus()
end event

on w_pdm_01577.create
this.p_mod=create p_mod
this.p_inq=create p_inq
this.p_can=create p_can
this.p_exit=create p_exit
this.dw_2=create dw_2
this.dw_1=create dw_1
this.rr_1=create rr_1
this.Control[]={this.p_mod,&
this.p_inq,&
this.p_can,&
this.p_exit,&
this.dw_2,&
this.dw_1,&
this.rr_1}
end on

on w_pdm_01577.destroy
destroy(this.p_mod)
destroy(this.p_inq)
destroy(this.p_can)
destroy(this.p_exit)
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.rr_1)
end on

type p_mod from uo_picture within w_pdm_01577
integer x = 3136
integer y = 12
integer width = 178
integer taborder = 30
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\복사_up.gif"
end type

event clicked;call super::clicked;wf_save()
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\복사_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\복사_up.gif"
end event

type p_inq from uo_picture within w_pdm_01577
integer x = 2962
integer y = 12
integer width = 178
integer taborder = 20
boolean bringtotop = true
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;String scode, sname, sspec, sgu, sitcls, sgrp_sql
String sold_sql, swhere_clause, snew_sql

dw_2.AcceptText()
sgu = dw_2.GetItemString(1,'ittyp')
IF IsNull(sgu) THEN sgu = ""

scode  = dw_2.GetItemString(1,'itnbr')
sname  = dw_2.GetItemString(1,'itdsc')
sspec  = dw_2.GetItemString(1,'ispec')
sitcls = dw_2.GetItemString(1,'itcls')

IF IsNull(scode)  THEN scode  = ""
IF IsNull(sname)  THEN sname  = ""
IF IsNull(sspec)  THEN sspec  = ""
IF IsNull(sitcls) THEN sitcls = ""

sold_sql = "SELECT A.ITNBR, A.ITDSC, A.ISPEC, B.TITNM, A.USEYN, FUN_GET_BOMCHK2(A.ITNBR,'2') AS BOMCHK " + &  
           "  FROM ITEMAS A, ITNCT B, ESTRUC D "            + & 
           " WHERE A.ITTYP = B.ITTYP (+) AND A.ITCLS = B.ITCLS (+) AND "  + &
			  "       A.GBWAN = 'Y' AND "    		  + &
			  "		 A.ITNBR = D.PINBR "
swhere_clause = ""
sgrp_sql = " GROUP BY A.ITNBR, A.ITDSC, A.ISPEC, B.TITNM, A.USEYN " 

IF sgu <> ""  THEN 
   swhere_clause = swhere_clause + "AND A.ITTYP ='"+sgu+"'"
END IF
IF scode <> "" THEN
	scode = '%' + scode +'%'
	swhere_clause = swhere_clause + "AND A.ITNBR LIKE '"+scode+"'"
END IF
IF sname <> "" THEN
	sname = '%' + sname +'%'
	swhere_clause = swhere_clause + "AND A.ITDSC LIKE '"+sname+"'"
END IF
IF sspec <> "" THEN
	sspec = '%' + sspec +'%'
	swhere_clause = swhere_clause + "AND A.ISPEC LIKE '"+sspec+"'"
END IF
IF sitcls <> "" THEN
	sitcls = '%' + sitcls +'%'
	swhere_clause = swhere_clause + "AND A.ITCLS LIKE '"+sitcls+"'"
END IF

snew_sql = sold_sql + swhere_clause + sgrp_sql
dw_1.SetSqlSelect(snew_sql)
	
dw_1.Retrieve()
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

type p_can from uo_picture within w_pdm_01577
integer x = 3310
integer y = 12
integer width = 178
integer taborder = 40
boolean bringtotop = true
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;dw_1.setredraw(false)
dw_1.reset()
dw_1.retrieve()
dw_1.setredraw(true)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

type p_exit from uo_picture within w_pdm_01577
integer x = 3483
integer y = 12
integer width = 178
integer taborder = 50
boolean bringtotop = true
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;
close(parent)


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type dw_2 from datawindow within w_pdm_01577
event ue_key pbm_dwnkey
integer x = 18
integer y = 12
integer width = 2638
integer height = 224
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pdm_01577_1"
boolean border = false
boolean livescroll = true
end type

event itemchanged;string snull, s_name

setnull(snull)

IF this.GetColumnName() = 'ittyp' THEN
	s_name = this.gettext()
 
   IF s_name = "" OR IsNull(s_name) THEN 
		RETURN
   END IF
	
	s_name = f_get_reffer('05', s_name)
	if isnull(s_name) or s_name="" then
		f_message_chk(33,'[품목구분]')
		this.SetItem(1,'ittyp', snull)
		return 1
   end if	
END IF
end event

event itemerror;RETURN 1
end event

type dw_1 from uo_multi_select within w_pdm_01577
integer x = 69
integer y = 244
integer width = 3566
integer height = 1848
integer taborder = 0
boolean enabled = true
string dataobject = "d_pdm_01577_2"
boolean border = false
borderstyle borderstyle = stylebox!
end type

type rr_1 from roundrectangle within w_pdm_01577
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 236
integer width = 3598
integer height = 1880
integer cornerheight = 40
integer cornerwidth = 55
end type

