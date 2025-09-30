$PBExportHeader$wp_pik2040.srw
$PBExportComments$** 년/월차내역
forward
global type wp_pik2040 from w_standard_print
end type
type rr_1 from roundrectangle within wp_pik2040
end type
end forward

global type wp_pik2040 from w_standard_print
string title = "년차내역"
rr_1 rr_1
end type
global wp_pik2040 wp_pik2040

type variables
String      sGetSysDept,sProcDept
int           li_level
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sYm, sprtgubn, sdeptcode, sdept, sadddept, sSaup, sJikjong, sKunmu, ArgBuf

dw_ip.accepttext()
sym 			= dw_ip.GetItemString(1,"yymm")
sprtgubn 	= dw_ip.GetItemString(1,"prtgubn")
sdeptcode 	= dw_ip.GetItemString(1,"deptcode")
sSaup 		= trim(dw_ip.GetItemString(1,"saup"))
sJikjong 	= trim(dw_ip.GetItemString(1,"jikjong"))
sKunmu 		= trim(dw_ip.GetItemString(1,"kunmu"))

IF sYm = '' OR ISNULL(sYm) THEN
	MessageBox("확인","출력년월을 입력하세요")
	Return -1
END IF	

IF sdeptcode = '' OR Isnull(sdeptcode) THEN sdeptcode = '%'

IF li_level = 3 then
	sdept = sdeptcode
	sadddept = '%'
ELSE
	sadddept = sdeptcode
	sdept = '%'
END IF	

dw_list.Setredraw(false)

IF sprtgubn = '1' THEN
	dw_list.DataObject = 'dp_pik2040_2'
	dw_list.SetTransObject(SQLCA)
	dw_print.DataObject = 'dp_pik2040_2_p'
	dw_print.SetTransObject(SQLCA)
ELSE
	dw_list.DataObject = 'dp_pik2040_1'
	dw_list.SetTransObject(SQLCA)
	dw_print.DataObject = 'dp_pik2040_1_p'
	dw_print.SetTransObject(SQLCA)
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

//MessageBox('확인!',gs_company+','+sYm+','+sdept+','+sadddept+','+sSaup+','+sJikjong+','+sKunmu)
//IF dw_print.Retrieve(gs_company,sYm,sdept,sadddept, sSaup, sJikjong, sKunmu) < 1 then

IF dw_print.Retrieve(gs_company, sYm, sSaup, sJikjong, sKunmu) < 1 then
	MessageBox("확인","조회된 자료가 없습니다" )
	Return -1
END IF
dw_print.sharedata(dw_list)

Return 1 
end function

on wp_pik2040.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on wp_pik2040.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;string sDeptName

SELECT "P0_SYSCNFG"."DATANAME"  														/*근태 담당부서*/
	INTO :sGetSysDept  
   FROM "P0_SYSCNFG"  
   WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  
         ( "P0_SYSCNFG"."SERIAL" = 1 ) AND  
         ( "P0_SYSCNFG"."LINENO" = '1' )   ;
			
IF IsNull(sGetSysDept) THEN sGetSysDept =" "

//부서level check	
SELECT "P0_DEPT"."DEPT_LEVEL"  
  INTO :li_level
  FROM "P0_DEPT"  
 WHERE "P0_DEPT"."DEPTCODE" = :gs_dept   ;
	
IF SQLCA.SQLCODE <> 0 THEN	
	 li_level = 3
END IF	

IF gs_dept = sGetSysDept THEN
ELSE
	dw_ip.SetItem(1,"deptcode",gs_dept)

	SELECT "DEPTNAME2"	INTO :sDeptName
		FROM "P0_DEPT"
		WHERE "P0_DEPT"."DEPTCODE" =:gs_dept;
		
	dw_ip.SetItem(1,"deptname",sDeptName)
	dw_ip.Modify("deptcode.protect = 1")
END IF

dw_list.DataObject = 'dp_pik2040_2'
dw_list.SetTransObject(SQLCA)
dw_print.DataObject = 'dp_pik2040_2_p'
dw_print.SetTransObject(SQLCA)

dw_ip.SetItem(1,"yymm",Left(gs_today,6))

f_set_saupcd(dw_ip, 'saup', '1')
is_saupcd = gs_saupcd

