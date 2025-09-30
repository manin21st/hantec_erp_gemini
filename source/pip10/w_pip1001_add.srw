$PBExportHeader$w_pip1001_add.srw
$PBExportComments$** ���� ���(�̷°���)
forward
global type w_pip1001_add from w_inherite_multi
end type
type dw_1 from datawindow within w_pip1001_add
end type
type dw_main from u_d_popup_sort within w_pip1001_add
end type
type cb_1 from commandbutton within w_pip1001_add
end type
type st_2 from statictext within w_pip1001_add
end type
type p_1 from picture within w_pip1001_add
end type
type rr_2 from roundrectangle within w_pip1001_add
end type
end forward

global type w_pip1001_add from w_inherite_multi
integer width = 4768
integer height = 2620
string title = "�������"
dw_1 dw_1
dw_main dw_main
cb_1 cb_1
st_2 st_2
p_1 p_1
rr_2 rr_2
end type
global w_pip1001_add w_pip1001_add

type variables
string is_yymm
end variables

forward prototypes
public function integer wf_updateyearpay ()
end prototypes

public function integer wf_updateyearpay ();string syymm, sempno, sbigo, shobong,slevel, sjikjong, sorderdate
decimal syear, smonth, sbonus, sbase
decimal ld_sudang1, ld_sudang2, ld_sudang3, ld_sudang4,ld_sudang5,ld_sudang6,ld_sudang7, ld_timepay
double syearpay
int lrow, row, cnt

if dw_main.Accepttext() = -1 then return -1
if dw_1.Accepttext() = -1 then return -1
 
row = dw_main.RowCount()

//If dw_main.ModifiedCount() <= 0 Then Return 1

lrow = 0
DO WHILE lrow < row

//lrow = dw_main.GetNextModified(lrow, Primary!)
lrow = lrow + 1
IF lrow > 0 THEN

	
	syymm = dw_1.GetItemstring(1, "yymm")
	sempno = dw_main.GetItemstring(lrow, "p1_master_empno")
    syear = dw_main.GetItemNumber(lrow, "yearamt")	 
	smonth = dw_main.GetItemNumber(lrow, "monthamt")	
	sbase = dw_main.GetItemNumber(lrow, "basepay") 
	sbonus = dw_main.GetItemNumber(lrow, "bonus") 
	ld_sudang1 = dw_main.GetItemNumber(lrow, "sudang1") 
	ld_sudang2 = dw_main.GetItemNumber(lrow, "sudang2") 
	ld_sudang3 = dw_main.GetItemNumber(lrow, "sudang3") 
	ld_sudang4 = dw_main.GetItemNumber(lrow, "sudang4") 
	ld_sudang5 = dw_main.GetItemNumber(lrow, "sudang5") 
	ld_sudang6 = dw_main.GetItemNumber(lrow, "sudang6") 
	ld_timepay  = dw_main.GetItemNumber(lrow, "timepay") 
	
	select count(*) into :cnt
	from p3_edityearpay
	where empno = :sempno and
	      yymm = :syymm;
	
	
	
	if cnt > 0 then	
	
	  UPDATE p3_edityearpay
		  SET  empno = :sempno,   
				 yearamt= :syear,   
				 monthamt = :smonth,
				 basepay = :sbase,
				 bonus = :sbonus,
				 sudang1 = :ld_sudang1,
				 sudang2 = :ld_sudang2,
				 sudang3 = :ld_sudang3,				
				 sudang4 = :ld_sudang4,
				 sudang5 = :ld_sudang5,
				 sudang6 = :ld_sudang6, 
				  timepay = :ld_timepay 
		WHERE  empno = :sempno and yymm = :syymm;
	 
				  
		if sqlca.sqlcode <> 0 then
			messagebox("Ȯ��","�������!")
			return -1 
		end if
	
   else
		
		insert into p3_edityearpay
        		 (empno, yearamt, monthamt, yymm, basepay, bonus, timepay,
			 	  sudang1, sudang2, sudang3, sudang4, sudang5, sudang6)
		values (:sempno, :syear, :smonth, :syymm, :sbase, :sbonus, :ld_timepay ,
		        :ld_sudang1,:ld_sudang2,:ld_sudang3,:ld_sudang4,:ld_sudang5,:ld_sudang6);
		
		if sqlca.sqlcode <> 0 then
			messagebox("Ȯ��","Insert ����!")
			return -1 
		end if
		
	end if	

