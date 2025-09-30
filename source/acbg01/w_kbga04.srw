$PBExportHeader$w_kbga04.srw
$PBExportComments$과목별실행예산조회
forward
global type w_kbga04 from w_standard_print
end type
type st_1 from statictext within w_kbga04
end type
type cb_2 from commandbutton within w_kbga04
end type
type dw_nugey from datawindow within w_kbga04
end type
type dw_dang from datawindow within w_kbga04
end type
type rr_1 from roundrectangle within w_kbga04
end type
type dw_ret from datawindow within w_kbga04
end type
end forward

global type w_kbga04 from w_standard_print
string title = "과목별 실행예산 조회"
boolean resizable = true
event keyup pbm_keyup
st_1 st_1
cb_2 cb_2
dw_nugey dw_nugey
dw_dang dw_dang
rr_1 rr_1
dw_ret dw_ret
end type
global w_kbga04 w_kbga04

type variables
datawindowchild dw_saupjang_dropdown
datawindowchild dw_acccode_dropdown 
datawindowchild dw_deptcode_dropdown
String open_mode
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
dw_ret.settransobject(sqlca)

dw_ip.Setitem(dw_ip.Getrow(),"saupj",gs_saupj)
dw_ip.Setitem(dw_ip.Getrow(),"acc_yy",Left(string(today(),"yyyy/mm/dd"),4))
dw_ip.Setitem(dw_ip.Getrow(),"acc_mm",Mid(string(today(),"yyyy/mm/dd"),6,2))
dw_ip.SetColumn("ye_gu")
dw_ip.SetFocus()

end event

on w_kbga04.create
int iCurrent
call super::create
this.st_1=create st_1
this.cb_2=create cb_2
this.dw_nugey=create dw_nugey
this.dw_dang=create dw_dang
this.rr_1=create rr_1
this.dw_ret=create dw_ret
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.dw_nugey
this.Control[iCurrent+4]=this.dw_dang
this.Control[iCurrent+5]=this.rr_1
this.Control[iCurrent+6]=this.dw_ret
end on

on w_kbga04.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.cb_2)
destroy(this.dw_nugey)
destroy(this.dw_dang)
destroy(this.rr_1)
destroy(this.dw_ret)
end on

type p_preview from w_standard_print`p_preview within w_kbga04
boolean visible = false
integer x = 3474
integer y = 580
end type

type p_exit from w_standard_print`p_exit within w_kbga04
integer x = 4411
integer y = 12
integer taborder = 40
boolean originalsize = true
end type

event p_exit::clicked;call super::clicked;//sle_msg.text =""
//IF wf_warndataloss("종료") = -1 THEN  	RETURN

end event

type p_print from w_standard_print`p_print within w_kbga04
boolean visible = false
integer x = 3648
integer y = 580
end type

type p_retrieve from w_standard_print`p_retrieve within w_kbga04
integer x = 4233
integer y = 12
integer taborder = 20
boolean originalsize = true
end type

event clicked;string ls_saupj, ls_acc_yy, ls_acc_mm, ls_ye_gu, ls_acc1_cd, ls_acc2_cd, sqlfd, sqlfd2
string ls_acc1cd, ls_acc2cd, ls_date
long   rowno, rownod, rownon, i

SetPointer(HourGlass!)
dw_ip.AcceptText()

ls_saupj   = dw_ip.Getitemstring(dw_ip.Getrow(),"saupj")
ls_acc_yy  = dw_ip.Getitemstring(dw_ip.Getrow(),"acc_yy")
ls_acc_mm  = dw_ip.Getitemstring(dw_ip.Getrow(),"acc_mm")
ls_ye_gu   = dw_ip.Getitemstring(dw_ip.Getrow(),"ye_gu")
ls_acc1_cd = dw_ip.Getitemstring(dw_ip.Getrow(),"acc1_cd")
ls_acc2_cd = dw_ip.Getitemstring(dw_ip.Getrow(),"acc2_cd")

//코드검사
if ls_saupj = "" or IsNull(ls_saupj) then
   F_MessageChk(1,'[사업장]')
   dw_ip.SetColumn("saupj")
   dw_ip.SetFocus()
   return
