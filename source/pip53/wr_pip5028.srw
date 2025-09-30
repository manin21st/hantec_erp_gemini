$PBExportHeader$wr_pip5028.srw
$PBExportComments$** 퇴직소득 원천징수 영수증 출력
forward
global type wr_pip5028 from w_standard_print
end type
type rb_1 from radiobutton within wr_pip5028
end type
type rb_2 from radiobutton within wr_pip5028
end type
type rb_3 from radiobutton within wr_pip5028
end type
type st_1 from statictext within wr_pip5028
end type
type rr_2 from roundrectangle within wr_pip5028
end type
type rr_3 from roundrectangle within wr_pip5028
end type
end forward

global type wr_pip5028 from w_standard_print
string title = "퇴직소득 원천영수증"
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
st_1 st_1
rr_2 rr_2
rr_3 rr_3
end type
global wr_pip5028 wr_pip5028

type variables

end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_paydate, ls_empno, ls_left, ls_mid, ls_right , ls_etc_name,ls_text, ls_saupcd
string ls_saupno , ls_bubno, ls_bubinname, ls_comname, ls_location, ls_tel, ls_kdate
string ls_sabu
int i

Setpointer(hourglass!)

if dw_ip.Accepttext() = -1 then return -1

ls_paydate = dw_ip.GetitemString(1,'sdate')
ls_sabu = dw_ip.GetitemString(1,'saupcd')

if isnull(ls_sabu) or ls_sabu = '' then ls_sabu = '%'
 
IF ls_paydate = '' OR ISNULL(ls_paydate) OR ls_paydate = '00000000' THEN
	MessageBox("확 인","작업일자를 입력하세요!!")
	dw_ip.Setcolumn('sdate')
	dw_ip.SetFocus( ) 
	Return -1
END IF

ls_kdate = dw_ip.GetitemString(1,'ydate')

//IF ls_kdate = '' OR ISNULL(ls_kdate) OR ls_kdate = '00000000' THEN
//	MessageBox("확 인","지급일자를 입력하세요!!")
//	dw_ip.Setcolumn('ydate')
//	dw_ip.SetFocus( ) 
//	Return -1
//END IF

ls_empno = dw_ip.GetitemString(1,'empno')

if ls_empno = "" or isnull(ls_empno) then 
//   messagebox("확 인", "사번을 입력하세요.!!")
//	dw_ip.Setcolumn('empno')
//	dw_ip.SetFocus( ) 
//   return -1
   ls_empno = '%'
end if	

ls_etc_name = dw_ip.GetitemString(1,'semu')

//if ls_etc_name = "" or isnull(ls_etc_name) then 
//   messagebox("확 인", "세무서를 입력하세요.!!")
//	dw_ip.Setcolumn('semu')
//	dw_ip.SetFocus( ) 
//   return -1
//end if	

 dw_list.SetRedraw(False)		
if dw_list.Retrieve(gs_company, ls_empno, ls_paydate,ls_sabu) > 0 then 
	/*법인정보*/
	  SELECT SAUPNO, JURNAME, CHAIRMAN, JURNO, ADDR, PHONE
		 INTO :ls_saupno,			//사업자등록번호
				:ls_bubinname,		//법인명
				:ls_comname,		//대표자명
				:ls_bubno,			//법인등록번호
				:ls_location,		//주소
				:ls_tel				//전화번호
		 FROM "P0_SAUPCD"
		WHERE COMPANYCODE = 'KN' AND
				SAUPCODE = decode(:ls_sabu,'%','10',:ls_sabu);
				
			dw_list.SetItem(1, "cdpman", ls_comname)
			dw_list.SetItem(1, "caddr", ls_location)
			dw_list.SetItem(1, "csano", ls_saupno)
			dw_list.SetItem(1, "crno1", ls_bubno)
			dw_list.SetItem(1, "csaname", ls_bubinname)
			dw_list.SetItem(1, "cectname", ls_etc_name)
			
			if rb_1.checked= true then
				ls_text="발행자보고용"
			elseif rb_2.checked=true then
				ls_text="발행자보관용"
			elseif rb_3.checked=true then
				ls_text="소득자보관용"
			end if	
	
  if ls_empno <> '%' then	
			dw_list.SetItem(1, "st_name", ls_text)
			
			dw_list.SetItem(1, "kyear", left(ls_kdate,4))
			dw_list.SetItem(1, "kmonth", mid(ls_kdate,5,2))
			dw_list.SetItem(1, "kday", right(ls_kdate,2))
	
			dw_list.SetRedraw(true)
	else	
		 FOR i = 1 to dw_list.Rowcount()
				
		   ls_empno = dw_list.GetitemString(i,'empno')
			
				
				dw_list.SetItem(i, "cdpman", ls_comname)
				dw_list.SetItem(i, "caddr", ls_location)
				dw_list.SetItem(i, "csano", ls_saupno)
				dw_list.SetItem(i, "crno1", ls_bubno)
				dw_list.SetItem(i, "csaname", ls_bubinname)
				dw_list.SetItem(i, "cectname", ls_etc_name)
				
				dw_list.SetItem(i, "st_name", ls_text)
				
				dw_list.SetItem(i, "kyear", left(ls_kdate,4))
				dw_list.SetItem(i, "kmonth", mid(ls_kdate,5,2))
				dw_list.SetItem(i, "kday", right(ls_kdate,2))
		
				dw_list.SetRedraw(true)			
   	 Next
		
	end if