//�߷ɻ��׿� ������Ʈ ���� ����(20220607 ������ ��û)
//	if sbase <> 0 or IsNull(sbase) = false then 
//			messagebox("Ȯ��", sempno + " UPDATE!")
//	
//		select max(orderdate) into :sorderdate
//		from p1_orders
//		where companycode = :gs_company and
//				empno = :sempno and
//				orderdate <= :syymm||'01';
//				
//	//   select nvl(basepay,0) into :syearpay
//	//	from p1_orders
//	//	where companycode = :gs_company and
//	//	      empno = :sempno and
//	//			orderdate = :sorderdate;		
//				
//			update p1_orders
//				set basepay = :sbase
//				where companycode = :gs_company and
//						empno = :sempno and
//						orderdate = :sorderdate;
//	
//			if sqlca.sqlcode <> 0 then			
//					rollback;
//					messagebox("Ȯ��","�߷ɻ��� ������Ʈ����!")
//					return -1 
//			else
//					commit;
//			end if		
//	end if
//  if sqlca.sqlcode = 0 and syearpay = 0 then 			
//	
//	  	update p1_orders
//			set basepay = :sbase
//			where companycode = :gs_company and
//					empno = :sempno and
//					orderdate = :sorderdate;	
//   			 
//			if sqlca.sqlcode <> 0 then
//				rollback;
//				messagebox("Ȯ��","�߷ɻ��� ������Ʈ����!")
//				return -1 
//			else
//				commit;
//				DECLARE start_sp_update_master procedure for sp_update_master(:gs_company,:sempno,:syymm+'01') ;
//            execute start_sp_update_master ;
//			end if
//			
//	end if
	
	
else			  
lrow = row + 1
end if

LOOP
return 1


end function

on w_pip1001_add.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_main=create dw_main
this.cb_1=create cb_1
this.st_2=create st_2
this.p_1=create p_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_main
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.p_1
this.Control[iCurrent+6]=this.rr_2
end on

on w_pip1001_add.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_main)
destroy(this.cb_1)
destroy(this.st_2)
destroy(this.p_1)
destroy(this.rr_2)
end on

event open;call super::open;
dw_main.SetTransObject(SQLCA)


dw_1.SetTransObject(SQLCA)
dw_1.insertrow(0)
dw_1.setitem(1,'yymm', left(f_today(),4)+'05')
is_yymm = left(f_today(),4)+'05'


String ls_jikjong

ls_jikjong = dw_1.GetitemString(1,'jikjong')
If IsNull(ls_jikjong) Then ls_jikjong = '%'

dw_main.retrieve(is_yymm, ls_jikjong)



end event

type p_delrow from w_inherite_multi`p_delrow within w_pip1001_add
boolean visible = false
integer x = 2158
integer y = 2916
end type

type p_addrow from w_inherite_multi`p_addrow within w_pip1001_add
boolean visible = false
integer x = 2345
integer y = 2908
boolean enabled = false
boolean focusrectangle = true
end type

type p_search from w_inherite_multi`p_search within w_pip1001_add
boolean visible = false
integer x = 2162
integer y = 3068
end type

type p_ins from w_inherite_multi`p_ins within w_pip1001_add
boolean visible = false
integer x = 2345
integer y = 2740
boolean enabled = false
boolean focusrectangle = true
end type

type p_exit from w_inherite_multi`p_exit within w_pip1001_add
integer x = 4389
integer y = 8
end type

type p_can from w_inherite_multi`p_can within w_pip1001_add
integer x = 4215
integer y = 8
end type

type p_print from w_inherite_multi`p_print within w_pip1001_add
boolean visible = false
integer x = 2336
integer y = 3068
end type

type p_inq from w_inherite_multi`p_inq within w_pip1001_add
integer x = 3867
integer y = 8
end type

