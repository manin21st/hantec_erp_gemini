$PBExportHeader$w_imt_03050.srw
$PBExportComments$B/L, 인수증 마감
forward
global type w_imt_03050 from w_inherite
end type
type rr_3 from roundrectangle within w_imt_03050
end type
type rr_4 from roundrectangle within w_imt_03050
end type
type dw_1 from datawindow within w_imt_03050
end type
type rb_1 from radiobutton within w_imt_03050
end type
type rb_2 from radiobutton within w_imt_03050
end type
type st_11 from statictext within w_imt_03050
end type
type st_2 from statictext within w_imt_03050
end type
type pb_2 from u_pb_cal within w_imt_03050
end type
type pb_1 from u_pb_cal within w_imt_03050
end type
type rr_2 from roundrectangle within w_imt_03050
end type
type rr_33 from roundrectangle within w_imt_03050
end type
end forward

global type w_imt_03050 from w_inherite
boolean visible = false
string title = "B/L, 인수증 마감"
rr_3 rr_3
rr_4 rr_4
dw_1 dw_1
rb_1 rb_1
rb_2 rb_2
st_11 st_11
st_2 st_2
pb_2 pb_2
pb_1 pb_1
rr_2 rr_2
rr_33 rr_33
end type
global w_imt_03050 w_imt_03050

type variables
char 		  ic_status
String     is_expgub          //수입비용 적용구분
string     is_useyn      //외자인터페이스 생성 적용구분
end variables

on w_imt_03050.create
int iCurrent
call super::create
this.rr_3=create rr_3
this.rr_4=create rr_4
this.dw_1=create dw_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.st_11=create st_11
this.st_2=create st_2
this.pb_2=create pb_2
this.pb_1=create pb_1
this.rr_2=create rr_2
this.rr_33=create rr_33
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_3
this.Control[iCurrent+2]=this.rr_4
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.rb_1
this.Control[iCurrent+5]=this.rb_2
this.Control[iCurrent+6]=this.st_11
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.pb_2
this.Control[iCurrent+9]=this.pb_1
this.Control[iCurrent+10]=this.rr_2
this.Control[iCurrent+11]=this.rr_33
end on

on w_imt_03050.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_3)
destroy(this.rr_4)
destroy(this.dw_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.st_11)
destroy(this.st_2)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.rr_2)
destroy(this.rr_33)
end on

event open;call super::open;//외자인테페이스 생성구분(1:l/c완료처리,2:bl마감시)
SELECT DATANAME
  INTO :is_useyn
  FROM SYSCNFG  
 WHERE SYSGU = 'Y'  AND  SERIAL = 32  AND  LINENO = '1'   ;

IF is_useyn = '' or isnull(is_useyn) or sqlca.sqlcode <> 0 then is_useyn = '1' 

///////////////////////////////////////////////////////////////////////////////////
// datawindow initial value
dw_1.settransobject(sqlca)
dw_1.insertrow(0)

//수입비용 적용구분을 구한다.
SELECT "SYSCNFG"."DATANAME"  
  INTO :is_expgub  
  FROM "SYSCNFG"  
 WHERE ( "SYSCNFG"."SYSGU" = 'Y' ) AND  ( "SYSCNFG"."SERIAL" = 16 ) AND  
		 ( "SYSCNFG"."LINENO" = '1' )   ;

IF is_expgub = '' or isnull(is_expgub) or sqlca.sqlcode <> 0 then is_expgub = '1'

rb_1.checked = true
rb_1.TriggerEvent("clicked")


end event

