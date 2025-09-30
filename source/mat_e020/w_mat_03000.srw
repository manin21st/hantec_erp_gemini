$PBExportHeader$w_mat_03000.srw
$PBExportComments$** 주기 실사 생성
forward
global type w_mat_03000 from w_inherite
end type
type st_2 from statictext within w_mat_03000
end type
type st_3 from statictext within w_mat_03000
end type
type st_7 from statictext within w_mat_03000
end type
type st_8 from statictext within w_mat_03000
end type
type st_9 from statictext within w_mat_03000
end type
type st_10 from statictext within w_mat_03000
end type
type st_11 from statictext within w_mat_03000
end type
type dw_1 from datawindow within w_mat_03000
end type
type st_12 from statictext within w_mat_03000
end type
type st_13 from statictext within w_mat_03000
end type
type st_14 from statictext within w_mat_03000
end type
type rr_1 from roundrectangle within w_mat_03000
end type
type st_5 from statictext within w_mat_03000
end type
type st_15 from statictext within w_mat_03000
end type
type pb_2 from u_pb_cal within w_mat_03000
end type
type pb_3 from u_pb_cal within w_mat_03000
end type
type pb_4 from u_pb_cal within w_mat_03000
end type
type pb_5 from u_pb_cal within w_mat_03000
end type
type cbx_1 from checkbox within w_mat_03000
end type
type st_6 from statictext within w_mat_03000
end type
type st_16 from statictext within w_mat_03000
end type
type st_4 from statictext within w_mat_03000
end type
end forward

global type w_mat_03000 from w_inherite
string title = "주기 실사 생성"
st_2 st_2
st_3 st_3
st_7 st_7
st_8 st_8
st_9 st_9
st_10 st_10
st_11 st_11
dw_1 dw_1
st_12 st_12
st_13 st_13
st_14 st_14
rr_1 rr_1
st_5 st_5
st_15 st_15
pb_2 pb_2
pb_3 pb_3
pb_4 pb_4
pb_5 pb_5
cbx_1 cbx_1
st_6 st_6
st_16 st_16
st_4 st_4
end type
global w_mat_03000 w_mat_03000

on w_mat_03000.create
int iCurrent
call super::create
this.st_2=create st_2
this.st_3=create st_3
this.st_7=create st_7
this.st_8=create st_8
this.st_9=create st_9
this.st_10=create st_10
this.st_11=create st_11
this.dw_1=create dw_1
this.st_12=create st_12
this.st_13=create st_13
this.st_14=create st_14
this.rr_1=create rr_1
this.st_5=create st_5
this.st_15=create st_15
this.pb_2=create pb_2
this.pb_3=create pb_3
this.pb_4=create pb_4
this.pb_5=create pb_5
this.cbx_1=create cbx_1
this.st_6=create st_6
this.st_16=create st_16
this.st_4=create st_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.st_7
this.Control[iCurrent+4]=this.st_8
this.Control[iCurrent+5]=this.st_9
this.Control[iCurrent+6]=this.st_10
this.Control[iCurrent+7]=this.st_11
this.Control[iCurrent+8]=this.dw_1
this.Control[iCurrent+9]=this.st_12
this.Control[iCurrent+10]=this.st_13
this.Control[iCurrent+11]=this.st_14
this.Control[iCurrent+12]=this.rr_1
this.Control[iCurrent+13]=this.st_5
this.Control[iCurrent+14]=this.st_15
this.Control[iCurrent+15]=this.pb_2
this.Control[iCurrent+16]=this.pb_3
this.Control[iCurrent+17]=this.pb_4
this.Control[iCurrent+18]=this.pb_5
this.Control[iCurrent+19]=this.cbx_1
this.Control[iCurrent+20]=this.st_6
this.Control[iCurrent+21]=this.st_16
this.Control[iCurrent+22]=this.st_4
end on

on w_mat_03000.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_7)
destroy(this.st_8)
destroy(this.st_9)
destroy(this.st_10)
destroy(this.st_11)
destroy(this.dw_1)
destroy(this.st_12)
destroy(this.st_13)
destroy(this.st_14)
destroy(this.rr_1)
destroy(this.st_5)
destroy(this.st_15)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.pb_4)
destroy(this.pb_5)
destroy(this.cbx_1)
destroy(this.st_6)
destroy(this.st_16)
destroy(this.st_4)
end on

event open;call super::open;string syymm

