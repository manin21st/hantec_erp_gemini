$PBExportHeader$w_mm03_00020.srw
$PBExportComments$** 자재실사 LIST (생성)
forward
global type w_mm03_00020 from w_inherite
end type
type rr_1 from roundrectangle within w_mm03_00020
end type
type dw_1 from datawindow within w_mm03_00020
end type
type dw_print from datawindow within w_mm03_00020
end type
type rr_2 from roundrectangle within w_mm03_00020
end type
end forward

global type w_mm03_00020 from w_inherite
string title = "재고 실사 LIST(생성)"
rr_1 rr_1
dw_1 dw_1
dw_print dw_print
rr_2 rr_2
end type
global w_mm03_00020 w_mm03_00020

on w_mm03_00020.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.dw_1=create dw_1
this.dw_print=create dw_print
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.dw_print
this.Control[iCurrent+4]=this.rr_2
end on

on w_mm03_00020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.dw_1)
destroy(this.dw_print)
destroy(this.rr_2)
end on

event open;call super::open;string syymm
String s_today

dw_Insert.Settransobject(sqlca)
dw_print.Settransobject(sqlca)
dw_1.Settransobject(sqlca)

dw_insert.ShareData(dw_print)

dw_1.Insertrow(0)
s_today = f_today()

dw_1.SetItem(1, "sicdat", s_today)   //생성일자  
dw_1.SetItem(1, "sisdat", s_today)   // 실사 시작일 
dw_1.SetItem(1, "siedat", s_today)   // 실사 종료일 
dw_1.SetItem(1, "s_iodate", s_today)  //입출고 일자




SELECT MAX("JUNPYO_CLOSING"."JPDAT")  
  INTO :SYYMM  
  FROM "JUNPYO_CLOSING"  
 WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
		 ( "JUNPYO_CLOSING"."JPGU" = 'C0' )   ;

dw_1.SetItem(1, "yymm", syymm)

dw_1.SetColumn("depot")
dw_1.SetFocus()
end event

event closequery;call super::closequery;
dw_insert.ShareDataoff()
end event

type dw_insert from w_inherite`dw_insert within w_mm03_00020
integer x = 50
integer y = 228
integer width = 4539
integer height = 2004
integer taborder = 10
string dataobject = "d_mm03_00020_b"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemerror;return 1
end event

type p_delrow from w_inherite`p_delrow within w_mm03_00020
boolean visible = false
integer x = 3739
integer y = 3144
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_mm03_00020
boolean visible = false
integer x = 3566
integer y = 3144
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_mm03_00020
boolean visible = false
integer x = 2871
integer y = 3144
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_mm03_00020
integer x = 3474
integer taborder = 30
string pointer = "C:\erpman\cur\create2.cur"
string picturename = "C:\erpman\image\생성_up.gif"
end type

event p_ins::ue_lbuttondown;PictureName = "C:\erpman\image\생성_dn.gif"
end event

event p_ins::ue_lbuttonup;PictureName = "C:\erpman\image\생성_up.gif"
end event

event p_ins::clicked;call super::clicked;String  s_date, s_depot, s_fdate, s_tdate, s_gub,  s_item, s_iodate
Int     iRtnValue
Long    get_count

IF dw_1.AcceptText() = -1 THEN RETURN 

s_date  = trim(dw_1.GetItemString(1, 'sicdat'))
s_depot = dw_1.GetItemString(1, 'depot')
s_fdate = trim(dw_1.GetItemString(1, 'sisdat'))
s_tdate = trim(dw_1.GetItemString(1, 'siedat'))
s_gub   = dw_1.GetItemString(1, 'gub')
s_item  = dw_1.GetItemString(1, 'gub2')
s_iodate = trim(dw_1.GetItemString(1, 's_iodate'))

if isnull(s_depot) or s_depot = "" then
	f_message_chk(30,'[창고]')
	dw_1.SetColumn('depot')
	dw_1.SetFocus()
	return
end if	


if isnull(s_date) or s_date = "" then
	f_message_chk(30,'[생성일자]')
	dw_1.SetColumn('sicdat')
	dw_1.SetFocus()
	return

end if	


SetPointer(HourGlass!)

