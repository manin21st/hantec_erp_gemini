$PBExportHeader$w_sal_05570.srw
$PBExportComments$월 목표 대 일일실적 현황(거래처)
forward
global type w_sal_05570 from w_standard_print
end type
type pb_1 from u_pb_cal within w_sal_05570
end type
type rr_1 from roundrectangle within w_sal_05570
end type
end forward

global type w_sal_05570 from w_standard_print
string title = "월 목표 대 일일실적 현황(거래처)"
pb_1 pb_1
rr_1 rr_1
end type
global w_sal_05570 w_sal_05570

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sIlja, sym, syy, sAreaCode,sTeamCd,tx_name

dw_ip.AcceptText()

sIlja = Trim(dw_ip.GetItemString(1,'symd'))
sym   = Left(sIlja,6)
syy   = Left(sIlja,4)
sTeamCd     = Trim(dw_ip.GetItemString(1,'deptcode'))
sAreaCode   = Trim(dw_ip.GetItemString(1,'areacode'))

If IsNull(sTeamCd) Then sTeamCd = ''
If IsNull(sAreaCode) Then sAreaCode = ''

if	(sIlja='') or isNull(sIlja) then
	f_Message_Chk(35, '[기준년도]')
	dw_ip.setcolumn('symd')
	dw_ip.setfocus()
	Return -1
end if

dw_list.object.r_ymd.Text = Left(sIlja,4) + '.' + Mid(sIlja,5,2) + '.' + Right(sIlja,2)

if dw_print.Retrieve(gs_sabu, sIlja, sym, sTeamCd+'%',sAreaCode+'%', syy) < 1 then
   f_message_Chk(300, '[출력조건 CHECK]')
  	dw_ip.setcolumn('symd')
   dw_ip.setfocus()
  	return -1
end if

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(deptcode) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_list.Modify("txt_steam.text = '"+tx_name+"'")

   dw_print.sharedata(dw_list)
return 1
end function

on w_sal_05570.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_sal_05570.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.setitem(1,'symd',left(f_today(),8))
end event

type p_preview from w_standard_print`p_preview within w_sal_05570
end type

type p_exit from w_standard_print`p_exit within w_sal_05570
end type

type p_print from w_standard_print`p_print within w_sal_05570
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_05570
end type







type st_10 from w_standard_print`st_10 within w_sal_05570
end type



type dw_print from w_standard_print`dw_print within w_sal_05570
string dataobject = "d_sal_05570_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_05570
integer x = 73
integer y = 28
integer width = 1518
integer height = 332
string dataobject = "d_sal_05570_01"
end type

event dw_ip::itemchanged;String sCol_Name, sNull, sPrtGbn, sIoCustArea, sdept

//dw_Ip.AcceptText()
sCol_Name = This.GetColumnName()
SetNull(sNull)

Choose Case sCol_Name
	// 기준일자 유효성 Check
   Case "symd"
		if f_DateChk(Trim(this.getText())) = -1 then
			this.SetItem(1, "symd", sNull)
			f_Message_Chk(35, '[기준일자]')
			return 1
		end if
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
	Case 'prtgbn'
		sPrtGbn = Trim(GetText())
		
		dw_print.SetRedraw(False)
		/* 송장기준 */
		If sPrtGbn = '1' Then
			dw_list.DataObject = 'd_sal_055701'
			dw_print.DataObject = 'd_sal_055701_p'
			dw_list.SetTransObject(SQLCA)
		elseIf sPrtGbn = '3' Then
			dw_list.DataObject = 'd_sal_055702'
			dw_print.DataObject = 'd_sal_055702_p'
			dw_list.SetTransObject(SQLCA)
		Else
			dw_list.DataObject = 'd_sal_05570'
			dw_print.DataObject = 'd_sal_05570_p'
			dw_list.SetTransObject(SQLCA)
		End If
		dw_print.SetTransObject(Sqlca)
		dw_print.SetRedraw(True)
end Choose

end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_sal_05570
integer x = 87
integer y = 376
integer width = 4512
integer height = 1920
string dataobject = "d_sal_05570"
boolean border = false
boolean hsplitscroll = false
end type

event dw_list::itemchanged;sle_msg.text = "출력조건을 입력하고 조회버턴을 누르세요"
end event

type pb_1 from u_pb_cal within w_sal_05570
integer x = 763
integer y = 64
integer height = 80
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('symd')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'symd', gs_code)

end event

type rr_1 from roundrectangle within w_sal_05570
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 78
integer y = 368
integer width = 4535
integer height = 1940
integer cornerheight = 40
integer cornerwidth = 55
end type

