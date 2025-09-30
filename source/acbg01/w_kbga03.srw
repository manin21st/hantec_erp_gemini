$PBExportHeader$w_kbga03.srw
$PBExportComments$부서별실행예산조회
forward
global type w_kbga03 from w_standard_print
end type
type st_1 from statictext within w_kbga03
end type
type cb_2 from commandbutton within w_kbga03
end type
type dw_nugey from datawindow within w_kbga03
end type
type dw_dang from datawindow within w_kbga03
end type
type gb_3 from groupbox within w_kbga03
end type
type rr_1 from roundrectangle within w_kbga03
end type
type dw_ret from datawindow within w_kbga03
end type
end forward

global type w_kbga03 from w_standard_print
string title = "부서별 실행예산 조회"
boolean resizable = true
event keyup pbm_keyup
st_1 st_1
cb_2 cb_2
dw_nugey dw_nugey
dw_dang dw_dang
gb_3 gb_3
rr_1 rr_1
dw_ret dw_ret
end type
global w_kbga03 w_kbga03

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

dw_ip.Setitem(dw_ip.Getrow(),"acc_yy",  Left(F_Today(),4))
dw_ip.Setitem(dw_ip.Getrow(),"acc_mm",  Mid(F_Today(),5,2))
dw_ip.SetItem(dw_ip.Getrow(),"dept_cd", Gs_Dept)

dw_ip.SetFocus()

end event

on w_kbga03.create
int iCurrent
call super::create
this.st_1=create st_1
this.cb_2=create cb_2
this.dw_nugey=create dw_nugey
this.dw_dang=create dw_dang
this.gb_3=create gb_3
this.rr_1=create rr_1
this.dw_ret=create dw_ret
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.dw_nugey
this.Control[iCurrent+4]=this.dw_dang
this.Control[iCurrent+5]=this.gb_3
this.Control[iCurrent+6]=this.rr_1
this.Control[iCurrent+7]=this.dw_ret
end on

on w_kbga03.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.cb_2)
destroy(this.dw_nugey)
destroy(this.dw_dang)
destroy(this.gb_3)
destroy(this.rr_1)
destroy(this.dw_ret)
end on

type p_preview from w_standard_print`p_preview within w_kbga03
boolean visible = false
integer x = 3781
integer y = 656
integer taborder = 40
end type

type p_exit from w_standard_print`p_exit within w_kbga03
integer x = 4416
integer y = 8
integer taborder = 40
boolean originalsize = true
end type

event p_exit::clicked;call super::clicked;//IF wf_warndataloss("종료") = -1 THEN  	RETURN

end event

type p_print from w_standard_print`p_print within w_kbga03
boolean visible = false
integer x = 3333
integer y = 524
integer taborder = 50
end type

type p_retrieve from w_standard_print`p_retrieve within w_kbga03
integer x = 4242
integer y = 8
integer taborder = 20
boolean originalsize = true
end type

event p_retrieve::clicked;string ls_saupj, ls_acc_yy, ls_acc_mm, ls_dept_cd, ls_ye_gu, &
       ls_acc1_cd, sqlfd, sqlfd2, get_code, get_name, ls_updept
string ls_acc1cd, ls_acc2cd, ls_date, snull
long   rowno, rownod, rownon, i

SetNull(snull)

SetPointer(HourGlass!)
dw_ip.AcceptText()

ls_saupj   = dw_ip.Getitemstring(dw_ip.Getrow(),"saupj")
ls_acc_yy  = dw_ip.Getitemstring(dw_ip.Getrow(),"acc_yy")
ls_acc_mm  = dw_ip.Getitemstring(dw_ip.Getrow(),"acc_mm")
ls_ye_gu   = dw_ip.Getitemstring(dw_ip.Getrow(),"ye_gu")
ls_dept_cd = dw_ip.Getitemstring(dw_ip.Getrow(),"dept_cd")
ls_acc1_cd = dw_ip.Getitemstring(dw_ip.Getrow(),"acc1_cd")

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
         "REFFPF"."RFCOD" = 'AD';
   if sqlca.sqlcode <> 0 then
      messagebox("확인","사업장을 확인하십시오!")
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
end if

ls_date = Trim(ls_acc_yy) +Trim(ls_acc_mm) + "01"
if f_datechk(ls_date) = -1 then
   messagebox("확인","회계년월을 확인하십시오!")
   dw_ip.SetColumn("acc_yy")
   dw_ip.SetFocus()
   return
