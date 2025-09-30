$PBExportHeader$wp_pif2560.srw
$PBExportComments$**결혼기념일 명단
forward
global type wp_pif2560 from w_standard_print
end type
type rr_2 from roundrectangle within wp_pif2560
end type
end forward

global type wp_pif2560 from w_standard_print
string title = "결혼기념일 명부"
rr_2 rr_2
end type
global wp_pif2560 wp_pif2560

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string	sDeptcode, sJikjong, sKunmu, sSaup, ArgBuf
string	StartDate
string	EndDate
Long		I,ToTalRow
String	sBirth1,sBirthday,YangBirth

dw_ip.AcceptText()

sDeptcode = dw_ip.GetItemString(1,"deptcode")
IF sDeptcode='' or isnull(sDeptcode) then sDeptcode = '%' 

StartDate = trim(dw_ip.GetItemString(1,"annifrom"))
EndDate   = trim(dw_ip.GetItemString(1,"annito"))
sJikjong	 = trim(dw_ip.GetItemString(1,"jikjong"))
sKunmu	 = trim(dw_ip.GetItemString(1,"kunmu"))
sSaup		 = trim(dw_ip.GetItemString(1,"saup"))

IF StartDate = ' ' THEN
	MessageBox("확 인","생일을 입력하세요!!")
	dw_ip.SetColumn("birthfrom")
	dw_ip.SetFocus()
	Return -1  
END IF 
IF EndDate = ' ' THEN
	MessageBox("확 인","생일을 입력하세요!!")
	dw_ip.SetColumn("birthto")
	dw_ip.SetFocus()
	Return -1  
END IF 

IF StartDate > EndDate THEN
	MessageBox("확 인","생일범위를 확인하세요!!")
	dw_ip.SetColumn("birthfrom")
	dw_ip.SetFocus()
	Return -1
END IF

IF sJikjong = '' or isnull(sJikjong) THEN
	sJikjong = '%'
	dw_print.modify("t_jikjong.text = '"+'전체'+"'")
ELSE
	SELECT "CODENM"
     INTO :ArgBuf
     FROM "P0_REF"
    WHERE ( "CODEGBN" = 'JJ') AND
          ( "CODE" <> '00' ) AND
			 ( "CODE" = :sJikjong);
	IF SQLCA.SQLCode = 0 THEN dw_print.modify("t_jikjong.text = '" + ArgBuf + "'")
END IF

IF sSaup = '' OR IsNull(sSaup) THEN
	sSaup = '%'
	dw_print.modify("t_saup.text = '"+'전체'+"'")
ELSE
	SELECT "SAUPNAME"
     INTO :ArgBuf
     FROM "P0_SAUPCD"
    WHERE ( "SAUPCODE" = :sSaup);
	IF SQLCA.SQLCode = 0 THEN dw_print.modify("t_saup.text = '" + ArgBuf + "'")
END IF

IF sKunmu = '' OR IsNull(sKunmu) THEN
	sKunmu = '%'
	dw_print.modify("t_kunmu.text = '"+'전체'+"'")
ELSE
	SELECT "KUNMUNAME"
     INTO :ArgBuf
     FROM "P0_KUNMU"
    WHERE ( "KUNMUGUBN" = :sKunmu);
	IF SQLCA.SQLCode = 0 THEN dw_print.modify("t_kunmu.text = '" + ArgBuf + "'")
END IF
//messagebox('',gs_company+','+sDeptcode+','+Startdate+','+Enddate+','+sJikjong+','+ sSaup+','+ sKunmu)
IF dw_print.Retrieve(gs_company,sDeptcode,Startdate,Enddate, sJikjong, sSaup, sKunmu) < 1 THEN
	MessageBox("확 인","조회한 자료가 없습니다!!")
	Return -1
END IF

dw_print.sharedata(dw_list)

Return 1
end function

on wp_pif2560.create
int iCurrent
call super::create
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
end on

on wp_pif2560.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
end on

event open;call super::open;string today

dw_datetime.settransobject(sqlca)
dw_list.settransobject(sqlca)

today = f_today()