dw_ip.SetColumn("yymm")
dw_ip.SetFocus()


end event

type p_preview from w_standard_print`p_preview within wp_pik2040
end type

type p_exit from w_standard_print`p_exit within wp_pik2040
end type

type p_print from w_standard_print`p_print within wp_pik2040
end type

type p_retrieve from w_standard_print`p_retrieve within wp_pik2040
end type

type st_window from w_standard_print`st_window within wp_pik2040
boolean visible = false
end type

type sle_msg from w_standard_print`sle_msg within wp_pik2040
boolean visible = false
end type

type dw_datetime from w_standard_print`dw_datetime within wp_pik2040
boolean visible = false
end type

type st_10 from w_standard_print`st_10 within wp_pik2040
boolean visible = false
end type

type gb_10 from w_standard_print`gb_10 within wp_pik2040
boolean visible = false
end type

type dw_print from w_standard_print`dw_print within wp_pik2040
string dataobject = "dp_pik2040_2_p"
end type

type dw_ip from w_standard_print`dw_ip within wp_pik2040
integer x = 567
integer y = 8
integer width = 2981
integer height = 252
string dataobject = "dp_pik2040_0"
end type

event dw_ip::itemchanged;STRING syymm, sprtgubn, sdeptcode, snull, sname

SetNull(snull)

this.AcceptText()

IF this.GetColumnName() = 'saup' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF

IF this.getcolumnname() = "yymm" THEN
	syymm = this.gettext()
	IF syymm = '' or isnull(syymm) THEN
		MessageBox("확인", "출력년월을 입력하십시오")
		this.setcolumn("yymm")
		this.setfocus()
		return 1
	END IF	
	IF f_datechk(syymm + '01') = -1 THEN
		MessageBox("확인", "출력년월을 확인하십시오")
		this.setcolumn("yymm")
		this.setitem(1,"yymm",snull)
		this.setfocus()
		return 1
	END IF	
END IF

IF this.getcolumnname() = "prtgubn" THEN
	sprtgubn = this.gettext()
	IF sprtgubn = '1' THEN
		dw_list.DataObject = 'dp_pik2040_2'
		dw_list.SetTransObject(SQLCA)
		dw_print.DataObject = 'dp_pik2040_2_p'
		dw_print.SetTransObject(SQLCA)		
	ELSE
		dw_list.DataObject = 'dp_pik2040_1'
		dw_list.SetTransObject(SQLCA)
		dw_print.DataObject = 'dp_pik2040_1_p'
		dw_print.SetTransObject(SQLCA)			
	END IF	
END IF

IF this.Getcolumnname() = "deptcode" THEN
	sdeptcode = this.gettext()
	IF sdeptcode = '' or isnull(sdeptcode) THEN
		this.setitem(1,"deptname",snull)
	END IF	
	
	SELECT "P0_DEPT"."DEPTNAME"  
     INTO :sname  
     FROM "P0_DEPT"  
    WHERE ( "P0_DEPT"."COMPANYCODE" = :gs_company ) AND  
          ( "P0_DEPT"."DEPTCODE" = :sdeptcode )   ;
			 
	IF SQLCA.SQLCODE <> 0 OR sname = '' OR IsNull(sname) THEN		 
		MessageBox("확인", "부서코드를 확인하십시오")
		this.setcolumn("deptcode")
		this.setitem(1,"deeptcode",snull)
		this.setitem(1,"deeptname",snull)
		this.setfocus()
		return 1
	ELSE
		this.setitem(1,"deeptname",sname)
	END IF	

		
END IF	



end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(Gs_gubun)

Gs_gubun = is_saupcd
IF this.GetColumnName() ="deptcode" THEN
	
	Open(w_dept_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(1,"deptcode",gs_code)
	this.SetItem(1,"deptname",gs_codename)	
END IF
end event

event dw_ip::getfocus;this.accepttext()
end event

type dw_list from w_standard_print`dw_list within wp_pik2040
integer x = 590
integer y = 280
integer width = 3328
integer height = 1960
string dataobject = "dp_pik2040_2"
boolean border = false
end type

type rr_1 from roundrectangle within wp_pik2040
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 581
integer y = 272
integer width = 3351
integer height = 1976
integer cornerheight = 40
integer cornerwidth = 55
end type

