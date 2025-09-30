$PBExportHeader$wp_pip3002.srw
$PBExportComments$** 갑근세 / 주민세납부서
forward
global type wp_pip3002 from w_standard_print
end type
type rr_1 from roundrectangle within wp_pip3002
end type
end forward

global type wp_pip3002 from w_standard_print
integer width = 4663
string title = "갑근세 / 주민세 납부서"
rr_1 rr_1
end type
global wp_pip3002 wp_pip3002

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();Long ToTalRow,I
String sDate,sDate2, sgbn,sgjno, tgbn
string S_Resno,S_SANAME,S_SAUPNO,S_PRESIDENT,S_ZIP,	S_ADDR,S_DDD, sabu
String l_Ym,l_Date,s_Saup,ls_tel,syymm, gigwan, sbank,s_resdient, ls_scode
Long l_Amt,l_SeAmt,l_Cnt,tjincometax, tjresidnettax, l_inwon, l_inwon_r
double ld_area, ld_freearea, ld_gwarea

dw_ip.AcceptText()

dw_print.ReSet()
dw_print.InsertRow(0)

SetPointer(HourGlass!)

sgbn   = dw_ip.GetItemString(1,"gubun")
syymm  = dw_ip.GetItemString(1,"yymm")
sDate  = dw_ip.GetItemString(1,"sdate")
sDate2  = dw_ip.GetItemString(1,"sdate2")
s_Saup = dw_ip.GetItemString(1,"saupj")
gigwan = dw_ip.GetItemString(1,"name5")
sbank  = dw_ip.GetItemString(1,"name6")
sgjno  = dw_ip.GetItemString(1,"name7")
tgbn = dw_ip.GetItemString(1,"gbn")



IF syymm = '' OR ISNULL(syymm) THEN
	MessageBox("확인","r기준년월을 입력하세요!")
	dw_ip.SetColumn("yymm")
	dw_ip.SetFocus()
	Return -1
END IF	

IF sDate = '' OR ISNULL(sDate) THEN
	MessageBox("확인","제출일을 입력하세요!")
	dw_ip.SetColumn("sDate")
	dw_ip.SetFocus()
	Return -1
END IF	

IF s_Saup = '' OR ISNULL(s_Saup) THEN
//	MessageBox("확인","사업장을 입력하십시요!")
//	dw_ip.setcolumn('saup')
//	dw_ip.setfocus()
//	return -1
// s_saup = '10'
	sabu = '%'
else
	sabu = s_saup
END IF	


// select lawno, cvnas, sano,   ownam, posno,  addr1||addr2 , telddd||telno1||telno2, resident 
//  into :S_Resno,:S_SANAME,:S_SAUPNO,:S_PRESIDENT,:S_ZIP,	:S_ADDR,:S_DDD	 , :s_resdient
//  from vndmst 
// where cvcod = (select codenm from p0_ref where codegbn = 'AD' and code = :s_Saup );

if dw_print.retrieve(gs_company, s_Saup) < 1 then
	messagebox("확인","조회할 자료가 없습니다")
	dw_print.insertrow(0)
end if

SELECT to_number("P0_SYSCNFG"."DATANAME")								
  INTO :ls_scode
  FROM "P0_SYSCNFG"
 WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 32 ) AND ( "P0_SYSCNFG"."LINENO" = :sabu )   ;
		 
IF sabu = '20' or sabu = '40' THEN
	select sum(a.allowamt201) as incometax//, count(a.empno) as inwon1        /*소득세*/
		INTO :l_Amt
		from p3_editdata a,  p1_master p, p0_dept d
		where a.empno = p.empno and
				p.deptcode = d.deptcode and
				d.saupcd IN ('20', '40') and			
				a.workym  = :syymm ;
				
		select sum(a.allowamt202) as residenttax, count(a.empno) as inwon      /*주민세*/
		INTO :l_SeAmt, :l_inwon
		from p3_editdata a,  p1_master p, p0_dept d
		where a.empno = p.empno and
				p.deptcode = d.deptcode and
				d.saupcd IN ('20', '40') and
				a.workym  = :syymm ;		
	
ELSE
	select sum(a.allowamt201) as incometax//, count(a.empno) as inwon1        /*소득세*/
		INTO :l_Amt
		from p3_editdata a,  p1_master p, p0_dept d
		where a.empno = p.empno and
				p.deptcode = d.deptcode and
				d.saupcd like :sabu and			
				a.workym  = :syymm ;
				
		select sum(a.allowamt202) as residenttax, count(a.empno) as inwon      /*주민세*/
		INTO :l_SeAmt, :l_inwon
		from p3_editdata a,  p1_master p, p0_dept d
		where a.empno = p.empno and
				p.deptcode = d.deptcode and
				d.saupcd like :sabu and
				a.workym  = :syymm ;		
