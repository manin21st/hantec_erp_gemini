$PBExportHeader$w_kgld31.srw
$PBExportComments$지급결제 명세서
forward
global type w_kgld31 from w_standard_print
end type
type rr_1 from roundrectangle within w_kgld31
end type
end forward

global type w_kgld31 from w_standard_print
integer x = 0
integer y = 0
string title = "지급결제 명세서"
rr_1 rr_1
end type
global w_kgld31 w_kgld31

type variables
string s_gelname
end variables

forward prototypes
public function integer wf_data_chk (string scolname, string scolvalue)
public function integer wf_retrieve ()
end prototypes

public function integer wf_data_chk (string scolname, string scolvalue);String snull,mysql1,sacc,ssql_gaej1,ssql_gaej2,sdate

SetNull(snull)

IF scolname ="sacc1" THEN
	sacc =dw_ip.GetItemString(dw_ip.GetRow(),"sacc2")	

	IF sacc ="" OR IsNull(sacc) THEN 
		dw_ip.SetItem(1,"sacc1",snull)
		dw_ip.SetItem(1,"sacc2",snull)
		dw_ip.SetItem(1,"saccname",snull)
		RETURN 1
	END IF
	
	SELECT "KFZ01OM0"."ACC1_NM","KFZ01OM0"."ACC2_NM"
    	INTO :ssql_gaej1,:ssql_gaej2
    	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :scolvalue) AND  
         	( "KFZ01OM0"."ACC2_CD" = :sacc ) ;
				
	IF SQLCA.SQLCODE = 0 THEN
		dw_ip.SetItem(1,"saccname",ssql_gaej1+' - '+ssql_gaej2)
	ELSE
		f_messagechk(25,"")
		dw_ip.SetItem(1,"sacc1",snull)
		dw_ip.SetItem(1,"sacc2",snull)
		dw_ip.SetItem(1,"saccname",snull)
		dw_ip.SetColumn("sacc1")
		dw_ip.Setfocus()
		RETURN -1
	END IF
ELSEIF scolname ="sacc2" THEN
	sacc =dw_ip.GetItemString(dw_ip.GetRow(),"sacc1")	
	
	IF sacc ="" OR IsNull(sacc) THEN 
		dw_ip.SetItem(1,"sacc1",snull)
		dw_ip.SetItem(1,"sacc2",snull)
		dw_ip.SetItem(1,"saccname",snull)
		RETURN 1
	END IF
	
	SELECT "KFZ01OM0"."ACC1_NM","KFZ01OM0"."ACC2_NM"
    	INTO :ssql_gaej1,:ssql_gaej2
    	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :sacc ) AND  
         	( "KFZ01OM0"."ACC2_CD" = :scolvalue );
	IF SQLCA.SQLCODE = 0 THEN
		dw_ip.SetItem(1,"saccname",ssql_gaej1+' - '+ssql_gaej2)
	ELSE
		f_messagechk(25,"")
		dw_ip.SetItem(1,"sacc1",snull)
		dw_ip.SetItem(1,"sacc2",snull)
		dw_ip.SetItem(1,"saccname",snull)
		dw_ip.SetColumn("sacc1")
		dw_ip.Setfocus()
		RETURN -1
	END IF
END IF

s_gelname = ssql_gaej2
Return 1
end function

public function integer wf_retrieve ();string sYearMonthDay,sSaupj

dw_ip.AcceptText()

sYearMonthDay = Trim(dw_ip.GetItemString(1,"k_symd"))
sSaupj        = dw_ip.GetItemString(1,"saupj")

IF sYearMonthDay = "" OR IsNull(sYearMonthDay) THEN
	f_messagechk(1,"[결제일자]")
	dw_ip.setcolumn("k_symd")
	dw_ip.SetFocus()
	Return -1
END IF

IF f_datechk(sYearMonthDay) = -1 THEN
	f_messagechk(21,"[결제일자]")
	dw_ip.SetColumn("k_symd")
	dw_ip.SetFocus()
	Return -1
