$PBExportHeader$w_mat_03030.srw
$PBExportComments$** 수불 마감
forward
global type w_mat_03030 from w_inherite
end type
type st_41 from statictext within w_mat_03030
end type
type st_3 from statictext within w_mat_03030
end type
type st_22 from statictext within w_mat_03030
end type
type st_33 from statictext within w_mat_03030
end type
type st_44 from statictext within w_mat_03030
end type
type st_45 from statictext within w_mat_03030
end type
type st_34 from statictext within w_mat_03030
end type
type dw_1 from datawindow within w_mat_03030
end type
type st_42 from statictext within w_mat_03030
end type
type st_2 from statictext within w_mat_03030
end type
type st_49 from statictext within w_mat_03030
end type
type pb_1 from u_pb_cal within w_mat_03030
end type
type rr_1 from roundrectangle within w_mat_03030
end type
type rr_2 from roundrectangle within w_mat_03030
end type
end forward

global type w_mat_03030 from w_inherite
string title = "수불 마감"
st_41 st_41
st_3 st_3
st_22 st_22
st_33 st_33
st_44 st_44
st_45 st_45
st_34 st_34
dw_1 dw_1
st_42 st_42
st_2 st_2
st_49 st_49
pb_1 pb_1
rr_1 rr_1
rr_2 rr_2
end type
global w_mat_03030 w_mat_03030

forward prototypes
public function integer wf_check (string ar_yymm, integer ar_count)
end prototypes

public function integer wf_check (string ar_yymm, integer ar_count);//////////////////////////////////////////////////////////////
//                                                          //
//   마감년월에 마감처리를 할 수 있는지 여부를 체크한다.    //
//                                                          //
//////////////////////////////////////////////////////////////
Long  get_count
string sYymm

//계속생성 할 마감월을 계산
if ar_count > 1 then   
	sYymm = f_aftermonth(ar_yymm, ar_count)
else
	sYymm = ar_yymm
end if

//자재 출고 인터페이스 자료가 회계처리 되었으면 마감할 수 없음
  SELECT COUNT(*)  
    INTO :get_count
    FROM KIF02OT0  
   WHERE SABU = :gs_sabu   
     AND IO_DATE >= ( SELECT MIN(CLDATE) FROM P4_CALENDAR
                       WHERE YYYYMM = :ar_yymm )
     AND IO_DATE <= ( SELECT MAX(CLDATE) FROM P4_CALENDAR
                       WHERE YYYYMM = :sYymm )
     AND BAL_DATE is not null   ;

if get_count > 0 then 
	sle_msg.text = ""
	messagebox("마감 불가", "마감처리를 할 수 없습니다. 마감년월을 확인하세요!" + '~n~n' + &
	                        "자재 출고 인터페이스에  회계 전표처리 된 자료가 있습니다.")
   return -1
end if	

return 1
end function

on w_mat_03030.create
int iCurrent
call super::create
this.st_41=create st_41
this.st_3=create st_3
this.st_22=create st_22
this.st_33=create st_33
this.st_44=create st_44
this.st_45=create st_45
this.st_34=create st_34
this.dw_1=create dw_1
this.st_42=create st_42
this.st_2=create st_2
this.st_49=create st_49
this.pb_1=create pb_1
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_41
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.st_22
this.Control[iCurrent+4]=this.st_33
this.Control[iCurrent+5]=this.st_44
this.Control[iCurrent+6]=this.st_45
this.Control[iCurrent+7]=this.st_34
this.Control[iCurrent+8]=this.dw_1
this.Control[iCurrent+9]=this.st_42
this.Control[iCurrent+10]=this.st_2
this.Control[iCurrent+11]=this.st_49
this.Control[iCurrent+12]=this.pb_1
this.Control[iCurrent+13]=this.rr_1
this.Control[iCurrent+14]=this.rr_2
end on

