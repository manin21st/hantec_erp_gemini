$PBExportHeader$w_pig5010.srw
$PBExportComments$교육계획 등록
forward
global type w_pig5010 from w_inherite_standard
end type
type gb_5 from groupbox within w_pig5010
end type
type pb_1 from picturebutton within w_pig5010
end type
type pb_2 from picturebutton within w_pig5010
end type
type dw_personal from u_d_select_sort within w_pig5010
end type
type uo_progress from u_progress_bar within w_pig5010
end type
type dw_total from u_d_select_sort within w_pig5010
end type
type dw_gbn from u_key_enter within w_pig5010
end type
type dw_lst from u_d_popup_sort within w_pig5010
end type
type gb_4 from groupbox within w_pig5010
end type
type rr_1 from roundrectangle within w_pig5010
end type
type dw_mst from datawindow within w_pig5010
end type
type cbx_copy from checkbox within w_pig5010
end type
end forward

global type w_pig5010 from w_inherite_standard
string title = "교육계획 등록"
gb_5 gb_5
pb_1 pb_1
pb_2 pb_2
dw_personal dw_personal
uo_progress uo_progress
dw_total dw_total
dw_gbn dw_gbn
dw_lst dw_lst
gb_4 gb_4
rr_1 rr_1
dw_mst dw_mst
cbx_copy cbx_copy
end type
global w_pig5010 w_pig5010

type variables
//str_edu    istr_edu
//Y : 신규등록, N : 조회
string     is_gub, isEkind, isEDept, isEYear,isEdetail,isEduGbn, is_status


end variables

forward prototypes
public function integer wf_retot (string arg_no, string arg_date)
public function integer wf_required_chk ()
public function integer wf_update_education (long leduseq)
public subroutine wf_init ()
public function long wf_retrieve (integer irow, string stag)
public function long wf_no (string sempno)
public function long wf_date (string sdate, string edate)
public subroutine wf_reset ()
end prototypes

public function integer wf_retot (string arg_no, string arg_date);dw_total.setredraw(false)

dw_total.retrieve(gs_company, arg_no, isEdept,arg_date)

dw_total.setredraw(true)

return 1
end function

public function integer wf_required_chk ();String  sFromD,sToD,sEduDept,sEduDesc,sEduPlace
Integer iInwon,iPersonCnt

sFromD    = Trim(dw_mst.GetItemString(dw_mst.GetRow(),"restartdate"))
sToD      = Trim(dw_mst.GetItemString(dw_mst.GetRow(),"reenddate"))
sEduDept  = dw_mst.GetItemString(dw_mst.GetRow(),"edudept")
sEduDesc  = dw_mst.GetItemString(dw_mst.GetRow(),"edudesc")
sEduPlace = dw_mst.GetItemString(dw_mst.GetRow(),"eduarea")
iInwon    = dw_mst.GetItemNumber(dw_mst.GetRow(),"ekitainwon")

if sFromD = '' or IsNull(sFromD) then
	MessageBox('확 인','교육일자를 입력하시요.')
	dw_mst.SetColumn("restartdate")
	dw_mst.SetFocus()
	Return -1
end if
if sToD = '' or IsNull(sToD) then
	MessageBox('확 인','교육일자를 입력하시요.')
	dw_mst.SetColumn("reenddate")
	dw_mst.SetFocus()
	Return -1
end if
if sEduDept = '' or IsNull(sEduDept) then
	MessageBox('확 인','주관부서를 입력하시요.')
	dw_mst.SetColumn("edudept")
	dw_mst.SetFocus()
	Return -1
end if
if sEduDesc = '' or IsNull(sEduDesc) then
	MessageBox('확 인','교육내용을 입력하시요.')
	dw_mst.SetColumn("edudesc")
	dw_mst.SetFocus()
	Return -1
end if

if sEduPlace = '' or IsNull(sEduPlace) then
	MessageBox('확 인','교육장소를 입력하시요.')
	dw_mst.SetColumn("eduarea")
	dw_mst.SetFocus()
	Return -1
end if

if IsNull(iInwon) then
	MessageBox('확 인','외인원을 입력하시요.')
	dw_mst.SetColumn("ekitainwon")
	dw_mst.SetFocus()
	Return -1
end if

if  sFromD > sToD then
	MessageBox("확 인", "시작일자가 종료일자보다 클 수는 없습니다.")
	dw_mst.SetColumn("reenddate")
	dw_mst.SetFocus()
	Return -1
end if

iPersonCnt = dw_personal.RowCount()
if IsNull(iPersonCnt) then iPersonCnt = 0

if iInwon <> iPersonCnt then
	MessageBox('확 인', '외인원수와 참석사번의 수가 다릅니다. 확인하십시요.')
	dw_mst.SetColumn("ekitainwon")
	dw_mst.SetFocus()
	Return -1
end if

return 1

end function

public function integer wf_update_education (long leduseq);Integer  iFindRow,iInWon,k
String   sEmpNo

sEmpNo = dw_mst.GetItemString(1,"empno")
iInWon = dw_mst.GetItemNumber(1,"ekitainwon")

dw_personal.SetRedraw(False)
dw_personal.SetFilter("")
dw_personal.Filter()

if iInwon = 0 then
	iFindRow = dw_personal.Find("eduempno = '"+sEmpNo + "'",1,dw_personal.RowCount())
	if iFindRow <=0 then
		iFindRow = dw_personal.InsertRow(0)
		
		dw_personal.SetItem(iFindRow, "companycode", Gs_Company)
		dw_personal.SetItem(iFindRow, "eduyear",     isEyear)
		dw_personal.SetItem(iFindRow, "empseq",      lEduSeq)
		dw_personal.SetItem(iFindRow, "empno",       sEmpno)
		dw_personal.SetItem(iFindRow, "eduempno",    sEmpno)
	end if
	
	dw_personal.SetItem(iFindRow, "peduyear",    isEyear)  
	dw_personal.SetItem(iFindRow, "pempseq",     lEduSeq)     
	dw_personal.SetItem(iFindRow, "strtdate",    dw_mst.GetItemString(1,"restartdate"))
	dw_personal.SetItem(iFindRow, "enddate",     dw_mst.GetItemString(1,"reenddate"))
	
	dw_personal.SetItem(iFindRow, "restartdate", dw_mst.GetItemString(1,"restartdate"))
	dw_personal.SetItem(iFindRow, "reenddate",   dw_mst.GetItemString(1,"reenddate"))
	
	dw_personal.SetItem(iFindRow, "datesu",      dw_mst.GetItemNumber(1,"datesu"))
	dw_personal.SetItem(iFindRow, "starttime",   dw_mst.GetItemNumber(1,"starttime"))
	dw_personal.SetItem(iFindRow, "endtime",     dw_mst.GetItemNumber(1,"endtime"))
	dw_personal.SetItem(iFindRow, "ehour",       dw_mst.GetItemNumber(1,"ehour"))
	
	dw_personal.SetItem(iFindRow, "ekitainwon",  dw_mst.GetItemNumber(1,"ekitainwon"))
	
	dw_personal.SetItem(iFindRow, "egubn",       dw_mst.GetItemString(1,"egubn"))
	dw_personal.SetItem(iFindRow, "eoffice",     dw_mst.GetItemString(1,"eoffice"))
	dw_personal.SetItem(iFindRow, "ekind",       IsEkind)
	dw_personal.SetItem(iFindRow, "eduteacher",  dw_mst.GetItemString(1,"eduteacher"))
	dw_personal.SetItem(iFindRow, "edudepmant",  dw_mst.GetItemString(1,"edudepmant"))
	dw_personal.SetItem(iFindRow, "edugun",      dw_mst.GetItemString(1,"edugun"))
	dw_personal.SetItem(iFindRow, "eduarea",     dw_mst.GetItemString(1,"eduarea"))
	dw_personal.SetItem(iFindRow, "eduarea1",    dw_mst.GetItemString(1,"eduarea1"))
	dw_personal.SetItem(iFindRow, "edubook",     dw_mst.GetItemString(1,"edubook"))
	dw_personal.SetItem(iFindRow, "edubook1",    dw_mst.GetItemString(1,"edubook1"))
	dw_personal.SetItem(iFindRow, "edudesc",     dw_mst.GetItemString(1,"edudesc"))
	dw_personal.SetItem(iFindRow, "edudept",     dw_mst.GetItemString(1,"edudept"))
	dw_personal.SetItem(iFindRow, "eduamt",      dw_mst.GetItemNumber(1,"eduamt"))
	dw_personal.SetItem(iFindRow, "educur",     dw_mst.GetItemString(1,"educur"))
	dw_personal.SetItem(iFindRow, "deptcode",    IsEdept)	
