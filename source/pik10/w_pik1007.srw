$PBExportHeader$w_pik1007.srw
$PBExportComments$** 개인별 주간별 근무일등록
forward
global type w_pik1007 from w_inherite_standard
end type
type dw_3 from datawindow within w_pik1007
end type
type rr_1 from roundrectangle within w_pik1007
end type
type rr_2 from roundrectangle within w_pik1007
end type
type dw_detail from u_d_select_sort within w_pik1007
end type
type dw_list from u_d_select_sort within w_pik1007
end type
type dw_req from u_key_enter within w_pik1007
end type
type dw_allreg from u_key_enter within w_pik1007
end type
end forward

global type w_pik1007 from w_inherite_standard
string title = "주간별 근무일등록"
boolean maxbox = false
boolean resizable = false
event ue_rtv_dept ( )
dw_3 dw_3
rr_1 rr_1
rr_2 rr_2
dw_detail dw_detail
dw_list dw_list
dw_req dw_req
dw_allreg dw_allreg
end type
global w_pik1007 w_pik1007

type variables
string arg_date[7]
string kcode[7] = {'k1','k2','k3','k4','k5','k6','k7'}
string kempno[]
int    k
end variables

forward prototypes
public subroutine wf_setradiobutton (integer lrow)
public subroutine wf_setcheck (integer iflag)
end prototypes

event ue_rtv_dept();string ls_jikjong
dw_req.Accepttext()
ls_jikjong = dw_req.GetitemString(1,'jikjong')
if IsNull(ls_jikjong) or ls_jikjong = '' then ls_jikjong = '%'

dw_list.Retrieve(is_saupcd,ls_jikjong)
dw_list.SelectRow(0,false)
dw_list.insertrow(1)
dw_list.SetItem(1,'deptname2','전      체')
dw_list.SelectRow(1,true)
end event

public subroutine wf_setradiobutton (integer lrow);int i
string snm[]

for i = 1 to lrow
	 select codenm into :snm[i]
	 from p0_ref
	 where codegbn = 'KG' and code <> '00' and code = to_char(:i);
next


if lrow = 1 then
	dw_detail.Object.kunmu.values = snm[1]+"	1/"
elseif lrow = 2 then
	dw_detail.Object.kunmu.values = snm[1]+"	1/"+snm[2]+"	2/" 
elseif lrow = 3 then
	dw_detail.Object.kunmu.values = snm[1]+"	1/"+snm[2]+"	2/"+snm[3]+"	2/" 
elseif lrow = 4 then
	dw_detail.Object.kunmu.values = snm[1]+"	1/"+snm[2]+"	2/"+snm[3]+"	2/"+snm[4]+"	2/" 
elseif lrow = 5 then
	dw_detail.Object.kunmu.values = snm[1]+"	1/"+snm[2]+"	2/"+snm[3]+"	2/"+snm[4]+"	2/"+snm[5]+"	2/" 
end if
end subroutine

public subroutine wf_setcheck (integer iflag);string ls_yn, ls_empno
int i,  j

if dw_detail.Accepttext() = -1 then return

if iflag = 1 then
	k = 1
	For i = 1 to dw_detail.rowcount()
		 ls_yn = dw_detail.GetitemString(i, 'chk')
		 if ls_yn  = 'Y' then
			  Kempno[k] = dw_detail.getitemString(i,'empno')
			  k += 1
		  end if		
	Next
	k -= 1
else
	For i = 1 to dw_detail.rowcount()
		 ls_empno = dw_detail.GetitemString(i, 'empno')
		 For j = 1 to k			
			 if  ls_empno  = Kempno[j] then
				  dw_detail.Setitem(i,'chk','Y')
			 end if
		 Next
	Next
	
end if

end subroutine

event open;call super::open;String	mod_string, err, sdate

dw_req.setTransObject(sqlca)
dw_allReg.setTransObject(sqlca)
dw_detail.setTransObject(sqlca)
dw_list.setTransObject(sqlca)
dw_3.SettransObject(sqlca)

dw_req.setRow(dw_req.insertRow(0))

