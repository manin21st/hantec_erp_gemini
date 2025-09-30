$PBExportHeader$w_pm05_00135.srw
$PBExportComments$생산일지(dds)
forward
global type w_pm05_00135 from w_standard_print
end type
type pb_3 from u_pb_cal within w_pm05_00135
end type
type pb_1 from u_pb_cal within w_pm05_00135
end type
type rr_2 from roundrectangle within w_pm05_00135
end type
end forward

global type w_pm05_00135 from w_standard_print
string title = "생산 일지"
pb_3 pb_3
pb_1 pb_1
rr_2 rr_2
end type
global w_pm05_00135 w_pm05_00135

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sFrom, sTo, sPdtgu, sJocod, swkctr, sempno, smchno, sitnbr1, sitnbr2

If dw_ip.AcceptText() <> 1 Then Return -1

sFrom = Trim(dw_ip.GetItemString(1, 'pedat'))
If IsNull(sFrom) Or sFrom = '' Then
	f_message_chk(1400,'[실적일자]')
	Return -1
End If

sTo = Trim(dw_ip.GetItemString(1, 'pedatto'))
If IsNull(sTo) Or sTo = '' Then
	f_message_chk(1400,'[실적일자]')
	Return -1
End If

//sPdtgu = Trim(dw_ip.GetItemString(1, 'pdtgu'))
//If IsNull(sPdtgu) Or sPdtgu = '' Then
//	f_message_chk(1400,'[생산팀]')
//	Return -1
//End If

sJocod = Trim(dw_ip.GetItemString(1, 'jocod'))
If IsNull(sJocod) Then sJocod = ''

swkctr = Trim(dw_ip.GetItemString(1, 'wkctr'))
If IsNull(swkctr) Then swkctr = '%'

//sempno = Trim(dw_ip.GetItemString(1, 'empno'))
//If IsNull(sempno) Then sempno = '%'
//
//smchno = Trim(dw_ip.GetItemString(1, 'mchno'))
//If IsNull(smchno) Then smchno = '%'
//
swkctr = Trim(dw_ip.GetItemString(1, 'wkctr'))
If IsNull(swkctr) Then swkctr = '%'

sPdtgu = Trim(dw_ip.GetItemString(1,'pdtgu'))
IF sPdtgu = '' OR ISNULL(sPdtgu) THEN
	sPdtgu = '%'
ELSE
	sPdtgu = sPdtgu + '%'
END IF

sitnbr1 = Trim(dw_ip.GetItemString(1, 'sitnbr'))
If IsNull(sitnbr1) or sitnbr1 = '' Then sitnbr1 = '.'

sitnbr2 = Trim(dw_ip.GetItemString(1, 'eitnbr'))
If IsNull(sitnbr2) or sitnbr2 = '' Then sitnbr2 = 'ZZZZZZZZZZZZ'


//IF dw_print.Retrieve(sFrom, sTo, swkctr + '%', sJocod+'%', sitnbr1, sitnbr2,sPdtgu) < 1 THEN
IF dw_print.Retrieve(GS_SABU, sFrom, sTo, swkctr + '%', sJocod+'%',sPdtgu,sitnbr1,sitnbr2) < 1 THEN
	f_message_chk(50,'')
	dw_ip.Setfocus()
	return -1
end if

dw_print.sharedata(dw_list)

// Argument 표시
String tx_name

//tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(pdtgu) ', 1)"))
//If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_print.Modify("tx_pdtgu.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.GetItemString(1, 'jonam'))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_jocod.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.GetItemString(1, 'wkctr') + '  ' + dw_ip.GetItemString(1, 'wkctr'))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_wkctr.text = '"+tx_name+"'")

//tx_name = Trim(dw_ip.GetItemString(1, 'empno') + '  ' + dw_ip.GetItemString(1, 'empname'))
//If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_print.Modify("tx_empno.text = '"+tx_name+"'")
//
//tx_name = Trim(dw_ip.GetItemString(1, 'mchno') + '  ' + dw_ip.GetItemString(1, 'mchnam'))
//If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_print.Modify("tx_mchno.text = '"+tx_name+"'")

return 1
end function

on w_pm05_00135.create
int iCurrent
call super::create
this.pb_3=create pb_3
this.pb_1=create pb_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_3
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.rr_2
end on

on w_pm05_00135.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_3)
destroy(this.pb_1)
destroy(this.rr_2)
end on

event open;call super::open;

string ls_today

ls_today = f_today()

dw_ip.setitem(1, 'pedat', ls_today)
dw_ip.setitem(1, 'pedatto', ls_today)
end event

type p_preview from w_standard_print`p_preview within w_pm05_00135
end type

type p_exit from w_standard_print`p_exit within w_pm05_00135
end type

type p_print from w_standard_print`p_print within w_pm05_00135
end type

type p_retrieve from w_standard_print`p_retrieve within w_pm05_00135
end type







