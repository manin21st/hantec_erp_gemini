$PBExportHeader$w_kbgc03.srw
$PBExportComments$과목별예실차이분석조회(완료)
forward
global type w_kbgc03 from w_standard_print
end type
type p_3 from uo_picture within w_kbgc03
end type
type p_2 from uo_picture within w_kbgc03
end type
type st_1 from statictext within w_kbgc03
end type
type gb_3 from groupbox within w_kbgc03
end type
type rr_1 from roundrectangle within w_kbgc03
end type
type dw_ret from datawindow within w_kbgc03
end type
end forward

global type w_kbgc03 from w_standard_print
string title = "과목별 예실차이분석 조회"
boolean maxbox = true
boolean resizable = true
event keyup pbm_keyup
p_3 p_3
p_2 p_2
st_1 st_1
gb_3 gb_3
rr_1 rr_1
dw_ret dw_ret
end type
global w_kbgc03 w_kbgc03

type variables
long il_rowno
String s_strparm
Boolean ib_any_typing
end variables

forward prototypes
public function integer wf_warndataloss (string as_titletext)
end prototypes

public function integer wf_warndataloss (string as_titletext);/*=============================================================================================
		 1. window-level user function : 종료, 등록시 호출됨
		    dw_detail 의 typing(datawindow) 변경사항 검사

		 2. 계속진행할 경우 변경사항이 저장되지 않음을 경고                                                               

		 3. Argument:  as_titletext (warning messagebox)                                                                          
		    Return values:                                                   
                                                                  
      	*  1 : 변경사항을 저장하지 않고 계속 진행할 경우.
			* -1 : 진행을 중단할 경우.                      
=============================================================================================*/

IF ib_any_typing = true THEN  				// EditChanged event(dw_detail)의 typing 상태확인

	Beep(1)
	IF MessageBox("확인 : " + as_titletext , &
		 "저장하지 않은 값이 있습니다. ~r변경사항을 저장하시겠습니까", &
		 question!, yesno!) = 1 THEN

		RETURN -1									

	END IF

END IF
																
RETURN 1												// (dw_detail) 에 변경사항이 없거나 no일 경우
														// 변경사항을 저장하지 않고 계속진행 

end function

event open;call super::open;
dw_datetime.SetTransObject(SQLCA)
dw_datetime.InsertRow(0)

dw_ret.settransobject(sqlca)
//dw_ret.Reset()
//dw_ret.InsertRow(0)

//sle_accname.text = ""
sle_msg.text = ""

dw_ip.Setitem(dw_ip.Getrow(),"saupj",gs_saupj)
dw_ip.Setitem(dw_ip.Getrow(),"acc_yy",Left(string(today(),"yyyy/mm/dd"),4))
dw_ip.Setitem(dw_ip.Getrow(),"acc_mm",Mid(string(today(),"yyyy/mm/dd"),6,2))
dw_ip.SetColumn("kfz01om0_ye_gu")
dw_Ip.SetFocus()

IF F_Valid_EmpNo(Gs_EmpNo) = 'Y' THEN
	dw_ip.Modify("saupj.protect = 0")
	//dw_ip.Modify("saupj.background.color ='"+String(RGB(255,255,255))+"'")		
ELSE
	dw_ip.Modify("saupj.protect = 1")
	//dw_ip.Modify("saupj.background.color ='"+String(RGB(192,192,192))+"'")			
END IF

p_print.Enabled =False

end event

on w_kbgc03.create
int iCurrent
call super::create
this.p_3=create p_3
this.p_2=create p_2
this.st_1=create st_1
this.gb_3=create gb_3
this.rr_1=create rr_1
this.dw_ret=create dw_ret
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_3
this.Control[iCurrent+2]=this.p_2
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.gb_3
this.Control[iCurrent+5]=this.rr_1
this.Control[iCurrent+6]=this.dw_ret
end on

on w_kbgc03.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.p_3)
destroy(this.p_2)
destroy(this.st_1)
destroy(this.gb_3)
destroy(this.rr_1)
destroy(this.dw_ret)
end on

type p_preview from w_standard_print`p_preview within w_kbgc03
boolean visible = false
integer x = 4233
integer y = 1068
end type

type p_exit from w_standard_print`p_exit within w_kbgc03
integer x = 4411
integer y = 44
integer taborder = 60
end type

event p_exit::clicked;call super::clicked;//sle_msg.text =""
//IF wf_warndataloss("종료") = -1 THEN  	RETURN

end event

