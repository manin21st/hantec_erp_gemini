$PBExportHeader$w_kbgb01a.srw
$PBExportComments$특인신청현황 조회
forward
global type w_kbgb01a from w_inherite
end type
type rr_1 from roundrectangle within w_kbgb01a
end type
type cb_10 from commandbutton within w_kbgb01a
end type
type dw_inq from datawindow within w_kbgb01a
end type
type dw_print from datawindow within w_kbgb01a
end type
type dw_ret from datawindow within w_kbgb01a
end type
type dw_ip from u_key_enter within w_kbgb01a
end type
end forward

global type w_kbgb01a from w_inherite
integer x = 37
integer y = 36
integer width = 4466
integer height = 2400
string title = "특인 신청 조회"
boolean controlmenu = false
boolean minbox = false
windowtype windowtype = response!
rr_1 rr_1
cb_10 cb_10
dw_inq dw_inq
dw_print dw_print
dw_ret dw_ret
dw_ip dw_ip
end type
global w_kbgb01a w_kbgb01a

event open;call super::open;
F_Window_Center_ResPonse(this)

dw_ip.SettransObject(sqlca)
dw_ret.SettransObject(sqlca)
dw_print.SettransObject(sqlca)
dw_inq.SettransObject(sqlca)

dw_ip.Reset()
dw_ret.Reset()
dw_print.Reset()
dw_inq.Reset()
dw_ip.Insertrow(0)

dw_ip.Setfocus()

dw_ip.Setitem(dw_ip.Getrow(),"saupj",gs_saupj)
dw_ip.Setitem(dw_ip.Getrow(),"exe_ymd",String(Today(),"yyyymmdd"))
dw_ip.Setitem(dw_ip.Getrow(),"exe_ymd2",String(Today(),"yyyymmdd"))

IF F_Valid_EmpNo(Gs_EmpNo) = 'Y' THEN
	dw_ip.Modify("saupj.protect = 0")
	dw_ip.Modify("saupj.background.color ='"+String(RGB(255,255,255))+"'")	
ELSE
	dw_ip.Modify("saupj.protect = 1")
	dw_ip.Modify("saupj.background.color ='"+String(RGB(192,192,192))+"'")			
END IF

end event

on w_kbgb01a.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.cb_10=create cb_10
this.dw_inq=create dw_inq
this.dw_print=create dw_print
this.dw_ret=create dw_ret
this.dw_ip=create dw_ip
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.cb_10
this.Control[iCurrent+3]=this.dw_inq
this.Control[iCurrent+4]=this.dw_print
this.Control[iCurrent+5]=this.dw_ret
this.Control[iCurrent+6]=this.dw_ip
end on

on w_kbgb01a.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.cb_10)
destroy(this.dw_inq)
destroy(this.dw_print)
destroy(this.dw_ret)
destroy(this.dw_ip)
end on

type dw_insert from w_inherite`dw_insert within w_kbgb01a
boolean visible = false
integer x = 3602
integer y = 24
integer width = 270
integer height = 132
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kbgb01a
boolean visible = false
integer x = 3314
integer y = 2856
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kbgb01a
boolean visible = false
integer x = 3141
integer y = 2856
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kbgb01a
boolean visible = false
integer x = 2446
integer y = 2856
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_kbgb01a
boolean visible = false
integer x = 2967
integer y = 2856
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kbgb01a
integer x = 4251
integer y = 20
integer taborder = 50
string picturename = "C:\erpman\image\선택_up.gif"
end type

event p_exit::ue_lbuttondown;PictureName = "C:\erpman\image\선택_dn.gif"
end event

event p_exit::ue_lbuttonup;PictureName = "C:\erpman\image\선택_up.gif"
end event

event p_exit::clicked;close(parent)
end event

type p_can from w_inherite`p_can within w_kbgb01a
boolean visible = false
integer x = 3835
integer y = 2856
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_kbgb01a
integer x = 4078
integer y = 20
integer taborder = 40
end type

event p_print::clicked;call super::clicked;string ls_saupj,ls_exe_gu,ls_fexe_ymd,ls_texe_ymd,ls_acc1_cd,ls_acc2_cd,lexe_gu,ls_ft_gu
string sqlfd, sqlfd2,ls_dept_cd
long   rowno, i, j, ll_exe_no, sv_exe_no

