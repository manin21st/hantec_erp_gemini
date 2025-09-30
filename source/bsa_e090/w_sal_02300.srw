$PBExportHeader$w_sal_02300.srw
$PBExportComments$등급/결제조건 할인율 등록
forward
global type w_sal_02300 from w_inherite
end type
type rr_1 from roundrectangle within w_sal_02300
end type
type rr_3 from roundrectangle within w_sal_02300
end type
type rr_2 from roundrectangle within w_sal_02300
end type
type cbx_del from checkbox within w_sal_02300
end type
type st_10 from statictext within w_sal_02300
end type
type st_11 from statictext within w_sal_02300
end type
type cb_1 from commandbutton within w_sal_02300
end type
type dw_1 from datawindow within w_sal_02300
end type
type dw_3 from datawindow within w_sal_02300
end type
type dw_2 from datawindow within w_sal_02300
end type
type p_1 from uo_picture within w_sal_02300
end type
end forward

global type w_sal_02300 from w_inherite
string title = "월 출하율 기준 등록(등급/결제)"
rr_1 rr_1
rr_3 rr_3
rr_2 rr_2
cbx_del cbx_del
st_10 st_10
st_11 st_11
cb_1 cb_1
dw_1 dw_1
dw_3 dw_3
dw_2 dw_2
p_1 p_1
end type
global w_sal_02300 w_sal_02300

type variables
str_itnct lstr_sitnct
end variables

forward prototypes
public function integer wf_update (datawindow dwo)
public function integer wf_delete (datawindow dwo)
end prototypes

public function integer wf_update (datawindow dwo);string sSalegu,sItcls, sDate, sIttyp
string ls_gubun , ls_dccod , ls_ittyp ,ls_itcls
Dec    lRate
Long   lRow, k, nRow, nCnt, nRowCnt

IF dwo.Accepttext() = -1 Then Return 0

If dwo.ModifiedCount() <= 0 Then Return 0

nRow = 0
nRowCnt = dwo.RowCount()
If nRowCnt <= 0 Then Return 0

setpointer(hourglass!)

DO WHILE nRow <= nRowCnt

	nRow = dwo.GetNextModified(nRow, Primary!)
	IF nRow > 0 THEN
		ls_gubun = dwo.GetItemString(nrow, "vnddc_mod_dcgub")       //영업구분
		ls_ittyp = dwo.GetItemString(nRow, "vnddc_mod_ittyp")       //품목분류 
		ls_itcls = dwo.GetItemString(nRow, "vnddc_mod_itcls")       //품목분류 
		ls_dccod = dwo.GetItemString(nRow, "vnddc_mod_dccod")  		//적용시작일
		lRate   = dwo.GetItemNumber(nRow, "dc_rate")     				//할인율 

		If IsNull(lRate) Then Continue


		Choose Case dwo
			/* 대분류 */
			Case dw_1
				Delete from vnddc_mod
				 where DCGUB  = :ls_gubun and
						 ittyp  = :ls_Ittyp and
						 substr(itcls,1,2)  = :ls_Itcls and
						 DCCOD  = :ls_dccod;
			/* 중분류 */
			Case dw_2
				Delete from vnddc_mod
				 where DCGUB  = :ls_gubun and
						 ittyp  = :ls_Ittyp and
						 substr(itcls,1,4)  = :ls_Itcls and
						 DCCOD  = :ls_dccod;
			/* 소분류 */
			Case dw_3
				Delete from vnddc_mod
				 where DCGUB  = :ls_gubun and
						 ittyp  = :ls_Ittyp and
						 itcls  = :ls_Itcls and
						 DCCOD  = :ls_dccod;
		End Choose
      If sqlca.sqlcode <> 0 Then
			MessageBox('%% ' + string(sqlca.sqlcode),sqlca.sqlerrtext)
			RollBack;
			Return -1
		End If		
		
//		SELECT COUNT(*) INTO :nCnt
//		  FROM "VNDDC_MOD"  
//		 WHERE ( "VNDDC_MOD"."DCGUB" = :ls_gubun ) AND  
//				 ( "VNDDC_MOD"."ITTYP" = :ls_Ittyp ) AND  
//				 ( "VNDDC_MOD"."ITCLS" = :ls_Itcls ) AND  
//				 ( "VNDDC_MOD"."DCCOD" = :ls_dccod ) ;
//	
//		If nCnt > 0 Then
//			update VNDDC_MOD
//				set dc_rate = nvl(:lRate,0)
//			 where DCGUB  = :ls_gubun and
//					 ittyp  = :ls_Ittyp and
//					 itcls  = :ls_Itcls and
//					 DCCOD  = :ls_dccod;
//		Else
			insert into VNDDC_MOD
			 values ( :ls_gubun, :ls_dccod, :ls_ittyp, :ls_itcls, nvl(:lRate,0) );
//		End If

      If sqlca.sqlcode <> 0 Then
			MessageBox('@@ ' + string(sqlca.sqlcode),sqlca.sqlerrtext)
			RollBack;
			Return -1
		End If
		
	Else
		nRow = nRowCnt + 1
	END IF
LOOP

Return 1
end function

public function integer wf_delete (datawindow dwo);string ls_gubun , ls_dccod , ls_ittyp , ls_itcls , ls_titnm
Long   lRate, lRow, k, nRow, nCnt, nRowCnt

IF dwo.Accepttext() = -1 Then Return 0

nRow = dwo.GetRow()
If nRow <= 0 Then Return 0

ls_gubun  = dwo.GetItemString(nRow, "vnddc_mod_dcgub")      
ls_Ittyp  = dwo.GetItemString(nRow, "vnddc_mod_ittyp")       //품목분류 
ls_Itcls  = dwo.GetItemString(nRow, "vnddc_mod_itcls")       //품목분류 
ls_dccod  = dwo.GetItemString(nRow, "vnddc_mod_dccod")  
ls_titnm  = dwo.GetItemString(nRow, "itnct_titnm")  
lRate     = dwo.GetItemNumber(nRow, "dc_rate")      