type p_print from w_standard_print`p_print within w_kbgc03
integer x = 4238
integer y = 44
integer taborder = 50
end type

event clicked;string ls_saupj, ls_acc_yy, ls_acc_mm, ls_ye_gu, ls_acc1_cd, ls_acc2_cd,sql_saupj,&
		 sql_yesan, ls_jun_yy, ls_jun_mm, ls_yegu
Int ll_temp

dw_print.Reset()
SetPointer(HourGlass!)
dw_ip.AcceptText()

ls_saupj   = dw_ip.Getitemstring(dw_ip.Getrow(),"saupj")
ls_acc_yy  = dw_ip.Getitemstring(dw_ip.Getrow(),"acc_yy")
ls_acc_mm  = dw_ip.Getitemstring(dw_ip.Getrow(),"acc_mm")
ls_ye_gu   = dw_ip.Getitemstring(dw_ip.Getrow(),"kfz01om0_ye_gu")
ls_acc1_cd = dw_ip.Getitemstring(dw_ip.Getrow(),"acc1_cd")
ls_acc2_cd = dw_ip.Getitemstring(dw_ip.Getrow(),"acc2_cd")

//코드검사
if ls_saupj = "" or IsNull(ls_saupj) then
   messagebox("확인","사업장코드를 확인하십시오!")
   return
else
  SELECT "REFFPF"."RFNA1"  
   INTO  :sql_saupj
   FROM "REFFPF"  
   WHERE "REFFPF"."RFGUB" = :ls_saupj and
         "REFFPF"."RFCOD" = 'AD' using sqlca ;
   if sqlca.sqlcode <> 0 then
      messagebox("확인","사업장코드를 확인하십시오!")
      return
   end if
end if

if ls_acc_yy = "" or IsNull(ls_acc_yy) then
   messagebox("확인","회계년도를 확인하십시오!")
   return
else
   if Not IsNumber(ls_acc_yy) then
      messagebox("확인","회계년도를 확인하십시오!")
      return
   end if
end if
ll_temp = Integer(ls_acc_yy) - 1
ls_jun_yy = String(ll_temp)   //전년도값 계산//

if ls_acc_mm = "" or IsNull(ls_acc_mm) then
   messagebox("확인","회계월을 확인하십시오!")
   return
else
   if ls_acc_yy < "01" or ls_acc_mm > "12" then
      messagebox("확인","회계월을 확인하십시오!")
      return
   end if
end if

if f_datechk(ls_acc_yy+ls_acc_mm+"01") = -1 then
   messagebox("확인","회계년월을 확인하십시오!")
   return
end if
if Integer(ls_acc_mm) > 10 then     //전월값 계산//
   ls_jun_mm = String(Integer(ls_acc_mm) - 1)
else
   ls_jun_mm = "0" + String(Integer(ls_acc_mm) - 1)
end if

if ls_ye_gu = ""  or IsNull(ls_ye_gu) then
   ls_ye_gu = "%"
else
  SELECT "REFFPF"."RFNA1"  
   INTO  :sql_yesan
   FROM "REFFPF"  
   WHERE "REFFPF"."RFGUB" = :ls_ye_gu and
         "REFFPF"."RFCOD" = 'AB' using sqlca ;
   if sqlca.sqlcode <> 0 then
      messagebox("확인","예산구분코드를 확인하십시오!")
      return
   end if
end if

if ls_acc1_cd = ""  or IsNull(ls_acc1_cd) then
   ls_acc1_cd = "%"
else
   ls_acc1_cd = ls_acc1_cd + "%"
end if

if ls_acc2_cd = "  "  or IsNull(ls_acc2_cd) then
   ls_acc2_cd = "%"
end if
IF dw_print.Retrieve(ls_saupj,ls_acc_yy,ls_acc_mm,ls_jun_yy,ls_jun_mm,ls_ye_gu,ls_acc1_cd,ls_acc2_cd) <=0 THEN
   messagebox("확인","조회할 자료가 없습니다!")
   return
ELSE
	dw_print.Modify("saupj.text ='"+sql_saupj+"'")
	dw_print.Modify("ym.text    ='"+ls_acc_yy+"/"+ls_acc_mm+"'")
end if
dw_print.Print()
sle_msg.Text = "자료가 인쇄되었습니다!"
end event

type p_retrieve from w_standard_print`p_retrieve within w_kbgc03
integer x = 3717
integer y = 44
integer taborder = 10
end type

event clicked;string ls_saupj, ls_acc_yy, ls_acc_mm, ls_ye_gu, ls_acc1_cd, ls_acc2_cd, sqlfd, sqlfd2
string ls_acc1cd, ls_acc2cd, ls_date, ls_jun_yy, ls_jun_mm
long   rowno, rownod, rownon, rownoy, rownop, i
Integer ll_temp

SetPointer(HourGlass!)
dw_ip.AcceptText()