on w_mat_03030.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_41)
destroy(this.st_3)
destroy(this.st_22)
destroy(this.st_33)
destroy(this.st_44)
destroy(this.st_45)
destroy(this.st_34)
destroy(this.dw_1)
destroy(this.st_42)
destroy(this.st_2)
destroy(this.st_49)
destroy(this.pb_1)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_Insert.Settransobject(sqlca)
dw_1.Settransobject(sqlca)
dw_1.Retrieve()
dw_Insert.Insertrow(0)

// 입출고이력 중에서 마감월 이전 수정내역을 조회하여 일자를 출력한다.
// 마감월 이전 전표중에서(수불승인일자 기준) 입력일자 또는 수정일자가 
// 마감월포함 이후일자로 되어있는 전표의 수불승인일자를 검색하여 출력하고
// 해당 수불승인일자부터 마감을 시작한다.
String sLdate, sLyymm

Setnull(sLdate)
Select last_jnpo_date into :sLdate
  from imhist_last_modify
 where sabu = :gs_sabu;

SELECT MAX("JUNPYO_CLOSING"."JPDAT")  
  INTO :sLyymm
  FROM "JUNPYO_CLOSING"  
 WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
       ( "JUNPYO_CLOSING"."JPGU" = 'C0' )   ;
 
dw_insert.setitem(1, "syymm", left(f_today(), 6))
dw_insert.setitem(1, "ldate", sLdate)
dw_insert.setitem(1, "last_mayymm", sLyymm)

dw_insert.SetColumn("syymm")
dw_insert.SetFocus()
end event

type dw_insert from w_inherite`dw_insert within w_mat_03030
integer x = 1083
integer y = 232
integer width = 2542
integer height = 152
string dataobject = "d_mat_03030_a"
boolean border = false
end type

event dw_insert::itemchanged;STRING s_date, snull

setnull(snull)

IF this.GetColumnName() ="syymm" THEN
	s_date = trim(this.GetText())
	
	if s_date = "" or isnull(s_date) then return 

  	IF f_datechk(s_date + '01') = -1	then
      f_message_chk(35, '[기준년월]')
		this.setitem(1, "syymm", left(f_today(), 6))
		return 1
	END IF
END IF
end event

event dw_insert::itemerror;return 1
end event

type p_delrow from w_inherite`p_delrow within w_mat_03030
boolean visible = false
integer x = 1490
integer y = 2396
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_mat_03030
boolean visible = false
integer x = 1317
integer y = 2396
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_mat_03030
boolean visible = false
integer x = 622
integer y = 2396
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_mat_03030
integer x = 3072
integer y = 72
string pointer = "C:\erpman\cur\create2.cur"
string picturename = "C:\erpman\image\생성_up.gif"
end type

event p_ins::clicked;call super::clicked;String  s_yymm, s_yymm2, serror, s_iwnm, s_maxym, s_maxym2
long    get_count, i
int     iReturn 

IF dw_insert.AcceptText() = -1 THEN RETURN 

s_yymm 	= trim(dw_insert.GetItemString(1, 'syymm'))

if isnull(s_yymm) or s_yymm = "" then
	f_message_chk(30,'[기준년월]')
	dw_insert.SetColumn('syymm')
	dw_insert.SetFocus()
	return
else
	s_yymm2 = f_aftermonth(s_yymm, 1)
end if	

if s_yymm < '200701' then
	Messagebox('확인',"2007년 이전 수불마감 작업은 불가합니다!!!")
	dw_insert.SetColumn('syymm')
	dw_insert.SetFocus()
	return
end if	


IF Messagebox('수불마감',"수불마감처리 하시겠습니까?", Question!,YesNo!,2) = 2 THEN RETURN 
SetPointer(HourGlass!)

SELECT "IOMATRIX"."IOGBN"  
  INTO :s_iwnm
  FROM "IOMATRIX"  
 WHERE ( "IOMATRIX"."SABU" = :gs_sabu ) AND ( "IOMATRIX"."TRANSGUB" = 'Y' )   ;