else
  SELECT "REFFPF"."RFGUB"  
   INTO  :sqlfd
   FROM "REFFPF"  
   WHERE "REFFPF"."RFGUB" = :ls_saupj and
         "REFFPF"."RFCOD" = 'AD' ;
   if sqlca.sqlcode <> 0 then
      messagebox("확인","사업장코드를 확인하십시오!")
      dw_ip.SetColumn("saupj")
      dw_ip.SetFocus()
      return
   end if
	IF ls_saupj = '99' THEN ls_saupj = '%'

end if

if ls_acc_yy = "" or IsNull(ls_acc_yy) then
      F_MessageChk(1,'[회계년도]')
   dw_ip.SetColumn("acc_yy")
   dw_ip.SetFocus()
   return
else
   if Not IsNumber(ls_acc_yy) then
      messagebox("확인","회계년도를 확인하십시오!")
      dw_ip.SetColumn("acc_yy")
      dw_ip.SetFocus()
      return
   end if
end if

if ls_acc_mm = "" or IsNull(ls_acc_mm) then
      F_MessageChk(1,'[회계월]')
   dw_ip.SetColumn("acc_mm")
   dw_ip.SetFocus()
   return
else
   if ls_acc_mm < "01" or ls_acc_mm > "12" then
      messagebox("확인","회계월을 확인하십시오!")
      dw_ip.SetColumn("acc_mm")
      dw_ip.SetFocus()
      return
   end if
end if

ls_date = Trim(ls_acc_yy)+Trim(ls_acc_mm)+ "01"
if f_datechk(ls_date) = -1 then
   messagebox("확인","회계년월을 확인하십시오!")
   dw_ip.SetColumn("acc_yy")
   dw_ip.SetFocus()
   return
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
      dw_ip.SetColumn("ye_gu")
      dw_ip.SetFocus()
      return
   end if
end if

if Trim(ls_acc1_cd) = ""  or IsNull(ls_acc1_cd) then
   ls_acc1_cd = "%"
else
   ls_acc1_cd = ls_acc1_cd + "%"
end if

if Trim(ls_acc2_cd) =""  or IsNull(ls_acc2_cd) then
   ls_acc2_cd = "%"
end if

IF dw_ret.Retrieve(ls_saupj,ls_acc_yy,ls_acc_mm,ls_acc1_cd,ls_acc2_cd,ls_ye_gu) <= 0 THEN
   messagebox("확인","조회할 자료가 없습니다!")
   return
end if
end event



type sle_msg from w_standard_print`sle_msg within w_kbga04
integer x = 379
integer y = 2840
integer width = 2418
end type

type dw_datetime from w_standard_print`dw_datetime within w_kbga04
integer x = 2798
integer y = 2836
integer width = 745
end type

type st_10 from w_standard_print`st_10 within w_kbga04
end type

type gb_10 from w_standard_print`gb_10 within w_kbga04
integer y = 2788
integer width = 3557
integer height = 152
integer textsize = -12
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
end type

