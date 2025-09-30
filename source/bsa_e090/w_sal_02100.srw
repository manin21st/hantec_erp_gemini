$PBExportHeader$w_sal_02100.srw
$PBExportComments$거래처별 출하율 조정
forward
global type w_sal_02100 from w_inherite
end type
type dw_1 from datawindow within w_sal_02100
end type
type dw_2 from datawindow within w_sal_02100
end type
type dw_list from datawindow within w_sal_02100
end type
type dw_3 from datawindow within w_sal_02100
end type
type st_2 from statictext within w_sal_02100
end type
type gb_1 from groupbox within w_sal_02100
end type
type rr_1 from roundrectangle within w_sal_02100
end type
type rr_2 from roundrectangle within w_sal_02100
end type
type rr_3 from roundrectangle within w_sal_02100
end type
type rr_4 from roundrectangle within w_sal_02100
end type
end forward

global type w_sal_02100 from w_inherite
string title = "거래처별 출하율 조정"
dw_1 dw_1
dw_2 dw_2
dw_list dw_list
dw_3 dw_3
st_2 st_2
gb_1 gb_1
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
rr_4 rr_4
end type
global w_sal_02100 w_sal_02100

type variables
str_itnct lstr_sitnct
end variables

forward prototypes
public function integer wf_delete (datawindow dwo)
public function integer wf_update (datawindow dwo)
end prototypes

public function integer wf_delete (datawindow dwo);string sCvcod,sItcls, sDate, sIttyp, sTitnm, sNull
Long   lRate, lRow, k, nRow, nCnt, nRowCnt

IF dwo.Accepttext() = -1 Then Return 0

nRow = dwo.GetRow()
If nRow <= 0 Then Return 0

sCvcod  = dwo.GetItemString(nRow, "cvcod")       //거래처
sIttyp  = dwo.GetItemString(nRow, "ittyp")       //품목분류 
sItcls  = dwo.GetItemString(nRow, "itcls")       //품목분류 
sTitnm  = dwo.GetItemString(nRow, "itnct_titnm") //품목분류 
sDate   = dwo.GetItemString(nRow, "start_date")  //적용시작일
lRate   = dwo.GetItemNumber(nRow, "dc_rate")     //할인율 
		
If IsNull(sCvcod) or Trim(sCvcod) = '' Then Return 0