ls_saupj   = dw_ip.Getitemstring(dw_ip.Getrow(),"saupj")
ls_acc_yy  = dw_ip.Getitemstring(dw_ip.Getrow(),"acc_yy")
ls_acc_mm  = dw_ip.Getitemstring(dw_ip.Getrow(),"acc_mm")
ls_ye_gu   = dw_ip.Getitemstring(dw_ip.Getrow(),"kfz01om0_ye_gu")
ls_acc1_cd = dw_ip.Getitemstring(dw_ip.Getrow(),"acc1_cd")
ls_acc2_cd = dw_ip.Getitemstring(dw_ip.Getrow(),"acc2_cd")

//코드검사
if ls_saupj = "" or IsNull(ls_saupj) then
   messagebox("확인","사업장코드를 확인하십시오!")
   return
else
  SELECT "REFFPF"."RFGUB"  
   INTO  :sqlfd
   FROM "REFFPF"  
   WHERE "REFFPF"."RFGUB" = :ls_saupj and
         "REFFPF"."RFCOD" = 'AD' using sqlca ;
   if sqlca.sqlcode <> 0 then
      messagebox("확인","사업장코드를 확인하십시오!")
      return
   end if
end if

if ls_acc_yy = "" or IsNull(ls_acc_yy) then
   messagebox("확인","회계년도를 확인하십시오!")
   return
else
   if Not IsNumber(ls_acc_yy) then
      messagebox("확인","회계년도를 확인하십시오!")
      return
   end if
end if
ll_temp = Integer(ls_acc_yy) - 1
ls_jun_yy = String(ll_temp)   //전년도값 계산//

if ls_acc_mm = "" or IsNull(ls_acc_mm) then
   messagebox("확인","회계월을 확인하십시오!")
   return
else
   if ls_acc_yy < "01" or ls_acc_mm > "12" then
      messagebox("확인","회계월을 확인하십시오!")
      return
   end if
end if

if f_datechk(ls_acc_yy+ls_acc_mm+"01") =  0 then
   messagebox("확인","회계년월을 확인하십시오!")
   return
end if
if Integer(ls_acc_mm) > 10 then     //전월값 계산//
   ls_jun_mm = String(Integer(ls_acc_mm) - 1)
else
   ls_jun_mm = "0" + String(Integer(ls_acc_mm) - 1)
end if

if ls_ye_gu = ""  or IsNull(ls_ye_gu) then
   ls_ye_gu = "%"
else
  SELECT "REFFPF"."RFGUB"  
   INTO  :sqlfd
   FROM "REFFPF"  
   WHERE "REFFPF"."RFGUB" = :ls_ye_gu and
         "REFFPF"."RFCOD" = 'AB' using sqlca ;
   if sqlca.sqlcode <> 0 then
      messagebox("확인","예산구분코드를 확인하십시오!")
      return
   end if
end if

if ls_acc1_cd = ""  or IsNull(ls_acc1_cd) then
   ls_acc1_cd = "%"
else
   ls_acc1_cd = ls_acc1_cd + "%"
end if

if ls_acc2_cd = "  "  or IsNull(ls_acc2_cd) then
   ls_acc2_cd = "%"
end if

IF dw_ret.Retrieve(ls_saupj,ls_acc_yy,ls_acc_mm,ls_jun_yy,ls_jun_mm,ls_ye_gu,ls_acc1_cd,ls_acc2_cd) <= 0 THEN
	MessageBox("확 인","조회한 자료가 없습니다.!!")
	Return
END IF

p_print.Enabled =True
w_mdi_frame.sle_msg.text = ""
end event



type sle_msg from w_standard_print`sle_msg within w_kbgc03
integer x = 393
integer y = 2428
integer width = 2469
end type

type dw_datetime from w_standard_print`dw_datetime within w_kbgc03
integer x = 2862
integer y = 2428
end type

