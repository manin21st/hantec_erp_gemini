$PBExportHeader$w_sal_01710.srw
$PBExportComments$견적/판매 이력 조회
forward
global type w_sal_01710 from window
end type
type pb_2 from u_pb_cal within w_sal_01710
end type
type pb_1 from u_pb_cal within w_sal_01710
end type
type p_2 from uo_picture within w_sal_01710
end type
type p_ins from uo_picture within w_sal_01710
end type
type p_1 from uo_picture within w_sal_01710
end type
type dw_list from datawindow within w_sal_01710
end type
type dw_ip from u_key_enter within w_sal_01710
end type
type rr_1 from roundrectangle within w_sal_01710
end type
end forward

global type w_sal_01710 from window
integer x = 5
integer y = 224
integer width = 3689
integer height = 1880
boolean titlebar = true
string title = "견적/판매 이력 조회"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
pb_2 pb_2
pb_1 pb_1
p_2 p_2
p_ins p_ins
p_1 p_1
dw_list dw_list
dw_ip dw_ip
rr_1 rr_1
end type
global w_sal_01710 w_sal_01710

type variables
boolean b_flag
String  isSts
end variables

on w_sal_01710.create
this.pb_2=create pb_2
this.pb_1=create pb_1
this.p_2=create p_2
this.p_ins=create p_ins
this.p_1=create p_1
this.dw_list=create dw_list
this.dw_ip=create dw_ip
this.rr_1=create rr_1
this.Control[]={this.pb_2,&
this.pb_1,&
this.p_2,&
this.p_ins,&
this.p_1,&
this.dw_list,&
this.dw_ip,&
this.rr_1}
end on

on w_sal_01710.destroy
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.p_2)
destroy(this.p_ins)
destroy(this.p_1)
destroy(this.dw_list)
destroy(this.dw_ip)
destroy(this.rr_1)
end on

event open;String sDatef, sDatet, sItdsc, sIspec, sJijil

dw_ip.SetTransObject(sqlca)
dw_list.SetTransObject(sqlca)

dw_ip.InsertRow(0)

/* 견적만 조회할 경우 */
If gs_gubun = '1' Then
	dw_ip.SetItem(1, 'gubun', gs_gubun)
	dw_ip.Modify('gubun.protect = 1')
	p_ins.Enabled =True
	p_ins.PictureName ="C:\erpman\image\선택_up.gif"
	
	/* 견적상태 구분 */
	If gs_code <> '2' Then
		isSts = '%'
	Else
		isSts = '2'
	End If
/* 판매이력조회 */
ElseIf gs_gubun = '2' Then
	p_ins.Enabled = False
	p_ins.PictureName ="C:\erpman\image\선택_d.gif"
	dw_ip.SetItem(1, 'gubun', gs_gubun)
	
	dw_list.SetRedraw(False)
	dw_list.DataObject = 'd_sal_017102'
	dw_list.SetTransObject(sqlca)
	dw_list.SetRedraw(True)
	
	SELECT "ITDSC", "ISPEC", "JIJIL"
	  INTO :sItdsc, :sIspec, :sJijil
	  FROM "ITEMAS"
	 WHERE "ITNBR" = :gs_code ;
	
	IF SQLCA.SQLCODE = 0 THEN
		dw_ip.SetItem(1,"itnbr", gs_code)
		dw_ip.SetItem(1,"itdsc", sItdsc)
		dw_ip.SetItem(1,"ispec", sIspec)
		dw_ip.SetItem(1,"jijil", sJijil)
	End If		
Else
	p_ins.Enabled =True
	p_ins.PictureName ="C:\erpman\image\선택_up.gif"
	
	isSts = '%'
End If

select to_char(sysdate,'yyyymmdd'),to_char(sysdate-7,'yyyymmdd')
  into :sDateT, :sDateF
  from dual;
  
f_window_center_response(this)

dw_ip.SetItem(1,'frdate',sDatef)
dw_ip.SetItem(1,'todate',sDatet)

dw_ip.SetFocus()
dw_ip.SetColumn('frdate')

end event

