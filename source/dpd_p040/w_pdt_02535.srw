$PBExportHeader$w_pdt_02535.srw
$PBExportComments$작업의뢰서
forward
global type w_pdt_02535 from w_standard_print
end type
end forward

global type w_pdt_02535 from w_standard_print
integer height = 2496
string title = "작업의뢰서( Print/None_Print/Sample)"
end type
global w_pdt_02535 w_pdt_02535

type variables
String    is_cod  = '1'   //출력구분: 1:print,2:none,3:샘플
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sorder_no, sgub, ssugub, sDate, eDate, sPdtgu, ePdtgu, sfitcls, stitcls, sempno 

if dw_ip.AcceptText() = -1 then return -1

sorder_no = trim(dw_ip.GetItemString(1,"order_no"))
sgub      = dw_ip.GetItemString(1,"gub")
sSugub    = dw_ip.GetItemString(1,"sugugb")

sDate     = trim(dw_ip.GetItemString(1,"sdate"))
eDate     = trim(dw_ip.GetItemString(1,"edate"))
sPdtgu    = trim(dw_ip.GetItemString(1,"spdtgu"))
ePdtgu    = trim(dw_ip.GetItemString(1,"epdtgu"))
sfitcls   = trim(dw_ip.getitemstring(1, 'fitcls')) 
stitcls   = trim(dw_ip.getitemstring(1, 'titcls')) 
sempno    = trim(dw_ip.getitemstring(1, 'empno')) 

IF sDate = '' OR ISNULL(sDate) THEN  sDate = '10000101'
IF eDate = '' OR ISNULL(eDate) THEN  eDate = '99991231'
IF sPdtgu = '' OR ISNULL(sPdtgu) THEN  sPdtgu = '.'
IF ePdtgu = '' OR ISNULL(ePdtgu) THEN  ePdtgu = 'zzzzzz'
IF sorder_no = '' OR ISNULL(sorder_no) THEN sorder_no = '%'

if sfitcls = '' or isnull(sfitcls) then sfitcls = '.'
if stitcls = '' or isnull(stitcls) then 
	stitcls = 'zzzzzzz'
else
	stitcls = stitcls + 'zzzzzz'
end if	
if sempno = '' or isnull(sempno) then sempno = '%'

IF dw_list.Retrieve(gs_sabu, sDate, eDate, sorder_no, sPdtgu, ePdtgu, sgub, sfitcls, stitcls, sempno) < 1 THEN
	f_message_chk(50,'')
	dw_ip.setfocus()
	return -1
END IF	
    
//	dw_print.sharedata(dw_list) 
Return 1

end function

on w_pdt_02535.create
call super::create
end on

on w_pdt_02535.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;//dw_ip.setitem(1, 'sdate', is_today)
//dw_ip.setitem(1, 'edate', is_today)
end event

type p_preview from w_standard_print`p_preview within w_pdt_02535
end type

type p_exit from w_standard_print`p_exit within w_pdt_02535
end type

type p_print from w_standard_print`p_print within w_pdt_02535
end type

event p_print::clicked;if dw_ip.accepttext() = -1 then return 

is_cod = dw_ip.GetItemString(1, "sugugb")

CALL SUPER ::CLICKED

end event

type p_retrieve from w_standard_print`p_retrieve within w_pdt_02535
end type







type st_10 from w_standard_print`st_10 within w_pdt_02535
end type



type dw_print from w_standard_print`dw_print within w_pdt_02535
string dataobject = "d_pdt_02535_00_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_02535
integer y = 64
integer width = 3662
integer height = 288
string dataobject = "d_pdt_02535"
end type

event dw_ip::itemchanged;string snull, s_cod, sSugugb, sPrint_yn, sPangbn, sAgrdat

