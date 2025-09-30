$PBExportHeader$w_psd1190.srw
$PBExportComments$��������������
forward
global type w_psd1190 from w_inherite_standard
end type
type dw_ip from datawindow within w_psd1190
end type
type dw_list from datawindow within w_psd1190
end type
type dw_detail from datawindow within w_psd1190
end type
type cb_1 from commandbutton within w_psd1190
end type
type rr_1 from roundrectangle within w_psd1190
end type
type rr_2 from roundrectangle within w_psd1190
end type
type rr_3 from roundrectangle within w_psd1190
end type
end forward

global type w_psd1190 from w_inherite_standard
integer height = 2464
string title = "��������������"
dw_ip dw_ip
dw_list dw_list
dw_detail dw_detail
cb_1 cb_1
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
end type
global w_psd1190 w_psd1190

on w_psd1190.create
int iCurrent
call super::create
this.dw_ip=create dw_ip
this.dw_list=create dw_list
this.dw_detail=create dw_detail
this.cb_1=create cb_1
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_ip
this.Control[iCurrent+2]=this.dw_list
this.Control[iCurrent+3]=this.dw_detail
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.rr_1
this.Control[iCurrent+6]=this.rr_2
this.Control[iCurrent+7]=this.rr_3
end on

on w_psd1190.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_ip)
destroy(this.dw_list)
destroy(this.dw_detail)
destroy(this.cb_1)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
end on

event open;dw_ip.settransobject(sqlca)
dw_list.settransobject(sqlca)
dw_detail.settransobject(sqlca)

dw_datetime.settransobject(sqlca)

dw_ip.insertrow(0)
dw_detail.insertrow(0)
dw_datetime.insertrow(0)

f_set_saupcd(dw_ip, 'saupcd', '1')
is_saupcd = gs_saupcd

dw_ip.setitem(1,"ym",left(f_today(),6))
dw_ip.setcolumn("ym")
dw_ip.setfocus()




end event

type p_mod from w_inherite_standard`p_mod within w_psd1190
integer x = 4046
integer y = 52
end type

event p_mod::clicked;call super::clicked;real s_uppnt1,s_uppnt2,s_tapont1,s_tapont2,s_capnt1,s_capnt2
real s_weight1, s_weight2, s_weight_tot,is_weight1,is_weight2
string is_yymm,is_empno,is_empname


if dw_detail.accepttext() = -1 then return -1

is_empname = dw_list.getitemstring(dw_list.getrow(),"p1_master_empname")

if messagebox('Ȯ��', is_empname + '���� ����� �����Ͻðڽ��ϱ�?', question!,yesno!) = 1 then

	setpointer(hourglass!)

	is_yymm = dw_ip.getitemstring(1,"ym")
	is_empno = dw_list.getitemstring(dw_list.getrow(),"p6_meritwork_empno")
	
	is_weight1 = dw_detail.getitemdecimal(1,"p6_meritweight_weight1")
	is_weight2 = dw_detail.getitemdecimal(1,"p6_meritweight_weight2")
	s_uppnt1 = dw_detail.getitemdecimal(1,"uppnt1")
	s_tapont1 = dw_detail.getitemdecimal(1,"tapont1")
	s_capnt1 = dw_detail.getitemdecimal(1,"capnt1")
	s_uppnt2 = dw_detail.getitemdecimal(1,"uppnt2")
	s_tapont2 = dw_detail.getitemdecimal(1,"tapont2")
	s_capnt2 = dw_detail.getitemdecimal(1,"capnt2")
	
	//�� 1�� ����ġ
	s_weight1 = ((s_uppnt1 + s_tapont1 + s_capnt1) * (is_weight1 / 100))	
	//�� 2�� ����ġ
	s_weight2 = ((s_uppnt2 + s_tapont2 + s_capnt2) * (is_weight2 / 100))
	//����ġ��������
	s_weight_tot = s_weight1 + s_weight2
	
	
	delete from p6_meritfinal where mryymm = :is_yymm ;
	delete from p6_meritwork2 where mryymm = :is_yymm ;
	
	update "P6_MERITWORK" 
	set 	"UPPNT1" = :s_uppnt1, 
			"UPPNT2" = :s_uppnt2, 
			"TAPONT1" = :s_tapont1, 
			"TAPONT2" = :s_tapont1, 
			"CAPNT1" = :s_capnt1, 
			"CAPNT2" = :s_capnt2,	
			"WEIGHT1" = :s_weight1, 
			"WEIGHT2" = :s_weight2, 
			"WEIGHTPNT" = :s_weight_tot, 
			"ADJUST" = 0, "ADJPNT" = 0 

	where "MRYYMM" = :is_yymm and "EMPNO" = :is_empno ;
	
	
end if

w_mdi_frame.sle_msg.text = "�����Ǿ����ϴ�"
end event

type p_del from w_inherite_standard`p_del within w_psd1190
integer x = 2949
integer y = 2620
end type