ELSE
	MessageBox("확 인","조회한 자료가 없습니다!!")
	dw_list.Insertrow(0)
	dw_list.SetRedraw(true)		
	return -1
End If

dw_list.Object.DataWindow.Print.Preview = 'yes'
return 1

end function

on wr_pip5028.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.st_1=create st_1
this.rr_2=create rr_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rb_3
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.rr_2
this.Control[iCurrent+6]=this.rr_3
end on

on wr_pip5028.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.st_1)
destroy(this.rr_2)
destroy(this.rr_3)
end on

event open;call super::open;dw_list.InsertRow(0)

dw_ip.Setitem(1,'sdate', f_today())
dw_ip.Setitem(1,'ydate', f_today())

f_set_saupcd(dw_ip, 'saupcd', '1')
is_saupcd = gs_saupcd
end event

type p_xls from w_standard_print`p_xls within wr_pip5028
end type

type p_sort from w_standard_print`p_sort within wr_pip5028
end type

type p_preview from w_standard_print`p_preview within wr_pip5028
integer x = 4059
end type

event p_preview::clicked;OpenWithParm(w_print_preview, dw_list)	
end event

type p_exit from w_standard_print`p_exit within wr_pip5028
integer x = 4407
end type

type p_print from w_standard_print`p_print within wr_pip5028
integer x = 4233
end type

event p_print::clicked;IF dw_list.rowcount() > 0 then 
	gi_page = dw_list.GetItemNumber(1,"last_page")
ELSE
	gi_page = 1
END IF
OpenWithParm(w_print_options, dw_list)
end event

type p_retrieve from w_standard_print`p_retrieve within wr_pip5028
integer x = 3886
end type

type st_window from w_standard_print`st_window within wr_pip5028
boolean visible = false
end type

type sle_msg from w_standard_print`sle_msg within wr_pip5028
boolean visible = false
end type

type dw_datetime from w_standard_print`dw_datetime within wr_pip5028
boolean visible = false
end type

type st_10 from w_standard_print`st_10 within wr_pip5028
boolean visible = false
end type

type gb_10 from w_standard_print`gb_10 within wr_pip5028
boolean visible = false
end type

type dw_print from w_standard_print`dw_print within wr_pip5028
integer x = 3749
integer y = 32
string dataobject = "dr_pip5028_2"
end type