dw_Insert.Settransobject(sqlca)
dw_Insert.Insertrow(0)
dw_1.Settransobject(sqlca)
dw_1.Insertrow(0)

dw_insert.SetItem(1, "sicdat", is_today)
dw_insert.SetItem(1, "sisdat", is_today)
dw_insert.SetItem(1, "s_iodate", is_today)

SELECT MAX("JUNPYO_CLOSING"."JPDAT")
  INTO :SYYMM
  FROM "JUNPYO_CLOSING"
 WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND
		 ( "JUNPYO_CLOSING"."JPGU" = 'C0' );

dw_insert.SetItem(1, "yymm", syymm)

dw_insert.SetColumn("depot")
dw_insert.SetFocus()

//사업장
//f_mod_saupj(dw_insert, 'depot' )
//f_mod_saupj(dw_1, 'depot' )
end event

event key;//
Choose Case key
	Case KeyF!
		p_ins.TriggerEvent(Clicked!)
//	Case KeyW!
//		p_print.TriggerEvent(Clicked!)
//	Case KeyQ!
//		p_inq.TriggerEvent(Clicked!)
//	Case KeyT!
//		p_ins.TriggerEvent(Clicked!)
//	Case KeyA!
//		p_addrow.TriggerEvent(Clicked!)
//	Case KeyE!
//		p_delrow.TriggerEvent(Clicked!)
//	Case KeyS!
//		p_mod.TriggerEvent(Clicked!)
	Case KeyD!
		p_del.TriggerEvent(Clicked!)
//	Case KeyC!
//		p_can.TriggerEvent(Clicked!)
	Case KeyX!
		p_exit.TriggerEvent(Clicked!)
End Choose
end event

type dw_insert from w_inherite`dw_insert within w_mat_03000
integer x = 581
integer y = 324
integer width = 2021
integer height = 552
integer taborder = 10
string dataobject = "d_mat_03000_a"
boolean border = false
end type

event dw_insert::itemchanged;STRING s_fdate, s_tdate, snull

setnull(snull)

If This.GetColumnName() = 'depot' Then
	/* 물류창고일 경우 주기실사 제외 - 2006.11.24 By sHIngOOn */
	String ls_jumae
	String ls_depot
	
	ls_depot = data
	
	SELECT JUMAECHUL
	  INTO :ls_jumae
	  FROM VNDMST
	 WHERE CVCOD = :ls_depot ;
	If ls_jumae = '4' Then
//		MessageBox('창고 확인', '물류창고일 경우 주기실사 작업을 실행 할 수 없습니다.')
//		This.SetItem(1, 'depot', '')
//		Return 
		this.object.plant.visible = 1
		this.object.t_plant.visible = 1
	Else
		this.object.plant.visible = 0
		this.object.t_plant.visible = 0
	End If
	/*------------------------------------------------------------------------------------*/
ElseIF this.GetColumnName() ="sicdat" THEN
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

event dw_insert::itemerror;return 1
end event

type p_delrow from w_inherite`p_delrow within w_mat_03000
boolean visible = false
integer x = 3739
integer y = 3144
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_mat_03000
boolean visible = false
integer x = 3566
integer y = 3144
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_mat_03000
boolean visible = false
integer x = 2871
integer y = 3144
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_mat_03000
integer x = 4096
integer taborder = 30
string pointer = "C:\erpman\cur\create2.cur"
string picturename = "C:\erpman\image\생성_up.gif"
end type

event p_ins::ue_lbuttondown;PictureName = "C:\erpman\image\생성_dn.gif"
end event

event p_ins::ue_lbuttonup;PictureName = "C:\erpman\image\생성_up.gif"
end event

event p_ins::clicked;call super::clicked;String  s_date, s_depot, s_fdate, s_tdate, s_gub,  s_item, s_iodate, s_plant, ls_jumae
Int     iRtnValue
Long    get_count

IF dw_insert.AcceptText() = -1 THEN RETURN 

s_date  = trim(dw_insert.GetItemString(1, 'sicdat'))
s_depot = dw_insert.GetItemString(1, 'depot')
s_fdate = trim(dw_insert.GetItemString(1, 'sisdat'))
s_tdate = trim(dw_insert.GetItemString(1, 'siedat'))
s_gub   = dw_insert.GetItemString(1, 'gub')
s_item  = dw_insert.GetItemString(1, 'gub2')
s_iodate = trim(dw_insert.GetItemString(1, 's_iodate'))
s_plant = trim(dw_insert.GetItemString(1, 'plant'))

