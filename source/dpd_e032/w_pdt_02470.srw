$PBExportHeader$w_pdt_02470.srw
$PBExportComments$금형/치공구 제작전표
forward
global type w_pdt_02470 from w_standard_print
end type
end forward

global type w_pdt_02470 from w_standard_print
string title = "금형/치공구 제작전표"
long backcolor = 79741120
end type
global w_pdt_02470 w_pdt_02470

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String pordno, sgub, ssugub, sDate, eDate, sPdtgu, ePdtgu, sittyp, sfitcls, stitcls, sempno 

if dw_ip.AcceptText() = -1 then return -1

pordno    = trim(dw_ip.GetItemString(1,"pordno"))
sgub      = dw_ip.GetItemString(1,"gub")

sDate     = trim(dw_ip.GetItemString(1,"sdate"))
eDate     = trim(dw_ip.GetItemString(1,"edate"))
//sPdtgu    = trim(dw_ip.GetItemString(1,"spdtgu"))
//ePdtgu    = trim(dw_ip.GetItemString(1,"epdtgu"))
//
//sittyp    = trim(dw_ip.getitemstring(1, 'ittyp')) 
//sfitcls   = trim(dw_ip.getitemstring(1, 'fitcls')) 
//stitcls   = trim(dw_ip.getitemstring(1, 'titcls')) 
//sempno    = trim(dw_ip.getitemstring(1, 'empno')) 

IF pordno = '' OR ISNULL(pordno) THEN  pordno = '%'

IF sDate = '' OR ISNULL(sDate) THEN  sDate = '10000101'
IF eDate = '' OR ISNULL(eDate) THEN  eDate = '99991231'

//IF sPdtgu = '' OR ISNULL(sPdtgu) THEN  sPdtgu = '.'
//IF ePdtgu = '' OR ISNULL(ePdtgu) THEN  ePdtgu = 'zzzzzz'

//if sfitcls = '' or isnull(sfitcls) then sfitcls = '.'
//if stitcls = '' or isnull(stitcls) then 
//	stitcls = 'zzzzzzz'
//else
//	stitcls = stitcls + 'zzzzzz'
//end if	
//if sempno = '' or isnull(sempno) then sempno = '%'
//if sittyp = '' or isnull(sittyp) then sittyp = '%'
//

//IF dw_list.Retrieve(gs_sabu, sDate, eDate, pordno, sPdtgu, ePdtgu, sgub, sittyp, sfitcls, stitcls, sempno ) < 1 THEN
IF dw_list.Retrieve(gs_sabu, sDate, eDate, pordno, sgub) < 1 THEN
	f_message_chk(50,'')
	dw_ip.setfocus()
	return -1
END IF	

Return 1

end function

on w_pdt_02470.create
call super::create
end on

on w_pdt_02470.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;dw_ip.Setfocus()

end event

type p_preview from w_standard_print`p_preview within w_pdt_02470
integer y = 1748
end type

type p_exit from w_standard_print`p_exit within w_pdt_02470
integer y = 1952
end type

type p_print from w_standard_print`p_print within w_pdt_02470
integer y = 1848
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_02470
integer y = 1744
end type







type dw_ip from w_standard_print`dw_ip within w_pdt_02470
integer x = 41
integer y = 76
integer width = 745
string dataobject = "d_pdt_02470"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::itemchanged;string snull, s_cod, sPrint_yn, gubun