type dw_ip from w_standard_print`dw_ip within wr_pip5028
integer x = 146
integer y = 52
integer width = 2720
integer height = 240
string dataobject = "dr_pip5028_1"
boolean livescroll = false
end type

event dw_ip::itemchanged;call super::itemchanged;String sEmpno,snull,sEmpname,sName,sMdate, ls_name
Int sNo 

SetNull(snull)

this.AcceptText()

IF this.GetColumnName() = 'saupcd' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF

IF dw_ip.GetColumnName() = "empno" THEN
    sEmpno = dw_ip.GetText()
   IF sEmpno = '' or isnull(sEmpno) THEN
		dw_ip.SetITem(1,"empno",snull)
		dw_ip.SetITem(1,"empname",snull)
		Return 
	END IF	
	  SELECT COUNT(P1_MASTER.EMPNO)
      INTO :sNo  
     FROM "P1_MASTER" 
	  WHERE "P1_MASTER"."EMPNO" =:sEmpno ;
	  
     IF sNo = 0 or isnull(sNo) THEN
		  MessageBox("확인","등록되어있지 않은  사원입니다")
		  dw_ip.SetITem(1,"empno",snull)
		  dw_ip.SetITem(1,"empname",snull)
		  dw_ip.SetColumn("empno")
		  dw_ip.SetFocus()
		  Return 1
	  END IF	
	       SELECT "P1_MASTER"."EMPNAME"  
          INTO :sName  
          FROM "P1_MASTER"
			 WHERE "P1_MASTER"."EMPNO" = :sEmpno ;
			 
         dw_ip.SetITem(1,"empname",sName) 
			
			
	  select max(todate) into :sMdate
	  from p3_retirementpay
	  where empno = :sEmpno;
	  
	  if IsNull(sMdate) or sMdate = '' then
	  else
		   dw_ip.Setitem(1,'sdate', sMdate)
     end if
	 
	
END IF	

IF GetColumnName() = "empname" then
  sEmpName = GetItemString(1,"empname")

   ls_name = wf_exiting_saup_name('empname',sEmpName, '1', is_saupcd)	 
	 if IsNull(ls_name) then 
		 Setitem(1,'empname',ls_name)
		 Setitem(1,'empno',ls_name)
		 return 1
    end if
	 Setitem(1,"empno",ls_name)
	 ls_name = wf_exiting_saup_name('empno',ls_name, '1', is_saupcd)
	 Setitem(1,"empname",ls_name)
	  select max(todate) into :sMdate
	  from p3_retirementpay
	  where empno = :sEmpno;
	  
	  if IsNull(sMdate) or sMdate = '' then
	  else
		   dw_ip.Setitem(1,'sdate', sMdate)
     end if
	 return 1
END IF
	
	
	
	
	
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::rbuttondown;call super::rbuttondown;string sMdate
dw_ip.AcceptText()

SetNull(Gs_codename)
SetNull(Gs_code)
SetNull(Gs_gubun)

Gs_gubun = is_saupcd

IF dw_ip.GetColumnName() = "empno" THEN
   Gs_Code = dw_ip.GetITemString(1,"empno")
   open(w_employee_retire_popup)
	
   IF IsNull(Gs_code) THEN RETURN
	 
   dw_ip.SetITem(1,"empno",Gs_code)
	dw_ip.SetITem(1,"empname",Gs_codename)
	
	  select max(todate) into :sMdate
	  from p3_retirementpay
	  where empno = :Gs_code;
	  
	  if IsNull(sMdate) or sMdate = '' then
	  else
		   dw_ip.Setitem(1,'sdate', sMdate)
     end if
	  
END IF

IF dw_ip.GetColumnName() = "empname" THEN
   Gs_codename = dw_ip.GetITemString(1,"empno")
   open(w_employee_retire_popup)
	
   IF IsNull(Gs_code) THEN RETURN
	 
   dw_ip.SetITem(1,"empno",Gs_code)
	dw_ip.SetITem(1,"empname",Gs_codename)
	
	  select max(todate) into :sMdate
	  from p3_retirementpay
	  where empno = :Gs_code;
	  
	  if IsNull(sMdate) or sMdate = '' then
	  else
		   dw_ip.Setitem(1,'sdate', sMdate)
     end if
	  
END IF	
end event

type dw_list from w_standard_print`dw_list within wr_pip5028
integer x = 178
integer y = 308
integer width = 3886
integer height = 1956
string dataobject = "dr_pip5028_3"
end type

event dw_list::rowfocuschanged;//OVERRIDE
end event

event dw_list::clicked;//OVERRIDE
end event

type rb_1 from radiobutton within wr_pip5028
integer x = 3246
integer y = 64
integer width = 453
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "발행자보고용"
boolean checked = true
end type

type rb_2 from radiobutton within wr_pip5028
integer x = 3246
integer y = 136
integer width = 453
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "발행자보관용"
end type

type rb_3 from radiobutton within wr_pip5028
integer x = 3246
integer y = 212
integer width = 453
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "소득자보관용"
end type

type st_1 from statictext within wr_pip5028
integer x = 2939
integer y = 88
integer width = 256
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "출력구분"
alignment alignment = center!
boolean focusrectangle = false
end type

type rr_2 from roundrectangle within wr_pip5028
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 2889
integer y = 56
integer width = 873
integer height = 228
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within wr_pip5028
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 16777215
integer x = 165
integer y = 292
integer width = 3918
integer height = 1988
integer cornerheight = 40
integer cornerwidth = 46
end type