type dw_print from w_standard_print`dw_print within w_kbga04
integer x = 4101
integer y = 32
string dataobject = "dw_kbga04_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kbga04
event ue_key pbm_dwnkey
event ue_keyenter pbm_dwnprocessenter
integer x = 55
integer width = 4160
integer height = 144
integer taborder = 10
string dataobject = "dw_kbga04_1"
end type

event dw_ip::ue_key;IF keydown(keyF1!) or keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_keyenter;Send(Handle(this),256,9,0)
Return 1
end event

event dw_ip::rbuttondown;String ls_gj1, ls_gj2

SetNull(gs_code)
SetNull(gs_codename)

IF this.GetColumnName() <> "acc1_cd" THEN RETURN

dw_ip.AcceptText()
gs_code = dw_ip.GetItemString(dw_ip.GetRow(), "acc1_cd")
IF IsNull(gs_code) then
	gs_code =""
end if

Open(W_KFE01OM0_POPUP)
if gs_code <> "" and Not IsNull(gs_code) then
   dw_ip.SetItem(dw_ip.GetRow(), "acc1_cd", Left(gs_code,5))
   dw_ip.SetItem(dw_ip.GetRow(), "acc2_cd", Mid(gs_code,6,2))
   dw_ip.SetItem(dw_ip.GetRow(), "accname", gs_codename)
end if

dw_ip.Setfocus()

end event

event itemchanged;string ls_acc1_cd, ls_acc2_cd, sqlfd3, sqlfd4
Int rowno

dw_ip.Accepttext()
rowno = dw_ip.Getrow()
if rowno = 1 then
   ls_acc1_cd = dw_ip.Getitemstring(rowno,"acc1_cd")
   ls_acc2_cd = dw_ip.Getitemstring(rowno,"acc2_cd")
end if

//계정과목명 표시//
  SELECT "KFZ01OM0"."ACC1_NM","KFZ01OM0"."ACC2_NM"
    INTO :sqlfd3, :sqlfd4
    FROM "KFZ01OM0"  
   WHERE "KFZ01OM0"."ACC1_CD" = :ls_acc1_cd and
         "KFZ01OM0"."ACC2_CD" = :ls_acc2_cd ;
  if sqlca.sqlcode = 0 then
     dw_ip.Setitem(dw_ip.Getrow(),"accname",sqlfd3 + " - " + sqlfd4)
  else
     dw_ip.Setitem(dw_ip.Getrow(),"accname"," ")
  end if
end event

event itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_kbga04
boolean visible = false
integer x = 480
integer width = 3954
integer height = 1792
boolean enabled = false
string dataobject = "dw_kbga04_2"
end type

type st_1 from statictext within w_kbga04
integer x = 18
integer y = 2840
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

type cb_2 from commandbutton within w_kbga04
boolean visible = false
integer x = 375
integer y = 2368
integer width = 603
integer height = 108
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "과목별 실행예산(old)"
end type

event clicked;//string ls_saupj, ls_acc_yy, ls_acc_mm, ls_ye_gu, ls_acc1_cd, ls_acc2_cd, sqlfd, sqlfd2
//string ls_acc1cd, ls_acc2cd, ls_date
//long   rowno, rownod, rownon, i
//
//SetPointer(HourGlass!)
//dw_ip.AcceptText()
//
//ls_saupj   = dw_ip.Getitemstring(dw_ip.Getrow(),"saupj")
//ls_acc_yy  = dw_ip.Getitemstring(dw_ip.Getrow(),"acc_yy")
//ls_acc_mm  = dw_ip.Getitemstring(dw_ip.Getrow(),"acc_mm")
//ls_ye_gu   = dw_ip.Getitemstring(dw_ip.Getrow(),"ye_gu")
//ls_acc1_cd = dw_ip.Getitemstring(dw_ip.Getrow(),"acc1_cd")
//ls_acc2_cd = dw_ip.Getitemstring(dw_ip.Getrow(),"acc2_cd")
//
////코드검사
//if ls_saupj = "" or IsNull(ls_saupj) then
//   messagebox("확인","사업장코드를 확인하십시오!")
//   dw_ip.SetColumn("saupj")
//   dw_ip.SetFocus()
//   return
//else
//  SELECT "REFFPF"."RFGUB"  
//   INTO  :sqlfd
//   FROM "REFFPF"  
//   WHERE "REFFPF"."RFGUB" = :ls_saupj and
//         "REFFPF"."RFCOD" = 'AD' using sqlca ;
//   if sqlca.sqlcode <> 0 then
//      messagebox("확인","사업장코드를 확인하십시오!")
//      dw_ip.SetColumn("saupj")
//      dw_ip.SetFocus()
//      return
//   end if
//end if
//
//if ls_acc_yy = "" or IsNull(ls_acc_yy) then
//   messagebox("확인","회계년도를 확인하십시오!")
//   dw_ip.SetColumn("acc_yy")
//   dw_ip.SetFocus()
//   return
//else
//   if Not IsNumber(ls_acc_yy) then
//      messagebox("확인","회계년도를 확인하십시오!")
//      dw_ip.SetColumn("acc_yy")
//      dw_ip.SetFocus()
//      return
//   end if
//end if
//
//if ls_acc_mm = "" or IsNull(ls_acc_mm) then
//   messagebox("확인","회계월을 확인하십시오!")
//   dw_ip.SetColumn("acc_mm")
//   dw_ip.SetFocus()
//   return
//else
//   if ls_acc_mm < "01" or ls_acc_mm > "12" then
//      messagebox("확인","회계월을 확인하십시오!")
//      dw_ip.SetColumn("acc_mm")
//      dw_ip.SetFocus()
//      return
//   end if
//end if
//
//ls_date = Trim(ls_acc_yy)+"/"+Trim(ls_acc_mm)+"/01"
//if f_datechk(ls_date) = -1 then
//   messagebox("확인","회계년월을 확인하십시오!")
//   dw_ip.SetColumn("acc_yy")
//   dw_ip.SetFocus()
//   return
//end if
//
//if ls_ye_gu = ""  or IsNull(ls_ye_gu) then
//   ls_ye_gu = "%"
//else
//  SELECT "REFFPF"."RFGUB"  
//   INTO  :sqlfd
//   FROM "REFFPF"  
//   WHERE "REFFPF"."RFGUB" = :ls_ye_gu and
//         "REFFPF"."RFCOD" = 'AB' using sqlca ;
//   if sqlca.sqlcode <> 0 then
//      messagebox("확인","예산구분코드를 확인하십시오!")
//      dw_ip.SetColumn("ye_gu")
//      dw_ip.SetFocus()
//      return
//   end if
//end if
//
//if ls_acc1_cd = ""  or IsNull(ls_acc1_cd) then
//   ls_acc1_cd = "%"
//else
//   ls_acc1_cd = ls_acc1_cd + "%"
//end if
//
//if ls_acc2_cd = "  "  or IsNull(ls_acc2_cd) then
//   ls_acc2_cd = "%"
//end if
//
////자료검색
//rownod = dw_dang.Retrieve(ls_saupj,ls_acc_yy,ls_ye_gu,ls_acc_mm,ls_acc1_cd,ls_acc2_cd)
//rownon = dw_nugey.Retrieve(ls_saupj,ls_acc_yy,ls_ye_gu,ls_acc_mm,ls_acc1_cd,ls_acc2_cd)
//
//if rownod <> 0 and rownon <>0 and rownod = rownon then
//   dw_ret.Reset()
//   for i = 1 to rownod
//      dw_ret.Insertrow(0)
//      ls_acc1cd = dw_dang.GetitemString(i,"acc1_cd")
//      ls_acc2cd = dw_dang.GetitemString(i,"acc2_cd")
//
//      SELECT "KFZ01OM0"."ACC1_NM","KFZ01OM0"."ACC2_NM"  
//      INTO :sqlfd, :sqlfd2
//      FROM "KFZ01OM0"  
//      WHERE ( "KFZ01OM0"."ACC1_CD" = :ls_acc1cd ) AND  
//            ( "KFZ01OM0"."ACC2_CD" = :ls_acc2cd )  using sqlca ;
//      
//      dw_ret.Setitem(i,"accname1",sqlfd)
//      dw_ret.Setitem(i,"accname2",sqlfd2)
//      dw_ret.Setitem(i,"saup_amt",dw_dang.GetitemNumber(i,"kibon_amt"))
//      dw_ret.Setitem(i,"jojung_amt",dw_dang.GetitemNumber(i,"jojung_amt"))
//      dw_ret.Setitem(i,"silhan_amt",dw_dang.GetitemNumber(i,"silhan_amt"))
//      dw_ret.Setitem(i,"saup_samt",dw_nugey.GetitemNumber(i,"kibonsum"))
//      dw_ret.Setitem(i,"jojung_samt",dw_nugey.GetitemNumber(i,"jojungsum"))
//      dw_ret.Setitem(i,"silhan_samt",dw_nugey.GetitemNumber(i,"silhansum"))
//   next
//else
//   messagebox("확인","조회할 자료가 없습니다!")
//   return
//end if
end event

type dw_nugey from datawindow within w_kbga04
boolean visible = false
integer x = 1792
integer y = 2368
integer width = 494
integer height = 204
boolean titlebar = true
string title = "누계자료검색(old)"
string dataobject = "dw_kbga04_4"
boolean livescroll = true
end type

type dw_dang from datawindow within w_kbga04
boolean visible = false
integer x = 1010
integer y = 2376
integer width = 494
integer height = 212
boolean titlebar = true
string title = "당월자료검색(old)"
string dataobject = "dw_kbga04_3"
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_kbga04
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 164
integer width = 4517
integer height = 2048
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_ret from datawindow within w_kbga04
integer x = 73
integer y = 176
integer width = 4485
integer height = 2024
integer taborder = 30
boolean bringtotop = true
string dataobject = "dw_kbga04_2"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

