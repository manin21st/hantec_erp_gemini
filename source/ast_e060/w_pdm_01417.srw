$PBExportHeader$w_pdm_01417.srw
$PBExportComments$** 설비별 1회 투입량 등록
forward
global type w_pdm_01417 from w_inherite
end type
type dw_jogun from datawindow within w_pdm_01417
end type
type dw_1 from datawindow within w_pdm_01417
end type
type rr_1 from roundrectangle within w_pdm_01417
end type
type rr_2 from roundrectangle within w_pdm_01417
end type
end forward

global type w_pdm_01417 from w_inherite
integer height = 2380
string title = "제품별 설비 1회 생산투입량"
dw_jogun dw_jogun
dw_1 dw_1
rr_1 rr_1
rr_2 rr_2
end type
global w_pdm_01417 w_pdm_01417

type variables
string is_itnbr
end variables

forward prototypes
public function integer wf_required_chk ()
public function boolean wf_duplication_chk (integer crow)
public function integer wf_delete_chk (string sjocod)
end prototypes

public function integer wf_required_chk ();//필수입력항목 체크
Long i

for i = 1 to dw_insert.RowCount()
	if Isnull(dw_insert.object.jocod[i]) or dw_insert.object.jocod[i] =  "" then
	   f_message_chk(1400,'[조코드]')
	   dw_insert.SetColumn('jocod')
	   dw_insert.SetFocus()
	   return -1
   end if	
	
	if Isnull(dw_insert.object.jonam[i]) or dw_insert.object.jonam[i] =  "" then
	   f_message_chk(1400,'[조명]')
	   dw_insert.SetColumn('jonam')
	   dw_insert.SetFocus()
	   return -1
   end if
	
	if Isnull(dw_insert.object.pdtgu[i]) or dw_insert.object.pdtgu[i] =  "" then
	   f_message_chk(1400,'[생산팀]')
	   dw_insert.SetColumn('pdtgu')
	   dw_insert.SetFocus()
	   return -1
   end if
	if Isnull(dw_insert.object.dptno[i]) or dw_insert.object.dptno[i] =  "" then
	   f_message_chk(1400,'[부서]')
	   dw_insert.SetColumn('dptno')
	   dw_insert.SetFocus()
	   return -1
   end if
next

return 1
end function

public function boolean wf_duplication_chk (integer crow);String s1
long   ll_frow

dw_insert.AcceptText()

s1 = dw_insert.object.jocod[crow]

ll_frow = dw_insert.Find("jocod = '" + s1 + "'", 1, crow - 1)
if ll_frow = crow then
elseif not (IsNull(ll_frow) or ll_frow < 1) then
	f_message_chk(1, "[" + String(ll_Frow) + " 번째ROW]")
	return False
end if

ll_frow = dw_insert.Find("jocod = '" + s1 + "'", crow + 1, dw_insert.RowCount())

if ll_frow = crow then
elseif not (IsNull(ll_frow) or ll_frow < 1) then
	f_message_chk(1, "[" + String(ll_Frow) + " 번째ROW]")
	return False
end if

return true
end function

public function integer wf_delete_chk (string sjocod);long  l_cnt

l_cnt = 0
SELECT COUNT(*)
  INTO :l_cnt
  FROM JODETL
 WHERE JOCOD = :sjocod;

if sqlca.sqlcode <> 0 or l_cnt >= 1 then
	f_message_chk(38,'[조별인원]')
	return -1
end if

l_cnt = 0
SELECT COUNT(*)
  INTO :l_cnt  
  FROM WRKCTR  
 WHERE JOCOD = :sjocod   ;

if sqlca.sqlcode <> 0 or l_cnt >= 1 then
	f_message_chk(38,'[작업장마스타]')
	return -1
end if

l_cnt = 0
SELECT COUNT(*)
  INTO :l_cnt  
  FROM MOROUT
 WHERE SABU = :gs_sabu AND JOCOD = :sjocod   ;

if sqlca.sqlcode <> 0 or l_cnt >= 1 then
	f_message_chk(38,'[작업공정]')
	return -1
end if

return 1
end function

on w_pdm_01417.create
int iCurrent
call super::create
this.dw_jogun=create dw_jogun
this.dw_1=create dw_1
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_jogun
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.rr_1
this.Control[iCurrent+4]=this.rr_2
end on

on w_pdm_01417.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_jogun)
destroy(this.dw_1)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_insert.SetTransObject(SQLCA)
dw_jogun.SetTransObject(SQLCA)
dw_jogun.insertrow(0)

f_mod_saupj(dw_jogun, 'porgu')


end event