if isnull(s_depot) or s_depot = "" then
	f_message_chk(30,'[창고]')
	dw_insert.SetColumn('depot')
	dw_insert.SetFocus()
	return
end if	

if s_item = "2" then
	if isnull(s_iodate) or s_iodate = "" then
		f_message_chk(30,'[입/출고일자]')
		dw_insert.SetColumn('s_iodate')
		dw_insert.SetFocus()
		return
	end if	
	s_gub = '3' //입출고일자로 품목을 생성시 생성구분을 변경시킨다.
end if	


/* 공장코드를 전체로 선택할 경우 STOCK 기준으로 재고자료 생성 - BY SHINGOON 2015.12.29 *****************************/
If s_plant <> '.' Then
	// 물류업체인 경우 공장코드 확인 - 2006.11.24 - 송병호 
	SELECT JUMAECHUL
	  INTO :ls_jumae
	  FROM VNDMST
	 WHERE CVCOD = :s_depot ;
	If ls_jumae = '4' Then
		//if isnull(s_plant) or s_plant = "" or s_plant = "." then
		if isnull(s_plant) or s_plant = "" then
			f_message_chk(30,'[공장코드]')
			dw_insert.SetColumn('plant')
			dw_insert.SetFocus()
			return
		end if	
		s_gub = 'X' // 생성구분 변경
		s_iodate = s_plant  // 공장코드를 저장 
	end if
End If
/*******************************************************************************************************************/


if isnull(s_date) or s_date = "" then
	f_message_chk(30,'[생성일자]')
	dw_insert.SetColumn('sicdat')
	dw_insert.SetFocus()
	return
else
	if s_gub = '2' then //생성구분이 이월재고인 경우

		SELECT COUNT(*)
		  INTO :get_count 
		  FROM "JUNPYO_CLOSING"  
		 WHERE ( "JUNPYO_CLOSING"."SABU"  = :gs_sabu ) AND  
				 ( "JUNPYO_CLOSING"."JPGU"  = 'C0' ) AND  
				 ( "JUNPYO_CLOSING"."JPDAT" = (SELECT YYYYMM FROM P4_CALENDAR
                                            WHERE CLDATE = :s_date ) )  ;
	
		if get_count < 1 then 
			messagebox('확 인', '마감된 자료가 없습니다. 생성일자를 확인하세요!')
			dw_insert.SetColumn('sicdat')
			dw_insert.SetFocus()
			return
		end if
	end if
end if	

if isnull(s_fdate) or s_fdate = "" then
	f_message_chk(30,'[실사기간 FROM]')
	dw_insert.SetColumn('sisdat')
	dw_insert.SetFocus()
	return
end if	

if isnull(s_tdate) or s_tdate = "" then
	f_message_chk(30,'[실사기간 TO]')
	dw_insert.SetColumn('siedat')
	dw_insert.SetFocus()
	return
end if	

if s_fdate > s_tdate then
	f_message_chk(34,'[실사기간]')
	dw_insert.Setcolumn('sisdat')
	dw_insert.SetFocus()
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
	sle_msg.text = "   " + String(iRtnValue) +"건에 자료가 생성되었습니다!!"
	messagebox('확 인',  String(iRtnValue) + '  건에 자료가 생성되었습니다!!')
END IF

end event

type p_exit from w_inherite`p_exit within w_mat_03000
integer taborder = 50
end type

event p_exit::clicked;close(parent)
end event

type p_can from w_inherite`p_can within w_mat_03000
boolean visible = false
integer x = 4261
integer y = 3144
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_mat_03000
boolean visible = false
integer x = 3045
integer y = 3144
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_mat_03000
boolean visible = false
integer x = 3218
integer y = 3144
integer taborder = 0
end type

type p_del from w_inherite`p_del within w_mat_03000
integer x = 4270
integer taborder = 40
end type

event p_del::clicked;call super::clicked;String  sDepot, sSicdat, sCycsts
int     iseq
long    get_count 

IF dw_1.AcceptText() = -1 THEN RETURN 
IF dw_insert.AcceptText() = -1 THEN RETURN 

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
sle_msg.text = "주기실사 자료 삭제 완료"

end event

type p_mod from w_inherite`p_mod within w_mat_03000
boolean visible = false
integer x = 3913
integer y = 3144
integer taborder = 0
end type