select max(cldate) into :sdate
from p4_calendar_saup
where saupcd = '10' and
      cldate <= :is_today and
		daygubn = '2';
dw_req.Setitem(1,'sdate',sdate)
dw_req.Setitem(1,'edate',f_afterday(sdate,6))

f_set_saupcd(dw_req, 'saup', '1')
is_saupcd = gs_saupcd

dw_allReg.setRow(dw_allReg.insertRow(0))
dw_allReg.setItem(1,'ddltname','1')

event ue_rtv_dept()
p_inq.TriggerEvent(Clicked!)

dw_list.SetFocus()
end event

on w_pik1007.create
int iCurrent
call super::create
this.dw_3=create dw_3
this.rr_1=create rr_1
this.rr_2=create rr_2
this.dw_detail=create dw_detail
this.dw_list=create dw_list
this.dw_req=create dw_req
this.dw_allreg=create dw_allreg
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_3
this.Control[iCurrent+2]=this.rr_1
this.Control[iCurrent+3]=this.rr_2
this.Control[iCurrent+4]=this.dw_detail
this.Control[iCurrent+5]=this.dw_list
this.Control[iCurrent+6]=this.dw_req
this.Control[iCurrent+7]=this.dw_allreg
end on

on w_pik1007.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_3)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.dw_detail)
destroy(this.dw_list)
destroy(this.dw_req)
destroy(this.dw_allreg)
end on

type p_mod from w_inherite_standard`p_mod within w_pik1007
integer x = 4210
end type

event p_mod::clicked;call super::clicked;//String	ls_empno, ls_kunmu, ls_tag
//long		ll_row, ll_cnt, i
//
//ll_row = dw_detail.rowCount()
//
//w_mdi_frame.sle_msg.text ="데이타를 저장하고 있습니다."
//
//FOR i = 1 to ll_row
//
//	ls_empno = dw_detail.getItemString(i,'empno')
//	ls_kunmu = dw_detail.getItemString(i,'kunmu')
//	ls_tag = dw_detail.getItemString(i,'tag')
//	
//	SELECT 	count(empno)
//	INTO 		:ll_cnt
//	FROM 		p1_kunmu
//	WHERE 	empno = :ls_empno;
//	
//	IF ll_cnt <= 0 THEN
//		INSERT INTO p1_kunmu
//		VALUES(:ls_empno, :ls_kunmu, :ls_tag);
//	ELSE
//		UPDATE p1_kunmu SET
//						kunmu = :ls_kunmu, 
//						tag = :ls_tag
//		WHERE empno = :ls_empno;
//	END IF
//NEXT
//
////MessageBox('sqlcode',string(sqlca.sqlcode))
//IF sqlca.sqlcode = 0 THEN
//	commit;
//ELSE
//	rollback;
//	MessageBox(string(sqlca.sqlcode),'error message= '+SQLCA.SQLErrText)	
//	w_mdi_frame.sle_msg.text ="저장에 실패하였습니다."
//	return
//END IF
//
//w_mdi_frame.sle_msg.text ="저장 완료하였습니다."


Int j ,i ,l
string ls_empno ,ls_kmgb 

IF dw_detail.Accepttext() = -1 THEN 	RETURN

l= 1
dw_3.reset()

IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN

wf_setcheck(1)

w_mdi_frame.sle_msg.text = '자료 저장 중......'
SetPointer(HourGlass!)

FOR j = 1 to dw_detail.rowcount()
	ls_empno = dw_detail.getitemstring(j,"empno")
   DELETE FROM "P4_PERKUNMU"  
   WHERE ( "P4_PERKUNMU"."COMPANYCODE" = :gs_company ) AND  
         ( "P4_PERKUNMU"."KDATE" >= :arg_date[1] ) AND  
         ( "P4_PERKUNMU"."KDATE" <= :arg_date[7] ) AND 
			( "P4_PERKUNMU"."EMPNO"  = :ls_empno)  	; 
   for i = 1 to 7 
		ls_kmgb  = dw_detail.GetItemString(j,kcode[i])
		if ls_kmgb = '' or  isnull(ls_kmgb) then
		else	
		   dw_3.insertrow(0)
			dw_3.setitem(l,"companycode",gs_company)
			dw_3.setitem(l,"empno",ls_empno)
			dw_3.setitem(l,"kdate",arg_date[i])
			dw_3.setitem(l,"kmgubn",ls_kmgb)
		   l = l+1
		end if
	next	

NEXT

///////////////////////////////////////////////////////////////////////////////////
IF dw_3.Update() > 0 THEN			
	COMMIT USING sqlca;
	ib_any_typing =False
	
ELSE
	ROLLBACK USING sqlca;
	ib_any_typing = True
	SetPointer(Arrow!)
	Return
END IF

w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
SetPointer(Arrow!)

dw_detail.Setfocus()


end event

type p_del from w_inherite_standard`p_del within w_pik1007
boolean visible = false
integer x = 1989
integer y = 2356
end type