type p_inq from w_inherite_standard`p_inq within w_psd1190
integer x = 3867
integer y = 52
end type

event p_inq::clicked;call super::clicked;string li_ym, li_deptcd, saupcd

if dw_ip.accepttext() = -1 then return -1

li_ym = dw_ip.getitemstring(1,"ym")
li_deptcd = dw_ip.getitemstring(1,"deptcode")
saupcd = dw_ip.GetItemString(1,"saupcd")

if li_deptcd = "" or isnull(li_deptcd) then li_deptcd = '%'
if saupcd = ""  or  isnull(saupcd) then	saupcd = '%'

if li_ym = "" or isnull(li_ym) then 
	messagebox('Ȯ��','�������� Ȯ���ϼ���')
	dw_ip.setcolumn("ym")
	dw_ip.setfocus()
	return -1

elseif f_datechk(li_ym + "01") = -1 then
	messagebox('Ȯ��','�������� Ȯ���ϼ���')
	dw_ip.setcolumn("ym")
	dw_ip.setfocus()
	return -1

end if

if dw_list.retrieve(li_deptcd, li_ym, saupcd) < 1 then 
	messagebox('Ȯ��','�ڷᰡ �����ϴ�')
	dw_ip.setcolumn("deptcode")
	dw_ip.setfocus()
	return -1	
end if

return 1

end event

type p_print from w_inherite_standard`p_print within w_psd1190
integer x = 3209
integer y = 2768
string picturename = "C:\erpman\image\�������_up.gif"
end type

type p_can from w_inherite_standard`p_can within w_psd1190
integer x = 4224
integer y = 52
end type

event p_can::clicked;call super::clicked;
dw_detail.reset()
dw_list.reset()

dw_ip.insertrow(0)
dw_detail.insertrow(0)

dw_ip.setitem(1,"ym",left(f_today(),6))
dw_ip.setcolumn("ym")
dw_ip.setfocus()



end event

type p_exit from w_inherite_standard`p_exit within w_psd1190
integer x = 4398
integer y = 52
end type

type p_ins from w_inherite_standard`p_ins within w_psd1190
integer x = 2752
integer y = 2584
end type

type p_search from w_inherite_standard`p_search within w_psd1190
integer x = 3657
integer y = 2672
end type

type p_addrow from w_inherite_standard`p_addrow within w_psd1190
integer x = 864
integer y = 2620
end type

type p_delrow from w_inherite_standard`p_delrow within w_psd1190
integer x = 1038
integer y = 2620
end type

type dw_insert from w_inherite_standard`dw_insert within w_psd1190
integer x = 2107
integer y = 2600
end type

type st_window from w_inherite_standard`st_window within w_psd1190
integer x = 1426
integer y = 2444
integer width = 599
long backcolor = 80269524
end type

type cb_exit from w_inherite_standard`cb_exit within w_psd1190
integer x = 4375
end type

type cb_update from w_inherite_standard`cb_update within w_psd1190
integer x = 265
integer y = 2712
integer width = 562
string text = "�������(&I)"
end type

event cb_update::clicked;call super::clicked;string is_yymm