IF MessageBox("삭 제",sTitnm+" 가 삭제됩니다." +"~n~n" +&
                    	 "삭제 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN 0

DELETE FROM "VNDDC"  
WHERE ( "VNDDC"."CVCOD" = :sCvcod ) AND  
		( "VNDDC"."ITTYP" = :sIttyp ) AND  
		( "VNDDC"."ITCLS" = :sItcls ) AND  
		( "VNDDC"."START_DATE" = :sDate )   ;
	
If sqlca.sqlcode <> 0 Then
	RollBack;
	Return -1
End If

COMMIT;

/* 삭제된 row를 clear */
SetNull(sNull)
dwo.SetItem(nRow, "start_date",sNull)  //적용시작일
dwo.SetItem(nRow, "dc_rate",0)     //할인율 

w_mdi_frame.sle_msg.text = "삭제하였습니다!!"

Return 1
end function

public function integer wf_update (datawindow dwo);string sCVcod,sItcls, sDate, sIttyp
Long   lRow, k, nRow, nCnt, nRowCnt
dec{1} lRate

IF dwo.Accepttext() = -1 Then Return 0

If dwo.ModifiedCount() <= 0 Then Return 0

nRow = 0
nRowCnt = dwo.RowCount()
DO WHILE nRow <= nRowCnt

	nRow = dwo.GetNextModified(nRow, Primary!)
	IF nRow > 0 THEN
		sCVcod  = dwo.GetItemString(nRow, "cvcod")       //거래처
		sIttyp  = dwo.GetItemString(nRow, "ittyp")       //품목분류 
		sItcls  = dwo.GetItemString(nRow, "itcls")       //품목분류 
		sDate   = dwo.GetItemString(nRow, "start_date")  //적용시작일
		lRate   = dwo.GetItemNumber(nRow, "dc_rate")     //할인율 
		
		If IsNull(sDate) or Trim(sDate) = '' Then continue
		If IsNull(lRate) Then lRate = 0.0
		
		select count(*) into :nCnt from vnddc
		 where cvcod = :sCvcod and
				 ittyp = :sIttyp and
				 itcls = :sItcls and
				 start_date = :sDate;
		
		If nCnt > 0 Then
			update vnddc
				set dc_rate = :lRate
			 where cvcod = :sCvcod and
					 ittyp = :sIttyp and
					 itcls = :sItcls and
					 start_date = :sDate;
		Else
			Insert into vnddc
			 values ( :sCvcod, :sIttyp, :sItcls, :sDate, :lRate );
		End If

      If sqlca.sqlcode <> 0 Then
			RollBack;
			Return -1
		End If
	Else
		nRow = nRowCnt + 1
	END IF
LOOP

COMMIT;

Return 1

end function

on w_sal_02100.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.dw_list=create dw_list
this.dw_3=create dw_3
this.st_2=create st_2
this.gb_1=create gb_1
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
this.rr_4=create rr_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.dw_list
this.Control[iCurrent+4]=this.dw_3
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.gb_1
this.Control[iCurrent+7]=this.rr_1
this.Control[iCurrent+8]=this.rr_2
this.Control[iCurrent+9]=this.rr_3
this.Control[iCurrent+10]=this.rr_4
end on

on w_sal_02100.destroy
call super::destroy
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.dw_list)
destroy(this.dw_3)
destroy(this.st_2)
destroy(this.gb_1)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
destroy(this.rr_4)
end on

event open;call super::open;dw_insert.settransobject(sqlca)

dw_1.settransobject(sqlca)
dw_2.settransobject(sqlca)
dw_3.settransobject(sqlca)
dw_list.settransobject(sqlca)

dw_insert.InsertRow(0)
p_can.TriggerEvent(Clicked!)


end event