IF Messagebox('저 장',  "주기실사 자료를 생성 하겠습니까?", Question!,YesNo!,2) = 2 THEN
	Return 
END IF
	
sle_msg.text = "주기 실사 자료 생성 中 ........."
//사업장, 창고, 생성일, 시작일, 종료일, 구분, 입/출고일자
//구분 ==>  1:주기실사품목에 현재고, 2:주기실사품목에 이월재고, 3:입출고일자 품목에 현재고
iRtnValue = SQLCA.ERP000000200(gs_sabu,s_depot,s_date, s_fdate, s_tdate, s_gub, s_iodate)

IF iRtnValue < 0 THEN
	f_message_chk(41,'')
	sle_msg.text = ""
	Return
ELSE
	Long ll_seq

	Select Max(siseq) Into :ll_seq
	  from ITMCYC
	 Where sabu = :gs_sabu 
	   and depot = :s_depot
		and sicdat = :s_date ;
		
	If sqlca.sqlcode <> 0 Then
		f_message_chk(41,'')
		Return
	Else
		dw_1.SetItem(1,"seq",ll_seq )
	End If
	
	sle_msg.text = "   " + String(iRtnValue) +"건에 자료가 생성되었습니다!!"
	
	If MessageBox('확인',String(iRtnValue) +"건에 주기실사 자료가 생성되었습니다!!" + &
	                  '~n~r~n~r주시실사 자료를 조회하시겠습니까? ' ,Question!, OKCancel!, 1) = 2 Then Return
	
	dw_insert.Retrieve(gs_sabu , s_depot , s_date , ll_seq  )
END IF

end event

type p_exit from w_inherite`p_exit within w_mm03_00020
integer taborder = 50
end type

event p_exit::clicked;close(parent)
end event

type p_can from w_inherite`p_can within w_mm03_00020
integer x = 4096
integer taborder = 0
end type

event p_can::clicked;call super::clicked;String syymm , s_today

dw_1.SetRedraw(False)
dw_1.Reset()
dw_1.Insertrow(0)
s_today = f_today()

dw_1.SetItem(1, "sicdat", s_today)   //생성일자  
dw_1.SetItem(1, "sisdat", s_today)   // 실사 시작일 
dw_1.SetItem(1, "siedat", s_today)   // 실사 종료일 
dw_1.SetItem(1, "s_iodate", s_today)  //입출고 일자

SELECT MAX("JUNPYO_CLOSING"."JPDAT")  
  INTO :SYYMM  
  FROM "JUNPYO_CLOSING"  
 WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
		 ( "JUNPYO_CLOSING"."JPGU" = 'C0' )   ;

dw_1.SetItem(1, "yymm", syymm)

dw_1.SetColumn("depot")
dw_1.SetFocus()

dw_1.SetRedraw(True)

dw_insert.Setredraw(False)
dw_insert.Reset()
dw_insert.Setredraw(True)
end event

type p_print from w_inherite`p_print within w_mm03_00020
integer x = 4270
integer taborder = 0
string picturename = "C:\erpman\image\미리보기_up.gif"
end type

event p_print::ue_lbuttondown;PictureName = "C:\erpman\image\미리보기_dn.gif"
end event

event p_print::ue_lbuttonup;PictureName = "C:\erpman\image\미리보기_up.gif"
end event

event p_print::clicked;call super::clicked;If dw_insert.Rowcount() < 1 Then Return
OpenWithParm(w_print_preview, dw_print)	
end event

type p_inq from w_inherite`p_inq within w_mm03_00020
integer x = 3749
integer taborder = 0
end type

event p_inq::clicked;call super::clicked;String  s_date, s_depot, s_fdate, s_tdate, s_gub,  s_item, s_iodate
Long    ll_seq_st 

IF dw_1.AcceptText() = -1 THEN RETURN 

s_date  = trim(dw_1.GetItemString(1, 'sicdat'))
s_depot = dw_1.GetItemString(1, 'depot')
s_fdate = trim(dw_1.GetItemString(1, 'sisdat'))
s_tdate = trim(dw_1.GetItemString(1, 'siedat'))
s_gub   = dw_1.GetItemString(1, 'gub')
s_item  = dw_1.GetItemString(1, 'gub2')
s_iodate = trim(dw_1.GetItemString(1, 's_iodate'))

