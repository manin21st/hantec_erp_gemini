$PBExportHeader$w_pdm_01530_ys.srw
$PBExportComments$생산bom등록_양산이관작업
forward
global type w_pdm_01530_ys from window
end type
type p_mod from uo_picture within w_pdm_01530_ys
end type
type p_inq from uo_picture within w_pdm_01530_ys
end type
type p_can from uo_picture within w_pdm_01530_ys
end type
type p_exit from uo_picture within w_pdm_01530_ys
end type
type dw_2 from datawindow within w_pdm_01530_ys
end type
type dw_1 from uo_multi_select within w_pdm_01530_ys
end type
type rr_1 from roundrectangle within w_pdm_01530_ys
end type
end forward

global type w_pdm_01530_ys from window
integer width = 2615
integer height = 2256
boolean titlebar = true
string title = "양산이관"
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
global w_pdm_01530_ys w_pdm_01530_ys

type variables
string  is_gubun
long   d1_currentRow, d2_currentRow
end variables

forward prototypes
public subroutine wf_server_copy ()
public subroutine wf_save ()
public function integer wf_copy_itnbr (string arg_itnbr, string arg_nitnbr)
public function integer wf_copy_bom (string arg_pinbr, string arg_cinbr, string arg_usseq, string arg_npinbr, string arg_ncinbr)
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

public subroutine wf_save ();//long i
//string ls_chk, s_itnbr
//
//
//for i = 1 to dw_1.rowcount()
//	ls_chk = dw_1.getitemstring( i, 'chk')
//	
//	if ls_chk = 'N' then continue
//	
//	s_itnbr = dw_1.getitemstring(i,'itnbr')
//
//	if SQLCA.FUN_ITEMBOM_XCOPY(s_itnbr) < 0 then
//		messagebox("확인",'  ' + s_itnbr + '  품번 양산 이관중 오류 발생!!')
//		continue
//	end if
//next
//
//p_inq.event clicked( )
//
//messagebox("확인",'양산이관 완료!!')




end subroutine

public function integer wf_copy_itnbr (string arg_itnbr, string arg_nitnbr);string ls_new_itnbr
int li_cnt


SELECT count(*) into :li_cnt FROM ITEMAS WHERE ITNBR = :arg_nitnbr;

if li_cnt > 0 then return 0


INSERT INTO ITEMAS
( 	SABU, ITNBR, ITDSC, ISPEC, JIJIL, JEJOS, ITTYP, GRITU, ITCLS, SEQNO, ITNBR_VERSION, ENGNO, EMPNO2, LOTGUB, GBWAN, GBDATE, 
	GBGUB, USEYN, STDNBR, EMPNO, PUMSR, CNVFAT, UNMSR, WAGHT, FILSK, ACCOD, ITGU, CHGBN, QCEMP, LOCFR, LOCTO, HSNO, ABCGB, 
	SILSU, SILDATE, WONPRC, FORPRC, FORPUN, WONSRC, FORSRC, FORSUN, GNHNO, MLICD, LDTIM, LDTIM2, MINSAF, MIDSAF, MAXSAF, SHRAT, 
	MINQT, MULQT, MAXQT, AUTO, ESTDATE, BASEQTY, PACKQTY, SPEC2, JIJIL2, REMARK, AUTOHOLD, LOT, QCGUB, QCRMKS, REPREITNBR, 
//	CRT_DATE, CRT_TIME, CRT_USER, UPD_DATE, UPD_TIME, UPD_USER, 
	PRPGUB, HOLDYN, YEBI1, YEBI2, YEBI3, NEWITS, NEWITE, BALRATE, PANGBN, ISPEC_CODE, WONFAC, FORFAC, MDL_JIJIL, RMARK, RMARK2, 
	ENG_YN, PDTGU, JOCOD, MUSEQTY, MNAPQTY, MROINFO, GURE_GIGAN, GURE_RANGE, SHAER_RATE, ALLOW_RATE  )