dw_ip.SetItem(1,"annifrom",mid(today,5,2)+'01')
dw_ip.SetItem(1,"annito",right(f_last_date(left(today,6)),4))

w_mdi_frame.sle_msg.text = ''
//w_mdi_frame.sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 세로방향"
end event

type p_preview from w_standard_print`p_preview within wp_pif2560
integer x = 4069
string pointer = ""
end type

event p_preview::clicked;//string  sDeptcode, sabu
//string StartDate
//string EndDate,ls_gubun
//Long I,ToTalRow
//String sBirth1,sBirthday,YangBirth
//
//sDeptcode = dw_ip.GetItemString(1,"deptcode")
//IF sDeptcode='' or isnull(sDeptcode) then sDeptcode = '%' 
//
//StartDate = trim(dw_ip.GetItemString(1,"birthfrom"))
//EndDate   = trim(dw_ip.GetItemString(1,"birthto"))
//
//ls_gubun = '%' 
//sabu = '%'
//
//dw_print.Retrieve(gs_company,sDeptcode,Startdate,Enddate,ls_gubun, sabu) 
//
//
//ToTalRow = dw_print.RowCount()
//FOR I=1 TO dw_print.RowCount()
//	  sBirth1 = TRIM(dw_print.GetItemString(I,"birth1") )
//	  sBirthday = LEFT(gs_TODAY,4) + dw_print.GetItemString(I,"homebirthday")
//	  IF sBirth1 = '' OR ISNULL(sBirth1) THEN
//	  ELSE	
//
//           YangBirth = F_LUNTOSOL(sBirthday,FALSE,'') //윤달인 아닌경우
//			  
//			  if mid(sBirthday,5,2) > '10' and mid(YangBirth,5,2) <= '02' then
//				  sBirthday = left(f_aftermonth(gs_today,-1),4) + dw_print.GetItemString(I,"homebirthday")
//				  YangBirth = F_LUNTOSOL(sBirthday,FALSE,'')
//			  elseif YangBirth = '00.00.00' then
//				  sBirthday = f_afterday(sBirthday, -1)
//				  YangBirth = F_LUNTOSOL(sBirthday,FALSE,'')				  
//			  end if
//		     dw_print.SetItem(I,"birth2",right(YangBirth,4))
//
//	  END IF	  
//NEXT	
//
//
//dw_print.filter()
//dw_print.setsort('birth2 A')
//dw_print.sort()


OpenWithParm(w_print_preview, dw_print)	
end event

type p_exit from w_standard_print`p_exit within wp_pif2560
integer x = 4416
string pointer = ""
end type

type p_print from w_standard_print`p_print within wp_pif2560
integer x = 4242
string pointer = ""
end type

event p_print::clicked;//string  sDeptcode, sabu
//string StartDate
//string EndDate,ls_gubun
//Long I,ToTalRow
//String sBirth1,sBirthday,YangBirth
//
//sDeptcode = dw_ip.GetItemString(1,"deptcode")
//IF sDeptcode='' or isnull(sDeptcode) then sDeptcode = '%' 
//
//StartDate = trim(dw_ip.GetItemString(1,"birthfrom"))
//EndDate   = trim(dw_ip.GetItemString(1,"birthto"))
//
//ls_gubun = '%' 
//sabu = '%'
//
//dw_print.Retrieve(gs_company,sDeptcode,Startdate,Enddate,ls_gubun, sabu) 
//
//
//ToTalRow = dw_print.RowCount()
//FOR I=1 TO dw_print.RowCount()
//	  sBirth1 = TRIM(dw_print.GetItemString(I,"birth1") )
//	  sBirthday = LEFT(gs_TODAY,4) + dw_print.GetItemString(I,"homebirthday")
//	  IF sBirth1 = '' OR ISNULL(sBirth1) THEN
//	  ELSE	
//
//           YangBirth = F_LUNTOSOL(sBirthday,FALSE,'') //윤달인 아닌경우
//			  
//			  if mid(sBirthday,5,2) > '10' and mid(YangBirth,5,2) <= '02' then
//				  sBirthday = left(f_aftermonth(gs_today,-1),4) + dw_print.GetItemString(I,"homebirthday")
//				  YangBirth = F_LUNTOSOL(sBirthday,FALSE,'')
//			  elseif YangBirth = '00.00.00' then
//				  sBirthday = f_afterday(sBirthday, -1)
//				  YangBirth = F_LUNTOSOL(sBirthday,FALSE,'')				  
//			  end if
//		     dw_print.SetItem(I,"birth2",right(YangBirth,4))
//
//	  END IF	  
//NEXT	
//
//
//dw_print.filter()
//dw_print.setsort('birth2 A')
//dw_print.sort()


IF dw_print.rowcount() > 0 then 
	gi_page = dw_print.GetItemNumber(1,"last_page")
ELSE
	gi_page = 1
END IF
OpenWithParm(w_print_options, dw_print)

end event

type p_retrieve from w_standard_print`p_retrieve within wp_pif2560
integer x = 3895
string pointer = ""
end type