END IF

	if sqlca.sqlcode <> 0  then
		l_amt = 0
		l_seamt = 0
	end if		 
		 
		 
IF sabu = '20' or sabu = '40' THEN
	select sum(balanceincometax), sum(balanceresidenttax), count(a.empno) as inwon
	into :tjincometax, :tjresidnettax, :l_inwon_r
	from p3_retirementpay a, p1_master p, p0_dept d
	where a.empno = p.empno and
			p.deptcode = d.deptcode and
			d.saupcd IN ('20','40') and
			substr(a.todate,1,6) = :syymm ;
ELSE
	select sum(balanceincometax), sum(balanceresidenttax), count(a.empno) as inwon
	into :tjincometax, :tjresidnettax, :l_inwon_r
	from p3_retirementpay a, p1_master p, p0_dept d
	where a.empno = p.empno and
			p.deptcode = d.deptcode and
			d.saupcd like :sabu and
			substr(a.todate,1,6) = :syymm ;
END IF

if IsNull(tjincometax) then tjincometax = 0
if IsNull(tjresidnettax) then tjresidnettax = 0



if sgbn = '1' or sgbn = '3' then               /*근로소득*/

	if sgbn = '1' then	                       /*소득세*/		
	   dw_print.Setitem(1,'syear',left(syymm,4))
	   dw_print.Setitem(1,'smm',right(syymm,2))
		dw_print.Setitem(1,'sgubun','4')
		dw_print.Setitem(1,'semok','14')
		dw_print.Setitem(1,'sdate',sdate)
		dw_print.Setitem(1,'nabudate',sdate2)
		dw_print.Setitem(1,'semuseo',gigwan)
		dw_print.Setitem(1,'gjno',sgjno)
		dw_print.Setitem(1,'sbank',sbank)
		dw_print.SetITem(1,"svat",l_Amt)     
		if tgbn = 'Y' then
			dw_print.Setitem(1,'pamt',tjincometax)
		end if
		dw_print.modify("t_sc.text ='" + ls_scode + "'")
	else 		                                    /*주민세*/		  
		dw_print.Setitem(1,'syear',left(syymm,4))
	   dw_print.Setitem(1,'smm',right(syymm,2))
		dw_print.Setitem(1,'sdate',sdate)
		dw_print.Setitem(1,'nabudate', sdate2)	
		dw_print.SetITem(1,"pamt",l_Amt)               /*소득세*/ 
		dw_print.SetITem(1,"svat",l_SeAmt)             /*주민세*/	
//		dw_print.Setitem(1,'ownam',s_president)		
		dw_print.Setitem(1,'gigwan',sbank)
//		dw_print.Setitem(1,'resident',s_resdient)
		dw_print.Setitem(1,'jh','Y')
		dw_print.SetItem(1, 'inwon', l_inwon)
		dw_print.Setitem(1,'semuseo',gigwan)
		if tgbn = 'Y' then
			dw_print.Setitem(1,'pamt',l_Amt)
			dw_print.SetItem(1, 'pamt_r', tjincometax)
			dw_print.Setitem(1,'svat',l_SeAmt)
			dw_print.Setitem(1,'svat',tjresidnettax)
			dw_print.Setitem(1,'tj','Y')
			dw_print.SetItem(1, 'inwon_r', l_inwon_r)
		end if
	end if
	
else                                                 /*퇴직소득*/
	
   if sgbn = '2' then	                       /*소득세*/		
	   dw_print.Setitem(1,'syear',left(syymm,4))
	   dw_print.Setitem(1,'smm',right(syymm,2))
		dw_print.Setitem(1,'sgubun','4')
		dw_print.Setitem(1,'semok','14')
		dw_print.Setitem(1,'sdate',sdate)
		dw_print.Setitem(1,'nabudate',sdate2)
		dw_print.Setitem(1,'semuseo',gigwan)
		dw_print.Setitem(1,'gjno',sgjno)
		dw_print.Setitem(1,'sbank',sbank)
		dw_print.SetITem(1,"pamt",tjincometax) 
		dw_print.modify("t_sc.text ='" + ls_scode + "'")
		
		
	else                                        /*주민세*/		  
		dw_print.Setitem(1,'syear',left(syymm,4))
	   dw_print.Setitem(1,'smm',right(syymm,2))
		dw_print.Setitem(1,'sdate',sdate)
		dw_print.Setitem(1,'napbudate', sdate2)	
		dw_print.SetITem(1,"pamt",tjincometax)               /*소득세*/ 
		dw_print.SetITem(1,"svat",tjresidnettax)             /*주민세*/	