type p_inq from w_inherite_standard`p_inq within w_pik1007
integer x = 4032
end type

event p_inq::clicked;call super::clicked;//Integer row, cnt,i
//string ls_jjong, ls_dept, ls_type, mod_string, sSaup, sKunmu
//
//dw_req.acceptText()
//dw_list.acceptText()
//
//row = dw_list.GetRow()
//IF row <= 0 OR row > dw_list.RowCount() THEN
//	parent.event ue_rtv_dept()
//	dw_list.SelectRow(1,True)
//	row = 1
//END IF
//
//ls_dept = dw_list.GetItemString(row,'deptcode')
//ls_jjong = dw_req.getItemString(1,'jikjong')
//ls_type = dw_req.getItemString(1,'stype')       //급여구분
//sSaup = trim(dw_req.GetItemString(1,"saup"))
//sKunmu = trim(dw_req.GetItemString(1,"kunmu"))  //기본설정
//
//w_mdi_frame.sle_msg.text ="데이타를 조회하고 있습니다."
// 
//IF ls_dept = '' OR IsNull(ls_dept) THEN ls_dept = '%'	
//IF sSaup = '' OR IsNull(sSaup) THEN sSaup = '%'
//IF sKunmu = '' OR IsNull(sKunmu) THEN sKunmu = '%'
//IF isNull(ls_jjong) or ls_jjong = '' THEN ls_jjong = '%'
//IF isNull(ls_type) or ls_type = '' THEN ls_type = '%'
//
//select count(*) into :cnt from p0_ref where codegbn = 'KG' and code <> '00';
//
//dw_detail.Object.kunmu.RadioButtons.Columns= cnt
//wf_setradiobutton(cnt)
////dw_detail.Object.cgubn.values = snm[1]+"	1/"+snm[2]+"	2/" 
////dw_detail.Object.cgubn.values = "zz	1/ss	2/ee	3/" 
//
//IF dw_detail.retrieve(gs_Today,ls_jjong,ls_dept,sKunmu,sSaup,ls_type) < 1 THEN
//	w_mdi_frame.sle_msg.text ="조회된 데이타가 없습니다."
//ELSE
//	w_mdi_frame.sle_msg.text ="데이타를 조회했습니다."
//	dw_list.SetFocus()
//END IF
//
//return
IF ib_any_typing = true THEN  				

	IF MessageBox("확인" , "저장하지 않은 값이 있습니다. ~r변경사항을 저장하시겠습니까", &
		 question!, yesno!) = 1 THEN
		RETURN 
	END IF

END IF

string ls_kdate, ls_deptcode, ls_dept, sabu,ls_jjong

int i,row
w_mdi_frame.sle_msg.text =""

dw_req.accepttext()
dw_list.acceptText()

row = dw_list.GetRow()
IF row <= 0 OR row > dw_list.RowCount() THEN
	parent.event ue_rtv_dept()
	dw_list.SelectRow(1,True)
	row = 1
END IF

dw_allreg.setitem(1,'allchk','N')
ls_dept = dw_list.GetItemString(row,'deptcode')
ls_kdate = Trim(dw_req.Getitemstring(dw_req.getrow(),'sdate'))
ls_jjong = Trim(dw_req.getItemString(1,'jikjong'))
sabu = dw_req.Getitemstring(dw_req.getrow(),'saup')

//처리일자 검사
IF ls_kdate = "" OR IsNull(ls_kdate) THEN
	MessageBox("확 인","근태일자를 입력하십시요!!")
	dw_req.SetColumn("kdate")
	dw_req.SetFocus()
	Return
ELSE
	if f_datechk(ls_kdate) = -1 then
		 messagebox("확인","근태일자를 확인하십시오!")
		 dw_req.setcolumn("kdate")
		 dw_req.setfocus()
		 return -1
	end if
END IF

if ls_dept = '' or IsNull(ls_dept) then ls_dept = '%'
if IsNull(sabu) or sabu = '' then sabu = '%'
if IsNull(ls_jjong) or ls_jjong = '' then ls_jjong = '%'

arg_date[1] = ls_kdate
for i = 1 to 6 
	arg_date[i+1] =  string(RelativeDate(date(left(ls_kdate,4) + "." + mid(ls_kdate,5,2) & 
	                                          + "." + right(ls_kdate,2)), i),'yyyymmdd')
next	

dw_detail.retrieve(ls_dept, gs_company , arg_date[1], arg_date[2], arg_date[3], arg_date[4] & 
                 , arg_date[5], arg_date[6], arg_date[7],sabu, ls_jjong)
dw_detail.Setfocus()

ib_any_typing = false

end event

type p_print from w_inherite_standard`p_print within w_pik1007
boolean visible = false
integer x = 1289
integer y = 2356
end type