if dw_detail.accepttext() = -1 then return -1

if messagebox('Ȯ��','����� �ٽ� ����Ͻðڽ��ϱ�?', question!,yesno!) = 1 then

	setpointer(hourglass!)
	
	is_yymm = dw_ip.getitemstring(1,"ym")

				
	/*������� ��뺯��*/
	real  is_tot_wepnt,is_tot_cnt,is_tot_avg,is_team_wepnt,is_team_cnt,is_team_avg,is_per_wepnt
	real is_adjust_tmp,is_adjust_tot
		
	string	is_team_dept,is_per_empno,is_per_deptcd,is_ym,is_teamcd
		
	/* �Ҽ����� ����ġ�������� �հ踦 ���ϱ� ���� ������ (��������) */
	DECLARE cur_team_tmp CURSOR FOR
	
		select a.dept_cd,
				count(*) as cnt_empno,
				sum(a.weightpnt) as wepnt_hap
		from
			(select distinct p6_meritwork.empno, 
					p6_meritwork.weightpnt,
					p6_meritgrade.dept_cd,
					p1_master.jobkindcode
			from 	p6_meritwork,
					p6_meritgrade,
					p1_master
			where	p6_meritwork.empno = p6_meritgrade.empno and
					p6_meritwork.empno = p1_master.empno and
					p1_master.jobkindcode <> trim(:is_teamcd) and
					p6_meritwork.mryymm = :is_yymm ) a
		group by a.dept_cd ;
	
				
	/* ���κ� ����ġ */
	DECLARE cur_meritwork CURSOR FOR 
	
		select distinct p6_meritwork.empno, 
					p6_meritwork.weightpnt,
					p6_meritgrade.dept_cd,
					p6_meritwork.mryymm
		from 	p6_meritwork,
				p6_meritgrade,
				p1_master
		where	p6_meritwork.empno = p6_meritgrade.empno and
				p6_meritwork.empno = p1_master.empno and
				p6_meritwork.mryymm = :is_yymm and
				p6_meritgrade.dept_cd = :is_team_dept;
		
		

	/* ���� �ڵ� ���ϱ� */		
	select dataname into :is_teamcd
	from p0_syscnfg
	where sysgu = 'P' and  serial = '60' and lineno <> '00' and datagu is not null ;		
				
	/* ��ü ����ġ�������� �հ踦 ���ϱ� ���� ������ (��������)*/
	select count(*) as cnt_empno,
		sum(a.weightpnt) as wepnt_hap
	into :is_tot_cnt, :is_tot_wepnt
	from
		(select distinct p6_meritwork.empno, 
			p6_meritwork.weightpnt,
			p1_master.jobkindcode
	from 	p6_meritwork,
			p6_meritgrade,
			p1_master
	where	p6_meritwork.empno = p6_meritgrade.empno and
			p6_meritwork.empno = p1_master.empno and
			p1_master.jobkindcode <> TRIM(:is_teamcd) and
			p6_meritwork.mryymm = :is_yymm) a ;
			
	/* ��ü ����ġ�������� �հ迡 ���� ���� ���Ѵ�*/		
	is_tot_avg = round( is_tot_wepnt / is_tot_cnt ,0)
	
	open cur_team_tmp ;
	do while true
		fetch cur_team_tmp into :is_team_dept, :is_team_cnt, :is_team_wepnt;
		
		if sqlca.sqlcode = 0 then
			
			/* �Ҽ����� ����ġ�������� �հ迡 ���� ���� ���Ѵ�*/
			is_team_avg = round( is_team_wepnt / is_team_cnt ,0)
							
			/* �Ҽ����� ������ ������� �� = ��ü ����ġ�������� ��� / �Ҽ��� ����ġ�������� ���  */
			is_adjust_tmp = is_tot_avg / is_team_avg 


				open cur_meritwork;
				do while true
					fetch cur_meritwork into :is_per_empno, :is_per_wepnt, :is_per_deptcd, :is_ym;
											
					/* ������������� = ���κ� ����ġ ���� * ������� */
					is_adjust_tot = is_per_wepnt * is_adjust_tmp 
					
					/* p6_meritwork �� ������Ʈ�Ѵ�*/
					if sqlca.sqlcode = 0 then
						update p6_meritwork set adjust = :is_adjust_tmp, adjpnt = :is_adjust_tot
						where mryymm = :is_ym and empno = :is_per_empno ;
					else
						exit
					end if

				loop ;			
									
					/* p6_meritwork2 �� �μ�Ʈ�Ѵ�*/
					insert into "P6_MERITWORK2" ("MRYYMM", "DEPT_CD", "DEPT_AVG", "TOTAL_AVG", "ADJUST" )
					VALUES ( :is_ym, :is_per_deptcd, :is_team_avg, :is_tot_avg, :is_adjust_tmp ) ;	

				close cur_meritwork ;
				
		else
			exit
		end if
	loop ;
	close cur_team_tmp ;	
