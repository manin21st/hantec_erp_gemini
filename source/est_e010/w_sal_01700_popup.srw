$PBExportHeader$w_sal_01700_popup.srw
$PBExportComments$견적의뢰 조회 POPUP
forward
global type w_sal_01700_popup from w_inherite_popup
end type
type dw_ip from u_key_enter within w_sal_01700_popup
end type
type rr_1 from roundrectangle within w_sal_01700_popup
end type
end forward

global type w_sal_01700_popup from w_inherite_popup
integer x = 407
integer y = 276
integer width = 2674
integer height = 1820
string title = "견적의뢰 조회 POPUP"
dw_ip dw_ip
rr_1 rr_1
end type
global w_sal_01700_popup w_sal_01700_popup

on w_sal_01700_popup.create
int iCurrent
call super::create
this.dw_ip=create dw_ip
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_ip
this.Control[iCurrent+2]=this.rr_1
end on

on w_sal_01700_popup.destroy
call super::destroy
destroy(this.dw_ip)
destroy(this.rr_1)
end on

event open;call super::open;String sToday

dw_ip.SetTransObject(sqlca)
dw_ip.InsertRow(0)

dw_ip.SetFocus()

sToday = f_today()
dw_ip.SetItem(1,'sdatet', sToday)
dw_ip.SetItem(1,'sdatef', Left(stoday,6)+'01')

dw_ip.SetColumn('sdatef')

end event

type dw_jogun from w_inherite_popup`dw_jogun within w_sal_01700_popup
integer x = 105
integer y = 2104
end type

type p_exit from w_inherite_popup`p_exit within w_sal_01700_popup
integer x = 2437
end type

event clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_sal_01700_popup
integer x = 2089
end type

event p_inq::clicked;call super::clicked;String sDatef, sDatet

If dw_ip.AcceptText() <> 1 Then Return 1

sDatef = Trim(dw_ip.GetItemString(1,'sdatef'))
sDatet = Trim(dw_ip.GetItemString(1,'sdatet'))
dw_ip.SetFocus()
If f_datechk(sDatef) <> 1  then
	f_message_chk(35,'')
	dw_ip.SetColumn('sdatef')
	Return 
End If

If f_datechk(sDatet) <> 1  then
	f_message_chk(35,'')
	dw_ip.SetColumn('sdatet')
	Return 
End If

dw_1.Retrieve(gs_sabu,sDatef, sDatet)
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type p_choose from w_inherite_popup`p_choose within w_sal_01700_popup
integer x = 2263
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "ofno")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_sal_01700_popup
integer x = 50
integer y = 212
integer width = 2555
integer height = 1480
integer taborder = 20
string dataobject = "d_sal_01700_popup"
end type

event dw_1::clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag = False
END IF

CALL SUPER ::CLICKED

end event

event dw_1::doubleclicked;IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code= dw_1.GetItemString(Row, "ofno")

Close(Parent)
end event

type sle_2 from w_inherite_popup`sle_2 within w_sal_01700_popup
boolean visible = false
integer x = 1170
integer y = 2100
integer width = 1138
integer taborder = 0
boolean enabled = false
end type

event sle_2::getfocus;f_toggle_kor(Handle(this))

end event

type cb_1 from w_inherite_popup`cb_1 within w_sal_01700_popup
boolean visible = false
integer x = 1550
integer y = 2000
end type

event cb_1::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "ofno")

Close(Parent)

end event

type cb_return from w_inherite_popup`cb_return within w_sal_01700_popup
boolean visible = false
integer x = 2181
integer y = 2000
end type

event cb_return::clicked;call super::clicked;//SetNull(gs_gubun)
//SetNull(gs_code)
//SetNull(gs_codename)
//
//Close(Parent)
end event

