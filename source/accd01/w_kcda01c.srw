$PBExportHeader$w_kcda01c.srw
$PBExportComments$계정별 관리항목  조회 출력
forward
global type w_kcda01c from w_standard_print
end type
type rr_1 from roundrectangle within w_kcda01c
end type
end forward

global type w_kcda01c from w_standard_print
string title = "계정과목별 관리코드 조회 출력"
rr_1 rr_1
end type
global w_kcda01c w_kcda01c

forward prototypes
public function integer wf_retrieve ()
public function integer wf_data_chk (string scolname, string scolvalue)
end prototypes

public function integer wf_retrieve ();
String sacc1f,sacc2f,sacc1t,sacc2t,sname1,sname2,snamef,snamet

IF dw_ip.AcceptText() = -1 THEN RETURN -1

sacc1f =dw_ip.GetItemString(1,"acc1f")
sacc2f =dw_ip.GetItemString(1,"acc2f")
sacc1t =dw_ip.GetItemString(1,"acc1t")
sacc2t =dw_ip.GetItemString(1,"acc2t")

IF (sacc1f ="" OR IsNull(sacc1f)) AND (sacc2f ="" OR IsNull(sacc2f)) THEN
	sacc1f ="10000"
	sacc2f ="00"
	snamef ="[자산]"
ELSE
	SELECT "KFZ01OM0"."ACC1_NM",   
          "KFZ01OM0"."ACC2_NM"  
   	INTO :sname1,   
           :sname2  
    	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :sacc1f ) AND  
         	( "KFZ01OM0"."ACC2_CD" = :sacc2f )   ;
	snamef =sname1+"-"+sname2

END IF

IF (sacc1t ="" OR IsNull(sacc1t)) AND (sacc2t ="" OR IsNull(sacc2t)) THEN
	sacc1t ="99999"
	sacc2t ="99"
	snamet =" "
ELSE
	SELECT "KFZ01OM0"."ACC1_NM",   
          "KFZ01OM0"."ACC2_NM"  
   	INTO :sname1,   
           :sname2  
    	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :sacc1t ) AND  
         	( "KFZ01OM0"."ACC2_CD" = :sacc2t )   ;
	snamet =sname1+"-"+sname2
END IF

IF dw_print.Retrieve(sacc1f,sacc2f,sacc1t,sacc2t,snamef,snamet) <= 0 THEN 
	f_messagechk(14,"")
	Return -1
END IF
dw_print.ShareData(dw_list)
Return 1
end function

public function integer wf_data_chk (string scolname, string scolvalue);
Return 1
end function

on w_kcda01c.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kcda01c.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

type p_preview from w_standard_print`p_preview within w_kcda01c
integer x = 4050
integer y = 44
end type

type p_exit from w_standard_print`p_exit within w_kcda01c
integer x = 4398
integer y = 44
end type

type p_print from w_standard_print`p_print within w_kcda01c
integer x = 4224
integer y = 44
end type

type p_retrieve from w_standard_print`p_retrieve within w_kcda01c
integer x = 3877
integer y = 44
end type

type st_window from w_standard_print`st_window within w_kcda01c
boolean visible = false
integer y = 2116
end type

type sle_msg from w_standard_print`sle_msg within w_kcda01c
boolean visible = false
integer y = 2120
end type

type dw_datetime from w_standard_print`dw_datetime within w_kcda01c
boolean visible = false
integer y = 2116
end type

type st_10 from w_standard_print`st_10 within w_kcda01c
boolean visible = false
integer y = 2120
end type

type gb_10 from w_standard_print`gb_10 within w_kcda01c
boolean visible = false
integer y = 2084
end type

type dw_print from w_standard_print`dw_print within w_kcda01c
string dataobject = "dw_kcda01c_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kcda01c
integer x = 37
integer y = 28
integer width = 2569
integer height = 200
string dataobject = "dw_kcda06_0"
end type

event dw_ip::rbuttondown;String ls_gj1, ls_gj2,rec_acc1,rec_acc2,sname1,sname2

dw_ip.AcceptText()
IF this.GetColumnName() = "acc1f" THEN
	ls_gj1 = dw_ip.GetItemString(dw_ip.GetRow(), "acc1f")
	ls_gj2 = dw_ip.GetItemString(dw_ip.GetRow(), "acc2f")

	IF IsNull(ls_gj1) then
		ls_gj1 = ""
	end if
	IF IsNull(ls_gj2) then
		ls_gj2 = ""
	end if
	lstr_account.acc1_cd = Trim(ls_gj1)
	lstr_account.acc2_cd = Trim(ls_gj2)
	
	Open(W_KFZ01OM0_POPUP)
	
	IF IsNull(lstr_account.acc1_cd) AND IsNull(lstr_account.acc2_cd) THEN RETURN
	
		dw_ip.SetItem(dw_ip.GetRow(), "acc1f", lstr_account.acc1_cd)
		dw_ip.SetItem(dw_ip.GetRow(), "acc2f", lstr_account.acc2_cd)
		dw_ip.SetItem(dw_ip.Getrow(),"accf_name",lstr_account.acc2_nm)
	