type dw_insert from w_inherite`dw_insert within w_sal_02100
integer x = 46
integer y = 4
integer width = 1115
integer height = 536
string dataobject = "d_sal_02100_01"
boolean border = false
end type

event dw_insert::itemchanged;String  sIoCust, sIoCustArea, sIoCustName, sDept, sDeptname
String  sDateFrom, sDateTo, snull, sPrtGbn, sSummary

SetNull(snull)

Choose Case GetColumnName() 
	Case"sdatef"
		sDateFrom = Trim(this.GetText())
		IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
		
		IF f_datechk(sDateFrom+'01') = -1 THEN
			f_message_chk(35,'[적용년월]')
			this.SetItem(1,"sdatef",snull)
			Return 1
		END IF
	/* 영업팀 */
	Case "deptcode"
		SetItem(1,'areacode',sNull)
		SetItem(1,"custcode",sNull)
		SetItem(1,"custname",sNull)
	/* 관할구역 */
	Case "areacode"
		SetItem(1,"custcode",sNull)
		SetItem(1,"custname",sNull)
		
		sIoCustArea = this.GetText()
		IF sIoCustArea = "" OR IsNull(sIoCustArea) THEN RETURN
		
		SELECT "SAREA"."SAREA" ,"SAREA"."STEAMCD" 	INTO :sIoCustArea  ,:sDept
		  FROM "SAREA"  
		 WHERE "SAREA"."SAREA" = :sIoCustArea   ;
		
		SetItem(1,'deptcode',sDept)
	/* 거래처 */
	Case "custcode"
		sIoCust = this.GetText()
		IF sIoCust ="" OR IsNull(sIoCust) THEN
			this.SetItem(1,"custname",snull)
			Return
		END IF
		
		SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
		  INTO :sIoCustName,		:sIoCustArea,			:sDept
		  FROM "VNDMST","SAREA" 
		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :sIoCust   ;
		IF SQLCA.SQLCODE <> 0 THEN
			this.TriggerEvent(RbuttonDown!)
			Return 2
		ELSE
			this.SetItem(1,"deptcode",  sDept)
			this.SetItem(1,"custname",  sIoCustName)
			this.SetItem(1,"areacode",  sIoCustArea)
		END IF
	/* 거래처명 */
	Case "custname"
		sIoCustName = Trim(GetText())
		IF sIoCustName ="" OR IsNull(sIoCustName) THEN
			this.SetItem(1,"custcode",snull)
			Return
		END IF
		
		SELECT "VNDMST"."CVCOD", "VNDMST"."CVNAS2","VNDMST"."SAREA","SAREA"."STEAMCD"
		  INTO :sIoCust, :sIoCustName, :sIoCustArea,	:sDept
		  FROM "VNDMST","SAREA" 
		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVNAS2" = :sIoCustName;
		IF SQLCA.SQLCODE <> 0 THEN
			this.TriggerEvent(RbuttonDown!)
			Return 2
		ELSE
			SetItem(1,"deptcode",  sDept)
			SetItem(1,"custcode",  sIoCust)
			SetItem(1,"custname",  sIoCustName)
			SetItem(1,"areacode",  sIoCustArea)
			Return
		END IF
END Choose
end event

event dw_insert::itemerror;RETURN 1
end event

event dw_insert::rbuttondown;string sIoCustName,sIoCustArea,sDept

SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case this.GetColumnName() 
	/* 거래처 */
	Case "custcode"
		gs_gubun = '1'
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		this.SetItem(1,"custcode",gs_code)
		
		SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
		  INTO :sIoCustName,		:sIoCustArea,			:sDept
		  FROM "VNDMST","SAREA" 
		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
		IF SQLCA.SQLCODE = 0 THEN
			this.SetItem(1,"deptcode",  sDept)
			this.SetItem(1,"custname",  sIoCustName)
			this.SetItem(1,"areacode",  sIoCustArea)
		END IF
	/* 거래처명 */
	Case "custname"
		gs_gubun = '1'
		gs_codename = Trim(GetText())
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		this.SetItem(1,"custcode",gs_code)
		
		SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
		  INTO :sIoCustName,		:sIoCustArea,			:sDept
		  FROM "VNDMST","SAREA" 
		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
		IF SQLCA.SQLCODE = 0 THEN
			this.SetItem(1,"deptcode",  sDept)
			this.SetItem(1,"custname",  sIoCustName)
			this.SetItem(1,"areacode",  sIoCustArea)
		END IF
END Choose

end event

event dw_insert::ue_key;string sCol
str_itnct str_sitnct

SetNull(gs_code)
SetNull(gs_codename)
IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
elseIF KeyDown(KeyF2!) THEN
	Choose Case GetColumnName()
	   Case  'itcls'
		    open(w_ittyp_popup3) 
			 str_sitnct = Message.PowerObjectParm
			 if IsNull(str_sitnct.s_ittyp) or str_sitnct.s_ittyp = "" then return
			 If Len(str_sitnct.s_sumgub) <= 4 Then
  		       this.SetItem(1, "ittyp", str_sitnct.s_ittyp)
		       this.SetItem(1, "itcls", str_sitnct.s_sumgub)
		       this.SetItem(1, "itclsnm", str_sitnct.s_titnm)
			 Else
				Return
			End If
	END Choose
End if	

end event

event dw_insert::editchanged;w_mdi_frame.sle_msg.text = ''
end event

type p_delrow from w_inherite`p_delrow within w_sal_02100
boolean visible = false
integer x = 4251
integer y = 5000
end type

type p_addrow from w_inherite`p_addrow within w_sal_02100
boolean visible = false
integer x = 4078
integer y = 5000
end type

type p_search from w_inherite`p_search within w_sal_02100
integer x = 4206
integer y = 336
integer width = 306
boolean originalsize = true
string picturename = "C:\erpman\image\출고단가조정_up.gif"
end type