end if


string is_final_mryymm,	is_final_empno,is_final_deptcd
real is_final_adjpnt	,is_final_gagam
	
/* p6_meritfinal �� �μ�Ʈ�� �ڷḦ ����Ʈ�Ѵ� */
declare cur_meritfinal cursor for
		
	select p6_meritwork.mryymm,
			p6_meritwork.empno,
			p6_meritwork.adjpnt,
			0 as gagam,
			p1_master.deptcode
	from 	p6_meritwork, p1_master
	where	p6_meritwork.empno = p1_master.empno and
			p6_meritwork.mryymm = :is_yymm  ;
				

/* p6_meritfinal �� �μ�Ʈ�Ѵ�.*/		
open cur_meritfinal ;
do while true 
	fetch cur_meritfinal into :is_final_mryymm,:is_final_empno,:is_final_adjpnt,:is_final_gagam, :is_final_deptcd	;
		
		if sqlca.sqlcode = 0 then
			insert into "P6_MERITFINAL" ("MRYYMM", "EMPNO", "MRPOINT", "ASPOINT", "DEPT_CD")
			VALUES ( :is_final_mryymm, :is_final_empno, :is_final_adjpnt, :is_final_gagam, :is_final_deptcd) ;	
		else
			exit
		end if
			
LOOP;
close cur_meritfinal ;

if sqlca.sqlcode = 0 then
	commit;
else
	rollback;
	messagebox('Ȯ��','��� ���� ����')
	return -1
end if

setpointer(arrow!)
sle_msg.text = "��� ���� ����"
		
	
				
end event