ELSEIF this.GetColumnName() = "acc1t" THEN 
	ls_gj1 = dw_ip.GetItemString(dw_ip.GetRow(), "acc1t")
	ls_gj2 = dw_ip.GetItemString(dw_ip.GetRow(), "acc2t")
	
	IF IsNull(ls_gj1) then
		ls_gj1 = ""
	end if
	IF IsNull(ls_gj2) then
		ls_gj2 = ""
	end if
	lstr_account.acc1_cd = Trim(ls_gj1)
	lstr_account.acc2_cd = Trim(ls_gj2)
	
	Open(W_KFZ01OM0_POPUP)
	
	IF IsNull(lstr_account.acc1_cd) AND IsNull(lstr_account.acc2_cd) THEN RETURN
	
	dw_ip.SetItem(dw_ip.GetRow(), "acc1t", lstr_account.acc1_cd)
	dw_ip.SetItem(dw_ip.GetRow(), "acc2t", lstr_account.acc2_cd)
	dw_ip.SetItem(dw_ip.Getrow(),"acct_name",lstr_account.acc2_nm)
END IF	
dw_ip.SetFocus()
end event

event dw_ip::itemchanged;call super::itemchanged;
//IF WF_DATA_CHK(dwo.name,data) = -1 THEN RETURN 1

String snull,mysql1,sacc,ssql_gaej1,ssql_gaej2,sdate,scolvalue

SetNull(snull)

IF dwo.name ="acc1f" THEN
	scolvalue = data
	sacc =dw_ip.GetItemString(dw_ip.GetRow(),"acc2f")	

	IF sacc ="" OR IsNull(sacc) THEN RETURN 
	
	SELECT "KFZ01OM0"."ACC1_NM","KFZ01OM0"."ACC2_NM"
    	INTO :ssql_gaej1,:ssql_gaej2
    	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :scolvalue) AND  
         	( "KFZ01OM0"."ACC2_CD" = :sacc ) ;
				
	IF SQLCA.SQLCODE = 0 THEN
		dw_ip.SetItem(1,"accf_name",ssql_gaej2)
	Else
		dw_ip.SetItem(1,"acc1f",snull)
		dw_ip.SetItem(1,"acc2f",snull)
		dw_ip.SetItem(1,"accf_name",snull)
		return
	END IF
ELSEIF dwo.name ="acc2f" THEN
	scolvalue = data
	sacc =dw_ip.GetItemString(dw_ip.GetRow(),"acc1f")	
	
	IF sacc ="" OR IsNull(sacc) THEN RETURN 
	
	SELECT "KFZ01OM0"."ACC1_NM","KFZ01OM0"."ACC2_NM"
    	INTO :ssql_gaej1,:ssql_gaej2
    	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :sacc ) AND  
         	( "KFZ01OM0"."ACC2_CD" = :scolvalue );
	IF SQLCA.SQLCODE = 0 THEN
		dw_ip.SetItem(1,"accf_name",ssql_gaej2)
	Else
		dw_ip.SetItem(1,"acc1f",snull)
		dw_ip.SetItem(1,"acc2f",snull)
		dw_ip.SetItem(1,"accf_name",snull)
		return
	END IF
ELSEIF dwo.name ="acc1t" THEN
	scolvalue = data
	sacc =dw_ip.GetItemString(dw_ip.GetRow(),"acc2t")	

	IF sacc ="" OR IsNull(sacc) THEN RETURN 
	
	SELECT "KFZ01OM0"."ACC1_NM","KFZ01OM0"."ACC2_NM"
    	INTO :ssql_gaej1,:ssql_gaej2
    	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :scolvalue) AND  
         	( "KFZ01OM0"."ACC2_CD" = :sacc ) ;
				
	IF SQLCA.SQLCODE = 0 THEN
		dw_ip.SetItem(1,"acct_name",ssql_gaej2)
	Else
		dw_ip.SetItem(1,"acc1t",snull)
		dw_ip.SetItem(1,"acc2t",snull)
		dw_ip.SetItem(1,"acct_name",snull)
		return
	END IF
ELSEIF dwo.name ="acc2t" THEN
	scolvalue = data
	sacc =dw_ip.GetItemString(dw_ip.GetRow(),"acc1t")	
	
	IF sacc ="" OR IsNull(sacc) THEN RETURN 
	
	SELECT "KFZ01OM0"."ACC1_NM","KFZ01OM0"."ACC2_NM"
    	INTO :ssql_gaej1,:ssql_gaej2
    	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :sacc ) AND  
         	( "KFZ01OM0"."ACC2_CD" = :scolvalue );
	IF SQLCA.SQLCODE = 0 THEN
		dw_ip.SetItem(1,"acct_name",ssql_gaej2)
	Else
		dw_ip.SetItem(1,"acc1t",snull)
		dw_ip.SetItem(1,"acc2t",snull)
		dw_ip.SetItem(1,"acct_name",snull)
		return
	END IF
END IF
end event

event dw_ip::itemerror;call super::itemerror;Return 1
end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_kcda01c
integer x = 50
integer y = 244
integer width = 4539
integer height = 2060
string dataobject = "dw_kcda01c_1"
boolean border = false
end type

type rr_1 from roundrectangle within w_kcda01c
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 228
integer width = 4585
integer height = 2100
integer cornerheight = 40
integer cornerwidth = 55
end type