type st_10 from w_standard_print`st_10 within w_pm05_00135
end type



type dw_print from w_standard_print`dw_print within w_pm05_00135
integer x = 3630
integer y = 152
integer width = 137
integer height = 92
string dataobject = "d_pm05_00135_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pm05_00135
integer y = 12
integer width = 3264
integer height = 292
string dataobject = "d_pm05_00135_1"
end type

event dw_ip::rbuttondown;call super::rbuttondown;String sData, sname
long lrow

SetNull(gs_code)
SetNull(gs_codename)

Choose Case GetColumnName()
	 Case 'jocod'
			Open(w_jomas_popup)
			SetItem(1,'jocod',gs_code)
			SetItem(1,'jonam',gs_codename)
	 Case 'wkctr'
			open(w_workplace_popup)
			SetItem(1,'wkctr',gs_code)
			SetItem(1,'wcdsc',gs_codename)
	 Case 'empno'
			sdata = this.getitemstring(1,'jocod')
			select dptno into :sname from jomast where jocod = :sdata ;
			if sqlca.sqlcode = 0 then gs_gubun = sname
			open(w_sawon_popup)
			SetItem(1,'empno',gs_code)
			SetItem(1,'empname',gs_codename)
	 Case 'mchno'
			open(w_mchno_popup)
			SetItem(1,'mchno',gs_code)
			SetItem(1,'mchnam',gs_codename)
End Choose
end event

event dw_ip::itemerror;call super::itemerror;RETURN 1
end event

event dw_ip::itemchanged;call super::itemchanged;String sDate, sData, sNull,sName, sEitnbr

SetNull(sNull)

Choose Case GetColumnName()
	Case 'pedat', 'pedatto'
		sDate = Trim(GetText())
		
		If f_datechk(sDate) <> 1 Then
			f_message_chk(35,'')
			Return 1
		End If
	Case 'jocod'
		sData = this.gettext()
		Select jonam into :sName From jomast
		Where jocod = :sData;
		if sqlca.sqlcode <> 0 then
//	f_message_chk(33,'[반코드]')
			setitem(1, "jocod", sNull)
			setitem(1, "jonam", sNull)
			setcolumn("jocod")
			setfocus()
			Return 1					
		End if
		setitem(1, "jonam", sName)		
	Case 'wkctr'
		sData = this.gettext()
		select wcdsc into :sname from wrkctr
		 where wkctr = :sdata ;
		if sqlca.sqlcode <> 0 then
//			f_message_chk(33,'[작업장]')
			setitem(1, "wkctr", sNull)
			setitem(1, "wcdsc", sNull)
			setcolumn("wkctr")
			setfocus()
			Return 1					
		End if
		setitem(1, "wcdsc", sName)
	Case 'empno'
		sData = this.gettext()
		select empname into :sname from p1_master
		 where empno = :sdata ;
		if sqlca.sqlcode <> 0 then
			f_message_chk(33,'[작업자]')
			setitem(1, "empno", sNull)
			setitem(1, "empname", sNull)
			setcolumn("empno")
			setfocus()
			Return 1					
		End if
		setitem(1, "empname", sName)
	Case 'mchno'
		sData = this.gettext()
		select mchnam into :sname from mchmst
		 where mchno = :sdata ;
		if sqlca.sqlcode <> 0 then
			f_message_chk(33,'[설비]')
			setitem(1, "mchno", sNull)
			setitem(1, "mchnam", sNull)
			setcolumn("mchno")
			setfocus()
			Return 1					
		End if
		setitem(1, "mchnam", sName)
	Case 'sitnbr'
		sData = this.gettext()
 
      sEitnbr = dw_ip.GetItemString(1, 'eitnbr')
		if isNull(sEitnbr) or sEitnbr = "" then 
			setitem(1, "eitnbr", sData)
		End if
		
End Choose
end event

type dw_list from w_standard_print`dw_list within w_pm05_00135
integer x = 50
integer y = 344
integer width = 4558
string dataobject = "d_pm05_00135_2"
boolean border = false
end type

event dw_list::rowfocuschanged;call super::rowfocuschanged;if currentrow > 0 then
	selectrow(0, false)
	selectrow(currentrow, true)
else
	selectrow(0, false)
end if

end event

type pb_3 from u_pb_cal within w_pm05_00135
integer x = 759
integer y = 60
integer height = 76
integer taborder = 90
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('pedat')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'pedat', gs_code)

end event

type pb_1 from u_pb_cal within w_pm05_00135
integer x = 1225
integer y = 60
integer height = 76
integer taborder = 100
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('pedatto')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'pedatto', gs_code)

end event

type rr_2 from roundrectangle within w_pm05_00135
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 41
integer y = 336
integer width = 4581
integer height = 1984
integer cornerheight = 40
integer cornerwidth = 55
end type