type cb_insert from w_inherite_standard`cb_insert within w_psd1190
integer x = 1125
integer y = 2804
integer width = 357
string text = "����(&S)"
end type

event cb_insert::clicked;call super::clicked;real s_uppnt1,s_uppnt2,s_tapont1,s_tapont2,s_capnt1,s_capnt2
real s_weight1, s_weight2, s_weight_tot,is_weight1,is_weight2
string is_yymm,is_empno,is_empname


if dw_detail.accepttext() = -1 then return -1

is_empname = dw_list.getitemstring(dw_list.getrow(),"p1_master_empname")

if messagebox('Ȯ��', is_empname + '���� ����� �����Ͻðڽ��ϱ�?', question!,yesno!) = 1 then

	setpointer(hourglass!)

	is_yymm = dw_ip.getitemstring(1,"ym")
	is_empno = dw_list.getitemstring(dw_list.getrow(),"p6_meritwork_empno")
	
	is_weight1 = dw_detail.getitemdecimal(1,"p6_meritweight_weight1")
	is_weight2 = dw_detail.getitemdecimal(1,"p6_meritweight_weight2")
	s_uppnt1 = dw_detail.getitemdecimal(1,"uppnt1")
	s_tapont1 = dw_detail.getitemdecimal(1,"tapont1")
	s_capnt1 = dw_detail.getitemdecimal(1,"capnt1")
	s_uppnt2 = dw_detail.getitemdecimal(1,"uppnt2")
	s_tapont2 = dw_detail.getitemdecimal(1,"tapont2")
	s_capnt2 = dw_detail.getitemdecimal(1,"capnt2")
	
	//�� 1�� ����ġ
	s_weight1 = ((s_uppnt1 + s_tapont1 + s_capnt1) * (is_weight1 / 100))	
	//�� 2�� ����ġ
	s_weight2 = ((s_uppnt2 + s_tapont2 + s_capnt2) * (is_weight2 / 100))
	//����ġ��������
	s_weight_tot = s_weight1 + s_weight2
	
	
	delete from p6_meritfinal where mryymm = :is_yymm ;
	delete from p6_meritwork2 where mryymm = :is_yymm ;
	
	update "P6_MERITWORK" 
	set 	"UPPNT1" = :s_uppnt1, 
			"UPPNT2" = :s_uppnt2, 
			"TAPONT1" = :s_tapont1, 
			"TAPONT2" = :s_tapont1, 
			"CAPNT1" = :s_capnt1, 
			"CAPNT2" = :s_capnt2,	
			"WEIGHT1" = :s_weight1, 
			"WEIGHT2" = :s_weight2, 
			"WEIGHTPNT" = :s_weight_tot, 
			"ADJUST" = 0, "ADJPNT" = 0 

	where "MRYYMM" = :is_yymm and "EMPNO" = :is_empno ;
	
	
end if

sle_msg.text = "�����Ǿ����ϴ�"
end event

type cb_delete from w_inherite_standard`cb_delete within w_psd1190
integer x = 1367
integer y = 2564
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_psd1190
integer x = 946
integer y = 2788
end type

event cb_retrieve::clicked;call super::clicked;string li_ym, li_deptcd

if dw_ip.accepttext() = -1 then return -1

li_ym = dw_ip.getitemstring(1,"ym")
li_deptcd = dw_ip.getitemstring(1,"deptcode")

if li_deptcd = "" or isnull(li_deptcd) then li_deptcd = '%'

if li_ym = "" or isnull(li_ym) then 
	messagebox('Ȯ��','�������� Ȯ���ϼ���')
	dw_ip.setcolumn("ym")
	dw_ip.setfocus()
	return -1

elseif f_datechk(li_ym + "01") = -1 then
	messagebox('Ȯ��','�������� Ȯ���ϼ���')
	dw_ip.setcolumn("ym")
	dw_ip.setfocus()
	return -1

end if

if dw_list.retrieve(li_deptcd, li_ym) < 1 then 
	messagebox('Ȯ��','�ڷᰡ �����ϴ�')
	dw_ip.setcolumn("deptcode")
	dw_ip.setfocus()
	return -1	
end if

return 1

end event

type st_1 from w_inherite_standard`st_1 within w_psd1190
integer x = 0
integer y = 2444
long backcolor = 80269524
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_psd1190
integer x = 1531
integer y = 2816
end type

event clicked;call super::clicked;
dw_detail.reset()
dw_list.reset()

dw_ip.insertrow(0)
dw_detail.insertrow(0)

dw_ip.setitem(1,"ym",left(f_today(),6))
dw_ip.setcolumn("ym")
dw_ip.setfocus()



end event

type dw_datetime from w_inherite_standard`dw_datetime within w_psd1190
integer x = 2798
integer y = 2432
end type

type sle_msg from w_inherite_standard`sle_msg within w_psd1190
integer x = 411
integer y = 2444
long backcolor = 80269524
end type

type gb_2 from w_inherite_standard`gb_2 within w_psd1190
integer x = 1371
integer y = 2400
integer width = 1778
long backcolor = 80269524
end type

type gb_1 from w_inherite_standard`gb_1 within w_psd1190
integer x = 379
integer y = 2408
integer width = 421
long backcolor = 80269524
end type

type gb_10 from w_inherite_standard`gb_10 within w_psd1190
integer x = 3456
integer y = 2400
integer width = 3552
long backcolor = 80269524
end type