end if

if ls_dept_cd = "" or IsNull(ls_dept_cd) then
   F_MessageChk(1,'[배정부서]')
   dw_ip.SetColumn("dept_cd")
   dw_ip.SetFocus()
   return
else
	SELECT "KFE03OM0"."DEPTCODE",   
			  "KFE03OM0"."DEPTNAME"  
		 INTO :get_code,    
				:get_name  
		 FROM "KFE03OM0"  
		WHERE "KFE03OM0"."DEPTCODE" = :ls_dept_cd   ;
			
		if sqlca.sqlcode = 0 then 	
			dw_ip.SetItem(dw_ip.GetRow(), 'dept_cd', get_code)
		else
         messagebox("확인","배정부서를 확인하십시오")
			dw_ip.SetItem(dw_ip.GetRow(), 'dept_cd', snull)
			dw_ip.SetColumn("dept_cd")
			dw_ip.SetFocus()
			return 
		end if 

   if sqlca.sqlcode <> 0 then

      return
   end if
end if

if trim(ls_ye_gu) = ""  or IsNull(ls_ye_gu) then
   ls_ye_gu = "%"
else
  SELECT "REFFPF"."RFGUB"  
   INTO  :sqlfd
   FROM "REFFPF"  
   WHERE "REFFPF"."RFGUB" = :ls_ye_gu and "REFFPF"."RFCOD" = 'AB';
   if sqlca.sqlcode <> 0 then
      messagebox("확인","예산구분을 확인하십시오!")
      dw_ip.SetColumn("ye_gu")
      dw_ip.SetFocus()
      return
   end if
end if

if ls_acc1_cd = ""  or IsNull(ls_acc1_cd) then
   ls_acc1_cd = "%"
else
   ls_acc1_cd = ls_acc1_cd + "%"
end if

IF dw_ret.Retrieve(ls_saupj,ls_acc_yy,ls_acc_mm, &
                   ls_dept_cd, ls_acc1_cd, ls_ye_gu) <=0 THEN
   F_MessageChk(14,'')
//   return
end if

end event



type sle_msg from w_standard_print`sle_msg within w_kbga03
integer x = 416
integer y = 3420
integer width = 2455
end type

type dw_datetime from w_standard_print`dw_datetime within w_kbga03
integer x = 2871
integer y = 3416
end type

type st_10 from w_standard_print`st_10 within w_kbga03
end type

type gb_10 from w_standard_print`gb_10 within w_kbga03
integer x = 37
integer y = 3368
integer width = 3607
integer height = 152
integer textsize = -12
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
end type