else
	For k = 1 To dw_personal.RowCount()
		dw_personal.SetItem(k, "eduyear",     isEyear)
		dw_personal.SetItem(k, "empseq",      lEduSeq)
		
		dw_personal.SetItem(k, "peduyear",    isEyear)  
		dw_personal.SetItem(k, "pempseq",     lEduSeq)     
		dw_personal.SetItem(k, "strtdate",    dw_mst.GetItemString(1,"restartdate"))
		dw_personal.SetItem(k, "enddate",     dw_mst.GetItemString(1,"reenddate"))
		
		dw_personal.SetItem(k, "restartdate", dw_mst.GetItemString(1,"restartdate"))
		dw_personal.SetItem(k, "reenddate",   dw_mst.GetItemString(1,"reenddate"))
		
		dw_personal.SetItem(k, "datesu",      dw_mst.GetItemNumber(1,"datesu"))
		dw_personal.SetItem(k, "starttime",   dw_mst.GetItemNumber(1,"starttime"))
		dw_personal.SetItem(k, "endtime",     dw_mst.GetItemNumber(1,"endtime"))
		dw_personal.SetItem(k, "ehour",       dw_mst.GetItemNumber(1,"ehour"))
		
		dw_personal.SetItem(k, "ekitainwon",  dw_mst.GetItemNumber(1,"ekitainwon"))
		
		dw_personal.SetItem(k, "egubn",       dw_mst.GetItemString(1,"egubn"))
		dw_personal.SetItem(k, "eoffice",     dw_mst.GetItemString(1,"eoffice"))
		dw_personal.SetItem(k, "ekind",       IsEkind)
		dw_personal.SetItem(k, "eduteacher",  dw_mst.GetItemString(1,"eduteacher"))
		dw_personal.SetItem(k, "edudepmant",  dw_mst.GetItemString(1,"edudepmant"))
		dw_personal.SetItem(k, "edugun",      dw_mst.GetItemString(1,"edugun"))
		dw_personal.SetItem(k, "eduarea",     dw_mst.GetItemString(1,"eduarea"))
		dw_personal.SetItem(k, "eduarea1",    dw_mst.GetItemString(1,"eduarea1"))
		dw_personal.SetItem(k, "edubook",     dw_mst.GetItemString(1,"edubook"))
		dw_personal.SetItem(k, "edubook1",    dw_mst.GetItemString(1,"edubook1"))
		dw_personal.SetItem(k, "edudesc",     dw_mst.GetItemString(1,"edudesc"))
		dw_personal.SetItem(k, "edudept",     dw_mst.GetItemString(1,"edudept"))
		dw_personal.SetItem(k, "eduamt",      dw_mst.GetItemNumber(1,"eduamt"))
		dw_personal.SetItem(k, "educur",      dw_mst.GetItemString(1,"educur"))
		dw_personal.SetItem(k, "deptcode",    IsEdept)		
	Next
	/*대표사번 추가*/
	iFindRow = dw_personal.Find("eduempno = '"+sEmpNo + "'",1,dw_personal.RowCount())
	if iFindRow <=0 then
		iFindRow = dw_personal.InsertRow(0)
		
		dw_personal.SetItem(iFindRow, "companycode", Gs_Company)
		dw_personal.SetItem(iFindRow, "eduyear",     isEyear)
		dw_personal.SetItem(iFindRow, "empseq",      lEduSeq)
		dw_personal.SetItem(iFindRow, "empno",       sEmpno)
		dw_personal.SetItem(iFindRow, "eduempno",    sEmpno)
	end if
	
	dw_personal.SetItem(iFindRow, "peduyear",    isEyear)  
	dw_personal.SetItem(iFindRow, "pempseq",     lEduSeq)     
	dw_personal.SetItem(iFindRow, "strtdate",    dw_mst.GetItemString(1,"restartdate"))
	dw_personal.SetItem(iFindRow, "enddate",     dw_mst.GetItemString(1,"reenddate"))
	
	dw_personal.SetItem(iFindRow, "restartdate", dw_mst.GetItemString(1,"restartdate"))
	dw_personal.SetItem(iFindRow, "reenddate",   dw_mst.GetItemString(1,"reenddate"))
	
	dw_personal.SetItem(iFindRow, "datesu",      dw_mst.GetItemNumber(1,"datesu"))
	dw_personal.SetItem(iFindRow, "starttime",   dw_mst.GetItemNumber(1,"starttime"))
	dw_personal.SetItem(iFindRow, "endtime",     dw_mst.GetItemNumber(1,"endtime"))
	dw_personal.SetItem(iFindRow, "ehour",       dw_mst.GetItemNumber(1,"ehour"))
	
	dw_personal.SetItem(iFindRow, "ekitainwon",  dw_mst.GetItemNumber(1,"ekitainwon"))
	
	dw_personal.SetItem(iFindRow, "egubn",       dw_mst.GetItemString(1,"egubn"))
	dw_personal.SetItem(iFindRow, "eoffice",     dw_mst.GetItemString(1,"eoffice"))
	dw_personal.SetItem(iFindRow, "ekind",       IsEkind)
	dw_personal.SetItem(iFindRow, "eduteacher",  dw_mst.GetItemString(1,"eduteacher"))
	dw_personal.SetItem(iFindRow, "edudepmant",  dw_mst.GetItemString(1,"edudepmant"))
	dw_personal.SetItem(iFindRow, "edugun",      dw_mst.GetItemString(1,"edugun"))
	dw_personal.SetItem(iFindRow, "eduarea",     dw_mst.GetItemString(1,"eduarea"))
	dw_personal.SetItem(iFindRow, "eduarea1",    dw_mst.GetItemString(1,"eduarea1"))
	dw_personal.SetItem(iFindRow, "edubook",     dw_mst.GetItemString(1,"edubook"))
	dw_personal.SetItem(iFindRow, "edubook1",    dw_mst.GetItemString(1,"edubook1"))
	dw_personal.SetItem(iFindRow, "edudesc",     dw_mst.GetItemString(1,"edudesc"))
	dw_personal.SetItem(iFindRow, "edudept",     dw_mst.GetItemString(1,"edudept"))
	dw_personal.SetItem(iFindRow, "eduamt",      dw_mst.GetItemNumber(1,"eduamt"))
	dw_personal.SetItem(iFindRow, "educur",      dw_mst.GetItemString(1,"educur"))
	dw_personal.SetItem(iFindRow, "deptcode",    IsEdept)	