type dw_insert from w_inherite`dw_insert within w_imt_03050
integer x = 27
integer y = 200
integer width = 4571
integer height = 2120
integer taborder = 30
string dataobject = "d_imt_03050"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemerror;call super::itemerror;RETURN 1
	
	
end event

event dw_insert::buttonclicked;call super::buttonclicked;IF row < 1 THEN RETURN 

gs_code = this.getitemstring(row, 'poblno')

open(w_imt_03050_popup)
end event

event dw_insert::itemchanged;call super::itemchanged;string sCode, sBlno, sLcno
dec{3} dIoqty, dBlqty 
long   i, get_count

IF this.GetColumnName() = 'magyeo' THEN

	sCode = this.GetText()
	
	sBlno = this.getitemstring(row, 'poblno')
//	sLcno = this.getitemstring(row, 'polcbl_polcno')
	
	if ic_status = '1' AND scode = 'Y'  then 
		
		SELECT NVL(SUM(TRUNC(DECODE(NVL(B.CNVFAT,0), 0, A.BLQTY, 1, A.BLQTY, 
					  DECODE(B.CNVART, '*', A.BLQTY / B.CNVFAT, A.BLQTY * B.CNVFAT )), 3)),0)  
		  INTO :dBlqty  
		  FROM POLCBL A,  POBLKT B 
		 WHERE A.SABU    = :gs_sabu	AND
				 A.POBLNO  = :sBlno 		AND
				 A.SABU    = B.SABU  	AND
				 A.BALJPNO = B.BALJPNO	AND
				 A.BALSEQ  = B.BALSEQ ;
				 
		SELECT NVL(SUM(IOQTY),0)
		  INTO :dIoqty  
		  FROM IMHIST A, IOMATRIX B  
		 WHERE A.SABU   = B.SABU
		   AND A.IOGBN  = B.IOGBN 
			AND A.SABU   = :gs_sabu 
			AND A.POBLNO = :sBlno   
			AND A.POLCNO IS NOT NULL
		   AND B.IOSP   = 'I' 
 		   AND B.MAIPGU = 'Y' ;
				 
		if dBlqty <> dIoqty then 
			messagebox("확 인", "마감처리 할 수 없는 자료입니다." +"~n~n"+ &
        "B/L 수량 " + string(dBlqty, "#,##0") + " / 입고승인수량 " + string(dIoqty, "#,##0"))
			return 1
		end if	
   ELSEIF ic_Status = '2' AND sCode = 'N' and is_useyn = '2' THEN 
		
		SELECT COUNT(*)
		  INTO :get_count
		  FROM KIF16OT0 
		 WHERE SABU   = :gs_sabu 
			AND POBLNO = :sBlno
			AND BAL_DATE IS NOT NULL ;
			
		if get_count > 0 then 
			messagebox("확 인", "회계에서 발행처리되어서 취소처리를 할 수 없습니다.")
			this.setitem(row, 'magyeo', 'Y')
			return 1
		end if
	END IF 
END IF

end event

event dw_insert::editchanged;return 1
end event

type p_delrow from w_inherite`p_delrow within w_imt_03050
boolean visible = false
integer x = 4850
integer y = 12
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_imt_03050
boolean visible = false
integer x = 4827
integer y = 76
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_imt_03050
boolean visible = false
integer x = 4795
integer y = 160
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_imt_03050
boolean visible = false
integer x = 4754
integer y = 220
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_imt_03050
integer taborder = 60
end type

type p_can from w_inherite`p_can within w_imt_03050
integer taborder = 50
end type

event p_can::clicked;call super::clicked;dw_insert.Reset()

rb_1.checked = true
rb_1.TriggerEvent("clicked")


end event

type p_print from w_inherite`p_print within w_imt_03050
boolean visible = false
integer x = 4809
integer y = 124
integer height = 140
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_imt_03050
integer x = 3749
integer taborder = 20
end type

event clicked;call super::clicked;IF dw_1.accepttext() = -1			THEN 	RETURN 

string	sf_Date, st_date, slcno, ssaupj
Long     k
Integer  iseq, get_seq

sf_Date =  trim(dw_1.getitemstring(1, 'fr_date'))
st_Date =  trim(dw_1.getitemstring(1, 'to_date'))
//ssaupj  =  dw_1.getitemstring(1, 'saupj')

dw_insert.setredraw(false)