if sqlca.sqlcode <> 0 then 
	f_message_chk(41,'[ 이월구분에 대한 수불코드 ]')
	return
end if	

/* 수불마감에 대한 최초 전표 */
  SELECT MAX(JPDAT)  
    INTO :s_maxym
    FROM JUNPYO_CLOSING  
   WHERE SABU = :gs_sabu AND JPGU = 'C0' ;

if s_maxym = "" or isnull(s_maxym) then 
   get_count = 1
else
   s_maxym2 = f_aftermonth(s_maxym,1)
   if s_maxym2 < s_yymm then  //마감월이 이전 마감월 + 1보다 크면 error 
   	f_message_chk(111,'[기준년월]')
		dw_insert.SetColumn('syymm')
		dw_insert.SetFocus()
		return
	elseif s_maxym = s_yymm then 
		IF Messagebox('수불마감',"생성하려는 이월 자료가 이미 존재합니다." +"~n~n" +&
									 "기존자료를 삭제하시고 새로 생성 하시겠습니까?", +&
									  Question!,YesNo!,2) = 2 THEN RETURN 
      get_count = 1
	elseif s_maxym > s_yymm then 
		IF Messagebox('수불마감',"생성하려는 이월 자료가 이미 존재합니다." +"~n~n" +&
              		 "이전자료를 새로 수불마감하시면 기준년월 이후 자료도 새로 생성합니다." +"~n" +&
									 "기존자료를 삭제하시고 새로 생성 하시겠습니까?", +&
     								  Question!,YesNo!,2) = 2 THEN RETURN 
		get_count = f_month_between(s_maxym, s_yymm) + 1
  else    
      get_count = 1
  end if
end if	

sle_msg.text = "수불자료 마감가능 여부 체크 中 .........!!"
/* get_count는 마감해야할 개월수를 말한다 */
if wf_check(s_yymm, get_count) = -1 then 
   sle_msg.text = ""
	return 
end if

sle_msg.text = "수불자료 마감 中 .........!!"

/* 수불마감 전표이력 삭제 */
DELETE FROM JUNPYO_CLOSING  
WHERE SABU   = :gs_sabu AND JPGU = 'C0' AND
		JPDAT >= :s_yymm   AND JPDAT <= :s_maxym  ;
		
/* 이월자료 삭제 */
FOR i = 1 TO get_count
   if i > 1 then   
      s_yymm  = f_aftermonth(s_yymm,  1)
      s_yymm2 = f_aftermonth(s_yymm2, 1)
      sle_msg.text = left(s_yymm,4) + '년 ' + mid(s_yymm,5,2) + "월 수불자료 마감 中 .........!!"
   end if
  
  /* 자사창고 - 다음달 이월자료 삭제 */
  	DELETE FROM STOCKMONTH  
   	  WHERE ( STOCK_YYMM = :s_yymm2 ) AND 
         ( IOGBN  = :s_iwnm) ;
	if sqlca.sqlcode <> 0 then
		rollback;
		messagebox("확인", "[자사창고 - 다음달 이월자료 삭제] 가 에러가 발생했습니다." )
		return 0
	end if
	COMMIT;

  /* 자사창고 - 다음달 이월자료 삭제 */
  	DELETE FROM STOCKMONTH_LOT
   	  WHERE ( STOCK_YYMM = :s_yymm2 ) AND 
         ( IOGBN  = :s_iwnm) ;
	if sqlca.sqlcode <> 0 then
		rollback;
		messagebox("확인", "[자사창고 - 다음달 이월자료 삭제] 가 에러가 발생했습니다." )
		return 0
	end if
	COMMIT;
	
  /* 외주처   - 다음달 이월자료 삭제 */
	Update stockmonth_vendor
		 set iwol_stock_qty = 0
	 where base_yymm 	= :s_yymm2;

	if sqlca.sqlcode <> 0 then
		rollback;
		messagebox("확인", "[외주처   - 다음달 이월자료 삭제] 가 에러가 발생했습니다." )
		return 0
	end if
	COMMIT;
	
	//에러 30자리 까지 
	serror = '123456789012345678901234567890'
	
   sqlca.erp000001000(gs_sabu, s_yymm, s_yymm2, s_iwnm, serror);
	If serror <> 'N' then
		sle_msg.text = ''
		rollback;
		f_message_chk(89,'[' + serror + ']') 
		return
	end if
	
	iReturn = sqlca.erp000000905(gs_sabu, s_yymm);
	If ireturn < 0  then
		sle_msg.text = ''
		rollback;	
		f_message_chk(89,'[자재출고 인터페이스 생성] [ ' + string(ireturn) + ' ]') 
		return
	end if
	