end if
if dw_personal.Update() <> 1 then
	MessageBox('확 인','자료저장을 실패하였습니다.')
	Return -1
end if

dw_personal.SetFilter("empno <> eduempno")
dw_personal.Filter()
dw_personal.SetRedraw(True)

return 1
end function

public subroutine wf_init ();Integer iRow

is_gub = 'I'

dw_mst.SetRedraw(False)
dw_mst.Reset()
iRow = dw_mst.InsertRow(0)

dw_mst.SetItem(iRow,"eduyear",       isEyear)
dw_mst.SetItem(iRow,"peduyear",      isEyear)
dw_mst.SetItem(iRow,"restartdate",   F_Today())
dw_mst.SetItem(iRow,"reenddate",     F_Today())
dw_mst.SetItem(iRow,"egubn",         dw_gbn.GetItemString(1,"egubn"))
dw_mst.SetItem(iRow,"ekind",         IsEkind)
dw_mst.SetItem(iRow,"sflag",         is_gub)
dw_mst.SetColumn("empno")
dw_mst.SetFocus()

dw_mst.SetRedraw(True)

wf_ReTot('999999', F_Today())

dw_personal.Reset()

end subroutine

public function long wf_retrieve (integer irow, string stag);String   sEmpNo,sEmpSeq
Integer  iFindrow

if iRow > 0 then
	sEmpNo  = dw_lst.GetItemString(iRow,"empno")
	sEmpSeq = dw_lst.GetItemString(iRow,"str_empseq")
end if

dw_lst.SetRedraw(False)
if sTag = 'A' then				/*전체 조회*/
	if dw_lst.Retrieve(IsEkind,IsEdept,IsEyear) <=0 then
		Wf_Init()
		dw_lst.SetRedraw(True)
		Return -1
	end if
	if iRow <=0 then
		sEmpNo  = dw_lst.GetItemString(1,"empno")
		sEmpSeq = dw_lst.GetItemString(1,"str_empseq")
	end if
end if

iFindrow = dw_lst.Find("empno = '"+sEmpNo+ "' and str_empseq = '"+sEmpSeq + "'",1,dw_lst.RowCount())

dw_lst.SelectRow(0,False)
dw_lst.SelectRow(iFindRow,True)

dw_lst.SetRedraw(True)
is_gub = 'M'

dw_mst.SetRedraw(False)
dw_mst.Retrieve(Gs_Company,dw_lst.GetItemString(iFindRow,"empno"),isEyear,dw_lst.GetItemNumber(iFindRow,"empseq"),isEkind)
dw_mst.SetRedraw(True)

Wf_Retot(dw_lst.GetItemString(iFindRow,"empno"), F_Today())

dw_personal.SetRedraw(False)
dw_personal.Retrieve(Gs_Company,dw_lst.GetItemString(iFindRow,"empno"),isEyear,dw_lst.GetItemNumber(iFindRow,"empseq"),isEkind)
dw_personal.SetFilter("eduempno <>  empno")
dw_personal.FilTer()
dw_personal.SetRedraw(True)

if sTag = 'P' then
	String sConFirm,sIsuGbn
	
	sConFirm = dw_lst.GetItemString(iFindRow,"confirm")
	sIsuGbn  = dw_lst.GetItemString(iFindRow,"isu")
	
	if sConFirm = "Y" OR sIsuGbn = 'Y' then
		if sConFirm = 'Y' then
			MessageBox("확 인", "총무 확인된 자료이므로 수정/삭제할 수 없습니다.")
		elseif sIsuGbn = 'Y' then
			MessageBox("확 인", "완료된 자료이므로 수정/삭제할 수 없습니다.")	
		end if
		p_del.enabled = False
		p_del.PictureName = "C:\erpman\image\삭제_d.gif"
		
		p_mod.enabled = False
		p_mod.PictureName = "C:\erpman\image\저장_d.gif"
		
		cbx_copy.Enabled = False
		cbx_copy.Checked = False	
			
		pb_1.enabled = False
		pb_2.enabled = False
	else
		p_del.enabled = True
		p_del.PictureName = "C:\erpman\image\삭제_up.gif"
		
		p_mod.enabled = True
		p_mod.PictureName = "C:\erpman\image\저장_up.gif"
		
		cbx_copy.Enabled = False
		cbx_copy.Checked = False	
			
		if isEduGbn = '1' then					/*사내교육*/
			pb_1.Enabled = True
			pb_2.Enabled = True
		else
			pb_1.Enabled = False
			pb_2.Enabled = False
		end if
	end if 															
end if

if isEdetail = 'Y' then			/*세부일정*/
	p_search.Enabled = True
	p_search.PictureName = "C:\erpman\image\세부일정등록_up.gif"
else
	p_search.Enabled = False
	p_search.PictureName = "C:\erpman\image\세부일정등록_d.gif"
end if
	
Return 1

end function

public function long wf_no (string sempno);Long  lSeq

select max(empseq)	into :lSeq
	from p5_educations_s
	where companycode = :Gs_Company and eduyear = :IsEyear ;
if sqlca.sqlcode = 0 then
	if IsNull(lSeq) then lSeq = 0
else
	lSeq = 0
end if
lSeq = lSeq + 1

return lSeq

end function

public function long wf_date (string sdate, string edate);string temp_date1, temp_date2
long ll_temp1

if isnull(sdate) or sdate = "" then return -1
if isnull(edate) or edate = "" then return -1

temp_date1 = string(left(sdate, 4) + "/"+ mid(sdate, 5,2) + "/" + &
				 right(sdate, 2))
temp_date2 = string(left(edate, 4) + "/"+ mid(edate, 5,2) + "/" + &
				 right(edate, 2))
ll_temp1 = 	daysafter(date(temp_date1), date(temp_date2)) + 1

return ll_temp1

end function

public subroutine wf_reset ();DataWindowChild  Dwc_Dept
String           sDeptCode

select dataname	into :sDeptCode		
	from p0_syscnfg where sysgu = 'P' and serial = '1' and lineno = '1';

if sDeptCode = Gs_Dept then					/*담당부서*/
	dw_gbn.GetChild("deptcode",Dwc_Dept)
	Dwc_Dept.SetTransObject(Sqlca)
	Dwc_Dept.Retrieve('%')
else
	dw_gbn.GetChild("deptcode",Dwc_Dept)
	Dwc_Dept.SetTransObject(Sqlca)
	Dwc_Dept.Retrieve(gs_dept)	
end if

dw_gbn.Reset()
dw_gbn.InsertRow(0)

if sDeptCode = Gs_Dept then					/*담당부서*/
	dw_gbn.Modify("deptcode.protect = 0")
	
	dw_gbn.SetColumn("deptcode")
	
	is_status = 'A'							
else
	Integer iCount
	
	select Count(*)	into :iCount from p0_dept
		where companycode = :gs_company and updept = :gs_dept and usetag = '1';
	if sqlca.sqlcode = 0 and iCount = 0 then				/*최하위부서*/
		dw_gbn.SetItem(1,"deptcode", Gs_Dept)
		dw_gbn.Modify("deptcode.protect = 1")
	else
		dw_gbn.Modify("deptcode.protect = 0")
		dw_gbn.SetItem(1,"deptcode", Gs_Dept)
	end if
	
	is_status = 'U'		
end if

end subroutine