event p_inq::clicked;call super::clicked;String ls_jikjong

ls_jikjong = dw_1.GetitemString(1,'jikjong')
If IsNull(ls_jikjong) Then ls_jikjong = '%'

dw_main.retrieve(is_yymm, ls_jikjong)
end event

type p_del from w_inherite_multi`p_del within w_pip1001_add
boolean visible = false
integer x = 2135
integer y = 2756
boolean enabled = false
boolean focusrectangle = true
end type

type p_mod from w_inherite_multi`p_mod within w_pip1001_add
integer x = 4041
integer y = 8
end type

event p_mod::clicked;call super::clicked;String snull

setpointer(hourglass!)

SetNull(snull)

if dw_main.rowcount() > 0 then

	IF MessageBox("Ȯ��", "�����Ͻðڽ��ϱ�?", question!, yesno!) = 2	THEN	RETURN
	
	if wf_updateyearpay() = 1 then
		ib_any_typing = False
		w_mdi_frame.sle_msg.text ="�ڷḦ �����Ͽ����ϴ�!!"
		commit;  
	ELSE
		ROLLBACK ;
		ib_any_typing = True
		Return	
	END IF
	
else
	return
	
end if
	

setpointer(arrow!)
end event

type dw_insert from w_inherite_multi`dw_insert within w_pip1001_add
boolean visible = false
integer y = 2832
boolean enabled = false
end type

type st_window from w_inherite_multi`st_window within w_pip1001_add
boolean visible = false
integer x = 2267
integer y = 2776
integer taborder = 30
long backcolor = 77633680
end type

type cb_append from w_inherite_multi`cb_append within w_pip1001_add
boolean visible = false
integer x = 1349
integer y = 2772
integer taborder = 60
end type

event cb_append::clicked;call super::clicked;//Int il_currow,il_functionvalue
//
//string jikjonggubn ,levelcode ,sCodeName,snull, syymm, sempno
//sle_msg.text= ''
//dw_level.accepttext()
//
//SetNull(snull)
//
//jikjonggubn  = dw_level.GetItemString(1,"jikjonggubn")
//levelcode   = dw_level.GetItemstring(1,"levelcode")
//syymm   = dw_level.GetItemstring(1,"yymm")
//
//
////IF jikjonggubn ="" OR IsNull(jikjonggubn) OR (jikjonggubn <> '1' AND jikjonggubn <> '2') THEN
////	Messagebox("Ȯ ��","������ Ȯ���ϼ���!!")
////	sle_msg.text= "����������  '1' , '2' "
////	dw_level.setitem(1,"jikjonggubn",snull)
////	dw_level.SetColumn("jikjonggubn")
////	dw_level.SetFocus()
////	Return  
////END IF
////
////IF levelcode ="" OR IsNull(levelcode) THEN
////	Messagebox("Ȯ ��","������ �Է��ϼ���!!")
//// 	sle_msg.text= ''
////	dw_level.SetColumn("levelcode")
////	dw_level.SetFocus()
////	Return 
////else
////	sCodeName = f_code_select('����',LevelCode)
////	IF IsNull(sCodeName) THEN
////		MessageBox("Ȯ ��","��ϵ��� ���� �����ڵ��Դϴ�!!")
////		dw_level.SetItem(1,"levelcode",snull)
////		dw_level.SetColumn("levelcode")
////		dw_level.SetFocus()	
////		Return 
////	END IF
////END IF
//
//IF dw_main.RowCount() <=0 THEN
//	il_currow = 0
//	il_functionvalue =1
//ELSE
//	il_functionvalue = wf_requiredcheck(dw_main.GetRow())
//	
//	il_currow = dw_main.Rowcount() 
//END IF
//
//IF il_functionvalue = 1 THEN
//	il_currow = il_currow + 1
//	
//	dw_main.InsertRow(il_currow)
//	dw_main.SetItem(il_currow,"companycode",gs_company)
//	dw_main.SetItem(il_currow,"levelcode",levelcode)
//	dw_main.SetItem(il_currow,"jikjonggubn",jikjonggubn)
////	dw_main.SetItem(il_currow,"startym",syymm)
//	
//	dw_main.ScrollToRow(il_currow)
//	dw_main.SetColumn("salary")
//	dw_main.SetFocus()
//	
//END IF
//
end event

type cb_exit from w_inherite_multi`cb_exit within w_pip1001_add
boolean visible = false
integer x = 1056
integer y = 3036
integer width = 206
integer height = 76
integer taborder = 110
integer textsize = -9
integer weight = 400
boolean enabled = false
end type

