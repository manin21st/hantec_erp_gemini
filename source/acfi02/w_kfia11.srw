$PBExportHeader$w_kfia11.srw
$PBExportComments$어음수표책사용명세서 조회출력
forward
global type w_kfia11 from w_standard_print
end type
type rr_1 from roundrectangle within w_kfia11
end type
end forward

global type w_kfia11 from w_standard_print
string tag = "수표책사용명세"
integer x = 0
integer y = 0
string title = "어음수표책 사용명세서 "
rr_1 rr_1
end type
global w_kfia11 w_kfia11

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string schk_bnk, spur_date, spur_date2, schk_gu, suse_gu,sGubun

dw_ip.AcceptText()
sGubun     = dw_ip.GetItemString(1,"gubun")
spur_date  = Trim(dw_ip.GetitemString(1, "pur_date"))
spur_date2 = Trim(dw_ip.GetitemString(1, "pur_date2"))
schk_bnk   = Trim(dw_ip.GetitemString(1, "check_bnk"))
schk_gu    = Trim(dw_ip.GetitemString(1, "check_gu"))
suse_gu    = Trim(dw_ip.GetitemString(1, "use_gu"))

IF spur_date ="" OR ISNULL(spur_date) THEN
	F_MessageChk(1,'[일자]')
   dw_ip.SetColumn("pur_date")
   dw_ip.SetFocus()
   Return -1
END IF         
IF sGubun <> '3' THEN
	IF spur_date2 ="" OR ISNULL(spur_date2) THEN
		F_MessageChk(1,'[일자]')
		dw_ip.SetColumn("pur_date2")
		dw_ip.SetFocus()
		Return -1
	END IF         
END IF
IF sChk_Bnk = "" OR IsNull(sChk_Bnk) THEN sChk_Bnk = '%'
IF suse_gu ="" OR ISNULL(suse_gu) THEN suse_gu = '%'

setpointer(hourglass!)
IF dw_print.Retrieve(spur_date,spur_date2,schk_gu,schk_bnk,suse_gu,sGubun) <= 0  THEN
	f_messagechk(14,"")
	//dw_list.insertrow(0)
	return -1 
	
END IF
dw_print.sharedata(dw_list)
dw_ip.SetFocus()
setpointer(arrow!)

Return 1
end function

on w_kfia11.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kfia11.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;
dw_ip.SetRedraw(False)
   
dw_ip.InsertRow(0)
dw_ip.SetItem(dw_ip.GetRow(),"check_gu", '1')
dw_ip.SetItem(dw_ip.GetRow(),"pur_date", left(f_today(), 6) +"01")
dw_ip.SetItem(dw_ip.GetRow(),"pur_date2", f_today())
	
dw_ip.SetRedraw(True)
dw_ip.SetColumn("pur_date")
dw_ip.SetFocus()
end event

type p_preview from w_standard_print`p_preview within w_kfia11
end type

type p_exit from w_standard_print`p_exit within w_kfia11
end type

type p_print from w_standard_print`p_print within w_kfia11
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfia11
end type







type st_10 from w_standard_print`st_10 within w_kfia11
end type



type dw_print from w_standard_print`dw_print within w_kfia11
string dataobject = "d_kfia112_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfia11
integer x = 0
integer y = 0
integer width = 2126
integer height = 324
string dataobject = "d_kfia111"
end type

event dw_ip::itemchanged;String sNull

SetNull(sNull)
IF this.GetColumnName() = "gubun" THEN
	dw_list.SetRedraw(False)
	
	IF this.GetText() = '1' OR this.GetText() = '2' THEN											/*사용명세서*/
		dw_list.DataObject = 'd_kfia112'
	   dw_print.DataObject = 'd_kfia112_p'
   ELSE
		dw_list.DataObject = 'd_kfia113'
	   dw_print.DataObject = 'd_kfia113_p'
   END IF
	dw_list.SetRedraw(True)	
	dw_list.SetTransObject(Sqlca)
	dw_print.SetTransObject(Sqlca)
	dw_list.Reset()
END IF

IF this.GetColumnName() = "pur_date" THEN
	IF Trim(this.GetText()) = '' OR IsNull(Trim(this.GetText()) ) THEN Return
	
	IF F_DateChk(Trim(this.GetText())) = -1 THEN
		F_MessageChk(21,'')
		this.SetItem(this.GetRow(),"pur_date",sNull)
		Return 1
	END IF
	IF this.GetItemString(this.GetRow(),"gubun") = '3' THEN
		this.SetItem(this.GetRow(),"pur_date2",Trim(this.GetText()))
	END IF
END IF

IF this.GetColumnName() = "pur_date2" THEN
	IF Trim(this.GetText()) = '' OR IsNull(Trim(this.GetText()) ) THEN Return
	
	IF F_DateChk(Trim(this.GetText())) = -1 THEN
		F_MessageChk(21,'')
		this.SetItem(this.GetRow(),"pur_date2",sNull)
		Return 1
	END IF
END IF
end event

event dw_ip::itemerror;Return 1
end event

type dw_list from w_standard_print`dw_list within w_kfia11
integer x = 23
integer y = 348
integer width = 4562
integer height = 1964
string title = "수표책 사용명세서"
string dataobject = "d_kfia112"
boolean border = false
end type

type rr_1 from roundrectangle within w_kfia11
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 336
integer width = 4608
integer height = 2008
integer cornerheight = 40
integer cornerwidth = 55
end type