on w_pig5010.create
int iCurrent
call super::create
this.gb_5=create gb_5
this.pb_1=create pb_1
this.pb_2=create pb_2
this.dw_personal=create dw_personal
this.uo_progress=create uo_progress
this.dw_total=create dw_total
this.dw_gbn=create dw_gbn
this.dw_lst=create dw_lst
this.gb_4=create gb_4
this.rr_1=create rr_1
this.dw_mst=create dw_mst
this.cbx_copy=create cbx_copy
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_5
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.pb_2
this.Control[iCurrent+4]=this.dw_personal
this.Control[iCurrent+5]=this.uo_progress
this.Control[iCurrent+6]=this.dw_total
this.Control[iCurrent+7]=this.dw_gbn
this.Control[iCurrent+8]=this.dw_lst
this.Control[iCurrent+9]=this.gb_4
this.Control[iCurrent+10]=this.rr_1
this.Control[iCurrent+11]=this.dw_mst
this.Control[iCurrent+12]=this.cbx_copy
end on

on w_pig5010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_5)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.dw_personal)
destroy(this.uo_progress)
destroy(this.dw_total)
destroy(this.dw_gbn)
destroy(this.dw_lst)
destroy(this.gb_4)
destroy(this.rr_1)
destroy(this.dw_mst)
destroy(this.cbx_copy)
end on

event open;call super::open;dw_gbn.SetTransObject(sqlca)
dw_lst.SetTransObject(sqlca)

dw_mst.SetTransObject(sqlca)

dw_total.SetTransObject(sqlca)
dw_personal.SetTransObject(sqlca)

Wf_Reset()

isEDept = Gs_Dept
isEYear = Left(F_Today(),4)

dw_gbn.SetItem(1,"deptcode", IsEDept)
dw_gbn.SetItem(1,"eduyear",  IsEYear)

dw_mst.reset()
dw_mst.insertrow(0)

uo_progress.Hide()

is_gub = 'I'

wf_retot('999999', F_Today())

dw_gbn.SetColumn("ekind")
dw_gbn.SetFocus()

ib_any_typing = False

cbx_copy.Enabled = False
cbx_copy.Checked = False

end event

type p_mod from w_inherite_standard`p_mod within w_pig5010
integer x = 3886
integer y = 16
integer taborder = 60
boolean enabled = false
string picturename = "C:\erpman\image\저장_d.gif"
end type

event p_mod::clicked;call super::clicked;Long  lEduSeq

if dw_mst.AcceptText() = -1 then return 
if dw_mst.GetRow() <=0 then Return

if Wf_Required_Chk() = -1 then Return

if is_Gub = 'I' then					/*입력*/
	lEduSeq = Wf_No(dw_mst.GetItemString(1,"empno"))	
	dw_mst.SetItem(1,"empseq",  lEduSeq)
else
	lEduSeq = dw_mst.GetItemNumber(1,"empseq")
end if

if f_msg_update() = -1 then return

if Wf_Update_Education(lEduSeq) = -1 then 
	Rollback;
	dw_personal.SetFilter("empno <> eduempno")
	dw_personal.Filter()
	dw_personal.SetRedraw(True)
	Return
else
	Commit;
	
	Wf_Retrieve(dw_lst.GetSelectedRow(0),'A')
	
	is_gub = "M"
	ib_any_typing = false
end if

w_mdi_frame.sle_msg.text = '자료를 저장하였습니다.'

//ll_emp_empseq   =  dw_mst.GetItemNumber(1, 'empseq')
//
//int i, ll_irow
//
//ll_irow = dw_personal.rowcount()
//
//if ll_irow > 0 then 
//   uo_progress.Show()	
//	for i = 1 to ll_irow
//		dw_personal.SetItem(i, 'companycode', ls_mst_company)
//		dw_personal.setItem(i, 'empseq', ll_emp_empseq)
//      if wf_totupdate(i) = -1 then 
//   		MessageBox("확 인", "참석차번 저장중 에러 발생" + dw_personal.GetItemString(i, 'eduempno'))			
//			EXIT
//		end if
//      ll_meterPosition = (i/ ll_irow) * 100		
//      uo_progress.uf_set_position (ll_meterPosition)		
//	next
//	
//	if dw_personal.update() <> 1 then
//		rollback using sqlca;
//		MessageBox("저장실패", "저장중 에러발생")
//
//	else
//		commit using sqlca;
//	end if
//   uo_progress.hide()	
//	
////	if dw_personal.update() <> 1 then
////		rollback using sqlca;
////		MessageBox("저장실패", "저장중 에러발생" + dw_personal.GetItemString(i, 'eduempno'))
////
////		return 
////	else
////		commit using sqlca;
////	end if
//end if
//
//ls_egubn = dw_mst.GetItemString(1, 'egubn')
//ll_ekitainwon = dw_mst.GetItemNumber(1, 'ekitainwon')
//
//
//if is_gub = "등록"  then
//	wf_reper(ls_emp_empno, ls_emp_eduyear, ll_emp_empseq)
//	wf_retot(ls_emp_empno, ls_emp_eduyear, ll_emp_empseq)
//else
//	if dw_personal.rowcount() <= 0 then
//		if dw_mst.update() <> 1 then
//			rollback using sqlca;
//			MessageBox("저장실패", "저장중 에러발생")
//		else
//			commit using sqlca;
//		end if
//	end if		
//end if
//// 교육구분 (1 : 사내, 2 : 사외)
////if ( ll_ekitainwon > 0 ) and ls_egubn = "1"  then       //사내면, 외인원이 0보다 크면
//	
////else
////	
////	DELETE FROM p5_educations_s
////	  WHERE companycode = :ls_mst_company AND
////			  empno = :ls_emp_empno AND 
////			  eduyear = :ls_emp_eduyear AND 
////			  empseq  = :ll_emp_empseq AND 
////			  eduempno <> :ls_emp_empno ; 
////	  if sqlca.sqlcode <> 0 then 
////		  rollback using sqlca;
////		  MessageBox("저장실패", "참석사번 삭제도중 오류발생!!")
////		  return
////	  end if	
////	  commit using sqlca;
////		dw_total.reset()	
////		dw_personal.reset()		
////	  
////end if
//
//
//// 이미 저장이 되었음을 나타냄
//w_mdi_frame.sle_msg.text = "자료가 저장되었습니다.!!"
//wf_init()
//if dw_total.rowcount() < 1 then
//	wf_retot('999999', left(f_today(),4), 0)
//end if
//is_gub = "조회"
//
//ib_any_typing = false
//
//dw_emp.enabled = false
//
//p_del.enabled = true
//p_ins.enabled = true
//
end event

type p_del from w_inherite_standard`p_del within w_pig5010
integer x = 4059
integer y = 16
integer taborder = 70
boolean enabled = false
string picturename = "C:\erpman\image\삭제_d.gif"
end type

event p_del::clicked;String  sEmpno,sConFirm,sIsuGbn
Long    lEduSeq

if dw_lst.GetSelectedRow(0) <=0 then
	MessageBox('확 인','삭제할 자료를 선택하십시요.')
	Return
end if

lEduSeq  = dw_lst.GetItemNumber(dw_lst.GetSelectedRow(0),"empseq")
sEmpno   = dw_lst.GetItemString(dw_lst.GetSelectedRow(0),"empno")
sConFirm = dw_lst.GetItemString(dw_lst.GetSelectedRow(0),"confirm")
sIsuGbn  = dw_lst.GetItemString(dw_lst.GetSelectedRow(0),"isu")

if sIsuGbn = "Y" then
	MessageBox("확 인", "총무 확인된 자료이므로 삭제할 수 없습니다.")			  
	Return
