$PBExportHeader$w_kfia35.srw
$PBExportComments$지급어음 명세서 조회 출력
forward
global type w_kfia35 from w_standard_print
end type
type rr_1 from roundrectangle within w_kfia35
end type
end forward

global type w_kfia35 from w_standard_print
integer x = 0
integer y = 0
string title = "지급어음 명세서 조회 출력"
rr_1 rr_1
end type
global w_kfia35 w_kfia35

type variables

end variables

forward prototypes
public function integer wf_chk_cond ()
public function integer wf_retrieve ()
end prototypes

public function integer wf_chk_cond ();string ls_stdate

dw_ip.AcceptText()

ls_stdate = Trim(dw_ip.GetItemString(dw_ip.GetRow(),"stdate"))

IF ls_stdate = '' OR IsNull(ls_stdate) THEN
	F_MessageChk(1,'[기준일자]')
	dw_ip.SetColumn("stdate")
	dw_ip.SetFocus()
	Return -1
END IF

IF f_datechk(ls_stdate) = -1 THEN
	f_messagechk(21,"") 
	Return -1
END IF

Return 1

end function

public function integer wf_retrieve ();string ls_stdate,sGubun

IF dw_ip.AcceptText() = -1 THEN RETURN -1

ls_stdate = Trim(dw_ip.getitemstring(dw_ip.getrow(),'stdate'))
sGubun    = dw_ip.getitemstring(dw_ip.getrow(),'gubun')

IF wf_chk_cond() = -1 THEN RETURN -1

if dw_print.Retrieve(ls_stdate,sGubun) < 0 then
	f_messagechk(14,"") 
	Return -1
END IF
  
dw_print.sharedata(dw_list)
Return 1
end function

on w_kfia35.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kfia35.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;
dw_ip.SetItem(dw_ip.GetRow(),"stdate",f_today())
dw_ip.Setfocus()

	
end event

type p_preview from w_standard_print`p_preview within w_kfia35
end type

type p_exit from w_standard_print`p_exit within w_kfia35
end type

type p_print from w_standard_print`p_print within w_kfia35
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfia35
end type







type st_10 from w_standard_print`st_10 within w_kfia35
end type



type dw_print from w_standard_print`dw_print within w_kfia35
string dataobject = "d_kfia35_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfia35
integer x = 0
integer width = 2162
integer height = 192
string dataobject = "d_kfia35_0"
end type

event dw_ip::itemerror;call super::itemerror;Return 1
end event

event dw_ip::itemchanged;String snull, scustfnm, scusttnm

SetNull(snull)
sle_msg.text =""

IF dwo.name ="custf" THEN
	SELECT "KFZ04OM0"."PERSON_NM"
   	INTO :scustfnm
   	FROM "KFZ04OM0"  
   	WHERE ( "KFZ04OM0"."PERSON_GU" = '1' ) AND
				( "KFZ04OM0"."PERSON_CD" = :data) ;

	IF SQLCA.SQLCODE <> 0 THEN
		f_messagechk(20,"거래처")
		dw_ip.SetItem(dw_ip.GetRow(),"custf",snull)
		Return 1
	END IF
END IF

IF dwo.name ="custt" THEN
	SELECT "KFZ04OM0"."PERSON_NM"
   	INTO :scusttnm
   	FROM "KFZ04OM0"  
   	WHERE ( "KFZ04OM0"."PERSON_GU" = '1' ) AND
				( "KFZ04OM0"."PERSON_CD" = :data) ;

	IF SQLCA.SQLCODE <> 0 THEN
		f_messagechk(20,"거래처")
		dw_ip.SetItem(dw_ip.GetRow(),"custt",snull)
		Return 1
	END IF
END IF


end event

event dw_ip::rbuttondown;call super::rbuttondown;String snull

SetNull(snull)

IF dwo.name ="custf" THEN
	gs_code =dw_ip.GetItemString(1,"custf")

	IF IsNull(gs_code) then
   	gs_code = ""
	end if

	Open(W_VNDMST_POPUP)
	
	IF Not IsNull(gs_code) THEN
		dw_ip.SetItem(1,"custf",gs_code)
	END IF
END IF

IF dwo.name ="custt" THEN
	gs_code =dw_ip.GetItemString(1,"custt")

	IF IsNull(gs_code) then
   	gs_code = ""
	end if

	Open(W_VNDMST_POPUP)
	
	IF Not IsNull(gs_code) THEN
		dw_ip.SetItem(1,"custt",gs_code)
	END IF
END IF

end event

type dw_list from w_standard_print`dw_list within w_kfia35
integer x = 32
integer y = 244
integer width = 4567
integer height = 1988
string title = "지급어음 명세서 조회"
string dataobject = "d_kfia35_1"
boolean border = false
end type

type rr_1 from roundrectangle within w_kfia35
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 216
integer width = 4617
integer height = 2032
integer cornerheight = 40
integer cornerwidth = 55
end type

