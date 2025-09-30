$PBExportHeader$w_voda_activity_popup2.srw
$PBExportComments$PROJECT ���� POPUP
forward
global type w_voda_activity_popup2 from w_inherite_popup
end type
type p_1 from picture within w_voda_activity_popup2
end type
type p_2 from picture within w_voda_activity_popup2
end type
type p_3 from picture within w_voda_activity_popup2
end type
type rr_2 from roundrectangle within w_voda_activity_popup2
end type
end forward

global type w_voda_activity_popup2 from w_inherite_popup
integer x = 407
integer y = 276
integer width = 1838
integer height = 2188
string title = "ACTIVITY ���� POPUP"
p_1 p_1
p_2 p_2
p_3 p_3
rr_2 rr_2
end type
global w_voda_activity_popup2 w_voda_activity_popup2

type variables
string is_proj_code
end variables

on w_voda_activity_popup2.create
int iCurrent
call super::create
this.p_1=create p_1
this.p_2=create p_2
this.p_3=create p_3
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_1
this.Control[iCurrent+2]=this.p_2
this.Control[iCurrent+3]=this.p_3
this.Control[iCurrent+4]=this.rr_2
end on

on w_voda_activity_popup2.destroy
call super::destroy
destroy(this.p_1)
destroy(this.p_2)
destroy(this.p_3)
destroy(this.rr_2)
end on

event open;call super::open;wstr_parm lstr_parm

/* gs_gubun : 1(����),2(������) */
dw_1.SetTransObject(sqlca)

lstr_parm = message.powerobjectparm
is_proj_code = lstr_parm.s_parm[1]

dw_1.retrieve(is_proj_code)
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_voda_activity_popup2
boolean visible = false
integer x = 23
integer y = 180
integer width = 2583
integer height = 148
string dataobject = "d_voda_activity_popup1"
end type

type p_exit from w_inherite_popup`p_exit within w_voda_activity_popup2
integer x = 1637
end type

event p_exit::clicked;call super::clicked;Long ll_return

//������ ������ �ִ����� üũ�ؼ� ������ϰ� ������ ������ �����ϸ� ����ó���Ѵ� 
if dw_1.deletedcount() > 0 or dw_1.modifiedcount() > 0  then 
	ll_return = messagebox('Ȯ��!', '����� ������ �����մϴ�! �����Ͻʰڽ��ϱ�?', Exclamation!, OKCancel!, 2)
	if ll_return = 2 then return 
end if 
SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_voda_activity_popup2
boolean visible = false
integer x = 270
integer y = 12
integer taborder = 0
string picturename = "C:\erpman\image\�߰�_up.gif"
end type

type p_choose from w_inherite_popup`p_choose within w_voda_activity_popup2
boolean visible = false
integer x = 101
integer y = 24
string picturename = "C:\erpman\image\����_up.gif"
end type

event p_choose::clicked;call super::clicked;long ll_i, ll_i2, ll_seq, ll_seq2, ll_return

dw_1.setsort('display_seq')
dw_1.sort()

FOR ll_i = 1 to dw_1.rowcount() 
	 ll_seq = dw_1.object.display_seq[ll_i]
	 if dw_1.rowcount() > ll_i then 
		 For ll_i2= ll_i + 1 to dw_1.rowcount() 
			 ll_seq2	= dw_1.object.display_seq[ll_i2]
			 if ll_seq = ll_seq2 then 
				 ll_return =  Messagebox('Ȯ��', '���� ������ �����մϴ�. �����Ͻðڽ��ϱ�?', Exclamation!, okcancel!,2)
				 if ll_return = 2 then 
					 Return 
				 end if 
			 end if 
		 Next 
	 end if 
Next 

dw_1.update() 

end event

type dw_1 from w_inherite_popup`dw_1 within w_voda_activity_popup2
integer x = 46
integer y = 188
integer width = 1760
integer height = 1816
integer taborder = 20
string dataobject = "d_voda_activity_popup2"
end type

event dw_1::itemchanged;call super::itemchanged;long ll_i, ll_i2, ll_seq, ll_seq2, ll_return

IF UPPER(dw_1.getcolumnname())  = 'DISPLAY_SEQ' then 
	dw_1.setsort('display_seq')
	dw_1.sort()
	
//	FOR ll_i = 1 to dw_1.rowcount() 
//		 ll_seq = dw_1.object.display_seq[ll_i]
//		 if dw_1.rowcount() > ll_i then 
//			 For ll_i2= ll_i + 1 to dw_1.rowcount() 
//				 ll_seq2	= dw_1.object.display_seq[ll_i2]
//				 if ll_seq = ll_seq2 then 
//					 ll_return =  Messagebox('Ȯ��', '���� ������ �����մϴ�. �����Ͻðڽ��ϱ�?', Exclamation!, okcancel!,2)
//					 if ll_return = 2 then 
//						 Return 
//					 end if 
//				 end if 
//			 Next 
//		 end if 
//	Next 
End if 
end event

type sle_2 from w_inherite_popup`sle_2 within w_voda_activity_popup2
boolean visible = false
integer x = 1010
integer y = 2008
integer width = 1138
boolean enabled = false
end type

