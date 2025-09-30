$PBExportHeader$w_pig5030_popup.srw
$PBExportComments$교육복명서 등록
forward
global type w_pig5030_popup from window
end type
type dw_2 from datawindow within w_pig5030_popup
end type
type p_5 from uo_picture within w_pig5030_popup
end type
type p_4 from uo_picture within w_pig5030_popup
end type
type p_3 from uo_picture within w_pig5030_popup
end type
type p_2 from uo_picture within w_pig5030_popup
end type
type p_1 from uo_picture within w_pig5030_popup
end type
type dw_1 from u_d_popup_sort within w_pig5030_popup
end type
type rr_2 from roundrectangle within w_pig5030_popup
end type
end forward

global type w_pig5030_popup from window
integer x = 1294
integer y = 160
integer width = 4050
integer height = 2008
boolean titlebar = true
string title = "교육 조회 선택"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
dw_2 dw_2
p_5 p_5
p_4 p_4
p_3 p_3
p_2 p_2
p_1 p_1
dw_1 dw_1
rr_2 rr_2
end type
global w_pig5030_popup w_pig5030_popup

type variables
str_edu  istr_edu
end variables

on w_pig5030_popup.create
this.dw_2=create dw_2
this.p_5=create p_5
this.p_4=create p_4
this.p_3=create p_3
this.p_2=create p_2
this.p_1=create p_1
this.dw_1=create dw_1
this.rr_2=create rr_2
this.Control[]={this.dw_2,&
this.p_5,&
this.p_4,&
this.p_3,&
this.p_2,&
this.p_1,&
this.dw_1,&
this.rr_2}
end on

on w_pig5030_popup.destroy
destroy(this.dw_2)
destroy(this.p_5)
destroy(this.p_4)
destroy(this.p_3)
destroy(this.p_2)
destroy(this.p_1)
destroy(this.dw_1)
destroy(this.rr_2)
end on

event open;
f_Window_Center_Response(This)

string sgbn, ls_empname, sdeptcode

istr_edu = Message.PowerObjectParm

dw_2.SetTransObject(SQLCA)
dw_2.Reset()
dw_2.InsertRow(0)
dw_2.SetItem(1,"ekind",    istr_edu.str_egubn)
dw_2.SetItem(1,"deptcode", istr_edu.str_dept)
dw_2.SetItem(1,"eduyear",  istr_edu.str_eduyear)

dw_1.SetTransObject(SQLCA)

dw_1.Retrieve(Gs_Company,istr_edu.str_dept,istr_edu.str_egubn,istr_edu.str_eduyear)


select dataname	into :sDeptCode		
from p0_syscnfg 
where sysgu = 'P' and serial = '1' and lineno = '1';

if sDeptCode = Gs_Dept then					/*담당부서*/
	dw_2.SetTaborder("deptcode",10)
else
	dw_2.SetTaborder("deptcode",0)
end if
end event

event key;choose case key
	case keypageup!
		dw_1.scrollpriorpage()
	case keypagedown!
		dw_1.scrollnextpage()
	case keyhome!
		dw_1.scrolltorow(1)
	case keyend!
		dw_1.scrolltorow(dw_1.rowcount())
end choose
end event

event close;istr_edu.str_flag = '0'
Closewithreturn(this, istr_edu)

end event

type dw_2 from datawindow within w_pig5030_popup
integer x = 37
integer y = 8
integer width = 2766
integer height = 136
integer taborder = 10
string title = "none"
string dataobject = "d_pig5030_popup1"
boolean border = false
boolean livescroll = true
end type

event itemchanged;if this.GetColumnName() = 'deptcode' then
	
	p_4.Triggerevent(Clicked!)
	
end if	
end event

type p_5 from uo_picture within w_pig5030_popup
integer x = 3840
integer width = 178
boolean originalsize = true
string picturename = "C:\Erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;SetNull(istr_edu.str_empno)
SetNull(istr_edu.str_eduyear)
SetNull(istr_edu.str_empseq)
SetNull(istr_edu.str_gbn)

istr_edu.str_flag = '0'
Closewithreturn(Parent, istr_edu)

end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

type p_4 from uo_picture within w_pig5030_popup
boolean visible = false
integer x = 2930
integer width = 178
boolean originalsize = true
string picturename = "C:\Erpman\image\조회_up.gif"
end type

event clicked;string ls_ekind, ls_dept, ld_eduyear

if dw_2.Accepttext() = -1 then return