END IF
if sSaupj = '' or IsNull(sSaupj) then sSaupj = '%'

setpointer(hourglass!)

if dw_print.retrieve(sSaupj, sYearMonthDay) <= 0 then
	f_messagechk(14,"")
	return -1
end if 

Return 1
end function

on w_kgld31.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kgld31.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;
dw_ip.SetTransObject(SQLCA)
dw_ip.Reset()
dw_ip.InsertRow(0)

dw_ip.SetItem(1,"k_symd", f_today())
dw_ip.Setfocus()

end event

type p_preview from w_standard_print`p_preview within w_kgld31
integer x = 4091
integer y = 8
end type

type p_exit from w_standard_print`p_exit within w_kgld31
integer x = 4439
integer y = 8
end type

type p_print from w_standard_print`p_print within w_kgld31
integer x = 4265
integer y = 8
end type

type p_retrieve from w_standard_print`p_retrieve within w_kgld31
integer x = 3918
integer y = 8
end type

type st_window from w_standard_print`st_window within w_kgld31
boolean visible = false
end type

type sle_msg from w_standard_print`sle_msg within w_kgld31
boolean visible = false
end type

type dw_datetime from w_standard_print`dw_datetime within w_kgld31
boolean visible = false
end type

type st_10 from w_standard_print`st_10 within w_kgld31
boolean visible = false
end type

type gb_10 from w_standard_print`gb_10 within w_kgld31
boolean visible = false
integer width = 3589
end type

type dw_print from w_standard_print`dw_print within w_kgld31
integer x = 2994
integer y = 20
string dataobject = "dw_kgld31_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kgld31
integer x = 37
integer y = 8
integer width = 1861
integer height = 160
string dataobject = "dw_kgld310"
end type

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

IF this.GetColumnName() <>"sacc1" AND this.GetColumnName() <>"sacc2"  THEN RETURN

dw_ip.AcceptText()

IF this.GetColumnName() = "sacc1" OR this.GetColumnName() = "sacc2" THEN
	lstr_account.acc1_cd = dw_ip.GetItemString(dw_ip.GetRow(), "sacc1")
	lstr_account.acc2_cd = dw_ip.GetItemString(dw_ip.GetRow(), "sacc2")
END IF

IF IsNull(lstr_account.acc1_cd) then
   lstr_account.acc1_cd = ""
end if
IF IsNull(lstr_account.acc2_cd) then
   lstr_account.acc2_cd = ""
end if

lstr_account.acc1_cd = Trim(lstr_account.acc1_cd)
lstr_account.acc2_cd = Trim(lstr_account.acc2_cd)

Open(W_KFZ01OM0_POPUP1)

IF this.GetColumnName() = "sacc1" OR this.GetColumnName() = "sacc2" THEN
	dw_ip.SetItem(dw_ip.GetRow(), "sacc1", lstr_account.acc1_cd)
	dw_ip.SetItem(dw_ip.GetRow(), "sacc2", lstr_account.acc2_cd)
	dw_ip.SetItem(dw_ip.Getrow(),"saccname",lstr_account.acc1_nm+" - "+lstr_account.acc2_nm)
	s_gelname = lstr_account.acc2_nm
END IF

dw_ip.SetFocus()

end event

event dw_ip::itemchanged;IF WF_DATA_CHK(dwo.name,data) = -1 THEN RETURN 1
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::losefocus;call super::losefocus;dw_ip.AcceptText()
end event

type dw_list from w_standard_print`dw_list within w_kgld31
integer x = 55
integer y = 188
integer width = 4553
integer height = 2016
string title = "계정과목명 지급결제명세서"
string dataobject = "dw_kgld31"
boolean border = false
boolean hsplitscroll = false
borderstyle borderstyle = styleraised!
end type

type rr_1 from roundrectangle within w_kgld31
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 180
integer width = 4571
integer height = 2040
integer cornerheight = 40
integer cornerwidth = 55
end type

