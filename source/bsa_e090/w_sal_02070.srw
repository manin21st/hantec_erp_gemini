$PBExportHeader$w_sal_02070.srw
$PBExportComments$ ** 기본 할인율 등록
forward
global type w_sal_02070 from w_inherite
end type
type dw_1 from datawindow within w_sal_02070
end type
type dw_2 from datawindow within w_sal_02070
end type
type dw_3 from datawindow within w_sal_02070
end type
type pb_1 from u_pb_cal within w_sal_02070
end type
type rr_1 from roundrectangle within w_sal_02070
end type
type rr_2 from roundrectangle within w_sal_02070
end type
type rr_3 from roundrectangle within w_sal_02070
end type
end forward

global type w_sal_02070 from w_inherite
string title = "기본 할인율 등록"
dw_1 dw_1
dw_2 dw_2
dw_3 dw_3
pb_1 pb_1
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
end type
global w_sal_02070 w_sal_02070

type variables
str_itnct lstr_sitnct
end variables

forward prototypes
public function integer wf_update (datawindow dwo)
public function integer wf_delete (datawindow dwo)
end prototypes

public function integer wf_update (datawindow dwo);string sSalegu,sItcls, sDate, sIttyp
Long   lRate, lRow, k, nRow, nCnt, nRowCnt

IF dwo.Accepttext() = -1 Then Return 0

If dwo.ModifiedCount() <= 0 Then Return 0

sSalegu = dw_insert.GetItemString(1, "salegu")      //영업구분

nRow = 0
nRowCnt = dwo.RowCount()
DO WHILE nRow <= nRowCnt

	nRow = dwo.GetNextModified(nRow, Primary!)
	IF nRow > 0 THEN
		sIttyp  = dwo.GetItemString(nRow, "ittyp")       //품목분류 
		sItcls  = dwo.GetItemString(nRow, "itcls")       //품목분류 
		sDate   = dwo.GetItemString(nRow, "start_date")  //적용시작일
		lRate   = dwo.GetItemNumber(nRow, "dc_rate")     //할인율 
		
		If IsNull(sDate) or Trim(sDate) = '' Then continue
		If IsNull(lRate) Then lRate = 0.0
		
		SELECT COUNT(*) INTO :nCnt
		  FROM "ITGRDC"  
		 WHERE ( "ITGRDC"."START_DATE" = :sDate ) AND  
				 ( "ITGRDC"."ITTYP" = :sIttyp ) AND  
				 ( "ITGRDC"."ITCLS" = :sItcls ) AND  
				 ( "ITGRDC"."SALEGU" = :sSalegu ) ;
	
		If nCnt > 0 Then
			update itgrdc
				set dc_rate = :lRate
			 where salegu = :sSalegu and
					 ittyp  = :sIttyp and
					 itcls  = :sItcls and
					 start_date = :sDate;
		Else
			insert into itgrdc
			 values ( :sSalegu, :sIttyp, :sItcls, :sDate, :lRate );
		End If

      If sqlca.sqlcode <> 0 Then
			MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
			RollBack;
			Return -1
		End If
	Else
		nRow = nRowCnt + 1
	END IF
LOOP

COMMIT;
w_mdi_frame.sle_msg.text = "저장하였습니다!!"

Return 1

end function

public function integer wf_delete (datawindow dwo);string sSalegu,sItcls, sDate, sIttyp, sTitnm
Long   lRate, lRow, k, nRow, nCnt, nRowCnt

IF dwo.Accepttext() = -1 Then Return 0

nRow = dwo.GetRow()
If nRow <= 0 Then Return 0

sSalegu = dwo.GetItemString(nRow, "salegu")      //영업구분
sIttyp  = dwo.GetItemString(nRow, "ittyp")       //품목분류 
sItcls  = dwo.GetItemString(nRow, "itcls")       //품목분류 
sTitnm  = dwo.GetItemString(nRow, "itnct_titnm")       //품목분류 
sDate   = dwo.GetItemString(nRow, "start_date")  //적용시작일
lRate   = dwo.GetItemNumber(nRow, "dc_rate")     //할인율 
		
If IsNull(sSalegu) or Trim(sSalegu) = '' Then Return 0