ls_ekind = dw_2.GetitemString(1,'ekind')
ls_dept = dw_2.GetitemString(1,'deptcode')
ld_eduyear = dw_2.GetitemString(1,'eduyear')

IF dw_1.Retrieve(Gs_Company,ls_dept,ls_ekind,ld_eduyear) <=0 THEN
	Return
END IF

end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

type p_3 from uo_picture within w_pig5030_popup
integer x = 338
integer y = 1936
end type

type p_2 from uo_picture within w_pig5030_popup
integer x = 338
integer y = 1936
end type

type p_1 from uo_picture within w_pig5030_popup
integer x = 3666
integer width = 178
boolean originalsize = true
string picturename = "C:\Erpman\image\선택_up.gif"
end type

event clicked;call super::clicked;Long ll_row	

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. ~r 다시 선택한후 선택버튼을 누르십시오 !!")
   return
END IF

istr_edu.str_eduyear   = dw_1.GetItemString(ll_Row,"eduyear")
istr_edu.str_empseq    = dw_1.GetItemNumber(ll_Row,"empseq")
istr_edu.str_empno     = dw_1.GetItemString(ll_Row,"empno")
istr_edu.str_sdate     = dw_1.GetItemString(ll_Row,"restartdate")
istr_edu.str_edate     = dw_1.GetItemString(ll_Row,"reenddate")
istr_edu.itr_datesu    = dw_1.GetItemNumber(ll_Row,"datesu")
istr_edu.str_edudesc   = dw_1.GetItemString(ll_Row,"edudesc")

istr_edu.str_empname   = dw_1.GetItemString(ll_Row,"empname")
istr_edu.str_egubn     = dw_1.GetItemString(ll_Row,"ekind")
istr_edu.str_gbn       = dw_1.GetItemString(ll_Row,"egubn")
istr_edu.str_dept		  = dw_1.GetItemString(ll_Row,"deptcode")
istr_edu.str_prostate  = dw_1.GetItemString(ll_Row,"prostate")

istr_edu.str_flag = '1'

Closewithreturn(Parent, istr_edu)
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\선택_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\선택_dn.gif"
end event

type dw_1 from u_d_popup_sort within w_pig5030_popup
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 64
integer y = 168
integer width = 3927
integer height = 1680
integer taborder = 20
string dataobject = "d_pig5030_popup"
boolean vscrollbar = true
boolean border = false
end type

event ue_pressenter;
p_1.TriggerEvent(Clicked!)
end event

event ue_key;choose case key
	case keypageup!
		dw_1.scrollpriorpage()
	case keypagedown!
		dw_1.scrollnextpage()
	case keyhome!
		dw_1.scrolltorow(1)
	case keyend!
		dw_1.scrolltorow(dw_1.rowcount())
end choose
end event

event rowfocuschanged;
dw_1.SelectRow(0,False)
dw_1.SelectRow(currentrow,True)

dw_1.ScrollToRow(currentrow)
end event

event clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag = False

END IF

CALL SUPER ::CLICKED


end event

event doubleclicked;IF Row = 0 THEN
   MessageBox("확 인", "선택값이 없습니다. ~r다시 선택한후 ok 버튼을 누르십시오 !")
   return
END IF

istr_edu.str_eduyear   = dw_1.GetItemString(row,"eduyear")
istr_edu.str_empseq    = dw_1.GetItemNumber(row,"empseq")
istr_edu.str_empno     = dw_1.GetItemString(row,"empno")
istr_edu.str_sdate     = dw_1.GetItemString(row,"restartdate")
istr_edu.str_edate     = dw_1.GetItemString(row,"reenddate")
istr_edu.itr_datesu    = dw_1.GetItemNumber(row,"datesu")
istr_edu.str_edudesc   = dw_1.GetItemString(row,"edudesc")

//istr_edu.str_eduno     = dw_1.GetItemString(row,"eduno")
istr_edu.str_empname   = dw_1.GetItemString(row,"empname")
istr_edu.str_egubn     = dw_1.GetItemString(row,"ekind")
istr_edu.str_gbn       = dw_1.GetItemString(row,"egubn")
istr_edu.str_dept		  = dw_1.GetItemString(row,"deptcode")
istr_edu.str_prostate  = dw_1.GetItemString(row,"prostate")

istr_edu.str_flag = '1'

Closewithreturn(Parent, istr_edu)



end event

type rr_2 from roundrectangle within w_pig5030_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 156
integer width = 3954
integer height = 1708
integer cornerheight = 40
integer cornerwidth = 55
end type

