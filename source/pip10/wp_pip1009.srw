$PBExportHeader$wp_pip1009.srw
$PBExportComments$** 급여항목 조회
forward
global type wp_pip1009 from w_standard_print
end type
type rr_1 from roundrectangle within wp_pip1009
end type
end forward

global type wp_pip1009 from w_standard_print
string title = "급여항목 조회"
rr_1 rr_1
end type
global wp_pip1009 wp_pip1009

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_sptag

dw_ip.AcceptText()

ls_sptag = trim(dw_ip.getItemString(1,'paysubtag'))
if ls_sptag = '' or isNull(ls_sptag) then ls_sptag = '%'

IF dw_print.retrieve(ls_sptag) < 1 THEN
	MessageBox('확인','조회한 자료가 없습니다.')
	return -1
END IF

dw_print.sharedata(dw_list)

return 1
end function

on wp_pip1009.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on wp_pip1009.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;p_retrieve.TriggerEvent(Clicked!)
end event

type p_preview from w_standard_print`p_preview within wp_pip1009
integer x = 4073
end type

type p_exit from w_standard_print`p_exit within wp_pip1009
integer x = 4421
end type

type p_print from w_standard_print`p_print within wp_pip1009
integer x = 4247
end type

type p_retrieve from w_standard_print`p_retrieve within wp_pip1009
integer x = 3899
end type







type st_10 from w_standard_print`st_10 within wp_pip1009
end type



type dw_print from w_standard_print`dw_print within wp_pip1009
string dataobject = "dp_pip1009_1_p"
end type

type dw_ip from w_standard_print`dw_ip within wp_pip1009
integer x = 55
integer y = 68
integer width = 1088
integer height = 168
string dataobject = "dp_pip1009_2"
end type

event dw_ip::itemchanged;call super::itemchanged;p_retrieve.triggerevent(clicked!)
end event

type dw_list from w_standard_print`dw_list within wp_pip1009
integer x = 55
integer y = 252
integer width = 4521
integer height = 2040
string dataobject = "dp_pip1009_1"
boolean border = false
end type

type rr_1 from roundrectangle within wp_pip1009
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 46
integer y = 244
integer width = 4544
integer height = 2056
integer cornerheight = 40
integer cornerwidth = 55
end type

