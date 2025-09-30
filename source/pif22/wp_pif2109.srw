$PBExportHeader$wp_pif2109.srw
$PBExportComments$** 자격 / 면허 대장 현황(사용)
forward
global type wp_pif2109 from w_standard_print
end type
type rr_1 from roundrectangle within wp_pif2109
end type
end forward

global type wp_pif2109 from w_standard_print
integer x = 0
integer y = 0
string title = "자격 / 면허 대장"
event ue_f1key pbm_keydown
rr_1 rr_1
end type
global wp_pif2109 wp_pif2109

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_code1, ls_code2
String ls_gubun, sKunmu, sSaup
String sLicence_MaxCode,sLicence_MinCode    
String sLicence_MinName,sLicence_MaxName
String ArgBuf

ls_code1 = trim(dw_ip.GetItemString(1,"scode"))
ls_code2 = trim(dw_ip.GetItemString(1,"scode2"))
ls_gubun = trim(dw_ip.GetItemString(1,"jikjong"))
sKunmu = dw_ip.GetItemString(1,"kunmu")
sSaup = trim(dw_ip.GetItemString(1,"saup"))

//dw_list.modify("slicname.text = '"+''+"'")
//dw_list.modify("elicname.text = '"+''+"'")

IF ls_gubun = '' or isnull(ls_gubun) THEN	ls_gubun = '%'
IF sSaup = '' OR IsNull(sSaup) THEN	sSaup = '%'
IF sKunmu = '' OR IsNull(sKunmu) THEN sKunmu = '%'

IF (Isnull(ls_code1) or ls_code1 = '') and (isnull(ls_code2) or ls_code2 = '') THEN

    dw_list.Dataobject = "dp_pif2109_1"
	 dw_print.Dataobject = "dp_pif2109_1_p"
	 dw_print.SetTransobject(sqlca)
	 
	 IF dw_print.retrieve(ls_gubun, sKunmu, sSaup) < 1 then
		messagebox("자료 확인", "해당 자료가 없습니다.!", stopsign!)
		dw_ip.SetColumn("scode")
	   dw_ip.SetFocus()
	 	Return -1
  	 END IF

ELSE

	IF ls_code1 = '' OR ISNULL(ls_code1) THEN
		  SELECT Min("P0_LICENSE"."LICENSECODE")
      	INTO  :sLicence_MinCode
	      FROM  "P0_LICENSE"  ;
   	   ls_code1 = sLicence_MinCode
		
	     SELECT "P0_LICENSE"."LICENSENAME"  
   	   INTO :sLicence_MinName  
      	FROM "P0_LICENSE"   
	     WHERE "P0_LICENSE"."LICENSECODE" = :sLicence_MinCode ;
	ELSE
		  sLicence_MinName  = dw_ip.GetItemString(1,"sname")
	END IF	

	IF ls_code2 = '' OR ISNULL(ls_code2) THEN
		  SELECT Max("P0_LICENSE"."LICENSECODE")
      	INTO  :sLicence_MaxCode
	      FROM "P0_LICENSE"  ;
   	   ls_code2 = sLicence_MaxCode
      
			SELECT "P0_LICENSE"."LICENSENAME"  
	      INTO :sLicence_MaxName  
   	   FROM "P0_LICENSE"   
    		WHERE  "P0_LICENSE"."LICENSECODE" = :sLicence_MaxCode ;
	ELSE
   	sLicence_MaxName = dw_ip.GetItemString(1,"sname2")
	END IF	

	if ls_code1 > ls_code2 then
		messagebox("자격증 코드", "자격증 코드 입력 범위가 부정확합니다.!", information!)
		dw_ip.SetColumn("scode")
		dw_ip.SetFocus()
		return -1
	end if

	dw_list.Dataobject = "dp_pif2109"
	dw_print.Dataobject = "dp_pif2109_p"
	dw_print.SetTransobject(sqlca)
	 
	IF dw_print.retrieve(ls_code1, ls_code2,ls_gubun, sKunmu, sSaup) < 1 then
		messagebox("자료 확인", "해당 자료가 없습니다.!", stopsign!)
		dw_ip.SetColumn("scode")
	   dw_ip.SetFocus()
		Return -1
	END IF

END IF

IF ls_gubun = '%' THEN
	dw_print.modify("t_jikjong.text = '"+'전체'+"'")
ELSE
	SELECT "CODENM"
     INTO :ArgBuf
     FROM "P0_REF"
    WHERE ( "CODEGBN" = 'JJ') AND
          ( "CODE" <> '00' ) AND
			 ( "CODE" = :ls_gubun);
	IF SQLCA.SQLCode = 0 THEN dw_print.modify("t_jikjong.text = '" + ArgBuf + "'")
END IF

IF sSaup = '%' THEN
	dw_print.modify("t_saup.text = '"+'전체'+"'")
ELSE
	SELECT "SAUPNAME"
     INTO :ArgBuf
     FROM "P0_SAUPCD"
    WHERE ( "SAUPCODE" = :sSaup);
	IF SQLCA.SQLCode = 0 THEN dw_print.modify("t_saup.text = '" + ArgBuf + "'")
END IF

IF sKunmu = '%' THEN
	dw_print.modify("t_kunmu.text = '"+'전체'+"'")