type p_can from w_inherite_standard`p_can within w_pik1007
boolean visible = false
integer x = 2162
integer y = 2356
end type

type p_exit from w_inherite_standard`p_exit within w_pik1007
end type

type p_ins from w_inherite_standard`p_ins within w_pik1007
boolean visible = false
integer x = 1467
integer y = 2356
end type

type p_search from w_inherite_standard`p_search within w_pik1007
boolean visible = false
integer x = 1111
integer y = 2356
end type

type p_addrow from w_inherite_standard`p_addrow within w_pik1007
boolean visible = false
integer x = 1641
integer y = 2356
end type

type p_delrow from w_inherite_standard`p_delrow within w_pik1007
boolean visible = false
integer x = 1815
integer y = 2356
end type

type dw_insert from w_inherite_standard`dw_insert within w_pik1007
boolean visible = false
integer x = 841
integer y = 2356
end type

type st_window from w_inherite_standard`st_window within w_pik1007
boolean visible = false
end type

type cb_exit from w_inherite_standard`cb_exit within w_pik1007
boolean visible = false
end type

type cb_update from w_inherite_standard`cb_update within w_pik1007
boolean visible = false
end type

type cb_insert from w_inherite_standard`cb_insert within w_pik1007
boolean visible = false
end type

type cb_delete from w_inherite_standard`cb_delete within w_pik1007
boolean visible = false
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pik1007
boolean visible = false
end type

type st_1 from w_inherite_standard`st_1 within w_pik1007
boolean visible = false
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pik1007
boolean visible = false
end type

type dw_datetime from w_inherite_standard`dw_datetime within w_pik1007
boolean visible = false
end type

type sle_msg from w_inherite_standard`sle_msg within w_pik1007
boolean visible = false
end type

type gb_2 from w_inherite_standard`gb_2 within w_pik1007
boolean visible = false
end type

type gb_1 from w_inherite_standard`gb_1 within w_pik1007
boolean visible = false
end type

type gb_10 from w_inherite_standard`gb_10 within w_pik1007
boolean visible = false
end type

type dw_3 from datawindow within w_pik1007
boolean visible = false
integer x = 3936
integer y = 188
integer width = 686
integer height = 60
integer taborder = 60
boolean bringtotop = true
string title = "저장dw"
string dataobject = "d_pik1007_5"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_pik1007
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 837
integer y = 284
integer width = 3753
integer height = 1944
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pik1007
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 284
integer width = 805
integer height = 1948
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_detail from u_d_select_sort within w_pik1007
integer x = 841
integer y = 288
integer width = 3717
integer height = 1932
integer taborder = 21
string dataobject = "d_pik1007_3"
boolean hscrollbar = false
boolean border = false
end type

