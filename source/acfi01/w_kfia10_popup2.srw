$PBExportHeader$w_kfia10_popup2.srw
$PBExportComments$어음수표책 보조등록(조회버튼)
forward
global type w_kfia10_popup2 from window
end type
type p_can from uo_picture within w_kfia10_popup2
end type
type p_exit from uo_picture within w_kfia10_popup2
end type
type dw_list from datawindow within w_kfia10_popup2
end type
type dw_1 from u_key_enter within w_kfia10_popup2
end type
end forward

global type w_kfia10_popup2 from window
integer x = 741
integer y = 424
integer width = 2290
integer height = 924
boolean titlebar = true
string title = "어음/수표책 조회 조건"
windowtype windowtype = response!
long backcolor = 32106727
p_can p_can
p_exit p_exit
dw_list dw_list
dw_1 dw_1
end type
global w_kfia10_popup2 w_kfia10_popup2

type variables
Boolean itemerr =False

s_us_in lstr_us_in                 //어음수표

end variables

event open;string max_no, min_no

f_window_center_Response(this)

dw_1.SetTransObject(SQLCA)
dw_1.Reset()

dw_1.SetRedraw(False)
   
SELECT MAX("KFM06OT0"."CHECK_NO"), MIN("KFM06OT0"."CHECK_NO")    
	INTO :max_no, :min_no  
   FROM "KFM06OT0"  ;
  
dw_1.InsertRow(0)
dw_1.SetItem(dw_1.GetRow(),"check_no1", min_no)
dw_1.SetItem(dw_1.GetRow(),"check_no2", max_no)

dw_1.SetItem(dw_1.GetRow(),"pur_date",  Left(F_Today(),6)+'01')
dw_1.SetItem(dw_1.GetRow(),"pur_date2", F_Today())
	
dw_1.SetRedraw(True)
dw_1.SetColumn("check_bnk")
dw_1.SetFocus()


end event

on w_kfia10_popup2.create
this.p_can=create p_can
this.p_exit=create p_exit
this.dw_list=create dw_list
this.dw_1=create dw_1
this.Control[]={this.p_can,&
this.p_exit,&
this.dw_list,&
this.dw_1}
end on

on w_kfia10_popup2.destroy
destroy(this.p_can)
destroy(this.p_exit)
destroy(this.dw_list)
destroy(this.dw_1)
end on

type p_can from uo_picture within w_kfia10_popup2
integer x = 2071
integer width = 178
integer taborder = 30
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;lstr_us_in.flag = '2' 

CloseWithReturn(parent,lstr_us_in)	 

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

type p_exit from uo_picture within w_kfia10_popup2
integer x = 1897
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;
dw_list.SetTransObject(SQLCA)

IF dw_1.AcceptText() = -1 then return 

lstr_us_in.schk_bnk  = Trim(dw_1.GetitemString(1, "check_bnk"))
lstr_us_in.schk_bnk2 = Trim(dw_1.GetitemString(1, "check_bnk2"))
IF lstr_us_in.schk_bnk ="" OR ISNULL(lstr_us_in.schk_bnk) THEN
	select min(person_cd)	into :lstr_us_in.schk_bnk	from kfz04om0	where person_gu = '2' ;
END IF
IF lstr_us_in.schk_bnk2 ="" OR ISNULL(lstr_us_in.schk_bnk2) THEN
	select max(person_cd)	into :lstr_us_in.schk_bnk2	from kfz04om0	where person_gu = '2' ;
END IF

IF	lstr_us_in.schk_bnk > lstr_us_in.schk_bnk2 THEN
   MessageBox("확인", "금융기관범위를 확인하십시오.!!")
   dw_1.SetColumn("check_bnk")
   dw_1.SetFocus()
   Return 
END IF