event p_search::clicked;call super::clicked;Long nRow

If dw_list.AcceptText() <> 1 Then Return 1

nRow = dw_list.GetRow()
If nRow <= 0 Then Return

gs_code     = dw_list.GetItemString(nRow,'cvcod')
gs_codename = dw_list.GetItemString(nRow,'cvnas2')
open(w_sal_02120)
end event

event p_search::ue_lbuttondown;PictureName = "c:\erpman\image\출고단가조정_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "c:\erpman\image\출고단가조정_up.gif"
end event

type p_ins from w_inherite`p_ins within w_sal_02100
boolean visible = false
integer x = 3904
integer y = 5000
end type

type p_exit from w_inherite`p_exit within w_sal_02100
integer x = 4384
end type

type p_can from w_inherite`p_can within w_sal_02100
integer x = 4210
end type

event p_can::clicked;call super::clicked;dw_insert.Enabled = True

dw_list.Reset()
dw_1.Reset()
dw_2.Reset()
dw_3.reset()

dw_insert.setfocus()
dw_insert.setcolumn("sdatef")
//string scvcod,sittyp,scvnas
//int nRow
//
//nRow = dw_insert.GetRow()
//If nRow > 0 Then 
//   scvcod = Trim(dw_insert.GetItemString(nRow,'cvcod'))
//   scvnas = Trim(dw_insert.GetItemString(nRow,'cvcodnm'))
//Else
//	SetNull(scvcod)
//End If
//nRow = dw_3.GetRow()
//If nRow > 0 Then 
//   sittyp = Trim(dw_3.GetItemString(nRow,'ittyp'))
//Else
//	SetNull(sittyp)
//End If
//
//dw_insert.SetRedraw(false)
//dw_insert.reset()
//nRow = dw_insert.InsertRow(0)
//
//dw_insert.SetItem(nRow, "cvcod", scvcod)
//dw_insert.SetItem(nRow, "cvcodnm", scvnas)
//dw_insert.SetItem(nRow, "ittyp", sittyp)
//dw_insert.SetItem(nRow, "start_date", f_today())
//
//wf_key_protect(false)
//
//dw_1.Reset()
//dw_2.Reset()
//dw_insert.SetRedraw(true)
//
//dw_insert.setfocus()
//dw_insert.SetRow(nRow)
//dw_insert.setcolumn("itcls")
//
//ib_any_typing = false
//
end event

type p_print from w_inherite`p_print within w_sal_02100
boolean visible = false
integer x = 3557
integer y = 5000
end type

type p_inq from w_inherite`p_inq within w_sal_02100
integer x = 3689
integer y = 20
end type

event p_inq::clicked;call super::clicked;String sDatef, sSaleGu, sIttyp,sArea, sCvcod

dw_insert.accepttext()

sDatef  = Trim(dw_insert.GetItemString(1,'sdatef'))
sSalegu = Trim(dw_insert.GetItemString(1,'salegu'))
sIttyp  = Trim(dw_insert.GetItemString(1,'ittyp'))
sArea   = Trim(dw_insert.GetItemString(1,'areacode'))
sCvcod  = Trim(dw_insert.GetItemString(1,'custcode'))

dw_insert.SetFocus()
If IsNull(sDatef) Or sDatef = '' Then
	f_message_chk(1400,'[적용년월]')
	dw_insert.setColumn('sdatef')
	Return 
End If

If IsNull(sSalegu) Or sSalegu = '' Then
	f_message_chk(1400,'[영업구분]')
	dw_insert.setColumn('salegu')
	Return 
End If

If IsNull(sIttyp) Or sIttyp = '' Then
	f_message_chk(1400,'[품목구분]')
	dw_insert.setColumn('ittyp')
	Return 
End If

If IsNull(sArea) Then  sArea = ''
If IsNull(sCvcod) Then sCvcod = ''

//dw_1.Reset()
//dw_2.Reset()
If dw_list.Retrieve(sDatef, sSaleGu, sIttyp, sArea+'%', sCvcod +'%') <= 0 Then
   f_message_chk(50,'')	
	Return
End If

/* Protect */
dw_insert.Enabled = False
end event

type p_del from w_inherite`p_del within w_sal_02100
integer x = 4037
end type

