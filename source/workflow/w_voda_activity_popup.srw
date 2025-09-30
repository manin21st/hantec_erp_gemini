$PBExportHeader$w_voda_activity_popup.srw
$PBExportComments$PROJECT 선택 POPUP
forward
global type w_voda_activity_popup from w_inherite_popup
end type
type p_1 from picture within w_voda_activity_popup
end type
type p_2 from picture within w_voda_activity_popup
end type
type p_3 from picture within w_voda_activity_popup
end type
type rr_2 from roundrectangle within w_voda_activity_popup
end type
end forward

global type w_voda_activity_popup from w_inherite_popup
integer x = 407
integer y = 276
integer width = 1838
integer height = 2188
string title = "ACTIVITY 조정 POPUP"
p_1 p_1
p_2 p_2
p_3 p_3
rr_2 rr_2
end type
global w_voda_activity_popup w_voda_activity_popup

type variables
string is_proj_code
end variables

on w_voda_activity_popup.create
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

on w_voda_activity_popup.destroy
call super::destroy
destroy(this.p_1)
destroy(this.p_2)
destroy(this.p_3)
destroy(this.rr_2)
end on

event open;call super::open;wstr_parm lstr_parm

/* gs_gubun : 1(영업),2(연구소) */
dw_1.SetTransObject(sqlca)

lstr_parm = message.powerobjectparm
is_proj_code = lstr_parm.s_parm[1]

dw_1.retrieve(is_proj_code)
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_voda_activity_popup
boolean visible = false
integer x = 23
integer y = 180
integer width = 2583
integer height = 148
string dataobject = "d_voda_activity_popup1"
end type

type p_exit from w_inherite_popup`p_exit within w_voda_activity_popup
integer x = 1637
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event p_exit::clicked;call super::clicked;Long ll_return

//삭제된 정보가 있는지를 체크해서 저장안하고 삭제된 내역이 존재하면 리턴처리한다 
if dw_1.deletedcount() > 0 or dw_1.modifiedcount() > 0  then 
	ll_return = messagebox('확인!', '변경된 내역이 존재합니다! 진행하십겠습니까?', Exclamation!, OKCancel!, 2)
	if ll_return = 2 then return 
end if 
SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

event p_exit::ue_lbuttondown;PictureName = 'C:\erpman\image\닫기_dn.gif'
end event

event p_exit::ue_lbuttonup;PictureName = 'C:\erpman\image\닫기_up.gif'
end event

type p_inq from w_inherite_popup`p_inq within w_voda_activity_popup
boolean visible = false
integer x = 270
integer y = 12
integer taborder = 0
string picturename = "C:\erpman\image\추가_up.gif"
end type

type p_choose from w_inherite_popup`p_choose within w_voda_activity_popup
boolean visible = false
integer x = 101
integer y = 24
string picturename = "C:\erpman\image\저장_up.gif"
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
				 ll_return =  Messagebox('확인', '같은 순번이 존재합니다. 조정하시겠습니까?', Exclamation!, okcancel!,2)
				 if ll_return = 2 then 
					 Return 
				 end if 
			 end if 
		 Next 
	 end if 
Next 

dw_1.update() 

end event

type dw_1 from w_inherite_popup`dw_1 within w_voda_activity_popup
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
//					 ll_return =  Messagebox('확인', '같은 순번이 존재합니다. 조정하시겠습니까?', Exclamation!, okcancel!,2)
//					 if ll_return = 2 then 
//						 Return 
//					 end if 
//				 end if 
//			 Next 
//		 end if 
//	Next 
End if 
end event

type sle_2 from w_inherite_popup`sle_2 within w_voda_activity_popup
boolean visible = false
integer x = 1010
integer y = 2008
integer width = 1138
boolean enabled = false
end type

event sle_2::getfocus;f_toggle_kor(Handle(this))

end event

type cb_1 from w_inherite_popup`cb_1 within w_voda_activity_popup
boolean visible = false
integer x = 2752
integer y = 1844
boolean enabled = false
end type

type cb_return from w_inherite_popup`cb_return within w_voda_activity_popup
boolean visible = false
integer x = 3374
integer y = 1844
boolean enabled = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_voda_activity_popup
boolean visible = false
integer x = 3063
integer y = 1844
boolean enabled = false
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_voda_activity_popup
boolean visible = false
integer x = 521
integer y = 2008
integer width = 471
integer limit = 11
end type

type st_1 from w_inherite_popup`st_1 within w_voda_activity_popup
boolean visible = false
integer y = 2024
integer width = 494
string text = "C.INVOICE No."
end type

type p_1 from picture within w_voda_activity_popup
integer x = 1289
integer y = 20
integer width = 178
integer height = 144
boolean bringtotop = true
string picturename = "C:\erpman\image\삭제_up.gif"
boolean focusrectangle = false
end type