end if 															
if sIsuGbn = "Y" then
	MessageBox("확 인", "완료된 자료이므로 삭제할 수 없습니다.")							  
	return
end if 

if f_msg_delete() = -1 then return

delete from p5_educations_s
	where companycode = :Gs_Company and empno = :sEmpno and eduyear = :IsEyear and 
			empseq = :lEduSeq  ; 
if sqlca.sqlcode <> 0 then
	MessageBox('확 인','자료삭제를 실패하였습니다.')
	RollBack;
	Return
end if
Commit;

Wf_Retrieve(0,'A')

ib_any_typing = false		
w_mdi_frame.sle_msg.text = "자료를 삭제하였습니다.!!"


end event

type p_inq from w_inherite_standard`p_inq within w_pig5010
integer x = 3538
integer y = 16
integer taborder = 20
end type

event p_inq::clicked;
if dw_gbn.AcceptText() = -1 then Return
if dw_gbn.GetRow() <=0 then Return

IsEkind  = dw_gbn.GetItemString(1,"ekind")
IsEdept  = dw_gbn.GetItemString(1,"deptcode")
IsEyear  = dw_gbn.GetItemString(1,"eduyear")
isEduGbn = dw_gbn.GetItemString(1,"egubn")

if IsEkind = '' or IsNull(IsEkind) then
	MessageBox('확 인','교육종류를 입력하십시요.')
	dw_gbn.SetColumn("ekind")
	dw_gbn.SetFocus()
	Return
end if

if IsEdept = '' or IsNull(IsEdept) then
	MessageBox('확 인','부서/팀을 입력하십시요.')
	dw_gbn.SetColumn("deptcode")
	dw_gbn.SetFocus()
	Return
end if

if IsEyear = '' or IsNull(IsEyear) then
	MessageBox('확 인','교육년도를 입력하십시요.')
	dw_gbn.SetColumn("eduyear")
	dw_gbn.SetFocus()
	Return
end if

p_ins.Enabled = True
p_ins.PictureName = "C:\erpman\image\추가_up.gif"

p_mod.Enabled = True
p_mod.PictureName = "C:\erpman\image\저장_up.gif"

p_del.Enabled = True
p_del.PictureName = "C:\erpman\image\삭제_up.gif"

if Wf_Retrieve(0,'A') = -1 then 
//	MessageBox('확 인','조회한 자료가 없습니다.')
	Return
end if

is_gub = 'M'
ib_any_typing = False

if dw_lst.GetSelectedRow(0) > 0 then
	String sConFirm,sIsuGbn
	
	sConFirm = dw_lst.GetItemString(dw_lst.GetSelectedRow(0),"confirm")
	sIsuGbn  = dw_lst.GetItemString(dw_lst.GetSelectedRow(0),"isu")
	
	if sConFirm = "Y" OR sIsuGbn = 'Y' then
		if sConFirm = 'Y' then
			MessageBox("확 인", "총무 확인된 자료이므로 수정/삭제할 수 없습니다.")
		elseif sIsuGbn = 'Y' then
			MessageBox("확 인", "완료된 자료이므로 수정/삭제할 수 없습니다.")	
		end if
		p_del.enabled = False
		p_del.PictureName = "C:\erpman\image\삭제_d.gif"
		
		p_mod.enabled = False
		p_mod.PictureName = "C:\erpman\image\저장_d.gif"
		
		cbx_copy.Enabled = False
		cbx_copy.Checked = False	
			
		pb_1.enabled = False
		pb_2.enabled = False
	else
		p_del.enabled = True
		p_del.PictureName = "C:\erpman\image\삭제_up.gif"
		
		p_mod.enabled = True
		p_mod.PictureName = "C:\erpman\image\저장_up.gif"
		
		if isEduGbn = '1' then					/*사내교육*/
			pb_1.Enabled = True
			pb_2.Enabled = True
		else
			pb_1.Enabled = True
			pb_2.Enabled = True
		end if
	end if 	
else
	p_del.enabled = True
	p_del.PictureName = "C:\erpman\image\삭제_up.gif"
	
	p_mod.enabled = True
	p_mod.PictureName = "C:\erpman\image\저장_up.gif"
	
	if isEduGbn = '1' then					/*사내교육*/
		pb_1.Enabled = True
		pb_2.Enabled = True
	else
		pb_1.Enabled = True
		pb_2.Enabled = True
	end if
end if

end event

type p_print from w_inherite_standard`p_print within w_pig5010
boolean visible = false
integer x = 288
integer y = 3220
integer taborder = 0
end type

type p_can from w_inherite_standard`p_can within w_pig5010
integer x = 4233
integer y = 16
integer taborder = 80
end type

event p_can::clicked;call super::clicked;dw_lst.Reset()

Wf_Init()

wf_Retot('999999', F_Today())

p_ins.enabled = False
p_ins.PictureName = "C:\erpman\image\추가_d.gif"

p_del.enabled = False
p_del.PictureName = "C:\erpman\image\삭제_d.gif"

p_mod.enabled = True
p_mod.PictureName = "C:\erpman\image\저장_up.gif"

p_search.Enabled = False
p_search.PictureName = "C:\erpman\image\세부일정등록_d.gif"

pb_1.enabled = True
pb_2.enabled = True

cbx_copy.Enabled = False
cbx_copy.Checked = False	
	
ib_any_typing = false

w_mdi_frame.sle_msg.text = ""

end event

type p_exit from w_inherite_standard`p_exit within w_pig5010
integer x = 4407
integer y = 16
integer taborder = 90
end type

type p_ins from w_inherite_standard`p_ins within w_pig5010
integer x = 3712
integer y = 16
integer taborder = 30
boolean enabled = false
string picturename = "C:\erpman\image\추가_d.gif"
end type

event p_ins::clicked;call super::clicked;dw_lst.SelectRow(0,False)

Wf_Init()

wf_Retot('999999', F_Today())

p_ins.enabled = False
p_ins.PictureName = "C:\erpman\image\추가_d.gif"

p_mod.enabled = True
p_mod.PictureName = "C:\erpman\image\저장_up.gif"
		
ib_any_typing = True

if isEduGbn = '1' then					/*사내교육*/
	cbx_copy.Enabled = True
	cbx_copy.Checked = False	
	
	pb_1.Enabled = True
	pb_2.Enabled = True
else
	cbx_copy.Enabled = True
	cbx_copy.Checked = False
	
	pb_1.Enabled = True
	pb_2.Enabled = True
end if
		
w_mdi_frame.sle_msg.text = ""


end event

type p_search from w_inherite_standard`p_search within w_pig5010
boolean visible = false
integer x = 3223
integer y = 16
integer width = 306
integer taborder = 50
boolean enabled = false
boolean originalsize = true
string picturename = "C:\erpman\image\세부일정등록_d.gif"
end type

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\세부일정등록_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\세부일정등록_up.gif"
end event

event p_search::clicked;String   sConFirm,sIsuGbn
str_Edu  Istr_Edu

Istr_Edu.str_eduyear = IsEyear
Istr_Edu.str_empseq  = dw_lst.GetItemNumber(dw_lst.GetSelectedRow(0),"empseq")
Istr_Edu.str_empno   = dw_lst.GetItemString(dw_lst.GetSelectedRow(0),"empno")

if Istr_Edu.str_empseq = 0 or IsNull(Istr_Edu.str_empseq) then Return
if Istr_Edu.str_empno = '' or IsNull(Istr_Edu.str_empno) then Return


sConFirm = dw_lst.GetItemString(dw_lst.GetSelectedRow(0),"confirm")
sIsuGbn  = dw_lst.GetItemString(dw_lst.GetSelectedRow(0),"isu")
	