SetPointer(HourGlass!)
dw_print.Reset()
dw_ip.AcceptText()
ls_saupj    = dw_ip.Getitemstring(dw_ip.Getrow(),"saupj")
ls_fexe_ymd = dw_ip.Getitemstring(dw_ip.Getrow(),"exe_ymd")
ls_texe_ymd = dw_ip.Getitemstring(dw_ip.Getrow(),"exe_ymd2")
ls_exe_gu   = dw_ip.Getitemstring(dw_ip.Getrow(),"exe_gu")

if ls_saupj = "" or IsNull(ls_saupj) then
   messagebox("확인","사업장을 확인하십시오!")
   dw_ip.Setfocus()
   return	
else
   SELECT "REFFPF"."RFGUB"  
   INTO :sqlfd
   FROM "REFFPF"
   WHERE "REFFPF"."RFCOD" = 'AD' and
         "REFFPF"."RFGUB" = :ls_saupj  using sqlca;
   if sqlca.sqlcode <> 0 then
      messagebox("확인","사업장을 확인하십시오")
      return
      dw_ip.Setfocus()
   end if
end if

if f_datechk(ls_fexe_ymd) = -1 then
   messagebox("확인","조정처리일자를 확인하십시오!")
   dw_ip.Setfocus()
   return	
end if

if f_datechk(ls_texe_ymd) = -1 then
   messagebox("확인","조정처리일자를 확인하십시오!")
   dw_ip.Setfocus()
   return	
end if

if Long(ls_fexe_ymd) > Long(ls_texe_ymd)  then
   messagebox("확인","조정처리일 범위를 확인하십시오!")
   dw_ip.Setfocus()
   return
end if

if ls_exe_gu = "" or Isnull(ls_exe_gu) then
   ls_exe_gu = "%"
else
   SELECT "REFFPF"."RFGUB"  
   INTO :sqlfd
   FROM "REFFPF"
   WHERE "REFFPF"."RFCOD" = 'AE' and
         "REFFPF"."RFGUB" = :ls_exe_gu  using sqlca;
   if sqlca.sqlcode <> 0 then
      messagebox("확인","예산조정구분코드를 확인하십시오")
      dw_ip.Setfocus()
      return		
   end if
end if

IF F_Valid_EmpNo(gs_EmpNo) = 'Y' then
	ls_dept_cd = "%"
	rowno = dw_inq.Retrieve(ls_saupj,ls_fexe_ymd,ls_texe_ymd,'%',ls_exe_gu)
else
	ls_dept_cd = gs_dept+"%"
	rowno = dw_inq.Retrieve(ls_saupj,ls_fexe_ymd,ls_texe_ymd,ls_dept_cd,ls_exe_gu)
End if

if rowno < 1 then
   messagebox("확인","조회할 자료가 없습니다!")
   dw_ip.Setfocus()
   return	
end if

j = 1

dw_print.Insertrow(0)