If cbx_del.Checked Then
	IF MessageBox("삭 제",ls_titnm + "를 포함한 하위분류도 같이 삭제됩니다.~r~n~r~n삭제 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN 0
	
	UPDATE  "VNDDC_MOD"  
	SET     "DC_RATE" = 0
	WHERE  ( "VNDDC_MOD"."DCGUB" = :ls_gubun ) AND  
			 ( "VNDDC_MOD"."ITTYP" = :ls_Ittyp ) AND  
			 ( "VNDDC_MOD"."ITCLS" LIKE :ls_Itcls||'%' ) AND  
			 ( "VNDDC_MOD"."DCCOD" = :ls_dccod ) ;
Else
	IF MessageBox("삭 제",ls_titnm + "를 삭제 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN 0
	
	UPDATE  "VNDDC_MOD"
	SET     "DC_RATE" = 0
	 WHERE ( "VNDDC_MOD"."DCGUB" = :ls_gubun ) AND  
			 ( "VNDDC_MOD"."ITTYP" = :ls_Ittyp ) AND  
			 ( "VNDDC_MOD"."ITCLS" = :ls_Itcls ) AND  
			 ( "VNDDC_MOD"."DCCOD" = :ls_dccod ) ;
End If
		
If sqlca.sqlcode <> 0 Then
	RollBack;
	Return -1
End If

COMMIT;
w_mdi_frame.sle_msg.text = "삭제하였습니다!!"

Return 0
end function

on w_sal_02300.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.rr_3=create rr_3
this.rr_2=create rr_2
this.cbx_del=create cbx_del
this.st_10=create st_10
this.st_11=create st_11
this.cb_1=create cb_1
this.dw_1=create dw_1
this.dw_3=create dw_3
this.dw_2=create dw_2
this.p_1=create p_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.rr_3
this.Control[iCurrent+3]=this.rr_2
this.Control[iCurrent+4]=this.cbx_del
this.Control[iCurrent+5]=this.st_10
this.Control[iCurrent+6]=this.st_11
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.dw_1
this.Control[iCurrent+9]=this.dw_3
this.Control[iCurrent+10]=this.dw_2
this.Control[iCurrent+11]=this.p_1
end on

on w_sal_02300.destroy
call super::destroy
destroy(this.rr_1)
destroy(this.rr_3)
destroy(this.rr_2)
destroy(this.cbx_del)
destroy(this.st_10)
destroy(this.st_11)
destroy(this.cb_1)
destroy(this.dw_1)
destroy(this.dw_3)
destroy(this.dw_2)
destroy(this.p_1)
end on

event open;call super::open;dw_insert.settransobject(sqlca)
dw_1.settransobject(sqlca)
dw_2.settransobject(sqlca)
dw_3.settransobject(sqlca)

dw_insert.InsertRow(0)

p_can.TriggerEvent(Clicked!)
end event

type dw_insert from w_inherite`dw_insert within w_sal_02300
integer x = 18
integer y = 16
integer width = 2048
integer height = 260
integer taborder = 30
string dataobject = "d_sal_02300"
boolean border = false
end type

event dw_insert::itemerror;RETURN 1
end event

event dw_insert::itemchanged;call super::itemchanged;dw_1.Reset()
dw_2.Reset()
dw_3.Reset()
end event

type p_delrow from w_inherite`p_delrow within w_sal_02300
boolean visible = false
integer x = 2473
integer y = 28
end type

type p_addrow from w_inherite`p_addrow within w_sal_02300
boolean visible = false
integer x = 2299
integer y = 28
end type

type p_search from w_inherite`p_search within w_sal_02300
boolean visible = false
integer x = 2633
integer y = 20
end type

type p_ins from w_inherite`p_ins within w_sal_02300
boolean visible = false
integer x = 2126
integer y = 28
end type

type p_exit from w_inherite`p_exit within w_sal_02300
end type

type p_can from w_inherite`p_can within w_sal_02300
end type

event p_can::clicked;call super::clicked;dw_1.Reset()
dw_2.Reset()
DW_3.RESET()
dw_insert.reset()
dw_insert.insertrow(0)
end event

type p_print from w_inherite`p_print within w_sal_02300
integer x = 1778
integer y = 28
end type

type p_inq from w_inherite`p_inq within w_sal_02300
integer x = 3451
end type

event p_inq::clicked;call super::clicked;string ls_ittyp , ls_dccod1 , ls_dccod2 , ls_gubun
long   ll_count ,i

If dw_insert.AcceptText() <> 1 Then Return

ls_gubun = dw_insert.getitemstring(1,'gubun')
ls_ittyp  = Trim(dw_insert.GetItemString(1,'ittyp'))

If IsNull(ls_ittyp) Or ls_ittyp = '' Then
	f_message_chk(1400,'[품목구분]')
	dw_insert.SetFocus()
	dw_insert.setColumn('ittyp')
	Return 2
End If

if ls_gubun = '1' then
	ls_dccod1 = dw_insert.getitemstring(1,'dcrate1')
	
	if ls_dccod1 = "" or isnull(ls_dccod1) then 
		f_message_chk(30,'[등급]')
		dw_insert.setcolumn('dcrate1')
		dw_insert.setfocus()
		return
	end if
	
	if dw_1.retrieve(ls_gubun,ls_dccod1,ls_ittyp) < 1 then
		f_message_chk(300,'')
		dw_insert.SetFocus()
		dw_insert.setColumn('ittyp')
		Return 2
	end if
else
	ls_dccod2 = dw_insert.getitemstring(1,'dcrate2')
	
	if ls_dccod2 = "" or isnull(ls_dccod2) then 
		f_message_chk(30,'[결제]')
		dw_insert.setcolumn('dcrate2')
		dw_insert.setfocus()
		return
	end if
	
	if dw_1.retrieve(ls_gubun,ls_dccod2,ls_ittyp) < 1 then
		dw_1.retrieve('%',ls_dccod2,ls_ittyp)
		f_message_chk(300,'')
		dw_insert.SetFocus()
		dw_insert.setColumn('ittyp')
		Return 2
	end if
end if

dw_2.Reset() // 중분류 reset
dw_3.reset()

ll_count = dw_1.rowcount()

for i= 1 to ll_count
	dw_1.setitem(i,'vnddc_mod_dcgub',ls_gubun)
   dw_1.setitem(i,'vnddc_mod_ittyp',ls_ittyp)
	dw_1.setitem(i,'vnddc_mod_itcls',dw_1.getitemstring(i,'itcls'))
	if ls_gubun = '1' then
		dw_1.setitem(i,'vnddc_mod_dccod',ls_dccod1)
	else
		dw_1.setitem(i,'vnddc_mod_dccod',ls_dccod2)
	end if
next
	
	
///* Protect */
//dw_insert.Modify('ittyp.protect = 1')
//dw_insert.Modify("ittyp.background.color = 80859087") 
//
 
 
end event

type p_del from w_inherite`p_del within w_sal_02300
end type

event p_del::clicked;call super::clicked;String sSalegu, sIttyp, sItcls, sDate ,ls_ittyp1 , ls_itcls , ls_dcgub1 , ls_dccod1
Long   nRow ,ll_row

dw_1.accepttext()
dw_2.accepttext()
dw_3.accepttext()

nRow = dw_1.GetRow()
If nRow <= 0 Then Return

if dw_1.tag = 'this' then
	
	ll_row    = dw_1.getrow() 
   ls_dcgub1 = Trim(dw_1.getitemstring(ll_row,'vnddc_mod_dcgub'))
	ls_dccod1 = Trim(dw_1.getitemstring(ll_row,'vnddc_mod_dccod'))
	ls_ittyp1 = Trim(dw_1.getitemstring(ll_row,'vnddc_mod_ittyp'))
	
	If wf_delete(dw_1) < 0 Then 	Return
	
	if dw_1.retrieve(ls_dcgub1,ls_dccod1,ls_ittyp1) < 1 then		return	
elseif dw_2.tag = 'this' then
	
	ll_row    = dw_2.getrow() 
	ls_dcgub1 = Trim(dw_2.getitemstring(ll_row,'vnddc_mod_dcgub'))
	ls_dccod1 = Trim(dw_2.getitemstring(ll_row,'vnddc_mod_dccod'))
	ls_ittyp1 = Trim(dw_2.getitemstring(ll_row,'vnddc_mod_ittyp'))
	ls_itcls = Trim(dw_2.getitemstring(ll_row,'vnddc_mod_itcls'))
	
	If wf_delete(dw_2) < 0 Then 		Return
	
	IF dw_2.retrieve(ls_dcgub1,ls_dccod1,ls_ittyp1,left(ls_itcls,2)+'%') < 1	then return
	
	IF dw_3.retrieve(ls_dcgub1,ls_dccod1,ls_ittyp1,left(ls_itcls,4)+'%') < 1	then return
else
	
	ll_row    = dw_3.getrow() 
	ls_dcgub1 = Trim(dw_3.getitemstring(ll_row,'vnddc_mod_dcgub'))
	ls_dccod1 = Trim(dw_3.getitemstring(ll_row,'vnddc_mod_dccod'))
	ls_ittyp1 = Trim(dw_3.getitemstring(ll_row,'vnddc_mod_ittyp'))
	ls_itcls = Trim(dw_3.getitemstring(ll_row,'vnddc_mod_itcls'))
	
	If wf_delete(dw_3) < 0 Then 	Return

	if dw_3.retrieve(ls_dcgub1,ls_dccod1,ls_ittyp1, left(ls_itcls,4)) < 1 then		return 
end if
end event

type p_mod from w_inherite`p_mod within w_sal_02300
end type

event p_mod::clicked;call super::clicked;String sSalegu, sIttyp, sItcls, sDate
Long   nRow
string ls_dcgub, ls_ittyp, ls_dccod

If dw_insert.AcceptText() <> 1 Then Return
If dw_1.AcceptText() <> 1 Then Return
If dw_2.AcceptText() <> 1 Then Return
If dw_3.AcceptText() <> 1 Then Return

nRow = dw_1.GetRow()
If nRow <= 0 Then Return

ls_dcgub = dw_insert.getitemstring(1,'gubun')
ls_ittyp = Trim(dw_insert.GetItemString(1,'ittyp'))

If ls_dcgub = '1' then
	ls_dccod = dw_insert.getitemstring(1,'dcrate1')
Else
	ls_dccod = dw_insert.getitemstring(1,'dcrate2')
End If

If dw_1.tag = 'this' then
	/* 대분류 저장 */
	If wf_update(dw_1) < 0 Then 
		p_can.TriggerEvent(Clicked!)
		Return
	End If
	
	/* 중,소분류 생성 */
	INSERT INTO VNDDC_MOD
				( DCGUB, DCCOD, ITTYP, ITCLS, DC_RATE )
		SELECT :ls_dcgub, :ls_dccod, B.ITTYP, B.ITCLS, NVL(A.DC_RATE,0)
		  FROM VNDDC_MOD A, ITNCT B
		 WHERE B.ITTYP = A.ITTYP(+) AND
				 SUBSTR(B.ITCLS,1,2) = A.ITCLS(+) AND
				 B.ITTYP = :ls_ittyp AND
				 B.LMSGU IN ( 'M', 'S' ) AND 
	//			 NVL(A.DC_RATE,0) <> 0 AND 
				 NVL(A.DCGUB,0) = :ls_dcgub AND
				 NVL(A.DCCOD,0) = :ls_dccod AND
				 NOT EXISTS ( SELECT * FROM VNDDC_MOD C
									WHERE C.DCGUB = :ls_dcgub AND
											C.DCCOD = :ls_dccod AND
											C.ITTYP = B.ITTYP AND
											C.ITCLS = B.ITCLS );
				 
	If sqlca.sqlcode <> 0 Then
		MessageBox(string(sqlca.sqlcode),'M# '+ sqlca.sqlerrtext)
		RollBack;
		p_can.TriggerEvent(Clicked!)
		Return -1
	End If

ElseIf dw_2.tag = 'this' then
	/* 중분류 저장 */
	If wf_update(dw_2) < 0 Then 
		p_can.TriggerEvent(Clicked!)
		Return
	End If
	
	/* 소분류 생성 */
	INSERT INTO VNDDC_MOD
				( DCGUB, DCCOD, ITTYP, ITCLS, DC_RATE )
		SELECT :ls_dcgub, :ls_dccod, B.ITTYP, B.ITCLS, NVL(A.DC_RATE,0)
		  FROM VNDDC_MOD A, ITNCT B
		 WHERE B.ITTYP = A.ITTYP(+) AND
				 SUBSTR(B.ITCLS,1,4) = A.ITCLS(+) AND
				 B.ITTYP = :ls_ittyp AND
				 B.LMSGU = 'S' AND 
	//			 NVL(A.DC_RATE,0) <> 0 AND 
				 NVL(A.DCGUB,0) = :ls_dcgub AND
				 NVL(A.DCCOD,0) = :ls_dccod AND
				 NOT EXISTS ( SELECT * FROM VNDDC_MOD C
									WHERE C.DCGUB = :ls_dcgub AND
											C.DCCOD = :ls_dccod AND
											C.ITTYP = B.ITTYP AND
											C.ITCLS = B.ITCLS );
				 
	If sqlca.sqlcode <> 0 Then
		MessageBox(string(sqlca.sqlcode),'S# '+ sqlca.sqlerrtext)
		RollBack;
		p_can.TriggerEvent(Clicked!)
		Return -1
	End If
Else
	/* 소분류 저장 */
	If wf_update(dw_3) < 0 Then 
		p_can.TriggerEvent(Clicked!)
		Return
	End If
End If

COMMIT;

//해당 데이타 윈도우 조회//
string ls_ittyp1 , ls_itcls , ls_dcgub1 , ls_dccod1
long   ll_row

dw_1.accepttext()
dw_2.accepttext()
dw_3.accepttext()

if dw_1.tag = 'this' then
	ll_row    = dw_1.getrow() 
   ls_dcgub1 = Trim(dw_1.getitemstring(ll_row,'vnddc_mod_dcgub'))
	ls_dccod1 = Trim(dw_1.getitemstring(ll_row,'vnddc_mod_dccod'))
	ls_ittyp1 = Trim(dw_1.getitemstring(ll_row,'vnddc_mod_ittyp'))
	
	if dw_1.retrieve(ls_dcgub1,ls_dccod1,ls_ittyp1) < 1 then
		return
	end if
elseif dw_2.tag = 'this' then
	ll_row    = dw_2.getrow() 
	ls_dcgub1 = Trim(dw_2.getitemstring(ll_row,'vnddc_mod_dcgub'))
	ls_dccod1 = Trim(dw_2.getitemstring(ll_row,'vnddc_mod_dccod'))
	ls_ittyp1 = Trim(dw_2.getitemstring(ll_row,'vnddc_mod_ittyp'))
	ls_itcls = Trim(dw_2.getitemstring(ll_row,'vnddc_mod_itcls'))
	
	if dw_1.retrieve(ls_dcgub1,ls_dccod1,ls_ittyp1) < 1 then
		return
	end if
	if dw_2.retrieve(ls_dcgub1,ls_dccod1,ls_ittyp1,left(ls_itcls,2)+'%') < 1 then
		return 
	end if
else
	ll_row    = dw_3.getrow() 
	ls_dcgub1 = Trim(dw_3.getitemstring(ll_row,'vnddc_mod_dcgub'))
	ls_dccod1 = Trim(dw_3.getitemstring(ll_row,'vnddc_mod_dccod'))
	ls_ittyp1 = Trim(dw_3.getitemstring(ll_row,'vnddc_mod_ittyp'))
	ls_itcls = Trim(dw_3.getitemstring(ll_row,'vnddc_mod_itcls'))
	
	if dw_1.retrieve(ls_dcgub1,ls_dccod1,ls_ittyp1) < 1 then
		return
	end if
	if dw_2.retrieve(ls_dcgub1,ls_dccod1,ls_ittyp1, left(ls_itcls,2)+'%') < 1 then
		return 
	end if
	if dw_3.retrieve(ls_dcgub1,ls_dccod1,ls_ittyp1, left(ls_itcls,4)+'%') < 1 then
		return 
	end if
end if

w_mdi_frame.sle_msg.text = "저장하였습니다!!"
end event

type cb_exit from w_inherite`cb_exit within w_sal_02300
integer x = 3186
integer y = 1920
integer taborder = 100
end type

type cb_mod from w_inherite`cb_mod within w_sal_02300
boolean visible = false
integer x = 2126
integer y = 172
integer taborder = 60
end type

event cb_mod::clicked;call super::clicked;String sSalegu, sIttyp, sItcls, sDate
Long   nRow
string ls_dcgub, ls_ittyp, ls_dccod

If dw_insert.AcceptText() <> 1 Then Return
If dw_1.AcceptText() <> 1 Then Return
If dw_2.AcceptText() <> 1 Then Return
If dw_3.AcceptText() <> 1 Then Return

nRow = dw_1.GetRow()
If nRow <= 0 Then Return

ls_dcgub = dw_insert.getitemstring(1,'gubun')
ls_ittyp = Trim(dw_insert.GetItemString(1,'ittyp'))

If ls_dcgub = '1' then
	ls_dccod = dw_insert.getitemstring(1,'dcrate1')
Else
	ls_dccod = dw_insert.getitemstring(1,'dcrate2')
End If

If dw_1.tag = 'this' then
	/* 대분류 저장 */
	If wf_update(dw_1) < 0 Then 
		p_can.TriggerEvent(Clicked!)
		Return
	End If
	
	/* 중,소분류 생성 */
	INSERT INTO VNDDC_MOD
				( DCGUB, DCCOD, ITTYP, ITCLS, DC_RATE )
		SELECT :ls_dcgub, :ls_dccod, B.ITTYP, B.ITCLS, NVL(A.DC_RATE,0)
		  FROM VNDDC_MOD A, ITNCT B
		 WHERE B.ITTYP = A.ITTYP(+) AND
				 SUBSTR(B.ITCLS,1,2) = A.ITCLS(+) AND
				 B.ITTYP = :ls_ittyp AND
				 B.LMSGU IN ( 'M', 'S' ) AND 
	//			 NVL(A.DC_RATE,0) <> 0 AND 
				 NVL(A.DCGUB,0) = :ls_dcgub AND
				 NVL(A.DCCOD,0) = :ls_dccod AND
				 NOT EXISTS ( SELECT * FROM VNDDC_MOD C
									WHERE C.DCGUB = :ls_dcgub AND
											C.DCCOD = :ls_dccod AND
											C.ITTYP = B.ITTYP AND
											C.ITCLS = B.ITCLS );
				 
	If sqlca.sqlcode <> 0 Then
		MessageBox(string(sqlca.sqlcode),'M# '+ sqlca.sqlerrtext)
		RollBack;
		p_can.TriggerEvent(Clicked!)
		Return -1
	End If

ElseIf dw_2.tag = 'this' then
	/* 중분류 저장 */
	If wf_update(dw_2) < 0 Then 
		p_can.TriggerEvent(Clicked!)
		Return
	End If
	
	/* 소분류 생성 */
	INSERT INTO VNDDC_MOD
				( DCGUB, DCCOD, ITTYP, ITCLS, DC_RATE )
		SELECT :ls_dcgub, :ls_dccod, B.ITTYP, B.ITCLS, NVL(A.DC_RATE,0)
		  FROM VNDDC_MOD A, ITNCT B
		 WHERE B.ITTYP = A.ITTYP(+) AND
				 SUBSTR(B.ITCLS,1,4) = A.ITCLS(+) AND
				 B.ITTYP = :ls_ittyp AND
				 B.LMSGU = 'S' AND 
	//			 NVL(A.DC_RATE,0) <> 0 AND 
				 NVL(A.DCGUB,0) = :ls_dcgub AND
				 NVL(A.DCCOD,0) = :ls_dccod AND
				 NOT EXISTS ( SELECT * FROM VNDDC_MOD C
									WHERE C.DCGUB = :ls_dcgub AND
											C.DCCOD = :ls_dccod AND
											C.ITTYP = B.ITTYP AND
											C.ITCLS = B.ITCLS );
				 
	If sqlca.sqlcode <> 0 Then
		MessageBox(string(sqlca.sqlcode),'S# '+ sqlca.sqlerrtext)
		RollBack;
		p_can.TriggerEvent(Clicked!)
		Return -1
	End If
Else
	/* 소분류 저장 */
	If wf_update(dw_3) < 0 Then 
		p_can.TriggerEvent(Clicked!)
		Return
	End If
End If

COMMIT;

//해당 데이타 윈도우 조회//
string ls_ittyp1 , ls_itcls , ls_dcgub1 , ls_dccod1
long   ll_row

dw_1.accepttext()
dw_2.accepttext()
dw_3.accepttext()

if dw_1.tag = 'this' then
	ll_row    = dw_1.getrow() 
   ls_dcgub1 = Trim(dw_1.getitemstring(ll_row,'vnddc_mod_dcgub'))
	ls_dccod1 = Trim(dw_1.getitemstring(ll_row,'vnddc_mod_dccod'))
	ls_ittyp1 = Trim(dw_1.getitemstring(ll_row,'vnddc_mod_ittyp'))
	
	if dw_1.retrieve(ls_dcgub1,ls_dccod1,ls_ittyp1) < 1 then
		return
	end if
elseif dw_2.tag = 'this' then
	ll_row    = dw_2.getrow() 
	ls_dcgub1 = Trim(dw_2.getitemstring(ll_row,'vnddc_mod_dcgub'))
	ls_dccod1 = Trim(dw_2.getitemstring(ll_row,'vnddc_mod_dccod'))
	ls_ittyp1 = Trim(dw_2.getitemstring(ll_row,'vnddc_mod_ittyp'))
	ls_itcls = Trim(dw_2.getitemstring(ll_row,'vnddc_mod_itcls'))
	
	if dw_1.retrieve(ls_dcgub1,ls_dccod1,ls_ittyp1) < 1 then
		return
	end if
	if dw_2.retrieve(ls_dcgub1,ls_dccod1,ls_ittyp1,left(ls_itcls,2)+'%') < 1 then
		return 
	end if
else
	ll_row    = dw_3.getrow() 
	ls_dcgub1 = Trim(dw_3.getitemstring(ll_row,'vnddc_mod_dcgub'))
	ls_dccod1 = Trim(dw_3.getitemstring(ll_row,'vnddc_mod_dccod'))
	ls_ittyp1 = Trim(dw_3.getitemstring(ll_row,'vnddc_mod_ittyp'))
	ls_itcls = Trim(dw_3.getitemstring(ll_row,'vnddc_mod_itcls'))
	
	if dw_1.retrieve(ls_dcgub1,ls_dccod1,ls_ittyp1) < 1 then
		return
	end if
	if dw_2.retrieve(ls_dcgub1,ls_dccod1,ls_ittyp1, left(ls_itcls,2)+'%') < 1 then
		return 
	end if
	if dw_3.retrieve(ls_dcgub1,ls_dccod1,ls_ittyp1, left(ls_itcls,4)+'%') < 1 then
		return 
	end if
end if

w_mdi_frame.sle_msg.text = "저장하였습니다!!"
end event

type cb_ins from w_inherite`cb_ins within w_sal_02300
boolean visible = false
integer x = 50
integer y = 2364
end type

type cb_del from w_inherite`cb_del within w_sal_02300
boolean visible = false
integer x = 2487
integer y = 172
integer taborder = 80
end type

event cb_del::clicked;call super::clicked;String sSalegu, sIttyp, sItcls, sDate ,ls_ittyp1 , ls_itcls , ls_dcgub1 , ls_dccod1
Long   nRow ,ll_row

dw_1.accepttext()
dw_2.accepttext()
dw_3.accepttext()

nRow = dw_1.GetRow()
If nRow <= 0 Then Return

if dw_1.tag = 'this' then
	
	ll_row    = dw_1.getrow() 
   ls_dcgub1 = Trim(dw_1.getitemstring(ll_row,'vnddc_mod_dcgub'))
	ls_dccod1 = Trim(dw_1.getitemstring(ll_row,'vnddc_mod_dccod'))
	ls_ittyp1 = Trim(dw_1.getitemstring(ll_row,'vnddc_mod_ittyp'))
	
	If wf_delete(dw_1) < 0 Then 	Return
	
	if dw_1.retrieve(ls_dcgub1,ls_dccod1,ls_ittyp1) < 1 then		return	
elseif dw_2.tag = 'this' then
	
	ll_row    = dw_2.getrow() 
	ls_dcgub1 = Trim(dw_2.getitemstring(ll_row,'vnddc_mod_dcgub'))
	ls_dccod1 = Trim(dw_2.getitemstring(ll_row,'vnddc_mod_dccod'))
	ls_ittyp1 = Trim(dw_2.getitemstring(ll_row,'vnddc_mod_ittyp'))
	ls_itcls = Trim(dw_2.getitemstring(ll_row,'vnddc_mod_itcls'))
	
	If wf_delete(dw_2) < 0 Then 		Return
	
	IF dw_2.retrieve(ls_dcgub1,ls_dccod1,ls_ittyp1,left(ls_itcls,2)+'%') < 1	then return
	
	IF dw_3.retrieve(ls_dcgub1,ls_dccod1,ls_ittyp1,left(ls_itcls,4)+'%') < 1	then return
else
	
	ll_row    = dw_3.getrow() 
	ls_dcgub1 = Trim(dw_3.getitemstring(ll_row,'vnddc_mod_dcgub'))
	ls_dccod1 = Trim(dw_3.getitemstring(ll_row,'vnddc_mod_dccod'))
	ls_ittyp1 = Trim(dw_3.getitemstring(ll_row,'vnddc_mod_ittyp'))
	ls_itcls = Trim(dw_3.getitemstring(ll_row,'vnddc_mod_itcls'))
	
	If wf_delete(dw_3) < 0 Then 	Return

	if dw_3.retrieve(ls_dcgub1,ls_dccod1,ls_ittyp1, left(ls_itcls,4)) < 1 then		return 
end if
end event

type cb_inq from w_inherite`cb_inq within w_sal_02300
boolean visible = false
integer x = 2171
integer y = 0
integer width = 357
integer taborder = 10
string text = "조회(&Q)"
end type

event cb_inq::clicked;call super::clicked;string ls_ittyp , ls_dccod1 , ls_dccod2 , ls_gubun
long   ll_count ,i

If dw_insert.AcceptText() <> 1 Then Return

ls_gubun = dw_insert.getitemstring(1,'gubun')
ls_ittyp  = Trim(dw_insert.GetItemString(1,'ittyp'))

If IsNull(ls_ittyp) Or ls_ittyp = '' Then
	f_message_chk(1400,'[품목구분]')
	dw_insert.SetFocus()
	dw_insert.setColumn('ittyp')
	Return 2
End If

if ls_gubun = '1' then
	ls_dccod1 = dw_insert.getitemstring(1,'dcrate1')
	
	if ls_dccod1 = "" or isnull(ls_dccod1) then 
		f_message_chk(30,'[등급]')
		dw_insert.setcolumn('dcrate1')
		dw_insert.setfocus()
		return
	end if
	
	if dw_1.retrieve(ls_gubun,ls_dccod1,ls_ittyp) < 1 then
		f_message_chk(300,'')
		dw_insert.SetFocus()
		dw_insert.setColumn('ittyp')
		Return 2
	end if
else
	ls_dccod2 = dw_insert.getitemstring(1,'dcrate2')
	
	if ls_dccod2 = "" or isnull(ls_dccod2) then 
		f_message_chk(30,'[결제]')
		dw_insert.setcolumn('dcrate2')
		dw_insert.setfocus()
		return
	end if
	
	if dw_1.retrieve(ls_gubun,ls_dccod2,ls_ittyp) < 1 then
		dw_1.retrieve('%',ls_dccod2,ls_ittyp)
		f_message_chk(300,'')
		dw_insert.SetFocus()
		dw_insert.setColumn('ittyp')
		Return 2
	end if
end if

dw_2.Reset() // 중분류 reset
dw_3.reset()

ll_count = dw_1.rowcount()

for i= 1 to ll_count
	dw_1.setitem(i,'vnddc_mod_dcgub',ls_gubun)
   dw_1.setitem(i,'vnddc_mod_ittyp',ls_ittyp)
	dw_1.setitem(i,'vnddc_mod_itcls',dw_1.getitemstring(i,'itcls'))
	if ls_gubun = '1' then
		dw_1.setitem(i,'vnddc_mod_dccod',ls_dccod1)
	else
		dw_1.setitem(i,'vnddc_mod_dccod',ls_dccod2)
	end if
next
	
	
///* Protect */
//dw_insert.Modify('ittyp.protect = 1')
//dw_insert.Modify("ittyp.background.color = 80859087") 
//
 
 
end event

type cb_print from w_inherite`cb_print within w_sal_02300
boolean visible = false
integer x = 50
integer y = 2444
end type

type st_1 from w_inherite`st_1 within w_sal_02300
long backcolor = 80859087
end type

type cb_can from w_inherite`cb_can within w_sal_02300
boolean visible = false
integer x = 2848
integer y = 172
integer taborder = 90
end type

event cb_can::clicked;call super::clicked;dw_1.Reset()
dw_2.Reset()
DW_3.RESET()
dw_insert.reset()
dw_insert.insertrow(0)

//
///* Protect */
//dw_insert.Modify('salegu.protect = 0')
//dw_insert.Modify("salegu.background.color = '"+ String(Rgb(190,225,184))+"'")  //mint
//dw_insert.Modify('ittyp.protect = 0')
//dw_insert.Modify("ittyp.background.color = '"+ String(Rgb(190,225,184))+"'")  //mint
//dw_insert.Modify('start_date.protect = 0')
//dw_insert.Modify("start_date.background.color = '"+ String(Rgb(190,225,184))+"'")  //mint
//
//ib_any_typing = false
end event

type cb_search from w_inherite`cb_search within w_sal_02300
boolean visible = false
integer x = 50
integer y = 2552
end type



type sle_msg from w_inherite`sle_msg within w_sal_02300
long backcolor = 80859087
end type

type gb_10 from w_inherite`gb_10 within w_sal_02300
integer y = 5000
fontcharset fontcharset = ansi!
long backcolor = 80859087
end type

type gb_button1 from w_inherite`gb_button1 within w_sal_02300
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_02300
end type

type rr_1 from roundrectangle within w_sal_02300
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 3127
integer y = 376
integer width = 1472
integer height = 1944
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_sal_02300
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 376
integer width = 1472
integer height = 1944
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_sal_02300
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1577
integer y = 376
integer width = 1472
integer height = 1944
integer cornerheight = 40
integer cornerwidth = 55
end type

type cbx_del from checkbox within w_sal_02300
integer x = 4023
integer y = 276
integer width = 562
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "하위분류 삭제"
borderstyle borderstyle = stylelowered!
end type

type st_10 from statictext within w_sal_02300
integer x = 27
integer y = 292
integer width = 1522
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "*거래처의 기본 할인율에 더해질 추가할인율을 입력합니다."
boolean focusrectangle = false
end type

type st_11 from statictext within w_sal_02300
integer x = 1563
integer y = 292
integer width = 795
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "입력 Ex) 5%추가할 경우 5입력"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_sal_02300
boolean visible = false
integer x = 2798
integer y = 88
integer width = 631
integer height = 108
integer taborder = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "품목별할인율 등록(&N)"
end type

type dw_1 from datawindow within w_sal_02300
event ue_pressenter pbm_dwnprocessenter
string tag = "dw_1"
integer x = 91
integer y = 400
integer width = 1339
integer height = 1876
string dataobject = "d_sal_02300_01"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event clicked;String ls_gubun , ls_dccod , ls_ittyp , ls_itcls
long   ll_count , i
	
If row > 0 Then
	ls_gubun  = Trim(dw_1.GetItemString(row,'vnddc_mod_dcgub'))
	ls_dccod  = Trim(dw_1.GetItemString(row,'vnddc_mod_dccod'))
	ls_ittyp  = Trim(dw_1.GetItemString(row,'vnddc_mod_ittyp'))
	ls_itcls  = Trim(dw_1.GetItemString(row,'vnddc_mod_itcls'))
	
	/* 중분류 조회 */
	dw_2.Retrieve(ls_gubun, ls_dccod, ls_ittyp, ls_itcls+'%')
	dw_3.reset()
	ScrollToRow(row)
END If

ll_count = dw_2.rowcount()

for i= 1 to ll_count
	dw_2.setitem(i,'vnddc_mod_dcgub',ls_gubun)
   dw_2.setitem(i,'vnddc_mod_ittyp',ls_ittyp)
	dw_2.setitem(i,'vnddc_mod_itcls',dw_2.getitemstring(i,'itcls'))
	dw_2.setitem(i,'vnddc_mod_dccod',ls_dccod)
next

dw_1.tag = 'this'
dw_2.tag = ''
dw_3.tag = ''


end event

event itemerror;return 1
end event

event rowfocuschanged;String ls_gubun , ls_dccod , ls_ittyp , ls_itcls
long   ll_count , i
	
If currentrow > 0 Then
	ls_gubun  = Trim(dw_1.GetItemString(currentrow,'vnddc_mod_dcgub'))
	ls_dccod  = Trim(dw_1.GetItemString(currentrow,'vnddc_mod_dccod'))
	ls_ittyp  = Trim(dw_1.GetItemString(currentrow,'vnddc_mod_ittyp'))
	ls_itcls  = Trim(dw_1.GetItemString(currentrow,'vnddc_mod_itcls'))
	
	/* 중분류 조회 */
	dw_2.Retrieve(ls_gubun, ls_dccod, ls_ittyp, ls_itcls+'%')
	dw_3.reset()
	ScrollTorow(currentrow)
END If

ll_count = dw_2.rowcount()

for i= 1 to ll_count
	dw_2.setitem(i,'vnddc_mod_dcgub',ls_gubun)
   dw_2.setitem(i,'vnddc_mod_ittyp',ls_ittyp)
	dw_2.setitem(i,'vnddc_mod_itcls',dw_2.getitemstring(i,'itcls'))
	dw_2.setitem(i,'vnddc_mod_dccod',ls_dccod)
next


end event

event itemchanged;String ls_gubun , ls_dccod , ls_ittyp , ls_itcls , ls_dc_rate
long   ll_count , i
	
Choose Case this.getcolumnname()
	Case 'dc_rate'
   	ls_gubun  = Trim(this.GetItemString(row,'vnddc_mod_dcgub'))
	   ls_dccod  = Trim(this.GetItemString(row,'vnddc_mod_dccod'))
	   ls_ittyp  = Trim(this.GetItemString(row,'vnddc_mod_ittyp'))
	   ls_itcls  = Trim(this.GetItemString(row,'vnddc_mod_itcls'))
      ls_dc_rate = Trim(this.gettext())
		
		if ls_dc_rate = "" or isnull(ls_dc_rate) then ls_dc_rate = '0'
		
	UPDATE VNDDC_MOD
	SET    DC_RATE = :ls_dc_rate
	WHERE  DCGUB = :ls_gubun AND
	       DCCOD = :ls_dccod AND
	       ITTYP = :ls_ittyp AND
	       SUBSTR(ITCLS,1,2) = :ls_itcls ;
			 
End Choose
	
end event

type dw_3 from datawindow within w_sal_02300
event ue_pressenter pbm_dwnprocessenter
string tag = "dw_2"
integer x = 3200
integer y = 400
integer width = 1339
integer height = 1876
integer taborder = 110
boolean bringtotop = true
string dataobject = "d_sal_02300_03"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event clicked;dw_1.tag = ''
dw_2.tag = ''
dw_3.tag = 'this'


end event

event itemchanged;Choose Case GetColumnName()
	Case 'dc_rate'
     	If long(this.gettext()) > 100 then
	      messagebox("확 인","할인율은 100%를 초과할 수 없습니다!!")
     		return 2
     	End if
	Case 'start_date'
		If f_datechk(Trim(GetText())) <> 1 Then
			f_message_chk(35,'')
	      Return 2
      END IF
End Choose


end event

event itemerror;return 1
end event

type dw_2 from datawindow within w_sal_02300
event ue_pressenter pbm_dwnprocessenter
string tag = "dw_2"
integer x = 1655
integer y = 400
integer width = 1339
integer height = 1876
integer taborder = 50
string dataobject = "d_sal_02300_02"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemerror;return 1
end event

event itemchanged;Choose Case GetColumnName()
	Case 'dc_rate'
     	If long(this.gettext()) > 100 then
	      messagebox("확 인","할인율은 100%를 초과할 수 없습니다!!")
     		return 2
     	End if
	Case 'start_date'
		If f_datechk(Trim(GetText())) <> 1 Then
			f_message_chk(35,'')
	      Return 2
      END IF
End Choose

String ls_gubun , ls_dccod , ls_ittyp , ls_itcls , ls_dc_rate
long   ll_count , i
	
Choose Case this.getcolumnname()
	Case 'dc_rate'
   	ls_gubun  = Trim(this.GetItemString(row,'vnddc_mod_dcgub'))
	   ls_dccod  = Trim(this.GetItemString(row,'vnddc_mod_dccod'))
	   ls_ittyp  = Trim(this.GetItemString(row,'vnddc_mod_ittyp'))
	   ls_itcls  = Trim(this.GetItemString(row,'vnddc_mod_itcls'))
      ls_dc_rate = Trim(this.gettext())
		
		if ls_dc_rate = "" or isnull(ls_dc_rate) then ls_dc_rate = '0'
		
	UPDATE VNDDC_MOD
	SET    DC_RATE = :ls_dc_rate
	WHERE  DCGUB = :ls_gubun AND
	       DCCOD = :ls_dccod AND
	       ITTYP = :ls_ittyp AND
	       SUBSTR(ITCLS,1,4) = :ls_itcls ;
			 
End Choose
	

end event

event clicked;String ls_gubun , ls_dccod , ls_ittyp , ls_itcls
long   ll_count , i
	
If row > 0 Then
	ls_gubun  = Trim(dw_2.GetItemString(row,'vnddc_mod_dcgub'))
	ls_dccod  = Trim(dw_2.GetItemString(row,'vnddc_mod_dccod'))
	ls_ittyp  = Trim(dw_2.GetItemString(row,'vnddc_mod_ittyp'))
	ls_itcls  = Trim(dw_2.GetItemString(row,'vnddc_mod_itcls'))
	
	/* 소분류 조회 */
	dw_3.Retrieve(ls_gubun, ls_dccod, ls_ittyp, ls_itcls+'%')
	ScrollToRow(row)
END If

ll_count = dw_3.rowcount()

for i= 1 to ll_count
	dw_3.setitem(i,'vnddc_mod_dcgub',ls_gubun)
   dw_3.setitem(i,'vnddc_mod_ittyp',ls_ittyp)
	dw_3.setitem(i,'vnddc_mod_itcls',dw_3.getitemstring(i,'itcls'))
	dw_3.setitem(i,'vnddc_mod_dccod',ls_dccod)
next

dw_1.tag = ''
dw_2.tag = 'this'
dw_3.tag = ''


end event

event rowfocuschanged;String ls_gubun , ls_dccod , ls_ittyp , ls_itcls
long   ll_count , i
	
If currentrow > 0 Then
	ls_gubun  = Trim(dw_2.GetItemString(currentrow,'vnddc_mod_dcgub'))
	ls_dccod  = Trim(dw_2.GetItemString(currentrow,'vnddc_mod_dccod'))
	ls_ittyp  = Trim(dw_2.GetItemString(currentrow,'vnddc_mod_ittyp'))
	ls_itcls  = Trim(dw_2.GetItemString(currentrow,'vnddc_mod_itcls'))
	
	/* 소분류 조회 */
	dw_3.Retrieve(ls_gubun, ls_dccod, ls_ittyp, ls_itcls+'%')
	ScrollToRow(currentrow)
END If

ll_count = dw_3.rowcount()

for i= 1 to ll_count
	dw_3.setitem(i,'vnddc_mod_dcgub',ls_gubun)
   dw_3.setitem(i,'vnddc_mod_ittyp',ls_ittyp)
	dw_3.setitem(i,'vnddc_mod_itcls',dw_3.getitemstring(i,'itcls'))
	dw_3.setitem(i,'vnddc_mod_dccod',ls_dccod)
next

end event

type p_1 from uo_picture within w_sal_02300
integer x = 3621
integer y = 24
integer width = 306
boolean bringtotop = true
boolean originalsize = true
string picturename = "c:\erpman\image\품목별할인율등록_up.gif"
end type

event p_1::clicked;call super::clicked;Long   nRow
String sGubun, sItcls, sIttyp, sGrade

If dw_1.AcceptText() <> 1 Then Return
If dw_2.AcceptText() <> 1 Then Return
If dw_3.AcceptText() <> 1 Then Return

nRow = dw_3.GetRow()
If nRow <= 0 Then
	MessageBox('확 인','소분류를 선택하세요')
	Return
End If

sGubun = Trim(dw_insert.GetItemString(1, 'gubun'))
sIttyp = Trim(dw_insert.GetItemString(1, 'ittyp'))
If sGubun = '1' Then
	sGrade = dw_insert.GetItemString(1, 'dcrate1')
Else
	sGrade = dw_insert.GetItemString(1, 'dcrate2')
End If

sItcls  = Trim(dw_3.GetItemString(nRow, 'itcls'))

gs_code 		= sGubun
gs_codename = sIttyp
gs_gubun 	= sItcls
OpenWithParm(w_sal_02300_popup, sGrade)

end event

event ue_lbuttonup;call super::ue_lbuttonup;pictureName = "c:\erpman\image\품목별할인율등록_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;pictureName = "c:\erpman\image\품목별할인율등록_dn.gif"
end event