type dw_insert from w_inherite`dw_insert within w_pdm_01417
integer x = 2501
integer y = 424
integer width = 2071
integer height = 1720
integer taborder = 20
string dataobject = "d_pdm_01417"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = false
end type

event dw_insert::itemerror;RETURN 1
end event

event dw_insert::itemchanged;decimal {3} dqty
String  smchno
Long    Lrow, Lcnt

Lrow = row

smchno = getitemstring(Lrow, "mchno")
dqty  =  Dec(gettext())

Lcnt = 0
Select nvl(count(*), 0) into :lcnt from pstmch where itnbr = :is_itnbr and mchno = :smchno;
If Lcnt > 0 then
	If dqty = 0 then
		delete From pstmch where itnbr = :is_itnbr and mchno = :smchno;	
	Else
		Update pstmch set yoqty = :dqty where itnbr = :is_itnbr and mchno = :smchno;			
	End if
	
	iF SQLCA.SQLCODE <> 0 THEN
		MessageBox("저장실패", "자료저장에 실패", stopsign!)
		rollback;
		return
	end if
	
Else
	If dqty > 0 then
		Insert into pstmch (itnbr, mchno, yoqty)
			Values (:is_itnbr, :smchno, :dqty);
			
		iF SQLCA.SQLCODE <> 0 THEN
			MessageBox("저장실패", "자료저장에 실패", stopsign!)
			rollback;
			return
		end if			
			
	end if 
End if

Commit;
end event

type p_delrow from w_inherite`p_delrow within w_pdm_01417
boolean visible = false
integer x = 2450
integer y = 2300
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_pdm_01417
boolean visible = false
integer x = 2263
integer y = 2300
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_pdm_01417
boolean visible = false
integer x = 1714
integer y = 2292
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_pdm_01417
boolean visible = false
integer x = 677
integer y = 2444
integer taborder = 10
end type

event p_ins::clicked;call super::clicked;Long crow

dw_insert.Setredraw(False)
crow = dw_insert.InsertRow(dw_insert.GetRow() + 1)
if IsNull(crow) then 
	dw_insert.InsertRow(0)
end if	
dw_insert.ScrollToRow(crow)
dw_insert.Setredraw(True)
dw_insert.SetColumn("jocod") 
dw_insert.SetFocus()

end event

type p_exit from w_inherite`p_exit within w_pdm_01417
integer x = 4375
end type

type p_can from w_inherite`p_can within w_pdm_01417
integer x = 4201
end type

event p_can::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

dw_1.reset()
dw_insert.reset()

f_mod_saupj(dw_jogun, 'porgu')

w_mdi_frame.sle_msg.Text = "최종 저장 후의 작업을 취소 하였습니다!"
ib_any_typing = False //입력필드 변경여부 No


end event

type p_print from w_inherite`p_print within w_pdm_01417
boolean visible = false
integer x = 1888
integer y = 2292
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_pdm_01417
integer x = 4027
integer taborder = 0
end type

event p_inq::clicked;call super::clicked;String scode, sname, sspec, sgu, sitcls, sJijil, ls_porgu
String sold_sql, swhere_clause, snew_sql

if dw_jogun.AcceptText() = -1 then return 

sgu 		= dw_jogun.GetItemString(1,'ittyp')
ls_porgu 	= dw_jogun.GetItemString(1,'porgu')

IF IsNull(sgu) THEN sgu = ""

scode  	= trim(dw_jogun.GetItemString(1,'itnbr'))
sname  	= trim(dw_jogun.GetItemString(1,'itdsc'))
sspec  	= trim(dw_jogun.GetItemString(1,'ispec'))
sitcls 		= trim(dw_jogun.GetItemString(1,'itcls'))
sJijil 		= trim(dw_jogun.GetItemString(1,'jijil'))

IF IsNull(scode)  	THEN scode  = ""
IF IsNull(sname)  	THEN sname  = ""
IF IsNull(sspec)  	THEN sspec  = ""
IF IsNull(sitcls) 		THEN sitcls = ""
IF IsNull(sJijil) 		THEN sJijil = ""

sold_sql = "SELECT A.ITNBR, A.ITDSC, A.ISPEC, A.JIJIL, " + &  
           "       B.TITNM, B.PDTGU, A.USEYN, A.FILSK,  " + &
			  " FUN_GET_BOMCHK2(A.ITNBR, '2') AS PUSE_YN, " +&
                  "A.GRITU , "  + &
                  "A.MDL_JIJIL, "  + &
                  "C.CVCOD, "  + &
                  "FUN_GET_CVNAS(C.CVCOD), "  + &
                  "C.BUNBR  " + & 
            "  FROM ITEMAS A, ITNCT B, ITMBUY C "                      + & 
           " WHERE A.ITTYP = B.ITTYP (+) AND A.ITCLS = B.ITCLS (+) AND "  + &
			  "       A.GBWAN = 'Y' AND A.ITNBR = C.ITNBR (+) "      
swhere_clause = ""

IF 	sgu <> ""  THEN 
   	swhere_clause = 	swhere_clause + "AND A.ITTYP ='"		+sgu			+"'"
END IF
IF 	scode <> "" THEN
	scode = '%' + scode +'%'
	swhere_clause = 	swhere_clause + "AND A.ITNBR LIKE '"	+scode		+"'"
END IF
IF 	sname <> "" THEN
	sname = '%' + sname +'%'
	swhere_clause = 	swhere_clause + "AND A.ITDSC LIKE '"	+sname		+"'"
END IF
IF 	sspec <> "" THEN
	sspec = '%' + sspec +'%'
	swhere_clause = 	swhere_clause + "AND A.ISPEC LIKE '"	+sspec		+"'"
END IF
IF 	sitcls <> "" THEN
	sitcls = sitcls +'%'
	swhere_clause = 	swhere_clause + "AND A.ITCLS LIKE '"	+sitcls			+"'"
END IF
IF 	sJijil <> "" THEN
	sJijil = '%' + sJijil +'%'
	swhere_clause = 	swhere_clause + "AND A.JIJIL LIKE '"		+sJijil			+"'"
END IF
//-------------------  추가.(사업장)
IF 	ls_porgu 	<> "" THEN
	swhere_clause = 	swhere_clause + "AND ( B.PORGU = 'ALL' OR B.PORGU LIKE '"		+ ls_porgu	+"'" + ' )' 
END IF

snew_sql = sold_sql + swhere_clause
dw_1.SetSqlSelect(snew_sql)
dw_1.settransobject(sqlca)
	
dw_1.Retrieve()
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type p_del from w_inherite`p_del within w_pdm_01417
boolean visible = false
integer x = 1024
integer y = 2444
end type