ll_seq_st = dw_1.Object.seq[1]

if isnull(s_depot) or s_depot = "" then
	f_message_chk(30,'[창고]')
	dw_1.SetColumn('depot')
	dw_1.SetFocus()
	return
end if	


if isnull(s_date) or s_date = "" then
	f_message_chk(30,'[생성일자]')
	dw_1.SetColumn('sicdat')
	dw_1.SetFocus()
	return

end if	

if ll_seq_st < 1 then
	f_message_chk(30,'[실행차수]')
	dw_1.SetColumn('siseq')
	dw_1.SetFocus()
	return

end if

SetPointer(HourGlass!)

	
If dw_insert.Retrieve(gs_sabu , s_depot , s_date , ll_seq_st ) < 1 Then
	f_message_chk(50 , '')
End If


end event

type p_del from w_inherite`p_del within w_mm03_00020
integer x = 3922
integer taborder = 40
end type

event p_del::clicked;call super::clicked;String  sDepot, sSicdat, sCycsts
int     iseq
long    get_count 

IF dw_1.AcceptText() = -1 THEN RETURN 
IF dw_insert.AcceptText() = -1 THEN RETURN
If dw_insert.RowCount() < 1 THEN RETURN

sDepot 	= trim(dw_1.GetItemString(1, 'depot'))
if isnull(sDepot) or sDepot = "" then 
	f_message_chk(30,'[생성창고]')
	dw_1.SetColumn('depot')
	dw_1.SetFocus()
	return
end if	

sSicdat	= trim(dw_1.GetItemString(1, 'Sicdat'))
if isnull(sSicdat) or sSicdat = "" then
	f_message_chk(30,'[생성일자]')
	dw_1.SetColumn('Sicdat')
	dw_1.SetFocus()
	return
end if	

iSeq	= dw_1.GetItemNumber(1, 'seq')
if isnull(iSeq) or iSeq = 0 then
	f_message_chk(30,'[차수]')
	dw_1.SetColumn('Seq')
	dw_1.SetFocus()
	return
end if	

SELECT COUNT(*), MAX("CYCSTS")
  INTO :get_count, :sCycsts 
  FROM "ITMCYC"  
 WHERE ( "ITMCYC"."SABU"   = :gs_sabu ) AND  
       ( "ITMCYC"."DEPOT"  = :sdepot ) AND  
       ( "ITMCYC"."SICDAT" = :sSicdat ) AND  
       ( "ITMCYC"."SISEQ"  = :iseq ) ;

IF get_count <= 0 then 
	Messagebox('삭제확인', "삭제처리할 자료가 없습니다. 입력한 자료를 확인하세요!")
	dw_1.SetFocus()
	Return 
ELSEIF sCycsts = '2' THEN  
	Messagebox('삭제확인', "완료처리 되어서 삭제처리 할 수 없습니다!")
	dw_1.SetFocus()
	Return 
END IF

IF Messagebox('삭제확인', "주기실사 자료를 삭제 하시겠습니까?", Question!,YesNo!,2) = 2 THEN RETURN 
SetPointer(HourGlass!)

  DELETE FROM "ITMCYC"  
   WHERE ( "ITMCYC"."SABU"   = :gs_sabu ) AND  
         ( "ITMCYC"."DEPOT"  = :sdepot ) AND  
         ( "ITMCYC"."SICDAT" = :sSicdat ) AND  
         ( "ITMCYC"."SISEQ"  = :iseq )   ;

if sqlca.sqlcode < 0 then 
	rollback;	
	f_message_chk(31,'') 
	return
end if

commit;
dw_insert.SetRedraw(False)
dw_insert.Reset()
dw_insert.SetRedraw(True)
sle_msg.text = "주기실사 자료 삭제 완료"

MessageBox('확인','삭제를 완료 하였습니다.')

end event

type p_mod from w_inherite`p_mod within w_mm03_00020
boolean visible = false
integer x = 3913
integer y = 3144
integer taborder = 0
end type

type cb_exit from w_inherite`cb_exit within w_mm03_00020
integer x = 2446
integer y = 3172
end type

type cb_mod from w_inherite`cb_mod within w_mm03_00020
integer x = 649
integer y = 2612
end type

