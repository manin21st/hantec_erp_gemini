$PBExportHeader$w_bkcost10_00030.srw
$PBExportComments$ item별 사후 원가표
forward
global type w_bkcost10_00030 from w_standard_print
end type
type pb_1 from u_pb_cal within w_bkcost10_00030
end type
type pb_2 from u_pb_cal within w_bkcost10_00030
end type
type dw_1 from datawindow within w_bkcost10_00030
end type
type rr_1 from roundrectangle within w_bkcost10_00030
end type
type rr_2 from roundrectangle within w_bkcost10_00030
end type
type rr_3 from roundrectangle within w_bkcost10_00030
end type
end forward

global type w_bkcost10_00030 from w_standard_print
integer height = 2524
string title = "ITEM별 사후 원가표"
pb_1 pb_1
pb_2 pb_2
dw_1 dw_1
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
end type
global w_bkcost10_00030 w_bkcost10_00030

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();If dw_ip.AcceptText() = -1 Then Return -1

String sFryymm, sToyymm, tx_name, sMat, sInprcost, sOutprcost
Decimal{4} dRmat, dInprcost, dOutprcost

sFryymm  = Trim(dw_ip.GetItemString(1, 'fryymm'))
If sFryymm = '' or isNull(sFryymm) then
	f_Message_Chk(35, '[기준년월]')
	dw_ip.SetColumn('fryymm')
	Return 1
End If

sToyymm  = Trim(dw_ip.GetItemString(1, 'toyymm'))
If sToyymm = '' or isNull(sToyymm) then
	f_Message_Chk(35, '[기준년월]')
	dw_ip.SetColumn('toyymm')
	Return 1
End If

/* 조회 */
dw_list.SetRedraw(False)

IF dw_print.Retrieve(sFryymm, sToyymm) <= 0 THEN
	f_message_chk(50, '')
	dw_list.Reset()
	dw_ip.setcolumn('fryymm')
	dw_ip.setfocus()
	Return -1
END IF
			
dw_print.ShareData(dw_list)

tx_name = left(Trim(dw_ip.object.fryymm[1]),4) + "." + right(Trim(dw_ip.object.fryymm[1]),2)
dw_print.Modify("t_fryymm.text = '"+tx_name+"'")

tx_name = left(Trim(dw_ip.object.toyymm[1]),4) + "." + right(Trim(dw_ip.object.toyymm[1]),2)
dw_print.Modify("t_toyymm.text = '"+tx_name+"'")

SELECT TO_CHAR(INPUT_MAT,'9,999,999,999,999'), 
		 TO_CHAR(INPUT_IN_PRCOST,'9,999,999,999,999'), 
		 TO_CHAR(INPUT_OUT_PRCOST,'9,999,999,999,999')
INTO 	:sMat, 
		:sInprcost, 
		:sOutprcost
FROM BK_COST_PRODUCTION
WHERE YYMM_FR = :sFryymm 
AND YYMM_TO = :sToyymm;

tx_name = TRIM(sMat) + '원'
dw_print.Modify("t_mat.text = '"+tx_name+"'")

tx_name = TRIM(sInprcost) + '원'
dw_print.Modify("t_inprcost.text = '"+tx_name+"'")

tx_name = TRIM(sOutprcost) + '원'
dw_print.Modify("t_outprcost.text = '"+tx_name+"'")

dRmat = double(sMat)
dInprcost = double(sInprcost)
dOutprcost = double(sOutprcost)

dw_1.setitem(1,'mat_amt',dRmat)
dw_1.setitem(1,'iga_amt',dInprcost)
dw_1.setitem(1,'oga_amt',dOutprcost)

dw_list.SetRedraw(True)

Return 1
end function

on w_bkcost10_00030.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.dw_1=create dw_1
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.rr_1
this.Control[iCurrent+5]=this.rr_2
this.Control[iCurrent+6]=this.rr_3
end on

on w_bkcost10_00030.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.dw_1)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
end on

event open;call super::open;dw_ip.Reset()
dw_ip.Insertrow(0)

dw_ip.setitem(1,'fryymm',left(string(today(),'yyyymmdd'),6))
dw_ip.setitem(1,'toyymm',left(string(today(),'yyyymmdd'),6))

dw_1.Insertrow(0)

sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 가로방향"
end event

event ue_open;//
end event

type p_preview from w_standard_print`p_preview within w_bkcost10_00030
end type

type p_exit from w_standard_print`p_exit within w_bkcost10_00030
end type