//		dw_print.Setitem(1,'ownam',s_president)
		dw_print.Setitem(1,'gigwan',sbank)
//		dw_print.Setitem(1,'resdient',s_resdient)
		dw_print.Setitem(1,'semuseo',gigwan)
		dw_print.Setitem(1,'jh','Y')
		dw_print.Setitem(1,'tj','Y')
		dw_print.SetItem(1, 'inwon_r', l_inwon_r)
	
	end if
		

end if

Return 1
	  
end function

on wp_pip3002.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on wp_pip3002.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;
dw_ip.SetItem(1,"yymm",left(f_today(),6))
dw_ip.SetItem(1,'sdate',f_today())
dw_ip.Setcolumn('gubun')
dw_ip.Setfocus()

f_set_saupcd(dw_ip, 'saupj', '1')
is_saupcd = gs_saupcd

//dw_ip.object.t_5.visible = false
//dw_ip.object.name6.visible = false
end event

type p_preview from w_standard_print`p_preview within wp_pip3002
integer x = 4069
end type

type p_exit from w_standard_print`p_exit within wp_pip3002
integer x = 4416
end type

type p_print from w_standard_print`p_print within wp_pip3002
integer x = 4242
end type

type p_retrieve from w_standard_print`p_retrieve within wp_pip3002
integer x = 3895
end type







type st_10 from w_standard_print`st_10 within wp_pip3002
end type



type dw_print from w_standard_print`dw_print within wp_pip3002
boolean visible = true
integer x = 416
integer y = 372
integer width = 3698
integer height = 1824
string dataobject = "dp_pip3002_4_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

type dw_ip from w_standard_print`dw_ip within wp_pip3002
integer x = 398
integer y = 8
integer width = 2871
integer height = 348
string dataobject = "dp_pip3002_1"
end type

event dw_ip::itemchanged;string ls_gubun, ls_yymm, ls_sdate


IF this.GetColumnName() = 'saupj' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF

if this.GetColumnName() = 'gubun' then
   ls_gubun = this.gettext()
	
//	if ls_gubun = '1' or ls_gubun = '2' then
//		this.object.t_5.visible = false
//		this.object.name6.visible = false
//	else
//		this.object.t_5.visible = true
//		this.object.name6.visible = true
//	end if
	
	dw_print.Setredraw(false)
   if ls_gubun = '1' then               //소득세
      dw_print.dataobject = "dp_pip3002_2_1"
	   dw_print.settransobject(sqlca)
		dw_print.insertrow(0)
	elseif ls_gubun = '3' then           //주민세
		dw_print.dataobject = "dp_pip3002_4_1"	
	   dw_print.settransobject(sqlca)
		dw_print.insertrow(0)
	elseif ls_gubun = '2' then
      dw_print.dataobject = "dp_pip3002_2_1"
	   dw_print.settransobject(sqlca)
		dw_print.insertrow(0)
	else
		dw_print.dataobject = "dp_pip3002_4_1"
	   dw_print.settransobject(sqlca)
		dw_print.insertrow(0)
	end if
	dw_print.object.datawindow.print.preview = "yes"
   dw_print.Setredraw(true)
	
end if

if this.GetColumnName() = 'yymm' then
	ls_yymm = this.Gettext()
	
	if f_datechk(ls_yymm+'01') = -1 then
		Messagebox("확인", "기준년월을 확인하세요!")
		this.Setcolumn('yymm')
		this.Setfocus()
		return
	end if
end if

if this.GetColumnName() = 'sdate' then
	ls_sdate= this.Gettext()
	
	if f_datechk(ls_sdate) = -1 then
		Messagebox("확인","제출년월일을 확인하세요!")
		this.Setcolumn('sdate')
		this.Setfocus()
		return
	end if
end if
	
if this.GetColumnName() = 'sdate2' then
	ls_sdate= this.Gettext()
	
	if f_datechk(ls_sdate) = -1 then
		Messagebox("확인", "납부년월일을 확인하세요!")
		this.Setcolumn('sdate2')
		this.Setfocus()
		return
	end if
end if
	
	
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within wp_pip3002
boolean visible = false
integer x = 3657
integer y = 36
integer width = 201
integer height = 140
boolean hscrollbar = false
boolean vscrollbar = false
boolean border = false
boolean hsplitscroll = false
boolean livescroll = false
end type

type rr_1 from roundrectangle within wp_pip3002
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 16777215
integer x = 407
integer y = 364
integer width = 3721
integer height = 1840
integer cornerheight = 40
integer cornerwidth = 55
end type