type cb_inq from w_inherite_popup`cb_inq within w_sal_01700_popup
boolean visible = false
integer x = 1870
integer y = 2000
boolean default = false
end type

event cb_inq::clicked;call super::clicked;//String sDatef, sDatet
//
//If dw_ip.AcceptText() <> 1 Then Return 1
//
//sDatef = Trim(dw_ip.GetItemString(1,'sdatef'))
//sDatet = Trim(dw_ip.GetItemString(1,'sdatet'))
//dw_ip.SetFocus()
//If f_datechk(sDatef) <> 1  then
//	f_message_chk(35,'')
//	dw_ip.SetColumn('sdatef')
//	Return 
//End If
//
//If f_datechk(sDatet) <> 1  then
//	f_message_chk(35,'')
//	dw_ip.SetColumn('sdatet')
//	Return 
//End If
//
//dw_1.Retrieve(gs_sabu,sDatef, sDatet)
//	
//dw_1.SelectRow(0,False)
//dw_1.SelectRow(1,True)
//dw_1.ScrollToRow(1)
//dw_1.SetFocus()
//
//
end event

type sle_1 from w_inherite_popup`sle_1 within w_sal_01700_popup
boolean visible = false
integer x = 681
integer y = 2100
integer width = 471
integer taborder = 0
integer limit = 11
end type

type st_1 from w_inherite_popup`st_1 within w_sal_01700_popup
boolean visible = false
integer x = 160
integer y = 2116
integer width = 494
string text = "C.INVOICE No."
end type

type dw_ip from u_key_enter within w_sal_01700_popup
integer x = 32
integer y = 44
integer width = 1335
integer height = 152
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_sal_01700_popup1"
boolean border = false
end type

event itemchanged;String sNull, sIoCustArea, sDept, sIoCust, sIoCustName

SetNull(sNull)

Choose Case GetColumnName()
   // 시작일자 유효성 Check
	Case "sdatef"  
		if f_DateChk(Trim(this.getText())) = -1 then
			f_Message_Chk(35, '[시작일자]')
			this.SetItem(1, "sdatef", sNull)
			return 1
		end if
		
	// 끝일자 유효성 Check
   Case "sdatet"
		if f_DateChk(Trim(this.getText())) = -1 then
			this.SetItem(1, "sdatet", sNull)
			f_Message_Chk(35, '[종료일자]')
			return 1
		end if
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
		this.SetItem(1,"custname",  sIoCustName)
	END IF
/* 거래처명 */
 Case "custname"
	sIoCustName = Trim(GetText())
	IF sIoCustName ="" OR IsNull(sIoCustName) THEN
		this.SetItem(1,"custcode",snull)
		Return
	END IF
	
	SELECT "VNDMST"."custcode", "VNDMST"."CVNAS2","VNDMST"."SAREA","SAREA"."STEAMCD"
  	  INTO :sIoCust, :sIoCustName, :sIoCustArea,	:sDept
	  FROM "VNDMST","SAREA" 
    WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVNAS2" = :sIoCustName;
	IF SQLCA.SQLCODE <> 0 THEN
		this.TriggerEvent(RbuttonDown!)
		Return 2
	ELSE
		SetItem(1,"custcode",  sIoCust)
		SetItem(1,"custname",  sIoCustName)
		Return
	END IF
end Choose

end event

event rbuttondown;String sIoCustName, sIoCustArea, sDept

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case GetColumnName()
/* 거래처 */
Case "custcode"
	gs_gubun = '2'
	Open(w_agent_popup)
	
	IF gs_code ="" OR IsNull(gs_code) THEN RETURN
	
	this.SetItem(1,"custcode",gs_code)
	
	SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
		INTO :sIoCustName,		:sIoCustArea,			:sDept
	   FROM "VNDMST","SAREA" 
   	WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
	IF SQLCA.SQLCODE = 0 THEN
	  this.SetItem(1,"custname",  sIoCustName)
	END IF
Case "custname"
	gs_codename = Trim(GetText())
	gs_gubun = '2'
	Open(w_agent_popup)
	
	IF gs_code ="" OR IsNull(gs_code) THEN RETURN
	
	this.SetItem(1,"custcode",gs_code)
	
	SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
		INTO :sIoCustName,		:sIoCustArea,			:sDept
	   FROM "VNDMST","SAREA" 
   	WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
	IF SQLCA.SQLCODE = 0 THEN
	  this.SetItem(1,"custname",  sIoCustName)
	END IF
End Choose

end event

event itemerror;return 1
end event

type rr_1 from roundrectangle within w_sal_01700_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 200
integer width = 2583
integer height = 1504
integer cornerheight = 40
integer cornerwidth = 55
end type