IF MessageBox("삭 제",sTitnm+" 가 삭제됩니다." +"~n~n" +&
                    	 "삭제 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN 0

DELETE FROM "ITGRDC"  
 WHERE ( "ITGRDC"."START_DATE" = :sDate ) AND  
		 ( "ITGRDC"."ITTYP" = :sIttyp ) AND  
		 ( "ITGRDC"."ITCLS" = :sItcls ) AND  
		 ( "ITGRDC"."SALEGU" = :sSalegu ) ;
		
If sqlca.sqlcode <> 0 Then
	RollBack;
	Return -1
End If

COMMIT;
w_mdi_frame.sle_msg.text = "삭제하였습니다!!"

Return 0
end function

on w_sal_02070.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.dw_3=create dw_3
this.pb_1=create pb_1
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.dw_3
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.rr_1
this.Control[iCurrent+6]=this.rr_2
this.Control[iCurrent+7]=this.rr_3
end on

on w_sal_02070.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.dw_3)
destroy(this.pb_1)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
end on

event open;call super::open;dw_insert.settransobject(sqlca)
dw_1.settransobject(sqlca)
dw_2.settransobject(sqlca)
dw_3.settransobject(sqlca)

dw_insert.InsertRow(0)

p_can.TriggerEvent(Clicked!)
end event

type dw_insert from w_inherite`dw_insert within w_sal_02070
integer x = 18
integer y = 40
integer width = 1925
integer height = 228
integer taborder = 30
string dataobject = "d_sal_02070_01"
boolean border = false
end type

event dw_insert::itemerror;RETURN 1
end event

event dw_insert::itemchanged;call super::itemchanged;Choose Case GetColumnName()
	Case 'start_date'
		If f_datechk(Trim(GetText())) <> 1 Then
			f_message_chk(35,'')
	      Return 2
      END IF
End Choose
end event

type p_delrow from w_inherite`p_delrow within w_sal_02070
boolean visible = false
integer x = 2843
integer y = 128
end type

type p_addrow from w_inherite`p_addrow within w_sal_02070
boolean visible = false
integer x = 2670
integer y = 128
end type

type p_search from w_inherite`p_search within w_sal_02070
boolean visible = false
integer x = 1975
integer y = 128
end type

type p_ins from w_inherite`p_ins within w_sal_02070
boolean visible = false
integer x = 2496
integer y = 128
end type

type p_exit from w_inherite`p_exit within w_sal_02070
integer x = 4425
end type

type p_can from w_inherite`p_can within w_sal_02070
integer x = 4251
end type

event p_can::clicked;call super::clicked;dw_1.Reset()
dw_2.Reset()
DW_3.RESET()

/* Protect */
dw_insert.Modify('salegu.protect = 0')
//dw_insert.Modify("salegu.background.color = '"+ String(Rgb(190,225,184))+"'")  //mint
dw_insert.Modify('ittyp.protect = 0')
//dw_insert.Modify("ittyp.background.color = '"+ String(Rgb(190,225,184))+"'")  //mint
dw_insert.Modify('start_date.protect = 0')
//dw_insert.Modify("start_date.background.color = '"+ String(Rgb(190,225,184))+"'")  //mint

ib_any_typing = false
end event

type p_print from w_inherite`p_print within w_sal_02070
boolean visible = false
integer x = 2149
integer y = 128
end type

type p_inq from w_inherite`p_inq within w_sal_02070
integer x = 3730
end type

event p_inq::clicked;call super::clicked;string salegu, sIttyp, sDate
Long   nRow

If dw_insert.AcceptText() <> 1 Then Return

nRow = dw_insert.GetRow()
If nRow <= 0 Then Return

salegu = Trim(dw_insert.GetItemString(nRow,'salegu'))
If IsNull(salegu) Or salegu = '' Then
	f_message_chk(1400,'[영업구분]')
	dw_insert.SetFocus()
	dw_insert.SetRow(nRow)
	dw_insert.setColumn('salegu')
	Return 2
End If

sittyp  = Trim(dw_insert.GetItemString(nRow,'ittyp'))
If IsNull(sittyp) Or sittyp = '' Then
	f_message_chk(1400,'[품목구분]')
	dw_insert.SetFocus()
	dw_insert.SetRow(nRow)
	dw_insert.setColumn('ittyp')
	Return 2
End If

sDate  = Trim(dw_insert.GetItemString(nRow,'start_date'))
If IsNull(sDate) Or sDate = '' Then
	f_message_chk(1400,'[적용시작일]')
	dw_insert.SetFocus()
	dw_insert.SetRow(nRow)
	dw_insert.setColumn('start_date')
	Return 2
End If

dw_2.Reset() // 중분류 reset
dw_1.retrieve(salegu, sIttyp, sDate) // 대분류 조회

/* Protect */
dw_insert.Modify('salegu.protect = 1')
//dw_insert.Modify("salegu.background.color = 80859087") 
dw_insert.Modify('ittyp.protect = 1')
//dw_insert.Modify("ittyp.background.color = 80859087") 
dw_insert.Modify('start_date.protect = 1')
//dw_insert.Modify("start_date.background.color = 80859087") 
end event

type p_del from w_inherite`p_del within w_sal_02070
integer x = 4078
end type