for i = 1 to rowno
    if i = 1 then
       sv_exe_no = dw_inq.Getitemnumber(1,"exe_no")  //조정번호 보관//
    end if

    ll_exe_no  = dw_inq.Getitemnumber(i,"exe_no")
    ls_ft_gu   = dw_inq.Getitemstring(i,"ft_gu")
    ls_acc1_cd = dw_inq.Getitemstring(i,"acc1_cd")
    ls_acc2_cd = dw_inq.Getitemstring(i,"acc2_cd")

    if ll_exe_no <> sv_exe_no then
       j += 1
       sv_exe_no = ll_exe_no
       dw_print.InsertRow(0)
    end if

    dw_print.Setitem(j,"e_exe_ymd",dw_inq.Getitemstring(i,"exe_ymd"))
    dw_print.Setitem(j,"e_exe_no",sv_exe_no)
    dw_print.Setitem(j,"e_exe_gu",dw_inq.Getitemstring(i,"exe_gu"))
    dw_print.Setitem(j,"e_exe_amt",dw_inq.Getitemnumber(i,"exe_amt"))
    dw_print.Setitem(j,"e_exe_desc",dw_inq.Getitemstring(i,"kfe02om0_exe_desc"))

    if ls_ft_gu = "1" then //예산증가항목//
       dw_print.Setitem(j,"e_fdept_cd",dw_inq.Getitemstring(i,"dept_cd"))
       dw_print.Setitem(j,"e_facc_mm",dw_inq.Getitemstring(i,"acc_mm"))
       dw_print.Setitem(j,"e_fexe_bamt",dw_inq.Getitemnumber(i,"exe_bamt"))
       dw_print.Setitem(j,"e_fexe_aamt",dw_inq.Getitemnumber(i,"exe_aamt"))
       SELECT "KFZ01OM0"."ACC1_NM", "KFZ01OM0"."ACC2_NM"  
       INTO  :sqlfd, :sqlfd2
       FROM "KFZ01OM0"  
       WHERE ( "KFZ01OM0"."ACC1_CD" = :ls_acc1_cd ) AND  
             ( "KFZ01OM0"."ACC2_CD" = :ls_acc2_cd )  using sqlca ;
       if sqlca.sqlcode = 0 then
          dw_print.Setitem(j,"e_facc1_cd",sqlfd)
       else
          dw_print.Setitem(j,"e_facc1_cd",ls_acc1_cd + "-" + ls_acc2_cd)
       end if
    else   //예산감소항목//
		
       dw_print.Setitem(j,"e_tdept_cd",dw_inq.Getitemstring(i,"dept_cd"))
       dw_print.Setitem(j,"e_tacc_mm",dw_inq.Getitemstring(i,"acc_mm"))
       dw_print.Setitem(j,"e_texe_bamt",dw_inq.Getitemnumber(i,"exe_bamt"))
       dw_print.Setitem(j,"e_texe_aamt",dw_inq.Getitemnumber(i,"exe_aamt"))
		 
       SELECT "KFZ01OM0"."ACC1_NM", "KFZ01OM0"."ACC2_NM"  
       INTO  :sqlfd, :sqlfd2
       FROM "KFZ01OM0"  
       WHERE ( "KFZ01OM0"."ACC1_CD" = :ls_acc1_cd ) AND  
             ( "KFZ01OM0"."ACC2_CD" = :ls_acc2_cd )  using sqlca ;
       if sqlca.sqlcode = 0 then
          dw_print.Setitem(j,"e_tacc1_cd",sqlfd)
       else
          dw_print.Setitem(j,"e_tacc1_cd",ls_acc1_cd + "-" + ls_acc2_cd)
       end if
    end if
next

dw_print.Print()
end event

