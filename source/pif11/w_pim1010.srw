$PBExportHeader$w_pim1010.srw
$PBExportComments$** 참조코드등록
forward
global type w_pim1010 from w_inherite_multi
end type
type dw_detail from datawindow within w_pim1010
end type
type dw_list from datawindow within w_pim1010
end type
type rr_1 from roundrectangle within w_pim1010
end type
type rr_2 from roundrectangle within w_pim1010
end type
end forward

global type w_pim1010 from w_inherite_multi
string title = "참조코드 관리"
dw_detail dw_detail
dw_list dw_list
rr_1 rr_1
rr_2 rr_2
end type
global w_pim1010 w_pim1010

type variables
char c_status
String gsgubun,gsname

end variables

forward prototypes
public function integer err_check ()
public function integer key_check ()
end prototypes

public function integer err_check ();long    row_count, find_count, seek_count
string  rfgub_check 

FOR row_count=1 TO dw_list.rowcount()
    // 참조코드 check
    if dw_list.getitemstring(row_count, "code") = "" or &       
       isnull(dw_list.getitemstring(row_count, "code")) then
       dw_list.setcolumn("code")
       dw_list.setrow(row_count)
       F_MessageChk(1,'[참조코드]')
       dw_list.setfocus()
       return -1
    end if

    // 참조명1 check
    if dw_list.getitemstring(row_count, "codenm") = "" or &       
       isnull(dw_list.getitemstring(row_count, "codenm")) then
       dw_list.setcolumn("codenm")
       dw_list.setrow(row_count)
       F_MessageChk(1,'[참조명(FULL)]')
       dw_list.setfocus()
       return -1
    end if
    

NEXT

FOR row_count=1 TO dw_list.rowcount() - 1
    
    seek_count = row_count+1
    rfgub_check = dw_list.getitemstring(row_count, "code")    
    find_count  = dw_list.find("code = '"+ rfgub_check +"'", seek_count, dw_list.rowcount())    
    if find_count > 0 then  /* duplicate */
       messagebox("참조코드", "동일한 참조코드가 발생하였읍니다.", stopsign!)
       dw_list.setcolumn("code")
       dw_list.setrow(find_count)
       dw_list.setfocus()
       return -1
    end if
NEXT


return 0


end function

public function integer key_check ();long   row_count
string r_check, sKey,sgubun,sname,sparm

dw_detail.enabled = true
if dw_detail.accepttext() = -1	then	return 1

// 구분코드
sKey = dw_detail.getitemstring(1, "codegbn")

  SELECT count(*)
   INTO :row_count
   FROM P0_REF
  WHERE P0_REF.codegbn = :sKey ;
  
 if row_count = 0 or isnull(row_count) then

//   openwithparm(w_pim1010_response, sKey) 

	sparm =message.StringParm
	
	sgubun =Left(sparm,1)
	sname  =Mid(sparm,2,20)
	// 신규등록시
   if sgubun = "1" then
      dw_detail.setitem(1, "codenm", sName)
      c_status = "1"
      dw_detail.enabled = false
		
		p_mod.enabled = true
		p_mod.PictureName = "C:\erpman\image\저장_up.gif"
		p_ins.enabled = true
		p_ins.PictureName = "C:\erpman\image\추가_up.gif"
		p_del.enabled = true
		p_del.PictureName = "C:\erpman\image\삭제_up.gif"
		
      dw_list.enabled = true
      p_ins.triggerevent(clicked!)
      dw_list.setfocus()

	// 취소시
   else
//      cb_check()
      return 1 
   end if


else

      dw_detail.retrieve(sKey)
      dw_list.retrieve(sKey)
      c_status = "2"
      p_mod.enabled = true
		p_mod.PictureName = "C:\erpman\image\저장_up.gif"
		p_ins.enabled = true
		p_ins.PictureName = "C:\erpman\image\추가_up.gif"
		p_del.enabled = true
		p_del.PictureName = "C:\erpman\image\삭제_up.gif"
		//cb_print.enabled = true
      dw_detail.enabled = false
      dw_list.enabled = true
      dw_list.setfocus()
		
end if

return 0
end function

on w_pim1010.create
int iCurrent
call super::create
this.dw_detail=create dw_detail
this.dw_list=create dw_list
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detail
this.Control[iCurrent+2]=this.dw_list
this.Control[iCurrent+3]=this.rr_1
this.Control[iCurrent+4]=this.rr_2
end on

on w_pim1010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_detail)
destroy(this.dw_list)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_list.settransobject(sqlca)
dw_detail.settransobject(sqlca)
dw_list.retrieve()
dw_detail.reset()
end event

type p_delrow from w_inherite_multi`p_delrow within w_pim1010
integer x = 4471
integer y = 2532
end type

type p_addrow from w_inherite_multi`p_addrow within w_pim1010
integer x = 4297
integer y = 2532
end type

type p_search from w_inherite_multi`p_search within w_pim1010
integer x = 3771
integer y = 2528
end type

type p_ins from w_inherite_multi`p_ins within w_pim1010
integer x = 3680
end type

event p_ins::clicked;long ll_row

dw_detail.scrolltorow(dw_detail.insertrow(0))

dw_detail.setitem(dw_detail.rowcount(), "codegbn", gsgubun )

dw_detail.setfocus()
dw_detail.setcolumn('code')