SELECT
 	SABU, :arg_nitnbr, ITDSC, ISPEC, JIJIL, JEJOS, ITTYP, GRITU, ITCLS, SEQNO, ITNBR_VERSION, ENGNO, EMPNO2, LOTGUB, GBWAN, GBDATE, 
	GBGUB, USEYN, STDNBR, EMPNO, PUMSR, CNVFAT, UNMSR, WAGHT, FILSK, ACCOD, ITGU, CHGBN, QCEMP, LOCFR, LOCTO, HSNO, ABCGB, 
	SILSU, SILDATE, WONPRC, FORPRC, FORPUN, WONSRC, FORSRC, FORSUN, GNHNO, MLICD, LDTIM, LDTIM2, MINSAF, MIDSAF, MAXSAF, SHRAT, 
	MINQT, MULQT, MAXQT, AUTO, ESTDATE, BASEQTY, PACKQTY, SPEC2, JIJIL2, REMARK, AUTOHOLD, LOT, QCGUB, QCRMKS, REPREITNBR, 
//	CRT_DATE, CRT_TIME, CRT_USER, UPD_DATE, UPD_TIME, UPD_USER, 
	PRPGUB, HOLDYN, YEBI1, YEBI2, YEBI3, NEWITS, NEWITE, BALRATE, PANGBN, ISPEC_CODE, WONFAC, FORFAC, MDL_JIJIL, RMARK, RMARK2, 
	ENG_YN, PDTGU, JOCOD, MUSEQTY, MNAPQTY, MROINFO, GURE_GIGAN, GURE_RANGE, SHAER_RATE, ALLOW_RATE	
FROM  ITEMAS
WHERE ITNBR = :arg_itnbr;

if sqlca.sqlcode <> 0 then
	rollback;
	return -1
end if

return 1
end function

public function integer wf_copy_bom (string arg_pinbr, string arg_cinbr, string arg_usseq, string arg_npinbr, string arg_ncinbr);
INSERT INTO PSTRUC
(	PINBR, CINBR, USSEQ, QTYPR, ADTIN, OPSNO, 
	EFRDT, EFTDT, 
	GUBUN, DCINBR, BOMEND, PCBLOC, RMKS,
//	CRT_DATE, CRT_TIME, CRT_USER, UPD_DATE, UPD_TIME, UPD_USER, 
	SAGUB, GUBUN2   )
select
	:arg_npinbr, :arg_ncinbr, USSEQ, QTYPR, ADTIN, OPSNO, 
	TO_CHAR(SYSDATE,'YYYYMMDD'), '99991231', 
	GUBUN, DCINBR, BOMEND, PCBLOC, RMKS,
//	CRT_DATE, CRT_TIME, CRT_USER, UPD_DATE, UPD_TIME, UPD_USER, 
	SAGUB, GUBUN2
from PSTRUC
where PINBR = :arg_pinbr
  AND CINBR = :arg_cinbr
  AND USSEQ = :arg_usseq ;

if sqlca.sqlcode <> 0 then
	rollback;
	return -1
end if

return 1
end function

event open;f_window_center_response(this)

dw_1.settransobject(sqlca)
dw_2.settransobject(sqlca)
dw_2.INSERTROW(0)
dw_2.SetFocus()


if isnull(gs_code) or gs_code = '' then return

dw_2.setitem(1,'itnbr',gs_code)
dw_2.triggerevent(itemchanged!)





	
end event

on w_pdm_01530_ys.create
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

on w_pdm_01530_ys.destroy
destroy(this.p_mod)
destroy(this.p_inq)
destroy(this.p_can)
destroy(this.p_exit)
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.rr_1)
end on

type p_mod from uo_picture within w_pdm_01530_ys
integer x = 2043
integer y = 32
integer width = 178
integer taborder = 30
string pointer = "HyperLink!"
string picturename = "C:\erpman\image\양산이관_up.gif"
end type

event clicked;call super::clicked;string ls_itnbr, ls_nitnbr, ls_pinbr, ls_usseq, ls_rinbr, ls_chk
string ls_npinbr, ls_ncinbr, ls_cinbr, ls_ittyp
long i, ll_find, ll_end
int li_lvl, li_lvl_old
string searchstr