type p_inq from w_inherite`p_inq within w_kbgb01a
integer x = 3904
integer y = 20
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;string ls_saupj,ls_exe_gu,ls_fexe_ymd,ls_texe_ymd,ls_acc1_cd,ls_acc2_cd,lexe_gu,ls_ft_gu,ls_dept_cd
string sqlfd, sqlfd2, sEMPNO
long   rowno, i, j, ll_exe_no, sv_exe_no

SetPointer(HourGlass!)

dw_ret.Reset()
dw_ip.AcceptText()

ls_saupj    = dw_ip.Getitemstring(dw_ip.Getrow(),"saupj")
ls_fexe_ymd = dw_ip.Getitemstring(dw_ip.Getrow(),"exe_ymd")
ls_texe_ymd = dw_ip.Getitemstring(dw_ip.Getrow(),"exe_ymd2")
ls_exe_gu   = dw_ip.Getitemstring(dw_ip.Getrow(),"exe_gu")

if ls_saupj = "" or IsNull(ls_saupj) then
   messagebox("확인","사업장을 확인하십시오!")
   return
   dw_ip.Setfocus()
else
   SELECT "REFFPF"."RFGUB"  
   INTO :sqlfd
   FROM "REFFPF"
   WHERE "REFFPF"."RFCOD" = 'AD' and
         "REFFPF"."RFGUB" = :ls_saupj  using sqlca;
   if sqlca.sqlcode <> 0 then
      messagebox("확인","사업장을 확인하십시오")
      dw_ip.Setfocus()
      return		
   end if
end if

if f_datechk(ls_fexe_ymd) = -1 then
   messagebox("확인","조정처리일자를 확인하십시오!")
   dw_ip.Setfocus()
   return	
end if

if f_datechk(ls_texe_ymd) = -1 then
   messagebox("확인","조정처리일자를 확인하십시오!")
   dw_ip.Setfocus()
   return	
end if

if Long(ls_fexe_ymd) > Long(ls_texe_ymd)  then
   messagebox("확인","조정처리일 범위를 확인하십시오!")
   dw_ip.Setfocus()
   return	
end if

if ls_exe_gu = "" or Isnull(ls_exe_gu) then
   ls_exe_gu = "%"
else
   SELECT "REFFPF"."RFGUB"  
   INTO :sqlfd
   FROM "REFFPF"
   WHERE "REFFPF"."RFCOD" = 'AE' and
         "REFFPF"."RFGUB" = :ls_exe_gu  using sqlca;
   if sqlca.sqlcode <> 0 then
      messagebox("확인","예산조정구분코드를 확인하십시오")
      dw_ip.Setfocus()
      return		
   end if
end if

dw_ret.Reset()

IF F_Valid_EmpNo(gs_EmpNo) = 'Y' then
	ls_dept_cd = "%"
	rowno = dw_inq.Retrieve(ls_saupj,ls_fexe_ymd,ls_texe_ymd,'%',ls_exe_gu)
else
	ls_dept_cd = gs_dept+"%"
	rowno = dw_inq.Retrieve(ls_saupj,ls_fexe_ymd,ls_texe_ymd,ls_dept_cd,ls_exe_gu)
End if

if rowno < 1 then
   messagebox("확인","조회할 자료가 없습니다!")
   dw_ip.Setfocus()
   return	
end if

j = 1

dw_ret.Insertrow(0)

for i = 1 to rowno
    if i = 1 then
       sv_exe_no = dw_inq.Getitemnumber(1,"exe_no")  //조정번호 보관//
    end if

    ll_exe_no  = dw_inq.Getitemnumber(i,"exe_no")
    ls_ft_gu   = dw_inq.Getitemstring(i,"ft_gu")
    ls_acc1_cd = dw_inq.Getitemstring(i,"acc1_cd")
    ls_acc2_cd = dw_inq.Getitemstring(i,"acc2_cd")

    if ll_exe_no <> sv_exe_no then
       j += 1
       sv_exe_no = ll_exe_no
       dw_ret.InsertRow(0)
    end if

    dw_ret.Setitem(j,"e_saupj",dw_inq.Getitemstring(i,"saupj"))
    dw_ret.Setitem(j,"e_exe_ymd",dw_inq.Getitemstring(i,"exe_ymd"))
    dw_ret.Setitem(j,"e_exe_no",sv_exe_no)
    dw_ret.Setitem(j,"e_exe_gu",dw_inq.Getitemstring(i,"exe_gu"))
    dw_ret.Setitem(j,"e_exe_amt",dw_inq.Getitemnumber(i,"exe_amt"))
    dw_ret.Setitem(j,"e_exe_desc",dw_inq.Getitemstring(i,"kfe02om0_exe_desc"))

    if ls_ft_gu = "1" then //예산증가항목//
       dw_ret.Setitem(j,"e_fdept_cd",dw_inq.Getitemstring(i,"dept_cd"))
       dw_ret.Setitem(j,"e_facc_mm",dw_inq.Getitemstring(i,"acc_mm"))
       SELECT "KFZ01OM0"."ACC1_NM", "KFZ01OM0"."ACC2_NM"  
       INTO  :sqlfd, :sqlfd2
       FROM "KFZ01OM0"  
       WHERE ( "KFZ01OM0"."ACC1_CD" = :ls_acc1_cd ) AND  
             ( "KFZ01OM0"."ACC2_CD" = :ls_acc2_cd )  using sqlca ;
       if sqlca.sqlcode = 0 then
          dw_ret.Setitem(j,"e_facc1_cd",sqlfd)
       else
          dw_ret.Setitem(j,"e_facc1_cd",ls_acc1_cd + "-" + ls_acc2_cd)
       end if
    else   //예산감소항목//
       dw_ret.Setitem(j,"e_tdept_cd",dw_inq.Getitemstring(i,"dept_cd"))
       dw_ret.Setitem(j,"e_tacc_mm",dw_inq.Getitemstring(i,"acc_mm"))
       SELECT "KFZ01OM0"."ACC1_NM", "KFZ01OM0"."ACC2_NM"  
       INTO  :sqlfd, :sqlfd2
       FROM "KFZ01OM0"  
       WHERE ( "KFZ01OM0"."ACC1_CD" = :ls_acc1_cd ) AND  
             ( "KFZ01OM0"."ACC2_CD" = :ls_acc2_cd )  using sqlca ;
       if sqlca.sqlcode = 0 then
          dw_ret.Setitem(j,"e_tacc1_cd",sqlfd)
       else
          dw_ret.Setitem(j,"e_tacc1_cd",ls_acc1_cd + "-" + ls_acc2_cd)
       end if
    end if
next
end event

type p_del from w_inherite`p_del within w_kbgb01a
boolean visible = false
integer x = 3662
integer y = 2856
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kbgb01a
boolean visible = false
integer x = 3488
integer y = 2856
integer taborder = 0
end type

