$PBExportHeader$w_pig2020_12.srw
$PBExportComments$교육복명서 출력
forward
global type w_pig2020_12 from w_standard_print
end type
type dw_plan from u_key_enter within w_pig2020_12
end type
end forward

global type w_pig2020_12 from w_standard_print
string title = "교육보고서"
dw_plan dw_plan
end type
global w_pig2020_12 w_pig2020_12

type variables
string    is_gub, Is_GwGbn = 'N'
Str_Edu   istr_edu
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();w_mdi_frame.sle_msg.text = ""

if dw_ip.AcceptText() = -1 then return -1
istr_edu.str_egubn = dw_ip.GetItemString(1,"ekind")
istr_edu.str_gbn   = dw_ip.GetItemString(1,"egubn")

if dw_plan.AcceptText() = -1 then return -1
istr_edu.str_empseq  = dw_plan.GetItemNumber(1,"empseq")
istr_edu.str_empno   = dw_plan.GetItemString(1,"empno")

if istr_edu.str_egubn = '' or IsNull(istr_edu.str_egubn) then
	MessageBox('확 인','교육종류를 입력하세요!')
	dw_ip.SetColumn("ekind")
	dw_ip.SetFocus()
	Return -1
end if
if istr_edu.str_empseq = 0 or IsNull(istr_edu.str_empseq) then
	MessageBox('확 인','순번을 입력하세요!')
	dw_plan.SetColumn("empseq")
	dw_plan.SetFocus()
	return -1
end if

if istr_edu.str_empno = '' or IsNull(istr_edu.str_empno) then
	MessageBox('확 인','사번을 입력하세요!')
	dw_plan.SetColumn("empno")
	dw_plan.SetFocus()
  	return -1
end if

dw_list.SetRedraw(false)
If dw_list.Retrieve(gs_company, istr_edu.str_eduyear, istr_edu.str_empseq, istr_edu.str_empno) < 1 then
   messagebox("자료 확인", "해당 자료가 없습니다.!", stopsign!)
	dw_list.InsertRow(0)
	dw_list.SetRedraw(true)
  	return -1
End if	

dw_list.SetRedraw(true)
return 1

w_mdi_frame.sle_msg.text = "자료가 조회되었습니다!!"
end function

on w_pig2020_12.create
int iCurrent
call super::create
this.dw_plan=create dw_plan
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_plan
end on

on w_pig2020_12.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_plan)
end on

event open;call super::open;istr_edu.str_dept = Gs_Dept
istr_edu.str_eduYear = Left(F_Today(),4)

dw_ip.SetItem(1,"deptcode", istr_edu.str_dept)
dw_ip.SetItem(1,"eduyear",  istr_edu.str_eduyear)
dw_ip.SetColumn("ekind")
dw_ip.SetFocus()

dw_plan.SetTransObject(Sqlca)
dw_plan.InsertRow(0)

dw_list.InsertRow(0)
end event

type p_preview from w_standard_print`p_preview within w_pig2020_12
integer x = 4082
end type

type p_exit from w_standard_print`p_exit within w_pig2020_12
integer x = 4430
end type

type p_print from w_standard_print`p_print within w_pig2020_12
integer x = 4256
end type

type p_retrieve from w_standard_print`p_retrieve within w_pig2020_12
integer x = 3909
end type

type st_window from w_standard_print`st_window within w_pig2020_12
integer x = 2706
integer y = 4484
end type

type sle_msg from w_standard_print`sle_msg within w_pig2020_12
integer x = 731
integer y = 4484
end type

type dw_datetime from w_standard_print`dw_datetime within w_pig2020_12
integer x = 3200
integer y = 4484
end type

type st_10 from w_standard_print`st_10 within w_pig2020_12
integer x = 370
integer y = 4484
end type

type gb_10 from w_standard_print`gb_10 within w_pig2020_12
integer x = 357
integer y = 4448
end type

type dw_print from w_standard_print`dw_print within w_pig2020_12
string dataobject = "d_pig2020_12"
end type