event itemchanged;call super::itemchanged;string skunmu, snull

if this.GetColumnName() = 'chk' then
   skunmu = this.Gettext()
	dw_allreg.Setitem(1,'ddwtype',snull)	
	
end if
end event

event itemerror;call super::itemerror;Return 1
end event

event rowfocuschanged;call super::rowfocuschanged;
this.SelectRow(0, FALSE)
this.SelectRow(currentrow, TRUE)
end event

type dw_list from u_d_select_sort within w_pik1007
integer x = 27
integer y = 292
integer width = 773
integer height = 1928
integer taborder = 11
string dataobject = "d_pik1007_4"
boolean hscrollbar = false
boolean border = false
end type

event clicked;int li_idx,li_loc, li_i
long ll_clickedrow, ll_cur_row
String ls_raised = '6' , ls_lowered = '5' 
string ls_keydowntype,ls_dwobject, ls_tabkey = '~t', ls_dwobject_name
String ls_modify, ls_setsort, ls_rc, ls_sort_title, ls_col_no
DataWindow dw_sort

SetPointer(HourGlass!)

ls_dwobject = GetObjectAtPointer()
li_loc = Pos(ls_dwobject, ls_tabkey)
If li_loc = 0 Then Return
ls_dwobject_name = Left(ls_dwobject, li_loc - 1)
//유 상웅 추가(99.04) 헤드에 _t가 없으면 바로 RETURN  
if '_t' <> Right(ls_dwobject_name, 2) then return 
	
//IF b_flag =False THEN 
//	b_flag =True
//	RETURN
//END IF 
If ls_dwobject_name = 'type'  Then
	If Describe(ls_dwobject_name + ".border") = ls_lowered Then
		ls_modify = ls_dwobject_name + ".border=" + ls_raised
		ls_modify = ls_modify + " " + ls_dwobject_name + &
		 ".text=" + "'오름차순'"
	Else
		ls_modify = ls_dwobject_name + ".border=" + ls_lowered
		ls_modify = ls_modify + " " + ls_dwobject_name + &
		 ".text=" + "'내림차순'"
	End If

	ls_rc = Modify(ls_modify)
	If ls_rc <> "" Then
		MessageBox("dwModify", ls_rc + " : " + ls_modify)
		Return
	End If
	uf_sort(is_old_dwobject_name)
	Return
End If

If is_old_dwobject_name <> ls_dwobject_name Then 
	If uf_sort(ls_dwobject_name) = -1 Then Return
	If is_old_dwobject_name = "" Then
		ls_col_no = String(Describe("datawindow.column.count"))
		For li_i = 1 To Integer(ls_col_no)
			If Describe("#" + ls_col_no + ".border") = ls_lowered Then
				is_old_dwobject_name = Describe("#" + ls_col_no + &
				 + ".name") + "_t"
				is_old_color = Describe(is_old_dwobject_name + ".color")
				Exit
			End If
		Next
	End If
	If is_old_dwobject_name <> "" Then
		ls_modify = is_old_dwobject_name + ".border=" + ls_raised
		ls_modify = ls_modify + " " + &
		 is_old_dwobject_name + ".color=" + is_old_color
		ls_rc = Modify(ls_modify)
		If ls_rc <> "" Then
			MessageBox("dwModify", ls_rc + " : " + ls_modify)
			Return
		End If
	End If
	is_old_color = Describe(ls_dwobject_name + ".color")
	ls_modify = ls_dwobject_name + ".border=" + ls_lowered
	ls_modify = ls_modify + " " + &
	 ls_dwobject_name + ".color=" + String(RGB(0, 0, 128))
	ls_rc = Modify(ls_modify)
	If ls_rc <> "" Then
		MessageBox("dwModify", ls_rc + " : " + ls_modify)
		Return
	End If

	is_old_dwobject_name = ls_dwobject_name
End If


If Row <= 0 then
	this.SelectRow(0,False)
	b_flag =True
END IF

end event

event rowfocuschanged;call super::rowfocuschanged;If CurrentRow <= 0 then
	this.SelectRow(0,False)
	b_flag =True
