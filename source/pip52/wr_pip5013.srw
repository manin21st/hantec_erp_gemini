$PBExportHeader$wr_pip5013.srw
$PBExportComments$소득명세 이상자
forward
global type wr_pip5013 from w_standard_print
end type
type rr_2 from roundrectangle within wr_pip5013
end type
type rr_3 from roundrectangle within wr_pip5013
end type
end forward

global type wr_pip5013 from w_standard_print
string title = "소득명세 이상자 현황"
rr_2 rr_2
rr_3 rr_3
end type
global wr_pip5013 wr_pip5013

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string syear, ssaup, sdept


if dw_ip.Accepttext() = -1 then return -1


syear = dw_ip.GetitemString(1,'syear')
ssaup = dw_ip.GetitemString(1,'saupcd')
sdept = dw_ip.GetitemString(1,'deptcode')		

if trim(ssaup) = '' or isnull(ssaup) then ssaup = '%'
if trim(sdept) = '' or isnull(sdept) then sdept = '%'

IF dw_print.Retrieve(syear, ssaup, sdept) <=0 THEN
	MessageBox("확 인","조회한 자료가 없습니다!!")
	sle_msg.text =""
   return -1
ELSE
	sle_msg.text ="조 회"
END IF

   dw_print.sharedata(dw_list)

return 1
end function

on wr_pip5013.create
int iCurrent
call super::create
this.rr_2=create rr_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
this.Control[iCurrent+2]=this.rr_3
end on

on wr_pip5013.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
destroy(this.rr_3)
end on

event open;call super::open;f_set_saupcd(dw_ip, 'saupcd', '1')
is_saupcd = gs_saupcd

dw_ip.insertrow(0)
dw_ip.setitem(1,'syear', left(f_today(),4))

p_retrieve.TriggerEvent(Clicked!)
end event

type p_preview from w_standard_print`p_preview within wr_pip5013
end type

type p_exit from w_standard_print`p_exit within wr_pip5013
end type

type p_print from w_standard_print`p_print within wr_pip5013
end type

type p_retrieve from w_standard_print`p_retrieve within wr_pip5013
end type







type st_10 from w_standard_print`st_10 within wr_pip5013
end type



type dw_print from w_standard_print`dw_print within wr_pip5013
string dataobject = "dr_pip5013_p"
end type

type dw_ip from w_standard_print`dw_ip within wr_pip5013
integer x = 558
integer y = 100
integer width = 2880
integer height = 84
string dataobject = "dr_pip5013_1"
end type

event dw_ip::itemchanged;call super::itemchanged;String sDeptno,SetNull,sName

setnull(SetNull)

this.AcceptText()

IF this.GetColumnName() = 'saupcd' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF

IF this.GetColumnName() ="deptcode" THEN 
   sDeptno = this.GetText()
	IF sDeptno = '' OR ISNULL(sDeptno) THEN
		this.SetITem(1,"deptcode",SetNull)
		this.SetITem(1,"deptname",SetNull)
		p_retrieve.TriggerEvent(Clicked!)
		return
	END IF	
	
	  SELECT  "P0_DEPT"."DEPTNAME"  
		INTO :sName  
		FROM "P0_DEPT"  
		WHERE ( "P0_DEPT"."COMPANYCODE" = :gs_company ) AND  
				( "P0_DEPT"."DEPTCODE" = :sDeptno ); 
	
	IF sName = '' OR ISNULL(sName) THEN
   	MessageBox("확 인","부서번호를 확인하세요!!") 
		this.SetITem(1,"deptcode",SetNull)
	   this.SetITem(1,"deptname",SetNull) 
		this.SetColumn("deptcode")
		return 1
	END IF	
	   this.SetITem(1,"deptname",sName) 
END IF

p_retrieve.TriggerEvent(Clicked!)
end event

event dw_ip::rbuttondown;call super::rbuttondown;IF this.GetColumnName() = "deptcode" THEN
	SetNull(gs_code)
	SetNull(gs_codename)
	SetNull(Gs_gubun)
	
	GS_gubun = is_saupcd
	Open(w_dept_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	this.SetITem(1,"deptcode",gs_code)
	this.TriggerEvent(ItemChanged!)
END IF
end event

type dw_list from w_standard_print`dw_list within wr_pip5013
integer x = 562
integer y = 268
integer width = 3442
integer height = 1948
string dataobject = "dr_pip5013"
boolean border = false
end type

type rr_2 from roundrectangle within wr_pip5013
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 549
integer y = 44
integer width = 2971
integer height = 192
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within wr_pip5013
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 549
integer y = 264
integer width = 3479
integer height = 1984
integer cornerheight = 40
integer cornerwidth = 55
end type