if sConFirm = 'Y' or sIsuGbn = 'Y' then
	Istr_Edu.str_mode = 'R'
	
	OpenWithParm(w_pig5010a,Istr_Edu)
else
	Istr_Edu.str_mode = 'I'
	
	OpenWithParm(w_pig5010a,Istr_Edu)
end if
end event

type p_addrow from w_inherite_standard`p_addrow within w_pig5010
boolean visible = false
integer x = 809
integer y = 3220
integer taborder = 0
end type

type p_delrow from w_inherite_standard`p_delrow within w_pig5010
boolean visible = false
integer x = 983
integer y = 3220
integer taborder = 0
end type

type dw_insert from w_inherite_standard`dw_insert within w_pig5010
boolean visible = false
integer x = 178
integer y = 2932
integer taborder = 0
end type

type st_window from w_inherite_standard`st_window within w_pig5010
boolean visible = false
integer x = 2272
integer y = 3004
integer taborder = 0
end type

type cb_exit from w_inherite_standard`cb_exit within w_pig5010
boolean visible = false
integer x = 1879
integer y = 3700
integer width = 375
integer height = 148
integer taborder = 0
end type

type cb_update from w_inherite_standard`cb_update within w_pig5010
boolean visible = false
integer x = 1495
integer y = 3524
integer width = 375
integer height = 148
integer taborder = 0
end type

type cb_insert from w_inherite_standard`cb_insert within w_pig5010
boolean visible = false
integer x = 1879
integer y = 3348
integer width = 375
integer height = 148
integer taborder = 0
string text = "보고서(&I)"
end type

type cb_delete from w_inherite_standard`cb_delete within w_pig5010
boolean visible = false
integer x = 1495
integer y = 3700
integer width = 375
integer height = 148
integer taborder = 0
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pig5010
boolean visible = false
integer x = 1495
integer y = 3348
integer width = 375
integer height = 148
integer taborder = 0
end type

type st_1 from w_inherite_standard`st_1 within w_pig5010
boolean visible = false
integer x = 105
integer y = 3004
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pig5010
boolean visible = false
integer x = 1879
integer y = 3524
integer width = 375
integer height = 148
integer taborder = 0
end type

type dw_datetime from w_inherite_standard`dw_datetime within w_pig5010
boolean visible = false
integer x = 2917
integer y = 3004
end type

type sle_msg from w_inherite_standard`sle_msg within w_pig5010
boolean visible = false
integer x = 434
integer y = 3004
end type

type gb_2 from w_inherite_standard`gb_2 within w_pig5010
boolean visible = false
integer x = 1458
integer y = 3264
integer width = 841
integer height = 668
end type

type gb_1 from w_inherite_standard`gb_1 within w_pig5010
boolean visible = false
integer x = 123
integer y = 2772
boolean enabled = false
end type

type gb_10 from w_inherite_standard`gb_10 within w_pig5010
boolean visible = false
integer x = 526
integer y = 2816
long backcolor = 32106727
boolean enabled = false
end type

type gb_5 from groupbox within w_pig5010
integer x = 3442
integer y = 1152
integer width = 1134
integer height = 1036
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "참석 인원"
end type

type pb_1 from picturebutton within w_pig5010
integer x = 3328
integer y = 1200
integer width = 101
integer height = 88
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\Erpman\image\next.gif"
alignment htextalign = left!
end type

event clicked;
String   sEmpno,sEmpName,sDeptName,sEduEmp
Integer  k, iSelectRow,iFindRow,iCurRow

dw_mst.AcceptText()
sEmpNo = dw_mst.GetItemString(1,"empno")

if isnull(sEmpNo) or trim(sEmpNo) = "" then 
	MessageBox("확 인", "대표사번을 입력하십시요.")
	dw_mst.SetColumn('empno')
	dw_mst.setfocus()
	return 
end if

If dw_total.getselectedrow(0) <= 0 Then 
	MessageBox("확 인", "사원을 선택하십시요.")
  	return
end if

Do While True
	iSelectRow = dw_total.GetSelectedRow(0)
	if iSelectRow <=0 then exit
	
	sEduEmp     = dw_total.GetItemString(iSelectRow, "p1_master_empno")
   sEmpName    = dw_total.GetItemString(iSelectRow, "p1_master_empname")
   sDeptName   = dw_total.GetItemString(iSelectRow, "p0_dept_deptname")
	
	iFindRow = dw_personal.Find("eduempno = '"+sEduEmp+"'",1,dw_personal.RowCount())
	if iFindrow <=0 then
		iCurRow = dw_personal.InsertRow(0)
		
		dw_personal.setitem(iCurRow, "companycode",       gs_company)
		dw_personal.setitem(iCurRow, "p1_master_empname", sEmpName)	 
		dw_personal.setitem(iCurRow, "deptname",          sDeptName)           	
		dw_personal.setitem(iCurRow, "eduempno",          sEduEmp)              
		dw_personal.setitem(iCurRow, "empno",             sEmpno)              
		
	end if
	
	dw_total.SelectRow(iSelectRow,False)
Loop

if dw_personal.RowCount() <=0 then
	dw_mst.SetItem(1,"ekitainwon", 0)
else
	dw_mst.SetItem(1,"ekitainwon", dw_personal.GetItemNumber(dw_personal.RowCount(),"educnt"))
end if
end event

type pb_2 from picturebutton within w_pig5010
integer x = 3328
integer y = 1308
integer width = 101
integer height = 88
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\Erpman\image\prior.gif"
alignment htextalign = left!
end type

event clicked;Integer  iSelectRow

Do While True
	iSelectRow = dw_personal.GetSelectedRow(0)
	if iSelectRow <=0 then exit
	
	dw_personal.DeleteRow(iSelectRow)
Loop

if dw_personal.RowCount() <=0 then
	dw_mst.SetItem(1,"ekitainwon", 0)
else
	dw_mst.SetItem(1,"ekitainwon", dw_personal.GetItemNumber(dw_personal.RowCount(),"educnt"))
end if