type cb_update from w_inherite_multi`cb_update within w_pip1001_add
boolean visible = false
integer x = 1106
integer y = 2904
integer width = 206
integer height = 76
integer taborder = 80
integer textsize = -9
integer weight = 400
boolean enabled = false
end type

event cb_update::clicked;String snull

setpointer(hourglass!)

SetNull(snull)

if dw_main.rowcount() > 0 then

	IF MessageBox("Ȯ��", "�����Ͻðڽ��ϱ�?", question!, yesno!) = 2	THEN	RETURN
	
	if wf_updateyearpay() = 1 then
		ib_any_typing = False
		sle_msg.text ="�ڷḦ �����Ͽ����ϴ�!!"
		commit;  
	ELSE
		ROLLBACK ;
		ib_any_typing = True
		Return	
	END IF
	
else
	return
	
end if
	

setpointer(arrow!)
end event

type cb_insert from w_inherite_multi`cb_insert within w_pip1001_add
boolean visible = false
integer x = 905
integer y = 2772
integer taborder = 70
end type

event cb_insert::clicked;call super::clicked;//Int il_currow,il_functionvalue
//
//string jikjonggubn ,levelcode ,sCodeName,snull
//sle_msg.text= ''
//dw_level.accepttext()
//
//SetNull(snull)
//
//jikjonggubn  = dw_level.GetItemString(1,"jikjonggubn")
//levelcode   = dw_level.GetItemstring(1,"levelcode")
//
//IF jikjonggubn ="" OR IsNull(jikjonggubn) OR (jikjonggubn <> '1' AND jikjonggubn <> '2') THEN
//	Messagebox("Ȯ ��","������ Ȯ���ϼ���!!")
//	sle_msg.text= "����������  '1' , '2' "
//	dw_level.setitem(1,"jikjonggubn",snull)
//	dw_level.SetColumn("jikjonggubn")
//	dw_level.SetFocus()
//	Return  
//END IF
//
//IF levelcode ="" OR IsNull(levelcode) THEN
//	Messagebox("Ȯ ��","������ �Է��ϼ���!!")
// 	sle_msg.text= ''
//	dw_level.SetColumn("levelcode")
//	dw_level.SetFocus()
//	Return 
//else
//	sCodeName = f_code_select('����',LevelCode)
//	IF IsNull(sCodeName) THEN
//		MessageBox("Ȯ ��","��ϵ��� ���� �����ڵ��Դϴ�!!")
//		dw_level.SetItem(1,"levelcode",snull)
//		dw_level.SetColumn("levelcode")
//		dw_level.SetFocus()	
//		Return 
//	END IF
//END IF
//
//
//IF dw_main.RowCount() <=0 THEN
//	il_currow = 1
//	il_functionvalue = 1
//ELSE
//	il_functionvalue = wf_requiredcheck(dw_main.GetRow())
//	
//	il_currow = dw_main.GetRow() 
//END IF
//
//IF il_functionvalue = 1 THEN
//	il_currow = il_currow 
//	
//	dw_main.InsertRow(il_currow)
//	dw_main.SetItem(il_currow,"companycode",gs_company)
//	dw_main.SetItem(il_currow,"levelcode",levelcode)
//	dw_main.SetItem(il_currow,"jikjonggubn",jikjonggubn)
//	
//	dw_main.ScrollToRow(il_currow)
//	dw_main.SetColumn("salary")
//	dw_main.SetFocus()
//	
//	
//END IF
//
end event

