$PBExportHeader$w_sal_05870.srw
$PBExportComments$거래처별 관리등급 현황
forward
global type w_sal_05870 from w_standard_print
end type
type dw_insert from datawindow within w_sal_05870
end type
end forward

global type w_sal_05870 from w_standard_print
string title = "거래처별 관리등급 현황"
long backcolor = 80859087
dw_insert dw_insert
end type
global w_sal_05870 w_sal_05870

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String	syear, sPyear, sSteam, sSarea, tx_name
Long     nRow

//////////////////////////////////////////////////////////////////
If dw_ip.accepttext() <> 1 Then Return 0

syear  = trim(dw_ip.getitemstring(1, 'syear'))
sSteam = trim(dw_ip.getitemstring(1, 'deptcode'))
sSarea = trim(dw_ip.getitemstring(1, 'areacode'))

IF	IsNull(syear) or syear = '' Then
	f_message_chk(1400,'[기준년월]')
	dw_ip.setcolumn('syear')
	dw_ip.setfocus()
	Return -1
END IF

sPyear = f_aftermonth(syear,-12)
If IsNull(sSteam) Then sSteam = ''
If IsNull(sSarea) Then sSarea = ''
////////////////////////////////////////////////////////////////
dw_list.SetRedraw(False)

string ls_silgu

SELECT DATANAME
INTO  :ls_silgu
FROM  SYSCNFG
WHERE SYSGU = 'S' AND SERIAL = '8' AND LINENO = '40' ;

nRow = dw_list.retrieve(gs_sabu, sPyear, sYear, sSteam+'%', sSarea+'%',ls_silgu)
If nRow < 1	Then
	f_message_chk(50,"")
	dw_ip.setcolumn('syear')
	dw_ip.setfocus()
	dw_list.SetRedraw(True)
	return -1
End if

Double dAmt, jumsu
Long   rCnt, ix, row
String sGrade

/* 판매금액 */
rCnt = dw_insert.Retrieve(gs_sabu, '1') /* 평가기준점수 */
dw_insert.SetSort('par_value D')
dw_insert.Sort()

For ix = 1 To dw_list.RowCount()
	dAmt = dw_list.GetItemNumber(ix,'maechul')
   row = dw_insert.Find("par_value < " + string(dAmt),1,Rcnt)
	
   If Rcnt > 0 and row > 0 Then
   	jumsu = dw_insert.GetItemNumber(row,'par_jumsu')
   Else
   	jumsu = 0
   End If
	dw_list.SetItem(ix,'jumsu1',jumsu)
Next

/* 총회전일 */
rCnt = dw_insert.Retrieve(gs_sabu, '2') /* 평가기준점수 */
dw_insert.SetSort('par_value')
dw_insert.Sort()

For ix = 1 To dw_list.RowCount()
	dAmt = dw_list.GetItemNumber(ix,'hoijunil')
   row = dw_insert.Find("par_value > " + string(dAmt),1,Rcnt)
	
   If Rcnt > 0 and row > 0 Then
   	jumsu = dw_insert.GetItemNumber(row,'par_jumsu')
   Else
   	jumsu = 0
   End If
	dw_list.SetItem(ix,'jumsu2',jumsu)
Next

/* 성장율 */
rCnt = dw_insert.Retrieve(gs_sabu, '3') /* 평가기준점수 */
dw_insert.SetSort('par_value D')
dw_insert.Sort()

For ix = 1 To dw_list.RowCount()
	dAmt = dw_list.GetItemNumber(ix,'sungj_rate')
   row = dw_insert.Find("par_value < " + string(dAmt*100),1,Rcnt)
	
   If Rcnt > 0 and row > 0 Then
   	jumsu = dw_insert.GetItemNumber(row,'par_jumsu')
   Else
   	jumsu = 0
   End If
	dw_list.SetItem(ix,'jumsu3',jumsu)
Next

/* 총점수 */
rCnt = dw_insert.Retrieve(gs_sabu, '4') /* 평가기준점수 */
dw_insert.SetSort('par_value D')
dw_insert.Sort()

For ix = 1 To dw_list.RowCount()
	dAmt = dw_list.GetItemNumber(ix,'total_jumsu')
   row = dw_insert.Find("par_value < " + string(dAmt),1,Rcnt)
	
	If dw_list.GetItemString(ix,'outgu') = '3' Then
		sGrade = 'E'
	Else
		If Rcnt > 0 and row > 0 Then
			sGrade = dw_insert.GetItemString(row,'par_grade')
		Else
			sGrade = ''
		End If
	End If
	dw_list.SetItem(ix,'mlevel',sGrade)
Next

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(deptcode) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_list.Modify("txt_steamcd.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(areacode) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_list.Modify("txt_sarea.text = '"+tx_name+"'")

dw_list.SetRedraw(True)

Return 1
end function

on w_sal_05870.create
int iCurrent
call super::create
this.dw_insert=create dw_insert
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_insert
end on

on w_sal_05870.destroy
call super::destroy
destroy(this.dw_insert)
end on

event open;call super::open;dw_insert.SetTransObject(sqlca)
dw_ip.SetItem(1,'syear',Left(f_today(),6))

sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 세로방향"

/* User별 관할구역 Setting */
String sarea, steam , saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
   dw_ip.Modify("areacode.protect=1")
	dw_ip.Modify("deptcode.protect=1")
	dw_ip.Modify("areacode.background.color = 80859087")
	dw_ip.Modify("deptcode.background.color = 80859087")
End If
dw_ip.SetItem(1, 'areacode', sarea)
dw_ip.SetItem(1, 'deptcode', steam)
end event

type p_preview from w_standard_print`p_preview within w_sal_05870
end type

type p_exit from w_standard_print`p_exit within w_sal_05870
end type

type p_print from w_standard_print`p_print within w_sal_05870
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_05870
end type







type st_10 from w_standard_print`st_10 within w_sal_05870
end type



type dw_print from w_standard_print`dw_print within w_sal_05870
end type

type dw_ip from w_standard_print`dw_ip within w_sal_05870
integer x = 37
integer y = 108
integer width = 745
integer height = 588
string dataobject = "d_sal_05870_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String  sNull, sIoCustArea, sDept

SetNull(snull)

Choose Case GetColumnName() 
	/* 영업팀 */
	Case "deptcode"
		SetItem(1,'areacode',sNull)
	/* 관할구역 */
	Case "areacode"
		sIoCustArea = this.GetText()
		IF sIoCustArea = "" OR IsNull(sIoCustArea) THEN RETURN
		
		SELECT "SAREA"."SAREA" ,"SAREA"."STEAMCD" 	INTO :sIoCustArea  ,:sDept
		  FROM "SAREA"  
		 WHERE "SAREA"."SAREA" = :sIoCustArea   ;
			
		SetItem(1,'deptcode',sDept)
END Choose

end event

type dw_list from w_standard_print`dw_list within w_sal_05870
integer x = 805
integer width = 2807
integer height = 2056
string dataobject = "d_sal_05870"
end type

event dw_list::retrievestart;This.SetRedraw(False)
end event

event dw_list::retrieveend;This.SetRedraw(True)
end event

type dw_insert from datawindow within w_sal_05870
boolean visible = false
integer x = 78
integer y = 2324
integer width = 2089
integer height = 360
integer taborder = 70
boolean bringtotop = true
string dataobject = "d_sal_05970"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