SetNull(snull)
Choose Case GetColumnName() 
	 Case "order_no"
			s_cod = Trim(this.GetText())
 		   IF s_cod = '' or isnull(s_cod) then return 

	      SELECT A.SUGUGB,   
					 NVL(B.PRINT_YN, 'N'), A.AGRDAT    
			  INTO :sSugugb, :sPrint_yn, :sAgrdat
			  FROM SORDER A, SORDER_PRINT B
			 WHERE A.SABU     = B.SABU(+)
			   AND A.ORDER_NO = B.ORDER_NO(+)
				AND A.SABU     = :gs_sabu
				AND A.ORDER_NO = :s_cod    ;
         
			IF SQLCA.SQLCODE <> 0 THEN 
				MessageBox('확 인', '수주번호를 확인하세요!')
				setitem(1, 'order_no', snull)
				Return 1
			ELSEIF sagrdat <= '0' or isnull(sagrdat) then 
				MessageBox('확 인', '생산승인이 안된 자료입니다. 자료를 확인하세요!')
				setitem(1, 'order_no', snull)
				Return 1
			ELSE
				IF sPrint_yn = 'Y' then   //출력
				   this.setitem(1, 'gub', 'Y')
				ELSE
				   this.setitem(1, 'gub', 'N')
				END IF
				
				IF sSugugb = '4' then   //샘플인 경우
				   this.setitem(1, 'sugugb', '3')
					dw_print.Dataobject = "d_pdt_02535_06_p"
				ELSEIF sSugugb = '1' THEN //PRINT 품 인 경우
				   this.setitem(1, 'sugugb', '1')
					dw_print.dataobject = "d_pdt_02535_00_p" 
				ELSE
					this.setitem(1, 'sugugb', '2')
					dw_print.Dataobject = "d_pdt_02535_01_p"
				END IF
			END IF
			dw_print.SetTransobject(sqlca)
		   this.setitem(1, 'sdate', snull)
		   this.setitem(1, 'edate', snull)
		   this.setitem(1, 'spdtgu', snull)
		   this.setitem(1, 'epdtgu', snull)
	 Case "sugugb"
			s_cod = Trim(this.GetText())

			IF s_cod = '1' then
				dw_print.dataobject = "d_pdt_02535_00_p" 
			elseif s_cod = '2'  THEN 
				dw_print.Dataobject = "d_pdt_02535_01_p"
			else
				dw_print.Dataobject = "d_pdt_02535_06_p"
			end if
			
			dw_print.SetTransobject(sqlca)
	 Case "sdate"
			s_cod = Trim(this.GetText())
		   IF s_cod = '' or isnull(s_cod) then return 
 		   if f_datechk(s_cod) = -1 then
				F_message_chk(35,'[수주승인일]')
				setitem(1, 'sdate', snull)
				return 1
			end if 
	 Case "edate"
			s_cod = Trim(this.GetText())
		   IF s_cod = '' or isnull(s_cod) then return 
 		   if f_datechk(s_cod) = -1 then
				F_message_chk(35,'[수주승인일]')
				setitem(1, 'edate', snull)
				return 1
			end if 
END Choose


end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;string sittyp
str_itnct lstr_sitnct

setnull( gs_code) 
setnull( gs_codename )
setnull( gs_gubun ) 

IF this.GetColumnName() = 'order_no'	THEN
	Open(w_suju_popup)
	IF gs_code = '' or isnull(gs_code) then return 
	SetItem(1, "order_no", gs_code)
	this.triggerevent(itemchanged!)
elseif this.GetColumnName() = 'fitcls' then

	sIttyp   = '1'
	OpenWithParm(w_ittyp_popup4, sIttyp)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1, "fitcls", lstr_sitnct.s_sumgub)
elseif this.GetColumnName() = 'titcls' then

	sIttyp   = '1'
	OpenWithParm(w_ittyp_popup4, sIttyp)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1, "titcls", lstr_sitnct.s_sumgub)
END IF

end event

type dw_list from w_standard_print`dw_list within w_pdt_02535
integer y = 368
string dataobject = "d_pdt_02535_00"
end type

event dw_list::printend;Long  k, lRow 

lRow = this.Rowcount()
FOR k = 1 TO lRow
	this.setitem(k, 'sorder_print_print_yn', 'Y')
NEXT

If this.update() = -1 then
	rollback ;
	sle_msg.text = '출력여부 저장 실패!'
else
	commit;
end if	


end event