// 미마감자료
IF ic_Status = '1'	THEN

	IF	dw_insert.Retrieve(gs_sabu) <	1		THEN
		f_message_chk(50, '[미마감 자료]')
		dw_insert.SetFocus()
      dw_insert.setredraw(true)
		RETURN
   ELSE
		dw_insert.SetFocus()
   END IF

ELSE

	IF isnull(sf_Date) or sf_Date = "" 	THEN
		sf_date = '10000101'
	END IF
	IF isnull(st_Date) or st_Date = "" 	THEN
		st_date = '99999999'
	END IF

	IF	dw_insert.Retrieve(gs_sabu, sf_Date, st_date) <	1		THEN
		f_message_chk(50, '[마감 자료]')
		dw_1.SetColumn('fr_date')
		dw_1.SetFocus()
      dw_insert.setredraw(true)
		RETURN
   END IF

END IF
	
dw_insert.setredraw(true)

end event

type p_del from w_inherite`p_del within w_imt_03050
integer taborder = 0
end type

event p_del::clicked;call super::clicked;SetPointer(HourGlass!)

IF dw_1.accepttext() = -1			THEN 	RETURN 
IF dw_insert.accepttext() = -1			THEN 	RETURN 
IF dw_insert.RowCount() < 1			THEN 	RETURN 

long		lRow, get_count
string	sf_Date, sBlno, sLcno, sGubun, smsg, smadate, sjpno, snull
String   s_RateGub       //산출율에 의해 계산시 환율 사용여부(1:일일,2:예측)            
Integer  iMaxOrderNo, iReturn, icount 

setnull(snull)
			
sf_Date =  trim(dw_1.getitemstring(1, 'fr_date'))

IF Messagebox('확인', '마감취소 하시겠습니까?',Question!,YesNo!,1) <> 1 then return 

w_mdi_frame.sle_msg.text = '마감자료 삭제중....'

FOR  lRow = 1	TO		dw_insert.RowCount()

	sGubun  = dw_insert.GetItemString(lRow, "magyeo")
	IF sGubun = 'N'	THEN
		sBlno	  = dw_insert.GetItemString(lRow, "poblno")
//			sLcno   = dw_insert.GetItemString(lRow, "polcno")
		sLcno   = 'None'  //l/c번호는 처리하지 않고 b/l 번호로 일괄 처리 함 
		smadate = dw_insert.GetItemString(lRow, "magdat")
		
		ireturn = SQLCA.ERP000000170(gs_sabu, smadate, sblno, slcno ) 
		IF ireturn  < 1	THEN
			ROLLBACK;
			w_mdi_frame.sle_msg.text  = ''
			if ireturn = -8 then 
				MessageBox("마감취소실패", "수입단가산출 전표가 수불마감처리가 된 자료인지를 확인하세요!.", StopSign!)
				return 
			end if
			MessageBox("마감취소실패", string(iReturn) + " 마감취소를 실패하였습니다.", StopSign!)
			Return 
		END IF

		dw_insert.setitem(lrow, "magdat", snull)
		icount ++
	END IF

NEXT

IF icount < 1 then 
	w_mdi_frame.sle_msg.text  = ''
	Messagebox('확 인', '자료를 선택 후 처리 하십시요...') 
	return 
END IF

IF dw_insert.Update() > 0		THEN
	COMMIT;
	w_mdi_frame.sle_msg.text  = ''
	MessageBox("확인", "마감취소 완료")
ELSE
	ROLLBACK;
	f_Rollback()
	return 
END IF

p_can.TriggerEvent("clicked")	

SetPointer(Arrow!)

end event

type p_mod from w_inherite`p_mod within w_imt_03050
integer taborder = 0
string pointer = "C:\erpman\cur\point.cur"
string picturename = "C:\erpman\image\마감_up.gif"
end type

event p_mod::clicked;call super::clicked;SetPointer(HourGlass!)