p_can.enabled = true
p_can.PictureName = "C:\erpman\image\취소_up.gif"


end event

type p_exit from w_inherite_multi`p_exit within w_pim1010
integer x = 4375
end type

type p_can from w_inherite_multi`p_can within w_pim1010
integer x = 4201
end type

event p_can::clicked;dw_detail.retrieve(gsgubun)
end event

type p_print from w_inherite_multi`p_print within w_pim1010
integer x = 3945
integer y = 2528
end type

type p_inq from w_inherite_multi`p_inq within w_pim1010
integer x = 4119
integer y = 2528
end type

type p_del from w_inherite_multi`p_del within w_pim1010
integer x = 4027
end type

event p_del::clicked;string sgbn,scod
long   row , chk

row   = dw_detail.getrow()
sgbn  = dw_detail.getitemstring(row,'codegbn')
scod  = dw_detail.getitemstring(row,'code')
chk   = messagebox('','선택 항목을 삭제하시겠습니까?',QUESTION!,okcancel!,2)

if chk = 1 then
	dw_detail.deleterow(0)
	delete from p0_ref
	 where codegbn = :sgbn
	   and    code = :scod ;
   commit;
	messagebox('','자료가 삭제 되었습니다.',exclamation!)
else
	return
end if

dw_detail.retrieve(gsgubun)
end event

type p_mod from w_inherite_multi`p_mod within w_pim1010
integer x = 3854
end type

event p_mod::clicked;call super::clicked;dw_detail.update()
commit;
dw_detail.retrieve(gsgubun)

ib_any_typing = false
end event

type dw_insert from w_inherite_multi`dw_insert within w_pim1010
integer x = 183
integer y = 2416
integer width = 114
integer height = 108
end type

type st_window from w_inherite_multi`st_window within w_pim1010
end type

type cb_append from w_inherite_multi`cb_append within w_pim1010
end type

type cb_exit from w_inherite_multi`cb_exit within w_pim1010
end type

type cb_update from w_inherite_multi`cb_update within w_pim1010
end type

type cb_insert from w_inherite_multi`cb_insert within w_pim1010
end type

type cb_delete from w_inherite_multi`cb_delete within w_pim1010
end type

type cb_retrieve from w_inherite_multi`cb_retrieve within w_pim1010
end type

type st_1 from w_inherite_multi`st_1 within w_pim1010
end type

type cb_cancel from w_inherite_multi`cb_cancel within w_pim1010
end type

type dw_datetime from w_inherite_multi`dw_datetime within w_pim1010
end type

type sle_msg from w_inherite_multi`sle_msg within w_pim1010
end type

type gb_2 from w_inherite_multi`gb_2 within w_pim1010
end type

type gb_1 from w_inherite_multi`gb_1 within w_pim1010
end type

type gb_10 from w_inherite_multi`gb_10 within w_pim1010
end type

type dw_detail from datawindow within w_pim1010
event dw_detail_key pbm_dwnkey
event ue_downenter pbm_dwnprocessenter
integer x = 1691
integer y = 268
integer width = 2409
integer height = 1896
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_pim1010_02"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event dw_detail_key;
if keydown(keytab!) and dw_list.getcolumnname() = "reffpf_rfna2" then
   if dw_list.rowcount() = dw_list.getrow() then
   	if keydown(keyshift!) then

   	else
      	cb_insert.postevent(clicked!)
   	end if
   end if
end if
end event

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

on editchanged; ib_any_typing = true
end on

event itemerror;
RETURN 1
end event

event itemfocuschanged;Long wnd

wnd =Handle(this)

IF dwo.name ="rfna1" OR dwo.name ="rfna2" THEN
	f_toggle_kor(wnd)
ELSE
	f_toggle_eng(wnd)
END IF
end event

event retrieveend;if this.rowcount() < 1 then
	w_mdi_frame.sle_msg.text = '아직 등록된 사항이 없습니다.'
	p_del.enabled = false
	p_del.PictureName = "C:\erpman\image\삭제_d.gif"	
else
	w_mdi_frame.sle_msg.text = string(this.rowcount()) + '개의 코드가 등록 되어있습니다.'
	p_del.enabled = true
	p_del.PictureName = "C:\erpman\image\삭제_up.gif"		
end if
end event

on rowfocuschanged;this.setrowfocusindicator ( HAND! )
end on

event dberror;return 1
end event

type dw_list from datawindow within w_pim1010
event uevent_keypress pbm_dwnkey
integer x = 270
integer y = 276
integer width = 1330
integer height = 1884
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_pim1010_01"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;string sCod
long ll_row

ll_row = dw_list.rowcount()

if row < 1 then return
if row > ll_row then return

this.selectrow(0,false)
this.selectrow(row,true)

sCod = this.getitemstring(row,1)
dw_detail.retrieve(sCod)
gsgubun = sCod
end event

event itemerror;return 1
end event

event rowfocuschanged;if this.rowcount() < 1 then return

this.selectrow(0,false)
this.selectrow(currentrow,true)

gsgubun = this.getitemstring(currentrow,'codegbn')
dw_detail.retrieve(gsgubun)
end event

type rr_1 from roundrectangle within w_pim1010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 261
integer y = 272
integer width = 1353
integer height = 1904
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_pim1010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1673
integer y = 264
integer width = 2533
integer height = 1904
integer cornerheight = 40
integer cornerwidth = 46
end type