event p_del::clicked;call super::clicked;String sSalegu, sIttyp, sItcls, sDate
Long   nRow

sSalegu = Trim(dw_insert.GetItemString(1,'salegu'))
sIttyp  = Trim(dw_insert.GetItemString(1,'ittyp'))
sDate   = Trim(dw_insert.GetItemString(1,'start_date'))

/* 삭제 */
If dw_1.tag = 'this' Then
	wf_delete(dw_1)
	
	dw_1.retrieve(sSalegu, sIttyp, sDate) // 대분류 조회
elseif dw_3.tag='this' then
   nRow = dw_3.GetRow()
	If nRow <= 0 Then Return
	
	sItcls  = Trim(dw_3.GetItemString(nRow,'itcls'))
	wf_delete(dw_3)
	dw_1.retrieve(sSalegu, sIttyp, sDate ) // 대분류 조회
	dw_2.retrieve(sSalegu, sIttyp, Left(sItcls,2)+'%', sDate)     // 중분류 조회
	dw_3.retrieve(sSalegu, sIttyp, Left(sItcls,4)+'%', sDate) //소분류 조회
Else
	nRow = dw_2.GetRow()
	If nRow <= 0 Then Return
	
	sItcls  = Trim(dw_2.GetItemString(nRow,'itcls'))
	
	wf_delete(dw_2)
	
	dw_1.retrieve(sSalegu, sIttyp, sDate ) // 대분류 조회
	dw_2.retrieve(sSalegu, sIttyp, Left(sItcls,2)+'%', sDate)     // 중분류 조회
End If
dw_1.ScrollToRow(nRow)

ib_any_typing = false
end event

type p_mod from w_inherite`p_mod within w_sal_02070
integer x = 3904
end type

event p_mod::clicked;call super::clicked;String sSalegu, sIttyp, sItcls, sDate
Long   nRow

nRow = dw_1.GetRow()
If nRow <= 0 Then Return

sSalegu = Trim(dw_insert.GetItemString(1,'salegu'))
sIttyp  = Trim(dw_insert.GetItemString(1,'ittyp'))
sDate   = Trim(dw_insert.GetItemString(1,'start_date'))
sItcls  = Trim(dw_1.GetItemString(nRow,'itcls'))

/* 대분류 저장 */
If wf_update(dw_1) < 0 Then 
	p_can.TriggerEvent(Clicked!)
	Return
End If

/* 중분류 저장 */
If wf_update(dw_2) < 0 Then 
	p_can.TriggerEvent(Clicked!)
	Return
End If

/* 소분류 저장 */
If wf_update(dw_3) < 0 Then 
	p_can.TriggerEvent(Clicked!)
	Return
End If

dw_1.retrieve(sSalegu, sIttyp, sDate) // 대분류 조회
dw_1.ScrollToRow(nRow)

ib_any_typing = false
end event

type cb_exit from w_inherite`cb_exit within w_sal_02070
boolean visible = false
integer x = 1957
integer y = 8
integer taborder = 100
end type

type cb_mod from w_inherite`cb_mod within w_sal_02070
boolean visible = false
integer x = 1961
integer y = 12
integer taborder = 60
end type

event cb_mod::clicked;call super::clicked;String sSalegu, sIttyp, sItcls, sDate
Long   nRow

nRow = dw_1.GetRow()
If nRow <= 0 Then Return

sSalegu = Trim(dw_insert.GetItemString(1,'salegu'))
sIttyp  = Trim(dw_insert.GetItemString(1,'ittyp'))
sDate   = Trim(dw_insert.GetItemString(1,'start_date'))
sItcls  = Trim(dw_1.GetItemString(nRow,'itcls'))

/* 대분류 저장 */
If wf_update(dw_1) < 0 Then 
//	cb_can.TriggerEvent(Clicked!)
	Return
End If

/* 중분류 저장 */
If wf_update(dw_2) < 0 Then 
//	cb_can.TriggerEvent(Clicked!)
	Return
End If

/* 소분류 저장 */
If wf_update(dw_3) < 0 Then 
//	cb_can.TriggerEvent(Clicked!)
	Return
End If

dw_1.retrieve(sSalegu, sIttyp, sDate) // 대분류 조회
dw_1.ScrollToRow(nRow)

ib_any_typing = false
end event

type cb_ins from w_inherite`cb_ins within w_sal_02070
boolean visible = false
integer x = 50
integer y = 2404
end type