type cb_ins from w_inherite`cb_ins within w_mm03_00020
integer x = 1742
integer y = 3172
string text = "생성(&G)"
end type

type cb_del from w_inherite`cb_del within w_mm03_00020
integer x = 2094
integer y = 3172
end type

type cb_inq from w_inherite`cb_inq within w_mm03_00020
integer x = 1376
integer y = 2612
end type

type cb_print from w_inherite`cb_print within w_mm03_00020
integer y = 2612
end type

type st_1 from w_inherite`st_1 within w_mm03_00020
end type

type cb_can from w_inherite`cb_can within w_mm03_00020
integer x = 2112
integer y = 2612
end type

type cb_search from w_inherite`cb_search within w_mm03_00020
integer x = 2459
integer y = 2612
end type







type gb_button1 from w_inherite`gb_button1 within w_mm03_00020
end type

type gb_button2 from w_inherite`gb_button2 within w_mm03_00020
end type

type rr_1 from roundrectangle within w_mm03_00020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 24
integer width = 2702
integer height = 172
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_1 from datawindow within w_mm03_00020
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 82
integer y = 52
integer width = 2601
integer height = 124
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_mm03_00020_a"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;STRING s_fdate, s_tdate, snull

setnull(snull)

IF this.GetColumnName() ="sicdat" THEN
	s_fdate = trim(this.GetText())
	
	if s_fdate = "" or isnull(s_fdate) then return 

  	IF f_datechk(s_fdate) = -1	then
      f_message_chk(35, '[생성일자]')
		this.setitem(1, "sicdat", snull)
		return 1
	END IF

ELSEIF this.GetColumnName() ="sisdat" THEN
	s_fdate = trim(this.GetText())
	
	if s_fdate = "" or isnull(s_fdate) then return 

  	IF f_datechk(s_fdate) = -1	then
      f_message_chk(35, '[실사기간]')
		this.setitem(1, "sisdat", f_today())
		return 1
	END IF
	
	if s_fdate < f_today() then
		messagebox("확인", "실사기간은 현재일 보다 적을 수 없습니다!!")
		this.setitem(1, 'sisdat', f_today())
		return 1
   end if
ELSEIF this.GetColumnName() ="siedat" THEN
	s_tdate = trim(this.GetText())
	
	if s_tdate = "" or isnull(s_tdate) then return 

  	IF f_datechk(s_tdate) = -1	then
      f_message_chk(35, '[실사기간]')
		this.setitem(1, "siedat", snull)
		return 1
	END IF
	
	if s_tdate < f_today() then
		messagebox("확인", "실사기간은 현재일 보다 적을 수 없습니다!!")
		this.setitem(1, "siedat", snull)
		return 1
   end if
ELSEIF this.GetColumnName() ="s_iodate" THEN
	s_fdate = trim(this.GetText())
	
	if s_fdate = "" or isnull(s_fdate) then return 

  	IF f_datechk(s_fdate) = -1	then
      f_message_chk(35, '[입/출고 일자]')
		this.setitem(1, "s_iodate", snull)
		return 1
	END IF
ELSEIF this.GetColumnName() ="gub" THEN
	s_fdate = trim(this.GetText())
	
  	IF s_fdate = '2'	then
		this.setitem(1, "gub2", '1')
	END IF
END IF

end event

event itemerror;return 1
end event

event rbuttondown;setnull(gs_code)
setnull(gs_gubun)
setnull(gs_codename)

if this.GetColumnName() = 'seq' then
   gs_code = this.GetItemstring(1, 'depot')
	open(w_itmcyc_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"depot",  gs_gubun)
	this.SetItem(1,"sicdat", gs_code)
	this.SetItem(1,"seq",    integer(gs_codename))

end if	
end event

type dw_print from datawindow within w_mm03_00020
boolean visible = false
integer x = 2254
integer y = 420
integer width = 2327
integer height = 960
integer taborder = 20
boolean bringtotop = true
boolean titlebar = true
string title = "프린트"
string dataobject = "d_mm03_00020_b_p"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rr_2 from roundrectangle within w_mm03_00020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 216
integer width = 4576
integer height = 2048
integer cornerheight = 40
integer cornerwidth = 55
end type