IF dw_1.accepttext() = -1			THEN 	RETURN 
IF dw_insert.accepttext() = -1			THEN 	RETURN 
IF dw_insert.RowCount() < 1			THEN 	RETURN 

long		lRow, get_count
string	sf_Date, sBlno, sLcno, sGubun, smsg, smadate, sjpno, snull
String   s_RateGub       //산출율에 의해 계산시 환율 사용여부(1:일일,2:예측)            
Integer  iMaxOrderNo, iReturn, icount 

setnull(snull)
			
sf_Date =  trim(dw_1.getitemstring(1, 'fr_date'))

IF isnull(sf_Date) or sf_Date = "" 	THEN
	f_message_chk(30,'[마감일자]')
	dw_insert.SetFocus()
	RETURN
END IF

IF is_expgub = '1' then 
	smsg = '수입비용으로 마감 처리'
ELSE
	smsg = '수입비용 산출율로 마감 처리'
END IF	


IF Messagebox('마 감', smsg + ' 하시겠습니까?',Question!,YesNo!,1) <> 1 then return 

w_mdi_frame.sle_msg.text = smsg + ' 中 ....'

iMaxOrderNo = sqlca.fun_junpyo(gs_sabu, sf_Date, 'C0')
IF iMaxOrderNo <= 0 THEN
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(51,'')
	ROLLBACK;
END IF

sjpno = sf_Date + String(iMaxOrderNo,'0000')

Commit;
IF is_expgub = '2' then  //산출율에 의해 마감처리
	// 환경설정에서 환율사용여부 검색
	SELECT DATANAME
	  INTO :s_RateGub
	  FROM SYSCNFG  
	 WHERE SYSGU = 'Y' AND SERIAL = 27 AND  LINENO = '1'   ;
	
	if s_RateGub = '' or isnull(s_RateGub) or sqlca.sqlcode <> 0 then s_RateGub = '2'

	IF s_RateGub = '1' then  
		 SELECT COUNT(*)
			INTO :get_count
			FROM RATEMT  
		  WHERE RDATE = :sf_Date  ;	
		if get_count < 1 then 		
			w_mdi_frame.sle_msg.text  = ''
			messagebox("확 인", "마감일자에 일일 환율을 먼저 입력해야 합니다.")
			return 1
		end if	
	ELSE
		SELECT COUNT(*)
		  INTO :get_count
		  FROM EXCHRATE_FORECAST
		 WHERE BASE_YYMM = SUBSTR(:sf_Date, 1, 6) ;
		
		if get_count < 1 then 		
			w_mdi_frame.sle_msg.text  = ''
			messagebox("확 인", "마감일자 월에 예측 환율을 먼저 입력해야 합니다.")
			return 1
		end if	
	END IF
	
END IF	

FOR  lRow = 1	TO		dw_insert.RowCount()

	sGubun = dw_insert.GetItemString(lRow, "magyeo")
	sBlno	 = dw_insert.GetItemString(lRow, "poblno")
//		sLcno  = dw_insert.GetItemString(lRow, "polcno")
	
	IF sGubun = 'Y'	THEN
		dw_insert.setitem(lrow, "magdat", sf_date)
		icount ++
		
		UPDATE POLCBL
			SET MAGYEO = 'X',
				 MAGDAT = :sf_Date,
				 UPD_USER = :gs_userid
		 WHERE SABU   = :gs_sabu	
			AND POBLNO = :sBlno		;
				 
		IF SQLCA.SQLCODE <> 0 THEN 
			ROLLBACK;
			w_mdi_frame.sle_msg.text  = ''
			MessageBox("마감실패", "B/L 마감일자 저장이 실패하였습니다.", StopSign!)
			Return 
		END IF
			
	END IF

NEXT

IF icount < 1 then 
	w_mdi_frame.sle_msg.text  = ''
	Messagebox('확 인', '자료를 선택 후 처리 하십시요...') 
	return 
END IF