event clicked;string ls_proj_code, ls_proj_file[10]
Long   ll_proj_seq, ll_gateway_seq, ll_activity_seq, ll_i 

if dw_1.getrow() < 1 then return 

ls_proj_code 		= dw_1.object.proj_code[dw_1.getrow()]
ll_proj_seq 		= dw_1.object.proj_seq[dw_1.getrow()]
ll_gateway_seq 	= dw_1.object.gateway_seq[dw_1.getrow()]
ll_activity_seq 	= dw_1.object.activity_seq[dw_1.getrow()]

select product_file1,
		 product_file2,
		 product_file3,
		 product_file4,
		 product_file5,
		 Attach_file1,
		 Attach_file2, 
		 Attach_file3, 
		 Attach_file4,
		 Attach_file5
  into :ls_proj_file[1],
  		 :ls_proj_file[2],
  		 :ls_proj_file[3],
  		 :ls_proj_file[4],
  		 :ls_proj_file[5],
  		 :ls_proj_file[6],
  		 :ls_proj_file[7],
  		 :ls_proj_file[8],
  		 :ls_proj_file[9],
  		 :ls_proj_file[2]
  from flow_activity_blob
 where proj_code = :ls_proj_code 
   and proj_seq  = :ll_proj_seq
	and gateway_seq = :ll_gateway_seq 
	and activity_seq = :ll_activity_seq ; 
	
if sqlca.sqlcode = -1 then 
	Messagebox('확인', sqlca.sqlerrtext)
	Return 
End if 



 //파일 등록 유무체크 
 for ll_i = 1 to 10 
	if trim(ls_proj_file[ll_i]) <> '' and isnull(ls_proj_file[ll_i]) = false then 
		Messagebox('확인', '삭제하고자 한 프로세스에 이미 파일이 등록되어 있습니다. ~n 해당 프로세스를 삭제 하기위해서는 등록된 파일을 먼저 삭제하셔야 합니다.' ) 
		Return
	End if 
 Next 

//
Delete from Flow_activity_blob 
 where proj_code = :ls_proj_code 
   and proj_seq  = :ll_proj_seq
	and gateway_seq = :ll_gateway_seq 
	and activity_seq = :ll_activity_seq ; 

if sqlca.sqlcode = -1 then 
	Messagebox('확인', sqlca.sqlerrtext)
	Return 
End if 

dw_1.deleterow(dw_1.getrow())
//
//"FLOW_ACTIVITY"."PROJ_CODE",
//			"FLOW_ACTIVITY"."PROJ_SEQ",
//			"FLOW_ACTIVITY"."GATEWAY_SEQ",
//			"FLOW_ACTIVITY"."ACTIVITY_SEQ",
//			
//
//
end event

type p_2 from picture within w_voda_activity_popup
integer x = 1115
integer y = 20
integer width = 178
integer height = 144
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\추가_up.gif"
boolean focusrectangle = false
end type

event clicked;Long 		ll_row, ll_max, ll_i 
string 	ls_proj_name
datetime ld_s_date , ld_e_date

//IF dw_1.getrow() < 1 then 
//	Messagebox('확인', '추가하고자 하는 위치를 선택하십시오') 
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
	messagebox('확인', sqlca.sqlerrtext ) 
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
//	messagebox('확인', sqlca.sqlerrtext ) 
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

//시작일/종료일 
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

type p_3 from picture within w_voda_activity_popup
integer x = 1463
integer y = 20
integer width = 178
integer height = 144
boolean bringtotop = true
string picturename = "C:\erpman\image\저장_up.gif"
boolean focusrectangle = false
end type

event clicked;long ll_i, ll_i2, ll_i3, ll_seq, ll_seq2, ll_return

dw_1.setsort('display_seq')
dw_1.sort()

FOR ll_i = 1 to dw_1.rowcount() 
	 ll_seq = dw_1.object.display_seq[ll_i]
	 if dw_1.rowcount() > ll_i then 
		 For ll_i2= ll_i + 1 to dw_1.rowcount() 
			 ll_seq2	= dw_1.object.display_seq[ll_i2]
			 if ll_seq = ll_seq2 then 
				 ll_return =  Messagebox('확인', '같은 순번이 존재합니다. 자동조정하시겠습니까?', Exclamation!, okcancel!,2)
				 
				 if ll_return = 2 then 
					 Return
//				 ELSE 
//					 FOR ll_i3 = 1 to dw_1.rowcount() 
//					     dw_1.object.display_seq[ll_i3] = ll_i3
//					 Next 
				 end if
				 
			 end if 
		 Next 
	 end if 
	 
Next 

//순번 재조정
FOR ll_i3 = 1 to dw_1.rowcount() 
	 dw_1.object.display_seq[ll_i3] = ll_i3
Next 

dw_1.update() 

COMMIT USING SQLCA ; 
end event

type rr_2 from roundrectangle within w_voda_activity_popup
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

