$PBExportHeader$w_pm05_00160.srw
$PBExportComments$시간대별 실적현황
forward
global type w_pm05_00160 from w_standard_print
end type
type rr_1 from roundrectangle within w_pm05_00160
end type
end forward

global type w_pm05_00160 from w_standard_print
string title = "시간대별 실적현황"
rr_1 rr_1
end type
global w_pm05_00160 w_pm05_00160

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sYymm, sPdtgu, sJocod, sempno, sktcode, sdate, sGbn, stime, etime

If dw_ip.AcceptText() <> 1 Then Return -1

sPdtgu = Trim(dw_ip.GetItemString(1, 'pdtgu'))
sJocod = Trim(dw_ip.GetItemString(1, 'jocod'))
sEmpno = Trim(dw_ip.GetItemString(1, 'empno'))
//sktcode = Trim(dw_ip.GetItemString(1, 'ktcode'))
sDate  = Trim(dw_ip.GetItemString(1, 'jidat'))
sGbn	 = Trim(dw_ip.GetItemString(1, 'gbn'))

stime  = Trim(dw_ip.GetItemString(1, 'stime'))
etime  = Trim(dw_ip.GetItemString(1, 'etime'))

If IsNull(sPdtgu) Or sPdtgu = '' Then
	f_message_chk(1400,'[생산팀]')
	REturn -1
End If

If f_datechk(sDate) <> 1 Then
	f_message_chk(1400,'')
	REturn -1
End If

If IsNull(sJocod)  Then sJocod = ''
If IsNull(sEmpno)  Then sEmpno = ''
If IsNull(stime)  Then stime = '0000'
If IsNull(etime)  Then etime = '2359'

sDate = Left(sDate,4) + '-' + Mid(sDate,5,2) + '-' + Right(sDate,2)
stime = Left(stime,2) + '-' + Right(stime,2)
etime = Left(etime,2) + '-' + Right(etime,2)

//IF dw_print.Retrieve(gs_sabu, sDate, sPdtgu, sJocod+'%', sEmpno+'%', sGbn, sktcode) < 1 THEN
//	f_message_chk(50,'')
//	dw_ip.Setfocus()
//	return -1
//end if
// 주야구분 제외
IF dw_print.Retrieve(gs_sabu, sDate, sPdtgu, sJocod+'%', sEmpno+'%', sGbn,stime,etime) < 1 THEN
	f_message_chk(50,'')
	dw_ip.Setfocus()
	return -1
end if
dw_print.sharedata(dw_list)

// Argument 표시
String tx_name

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(pdtgu) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_pdtgu.text = '"+tx_name+"'")


tx_name = Trim(dw_ip.GetItemString(1, 'jonam'))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_jocod.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(gbn) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_time.text = '"+tx_name+"'")

//if sktcode = '.' then
//	dw_print.Modify("tx_ktcode.text = '주간'")
//else
//	dw_print.Modify("tx_ktcode.text = '야간'")
//end if

return 1
end function

on w_pm05_00160.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pm05_00160.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;//String sDate

//SELECT MAX(YYMMDD) INTO :sDate FROM PM02_WEEKPLAN_SUM;
//dw_ip.SetItem(1, 'yymm', is_today)

dw_ip.SetItem(1, 'jidat', is_today)
end event

type p_preview from w_standard_print`p_preview within w_pm05_00160
end type

type p_exit from w_standard_print`p_exit within w_pm05_00160
end type

type p_print from w_standard_print`p_print within w_pm05_00160
end type

type p_retrieve from w_standard_print`p_retrieve within w_pm05_00160
end type







type st_10 from w_standard_print`st_10 within w_pm05_00160
end type



type dw_print from w_standard_print`dw_print within w_pm05_00160
string dataobject = "d_pm05_00160_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pm05_00160
integer x = 46
integer y = 20
integer width = 3040
integer height = 224
string dataobject = "d_pm05_00160_1"
end type

event dw_ip::itemchanged;String sData, get_nm, sMatchk, sFilter,sNull,sName

Choose Case GetColumnName()
	
Case 'jocod'
		sData = this.gettext()
		 SELECT "JONAM"  
		 INTO :get_nm  
		 FROM "JOMAST"  
		WHERE "JOMAST"."JOCOD" = :sData;
		Select jonam into :sName From jomast
		Where jocod = :sData;
		if sqlca.sqlcode <> 0 then
		f_message_chk(33,'[반코드]')
			setitem(1, "jocod", sNull)
			setitem(1, "jonam", sNull)
			SetItem(1, 'jonam', get_nm)
			setcolumn("jocod")
			setfocus()
			Return 1					
		End if
		setitem(1, "jonam", sName)

	Case 'empno'
			sData = THIS.GetText()
		  SELECT "EMPNAME" INTO :get_nm FROM "P1_MASTER" WHERE "EMPNO" = :sData   ;
        
		  select empname into :sName from p1_master where empno = :sdata ;


		  If Sqlca.sqlcode = 0 then
			  this.setitem(1, "empname", get_nm)
		  End if
	Case 'matchk'
		sMatchk = GetText()
		
		Choose Case sMatchk
			Case '1'
				sFilter = "morout_emp_matchk = '1'"
			Case '2'
				sFilter = "morout_emp_matchk = '2'"
			Case Else
				sFilter = ""
		End Choose
		
		dw_print.SetFilter(sFilter)
		dw_print.Filter()
End Choose
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::rbuttondown;call super::rbuttondown;///////////////////////////////////////////////////////////////////////////
String sData, sname

setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

IF this.GetColumnName() = "jocod"	THEN
	
   gs_code = this.GetText()
	open(w_jomas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1, "jocod", 	 gs_Code)
	this.SetItem(1, "jonam", 	 gs_CodeName)
	RETURN 1
End If

IF this.GetColumnName() = "empno"	THEN
	
	sdata = this.getitemstring(1,'jocod')
				select dptno into :sname from jomast where jocod = :sdata ;
				if sqlca.sqlcode = 0 then gs_gubun = sname
	
   gs_code = this.GetText()
	open(w_sawon_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1, "empno", 	 gs_Code)
	this.SetItem(1, "empname",	 gs_CodeName)
	RETURN 1
End If

end event

type dw_list from w_standard_print`dw_list within w_pm05_00160
integer x = 73
integer y = 256
integer width = 4453
integer height = 2004
string dataobject = "d_pm05_00160_2"
boolean border = false
end type

event dw_list::rowfocuschanged;call super::rowfocuschanged;if currentrow > 0 then
	selectrow(0, false)
	selectrow(currentrow, true)
else
	selectrow(0, false)
end if

end event

type rr_1 from roundrectangle within w_pm05_00160
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 252
integer width = 4471
integer height = 2016
integer cornerheight = 40
integer cornerwidth = 55
end type