NEXT

Commit;
sle_msg.text = "수불마감 처리되었습니다.!!"


end event

event p_ins::ue_lbuttondown;PictureName = "C:\erpman\image\생성_dn.gif"
end event

event p_ins::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\생성_up.gif"
end event

type p_exit from w_inherite`p_exit within w_mat_03030
integer x = 3429
integer y = 72
end type

type p_can from w_inherite`p_can within w_mat_03030
boolean visible = false
integer x = 2011
integer y = 2396
boolean enabled = false
end type

type p_print from w_inherite`p_print within w_mat_03030
boolean visible = false
integer x = 795
integer y = 2396
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_mat_03030
boolean visible = false
integer x = 969
integer y = 2396
boolean enabled = false
end type

type p_del from w_inherite`p_del within w_mat_03030
integer x = 3250
integer y = 72
end type

event p_del::clicked;call super::clicked;String  s_yymm, serror

IF dw_insert.AcceptText() = -1 THEN RETURN 

s_yymm 	= trim(dw_insert.GetItemString(1, 'syymm'))

if isnull(s_yymm) or s_yymm = "" then
	f_message_chk(30,'[기준년월]')
	dw_insert.SetColumn('syymm')
	dw_insert.SetFocus()
	return
end if

if s_yymm < '200701' then
	Messagebox('확인',"2007년 이전 수불마감 삭제작업은 불가합니다!!!")
	dw_insert.SetColumn('syymm')
	dw_insert.SetFocus()
	return
end if	

//전표처리 된 내역있는지 여부 체크하여 마감 취소할 수 없도록 체크

IF Messagebox('삭제확인',"최종 마감년월보다 이전년월을 입력시 기준년월부터 최종마감 이력자료를 삭제합니다."+&
              '~n~n' +  "마감이력을 삭제 하시겠습니까?", Question!,YesNo!,2) = 2 THEN RETURN 
SetPointer(HourGlass!)

// 선입선출 History삭제
sError = 'X'
sqlca.erp000001070(gs_sabu, s_yymm, serror);
If serror <> 'N' then
	sle_msg.text = ''
	rollback;
	f_message_chk(89,'[' + serror + ']') 
	return
end if

/* 수불마감 전표이력 삭제 */
DELETE FROM JUNPYO_CLOSING  
WHERE SABU   = :gs_sabu AND JPGU = 'C0' AND
      JPDAT >= :s_yymm   ;
		
if sqlca.sqlcode < 0 then 
	rollback;	
	f_message_chk(31,'') 
	return
end if

commit;
sle_msg.text = "마감이력 삭제 완료"

end event

type p_mod from w_inherite`p_mod within w_mat_03030
boolean visible = false
integer x = 1664
integer y = 2396
boolean enabled = false
end type

type cb_exit from w_inherite`cb_exit within w_mat_03030
end type

type cb_mod from w_inherite`cb_mod within w_mat_03030
integer x = 649
integer y = 2612
end type

type cb_ins from w_inherite`cb_ins within w_mat_03030
end type

type cb_del from w_inherite`cb_del within w_mat_03030
end type

type cb_inq from w_inherite`cb_inq within w_mat_03030
integer x = 1376
integer y = 2612
end type