type cb_del from w_inherite`cb_del within w_sal_02070
boolean visible = false
integer x = 1966
integer y = 12
integer taborder = 80
end type

event cb_del::clicked;call super::clicked;String sSalegu, sIttyp, sItcls, sDate
Long   nRow

sSalegu = Trim(dw_insert.GetItemString(1,'salegu'))
sIttyp  = Trim(dw_insert.GetItemString(1,'ittyp'))
sDate   = Trim(dw_insert.GetItemString(1,'start_date'))

/* 삭제 */
If dw_1.tag = 'this' Then
	wf_delete(dw_1)
	
	dw_1.retrieve(sSalegu, sIttyp, sDate) // 대분류 조회
elseif dw_3.tag='this' then
   nRow = dw_3.GetRow()
	If nRow <= 0 Then Return
	
	sItcls  = Trim(dw_3.GetItemString(nRow,'itcls'))
	wf_delete(dw_3)
	dw_1.retrieve(sSalegu, sIttyp, sDate ) // 대분류 조회
	dw_2.retrieve(sSalegu, sIttyp, Left(sItcls,2)+'%', sDate)     // 중분류 조회
	dw_3.retrieve(sSalegu, sIttyp, Left(sItcls,4)+'%', sDate) //소분류 조회
Else
	nRow = dw_2.GetRow()
	If nRow <= 0 Then Return
	
	sItcls  = Trim(dw_2.GetItemString(nRow,'itcls'))
	
	wf_delete(dw_2)
	
	dw_1.retrieve(sSalegu, sIttyp, sDate ) // 대분류 조회
	dw_2.retrieve(sSalegu, sIttyp, Left(sItcls,2)+'%', sDate)     // 중분류 조회
End If
dw_1.ScrollToRow(nRow)

ib_any_typing = false
end event

type cb_inq from w_inherite`cb_inq within w_sal_02070
boolean visible = false
integer x = 1961
integer y = 16
integer taborder = 10
end type

event cb_inq::clicked;call super::clicked;string salegu, sIttyp, sDate
Long   nRow

If dw_insert.AcceptText() <> 1 Then Return

nRow = dw_insert.GetRow()
If nRow <= 0 Then Return

salegu = Trim(dw_insert.GetItemString(nRow,'salegu'))
If IsNull(salegu) Or salegu = '' Then
	f_message_chk(1400,'[영업구분]')
	dw_insert.SetFocus()
	dw_insert.SetRow(nRow)
	dw_insert.setColumn('salegu')
	Return 2
End If

sittyp  = Trim(dw_insert.GetItemString(nRow,'ittyp'))
If IsNull(sittyp) Or sittyp = '' Then
	f_message_chk(1400,'[품목구분]')
	dw_insert.SetFocus()
	dw_insert.SetRow(nRow)
	dw_insert.setColumn('ittyp')
	Return 2
End If

sDate  = Trim(dw_insert.GetItemString(nRow,'start_date'))
If IsNull(sDate) Or sDate = '' Then
	f_message_chk(1400,'[적용시작일]')
	dw_insert.SetFocus()
	dw_insert.SetRow(nRow)
	dw_insert.setColumn('start_date')
	Return 2
End If

dw_2.Reset() // 중분류 reset
dw_1.retrieve(salegu, sIttyp, sDate) // 대분류 조회

/* Protect */
dw_insert.Modify('salegu.protect = 1')
dw_insert.Modify("salegu.background.color = 80859087") 
dw_insert.Modify('ittyp.protect = 1')
dw_insert.Modify("ittyp.background.color = 80859087") 
dw_insert.Modify('start_date.protect = 1')
dw_insert.Modify("start_date.background.color = 80859087") 
end event

type cb_print from w_inherite`cb_print within w_sal_02070
boolean visible = false
integer x = 50
integer y = 2444
end type

type st_1 from w_inherite`st_1 within w_sal_02070
long backcolor = 80859087
end type

