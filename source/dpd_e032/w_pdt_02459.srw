$PBExportHeader$w_pdt_02459.srw
$PBExportComments$치공구 - 작업의뢰서
forward
global type w_pdt_02459 from w_standard_print
end type
end forward

global type w_pdt_02459 from w_standard_print
string title = "작업의뢰서(치공구)"
end type
global w_pdt_02459 w_pdt_02459

type variables
String    is_cod  = '1'   //출력구분: 1:print,2:none,3:샘플
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sorder_no, sgub, ssugub, sDate, eDate, sPdtgu, ePdtgu

if dw_ip.AcceptText() = -1 then return -1

sorder_no = trim(dw_ip.GetItemString(1,"order_no"))
//sgub      = dw_ip.GetItemString(1,"gub")
//sSugub    = dw_ip.GetItemString(1,"sugugb")
//
sDate     = trim(dw_ip.GetItemString(1,"sdate"))
eDate     = trim(dw_ip.GetItemString(1,"edate"))
//sPdtgu    = trim(dw_ip.GetItemString(1,"spdtgu"))
//ePdtgu    = trim(dw_ip.GetItemString(1,"epdtgu"))

IF sDate = '' OR ISNULL(sDate) THEN  sDate = '10000101'
IF eDate = '' OR ISNULL(eDate) THEN  eDate = '99991231'
//IF sPdtgu = '' OR ISNULL(sPdtgu) THEN  sPdtgu = '.'
//IF ePdtgu = '' OR ISNULL(ePdtgu) THEN  ePdtgu = 'zzzzzz'
IF sorder_no = '' OR ISNULL(sorder_no) THEN sorder_no = '%'

IF dw_list.Retrieve(gs_sabu, sDate, eDate, sorder_no) < 1 THEN
	f_message_chk(50,'')
	dw_ip.setfocus()
	return -1
END IF	

Return 1

end function

on w_pdt_02459.create
call super::create
end on

on w_pdt_02459.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;dw_ip.setitem(1, 'sdate', is_today)
dw_ip.setitem(1, 'edate', is_today)
end event

type p_preview from w_standard_print`p_preview within w_pdt_02459
end type

type p_exit from w_standard_print`p_exit within w_pdt_02459
end type

type p_print from w_standard_print`p_print within w_pdt_02459
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_02459
end type







type dw_ip from w_standard_print`dw_ip within w_pdt_02459
integer x = 41
integer y = 88
integer width = 736
integer height = 456
string dataobject = "d_pdt_02459_a"
end type

event dw_ip::itemchanged;string snull, s_cod, sdate, smakgub, smjgbn

SetNull(snull)
Choose Case GetColumnName() 
	 Case "order_no"
			s_cod = Trim(this.GetText())
 		   IF s_cod = '' or isnull(s_cod) then return 

		   SELECT CONF_DATE, MAKGUB, MJGBN  
			  INTO :sdate, :smakgub, :smjgbn
			  FROM KUMEST  
			 WHERE ( SABU   = :gs_sabu ) AND  
					 ( KESTNO = :s_cod )   ;

			IF SQLCA.SQLCODE <> 0 THEN 
				MessageBox('확 인', '치공구 의뢰번호를 확인하세요!')
				setitem(1, 'order_no', snull)
				Return 1
			ELSEIF smakgub = '3' then 
				MessageBox('확 인', '제작구분이 구매는 선택할 수 없습니다. 의뢰번호를 확인하세요!')
				setitem(1, 'order_no', snull)
				Return 1
			ELSEIF smjgbn <> 'J' then 
				MessageBox('확 인', '치공구 의뢰번호만 선택할 수 있습니다. 의뢰번호를 확인하세요!')
				setitem(1, 'order_no', snull)
				Return 1
			END IF
			
		   this.setitem(1, 'sdate', sdate)
		   this.setitem(1, 'edate', sdate)
	 Case "sdate"
			s_cod = Trim(this.GetText())
		   IF s_cod = '' or isnull(s_cod) then return 
 		   if f_datechk(s_cod) = -1 then
				F_message_chk(35,'[의뢰승인일]')
				setitem(1, 'sdate', snull)
				return 1
			end if 
	 Case "edate"
			s_cod = Trim(this.GetText())
		   IF s_cod = '' or isnull(s_cod) then return 
 		   if f_datechk(s_cod) = -1 then
				F_message_chk(35,'[의뢰승인일]')
				setitem(1, 'edate', snull)
				return 1
			end if 
END Choose


end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;setnull( gs_code) 
setnull( gs_codename )
setnull( gs_gubun ) 

IF this.GetColumnName() = 'order_no'	THEN
	gs_gubun = '치공구'
	gs_code = '사내'
	open(w_pdt_02451)
	IF gs_code = '' or isnull(gs_code) then return 
	SetItem(1, "order_no", gs_code)
	this.triggerevent(itemchanged!)
END IF

end event

type dw_list from w_standard_print`dw_list within w_pdt_02459
string dataobject = "d_pdt_02459_1"
end type

event dw_list::printend;//Long  k, lRow 
//
//lRow = this.Rowcount()
//FOR k = 1 TO lRow
//	this.setitem(k, 'sorder_print_print_yn', 'Y')
//NEXT
//
//If this.update() = -1 then
//	rollback ;
//	sle_msg.text = '출력여부 저장 실패!'
//else
//	commit;
//end if	
//
//
end event