type st_window from w_standard_print`st_window within wp_pif2560
boolean visible = false
end type

type sle_msg from w_standard_print`sle_msg within wp_pif2560
boolean visible = false
end type

type dw_datetime from w_standard_print`dw_datetime within wp_pif2560
boolean visible = false
end type

type st_10 from w_standard_print`st_10 within wp_pif2560
boolean visible = false
end type

type gb_10 from w_standard_print`gb_10 within wp_pif2560
boolean visible = false
end type

type dw_print from w_standard_print`dw_print within wp_pif2560
integer x = 3744
integer y = 40
string dataobject = "d_pif2560_p"
end type

type dw_ip from w_standard_print`dw_ip within wp_pif2560
integer x = 1006
integer y = 12
integer width = 2432
integer height = 260
string dataobject = "d_pif2560_1"
end type

event dw_ip::itemchanged;call super::itemchanged;String  	sDeptCode,SetNull,sDeptName
Long		ll_len

AcceptText()

IF GetColumnName() = "deptcode" then
  sDeptCode = GetItemString(1,"deptcode")

	  IF sDeptCode = '' or isnull(sDeptCode) THEN
		  SetITem(1,"deptcode",SetNull)
		  SetITem(1,"deptname",SetNull)
	  ELSE	
	SELECT  "P0_DEPT"."DEPTNAME"  
		INTO :sDeptName
   	FROM "P0_DEPT"  
   	WHERE ( "P0_DEPT"."COMPANYCODE" = :gs_company ) AND  
     		   ( "P0_DEPT"."DEPTCODE" = :sDeptCode ); 
			 
			 IF SQLCA.SQLCODE<>0 THEN
				 MessageBox("확 인","사원번호를 확인하세요!!") 
				 SetITem(1,"deptcode",SetNull)
				 SetITem(1,"deptname",SetNull)
				 RETURN 1 
			 END IF
				SetITem(1,"deptname",sDeptName  )
				
	 END IF
END IF

IF GetColumnName() = "birthfrom" or GetColumnName() = "birthto" then

  ll_len = Len(Trim(GetItemString(1,GetColumnName())))
 
  IF ll_len <> 4 THEN
	  MessageBox("확인","생일범위를 다시입력하세요")
     Return -1
  END IF	
END IF
end event

event dw_ip::rbuttondown;call super::rbuttondown;SetNull(Gs_code)
SetNull(Gs_codename)

AcceptText()
IF GetColumnName() = "deptcode" THEN
	Gs_Codename = this.GetItemString(this.GetRow(),"deptcode")
	
	open(w_dept_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	SetItem(this.GetRow(),"deptcode",Gs_code)
	SetItem(this.GetRow(),"deptname",Gs_codeName)
	
END IF
end event

type dw_list from w_standard_print`dw_list within wp_pif2560
integer x = 1024
integer y = 288
integer width = 2830
integer height = 2028
string dataobject = "d_pif2560"
boolean border = false
end type

type rr_2 from roundrectangle within wp_pif2560
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1010
integer y = 280
integer width = 2857
integer height = 2044
integer cornerheight = 40
integer cornerwidth = 55
end type