IF is_expgub = '1' then 
	iReturn = SQLCA.ERP000000160(gs_sabu, sf_Date, sjpno ) ;
	
	IF iReturn < 1	THEN
		ROLLBACK;
		w_mdi_frame.sle_msg.text  = ''
		MessageBox("마감실패", string(iReturn) + " 수입비용으로 마감을 실패하였습니다.", StopSign!)
		Return 
	ELSE
		IF dw_insert.Update() > 0		THEN
			COMMIT;
			w_mdi_frame.sle_msg.text  = ''
			MessageBox("확인", "수입비용으로 마감 완료")
		ELSE
			ROLLBACK;
			f_Rollback()
			return 
		END IF
	END IF
ELSE
	iReturn = SQLCA.ERP000000165(gs_sabu, sf_Date, s_RateGub, sjpno) ;
	IF iReturn < 1	THEN
		ROLLBACK;
		w_mdi_frame.sle_msg.text  = ''
		MessageBox("마감실패", "수입비용 산출율로 마감을 실패하였습니다.", StopSign!)
		Return 
	ELSE
		IF dw_insert.Update() > 0		THEN
			COMMIT;
			w_mdi_frame.sle_msg.text  = ''
			MessageBox("확인", "수입비용 산출율로 마감 완료")
		ELSE
			ROLLBACK;
			f_Rollback()
			return 
		END IF
	END IF
END IF	


p_can.TriggerEvent("clicked")	

SetPointer(Arrow!)

end event

event p_mod::ue_lbuttondown;PictureName = "C:\erpman\image\마감_dn.gif"
end event

event p_mod::ue_lbuttonup;PictureName = "C:\erpman\image\마감_up.gif"
end event

type cb_exit from w_inherite`cb_exit within w_imt_03050
end type

type cb_mod from w_inherite`cb_mod within w_imt_03050
end type

type cb_ins from w_inherite`cb_ins within w_imt_03050
end type

type cb_del from w_inherite`cb_del within w_imt_03050
end type

type cb_inq from w_inherite`cb_inq within w_imt_03050
end type

type cb_print from w_inherite`cb_print within w_imt_03050
end type

type st_1 from w_inherite`st_1 within w_imt_03050
end type

type cb_can from w_inherite`cb_can within w_imt_03050
integer x = 2094
integer y = 2780
end type

type cb_search from w_inherite`cb_search within w_imt_03050
end type







type gb_button1 from w_inherite`gb_button1 within w_imt_03050
end type