type cb_exit from w_inherite`cb_exit within w_kbgb01a
boolean visible = false
integer x = 1632
integer y = 2640
integer width = 297
boolean bringtotop = true
end type

type cb_mod from w_inherite`cb_mod within w_kbgb01a
boolean visible = false
integer x = 1957
integer y = 2644
end type

type cb_ins from w_inherite`cb_ins within w_kbgb01a
boolean visible = false
integer x = 2267
integer y = 2664
end type

type cb_del from w_inherite`cb_del within w_kbgb01a
boolean visible = false
integer x = 928
integer y = 2768
end type

type cb_inq from w_inherite`cb_inq within w_kbgb01a
boolean visible = false
integer x = 3278
integer y = 2688
integer width = 302
end type

type cb_print from w_inherite`cb_print within w_kbgb01a
boolean visible = false
integer x = 3598
integer y = 2688
integer width = 302
end type

type st_1 from w_inherite`st_1 within w_kbgb01a
boolean visible = false
integer x = 55
integer y = 2492
end type

type cb_can from w_inherite`cb_can within w_kbgb01a
boolean visible = false
integer x = 1289
integer y = 2772
end type

type cb_search from w_inherite`cb_search within w_kbgb01a
boolean visible = false
integer x = 2743
integer y = 2740
end type

type dw_datetime from w_inherite`dw_datetime within w_kbgb01a
boolean visible = false
integer x = 2894
integer y = 2488
end type

type sle_msg from w_inherite`sle_msg within w_kbgb01a
boolean visible = false
integer x = 407
integer y = 2492
end type

type gb_10 from w_inherite`gb_10 within w_kbgb01a
boolean visible = false
integer x = 37
integer y = 2440
end type

type gb_button1 from w_inherite`gb_button1 within w_kbgb01a
boolean visible = false
integer x = 517
integer y = 2664
integer height = 64
end type

type gb_button2 from w_inherite`gb_button2 within w_kbgb01a
boolean visible = false
integer x = 3246
integer y = 2640
integer width = 1006
integer height = 184
end type

type rr_1 from roundrectangle within w_kbgb01a
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 184
integer width = 4384
integer height = 2060
integer cornerheight = 40
integer cornerwidth = 55
end type

type cb_10 from commandbutton within w_kbgb01a
boolean visible = false
integer x = 3918
integer y = 2688
integer width = 302
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "선택(&S)"
end type

type dw_inq from datawindow within w_kbgb01a
boolean visible = false
integer x = 1627
integer y = 2808
integer width = 498
integer height = 108
boolean bringtotop = true
boolean titlebar = true
string title = "조회자료검색"
string dataobject = "dw_kbgb01a_4"
boolean livescroll = true
end type

type dw_print from datawindow within w_kbgb01a
boolean visible = false
integer x = 2149
integer y = 2808
integer width = 498
integer height = 108
boolean bringtotop = true
boolean titlebar = true
string title = "자료인쇄"
string dataobject = "dw_kbgb01a_3"
boolean resizable = true
boolean livescroll = true
end type

type dw_ret from datawindow within w_kbgb01a
integer x = 55
integer y = 192
integer width = 4361
integer height = 2044
integer taborder = 30
string dataobject = "dw_kbgb01a_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;Int ll_exe_no
string ls_saupj, ls_exe_ymd

If row <= 0 Then Return

this.SelectRow(0,False)
this.SelectRow(row,True)

ls_saupj   = dw_ret.Getitemstring(row,"e_saupj")
ls_exe_ymd = dw_ret.Getitemstring(row,"e_exe_ymd")
ll_exe_no  = dw_ret.Getitemnumber(row,"e_exe_no")

gs_code =ls_saupj+ls_exe_ymd+String(ll_exe_no)
end event

event doubleclicked;Int ll_exe_no
string ls_saupj, ls_exe_ymd

If row <= 0 Then Return

this.SelectRow(0,False)
this.SelectRow(row,True)

ls_saupj   = dw_ret.Getitemstring(row,"e_saupj")
ls_exe_ymd = dw_ret.Getitemstring(row,"e_exe_ymd")
ll_exe_no  = dw_ret.Getitemnumber(row,"e_exe_no")

gs_code =ls_saupj+ls_exe_ymd+String(ll_exe_no)

Close(Parent)
end event

type dw_ip from u_key_enter within w_kbgb01a
integer x = 37
integer y = 32
integer width = 3365
integer height = 148
integer taborder = 10
string dataobject = "dw_kbgb01a_1"
boolean border = false
end type

event itemerror;return 1
end event