type p_print from w_standard_print`p_print within w_bkcost10_00030
end type

type p_retrieve from w_standard_print`p_retrieve within w_bkcost10_00030
end type







type st_10 from w_standard_print`st_10 within w_bkcost10_00030
end type



type dw_print from w_standard_print`dw_print within w_bkcost10_00030
string dataobject = "d_bkcost_00030_2p"
end type

type dw_ip from w_standard_print`dw_ip within w_bkcost10_00030
integer x = 23
integer y = 52
integer width = 933
integer height = 96
string dataobject = "d_bkcost_00010_1"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String sIocust, sNull, sIoCustName , sCvcod, scvnas, sarea, steam, sSaupj, sName1

SetNull(sNull)

Choose Case GetColumnName()
	/* 거래처 */
	Case "custcode1"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"custname1",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'custcode1', sNull)
			SetItem(1, 'custname1', snull)
			Return 1
		ELSE		
			SetItem(1,"custname1", scvnas)
			setitem(1,'saupj',ssaupj)
		END IF
	/* 거래처명 */
	Case "custname1"
		scvnas = Trim(GetText())
		IF scvnas ="" OR IsNull(scvnas) THEN
			SetItem(1,"custcode1",snull)
			Return
		END IF
		
		If f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'custcode1', sNull)
			SetItem(1, 'custname1', snull)
			Return 1
		ELSE		
			SetItem(1,'custcode1', sCvcod)
			SetItem(1,"custname1", scvnas)
			setitem(1,'saupj',ssaupj)
			Return 1
		END IF
	/* 거래처2 */
	Case "custcode2"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"custname2",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'custcode2', sNull)
			SetItem(1, 'custname2', snull)
			Return 1
		ELSE		
			SetItem(1,"custname2", scvnas)
			setitem(1,'saupj',ssaupj)
		END IF
	/* 거래처명2 */
	Case "custname2"
		scvnas = Trim(GetText())
		IF scvnas ="" OR IsNull(scvnas) THEN
			SetItem(1,"custcode2",snull)
			Return
		END IF
		
		If f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'custcode2', sNull)
			SetItem(1, 'custname2', snull)
			Return 1
		ELSE		
			SetItem(1,'custcode2', sCvcod)
			SetItem(1,"custname2", scvnas)
			setitem(1,'saupj',ssaupj)
			Return 1
		END IF
End Choose
end event

event dw_ip::rbuttondown;string sIoCustName,sIoCustArea,sDept

SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case this.GetColumnName() 
	/* 거래처 */
   Case "custcode1", "custname1"
		gs_gubun = '1'
		If GetColumnName() = "custname1" then
			gs_codename = Trim(GetText())
		End If
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"custcode1",gs_code)
		SetColumn("custcode1")
		TriggerEvent(ItemChanged!)
	/* 거래처2 */
   Case "custcode2", "custname2"
		gs_gubun = '1'
		If GetColumnName() = "custname2" then
			gs_codename = Trim(GetText())
		End If
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"custcode2",gs_code)
		SetColumn("custcode2")
		TriggerEvent(ItemChanged!)
END Choose

end event

type dw_list from w_standard_print`dw_list within w_bkcost10_00030
integer x = 27
integer y = 200
integer width = 4571
integer height = 2092
string dataobject = "d_bkcost_00030_2"
boolean border = false
end type

event dw_list::retrievestart;This.SetRedraw(False)
end event

event dw_list::retrieveend;This.SetRedraw(True)
end event

type pb_1 from u_pb_cal within w_bkcost10_00030
boolean visible = false
integer x = 818
integer y = 48
integer height = 80
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('syymm1')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'syymm1', gs_code)

end event

type pb_2 from u_pb_cal within w_bkcost10_00030
boolean visible = false
integer x = 1298
integer y = 48
integer height = 80
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('syymm2')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'syymm2', gs_code)

end event

type dw_1 from datawindow within w_bkcost10_00030
integer x = 997
integer y = 52
integer width = 2853
integer height = 96
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_bkcost_00030_1"
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_bkcost10_00030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 192
integer width = 4594
integer height = 2116
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_bkcost10_00030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 14
integer y = 32
integer width = 951
integer height = 132
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_bkcost10_00030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 987
integer y = 32
integer width = 2894
integer height = 132
integer cornerheight = 40
integer cornerwidth = 55
end type