type dw_ip from datawindow within w_psd1190
integer x = 91
integer y = 72
integer width = 2615
integer height = 144
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_psd1190_dept"
boolean border = false
boolean livescroll = true
end type

type dw_list from datawindow within w_psd1190
integer x = 283
integer y = 412
integer width = 1134
integer height = 1484
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_psd1190_list"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;string li_empno, li_ym,li_empna

dw_list.accepttext() 

if row <= 0 then return -1
	
	dw_list.selectrow(0,false)
	dw_list.selectrow(row,true)
	

li_ym = dw_ip.getitemstring(1,"ym")
li_empno = dw_list.getitemstring(row, "p6_meritwork_empno")

dw_detail.retrieve(li_ym, li_empno)
end event

type dw_detail from datawindow within w_psd1190
event ue_enter pbm_dwnprocessenter
integer x = 1605
integer y = 448
integer width = 1591
integer height = 1264
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_psd1190_detail"
boolean border = false
boolean livescroll = true
end type

event ue_enter;send(handle(this),256,9,0)
return 1
end event

type cb_1 from commandbutton within w_psd1190
integer x = 3867
integer y = 224
integer width = 512
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "�������"
end type

event clicked;string is_yymm

if dw_detail.accepttext() = -1 then return -1

if messagebox('Ȯ��','����� �ٽ� ����Ͻðڽ��ϱ�?', question!,yesno!) = 1 then

	setpointer(hourglass!)
	
	is_yymm = dw_ip.getitemstring(1,"ym")

				
	/*������� ��뺯��*/
	real  is_tot_wepnt,is_tot_cnt,is_tot_avg,is_team_wepnt,is_team_cnt,is_team_avg,is_per_wepnt
	real is_adjust_tmp,is_adjust_tot
		
	string	is_team_dept,is_per_empno,is_per_deptcd,is_ym,is_teamcd
		
	/* �Ҽ����� ����ġ�������� �հ踦 ���ϱ� ���� ������ (��������) */
	DECLARE cur_team_tmp CURSOR FOR
	
		select a.dept_cd,
				count(*) as cnt_empno,
				sum(a.weightpnt) as wepnt_hap
		from
			(select distinct p6_meritwork.empno, 
					p6_meritwork.weightpnt,
					p6_meritgrade.dept_cd,
					p1_master.jobkindcode
			from 	p6_meritwork,
					p6_meritgrade,
					p1_master
			where	p6_meritwork.empno = p6_meritgrade.empno and
					p6_meritwork.empno = p1_master.empno and
					p1_master.jobkindcode <> trim(:is_teamcd) and
					p6_meritwork.mryymm = :is_yymm ) a
		group by a.dept_cd ;
	
				
	/* ���κ� ����ġ */
	DECLARE cur_meritwork CURSOR FOR 
	
		select distinct p6_meritwork.empno, 
					p6_meritwork.weightpnt,
					p6_meritgrade.dept_cd,
					p6_meritwork.mryymm
		from 	p6_meritwork,
				p6_meritgrade,
				p1_master
		where	p6_meritwork.empno = p6_meritgrade.empno and
				p6_meritwork.empno = p1_master.empno and
				p6_meritwork.mryymm = :is_yymm and
				p6_meritgrade.dept_cd = :is_team_dept;
		
		

	/* ���� �ڵ� ���ϱ� */		
	select dataname into :is_teamcd
	from p0_syscnfg
	where sysgu = 'P' and  serial = '60' and lineno <> '00' and datagu is not null ;		
				
	/* ��ü ����ġ�������� �հ踦 ���ϱ� ���� ������ (��������)*/
	select count(*) as cnt_empno,
		sum(a.weightpnt) as wepnt_hap
	into :is_tot_cnt, :is_tot_wepnt
	from
		(select distinct p6_meritwork.empno, 
			p6_meritwork.weightpnt,
			p1_master.jobkindcode
	from 	p6_meritwork,
			p6_meritgrade,
			p1_master
	where	p6_meritwork.empno = p6_meritgrade.empno and
			p6_meritwork.empno = p1_master.empno and
			p1_master.jobkindcode <> TRIM(:is_teamcd) and
			p6_meritwork.mryymm = :is_yymm) a ;
			
	/* ��ü ����ġ�������� �հ迡 ���� ���� ���Ѵ�*/		
	is_tot_avg = round( is_tot_wepnt / is_tot_cnt ,0)
	
	open cur_team_tmp ;
	do while true
		fetch cur_team_tmp into :is_team_dept, :is_team_cnt, :is_team_wepnt;
		
		if sqlca.sqlcode = 0 then
			
			/* �Ҽ����� ����ġ�������� �հ迡 ���� ���� ���Ѵ�*/
			is_team_avg = round( is_team_wepnt / is_team_cnt ,0)
							
			/* �Ҽ����� ������ ������� �� = ��ü ����ġ�������� ��� / �Ҽ��� ����ġ�������� ���  */
			is_adjust_tmp = is_tot_avg / is_team_avg 


				open cur_meritwork;
				do while true
					fetch cur_meritwork into :is_per_empno, :is_per_wepnt, :is_per_deptcd, :is_ym;
											
					/* ������������� = ���κ� ����ġ ���� * ������� */
					is_adjust_tot = is_per_wepnt * is_adjust_tmp 
					
					/* p6_meritwork �� ������Ʈ�Ѵ�*/
					if sqlca.sqlcode = 0 then
						update p6_meritwork set adjust = :is_adjust_tmp, adjpnt = :is_adjust_tot
						where mryymm = :is_ym and empno = :is_per_empno ;
					else
						exit
					end if

				loop ;			
									
					/* p6_meritwork2 �� �μ�Ʈ�Ѵ�*/
					insert into "P6_MERITWORK2" ("MRYYMM", "DEPT_CD", "DEPT_AVG", "TOTAL_AVG", "ADJUST" )
					VALUES ( :is_ym, :is_per_deptcd, :is_team_avg, :is_tot_avg, :is_adjust_tmp ) ;	

				close cur_meritwork ;
				
		else
			exit
		end if
	loop ;
	close cur_team_tmp ;	