type cb_exit from w_inherite`cb_exit within w_mat_03000
integer x = 2446
integer y = 3172
end type

type cb_mod from w_inherite`cb_mod within w_mat_03000
integer x = 649
integer y = 2612
end type

type cb_ins from w_inherite`cb_ins within w_mat_03000
integer x = 1742
integer y = 3172
string text = "생성(&G)"
end type

type cb_del from w_inherite`cb_del within w_mat_03000
integer x = 2094
integer y = 3172
end type

type cb_inq from w_inherite`cb_inq within w_mat_03000
integer x = 1376
integer y = 2612
end type

type cb_print from w_inherite`cb_print within w_mat_03000
integer y = 2612
end type

type st_1 from w_inherite`st_1 within w_mat_03000
end type

type cb_can from w_inherite`cb_can within w_mat_03000
integer x = 2112
integer y = 2612
end type

type cb_search from w_inherite`cb_search within w_mat_03000
integer x = 2459
integer y = 2612
end type







type gb_button1 from w_inherite`gb_button1 within w_mat_03000
end type

type gb_button2 from w_inherite`gb_button2 within w_mat_03000
end type

type st_2 from statictext within w_mat_03000
integer x = 654
integer y = 1084
integer width = 2478
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 32106727
boolean enabled = false
string text = "* 주기 실사할 내역을 생성시킨다."
boolean focusrectangle = false
end type

type st_3 from statictext within w_mat_03000
integer x = 581
integer y = 1536
integer width = 2606
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
string text = "[재고기준이 이월재고인 경우]"
boolean focusrectangle = false
end type

type st_7 from statictext within w_mat_03000
integer x = 727
integer y = 1704
integer width = 2606
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388736
long backcolor = 32106727
boolean enabled = false
string text = "주의) 생성일자에 월 수불마감이 먼저 이루어져야 하고 완료처리시 수량차이가 있으면"
boolean focusrectangle = false
end type

type st_8 from statictext within w_mat_03000
integer x = 878
integer y = 1788
integer width = 2103
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388736
long backcolor = 32106727
boolean enabled = false
string text = " 수불마감 취소처리 --> 주기실사 완료처리 --> 수불마감처리를 해야한다."
boolean focusrectangle = false
end type

type st_9 from statictext within w_mat_03000
integer x = 727
integer y = 1620
integer width = 1938
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "생성일자 : 마감년월의 마지막일자 (자동입력)."
boolean focusrectangle = false
end type

type st_10 from statictext within w_mat_03000
integer x = 581
integer y = 264
integer width = 443
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "[ 생성조건 ]"
boolean focusrectangle = false
end type

type st_11 from statictext within w_mat_03000
integer x = 2606
integer y = 264
integer width = 443
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "[ 삭제조건 ]"
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_mat_03000
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 2615
integer y = 324
integer width = 1138
integer height = 352
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_mat_03000_b"
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
//	this.triggerevent(itemchanged!)
end if	
end event

type st_12 from statictext within w_mat_03000
integer x = 727
integer y = 1160
integer width = 1879
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "실사대상 : 생성일보다 전일."
boolean focusrectangle = false
end type

type st_13 from statictext within w_mat_03000
integer x = 581
integer y = 1008
integer width = 887
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "[품목기준이 주기실사인 경우] "
boolean focusrectangle = false
end type

type st_14 from statictext within w_mat_03000
integer x = 581
integer y = 1316
integer width = 946
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "[품목기준이 입/출고일자인 경우]"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_mat_03000
long linecolor = 8388608
integer linethickness = 1
long fillcolor = 32106727
integer x = 434
integer y = 192
integer width = 3447
integer height = 1704
integer cornerheight = 40
integer cornerwidth = 55
end type

type st_5 from statictext within w_mat_03000
integer x = 727
integer y = 1376
integer width = 2501
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "실사대상 : 입/출고일자에 입고 또는 출고가 일어난 품목"
boolean focusrectangle = false
end type

type st_15 from statictext within w_mat_03000
integer x = 727
integer y = 1432
integer width = 2286
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "실사대상 식 --> [  창고재고별 최종실사일 + 품목마스타 실사일수 <= 생성일자]"
boolean focusrectangle = false
end type

type pb_2 from u_pb_cal within w_mat_03000
integer x = 1298
integer y = 672
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_insert.SetColumn('sicdat')
IF IsNull(gs_code) THEN Return
ll_row = dw_insert.GetRow()
If ll_row < 1 Then Return
dw_insert.SetItem(ll_row, 'sicdat', gs_code)



end event

type pb_3 from u_pb_cal within w_mat_03000
integer x = 1298
integer y = 764
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_insert.SetColumn('sisdat')
IF IsNull(gs_code) THEN Return
ll_row = dw_insert.GetRow()
If ll_row < 1 Then Return
dw_insert.SetItem(ll_row, 'sisdat', gs_code)



end event

type pb_4 from u_pb_cal within w_mat_03000
integer x = 1833
integer y = 764
integer taborder = 80
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_insert.SetColumn('siedat')
IF IsNull(gs_code) THEN Return
ll_row = dw_insert.GetRow()
If ll_row < 1 Then Return
dw_insert.SetItem(ll_row, 'siedat', gs_code)



end event

type pb_5 from u_pb_cal within w_mat_03000
integer x = 3333
integer y = 440
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_1.SetColumn('sicdat')
IF IsNull(gs_code) THEN Return
ll_row = dw_1.GetRow()
If ll_row < 1 Then Return
dw_1.SetItem(ll_row, 'sicdat', gs_code)



end event

type cbx_1 from checkbox within w_mat_03000
boolean visible = false
integer x = 1024
integer y = 260
integer width = 571
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "전체 일괄생성"
end type

event clicked;If This.Checked = False Then Return

If dw_insert.AcceptText() = -1 Then Return

If MessageBox('주기실사 생성', '주기실사 자료를 생성 하시겠습니까?', Question!, YesNo!, 2) = 2 Then
	This.Checked = False
	Return
End If

sle_msg.Text = '주기실사 자료 생성 중........'

String ls_depot
String ls_date
String ls_fdate
String ls_tdate
String ls_gub
String ls_item
String ls_iodate
String ls_jumae
String ls_fac
Long   ll_rtn

ls_date   = Trim(dw_insert.GetItemString(1, 'sicdat'  ))
ls_fdate  = Trim(dw_insert.GetItemString(1, 'sisdat'  ))
ls_tdate  = Trim(dw_insert.GetItemString(1, 'siedat'  ))
ls_gub    = Trim(dw_insert.GetItemString(1, 'gub'     ))
ls_item   = Trim(dw_insert.GetItemString(1, 'gub2'    ))
ls_iodate = Trim(dw_insert.GetItemString(1, 's_iodate'))

If IsNull(ls_date) OR ls_date = '' Then
	f_message_chk(30, '[생성일자]')
	dw_insert.SetColumn('sicdat')
	dw_insert.SetFocus()
	Return
Else
	If ls_gub = '2' Then //생성구분이 이월재고인 경우
	
		Long get_count

		SELECT COUNT(*)
		  INTO :get_count 
		  FROM JUNPYO_CLOSING  
		 WHERE SABU  = :gs_sabu 
		   AND JPGU  = 'C0'
			AND JPDAT = ( SELECT YYYYMM FROM P4_CALENDAR
                        WHERE CLDATE = :ls_date )  ;
	
		If get_count < 1 Then 
			Messagebox('확 인', '마감된 자료가 없습니다. 생성일자를 확인하세요!')
			dw_insert.SetColumn('sicdat')
			dw_insert.SetFocus()
			Return
		End If
	End If
End If	
	
If ls_item = '2' Then
	If IsNull(ls_iodate) OR ls_iodate = '' Then
		f_message_chk(30, '[입/출고일자]')
		dw_insert.SetColumn('s_iodate')
		dw_insert.SetFocus()
		Return
	End If
	
	ls_gub = '3' //입출고일자로 품목을 생성 시 생성구분을 변경시킨다.
End If

Long   ll_chk, ll_chk2
ll_chk  = 0
ll_chk2 = 0

Long   ll_cnt, ll_cnt2
SELECT COUNT('X')
  INTO :ll_cnt
  FROM VNDMST
 WHERE CVGU     = '5'
   AND CVSTATUS = '0' ;

DECLARE Depot_cur CURSOR FOR
  SELECT CVCOD
    FROM VNDMST
   WHERE CVGU     = '5'
     AND CVSTATUS = '0' ;

OPEN Depot_cur ;

Do While True
	FETCH Depot_cur INTO :ls_depot ;
	If SQLCA.SQLCODE <> 0 Then Exit ;
	
	// 물류업체인 경우 공장코드 확인 - 2006.11.24 - 송병호 
	SELECT JUMAECHUL
	  INTO :ls_jumae
	  FROM VNDMST
	 WHERE CVCOD = :ls_depot ;
	If ls_jumae = '4' Then
		SELECT COUNT('X')
		  INTO :ll_cnt2
		  FROM REFFPF
		 WHERE RFCOD =  '2A'
		   AND RFGUB <> '00'
			AND RFNA5 IS NOT NULL ;
			
		DECLARE Fac_cur CURSOR FOR
			SELECT RFGUB
			  FROM REFFPF
			 WHERE RFCOD =  '2A'
			   AND RFGUB <> '00'
			   AND RFNA5 IS NOT NULL ;
		
		OPEN Fac_cur ;
		
		Do While True
			FETCH Fac_cur INTO :ls_fac ;
			If SQLCA.SQLCODE <> 0 Then Exit ;
			
			ls_gub    = 'X'     // 생성구분 변경
			ls_iodate = ls_fac  // 공장코드를 저장
			
			/* 사업장, 창고, 생성일, 시작일, 종료일, 구분, 입/출고일자(공장코드) */
			/* 구분 ==>  1:주기실사품목에 현재고, 2:주기실사품목에 이월재고, 3:입출고일자 품목에 현재고 */
			ll_rtn = SQLCA.ERP000000200(gs_sabu, ls_depot, ls_date, ls_fdate, ls_tdate, ls_gub, ls_iodate)
			If ll_rtn < 0 Then
				f_message_chk(41, '')
				sle_msg.Text = ls_depot + ' / ' + ls_iodate
				Return
			Else
				ll_chk++
				sle_msg.Text = '   ' + String(ll_rtn) + '건에 자료가 생성 되었습니다!!'
				MessageBox('확인-' + String(ll_cnt2) + '/' + String(ll_chk), ls_depot + ' / ' + ls_fac + '~r~n' + String(ll_rtn) + ' 건에 자료가 생성 되었습니다.')
			End If
//			ll_chk++
		Loop
		
		Close Fac_cur ;
	Else
		ls_gub    = Trim(dw_insert.GetItemString(1, 'gub'     ))
		ls_iodate = Trim(dw_insert.GetItemString(1, 's_iodate'))
		
		/* 사업장, 창고, 생성일, 시작일, 종료일, 구분, 입/출고일자(공장코드) */
		/* 구분 ==>  1:주기실사품목에 현재고, 2:주기실사품목에 이월재고, 3:입출고일자 품목에 현재고 */
		ll_rtn = SQLCA.ERP000000200(gs_sabu, ls_depot, ls_date, ls_fdate, ls_tdate, ls_gub, ls_iodate)
		If ll_rtn < 0 Then
			f_message_chk(41, '')
			sle_msg.Text = ls_depot + ' / ' + ls_iodate
			Return
		Else		
			ll_chk2++
			sle_msg.Text = '   ' + String(ll_rtn) + '건에 자료가 생성 되었습니다!!'
			MessageBox('확인-' + String(ll_cnt) + '/' + String(ll_chk2), ls_depot + '~r~n' + String(ll_rtn) + ' 건에 자료가 생성 되었습니다.')
		End If		
//		ll_chk2++
	End If
Loop

Close Depot_cur ;
end event

event constructor;//If gs_empno = '1296' Then
//	This.Visible = True
//Else
//	This.Visible = False
//End If
end event

type st_6 from statictext within w_mat_03000
boolean visible = false
integer x = 46
integer y = 60
integer width = 3611
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 32106727
string text = "공장코드에 ~'.~'이 들어오면 STOCK기준의 재고를 조정 그 외 공장코드가 입력되면 STOCK_MULU_HAN기준의 재고를 조정"
boolean focusrectangle = false
end type

type st_16 from statictext within w_mat_03000
boolean visible = false
integer x = 50
integer y = 124
integer width = 4329
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 32106727
string text = "물류창고이고 공장코드가 ~'.~' 이면 재고생성 기준이 STOCK이 되고 물류창고이고 공장코드가 지정되면(~'.~'이 아닌것) STOCK_MULU_HAN 기준의 재고를 생성"
boolean focusrectangle = false
end type

type st_4 from statictext within w_mat_03000
integer x = 727
integer y = 1216
integer width = 2889
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "단, 완료처리가 안된 자료가 있으면 실사대상이라도 자료생성 안됨."
boolean focusrectangle = false
end type

