$PBExportHeader$w_pdt_06000_01.srw
$PBExportComments$설비지급이력
forward
global type w_pdt_06000_01 from window
end type
type p_4 from uo_picture within w_pdt_06000_01
end type
type p_3 from uo_picture within w_pdt_06000_01
end type
type p_2 from uo_picture within w_pdt_06000_01
end type
type p_1 from uo_picture within w_pdt_06000_01
end type
type dw_1 from datawindow within w_pdt_06000_01
end type
type rr_1 from roundrectangle within w_pdt_06000_01
end type
end forward

global type w_pdt_06000_01 from window
integer x = 517
integer y = 740
integer width = 3328
integer height = 1356
boolean titlebar = true
string title = "설비지급이력"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_4 p_4
p_3 p_3
p_2 p_2
p_1 p_1
dw_1 dw_1
rr_1 rr_1
end type
global w_pdt_06000_01 w_pdt_06000_01

type variables
string ismchno
end variables

on w_pdt_06000_01.create
this.p_4=create p_4
this.p_3=create p_3
this.p_2=create p_2
this.p_1=create p_1
this.dw_1=create dw_1
this.rr_1=create rr_1
this.Control[]={this.p_4,&
this.p_3,&
this.p_2,&
this.p_1,&
this.dw_1,&
this.rr_1}
end on

on w_pdt_06000_01.destroy
destroy(this.p_4)
destroy(this.p_3)
destroy(this.p_2)
destroy(this.p_1)
destroy(this.dw_1)
destroy(this.rr_1)
end on

event open;dw_1.settransobject(sqlca)
dw_1.retrieve(gs_sabu, gs_code)
ismchno = gs_code
end event

type p_4 from uo_picture within w_pdt_06000_01
integer x = 3090
integer y = 16
integer width = 178
boolean originalsize = true
string picturename = "c:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;rollback;
CLOSE(PARENT)
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "c:\erpman\image\취소_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "c:\erpman\image\취소_dn.gif"
end event

type p_3 from uo_picture within w_pdt_06000_01
integer x = 2917
integer y = 16
integer width = 178
string picturename = "c:\erpman\image\저장_up.gif"
end type

event clicked;call super::clicked;long  lCount, lrow, ll_found
string sfind

if dw_1.accepttext() = -1 then return

lCount = dw_1.rowcount()

for lrow = 1 to lCount
   if Isnull(Trim(dw_1.object.jidat[lRow])) or Trim(dw_1.object.jidat[lRow]) = "" then
  	   f_message_chk(1400,'[지급일자]')
		dw_1.SetRow(lRow)  
	   dw_1.SetColumn('jidat')
	   dw_1.SetFocus()
	   return 
   end if	
   if Isnull(Trim(dw_1.object.dptno[lRow])) or Trim(dw_1.object.dptno[lRow]) = "" then
  	   f_message_chk(1400,'[지급부서]')
		dw_1.SetRow(lRow)  
	   dw_1.SetColumn('dptno')
	   dw_1.SetFocus()
	   return 
   end if	
	
	if lrow < lCount then
		sfind = dw_1.object.jidat[lRow] + '||' + dw_1.object.dptno[lRow]
      ll_found = dw_1.Find("sfind = '" + sfind + "'", lrow + 1,  lcount) 
		if ll_found > 0 then
			MessageBox("확 인", String(ll_found) + " 번째 Row의 지급일자/부서 중복입니다!(등록 불가능!)")
			dw_1.SetRow(ll_found)  
			dw_1.SetColumn('jidat')
			dw_1.SetFocus()
			return
		end if	
   end if

   if Isnull(Trim(dw_1.object.sabu[lRow])) or Trim(dw_1.object.sabu[lRow]) = "" then
		dw_1.setitem(lrow, "sabu", gs_sabu)
		dw_1.setitem(lrow, "mchno", ismchno)
	end if
next

if dw_1.update() = 1 then
	commit;
	close(parent)
else
	rollback;
	f_rollback()
end if

end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "c:\erpman\image\저장_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "c:\erpman\image\저장_dn.gif"
end event

type p_2 from uo_picture within w_pdt_06000_01
integer x = 2743
integer y = 16
integer width = 178
string picturename = "c:\erpman\image\삭제_up.gif"
end type

event clicked;call super::clicked;long lrow

lrow = dw_1.getrow()

if lrow < 1 then return

if f_msg_delete() = 1 then
//	if dw_1.getitemstring(lrow, 'ipdat') > '.' then 
//		messagebox('확 인', '접수처리된 자료는 삭제할 수 없습니다.')
//		return 
//	end if
	
	dw_1.deleterow(lrow)
end if
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "c:\erpman\image\삭제_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "c:\erpman\image\삭제_dn.gif"
end event

type p_1 from uo_picture within w_pdt_06000_01
integer x = 2569
integer y = 16
integer width = 178
string picturename = "c:\erpman\image\추가_up.gif"
end type

event clicked;call super::clicked;long lrow
lrow = dw_1.insertrow(0)
dw_1.setrow(lrow)
dw_1.setfocus()
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "c:\erpman\image\추가_up.gif"

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "c:\erpman\image\추가_dn.gif"
end event

type dw_1 from datawindow within w_pdt_06000_01
event ue_key pbm_dwnkey
event us_pressenter pbm_dwnprocessenter
integer x = 50
integer y = 188
integer width = 3205
integer height = 1024
integer taborder = 10
string dataobject = "d_pdt_06000_01_01"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event us_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

if this.getcolumnname() = "dptno" then
	open(w_vndmst_4_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.SetItem(this.getrow(), "dptno", gs_code)
	this.SetItem(this.getrow(), "cvnas", gs_codename)
elseif this.getcolumnname() = "ipemp" then
	open( w_sawon_popup ) 
	if isnull(gs_code) or gs_code = '' then return 
	this.setitem(this.getrow(),"ipemp" ,gs_code)
	this.setitem(this.getrow(),"empname" ,gs_codename)
end if
end event

event itemerror;return 1
end event

event itemchanged;String s_cod, s_nam1, s_nam2, sNull, sname, sname2
Integer i_rtn
long    lrow

SetNull(sNull)

lrow = this.getrow()
s_cod = Trim(this.GetText())

if this.getcolumnname() = "dptno" then //관리부서
	i_rtn = f_get_name2("부서", "Y", s_cod, s_nam1, s_nam2)
	this.object.dptno[lrow] = s_cod
	this.object.cvnas[lrow] = s_nam1
	return i_rtn
elseif this.getcolumnname() = "jidat" then //지급일자
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[지급일자]")
		this.object.jidat[lrow] = ""
		return 1
	end if
	
	SetItem(lrow, 'ipdat', s_cod)
elseif this.getcolumnname() = "hidat" then //회수일자
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[회수일자]")
		this.object.hidat[lrow] = ""
		return 1
	end if
elseif this.getcolumnname() = "ipemp" then //의뢰담당자 
   s_cod = Trim(this.GetText())
	i_rtn = f_get_name2('사번','Y', s_cod , sname, sname2 )
	this.setitem(lrow,"ipemp", s_cod )
	this.setitem(lrow,"empname", sname)
	
	return i_rtn
End If


end event

type rr_1 from roundrectangle within w_pdt_06000_01
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 180
integer width = 3237
integer height = 1052
integer cornerheight = 40
integer cornerwidth = 55
end type