event sle_2::getfocus;f_toggle_kor(Handle(this))

end event

type cb_1 from w_inherite_popup`cb_1 within w_voda_activity_popup2
boolean visible = false
integer x = 2752
integer y = 1844
boolean enabled = false
end type

type cb_return from w_inherite_popup`cb_return within w_voda_activity_popup2
boolean visible = false
integer x = 3374
integer y = 1844
boolean enabled = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_voda_activity_popup2
boolean visible = false
integer x = 3063
integer y = 1844
boolean enabled = false
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_voda_activity_popup2
boolean visible = false
integer x = 521
integer y = 2008
integer width = 471
integer limit = 11
end type

type st_1 from w_inherite_popup`st_1 within w_voda_activity_popup2
boolean visible = false
integer y = 2024
integer width = 494
string text = "C.INVOICE No."
end type

type p_1 from picture within w_voda_activity_popup2
integer x = 1289
integer y = 20
integer width = 178
integer height = 144
boolean bringtotop = true
string picturename = "C:\erpman\image\����_up.gif"
boolean focusrectangle = false
end type

event clicked;if dw_1.getrow() < 1 then return 

dw_1.deleterow(dw_1.getrow())
end event

type p_2 from picture within w_voda_activity_popup2
integer x = 1115
integer y = 20
integer width = 178
integer height = 144
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\�߰�_up.gif"
boolean focusrectangle = false
end type

event clicked;Long 		ll_row, ll_max, ll_i 
string 	ls_proj_name
datetime ld_s_date , ld_e_date

//IF dw_1.getrow() < 1 then 
//	Messagebox('Ȯ��', '�߰��ϰ��� �ϴ� ��ġ�� �����Ͻʽÿ�') 
//	Return 
//end if 

ll_row = dw_1.insertrow(dw_1.getrow() + 1 )
dw_1.object.proj_code[ll_row] = is_proj_code
//Proj_name 
select Proj_name 
  into :ls_proj_name 
  from flow_project 
 where proj_code = :is_proj_code ; 
 
if sqlca.sqlcode <> 0 then 
	messagebox('Ȯ��', sqlca.sqlerrtext ) 
	return 
end if 
dw_1.object.proj_name[ll_row] = ls_proj_name 

//Max Activity_Seq
//select max(activity_seq)  
//  into :ll_max 
//  from flow_activity 
// where proj_code = :is_proj_code ; 
// 
//if sqlca.sqlcode <> 0 then 
//	messagebox('Ȯ��', sqlca.sqlerrtext ) 
//	return 
//end if 
//
//if ll_max = 0 or isnull(ll_max) then 
//	ll_max = 1
//else
//	ll_max = ll_max +1 
//end if 
//

ll_max = dw_1.object.c_max[ll_row] 
if ll_max = 0 or isnull(ll_max) then 
	ll_max = 1 
else 
	ll_max = ll_max + 1
end if 

dw_1.object.activity_seq[ll_row] = ll_max 
dw_1.object.PROJ_SEQ[ll_row] = 1 
dw_1.object.GATEWAY_SEQ[ll_row] = 1 

//Display_seq
for ll_i = 1 to dw_1.rowcount() 
	 dw_1.object.display_seq[ll_i] = ll_i 
Next 

//������/������ 
IF ll_row > 1 then 
	ld_s_date = dw_1.object.s_date[ll_row -1] 
	ld_e_date = dw_1.object.s_date[ll_row -1]
else
	if dw_1.rowcount() = 1 then 
		select sysdate
		  into :ld_s_date 
		  from dual ; 
		ld_e_date = ld_s_date  
	else 
		ld_s_date = dw_1.object.s_date[ll_row +1] 
		ld_e_date = dw_1.object.s_date[ll_row +1]
	end if 
end if 

dw_1.object.s_date[ll_row] = ld_s_date 
dw_1.object.e_date[ll_row] = ld_e_date 

end event

type p_3 from picture within w_voda_activity_popup2
integer x = 1463
integer y = 20
integer width = 178
integer height = 144
boolean bringtotop = true
string picturename = "C:\erpman\image\����_up.gif"
boolean focusrectangle = false
end type

event clicked;long ll_i, ll_i2, ll_seq, ll_seq2, ll_return

dw_1.setsort('display_seq')
dw_1.sort()

FOR ll_i = 1 to dw_1.rowcount() 
	 ll_seq = dw_1.object.display_seq[ll_i]
	 if dw_1.rowcount() > ll_i then 
		 For ll_i2= ll_i + 1 to dw_1.rowcount() 
			 ll_seq2	= dw_1.object.display_seq[ll_i2]
			 if ll_seq = ll_seq2 then 
				 ll_return =  Messagebox('Ȯ��', '���� ������ �����մϴ�. �����Ͻðڽ��ϱ�?', Exclamation!, okcancel!,2)
				 if ll_return = 2 then 
					 Return 
				 end if 
			 end if 
		 Next 
	 end if 
Next 

dw_1.update() 

end event

type rr_2 from roundrectangle within w_voda_activity_popup2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 176
integer width = 1797
integer height = 1856
integer cornerheight = 40
integer cornerwidth = 55
end type