SetNull(snull)
Choose Case GetColumnName() 
	 Case "pordno"
			s_cod = Trim(this.GetText())
 		   IF s_cod = '' or isnull(s_cod) then return 

	      SELECT NVL(B.PRINT_YN, 'N'), D.MJGBN   
			  INTO :sPrint_yn, :gubun
			  FROM MOMAST A, MOMAST_PRINT B, ITEMAS C, KUMEST D  
			 WHERE A.SABU   = B.SABU(+)
			   AND A.PORDNO = B.PORDNO(+)
				AND A.ITNBR  = C.ITNBR(+)
				AND A.PORGU  = '40'  
				AND A.SABU   = :gs_sabu
				AND A.PORDNO = :s_cod  
				AND A.SABU   = D.SABU(+)
			   AND A.KESTNO = D.KESTNO(+) ;
						
			IF SQLCA.SQLCODE <> 0 THEN 
				MessageBox('확 인', '금형/치공구 전표번호를 확인하세요!')
				setitem(1, 'pordno', snull)
				Return 1
			ELSE
				IF sPrint_yn = 'Y' then   //출력
				   this.setitem(1, 'gub', 'Y')
				ELSE
				   this.setitem(1, 'gub', 'N')
				END IF
			END IF
			
		   this.setitem(1, 'sdate', snull)
		   this.setitem(1, 'edate', snull)
		   this.setitem(1, 'spdtgu', snull)
		   this.setitem(1, 'epdtgu', snull)
			
			if gubun = 'M' then //금형
			   this.setitem(1, 'gub2', 'M')
				dw_list.Dataobject = "d_pdt_024701"
			ELSE
			   this.setitem(1, 'gub2', 'J')
				dw_list.Dataobject = "d_pdt_024705"
			END IF
			dw_list.SetTransobject(sqlca)
	 Case "sdate"
			s_cod = Trim(this.GetText())
		   IF s_cod = '' or isnull(s_cod) then return 
 		   if f_datechk(s_cod) = -1 then
				F_message_chk(35,'[작업승인일]')
				setitem(1, 'sdate', snull)
				return 1
			end if 
	 Case "edate"
			s_cod = Trim(this.GetText())
		   IF s_cod = '' or isnull(s_cod) then return 
 		   if f_datechk(s_cod) = -1 then
				F_message_chk(35,'[작업승인일]')
				setitem(1, 'edate', snull)
				return 1
			end if 
	 Case "gub2"
			s_cod = Trim(this.GetText())
			IF s_cod = 'M' then   //금형
				dw_list.Dataobject = "d_pdt_024701"
			ELSE
				dw_list.Dataobject = "d_pdt_024705"
			END IF
			dw_list.SetTransobject(sqlca)
END Choose




end event

event dw_ip::rbuttondown;call super::rbuttondown;string sittyp
str_itnct lstr_sitnct

setnull( gs_code) 
setnull( gs_codename )
setnull( gs_gubun ) 

IF this.GetColumnName() = 'pordno'	THEN
	gs_gubun = '40' 
	Open(w_jisi_popup)
	IF gs_code = '' or isnull(gs_code) then return 
	SetItem(1, "pordno", gs_code)
	this.triggerevent(itemchanged!)
elseif this.GetColumnName() = 'fitcls' then

	sIttyp   = this.getitemstring(1, 'ittyp')
	OpenWithParm(w_ittyp_popup4, sIttyp)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1, "ittyp",  lstr_sitnct.s_ittyp)
	this.SetItem(1, "fitcls", lstr_sitnct.s_sumgub)
elseif this.GetColumnName() = 'titcls' then

	sIttyp   = this.getitemstring(1, 'ittyp')
	OpenWithParm(w_ittyp_popup4, sIttyp)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1, "ittyp",  lstr_sitnct.s_ittyp)
	this.SetItem(1, "titcls", lstr_sitnct.s_sumgub)
END IF
end event

type dw_list from w_standard_print`dw_list within w_pdt_02470
integer x = 823
integer y = 16
integer width = 2811
integer height = 2060
string dataobject = "d_pdt_024701"
end type

event dw_list::printend;call super::printend;Long  k, lRow 

lRow = this.Rowcount()
FOR k = 1 TO lRow
	this.setitem(k, 'momast_print_print_yn', 'Y')
NEXT

If this.update() = -1 then
	rollback ;
	sle_msg.text = '출력여부 저장 실패!'
else
	commit;
end if	


end event

