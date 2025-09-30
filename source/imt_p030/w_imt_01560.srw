$PBExportHeader$w_imt_01560.srw
$PBExportComments$�ŷ�ó�� ǰ�� ����Ʈ(���)
forward
global type w_imt_01560 from w_standard_print
end type
type rr_1 from roundrectangle within w_imt_01560
end type
end forward

global type w_imt_01560 from w_standard_print
string title = "�ŷ�ó�� ǰ�� ����Ʈ"
rr_1 rr_1
end type
global w_imt_01560 w_imt_01560

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_frcode, ls_tocode, emp1, emp2, ls_gu, sortg, bomg

if dw_ip.AcceptText() = -1 then return -1

ls_frcode = dw_ip.GetItemString(1, 'fr_code')
ls_tocode = dw_ip.GetItemString(1, 'to_code')
emp1 = dw_ip.GetItemString(1, 'emp1')
emp2 = dw_ip.GetItemString(1, 'emp2')
ls_gu     = dw_ip.GetItemString(1, 'arg_itgu')
sortg     = dw_ip.GetItemString(1, 'sortg')
bomg      = dw_ip.GetItemString(1, 'bomg')

if isnull(ls_frcode) or ls_frcode = "" then ls_frcode = '.' 
if isnull(ls_tocode) or ls_tocode = "" then ls_tocode = 'zzzzzz' 
if IsNull(emp1) or emp1 = "" then emp1 = "."
if IsNull(emp2) or emp2 = "" then emp2 = "ZZZZZZ"

// sort����
if sortg = '1' then  //ǰ��
	dw_print.setsort("vndmst_emp_id A, danmst_cvcod A, danmst_itnbr A")
else						// ǰ��
	dw_print.setsort("vndmst_emp_id A, danmst_cvcod A, itemas_itdsc A, itemas_ispec A")
end if
dw_print.sort()	
dw_print.GroupCalc()

//bom�������
if bomg = '1' then  	  //�̻��
	dw_print.setfilter("bomg = '�̻��'")
	dw_print.filter()
elseif bomg = '2' then //���
	dw_print.setfilter("bomg = '���'")	
	dw_print.filter()	
else						  //��ü
	dw_print.setfilter("")
	dw_print.filter()
end if

if dw_print.retrieve(ls_frcode, ls_tocode, ls_gu, emp1, emp2) <= 0 then 
	MessageBox("Ȯ ��", "�˻��� �ڷᰡ �������� �ʽ��ϴ�.!!")
	dw_ip.setfocus()
	return -1
else
	dw_print.sharedata(dw_list)
end if

return 1
end function

on w_imt_01560.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_imt_01560.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;///* ������ & ������ & ���ұ��� Filtering */
//DataWindowChild state_child1, state_child2, state_child3
//integer rtncode1, rtncode2, rtncode3
//
//IF gs_saupj              = '10' THEN
//	rtncode1    = dw_ip.GetChild('emp1', state_child1)
//	rtncode2    = dw_ip.GetChild('emp2', state_child2)
//	
//	IF rtncode1 = -1 THEN MessageBox("Error1", "Not a DataWindowChild")
//	IF rtncode2 = -1 THEN MessageBox("Error2", "Not a DataWindowChild")
//	
//	state_child1.setFilter("Mid(rfgub,1,1) <> 'Z'")
//	state_child2.setFilter("Mid(rfgub,1,1) <> 'Z'")
//	
//	state_child1.Filter()
//	state_child2.Filter()
//	
//ELSEIF gs_saupj      = '11' THEN
//   rtncode1    = dw_ip.GetChild('emp1', state_child1)
//	rtncode2    = dw_ip.GetChild('emp2', state_child2)
//	
//	IF rtncode1 = -1 THEN MessageBox("Error1", "Not a DataWindowChild")
//	IF rtncode2 = -1 THEN MessageBox("Error2", "Not a DataWindowChild")
//	
//	state_child1.setFilter("Mid(rfgub,1,1) = 'Z'")
//	state_child2.setFilter("Mid(rfgub,1,1) = 'Z'")
//	
//	state_child1.Filter()
//	state_child2.Filter()
//END IF