type dw_print from w_standard_print`dw_print within w_kbga03
integer x = 3845
integer y = 32
boolean enabled = false
string dataobject = "dw_kbga03_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kbga03
event ue_key pbm_dwnkey
event ue_keyenter pbm_dwnprocessenter
integer x = 50
integer width = 3781
integer height = 208
integer taborder = 10
string dataobject = "dw_kbga03_1"
end type

event dw_ip::ue_key;IF keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_keyenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;string ls_acc1_cd, sqlfd

IF dwo.name ="acc1_cd" THEN

	SELECT "KFZ01OM0"."ACC1_NM"
    	INTO :sqlfd  
    	FROM "KFZ01OM0"  
    	WHERE "KFZ01OM0"."ACC1_CD" = :data  ;

	if sqlca.sqlcode <> 100 then
   	dw_ip.Setitem(dw_ip.Getrow(),"accname", sqlfd)
	else
   	dw_ip.Setitem(dw_ip.Getrow(),"accname","")
	end if
END IF

end event

event rbuttondown;String ls_gj1, ls_gj2

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
   dw_ip.SetItem(dw_ip.GetRow(), "acc1_cd",  Left(gs_code,5))
   dw_ip.SetItem(dw_ip.GetRow(), "accname",  gs_codename)
end if

dw_ip.Setfocus()
end event

event itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_kbga03
boolean visible = false
integer x = 805
integer y = 380
integer width = 3461
integer height = 1692
integer taborder = 30
boolean enabled = false
string dataobject = "dw_kbga03_2"
end type

type st_1 from statictext within w_kbga03
integer x = 55
integer y = 3420
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

type cb_2 from commandbutton within w_kbga03
boolean visible = false
integer x = 1285
integer y = 2388
integer width = 777
integer height = 108
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "부서별 실행예산(OLD)"
end type

event clicked;//string ls_saupj, ls_acc_yy, ls_acc_mm, ls_dept_cd, ls_ye_gu, ls_acc1_cd, sqlfd, sqlfd2
//string ls_acc1cd, ls_acc2cd, ls_date
//long   rowno, rownod, rownon, i
//
//SetPointer(HourGlass!)
//dw_ip.AcceptText()
//
//ls_saupj   = dw_ip.Getitemstring(dw_ip.Getrow(),"saupj")
//ls_acc_yy  = dw_ip.Getitemstring(dw_ip.Getrow(),"acc_yy")
//ls_acc_mm  = dw_ip.Getitemstring(dw_ip.Getrow(),"acc_mm")
//ls_ye_gu   = dw_ip.Getitemstring(dw_ip.Getrow(),"kfz01om0_ye_gu")
//ls_dept_cd = dw_ip.Getitemstring(dw_ip.Getrow(),"dept_cd")
//ls_acc1_cd = dw_ip.Getitemstring(dw_ip.Getrow(),"acc1_cd")
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
//end if
//
//ls_date = Trim(ls_acc_yy) + "/" + Trim(ls_acc_mm) + "/01"
//if f_datechk(ls_date) = -1 then
//   messagebox("확인","회계년월을 확인하십시오!")
//   dw_ip.SetColumn("acc_yy")
//   dw_ip.SetFocus()
//   return
//end if
//
//if ls_dept_cd = "" or IsNull(ls_dept_cd) then
//      messagebox("확인","배정부서코드를 확인하십시오")
//      dw_ip.SetColumn("dept_cd")
//      dw_ip.SetFocus()
//      return
//else
//   SELECT "VNDMST"."CVCOD"  
//   INTO :sqlfd
//   FROM "VNDMST"  
//   WHERE "VNDMST"."CVCOD" = :ls_dept_cd  and
//         "VNDMST"."CVGU" = '9'   using sqlca ;
//   if sqlca.sqlcode <> 0 then
//      messagebox("확인","배정부서코드를 확인하십시오")
//      dw_ip.SetColumn("dept_cd")
//      dw_ip.SetFocus()
//      return
//   end if
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
//      dw_ip.SetColumn("kfz01om0_ye_gu")
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
////자료검색
//rownod = dw_dang.Retrieve(ls_saupj,ls_acc_yy,ls_ye_gu,ls_dept_cd,ls_acc_mm,ls_acc1_cd)
//rownon = dw_nugey.Retrieve(ls_saupj,ls_acc_yy,ls_ye_gu,ls_dept_cd,ls_acc_mm,ls_acc1_cd)
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
//      dw_ret.Setitem(i,"saup_amt",dw_dang.GetitemNumber(i,"bgk_amt1"))
//      dw_ret.Setitem(i,"jojung_amt",dw_dang.GetitemNumber(i,"jojungak"))
//      dw_ret.Setitem(i,"silhan_amt",dw_dang.GetitemNumber(i,"silhanak"))
//      dw_ret.Setitem(i,"saup_samt",dw_nugey.GetitemNumber(i,"kibonsum"))
//      dw_ret.Setitem(i,"jojung_samt",dw_nugey.GetitemNumber(i,"jojungsum"))
//      dw_ret.Setitem(i,"silhan_samt",dw_nugey.GetitemNumber(i,"silhansum"))
//   next
//else
//   messagebox("확인","조회할 자료가 없습니다!")
//   return
//end if
end event

type dw_nugey from datawindow within w_kbga03
boolean visible = false
integer x = 2085
integer y = 2396
integer width = 558
integer height = 84
boolean titlebar = true
string title = "누계자료검색(OLD)"
string dataobject = "dw_kbga03_4"
boolean livescroll = true
end type

type dw_dang from datawindow within w_kbga03
boolean visible = false
integer x = 2656
integer y = 2396
integer width = 558
integer height = 84
boolean titlebar = true
string title = "당월자료검색(OLD)"
string dataobject = "dw_kbga03_3"
boolean livescroll = true
end type

type gb_3 from groupbox within w_kbga03
integer x = 37
integer y = 3384
integer width = 3593
integer height = 136
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12632256
end type

type rr_1 from roundrectangle within w_kbga03
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 224
integer width = 4530
integer height = 1988
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_ret from datawindow within w_kbga03
integer x = 69
integer y = 232
integer width = 4498
integer height = 1968
integer taborder = 30
boolean bringtotop = true
string dataobject = "dw_kbga03_2"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