type cb_print from w_inherite`cb_print within w_mat_03030
integer y = 2612
end type

type st_1 from w_inherite`st_1 within w_mat_03030
end type

type cb_can from w_inherite`cb_can within w_mat_03030
integer x = 2112
integer y = 2612
end type

type cb_search from w_inherite`cb_search within w_mat_03030
integer x = 2459
integer y = 2612
end type





type gb_10 from w_inherite`gb_10 within w_mat_03030
integer x = 18
end type

type gb_button1 from w_inherite`gb_button1 within w_mat_03030
end type

type gb_button2 from w_inherite`gb_button2 within w_mat_03030
end type

type st_41 from statictext within w_mat_03030
integer x = 1015
integer y = 1636
integer width = 1819
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
boolean enabled = false
string text = "* 마감이력삭제는 기준년월 이후에 마감이력을 모두 삭제한다."
boolean focusrectangle = false
end type

type st_3 from statictext within w_mat_03030
integer x = 1074
integer y = 1708
integer width = 2478
integer height = 68
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "Ex) 기준년월 1999년 11월을 입력시 11월 이력 포함하여 이후에 자료를 모두 삭제한다."
boolean focusrectangle = false
end type

type st_22 from statictext within w_mat_03030
integer x = 1015
integer y = 1444
integer width = 1490
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
boolean enabled = false
string text = "* 수불마감생성은 기준년월의 자재 수불을 마감하여 "
boolean focusrectangle = false
end type

type st_33 from statictext within w_mat_03030
integer x = 2491
integer y = 1444
integer width = 261
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 33027312
boolean enabled = false
string text = "이월재고"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_44 from statictext within w_mat_03030
integer x = 2757
integer y = 1444
integer width = 677
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
boolean enabled = false
string text = "를 생성시킨다."
boolean focusrectangle = false
end type

type st_45 from statictext within w_mat_03030
integer x = 1015
integer y = 1828
integer width = 2327
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
boolean enabled = false
string text = "* 수불마감 자료 생성 후 마감단가로 자재 출고 Interface 자료도 같이 생성한다."
boolean focusrectangle = false
end type

type st_34 from statictext within w_mat_03030
integer x = 1074
integer y = 1516
integer width = 2478
integer height = 68
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "Ex) 기준년월 2000.06 입력시 2000.07 에 이월자료 생성"
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_mat_03030
integer x = 1403
integer y = 428
integer width = 1938
integer height = 844
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_mat_03030_b"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type st_42 from statictext within w_mat_03030
integer x = 1015
integer y = 1952
integer width = 2327
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
boolean enabled = false
string text = "*  단가생성구분은 수량이 있고 재고단가가 0 인 경우 적용된다. "
boolean focusrectangle = false
end type

type st_2 from statictext within w_mat_03030
integer x = 1111
integer y = 2028
integer width = 2089
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "단, 원가수불인 경우 적용안함(원가수불은 마감시 이월수량만 생성하므로)"
boolean focusrectangle = false
end type

type st_49 from statictext within w_mat_03030
integer x = 1015
integer y = 2140
integer width = 2734
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
boolean enabled = false
string text = "*  자재출고인터페이스 자료 생성은 품목구분이 참조코드 ~'05~'에서 처리구분이 1 인 자료만 생성"
boolean focusrectangle = false
end type

type pb_1 from u_pb_cal within w_mat_03030
boolean visible = false
integer x = 3451
integer y = 256
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_insert.SetColumn('ldate')
IF IsNull(gs_code) THEN Return
ll_row = dw_insert.GetRow()
If ll_row < 1 Then Return
dw_insert.SetItem(ll_row, 'ldate', gs_code)



end event

type rr_1 from roundrectangle within w_mat_03030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1106
integer y = 412
integer width = 2514
integer height = 896
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_mat_03030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 864
integer y = 1360
integer width = 2999
integer height = 896
integer cornerheight = 40
integer cornerwidth = 55
end type