type st_10 from w_standard_print`st_10 within w_kbgc03
end type



type dw_print from w_standard_print`dw_print within w_kbgc03
integer x = 3214
integer y = 68
integer width = 494
integer height = 88
boolean titlebar = true
string title = "자료인쇄"
string dataobject = "dw_kbgc03_3"
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type dw_ip from w_standard_print`dw_ip within w_kbgc03
event ue_key pbm_dwnkey
event ue_keyenter pbm_dwnprocessenter
integer x = 46
integer y = 12
integer width = 3118
integer height = 216
integer taborder = 70
string dataobject = "dw_kbgc03_1"
end type

event dw_ip::ue_key;IF keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_keyenter;Send(Handle(this),256,9,0)
end event

event itemchanged;//계정과목코드를 읽어 계정명을 표시처리//
string ls_acc1_cd, ls_acc2_cd, sqlfd, sqlfd2

dw_ip.AcceptText()
ls_acc1_cd = dw_ip.Getitemstring(dw_ip.Getrow(),"acc1_cd")
ls_acc2_cd = dw_ip.Getitemstring(dw_ip.Getrow(),"acc2_cd")
if IsNull(ls_acc2_cd) then
  SELECT "KFZ01OM0"."ACC1_NM","KFZ01OM0"."ACC2_NM"  
  INTO :sqlfd, :sqlfd2
  FROM "KFZ01OM0"  
  WHERE ( "KFZ01OM0"."ACC1_CD" = :ls_acc1_cd ) using sqlca ;
//  if sqlca.sqlcode <> 100 then
//    // sle_accname.Text = Trim(sqlfd) + " - " + Trim(sqlfd2)
//  else
//    // sle_accname.Text = ""
//  end if
else
  SELECT "KFZ01OM0"."ACC1_NM","KFZ01OM0"."ACC2_NM"  
  INTO :sqlfd, :sqlfd2
  FROM "KFZ01OM0"  
  WHERE ( "KFZ01OM0"."ACC1_CD" = :ls_acc1_cd ) AND  
        ( "KFZ01OM0"."ACC2_CD" = :ls_acc2_cd )  using sqlca ;
//  if sqlca.sqlcode = 0 then
//     //sle_accname.Text = Trim(sqlfd) + " - " + Trim(sqlfd2)
//  else
//     sle_accname.Text = ""
//  end if
end if
end event

event rbuttondown;String ls_gj1, ls_gj2

SetNull(gs_code)
SetNull(gs_codename)

IF this.GetColumnName() <> "acc1_cd" AND this.GetColumnName() <> "acc2_cd" THEN RETURN

dw_ip.AcceptText()
gs_code = Trim(dw_ip.GetItemString(dw_ip.GetRow(), "acc1_cd"))
IF IsNull(gs_code) then
	gs_code =""
end if

Open(W_KFE01OM0_POPUP)
if gs_code <> "" and Not IsNull(gs_code) then
   dw_ip.SetItem(dw_ip.GetRow(), "acc1_cd", Left(gs_code,5))
   dw_ip.SetItem(dw_ip.GetRow(), "acc2_cd", Mid(gs_code,6,2))
  // sle_accname.text = gs_codename
end if

dw_ip.Setfocus()
end event

type dw_list from w_standard_print`dw_list within w_kbgc03
boolean visible = false
end type

type p_3 from uo_picture within w_kbgc03
integer x = 4064
integer y = 44
integer width = 178
integer taborder = 40
boolean originalsize = true
string picturename = "C:\erpman\image\부서_up.gif"
end type

event clicked;if il_rowno > 0 then
   OpenSheetWithParm(w_kbgc03b,s_strparm, w_mdi_frame, 2, Layered!)
else
   messagebox("확인","자료를 선택한 후 부서버튼을 누르십시오!")
end if

w_mdi_frame.sle_msg.text = ""
end event

type p_2 from uo_picture within w_kbgc03
integer x = 3890
integer y = 44
integer width = 178
integer taborder = 30
boolean originalsize = true
string picturename = "C:\erpman\image\조정_up.gif"
end type

event clicked;if il_rowno > 0 then
   OpenSheetWithParm(w_kbgc03a,s_strparm, w_mdi_frame, 2, Layered!)
else
   messagebox("확인","자료를 선택한 후 조정버튼을 누르십시오!")
end if

w_mdi_frame.sle_msg.text = ""
end event

type st_1 from statictext within w_kbgc03
integer x = 32
integer y = 2428
integer width = 361
integer height = 84
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 12632256
boolean enabled = false
string text = "메세지"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type gb_3 from groupbox within w_kbgc03
integer x = 14
integer y = 2392
integer width = 3607
integer height = 136
integer taborder = 80
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12632256
end type

type rr_1 from roundrectangle within w_kbgc03
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 236
integer width = 4526
integer height = 1992
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_ret from datawindow within w_kbgc03
integer x = 55
integer y = 248
integer width = 4503
integer height = 1968
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_kbgc03_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;string ls_saupj, ls_acc_yy, ls_acc_mm, ls_acc1_cd, ls_acc2_cd

il_rowno = dw_ret.GetClickedRow()
If  il_rowno > 0  Then	
	 this.SelectRow(0,False)
	 this.SelectRow(il_rowno,True)
else
    Return
End If

ls_saupj   = dw_ip.Getitemstring(dw_ip.Getrow(),"saupj")
ls_acc_yy  = dw_ip.Getitemstring(dw_ip.Getrow(),"acc_yy")
ls_acc_mm  = dw_ip.Getitemstring(dw_ip.Getrow(),"acc_mm")
ls_acc1_cd = dw_ret.Getitemstring(il_rowno,"acc1_cd")
ls_acc2_cd = dw_ret.Getitemstring(il_rowno,"acc2_cd")

s_strparm = Trim(ls_saupj) + Trim(ls_acc_yy) + Trim(ls_acc_mm) + &
         Trim(ls_acc1_cd) + Trim(ls_acc2_cd)
end event