type cb_delete from w_inherite_multi`cb_delete within w_pip1001_add
boolean visible = false
integer x = 2437
integer y = 2864
integer taborder = 90
end type

event cb_delete::clicked;call super::clicked;Int il_currow

il_currow = dw_main.GetRow()
IF il_currow <=0 Then Return

IF	 MessageBox("���� Ȯ��", "�����Ͻðڽ��ϱ�? ", question!, yesno!) = 2	THEN return
	
dw_main.DeleteRow(il_currow)

IF dw_main.Update() > 0 THEN
	commit;
	IF il_currow = 1 THEN
	ELSE
		dw_main.ScrollToRow(il_currow - 1)
		dw_main.SetColumn("salary")
		dw_main.SetFocus()
	END IF
	ib_any_typing =False
	sle_msg.text ="�ڷḦ �����Ͽ����ϴ�!!"
ELSE
	rollback;
	ib_any_typing =True
	Return
END IF

end event

type cb_retrieve from w_inherite_multi`cb_retrieve within w_pip1001_add
boolean visible = false
integer x = 1061
integer y = 2844
integer width = 206
integer height = 56
integer taborder = 50
integer textsize = -9
integer weight = 400
boolean enabled = false
end type

event cb_retrieve::clicked;call super::clicked;dw_main.retrieve()
end event

type st_1 from w_inherite_multi`st_1 within w_pip1001_add
boolean visible = false
integer x = 105
integer y = 2776
long backcolor = 77633680
end type

type cb_cancel from w_inherite_multi`cb_cancel within w_pip1001_add
boolean visible = false
integer x = 1088
integer y = 2980
integer width = 206
integer height = 76
integer taborder = 100
integer textsize = -9
integer weight = 400
boolean enabled = false
end type

event cb_cancel::clicked;call super::clicked;
sle_msg.text = ''


dw_main.Reset()
ib_any_typing = false

end event

type dw_datetime from w_inherite_multi`dw_datetime within w_pip1001_add
boolean visible = false
integer x = 2917
integer y = 2776
end type

type sle_msg from w_inherite_multi`sle_msg within w_pip1001_add
boolean visible = false
integer x = 434
integer y = 2776
long backcolor = 77633680
end type

type gb_2 from w_inherite_multi`gb_2 within w_pip1001_add
boolean visible = false
integer x = 2363
integer y = 2692
integer width = 1161
long backcolor = 77633680
end type

type gb_1 from w_inherite_multi`gb_1 within w_pip1001_add
boolean visible = false
integer x = 471
integer y = 2768
integer width = 448
integer height = 188
long backcolor = 77633680
boolean enabled = false
end type