type pb_2 from u_pb_cal within w_sal_01710
integer x = 1230
integer y = 48
integer height = 76
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('todate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'todate', gs_code)

end event

type pb_1 from u_pb_cal within w_sal_01710
integer x = 768
integer y = 48
integer height = 76
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('frdate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'frdate', gs_code)

end event

type p_2 from uo_picture within w_sal_01710
integer x = 3451
integer y = 24
integer width = 178
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

close(Parent)
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\닫기_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\닫기_dn.gif'
end event

type p_ins from uo_picture within w_sal_01710
integer x = 3273
integer y = 24
integer width = 178
string pointer = "C:\erpman\cur\choose.cur"
string picturename = "C:\erpman\image\선택_up.gif"
end type

event clicked;call super::clicked;Long ll_row

ll_Row = dw_list.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code		= dw_list.GetItemString(ll_Row, "ofno")
gs_codename = string(dw_list.GetItemNumber(ll_Row, "ofseq"))

Close(Parent)

end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\선택_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\선택_dn.gif'
end event

type p_1 from uo_picture within w_sal_01710
integer x = 3095
integer y = 24
integer width = 178
string pointer = "C:\erpman\cur\retrieve.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;String sFrdate, sTodate, sSarea, sCvcod, sItnbr, sIspec, sItdsc, sJijil, sIspecCode, sempno

If dw_ip.AcceptText() <> 1 Then Return 1

sFrdate = Trim(dw_ip.GetItemString(1,'frdate'))
sTodate = Trim(dw_ip.GetItemString(1,'todate'))
sSarea = Trim(dw_ip.GetItemString(1,'sarea'))
sCvcod = Trim(dw_ip.GetItemString(1,'custcode'))
sItnbr = Trim(dw_ip.GetItemString(1,'itnbr'))
sIspec = Trim(dw_ip.GetItemString(1,'ispec'))
sItdsc = Trim(dw_ip.GetItemString(1,'itdsc'))
sJijil = Trim(dw_ip.GetItemString(1,'jijil'))
sIspecCode = Trim(dw_ip.GetItemString(1,'ispec_code'))
sempno = Trim(dw_ip.GetItemString(1,'est_emp'))

If IsNull(sSarea) Then	sSarea = ''
If IsNull(sCvcod) Then	sCvcod = ''
If IsNull(sItnbr) Then	sItnbr = ''
If IsNull(sItdsc) Then	sItdsc = ''
If IsNull(sIspec) Then	sIspec = ''
If IsNull(sJijil) Then	sJijil = ''
If IsNull(sIspecCode) Then	sIspecCode = ''
If IsNull(sempno) Then	sempno = ''

dw_ip.SetFocus()
If f_DateChk(sFrdate) = -1 then
	f_Message_Chk(35, '[일자]')
	dw_ip.setcolumn("frdate")
	return -1
End If

If f_DateChk(sTodate) = -1 then
	f_Message_Chk(35, '[일자]')
	dw_ip.setcolumn("todate")
	return -1
End If

if dw_list.Retrieve(gs_sabu, sFrdate, sTodate, sSarea+'%', sCvcod+'%', sItnbr+'%', sItdsc+'%', sIspec+'%', sJijil+'%', sIspecCode+'%', isSts, sEmpNo+'%') < 1 then
	f_message_Chk(300, '[출력조건 CHECK]')
	dw_ip.setcolumn('frdate')
	dw_ip.setfocus()
	return -1
end if

return 1

end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\조회_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\조회_dn.gif'
end event

type dw_list from datawindow within w_sal_01710
integer x = 27
integer y = 420
integer width = 3611
integer height = 1328
integer taborder = 30
string dataobject = "d_sal_017101"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;If Row <= 0 then
	dw_list.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag = False
END IF
end event

event doubleclicked;/* 견적일 경우만 해당 */
If dw_ip.GetItemString(1, 'gubun') = '1' Then
	IF Row <= 0 THEN
		MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
		return
	END IF
	
	gs_code= dw_list.GetItemString(Row, "ofno")
	gs_codename= String(dw_list.GetItemNumber(Row, "ofseq"))
	
	Close(Parent)
End If
end event

type dw_ip from u_key_enter within w_sal_01710
integer x = 9
integer y = 12
integer width = 2830
integer height = 376
integer taborder = 20
string dataobject = "d_sal_01710"
boolean border = false
end type

event itemchanged;call super::itemchanged;String sOfDate, sNull, sGubun, sName, sGet_name, sIoCustArea
String sItnbr, sItdsc, sIspec, sJijil, sIspeccode
Int	 ireturn, nrow

SetNull(sNull)

nrow = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName()
	Case 'gubun'
		dw_list.SetRedraw(False)
		Choose Case GetText()
			Case '1'
				dw_list.DataObject = 'd_sal_017101'
			Case '2'
				dw_list.DataObject = 'd_sal_017102'
		End Choose
		dw_list.SetTransObject(sqlca)
		dw_list.SetRedraw(True)
	/* 일자 */
	Case "frdate", "todate"
		sOfDate = Trim(GetText())
		IF sOfDate ="" OR IsNull(sOfDate) THEN RETURN
		
		IF f_datechk(sOfDate) = -1 THEN
			f_message_chk(35,'[일자]')
			SetItem(1,GetColumnName(),snull)
			Return 1
		End If
	/* 고객 번호/거래처번호 */
	Case "custcode"
		sGubun = Trim(GetItemSTring(1, 'gubun'))

		sName = Trim(GetText())
		If sGubun = '1' Then
			IF sName ="" OR IsNull(sName) THEN
				setitem(1, 'custname', sNull)
				setitem(1, 'custcode', sNull)
				Return 1
			End If
			
			SELECT "CUST_NAME"  INTO :sGet_Name
			  FROM "CUSTOMER"
			 WHERE "CUST_NO" = :sName;
			
			IF SQLCA.SQLCODE = 0 THEN
				setitem(1, 'custname', left(sGet_Name, 20))
			Else
				setitem(1, 'custname', sNull)
				setitem(1, 'custcode', sNull)
				Return 1
			End If
		Else
			IF sName ="" OR IsNull(sName) THEN
				SetItem(1,"custname",snull)
				Return
			END IF
			
			SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA"
			  INTO :sGet_Name,		:sIoCustArea
			  FROM "VNDMST","SAREA" 
			 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :sName   ;
			IF SQLCA.SQLCODE <> 0 THEN
				TriggerEvent(RbuttonDown!)
				Return 2
			ELSE
				SetItem(1,"custname",  sGet_Name)
				SetItem(1,"sarea",  sIoCustArea)
			END IF
		End If
	/* 품번 */
	Case "itnbr"
		sItnbr = trim(GetText())
	
		ireturn = f_get_name4('품번', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		setitem(nRow, "itnbr", sitnbr)	
		setitem(nRow, "itdsc", sitdsc)	
		setitem(nRow, "ispec", sispec)
		setitem(nRow, "ispec_code", sispeccode)
		setitem(nRow, "jijil", sjijil)
		RETURN ireturn
End Choose
end event

event rbuttondown;call super::rbuttondown;String sGubun

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

sGubun = GetItemSTring(1,'gubun')

Choose Case GetColumnName()
	/* 고객번호 */
	Case "custcode"
		If sGubun = '1' Then
			Open(w_cust_popup)
			IF gs_code = "" OR IsNull(gs_code) THEN RETURN
			
			SetItem(1,"custcode", gs_code)
			SetItem(1,"custname", gs_codename)
		Else
			Open(w_vndmst_popup)
			IF gs_code = "" OR IsNull(gs_code) THEN RETURN
			
			SetItem(1,"custcode", gs_code)
			SetItem(1,"custname", gs_codename)
		End If
	/* 품번 */
	Case "itnbr"
		Open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,GetColumnName(),gs_code)
		SetFocus()
		SetColumn(GetColumnName())
		PostEvent(ItemChanged!)
End Choose
end event

event itemerror;call super::itemerror;Return 1
end event

type rr_1 from roundrectangle within w_sal_01710
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 408
integer width = 3630
integer height = 1348
integer cornerheight = 40
integer cornerwidth = 55
end type