end if


string is_final_mryymm,	is_final_empno,is_final_deptcd
real is_final_adjpnt	,is_final_gagam
	
/* p6_meritfinal �� �μ�Ʈ�� �ڷḦ ����Ʈ�Ѵ� */
declare cur_meritfinal cursor for
		
	select p6_meritwork.mryymm,
			p6_meritwork.empno,
			p6_meritwork.adjpnt,
			0 as gagam,
			p1_master.deptcode
	from 	p6_meritwork, p1_master
	where	p6_meritwork.empno = p1_master.empno and
			p6_meritwork.mryymm = :is_yymm  ;
				

/* p6_meritfinal �� �μ�Ʈ�Ѵ�.*/		
open cur_meritfinal ;
do while true 
	fetch cur_meritfinal into :is_final_mryymm,:is_final_empno,:is_final_adjpnt,:is_final_gagam, :is_final_deptcd	;
		
		if sqlca.sqlcode = 0 then
			insert into "P6_MERITFINAL" ("MRYYMM", "EMPNO", "MRPOINT", "ASPOINT", "DEPT_CD")
			VALUES ( :is_final_mryymm, :is_final_empno, :is_final_adjpnt, :is_final_gagam, :is_final_deptcd) ;	
		else
			exit
		end if
			
LOOP;
close cur_meritfinal ;

if sqlca.sqlcode = 0 then
	commit;
else
	rollback;
	messagebox('Ȯ��','��� ���� ����')
	return -1
end if

setpointer(arrow!)
w_mdi_frame.sle_msg.text = "��� ���� ����"
		
	
				
end event

type rr_1 from roundrectangle within w_psd1190
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 41
integer y = 16
integer width = 3735
integer height = 288
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_psd1190
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 32
integer y = 332
integer width = 1458
integer height = 1908
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_psd1190
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 1522
integer y = 336
integer width = 2994
integer height = 1908
integer cornerheight = 40
integer cornerwidth = 55
end type