type gb_10 from w_inherite_multi`gb_10 within w_pip1001_add
boolean visible = false
integer x = 87
integer y = 2724
long backcolor = 77633680
end type

type dw_1 from datawindow within w_pip1001_add
integer x = 18
integer y = 28
integer width = 2587
integer height = 220
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_pip1001_add_1"
boolean border = false
boolean livescroll = true
end type

event buttonclicking;Int     il_currow,ikt, i
Double  dyearamt, dmontamt, ld_mamt, ld_sudang
string ldeptname, ls_gubun


dw_1.Accepttext()

ikt = dw_1.GetItemNumber(1,'prate')
ls_gubun = dw_1.GetitemString(1,'gubun')

if IsNull(ikt) or ikt = 0 then return

For i = 1 to dw_main.rowcount()

	 ldeptname = dw_main.GetitemString(i,'p0_dept_deptname')		 
   	 
    dyearamt = dw_main.GetitemNumber(i,'yearamt')	
	 dmontamt = dw_main.GetitemNumber(i,'monthamt')	
	
    ld_mamt = truncate(dyearamt / ikt	,0)	
	 
	 if ld_mamt > 0 then
	    ld_sudang = truncate(ld_mamt / ikt	,0)	
 	 end if	 
	 
	 if IsNull(dyearamt) or dyearamt = 0 then continue
	 if ls_gubun <> '1' and (IsNull(dmontamt) or dmontamt = 0 ) then continue
	 
	 if ls_gubun = '1' then  //���޿�	
   	dw_main.SetItem(i,"monthamt",ld_mamt)
	 elseif ls_gubun = '2' then  //�⺻��	
	 	dw_main.SetItem(i,"basepay",ld_sudang)
	 elseif ls_gubun = '3' then  //��
	 	dw_main.SetItem(i,"bonus",ld_sudang)
	 elseif ls_gubun = '4' then  //��å	
	 	dw_main.SetItem(i,"sudang1",ld_sudang)
	 elseif ls_gubun = '5' then  //����	
	 	dw_main.SetItem(i,"sudang2",ld_sudang)
	 elseif ls_gubun = '6' then  //�ޱ�	
	 	dw_main.SetItem(i,"sudang3",ld_sudang)
	 elseif ls_gubun = '7' then  //�߰�	
	 	dw_main.SetItem(i,"sudang4",ld_sudang)
	 elseif ls_gubun = '8' then  //����	
	 	dw_main.SetItem(i,"sudang5",ld_sudang)
    elseif ls_gubun = '9' then  //����	
	 	dw_main.SetItem(i,"sudang6",ld_sudang)	 
    end if	 
	  
	
Next








end event

event itemchanged;if this.GetColumnName() = "yymm" then
	is_yymm = this.Gettext()
end if
end event

type dw_main from u_d_popup_sort within w_pip1001_add
integer x = 27
integer y = 284
integer width = 4567
integer height = 1984
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_pip1001_add_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event itemchanged;call super::itemchanged;Int     il_currow,ikt, ikt2, ikt3
Double  dyearamt, dmontamt, dbase, dtimeamt, dbasepay, djuamt, dyjtime, dyktime
string ldeptname

//ikt = long(em_1.text)
//ikt2 = long(em_2.text)
//ikt3 = long(em_3.text)
//ikt = dw_1.GetitemNumber(1,'prate')
//
//if IsNull(ikt) or ikt = 0 then return
//
//il_currow = this.GetRow()

 this.Accepttext()
 IF this.GetColumnName() = "monthamt" THEN
 
	 dmontamt = this.GetitemNumber(row,'monthamt')
	 dyearamt = dmontamt * 12
	 dtimeamt  =  dyearamt / 2900.04
	 dbase = dtimeamt * 8 * 21.78 
	 djuamt = dtimeamt * 8 * 4.345 
	 dyjtime = dtimeamt * 1.5 * 21.78
	 
	 dtimeamt = round(dtimeamt,2)
	 dbase =  round(dbase,0)
	 djuamt = round(djuamt,0)
	 dyjtime = round(dyjtime,0)

	 this.SetItem(row,'timepay',dtimeamt)
	 this.SetItem(row,'basepay',dbase)
	 this.SetItem(row,'yearamt',dyearamt)
	 this.SetItem(row,'sudang1',djuamt)
	 this.SetItem(row,'sudang2',dyjtime)
END IF
IF this.GetColumnName() = "yearamt" THEN
	
	 dyearamt = this.GetitemNumber(row,'yearamt')
	 dtimeamt  = dyearamt / 2900.04 
	 dbase = dtimeamt * 8 * 21.78
	 djuamt = dtimeamt * 8 * 4.345
	 dyjtime = dtimeamt * 1.5 * 21.78
      dyktime = this.GetitemNumber(row,'sudang3')
		
	 dtimeamt = round(dtimeamt,2)
	 dbase =  round(dbase,0)
	 djuamt = round(djuamt,0)
	 dyjtime = round(dyjtime,0)

	 this.SetItem(row,'timepay',dtimeamt)
	 this.SetItem(row,'basepay',dbase)
	 this.SetItem(row,'monthamt',dbase + djuamt + dyjtime + dyktime)
	 this.SetItem(row,'sudang1',djuamt)
	 this.SetItem(row,'sudang2',dyjtime)
END IF

IF this.GetColumnName() = "timepay" THEN
 
	 dtimeamt = this.GetitemNumber(row,'timepay')
	 dbase = round(dtimeamt * 8 * 21.78 ,0)
	 djuamt = round(dtimeamt * 8 * 4.345 ,0)
	 dyjtime =  round(dtimeamt * 1.5 * 21.78 ,0)

	 this.SetItem(row,'timepay',dtimeamt)
	 this.SetItem(row,'basepay',dbase)
	 this.SetItem(row,'monthamt',dbase)
	 this.SetItem(row,'sudang1',djuamt)
	 this.SetItem(row,'sudang2',dyjtime)
END IF

IF this.GetColumnName() = "sudang3" THEN
 
	 dyktime = this.GetitemNumber(row,'sudang3')
	 dyjtime = this.GetitemNumber(row,'sudang2')
	 djuamt = this.GetitemNumber(row,'sudang1')
	 dbase = this.GetitemNumber(row,'basepay')
	 
	 this.SetItem(row,'monthamt',dbase + djuamt + dyjtime + dyktime)
END IF
end event

event editchanged;call super::editchanged;ib_any_typing =True


end event

event itemerror;call super::itemerror;return 1
end event

type cb_1 from commandbutton within w_pip1001_add
integer x = 2638
integer y = 48
integer width = 448
integer height = 108
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "Excel Upload"
end type

event clicked;Long   lValue
String sDocname
String sNamed

// ���� IMPORT ***************************************************************

lValue = GetFileOpenName("���� �ڷ� ��������", sDocname, sNamed, "XLS", "XLS Files (*.XLS),*.XLS,")
If lValue <> 1 Then Return -1

Setpointer(Hourglass!)

//===========================================================================================
//UserObject ����
uo_xlobject uo_xl

w_mdi_frame.sle_msg.text = "���� ���ε� �غ���..."
uo_xl = Create uo_xlobject

//������ ����
uo_xl.uf_excel_connect(sDocname, False, 3)
uo_xl.uf_selectsheet(1)

//Data ���� Row Setting (��)
//Excel ���� A: 1 , B :2 �� ���� 

Long   lXlrow
Long   lCnt
Long   lCount

lXlrow = 2		// ù��带 �����ϰ� �ι�°����� ����
lCnt = 2

Long   iNotNullCnt
Long   i
Long   ll_find
Long   ll_chk
Double ldb_year
Double ldb_mon
Double ldb_base
Double ldb_bonus
Double ldb_juamt
Double ldb_yjamt
String ls_emp
String ls_year
String ls_mon
String ls_base
String ls_bonus
String ls_ret
String ls_nam
String ls_juamt
String ls_yjamt

String ls_time
Double ldb_time

Do While(True)
	
	// ����� ID(A,1)
	// Data�� ���� ��� �ش��ϴ� �������� �����ؾ߸� ���ڰ� ������ ����....������ �𸣰���....
	// �� 36�� ���� ����
	For i =1 To 15
		uo_xl.uf_set_format(lXlrow, i, '@' + Space(50))
	Next
	
	iNotNullCnt = 0 //�Ʒ� ���� ������� ������ ����
	
	ls_emp   = Trim(uo_xl.uf_gettext(lXlrow, 2))  //���
	ls_time = Trim(uo_xl.uf_gettext(lXlrow, 4))  //�ñ�

	ls_base  = Trim(uo_xl.uf_gettext(lXlrow, 5))  //�⺻��	
	ls_bonus = Trim(uo_xl.uf_gettext(lXlrow, 6))  //��	
	ls_juamt = Trim(uo_xl.uf_gettext(lXlrow, 7))  //���޼���	
	ls_yjamt = Trim(uo_xl.uf_gettext(lXlrow,9))  //�������
	ls_mon   = Trim(uo_xl.uf_gettext(lXlrow, 10))  //���޿�		
	ls_year  = Trim(uo_xl.uf_gettext(lXlrow, 11))  //����




	 If Not IsNull(ls_emp) AND ls_emp >= '1000' AND Trim(ls_emp) <> '' Then
		iNotNullCnt++
		
		/* ��� ��Ͽ��� �� �������� */
		SELECT COUNT('X'), MAX(RETIREDATE), MAX(EMPNAME)
		  INTO :ll_chk   , :ls_ret        , :ls_nam
		  FROM P1_MASTER
		 WHERE EMPNO = :ls_emp ;
		If SQLCA.SQLCODE <> 0 OR IsNull(ll_chk) OR ll_chk = 0 Then
			MessageBox('�� ��� ���', '��� ' + ls_emp + '(��)�� ��ϵ� ����� �ƴմϴ�.')
			uo_xl.uf_excel_Disconnect()
			DESTROY uo_xl
			Return
		End If
		
		If Trim(ls_ret) <> '' OR Not IsNull(ls_ret) Then
			MessageBox('���� ���', '��� ' + ls_emp + '(��)�� ���� ó���� ����Դϴ�.')
			uo_xl.uf_excel_Disconnect()
			DESTROY uo_xl
			Return
		End If
		
		w_mdi_frame.sle_msg.text = "���� ���ε� ���� ��.. (" + String(lCnt) + "��) ..." + ls_emp + "  " + ls_nam
		lCount = lCnt
		
		If IsNull(ls_year)  Then ls_year  = '0'
		If IsNull(ls_mon)   Then ls_mon   = '0'
		If IsNull(ls_base)  Then ls_base  = '0'
		If IsNull(ls_bonus) Then ls_bonus = '0'
		If IsNull(ls_time) Then ls_time = '0'
		If IsNull(ls_juamt) Then ls_juamt = '0'
		If IsNull(ls_yjamt) Then ls_yjamt = '0'
		
		ldb_year  = Double(ls_year)
		ldb_mon   = Double(ls_mon)
		ldb_base  = Double(ls_base)
		ldb_bonus = Double(ls_bonus)
		ldb_time = Double(ls_time)
		ldb_juamt = Double(ls_juamt)
		ldb_yjamt = Double(ls_yjamt)		
		
		ll_find = dw_main.Find("p1_master_empno = '" + ls_emp + "'", 1, dw_main.RowCount())
		
		If ll_find > 0 Then
			dw_main.SetItem(ll_find, 'yearamt' , ldb_year )  //����
			dw_main.SetItem(ll_find, 'monthamt', ldb_mon  )  //���޿�
			dw_main.SetItem(ll_find, 'basepay' , ldb_base )  //�⺻��
			dw_main.SetItem(ll_find, 'bonus'   , ldb_bonus)  //��
			dw_main.SetItem(ll_find, 'timepay'   , ldb_time)  //�������ñ�
			dw_main.SetItem(ll_find, 'sudang1'   , ldb_juamt)  //���޼���
			dw_main.SetItem(ll_find, 'sudang2'   , ldb_yjamt)  //�������
		End If
		
		lCnt++
	End If
		
	// �ش� ���� � ������ ���� �������� �ʾҴٸ� ���� ������ �ν��ؼ� ����Ʈ ����
	If iNotNullCnt = 0 Then 
		lCount = lCount -1 
		Exit
	end if
	
	lXlrow ++
Loop
uo_xl.uf_excel_Disconnect()


//// ���� IMPORT  END ***************************************************************
dw_insert.AcceptText()

MessageBox('Ȯ��', String(lCount) +' ���� �����ڷḦ ���������� Import �Ͽ����ϴ�.')
w_mdi_frame.sle_msg.text = ""
DESTROY uo_xl
end event

type st_2 from statictext within w_pip1001_add
integer x = 3662
integer y = 184
integer width = 891
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 16711680
long backcolor = 32106727
string text = "Excel Upload Sample��� ����"
boolean focusrectangle = false
end type

event clicked;p_1.Visible = True
end event

type p_1 from picture within w_pip1001_add
boolean visible = false
integer x = 3099
integer y = 36
integer width = 544
integer height = 208
boolean bringtotop = true
string pointer = "HyperLink!"
boolean originalsize = true
string picturename = "C:\erpman\image\smp_pip1001_add.JPG"
boolean border = true
boolean focusrectangle = false
string powertiptext = "�̹����� Ŭ���ϸ� ȭ���� �����ϴ�."
end type

event clicked;p_1.Visible = False
end event

type rr_2 from roundrectangle within w_pip1001_add
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 23
integer y = 272
integer width = 4585
integer height = 2008
integer cornerheight = 40
integer cornerwidth = 55
end type