type gb_button2 from w_inherite`gb_button2 within w_imt_03050
end type

type rr_3 from roundrectangle within w_imt_03050
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 969
integer y = 32
integer width = 1179
integer height = 140
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_4 from roundrectangle within w_imt_03050
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 188
integer width = 4590
integer height = 2148
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_1 from datawindow within w_imt_03050
event ue_key pbm_dwnkey
event ue_downenter pbm_dwnprocessenter
integer x = 978
integer y = 56
integer width = 1166
integer height = 104
integer taborder = 10
string title = "none"
string dataobject = "d_imt_03050_a"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemerror;RETURN 1
end event

event itemchanged;string  snull, sdate, gub

setnull(snull)

IF this.GetColumnName() = "fr_date"	THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[마감일자]')
		this.setitem(1, "fr_date", sNull)
		return 1
	END IF
	
	IF rb_1.checked then 
		sdate = left(sdate, 6)
		
	   SELECT "JUNPYO_CLOSING"."SABU"  
		  INTO :gub  
		  FROM "JUNPYO_CLOSING"  
 		 WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
				 ( "JUNPYO_CLOSING"."JPGU" = 'C0' ) AND  
				 ( "JUNPYO_CLOSING"."JPDAT"= :sdate )   ;

       if sqlca.sqlcode = 0 then 
			 messagebox('확 인', '수불마감된 일자입니다. 완료일자를 확인하세요!')
			 this.setitem(1, "fr_date", sNull)
			 return 1
		 end if
	END IF	
	
ELSEIF this.GetColumnName() = "to_date"	THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[마감일자]')
		this.setitem(1, "to_date", sNull)
		return 1
	END IF
END IF
end event

type rb_1 from radiobutton within w_imt_03050
integer x = 110
integer y = 72
integer width = 370
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "마감 처리"
boolean checked = true
end type

event clicked;ic_Status = '1'

p_mod.Enabled = True
p_del.Enabled = False
p_mod.PictureName = 'C:\erpman\image\마감_up.gif'
p_del.PictureName = 'C:\erpman\image\삭제_d.gif'

IF is_expgub = '1' then 
	dw_insert.DataObject = 'd_imt_03050'
	w_mdi_frame.sle_msg.text  = '수입비용으로 비용계산'
ELSE
	dw_insert.DataObject = 'd_imt_03052'
	w_mdi_frame.sle_msg.text  = '수입비용 산출율로 비용계산'
END IF	
dw_insert.SetTransObject(SQLCA)

//dw_1.settaborder("fr_date", 0)
dw_1.settaborder("to_date", 0)
//dw_1.Modify("fr_date.BackGround.Color= 12639424") 
dw_1.Modify("to_date.Visible= 0") 
dw_1.Modify("to_date_t.Visible= 0") 

dw_1.setitem(1, 'fr_date', is_today)
dw_insert.setfocus()

pb_2.Visible = False

end event

type rb_2 from radiobutton within w_imt_03050
integer x = 521
integer y = 72
integer width = 370
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "마감 취소"
end type

event clicked;ic_Status = '2'

p_mod.Enabled = False
p_del.Enabled = True
p_mod.PictureName = 'C:\erpman\image\마감_d.gif'
p_del.PictureName = 'C:\erpman\image\삭제_up.gif'

dw_insert.DataObject = 'd_imt_03051'
dw_insert.SetTransObject(SQLCA)

dw_1.Modify("to_date.Visible= 1") 
dw_1.Modify("to_date_t.Visible= 1") 
//dw_1.settaborder("fr_date", 20)
dw_1.settaborder("to_date", 30)
//dw_1.Modify("fr_date.BackGround.Color= 16777215") 

dw_1.setitem(1, 'fr_date', left(is_today,6) + '01')
dw_1.setitem(1, 'to_date', is_today)

dw_1.setcolumn('fr_date')
dw_1.setfocus()

pb_2.Visible = True

end event

type st_11 from statictext within w_imt_03050
integer x = 2199
integer y = 52
integer width = 1275
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
boolean enabled = false
string text = "마감처리는 수입비용에 물품대가 등록되어야 하고"
boolean focusrectangle = false
end type

type st_2 from statictext within w_imt_03050
integer x = 2199
integer y = 108
integer width = 1358
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
boolean enabled = false
string text = "           입고승인수량과 B/L수량이 일치하여야 함"
boolean focusrectangle = false
end type

type pb_2 from u_pb_cal within w_imt_03050
boolean visible = false
integer x = 2057
integer y = 60
integer taborder = 10
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_1.SetColumn('to_date')
IF IsNull(gs_code) THEN Return
ll_row = dw_1.GetRow()
If ll_row < 1 Then Return
dw_1.SetItem(ll_row, 'to_date', gs_code)



end event

type pb_1 from u_pb_cal within w_imt_03050
integer x = 1605
integer y = 60
integer taborder = 10
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_1.SetColumn('fr_date')
IF IsNull(gs_code) THEN Return
ll_row = dw_1.GetRow()
If ll_row < 1 Then Return
dw_1.SetItem(ll_row, 'fr_date', gs_code)



end event

type rr_2 from roundrectangle within w_imt_03050
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 18
integer y = 32
integer width = 937
integer height = 140
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_33 from roundrectangle within w_imt_03050
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 2162
integer y = 32
integer width = 1435
integer height = 140
integer cornerheight = 40
integer cornerwidth = 55
end type