ELSE
	SELECT "KUNMUNAME"
     INTO :ArgBuf
     FROM "P0_KUNMU"
    WHERE ( "KUNMUGUBN" = :sKunmu);
	IF SQLCA.SQLCode = 0 THEN dw_print.modify("t_kunmu.text = '" + ArgBuf + "'")
END IF


dw_print.sharedata(dw_list)

dw_print.modify("slicname.text = '"+ sLicence_MinName +"'")
dw_print.modify("elicname.text = '"+ sLicence_MaxName +"'")


Return 1


end function

on wp_pif2109.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on wp_pif2109.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_list.settransobject(sqlca)

f_set_saupcd(dw_ip, 'saup', '1')
is_saupcd = gs_saupcd

end event

type p_preview from w_standard_print`p_preview within wp_pif2109
integer x = 4078
integer y = 8
end type

type p_exit from w_standard_print`p_exit within wp_pif2109
integer x = 4425
integer y = 8
end type

type p_print from w_standard_print`p_print within wp_pif2109
integer x = 4251
integer y = 8
end type

type p_retrieve from w_standard_print`p_retrieve within wp_pif2109
integer x = 3904
integer y = 8
end type

type st_window from w_standard_print`st_window within wp_pif2109
integer y = 4000
end type

type sle_msg from w_standard_print`sle_msg within wp_pif2109
integer y = 4000
end type

type dw_datetime from w_standard_print`dw_datetime within wp_pif2109
integer y = 4000
end type

type st_10 from w_standard_print`st_10 within wp_pif2109
integer y = 4000
end type

type gb_10 from w_standard_print`gb_10 within wp_pif2109
integer y = 4000
end type

type dw_print from w_standard_print`dw_print within wp_pif2109
string dataobject = "dp_pif2109_p"
end type

type dw_ip from w_standard_print`dw_ip within wp_pif2109
integer x = 5
integer y = 8
integer width = 2487
integer height = 256
integer taborder = 60
string dataobject = "dw_pif2109ret"
end type

event dw_ip::rbuttondown;call super::rbuttondown;setnull(gs_code)
setnull(gs_codename)
SetNull(Gs_gubun)

Gs_gubun = is_saupcd
IF THIS.GetColumnName() = "scode" THEN
	
   gs_code = this.GetText()

  open(w_license_popup)

  if isnull(gs_code) or gs_code = '' then return

  dw_ip.SetITem(1,"scode",gs_code)
  dw_ip.SetITem(1,"sname",gs_codename)
ELSEIF THIS.GetColumnName() = "scode2" THEN
   
   gs_code = this.GetText()

  open(w_license_popup)

  if isnull(gs_code) or gs_code = '' then return

  dw_ip.SetITem(1,"scode2",gs_code)
  dw_ip.SetITem(1,"sname2",gs_codename)
END IF	
end event

event dw_ip::itemchanged;call super::itemchanged;String LicName,LicCode,SetNull

this.AcceptText()

IF this.GetColumnName() = 'saup' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF


IF this.GetColumnName() = "scode" THEN
	 LicCode = this.GetText()  
     
	 IF LicCode = '' or isnull(LicCode)  THEN
		 dw_ip.SetITem(1,"scode",SetNull)
		 dw_ip.SetITem(1,"sname",SetNull)
		 return
	 END IF
 	 SELECT "P0_LICENSE"."LICENSENAME"  
		INTO :LicName
		FROM "P0_LICENSE"  
		WHERE "P0_LICENSE"."LICENSECODE" =:LicCode ;   
    
	 IF sqlca.sqlcode <> 0 then
       MessageBox("확인","자격증코드를 확인하십시요")
	    dw_ip.SetITem(1,"scode",SetNull)
		 dw_ip.SetITem(1,"sname",SetNull)
		 dw_ip.SetColumn("scode")
		 dw_ip.SetFocus()
		 Return 1 
	 ELSE
		 dw_ip.SetITem(1,"sname",LicName)
	 END IF
ELSEIF this.GetColumnName() = "scode2" THEN
    LicCode = this.GetText()  
     
	 IF LicCode = '' or isnull(LicCode)  THEN
		 dw_ip.SetITem(1,"scode2",SetNull)
		 dw_ip.SetITem(1,"sname2",SetNull)
		 return
	 END IF
 	 SELECT "P0_LICENSE"."LICENSENAME"  
		INTO :LicName
		FROM "P0_LICENSE"  
		WHERE "P0_LICENSE"."LICENSECODE" =:LicCode ;   
    
	 IF sqlca.sqlcode <> 0 then
       MessageBox("확인","자격증코드를 확인하십시요")
	    dw_ip.SetITem(1,"scode2",SetNull)
		 dw_ip.SetITem(1,"sname2",SetNull)
		 dw_ip.SetColumn("scode2")
		 dw_ip.SetFocus()
		 Return 1 
	 ELSE
		 dw_ip.SetITem(1,"sname2",LicName)
	 END IF 
 
END IF	

	

end event

event dw_ip::itemerror;call super::itemerror;Return 1
end event

type dw_list from w_standard_print`dw_list within wp_pif2109
integer x = 18
integer y = 280
integer width = 4571
integer height = 2044
string dataobject = "dp_pif2109"
boolean border = false
end type

type rr_1 from roundrectangle within wp_pif2109
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 5
integer y = 268
integer width = 4613
integer height = 2072
integer cornerheight = 40
integer cornerwidth = 55
end type