type dw_ip from w_standard_print`dw_ip within w_pig2020_12
integer x = 18
integer width = 2853
integer height = 148
string dataobject = "d_pig50301"
end type

event dw_ip::itemchanged;String  sNull

SetNull(sNull)

if this.GetColumnName() = 'ekind' then
	istr_edu.str_egubn = this.GetText()
	if istr_edu.str_egubn = '' or IsNull(istr_edu.str_egubn) then Return
	
	select nvl(educationgbn,'1')	into :istr_edu.str_gbn
		from p0_education where educationcode = :istr_edu.str_egubn;
	if sqlca.sqlcode <> 0 then
		MessageBox('확 인','등록되지 않은 교육종류입니다.')
		this.SetItem(this.GetRow(),"ekind",sNull)
		Return 1
	end if
	this.SetItem(this.GetRow(),"egubn",istr_edu.str_gbn)
end if

if this.GetColumnName() = 'eduyear' then
	istr_edu.str_eduYear = this.GetText()
	if istr_edu.str_eduYear = '' or IsNull(istr_edu.str_eduYear) then Return
	
	if F_DateChk(istr_edu.str_eduYear+'0101') = -1 then
		MessageBox('확 인','교육년도를 확인하십시요.')
		this.SetItem(this.GetRow(),"eduyear",sNull)
		Return 1
	end if
end if

end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_pig2020_12
integer x = 503
integer y = 472
integer width = 3520
integer height = 2080
string title = "교육보고서"
string dataobject = "d_pig2020_12"
end type

event dw_list::rowfocuschanged;//override
end event

event dw_list::clicked;//override
end event

type dw_plan from u_key_enter within w_pig2020_12
integer x = 18
integer y = 176
integer width = 4421
integer height = 280
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pig50302"
boolean border = false
end type

event itemchanged;call super::itemchanged;String   sDateF,sDateT,sProState,sEduDesc
Integer  iDateSu
Integer  iNull

SetNull(iNull);

w_mdi_frame.sle_msg.text =""

//IF this.GetColumnName() ="empseq" THEN
//	istr_edu.str_empseq = Long(this.GetText())
//	IF IsNull(istr_edu.str_empseq) OR istr_edu.str_empseq = 0 THEN Return
//	
//	istr_edu.str_empno = this.GetItemString(1,"empno")
//	if istr_edu.str_empno = '' or IsNull(istr_edu.str_empno) then Return
//	
//	if istr_edu.str_gbn = '1' then				/*사내이면*/
//		select distinct restartdate,  reenddate, 		eduamt, 		prostate,		edudesc
//			into :sDateF, 					:sDateT, 		:dEduAmt, 	:sProState,		:sEduDesc
//			from p5_educations_s
//			where companycode = :gs_company and empno  = :istr_edu.str_empno and
//					eduyear = :istr_edu.str_eduyear and empseq  = :istr_edu.str_empseq and
//					egubn   = :istr_edu.str_gbn ;
//	else
//		select restartdate,  reenddate, 		eduamt, 		prostate,		edudesc
//			into :sDateF, 		:sDateT, 		:dEduAmt, 	:sProState,		:sEduDesc
//			from p5_educations_s
//			where companycode = :gs_company and eduempno  = :istr_edu.str_empno and
//					eduyear = :istr_edu.str_eduyear and empseq  = :istr_edu.str_empseq and
//					egubn   = :istr_edu.str_gbn ;
//	end if
//	if sqlca.sqlcode = 0 then
//		if sProState = 'C' or sProState = 'R' then
//			MessageBox('확 인','진행중인 자료가 아니므로 복명서를 등록할 수 없습니다.')
//			this.SetItem(1,"empseq", iNull)
//			this.SetColumn("empseq")
//			return 1
//		end if
//		
//		this.SetItem(1, 'restartdate', sDateF)
//		this.SetItem(1, 'reenddate',   sDateT)
//		this.SetItem(1, 'eduamt',      deduamt)
//		this.SetItem(1, 'edudesc',   	 sEduDesc)
//		
//		dw_mst.SetItem(1, 'eduyear',   istr_edu.str_eduyear)
//		dw_mst.SetItem(1, 'empseq',    istr_edu.str_empseq)
//		dw_mst.SetItem(1, 'eduempno',  istr_edu.str_empno)
//		dw_mst.SetItem(1, 'startdate', sDateF)
//		dw_mst.SetItem(1, 'enddate',   sDateT)
//		
//		
//		dw_mst.SetColumn("startdate")
//		dw_mst.SetFocus()
//		
//		p_inq.TriggerEvent(Clicked!)	
//	end if	
//END IF
//
IF this.GetColumnName() ="empno" or this.GetColumnName() ="empname" or &
	this.GetColumnName() ="empseq" THEN
	istr_edu.str_empno = this.GetItemString(this.GetRow(),'empno')
	if istr_edu.str_empno = '' or IsNull(istr_edu.str_empno) then Return
	
	istr_edu.str_empseq = this.GetItemNumber(1,"empseq")
	IF IsNull(istr_edu.str_empseq) OR istr_edu.str_empseq = 0 THEN Return

		select restartdate,  reenddate, 		datesu, 		prostate,		edudesc
			into :sDateF, 		:sDateT, 		:iDateSu, 	:sProState,		:sEduDesc
			from p5_educations_s
			where companycode = :gs_company and eduempno  = :istr_edu.str_empno and
					eduyear = :istr_edu.str_eduyear and empseq  = :istr_edu.str_empseq and
					egubn   = :istr_edu.str_gbn ;

//	if sqlca.sqlcode = 0 then
//			MessageBox('확 인','진행중인 자료가 아니므로 복명서를 등록할 수 없습니다.')
//			this.SetItem(1,"empseq", iNull)
//			this.SetColumn("empseq")
//			return 1
//		end if
	
		this.SetItem(1, 'restartdate', sDateF)
		this.SetItem(1, 'reenddate',   sDateT)
		this.SetItem(1, 'datesu',      iDateSu)
		this.SetItem(1, 'edudesc',   	 sEduDesc)
//		
//		dw_mst.SetItem(1, 'eduyear',   istr_edu.str_eduyear)
//		dw_mst.SetItem(1, 'empseq',    istr_edu.str_empseq)
//		dw_mst.SetItem(1, 'eduempno',  istr_edu.str_empno)
//		dw_mst.SetItem(1, 'startdate', sDateF)
//		dw_mst.SetItem(1, 'enddate',   sDateT)
//		
//		dw_mst.SetColumn("startdate")
//		dw_mst.SetFocus()
//		
		p_retrieve.TriggerEvent(Clicked!)	

END IF
//
end event

event itemerror;call super::itemerror;Return 1
end event

event rbuttondown;call super::rbuttondown;dw_ip.AcceptText()
IF This.GetColumnName() = "empseq" THEN
	istr_edu.str_egubn = dw_ip.GetItemString(1,"ekind")
	
	openwithparm(w_pig5030_popup, istr_edu)
	
	istr_edu = Message.PowerObjectParm	     // return value

	if isNull(istr_edu.str_eduyear) or istr_edu.str_eduyear = '' then Return
	
	this.SetItem(this.GetRow(),"empseq",      istr_edu.str_empseq)
	this.SetItem(this.GetRow(),"empname",     istr_edu.str_empname)
	this.SetItem(this.GetRow(),"empno",       istr_edu.str_empno)
	this.TriggerEvent(ItemChanged!)
	Return
END IF

IF This.GetColumnName() = "empno" THEN
	istr_edu.str_egubn = dw_ip.GetItemString(1,"ekind")
	
	openwithparm(w_pig5030_popup, istr_edu)
	
	istr_edu = Message.PowerObjectParm	     // return value

	if isNull(istr_edu.str_eduyear) or istr_edu.str_eduyear = '' then Return
	
	this.SetItem(this.GetRow(),"empseq",      istr_edu.str_empseq)
	this.SetItem(this.GetRow(),"empname",     istr_edu.str_empname)
	this.SetItem(this.GetRow(),"empno",       istr_edu.str_empno)	
	this.TriggerEvent(ItemChanged!)
	Return
END IF

end event