type cb_can from w_inherite`cb_can within w_sal_02070
boolean visible = false
integer x = 1957
integer y = 16
integer taborder = 90
end type

event cb_can::clicked;call super::clicked;dw_1.Reset()
dw_2.Reset()
DW_3.RESET()

/* Protect */
dw_insert.Modify('salegu.protect = 0')
dw_insert.Modify("salegu.background.color = '"+ String(Rgb(190,225,184))+"'")  //mint
dw_insert.Modify('ittyp.protect = 0')
dw_insert.Modify("ittyp.background.color = '"+ String(Rgb(190,225,184))+"'")  //mint
dw_insert.Modify('start_date.protect = 0')
dw_insert.Modify("start_date.background.color = '"+ String(Rgb(190,225,184))+"'")  //mint

ib_any_typing = false
end event

type cb_search from w_inherite`cb_search within w_sal_02070
boolean visible = false
integer x = 50
integer y = 2552
end type



type sle_msg from w_inherite`sle_msg within w_sal_02070
long backcolor = 80859087
end type

type gb_10 from w_inherite`gb_10 within w_sal_02070
fontcharset fontcharset = ansi!
long backcolor = 80859087
end type

type gb_button1 from w_inherite`gb_button1 within w_sal_02070
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_02070
end type

type dw_1 from datawindow within w_sal_02070
event ue_pressenter pbm_dwnprocessenter
string tag = "dw_1"
integer x = 50
integer y = 336
integer width = 1847
integer height = 1968
boolean bringtotop = true
string dataobject = "d_sal_02070_02"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event clicked;String sSaleGu, sIttyp, sItcls, sDate

This.SelectRow(0,false)
This.SelectRow(this.GetRow(),true)
	
If row > 0 Then
	sSalegu = Trim(dw_insert.GetItemString(1,'salegu'))
	sIttyp  = Trim(GetItemString(row,'ittyp'))
	sItcls  = Trim(GetItemString(row,'itcls'))
	sDate   = Trim(dw_insert.GetItemString(1,'start_date'))
	
	If IsNull(sDate) Then sDate = is_today
	
	/* 중분류 조회 */
	dw_2.Retrieve(sSalegu, sIttyp, sItcls+'%', sDate)
	dw_3.reset()
	ScrollToRow(row)
END If

dw_1.tag = 'this'
dw_2.tag = ''
dw_3.tag = ''
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

type dw_2 from datawindow within w_sal_02070
event ue_pressenter pbm_dwnprocessenter
string tag = "dw_2"
integer x = 1966
integer y = 336
integer width = 2633
integer height = 976
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_sal_02070_03"
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
end event

event clicked;String sSaleGu, sIttyp, sItcls, sDate
dw_2.accepttext()
dw_2.setfocus()

This.SelectRow(0,false)
This.SelectRow(this.GetRow(),true)
	
If row > 0 Then
	sSalegu = Trim(dw_insert.GetItemString(1,'salegu'))
	sIttyp  = Trim(dw_2.GetItemString(row,'ittyp'))
	sItcls  = Trim(dw_2.GetItemString(row,'itcls'))
	sDate   = Trim(dw_insert.GetItemString(1,'start_date'))
	
	If IsNull(sDate) Then sDate = is_today
	
	/* 소분류 조회 */
	dw_3.Retrieve(sSalegu, sIttyp, sItcls+'%', sDate)
	
	ScrollToRow(row)
END If

dw_1.tag = ''
dw_2.tag = 'this'
dw_3.tag = ''
end event

type dw_3 from datawindow within w_sal_02070
event ue_pressenter pbm_dwnprocessenter
string tag = "dw_2"
integer x = 1966
integer y = 1372
integer width = 2633
integer height = 896
integer taborder = 110
boolean bringtotop = true
string dataobject = "d_sal_02070_05"
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

This.SelectRow(0,false)
This.SelectRow(this.GetRow(),true)
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

type pb_1 from u_pb_cal within w_sal_02070
integer x = 1806
integer y = 160
integer width = 78
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_insert.SetColumn('start_date')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_insert.SetItem(1, 'start_date', gs_code)

end event

type rr_1 from roundrectangle within w_sal_02070
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 312
integer width = 1870
integer height = 2020
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_sal_02070
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1938
integer y = 312
integer width = 2665
integer height = 1016
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_sal_02070
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1938
integer y = 1348
integer width = 2665
integer height = 992
integer cornerheight = 40
integer cornerwidth = 55
end type