event p_del::clicked;call super::clicked;Long nRow
String sCvcod

nRow = dw_list.GetRow()
If nRow <= 0 Then Return

sCvcod = Trim(dw_list.GetItemString(nRow,'cvcod'))

/* 삭제 */
If dw_1.tag = 'this' Then
	wf_delete(dw_1)
elseIf dw_3.tag = 'this' Then
	wf_delete(dw_3)
Elseif dw_2.tag= 'this' then
	wf_delete(dw_2)
End If

/* 거래처정보 조회 */
p_inq.TriggerEvent(Clicked!)

nRow = dw_list.Find("cvcod = '" + sCvcod + "'" ,1,dw_list.RowCount())
If nRow > 0 Then
	dw_list.ScrollToRow(nRow)
	dw_list.SelectRow(0,False)
	dw_list.SelectRow(nRow,True)
End If

Parent.SetRedraw(True)

ib_any_typing = false
end event

type p_mod from w_inherite`p_mod within w_sal_02100
integer x = 3863
end type

event p_mod::clicked;call super::clicked;String sCvcod, sIttyp, sItcls
Long   nRow

nRow = dw_1.GetRow()
If nRow <= 0 Then Return

sCvcod = Trim(dw_1.GetItemString(nRow,'cvcod'))
sIttyp = Trim(dw_1.GetItemString(nRow,'ittyp'))
sItcls = Trim(dw_1.GetItemString(nRow,'itcls'))

Parent.SetRedraw(False)

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


/* 거래처정보 조회 */
p_inq.TriggerEvent(Clicked!)

nRow = dw_list.Find("cvcod = '" + sCvcod + "'" ,1,dw_list.RowCount())
If nRow > 0 Then
	dw_list.ScrollToRow(nRow)
	dw_list.SelectRow(0,False)
	dw_list.SelectRow(nRow,True)
End If

Parent.SetRedraw(True)

ib_any_typing = false

/* 출하단가조정 */
p_search.TriggerEvent(Clicked!)

w_mdi_frame.sle_msg.text = "저장하였습니다!!"
end event

type cb_exit from w_inherite`cb_exit within w_sal_02100
boolean visible = false
integer x = 4389
integer y = 5000
integer taborder = 100
end type

type cb_mod from w_inherite`cb_mod within w_sal_02100
boolean visible = false
integer x = 3506
integer y = 5000
integer taborder = 70
end type

type cb_ins from w_inherite`cb_ins within w_sal_02100
boolean visible = false
integer x = 50
integer y = 2376
end type

type cb_del from w_inherite`cb_del within w_sal_02100
boolean visible = false
integer x = 3867
integer y = 5000
integer taborder = 80
end type

type cb_inq from w_inherite`cb_inq within w_sal_02100
boolean visible = false
integer x = 3515
integer y = 5000
end type

event cb_inq::clicked;call super::clicked;String sDatef, sSaleGu, sIttyp,sArea, sCvcod

dw_insert.accepttext()

sDatef  = Trim(dw_insert.GetItemString(1,'sdatef'))
sSalegu = Trim(dw_insert.GetItemString(1,'salegu'))
sIttyp  = Trim(dw_insert.GetItemString(1,'ittyp'))
sArea   = Trim(dw_insert.GetItemString(1,'areacode'))
sCvcod  = Trim(dw_insert.GetItemString(1,'custcode'))

dw_insert.SetFocus()
If IsNull(sDatef) Or sDatef = '' Then
	f_message_chk(1400,'[적용년월]')
	dw_insert.setColumn('sdatef')
	Return 