lstr_us_in.spur_date = Trim(dw_1.GetitemString(1, "pur_date"))
lstr_us_in.spur_date2= Trim(dw_1.GetitemString(1, "pur_date2"))
IF lstr_us_in.spur_date ="" OR ISNULL(lstr_us_in.spur_date) THEN
	MessageBox("확인", "매입일자를 입력하십시오.!!")
   dw_1.SetColumn("pur_date")
   dw_1.SetFocus()
   Return 
ELSE
	IF f_datechk(lstr_us_in.spur_date) = -1 THEN
		MessageBox("확인", "매입일자를 확인하십시오.!!")
		dw_1.SetColumn("pur_date")
		dw_1.SetFocus()
		Return 
	END IF	
END IF         

IF lstr_us_in.spur_date2 ="" OR ISNULL(lstr_us_in.spur_date2) THEN
	MessageBox("확인", "매입일자를 입력하십시오.!!")
   dw_1.SetColumn("pur_date2")
   dw_1.SetFocus()
   Return 
ELSE
	IF f_datechk(lstr_us_in.spur_date2) = -1 THEN
		MessageBox("확인", "매입일자를 확인하십시오.!!")
		dw_1.SetColumn("pur_date2")
		dw_1.SetFocus()
		Return 
	END IF	
END IF         

IF lstr_us_in.spur_date > lstr_us_in.spur_date2 THEN
	MessageBox("확인", "매입일자범위를 확인하십시오.!!")
   dw_1.SetColumn("pur_date2")
   dw_1.SetFocus()
   Return 
END IF

lstr_us_in.schk_no1 = Trim(dw_1.GetitemString(1, "check_no1"))
lstr_us_in.schk_no2 = Trim(dw_1.GetitemString(1, "check_no2"))
IF lstr_us_in.schk_no1 ="" OR ISNULL(lstr_us_in.schk_no1) THEN
	SELECT MIN("KFM06OT0"."CHECK_NO")   INTO :lstr_us_in.schk_no1  FROM "KFM06OT0"  ;
END IF
IF lstr_us_in.schk_no2 ="" OR ISNULL(lstr_us_in.schk_no2) THEN
	SELECT MAX("KFM06OT0"."CHECK_NO")    INTO :lstr_us_in.schk_no2    FROM "KFM06OT0"  ;
END IF

IF	long(lstr_us_in.schk_no1) > long(lstr_us_in.schk_no2) THEN
   MessageBox("확인", "용지번호 범위를 확인하십시오.!!")
   dw_1.SetColumn("check_no1")
   dw_1.SetFocus()
   Return 
END IF
lstr_us_in.schk_gu = Trim(dw_1.GetitemString(1, "check_gu"))

lstr_us_in.suse_gu = Trim(dw_1.GetitemString(1, "use_gu"))
IF lstr_us_in.suse_gu ="" OR ISNULL(lstr_us_in.suse_gu) THEN
	lstr_us_in.suse_gu = '%'
END IF         

IF dw_list.Retrieve(lstr_us_in.schk_bnk, lstr_us_in.schk_bnk2, lstr_us_in.spur_date, &
                    lstr_us_in.spur_date2, lstr_us_in.schk_gu, lstr_us_in.schk_no1, & 
						  lstr_us_in.schk_no2,lstr_us_in.suse_gu ) <= 0  THEN
	F_MessageChk(14,'')
	return -1 
END IF

lstr_us_in.flag = '1'
CloseWithReturn(parent,lstr_us_in)	 
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

type dw_list from datawindow within w_kfia10_popup2
boolean visible = false
integer x = 878
integer y = 904
integer width = 494
integer height = 120
boolean titlebar = true
string title = "어음수표책등록자료조회"
string dataobject = "dw_kfia10_popup2_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
end type

type dw_1 from u_key_enter within w_kfia10_popup2
integer x = 9
integer y = 152
integer width = 2245
integer height = 668
integer taborder = 10
string dataobject = "dw_kfia10_popup2"
boolean border = false
end type