event p_del::clicked;call super::clicked;long 	lcRow
String s_jocod

IF dw_insert.accepttext() = -1 then return 

lcRow = dw_insert.GetRow()
if lcRow <= 0 then return

s_jocod = dw_insert.object.jocod[lcRow]

if wf_delete_chk(s_jocod) = -1 then return 

if f_msg_delete() = -1 then return

dw_insert.SetRedraw(False)
dw_insert.DeleteRow(lcRow)
IF dw_insert.Update() = 1 THEN
	COMMIT;
	w_mdi_frame.sle_msg.Text = "삭제 되었습니다!"
ELSE
	ROLLBACK;
	f_message_chk(31,'[삭제실패]') 
	dw_insert.SetRedraw(True)
	Return
END IF

dw_insert.SetRedraw(True)
ib_any_typing = False //입력필드 변경여부 No
end event

type p_mod from w_inherite`p_mod within w_pdm_01417
boolean visible = false
integer x = 850
integer y = 2444
integer taborder = 40
end type

event p_mod::clicked;call super::clicked;if dw_insert.AcceptText() = -1 then return 

if wf_required_chk() = -1 then return //필수입력항목 체크 

if f_msg_update() = -1 then return  //저장 Yes/No ?

if dw_insert.Update() = 1 then
	COMMIT;
	w_mdi_frame.sle_msg.text = "저장 되었습니다!"	
	ib_any_typing = False //입력필드 변경여부 No
else
	f_message_chk(32,'[자료저장 실패]') 
	ROLLBACK;
   w_mdi_frame.sle_msg.text = "저장작업 실패 하였습니다!"
	return 
end if
 
end event

type cb_exit from w_inherite`cb_exit within w_pdm_01417
integer x = 4041
integer y = 2328
end type

type cb_mod from w_inherite`cb_mod within w_pdm_01417
integer x = 2999
integer y = 2328
end type

type cb_ins from w_inherite`cb_ins within w_pdm_01417
integer x = 2651
integer y = 2328
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_pdm_01417
integer x = 3346
integer y = 2328
end type

type cb_inq from w_inherite`cb_inq within w_pdm_01417
integer x = 393
integer y = 2320
end type

type cb_print from w_inherite`cb_print within w_pdm_01417
integer x = 1253
integer y = 2336
end type

type st_1 from w_inherite`st_1 within w_pdm_01417
end type

type cb_can from w_inherite`cb_can within w_pdm_01417
integer x = 3694
integer y = 2328
end type

type cb_search from w_inherite`cb_search within w_pdm_01417
integer x = 750
integer y = 2336
end type





type gb_10 from w_inherite`gb_10 within w_pdm_01417
integer x = 18
integer y = 2512
integer height = 140
integer textsize = -8
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_pdm_01417
end type

type gb_button2 from w_inherite`gb_button2 within w_pdm_01417
end type

type dw_jogun from datawindow within w_pdm_01417
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 9
integer y = 12
integer width = 2450
integer height = 400
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_itemas_ittyp"
boolean border = false
boolean livescroll = true
end type

event ue_key;//Parent.event key(key, keyflags)
end event

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

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

event itemerror;return 1
end event

type dw_1 from datawindow within w_pdm_01417
integer x = 46
integer y = 432
integer width = 2350
integer height = 1700
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_itemas_popup"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event doubleclicked;string sitnbr

selectrow(0, false)

IF ROW < 1 THEN RETURN

selectrow(row, true)

sitnbr = getitemstring(Row, "itemas_itnbr")
is_itnbr = sitnbr

dw_insert.retrieve(gs_sabu, sitnbr)
dw_insert.setfocus()
end event

type rr_1 from roundrectangle within w_pdm_01417
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 416
integer width = 2405
integer height = 1736
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdm_01417
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2469
integer y = 416
integer width = 2139
integer height = 1736
integer cornerheight = 40
integer cornerwidth = 55
end type