ls_rinbr = dw_2.getitemstring(1,'to_itnbr')
if isnull(ls_rinbr) or ls_rinbr = '' then return
	
select ittyp into :ls_ittyp from itemas where itnbr = :ls_rinbr;

if sqlca.sqlcode <> 0  or ls_ittyp <> '1' then
	messagebox("확인", '양산이관 품번이 올바르지 않습니다.!!')
	return
end if


ll_end = dw_1.rowcount()

if ll_end < 1 then return
if messagebox("복사", "복사생성 하시겠읍니까?", question!, yesno!) = 2 then return

ll_find = 1
for i = 1 to ll_end
	if dw_1.object.chk[i] = 'Y' then
		ls_nitnbr = trim(dw_1.object.nitnbr[i])
		
		IF ISNULL(ls_nitnbr) OR ls_nitnbr = '' THEN
			messagebox("확인", '생성 품번정보 오류')	
			dw_1.scrolltorow(i)
			dw_1.setcolumn('nitnbr')
			dw_1.setfocus( )
			RETURN
		END IF
		
		ls_cinbr  = dw_1.object.itnbr[i]
		dw_1.object.nitnbr[i] = ls_nitnbr
		
		searchstr = "pinbr = '" + ls_cinbr + "' "
		ll_find = dw_1.Find(searchstr, ll_find, ll_end)
		DO WHILE ll_find > 0
				  // Collect found row
				  dw_1.setitem(ll_find,'npinbr', ls_nitnbr )
				  
				  ll_find++
				  // Prevent endless loop
				  IF ll_find > ll_end THEN EXIT
				  ll_find = dw_1.Find(searchstr, ll_find, ll_end)
		LOOP		
	end if
next

for i = 1 to ll_end
	if dw_1.object.chk[i] = 'Y' then
		ls_itnbr = dw_1.object.itnbr[i]
		ls_nitnbr = dw_1.object.nitnbr[i]
		
		//신규 품번 복사생성
		if wf_copy_itnbr(ls_itnbr, ls_nitnbr) < 0 then
			messagebox("확인", '품번생성 오류!!')
			RETURN
		end if
	end if
next

for i = 1 to dw_1.rowcount( )
		ls_pinbr 	= dw_1.object.pinbr[i]
		ls_cinbr 	= dw_1.object.itnbr[i]
		ls_ncinbr 	= dw_1.object.nitnbr[i]	
		ls_npinbr 	= dw_1.object.npinbr[i]	
		ls_usseq 	= dw_1.object.usseq[i]
		li_lvl		= dw_1.object.lvlno[i]
		
		if li_lvl = 1 then
			ls_npinbr = ls_rinbr
		end if	
		
		if ls_pinbr = ls_npinbr and ls_cinbr = ls_ncinbr then continue
		
		//bom 복사생성
		if wf_copy_bom(ls_pinbr, ls_cinbr, ls_usseq, ls_npinbr, ls_ncinbr) < 0 then
			messagebox("확인", 'BOM생성 오류!!')
			return
		end if
next
commit;

messagebox("확인", '양산품번으로 복사생성 완료!!')
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\양산이관_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\양산이관_up.gif"
end event

type p_inq from uo_picture within w_pdm_01530_ys
integer x = 1870
integer y = 32
integer width = 178
integer taborder = 20
boolean bringtotop = true
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;String scode, sname, sspec, sgu, sitcls, sgrp_sql
String sold_sql, swhere_clause, snew_sql

dw_2.AcceptText()

scode  = trim(dw_2.GetItemString(1,'itnbr'))


IF IsNull(scode)  THEN scode  = ""
	
if dw_1.Retrieve(scode) < 1 then
	f_message_Chk(300, '[복사품목의 BOM]')
	dw_2.setcolumn('itnbr')
	dw_2.setfocus()
	return 	
end if


	
//dw_1.SelectRow(0,False)
//dw_1.SelectRow(1,True)
//dw_1.ScrollToRow(1)
//dw_1.SetFocus()


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