DataWindowChild state_child
integer rtncode

//�����1
rtncode 	= dw_ip.GetChild('emp1', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - �����1")
state_child.SetTransObject(SQLCA)
state_child.Retrieve('43',gs_saupj)

//�����2
rtncode 	= dw_ip.GetChild('emp2', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - �����2")
state_child.SetTransObject(SQLCA)
state_child.Retrieve('43',gs_saupj)

sle_msg.text = "��¹� - ����ũ�� : A4, ��¹��� : ���ι���"
end event

type p_preview from w_standard_print`p_preview within w_imt_01560
end type

type p_exit from w_standard_print`p_exit within w_imt_01560
end type

type p_print from w_standard_print`p_print within w_imt_01560
end type

type p_retrieve from w_standard_print`p_retrieve within w_imt_01560
end type







type st_10 from w_standard_print`st_10 within w_imt_01560
end type



type dw_print from w_standard_print`dw_print within w_imt_01560
string dataobject = "d_imt_01560_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_01560
integer x = 32
integer y = 24
integer width = 2821
integer height = 384
string dataobject = "d_imt_01560_01"
end type

event dw_ip::rbuttondown;SetNull(Gs_code)
SetNull(Gs_codename)

IF this.getcolumnname() = "fr_code" THEN
	Gs_gubun = '1'
	open(w_vndmst_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(1, "fr_code", Gs_code)
	this.SetItem(1, "fr_name", Gs_codename)
END IF

IF this.getcolumnname() = "to_code" THEN
	Gs_gubun = '1'
	open(w_vndmst_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(1, "to_code", Gs_code)
	this.SetItem(1, "to_name", Gs_codename)
END IF

end event

event dw_ip::itemchanged;string s_code, fd_code, snull

setNull(snull)

if dwo.name = "fr_code" then 
	s_code = data
   if IsNUll(s_code) or s_code = "" then
	   this.SetItem(1, "fr_name", snull)
	   return
	else
		SELECT "VNDMST"."CVNAS2"  
		  INTO :fd_code   
		  FROM "VNDMST"  
       WHERE "VNDMST"."CVCOD" = :s_code ;		
				  
		  if sqlca.sqlcode = 0 then 
			  this.SetItem(1, "fr_name", fd_code )
		  else
			  this.SetItem(1, "fr_code", snull )  
			  this.SetItem(1, "fr_name", snull )  
  		     return 1
		  end if
   end if
elseif dwo.name = "to_code" then 
	s_code = data
   if IsNUll(s_code) or s_code = "" then
	   this.SetItem(1, "to_name", snull)
	   return
	else
		SELECT "VNDMST"."CVNAS2"  
		  INTO :fd_code   
		  FROM "VNDMST"  
       WHERE "VNDMST"."CVCOD" = :s_code ;		
				  
		  if sqlca.sqlcode = 0 then 
			  this.SetItem(1, "to_name", fd_code )
		  else
			  this.SetItem(1, "to_code", snull )  
			  this.SetItem(1, "to_name", snull )  
  		     return 1
		  end if
   end if
elseif dwo.name = "sortg" then 
	
	if data = '1' then  //ǰ��
		dw_list.setsort("vndmst_emp_id A, danmst_cvcod A, danmst_itnbr A")
	else						// ǰ��
		dw_list.setsort("vndmst_emp_id A, danmst_cvcod A, itemas_itdsc A, itemas_ispec A")
	end if
	dw_list.sort()	
	dw_list.GroupCalc()

END IF
end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_imt_01560
integer y = 448
integer width = 4562
integer height = 1868
string dataobject = "d_imt_01560_02"
boolean border = false
end type

type rr_1 from roundrectangle within w_imt_01560
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 436
integer width = 4576
integer height = 1888
integer cornerheight = 40
integer cornerwidth = 55
end type