//String ls_code, ls_empno, ls_eduyear, ls_eduempno, ls_isu
//string sEmpNo, sEmpName, sDeptName
//Long   totRow , sRow, rowcnt, ll_empseq, ll_cnt
//int i
//
//
//if dw_mst.AcceptText() = -1 then return 
//
//ls_empno  = '999999'
//ls_eduyear = dw_mst.GetItemString(1, 'eduyear')
//ll_empseq = dw_mst.GetItemNumber(1, 'empseq')
//ls_isu = dw_mst.GetItemString(1, 'isu')
//
//if ls_isu = 'Y' then
//	MessageBox("확 인", "이미 이수처리가 되어 있으므로, " + "~n" + "~n" + &
//							  "자료를 수정할 수 없습니다.")
//   return 	
//end if
//
//sRow = dw_personal.getselectedrow(0)
//If sRow <= 0 Then
//  MessageBox("확인", "선택된 사원이 없습니다")
//  Return
//end if
//
//
//sRow = 0
//do while true
//	sRow = dw_personal.getselectedrow(0)
//	If sRow <= 0 Then	  Exit
//
//	sEmpNo      = dw_personal.GetItemString(sRow, "eduempno")
//   sEmpName    = dw_personal.GetItemString(sRow, "p1_master_empname")
//   sDeptName   = dw_personal.GetItemString(sRow, "deptname")
//	
//
//   rowcnt = dw_total.RowCount() + 1	
//	
//   dw_total.insertrow(rowcnt)	
//	
//	dw_total.setitem(rowcnt, "p1_master_empname", sEmpName)	 
//	dw_total.setitem(rowcnt, "p0_dept_deptname", sDeptName)   
//	dw_total.setitem(rowcnt, "p1_master_empno", sEmpNo)       
//	
//   
//	dw_personal.deleterow(sRow)
//  
//Loop
//
// SELECT count(*)   
// INTO :ll_cnt 
// FROM "P5_EDUCATIONS_S" 
// WHERE ( "P5_EDUCATIONS_S"."COMPANYCODE" = :gs_company )  AND 
//		 ( "P5_EDUCATIONS_S"."EMPNO" =  :ls_empno ) AND 
//		 ( "P5_EDUCATIONS_S"."EDUYEAR" = :ls_eduyear ) AND
//		 ( "P5_EDUCATIONS_S"."EMPSEQ" = :ll_empseq )  AND 
//		 ( "P5_EDUCATIONS_S"."EDUEMPNO" = :ls_empno ) ;
// if sqlca.sqlcode = 0 and ll_cnt > 0 then 
//		if dw_personal.update() <> 1 then 
//			MessageBox("확 인", "저장중 에러가 발생하였습니다.!!")
//			rollback using sqlca;
//			return 
//		end if
//		commit using sqlca;
//		wf_reper(ls_empno, ls_eduyear, ll_empseq)
//		wf_retot(ls_empno, ls_eduyear, ll_empseq)
//  end if 	
//
end event

type dw_personal from u_d_select_sort within w_pig5010
integer x = 3456
integer y = 1196
integer width = 1102
integer height = 976
integer taborder = 0
boolean bringtotop = true
string dataobject = "d_pig50105"
boolean hscrollbar = false
boolean border = false
end type

event clicked;If Row <= 0 then
	b_flag =True
ELSE
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

type uo_progress from u_progress_bar within w_pig5010
boolean visible = false
integer x = 873
integer y = 2640
integer width = 1083
integer height = 72
boolean bringtotop = true
end type

on uo_progress.destroy
call u_progress_bar::destroy
end on

type dw_total from u_d_select_sort within w_pig5010
integer x = 2199
integer y = 1196
integer width = 1083
integer height = 976
integer taborder = 0
string dataobject = "d_pig50104"
boolean hscrollbar = false
boolean border = false
end type

event clicked;If Row <= 0 then
	b_flag =True
ELSE
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

type dw_gbn from u_key_enter within w_pig5010
integer x = 55
integer y = 20
integer width = 2743
integer height = 144
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pig5010gbn"
boolean border = false
end type

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;String  sNull

SetNull(sNull)

if this.GetColumnName() = 'ekind' then
	IsEkind = this.GetText()
	if IsEkind = '' or IsNull(IsEkind) then Return
	
	select nvl(educationgbn,'1')into :isEduGbn
		from p0_education where educationcode = :IsEkind;
	if sqlca.sqlcode <> 0 then
		MessageBox('확 인','등록되지 않은 교육종류입니다.')
		this.SetItem(this.GetRow(),"ekind",sNull)
		Return 1
	end if
	this.SetItem(this.GetRow(),"egubn",isEduGbn)
	
	if isEduGbn = '1' then					/*사내교육*/
		pb_1.Enabled = True
		pb_2.Enabled = True
	else
		pb_1.Enabled = False
		pb_2.Enabled = False
	end if
	
	
end if

if this.GetColumnName() = 'eduyear' then
	IsEYear = this.GetText()
	if IsEYear = '' or IsNull(IsEYear) then Return
	
	if F_DateChk(IsEYear+'0101') = -1 then
		MessageBox('확 인','교육년도를 확인하십시요.')
		this.SetItem(this.GetRow(),"eduyear",sNull)
		Return 1
	end if
end if

if this.GetColumnName() = 'deptcode' then
	isEDept = this.GetText()	
end if


dw_lst.Reset()
Wf_Init()

p_inq.Triggerevent(Clicked!)
end event

type dw_lst from u_d_popup_sort within w_pig5010
integer x = 78
integer y = 184
integer width = 2062
integer height = 1988
integer taborder = 0
boolean bringtotop = true
string dataobject = "d_pig50103"
boolean vscrollbar = true
boolean border = false
end type

event clicked;call super::clicked;
if row <=0 then Return

this.SelectRow(0,   False)
this.SelectRow(Row, True)

Wf_Retrieve(Row,'P')
end event

type gb_4 from groupbox within w_pig5010
integer x = 2185
integer y = 1152
integer width = 1125
integer height = 1036
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "대상 인원"
end type

type rr_1 from roundrectangle within w_pig5010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 172
integer width = 2098
integer height = 2012
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_mst from datawindow within w_pig5010
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 2185
integer y = 180
integer width = 2409
integer height = 960
integer taborder = 40
string dataobject = "d_pig50102"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)

Return 1

end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event rbuttondown;
IF this.GetColumnName() ="empno" THEN
	SetNull(Gs_Code);		SetNull(Gs_CodeName);
	
	OpenWithParm(w_employee_dept_popup2,isEdept)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"empno",  Gs_Code)
   this.TriggerEvent(ItemChanged!)	
END IF

IF this.GetColumnName() ="edudept" THEN
	SetNull(Gs_Code);		SetNull(Gs_CodeName);
	
	Open(w_dept_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"edudept",gs_code)
   this.TriggerEvent(ItemChanged!)	
END IF

end event

event itemchanged;String  sEmpno,sEmpNm,sDept,sDeptNm,sGrade,sStart,sEnd,sStartTime,sEndTime,sOffice,sNull
Integer iDateSu

if this.GetColumnName() = 'empno'  then
	sEmpno = this.GetText()
	if sEmpno = '' or IsNull(sEmpNo) then
		this.SetItem(this.GetRow(),"empname",   sNull)
		this.SetItem(this.GetRow(),"deptcode",  sNull)
		this.SetItem(this.GetRow(),"gradecode", sNull)
		Return
	end if
	
	select a.empname, a.deptcode, a.gradecode	into :sEmpNm, :sDept, :sGrade
		from p1_master a, p0_dept b
		where a.companycode = b.companycode and a.deptcode = b.deptcode and
				a.empno = :sEmpNo and a.deptcode like :isEdept ;
	if sqlca.sqlcode <> 0 then
		MessageBox('확 인','해당부서의 사번이 아닙니다.확인하십시요.')
		this.SetItem(this.GetRow(),"empno",     sNull)
		this.SetItem(this.GetRow(),"empname",   sNull)
		this.SetItem(this.GetRow(),"deptcode",  sNull)
		this.SetItem(this.GetRow(),"gradecode", sNull)
		Return 1
	end if
	this.SetItem(this.GetRow(),"empname",   sEmpNm)
	this.SetItem(this.GetRow(),"deptcode",  sDept)
	this.SetItem(this.GetRow(),"gradecode", sGrade)
	
	Wf_Retot(sEmpNo,F_Today())
end if

if this.GetColumnName() ="restartdate"THEN
	sStart = Trim(this.GetText())
	if sStart = '' or IsNull(sStart) then Return
	
	if F_DateChk(sStart) = -1 then
		MessageBox("확 인", "유효한 날짜가 아닙니다.")
		this.SetItem(this.GetRow(),"restartdate",   sNull)
		Return 1
	end if
	
	sEnd = this.GetItemstring(this.GetRow(),"reenddate")
	if sEnd = '' or IsNull(sEnd) then Return
	
	this.SetItem(this.GetRow(),"datesu", Wf_Date(sStart,sEnd))
	
	this.AcceptText()
	this.setItem(this.GetRow(), 'ehour', this.GetItemNumber(this.GetRow(),"datesu") * this.GetItemNumber(this.GetRow(),"temp1")) 