End If

If IsNull(sSalegu) Or sSalegu = '' Then
	f_message_chk(1400,'[영업구분]')
	dw_insert.setColumn('salegu')
	Return 
End If

If IsNull(sIttyp) Or sIttyp = '' Then
	f_message_chk(1400,'[품목구분]')
	dw_insert.setColumn('ittyp')
	Return 
End If

If IsNull(sArea) Then  sArea = ''
If IsNull(sCvcod) Then sCvcod = ''

//dw_1.Reset()
//dw_2.Reset()
If dw_list.Retrieve(sDatef, sSaleGu, sIttyp, sArea+'%', sCvcod +'%') <= 0 Then
   f_message_chk(50,'')	
	Return
End If

/* Protect */
dw_insert.Enabled = False
end event

type cb_print from w_inherite`cb_print within w_sal_02100
boolean visible = false
integer x = 50
integer y = 2444
end type

type st_1 from w_inherite`st_1 within w_sal_02100
long backcolor = 80859087
end type

type cb_can from w_inherite`cb_can within w_sal_02100
boolean visible = false
integer x = 4229
integer y = 5000
integer taborder = 90
end type

type cb_search from w_inherite`cb_search within w_sal_02100
boolean visible = false
integer x = 3867
integer y = 5000
integer width = 567
integer taborder = 60
string text = " 출고단가조정(&W)"
end type



type sle_msg from w_inherite`sle_msg within w_sal_02100
long backcolor = 80859087
end type

type gb_10 from w_inherite`gb_10 within w_sal_02100
fontcharset fontcharset = ansi!
long backcolor = 80859087
end type