type p_can from uo_picture within w_pdm_01530_ys
integer x = 2217
integer y = 32
integer width = 178
integer taborder = 40
boolean bringtotop = true
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;dw_1.setredraw(false)
dw_2.setredraw(false)

dw_1.reset()
dw_2.reset()
dw_2.insertrow(0)

dw_1.setredraw(true)
dw_2.setredraw(true)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

type p_exit from uo_picture within w_pdm_01530_ys
integer x = 2391
integer y = 32
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

type dw_2 from datawindow within w_pdm_01530_ys
event ue_key pbm_dwnkey
integer x = 18
integer y = 12
integer width = 1778
integer height = 280
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pdm_01530_ys_1"
boolean border = false
boolean livescroll = true
end type

event itemchanged;string snull, s_name, sitnbr, sItDsc
long ll_cnt

setnull(snull)

IF this.GetColumnName() = 'itnbr' THEN
		sitnbr = gettext()
		SELECT "ITEMAS"."ITDSC"
		  INTO :sItDsc
		  FROM "ITEMAS"
		 WHERE "ITEMAS"."ITNBR" = :sItnbr AND	"ITEMAS"."USEYN" = '0' ;

		IF SQLCA.SQLCODE <> 0 THEN
			MessageBox("품번", "등록되지 않은 품번입니다", stopsign!)
			Return 1
		END IF
		SetItem(1,"itdsc",   sItDsc)
		p_inq.triggerevent(clicked!)
END IF

IF this.GetColumnName() = 'to_itnbr' THEN
		sitnbr = gettext()
		SELECT "ITEMAS"."ITDSC"
		  INTO :sItDsc
		  FROM "ITEMAS"
		 WHERE "ITEMAS"."ITNBR" = :sItnbr AND	"ITEMAS"."USEYN" = '0' ;

		IF SQLCA.SQLCODE <> 0 THEN
			MessageBox("품번", "등록되지 않은 품번입니다", stopsign!)
			Return 1
		END IF
		SetItem(1,"to_itdsc",   sItDsc)
		
		
		// 해당 bom 존재여부 체크...
		
		select count(*) into :ll_cnt
		from PSTRUC where pinbr = :sitnbr ;
		
		if ll_cnt > 0 THEN 
			MessageBox("품번", "BOM 정보가 이미 존재합니다.", stopsign!)
			Return 1
		END IF
		
END IF


end event

event itemerror;RETURN 1
end event

event rbuttondown;Long nRow
String sItnbr, sNull

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)
SetNull(sNull)
nRow     = GetRow()
If nRow <= 0 Then Return
Choose Case GetcolumnName() 
	Case "itnbr"
		gs_gubun = '1'
		Open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		SetItem(nRow,"itnbr",gs_code)
		PostEvent(ItemChanged!)
	Case "to_itnbr"
		gs_gubun = '1'
		Open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		SetItem(nRow,"to_itnbr",gs_code)
		PostEvent(ItemChanged!)
end choose
end event

type dw_1 from uo_multi_select within w_pdm_01530_ys
integer x = 69
integer y = 316
integer width = 2469
integer height = 1776
integer taborder = 0
boolean enabled = true
string dataobject = "d_pdm_01530_ys_2"
boolean hscrollbar = false
boolean border = false
borderstyle borderstyle = stylebox!
end type

event itemchanged;call super::itemchanged;string ls_colnm, ls_itnbr, ls_newitnbr

ls_itnbr = this.getitemstring(row,'itnbr')

choose case dwo.name
	case 'chk'
		if data = 'Y' then
			if left(ls_itnbr,1) = 'X' then
				ls_newitnbr = mid(ls_itnbr,2)
			else
				setnull(ls_newitnbr)
			end if
			this.setitem(row,'nitnbr',ls_newitnbr)	
			this.setcolumn('nitnbr')
			this.setfocus( )
		else
			this.setitem(row,'nitnbr',ls_itnbr)			
		end if
end choose
end event

type rr_1 from roundrectangle within w_pdm_01530_ys
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 296
integer width = 2501
integer height = 1820
integer cornerheight = 40
integer cornerwidth = 55
end type