end if

if this.GetColumnName() ="reenddate"THEN
	sEnd = Trim(this.GetText())
	if sEnd = '' or IsNull(sEnd) then Return
	
	if F_DateChk(sEnd) = -1 then
		MessageBox("확 인", "유효한 날짜가 아닙니다.")
		this.SetItem(this.GetRow(),"reenddate",   sNull)
		Return 1
	end if
	
	sStart = this.GetItemstring(this.GetRow(),"restartdate")
	if sStart = '' or IsNull(sStart) then Return
	
	this.SetItem(this.GetRow(),"datesu", Wf_Date(sStart,sEnd))
	
	this.AcceptText()
	this.setItem(this.GetRow(), 'ehour', this.GetItemNumber(this.GetRow(),"datesu") * this.GetItemNumber(this.GetRow(),"temp1")) 
end if

if this.GetColumnName() = 'datesu' then
	iDateSu = Integer(this.GetText())
	if iDateSu = 0 or IsNull(iDateSu) then Return
	
	this.setItem(this.GetRow(), 'ehour', iDateSu * this.GetItemNumber(this.GetRow(),"temp1")) 	
end if


IF this.GetColumnName() ="edudept"THEN
	sDept = Trim(this.GetText())
	if sDept = "" or isnull(sDept) then return
	
	select deptname  into :sDeptNm  from p0_dept 
		where companycode = :gs_company and	deptcode    = :sDept ;
	if sqlca.sqlcode <> 0 then
		MessageBox("확 인", "등록된 부서코드가 아닙니다.")
	   this.SetItem(this.GetRow(), 'edudept',   sNull)
		this.SetItem(this.GetRow(), 'edudeptnm', sNull)
		return 1
	end if
	this.SetItem(this.GetRow(), "edudeptnm",   sDeptnm)
END IF

if this.GetColumnName() = 'starttime' then
	sStartTime = this.GetText()
	if sStartTime = '' or IsNull(sStartTime) then Return
	
	if IsTime(string(long(sStartTime),'00:00')) = False then
		MessageBox('확 인','유효한 시간이 아닙니다.')
		this.SetItem(this.GetRow(), "starttime",   sNull)
		Return 1
	end if
	
	this.AcceptText()
	this.setItem(this.GetRow(), 'ehour', this.GetItemNumber(this.GetRow(),"datesu") * this.GetItemNumber(this.GetRow(),"temp1")) 
end if

if this.GetColumnName() = 'endtime' then
	sEndTime = this.GetText()
	if sEndTime = '' or IsNull(sEndTime) then Return
	
	if IsTime(string(long(sEndTime),'00:00')) = False then
		MessageBox('확 인','유효한 시간이 아닙니다.')
		this.SetItem(this.GetRow(), "endtime",   sNull)
		Return 1
	end if
	
	this.AcceptText()
	this.setItem(this.GetRow(), 'ehour', this.GetItemNumber(this.GetRow(),"datesu") * this.GetItemNumber(this.GetRow(),"temp1")) 
end if

if this.GetColumnName() = 'eoffice' then
	sOffice = this.GetText()
	if sOffice = '' or IsNull(sOffice) then Return
	
	if IsNull(F_Code_Select('교육기관',sOffice)) then
		MessageBox('확 인','등록된 교육기관이 아닙니다.')
		this.SetItem(this.GetRow(), "eoffice",   sNull)
		Return 1
	end if
end if


end event

event itemfocuschanged;Long wnd

wnd =Handle(this)

IF this.GetColumnName() ="eduteacher" OR this.GetColumnName() ="edudepmant" OR &
   this.GetColumnName() ="eduarea" OR this.GetColumnName() ="edubook" OR &
	this.GetColumnName() ="edubook1" or this.GetColumnName() ="edudesc" THEN
	f_toggle_kor(wnd)
ELSE
	f_toggle_eng(wnd)
END IF

end event

event editchanged;
ib_any_typing = True
end event

event itemerror;return 1
end event

event retrieverow;if row <=0 then return

this.SetItem(row,"sflag",'M')
end event

type cbx_copy from checkbox within w_pig5010
integer x = 2802
integer y = 92
integer width = 347
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "자료복사"
end type

event clicked;str_Edu  Istr_Edu
Integer  iDateSu, iInwon,iHour
Long     lStTime,lEdTime
String   sOffice,sEteacher,sEdudepmant,sEduDept,sEarea,sEBook, sEbook1,sEdesc
Double   dEduAmt

dw_gbn.AcceptText()
Istr_Edu.str_eduyear = IsEyear
Istr_Edu.str_egubn   = dw_gbn.GetItemString(1,"ekind")
Istr_Edu.str_dept    = dw_gbn.GetItemString(1,"deptcode")

OpenWithParm(w_pig5010b,Istr_Edu)

Istr_Edu = Message.PowerObjectParm

if Istr_Edu.str_flag = '0' then Return

select datesu,			ekitainwon,			starttime,			endtime,
		 ehour,			eoffice,				eduteacher,			edudepmant,
		 edudept,		eduarea,				edubook,				edubook1,			
		 edudesc,		eduamt
	into :iDateSu,		:iInwon,				:lStTime,			:lEdTime,
		  :iHour,		:sOffice,			:sETeacher,			:sEdudepmant,
		  :sEduDept,	:sEarea,				:sEBook,				:sEbook1,			
		  :sEdesc,		:dEduAmt
	from p5_educations_s
	where companycode = :Gs_Company and empno = :istr_edu.str_empno and
			eduyear = :istr_edu.str_eduyear and empseq = :istr_edu.str_empseq and
			empno = eduempno;
if sqlca.sqlcode = 0 then
	dw_mst.setItem(dw_mst.GetRow(),"restartdate", istr_edu.str_sdate)	
	dw_mst.setItem(dw_mst.GetRow(),"reenddate",   istr_edu.str_edate)	
	dw_mst.setItem(dw_mst.GetRow(),"datesu",      iDateSu)	
	dw_mst.setItem(dw_mst.GetRow(),"edudept",     sEduDept)
	dw_mst.setItem(dw_mst.GetRow(),"edudeptnm",   f_get_personlst('4',sEduDept,'%'))
	dw_mst.setItem(dw_mst.GetRow(),"edudesc",     sEdesc)
	dw_mst.setItem(dw_mst.GetRow(),"ekitainwon",  iInwon)
	dw_mst.setItem(dw_mst.GetRow(),"eduarea",  	 sEarea)
	dw_mst.setItem(dw_mst.GetRow(),"eoffice",  	 sOffice)
	dw_mst.setItem(dw_mst.GetRow(),"edubook",  	 sEBook)
	dw_mst.setItem(dw_mst.GetRow(),"edubook1",  	 sEBook1)
	dw_mst.setItem(dw_mst.GetRow(),"starttime",   lStTime)
	dw_mst.setItem(dw_mst.GetRow(),"endtime",     lEdTime)
	dw_mst.setItem(dw_mst.GetRow(),"ehour",     	 iHour)
	
	dw_mst.setItem(dw_mst.GetRow(),"eduteacher",  sETeacher)
	dw_mst.setItem(dw_mst.GetRow(),"edudepmant",  sEdudepmant)
	
	dw_mst.SetColumn("empno")
	dw_mst.SetFocus()
end if
end event