type gb_button1 from w_inherite`gb_button1 within w_sal_02100
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_02100
end type

type dw_1 from datawindow within w_sal_02100
event ue_enter pbm_dwnprocessenter
integer x = 73
integer y = 568
integer width = 1815
integer height = 1740
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_sal_02100_03"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_enter;Send(Handle(this),256,9,0)
Return 1
end event

event clicked;Long nRow
String sCvcod, sIttyp, sDate, sItcls

nRow = dw_list.GetRow()
If nRow <= 0 Then Return

If row > 0 Then
	sCvcod = dw_list.GetItemString(nRow,'cvcod')
	sIttyp = dw_list.GetItemString(nRow,'ittyp')
	sDate  = dw_list.GetItemString(nRow,'start_date')
	sItcls = This.GetItemString(row,'itcls')

	If IsNull(sDate) Then sDate = ''
	
	/* 중분류 조회 */
	dw_2.Retrieve(sCvcod, sIttyp, sItcls+'%', sDate )
	dw_3.reset()
End If

dw_1.tag = 'this'
dw_2.tag = ''
dw_3.tag = ''

//Long   nCnt,rtn
//string s_cvcod,s_sdate, s_ittyp, s_itcls
//
//// 선택한 행 반전 ///////////////////////
//If Row <= 0 then
//	this.SelectRow(0,False)
//   return 
//ELSE
//	dw_2.SelectRow(0,false)
//	SelectRow(0, FALSE)
//	SelectRow(Row,TRUE)
//END IF
/////////////////////////////////////////////
//s_cvcod  = dw_insert.getitemstring(dw_insert.Getrow(), "cvcod")  //거래처
//If IsNull(s_cvcod) or s_cvcod = '' Then
//	s_cvcod = this.getitemstring(row, "cvcod")  //거래처
//End If
//
//s_sdate  = this.getitemstring(row, "start_date")   //시작일
//s_ittyp  = this.getitemstring(row, "ittyp")        //품목구분
//s_itcls  = this.getitemstring(row, "itcls")        //품목분류   
//
//dw_2.retrieve(s_cvcod, s_ittyp, s_itcls+'%')       // 중분류 조회
//
//// dw_insert 조회
//If s_sdate <> '' and Not IsNull(s_sdate) Then
//   nCnt = dw_insert.Retrieve(s_cvcod,s_ittyp,s_itcls,s_sdate)
//	If nCnt <=0 Then cb_can.TriggerEvent(Clicked!)
//	
//	wf_key_protect(true)
//Else
//	dw_insert.Setitem(1, "ittyp",s_ittyp)
//	dw_insert.Setitem(1, "itcls",s_itcls)
//   dw_insert.Setitem(1, "itclsnm",This.Describe("Evaluate('LookUpDisplay(itnct_titnm)'," + string(row) + ")"))
//	dw_insert.Setitem(1, "dc_rate",0)
//	
//	wf_key_protect(true)
//	dw_insert.Modify('start_date.protect = 0')
//   dw_insert.Modify("start_date.background.color = '"+String(Rgb(190,225,184))+"'")
//	
//	rtn = dw_insert.SetItemStatus(1,0,Primary!, NewModified!)
//End If
//
//dw_insert.SetFocus()
//dw_insert.SetRow(1)
//dw_insert.SetColumn('dc_rate')
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

type dw_2 from datawindow within w_sal_02100
event ue_enter pbm_dwnprocessenter
integer x = 2085
integer y = 604
integer width = 2409
integer height = 784
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_sal_02100_04"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_enter;Send(Handle(this),256,9,0)
Return 1
end event

event itemerror;return 1
end event

event clicked;Long nRow
String sCvcod, sIttyp, sDate, sItcls

nRow = dw_list.GetRow()
If nRow <= 0 Then Return

If row > 0 Then
	sCvcod = dw_list.GetItemString(nRow,'cvcod')
	sIttyp = dw_list.GetItemString(nRow,'ittyp')
	sDate  = dw_list.GetItemString(nRow,'start_date')
	sItcls = This.GetItemString(row,'itcls')

	If IsNull(sDate) Then sDate = ''
	
	/* 중분류 조회 */
	dw_3.Retrieve(sCvcod, sIttyp, sItcls+'%', sDate )
End If

dw_1.tag = ''
dw_2.tag = 'this'
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

type dw_list from datawindow within w_sal_02100
integer x = 1243
integer y = 60
integer width = 2222
integer height = 452
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_sal_02100_02"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;String sCvcod, sIttyp, sDate
IF Row <=0 THEN RETURN
this.SelectRow(0,False)
this.SelectRow(Row,True)

sCvcod = GetItemString(row,'cvcod')
sIttyp = GetItemString(row,'ittyp')
sDate  = GetItemString(row,'start_date')

If IsNull(sIttyp) Then sIttyp = dw_insert.GetItemString(1,'ittyp')
If IsNull(sDate)  Then sDate = ''

/* 대분류 조회 */
dw_1.Retrieve(sCvcod, sIttyp, sDate)
dw_2.Reset()
dw_3.reset()

w_mdi_frame.sle_msg.text = "거래처마스터에서 '익월출하율' 선택 업체만 조회됩니다"
end event

type dw_3 from datawindow within w_sal_02100
event ue_enter pbm_dwnprocessenter
integer x = 2085
integer y = 1452
integer width = 2409
integer height = 784
integer taborder = 110
boolean bringtotop = true
string dataobject = "d_sal_02100_05"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_enter;Send(Handle(this),256,9,0)
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

type st_2 from statictext within w_sal_02100
integer x = 1303
integer width = 343
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "거래처 현황"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_sal_02100
integer x = 4183
integer y = 296
integer width = 361
integer height = 212
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_sal_02100
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1225
integer y = 20
integer width = 2263
integer height = 508
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_sal_02100
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 548
integer width = 1911
integer height = 1772
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_sal_02100
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2016
integer y = 548
integer width = 2528
integer height = 880
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_4 from roundrectangle within w_sal_02100
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2016
integer y = 1440
integer width = 2528
integer height = 880
integer cornerheight = 40
integer cornerwidth = 55
end type