ELSE
	this.SelectRow(0, FALSE)
	this.SelectRow(CurrentRow, TRUE)
	b_flag = False
	p_inq.TriggerEvent(Clicked!)
END IF
end event

type dw_req from u_key_enter within w_pik1007
integer x = 5
integer y = 8
integer width = 1883
integer height = 240
integer taborder = 11
string dataobject = "d_pik1007_1"
boolean border = false
end type

event itemchanged;call super::itemchanged;string ls_sdate, ls_edate, snull

this.Accepttext()

if this.GetColumnName() = 'sdate' then
   ls_sdate = this.Gettext()
   if IsNull(ls_sdate) or ls_sdate  = '' then
		this.Setitem(1,'edate',snull)
	else
		this.Setitem(1,'edate',f_afterday(ls_sdate,6))
	end if
end if
		
if this.GetColumnName() = 'saup' then
	is_saupcd = this.GetText()
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
   parent.event ue_rtv_dept()
end if

if this.GetColumnName() = 'jikjong' then
   parent.event ue_rtv_dept()
end if

p_inq.Triggerevent(Clicked!)
	
end event

event itemerror;call super::itemerror;Return 1
end event

event rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(Gs_gubun)

GS_gubun = is_saupcd
IF dw_req.GetColumnName() = "sdeptcode" THEN
	Open(w_dept_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	dw_req.SetITem(1,"sdeptcode",gs_code)
	dw_req.SetITem(1,"sdeptname",gs_codename)
	p_inq.TriggerEvent(Clicked!)
END IF
end event

event buttonclicked;call super::buttonclicked;String ls_sdate, ls_edate

this.Accepttext()

IF dwo.name = 'b_plus' THEN
   ls_sdate = this.GetitemString(1,'sdate')
	this.Setitem(1,'sdate', f_afterday(ls_sdate,7))
	this.Setitem(1,'edate', f_afterday(ls_sdate,13))	
	p_inq.Triggerevent(Clicked!)
	wf_setcheck(2)
ELSEIF dwo.name = 'b_minus' THEN
	ls_sdate = this.GetitemString(1,'sdate')
	this.Setitem(1,'sdate', f_afterday(ls_sdate,-7))
	this.Setitem(1,'edate', f_afterday(ls_sdate,-1))
	p_inq.Triggerevent(Clicked!)	
	wf_setcheck(2)
END IF
end event

type dw_allreg from u_key_enter within w_pik1007
integer x = 1874
integer width = 2117
integer height = 252
integer taborder = 21
boolean bringtotop = true
string dataobject = "d_pik1007_2"
boolean border = false
end type

event itemchanged;call super::itemchanged;long ll_rows, i
int j
String ls_regNum, chkgbn, sdaygbn, snull

dw_allReg.acceptText()

sdaygbn = this.GetitemString(1,'daygbn')
IF dw_allReg.GetColumnName() = 'daygbn' THEN
	dw_allreg.Setitem(1,'ddwtype',snull)
END IF	

IF dw_allReg.GetColumnName() = 'allchk' THEN
	chkgbn = data
	//if chkgbn = 'Y' then
		for i = 1 to dw_detail.rowcount()
			dw_detail.setItem(i,'chk',chkgbn)			
		next
	//end if	
	dw_allreg.Setitem(1,'ddwtype',snull)
	return 
END IF
IF dw_allReg.GetColumnName() = 'ddwtype' THEN
	ls_regNum = Trim(this.Gettext())
		ll_rows = dw_detail.rowCount()
      if ls_regNum = '0' or IsNull(ls_regNum) then
			ls_regNum = snull
		end if
		for i = 1 to ll_rows
			if dw_detail.GetitemString(i,'chk') = 'Y' then
				if sdaygbn = '0' then				
					for j = 1 to 7 
   			       dw_detail.setItem(i,'k'+string(j),ls_regNum)
				   Next		 
				else
  			       dw_detail.setItem(i,'k'+string(long(sdaygbn) - 1),ls_regNum)						
			   end if
			end if	
		next

	
END IF

end event

