$PBExportHeader$w_pip1016.srw
$PBExportComments$** 월변동자료생성(정산자료생성)
forward
global type w_pip1016 from w_inherite_multi
end type
type rr_3 from roundrectangle within w_pip1016
end type
type uo_progress from u_progress_bar within w_pip1016
end type
type rb_1 from radiobutton within w_pip1016
end type
type st_2 from statictext within w_pip1016
end type
type rb_2 from radiobutton within w_pip1016
end type
type st_3 from statictext within w_pip1016
end type
type em_ym from editmask within w_pip1016
end type
type dw_allow from datawindow within w_pip1016
end type
type pb_1 from picturebutton within w_pip1016
end type
type pb_2 from picturebutton within w_pip1016
end type
type dw_total from u_d_select_sort within w_pip1016
end type
type dw_personal from u_d_select_sort within w_pip1016
end type
type rb_6 from radiobutton within w_pip1016
end type
type kem_ym from editmask within w_pip1016
end type
type st_11 from statictext within w_pip1016
end type
type em_ymf from editmask within w_pip1016
end type
type em_ymt from editmask within w_pip1016
end type
type rb_3 from radiobutton within w_pip1016
end type
type st_4 from statictext within w_pip1016
end type
type st_5 from statictext within w_pip1016
end type
type ddlb_1 from dropdownlistbox within w_pip1016
end type
type st_10 from statictext within w_pip1016
end type
type st_6 from statictext within w_pip1016
end type
type dw_saup from datawindow within w_pip1016
end type
type gb_9 from groupbox within w_pip1016
end type
type rr_1 from roundrectangle within w_pip1016
end type
type rr_2 from roundrectangle within w_pip1016
end type
type ln_1 from line within w_pip1016
end type
type ln_2 from line within w_pip1016
end type
type rr_4 from roundrectangle within w_pip1016
end type
type rr_5 from roundrectangle within w_pip1016
end type
type rr_6 from roundrectangle within w_pip1016
end type
end forward

global type w_pip1016 from w_inherite_multi
string title = "정산변동자료생성"
rr_3 rr_3
uo_progress uo_progress
rb_1 rb_1
st_2 st_2
rb_2 rb_2
st_3 st_3
em_ym em_ym
dw_allow dw_allow
pb_1 pb_1
pb_2 pb_2
dw_total dw_total
dw_personal dw_personal
rb_6 rb_6
kem_ym kem_ym
st_11 st_11
em_ymf em_ymf
em_ymt em_ymt
rb_3 rb_3
st_4 st_4
st_5 st_5
ddlb_1 ddlb_1
st_10 st_10
st_6 st_6
dw_saup dw_saup
gb_9 gb_9
rr_1 rr_1
rr_2 rr_2
ln_1 ln_1
ln_2 ln_2
rr_4 rr_4
rr_5 rr_5
rr_6 rr_6
end type
global w_pip1016 w_pip1016

type variables
String                sProcYearMonth, sPayGbn,sPTag,sBTag,sProcGbn, &
                         sKProcYearMonth,sfromYearMonth,stoYearMonth
DataWindow    dw_Process
Integer              il_rowcount


end variables

forward prototypes
public subroutine wf_calc_sokamt (string arg_code, string arg_addreplace, string arg_subaddgubn)
public subroutine wf_calc_calcamt (string arg_code, string arg_addreplace, string arg_subaddgubn, string arg_code1, string arg_addreplace1, string arg_subaddgubn1, string spbtag, string arg_code2, string arg_addreplace2, string arg_subaddgubn2)
end prototypes

public subroutine wf_calc_sokamt (string arg_code, string arg_addreplace, string arg_subaddgubn);/*소급금액 계산 */

string sempno 
int i
double allowamt , totsokamt , totmedamt, totciramt

sfromYearMonth = Left(em_ymf.text,4) + Right(em_ymf.text,2)
stoYearMonth = Left(em_ymt.text,4) + Right(em_ymt.text,2)
	
IF sfromYearMonth ="" OR IsNull(sfromYearMonth) THEN
	MessageBox("확 인","년월을 입력하세요!!")
	em_ymf.SetFocus()
	Return
END IF
IF stoYearMonth ="" OR IsNull(stoYearMonth) THEN
	MessageBox("확 인","년월을 입력하세요!!")
	em_ymt.SetFocus()
	Return
END IF
	

				
DELETE FROM "P3_EDITDATA"  
 		WHERE ( "P3_EDITDATA"."PBTAG" = 'S' ) AND  
            ( "P3_EDITDATA"."WORKYM" = :sProcYearMonth )   ;

DELETE FROM "P3_EDITDATACHILD"  
      WHERE ( "P3_EDITDATACHILD"."PBTAG" = 'S' ) AND  
            ( "P3_EDITDATACHILD"."WORKYM" = :sProcYearMonth )   ;

FOR  i = 1 to dw_process.rowcount()
	 sempno = dw_process.getitemstring(i,"empno")
	 totsokamt = dw_process.getitemnumber(i,"sokamt")
	 totmedamt = dw_process.getitemnumber(i,"medamt")
	 totciramt = dw_process.getitemnumber(i,"ciramt")
	 
	 IF totsokamt = 0 or Isnull(totsokamt) then
	 ELSE
		   SELECT "P3_MONTHCHGDATA"."ALLOWAMT"  
			 INTO :allowamt  
			 FROM "P3_MONTHCHGDATA"  
			WHERE ( "P3_MONTHCHGDATA"."WORKYM" = :sProcYearMonth ) AND  
					( "P3_MONTHCHGDATA"."EMPNO" = :sempno ) AND  
					( "P3_MONTHCHGDATA"."PBTAG" = 'P' ) AND  
					( "P3_MONTHCHGDATA"."ALLOWCODE" = :arg_code ) AND  
					( "P3_MONTHCHGDATA"."GUBUN" = :arg_subaddgubn )   ;
			IF allowamt <> 0  and Not IsNull(allowamt) THEN
				  DELETE FROM "P3_MONTHCHGDATA"
				  		  WHERE ( "P3_MONTHCHGDATA"."WORKYM" = :sProcYearMonth ) AND  
								  ( "P3_MONTHCHGDATA"."EMPNO" = :sempno ) AND  
								  ( "P3_MONTHCHGDATA"."PBTAG" = 'P' ) AND  
								  ( "P3_MONTHCHGDATA"."ALLOWCODE" = :arg_code ) AND  
								  ( "P3_MONTHCHGDATA"."GUBUN" = :arg_subaddgubn )   ;
			END IF	
		  
			IF arg_addreplace= 'R' THEN allowamt  = 0
			IF arg_subaddgubn= '1' THEN
				totsokamt  = (totsokamt + allowamt) * 1
			ELSE
				totsokamt  = (totsokamt + allowamt) * -1
			END IF	
			
			INSERT INTO "P3_MONTHCHGDATA"  
					      ( "WORKYM", "EMPNO", "PBTAG", "ALLOWCODE", "ALLOWAMT", "GUBUN" )  
				  VALUES (:sProcYearMonth,:sempno,  'P',  :arg_code, :totsokamt, :arg_subaddgubn )  ;
					
			
			
	 END IF	


NEXT				
		
end subroutine

public subroutine wf_calc_calcamt (string arg_code, string arg_addreplace, string arg_subaddgubn, string arg_code1, string arg_addreplace1, string arg_subaddgubn1, string spbtag, string arg_code2, string arg_addreplace2, string arg_subaddgubn2);/*정산 금액 계산 */

string sempno , skgubun,sacode
int i
double allowamt , samt,allowamt1 , samt1 ,  allowamt2 , samt2, &
		 dnetincometax, dnetspecialtax,dnetresidenttax,dsubemployee
sPbtag = 'P'
if dw_allow.Accepttext() = -1 then return
sacode = left(dw_allow.GetitemString(1,'allowcode'),2)
FOR  i = 1 to dw_process.rowcount()
	 sempno = dw_process.getitemstring(i,"empno")
	 dnetincometax = dw_process.GetItemnumber(i, "netincometax") 
	 dnetspecialtax = dw_process.GetItemnumber(i, "netspecialtax") 	
	 dnetresidenttax = dw_process.GetItemnumber(i, "netresidenttax") 		
	
	 skgubun = ddlb_1.text
	 
	 
	 IF skgubun = '전체' then
		 dnetincometax = dnetincometax + dnetresidenttax + dnetspecialtax
		 dnetresidenttax = 0
		 dnetspecialtax  = 0
	 ELSEIF skgubun = '소득세' then	 
		 dnetincometax = dnetincometax 
		 dnetresidenttax = 0
		 dnetspecialtax  = 0
	ELSEIF skgubun = '주민세' then	 
		 dnetresidenttax = dnetresidenttax 
		 dnetincometax = 0
		 dnetspecialtax  = 0
	 ELSEIF skgubun = '농특세' then	 
		 dnetspecialtax = dnetspecialtax 
		 dnetincometax = 0
		 dnetresidenttax = 0
	END IF	
	 IF dnetincometax = 0 or Isnull(dnetincometax) then
	 ELSE
		   SELECT "P3_MONTHCHGDATA"."ALLOWAMT"  
			 INTO :allowamt  
			 FROM "P3_MONTHCHGDATA"  
			WHERE ( "P3_MONTHCHGDATA"."COMPANYCODE" = :gs_company ) AND  
			      ( "P3_MONTHCHGDATA"."WORKYM" = :sProcYearMonth ) AND  
					( "P3_MONTHCHGDATA"."EMPNO" = :sempno ) AND  
					( "P3_MONTHCHGDATA"."PBTAG" = :spbtag ) AND  
					( "P3_MONTHCHGDATA"."ALLOWCODE" = :sacode ) AND  
					( "P3_MONTHCHGDATA"."GUBUN" = '2')   ;
			IF allowamt <> 0  and Not IsNull(allowamt) THEN
				  DELETE FROM "P3_MONTHCHGDATA"
				  		  WHERE ( "P3_MONTHCHGDATA"."COMPANYCODE" = :gs_company ) AND  					
								  ( "P3_MONTHCHGDATA"."WORKYM" = :sProcYearMonth ) AND  
								  ( "P3_MONTHCHGDATA"."EMPNO" = :sempno ) AND  
								  ( "P3_MONTHCHGDATA"."PBTAG" = :spbtag ) AND  
								  ( "P3_MONTHCHGDATA"."ALLOWCODE" = :sacode ) AND  
								  ( "P3_MONTHCHGDATA"."GUBUN" = '2' )   ;
			END IF	
		  
		
		   	INSERT INTO "P3_MONTHCHGDATA"  
					      ("COMPANYCODE", "WORKYM", "EMPNO", "PBTAG", "ALLOWCODE", "ALLOWAMT", "GUBUN" )  
				  VALUES (:gs_company, :sProcYearMonth,:sempno,  :spbtag,  :sacode, :dnetincometax, '2' )  ;
					
			IF SQLCA.SQLCODE <> 0 THEN
				Rollback ;
			ELSE
				Commit ;
			END IF	
	END IF		
			//주민세 금액	
	IF dnetresidenttax = 0 or Isnull(dnetresidenttax) then
	ELSE
		   SELECT "P3_MONTHCHGDATA"."ALLOWAMT"  
			 INTO :allowamt1  
			 FROM "P3_MONTHCHGDATA"  
			WHERE ( "P3_MONTHCHGDATA"."COMPANYCODE" = :gs_company ) AND  
			      ( "P3_MONTHCHGDATA"."WORKYM" = :sProcYearMonth ) AND  
					( "P3_MONTHCHGDATA"."EMPNO" = :sempno ) AND  
					( "P3_MONTHCHGDATA"."PBTAG" = :spbtag ) AND  
					( "P3_MONTHCHGDATA"."ALLOWCODE" = :sacode ) AND  
					( "P3_MONTHCHGDATA"."GUBUN" = '2' )   ;
			IF allowamt1 <> 0  and Not IsNull(allowamt1) THEN
				  DELETE FROM "P3_MONTHCHGDATA"
				  		  WHERE ( "P3_MONTHCHGDATA"."COMPANYCODE" = :gs_company ) AND  
							     ( "P3_MONTHCHGDATA"."WORKYM" = :sProcYearMonth ) AND  
								  ( "P3_MONTHCHGDATA"."EMPNO" = :sempno ) AND  
								  ( "P3_MONTHCHGDATA"."PBTAG" = :spbtag ) AND  
								  ( "P3_MONTHCHGDATA"."ALLOWCODE" = :sacode ) AND  
								  ( "P3_MONTHCHGDATA"."GUBUN" = '2' );
			END IF	
		  
					
			INSERT INTO "P3_MONTHCHGDATA"  
					      ("COMPANYCODE", "WORKYM", "EMPNO", "PBTAG", "ALLOWCODE", "ALLOWAMT", "GUBUN" )  
				  VALUES (:gs_company, :sProcYearMonth,:sempno,  :spbtag,  :sacode, :dnetresidenttax, '2' )  ;
					
			IF SQLCA.SQLCODE <> 0 THEN
				Rollback ;
			ELSE
				Commit ;
			END IF	
			
	 END IF	
			//농특세 금액	
	IF dnetspecialtax = 0 or Isnull(dnetspecialtax) then
	ELSE
		   SELECT "P3_MONTHCHGDATA"."ALLOWAMT"  
			 INTO :allowamt2  
			 FROM "P3_MONTHCHGDATA"  
			WHERE ( "P3_MONTHCHGDATA"."COMPANYCODE" = :gs_company ) AND  
			      ( "P3_MONTHCHGDATA"."WORKYM" = :sProcYearMonth ) AND  
					( "P3_MONTHCHGDATA"."EMPNO" = :sempno ) AND  
					( "P3_MONTHCHGDATA"."PBTAG" = :spbtag ) AND  
					( "P3_MONTHCHGDATA"."ALLOWCODE" = :sacode ) AND  
					( "P3_MONTHCHGDATA"."GUBUN" = '2' )   ;
			IF allowamt2 <> 0  and Not IsNull(allowamt2) THEN
				  DELETE FROM "P3_MONTHCHGDATA"
				  		  WHERE ( "P3_MONTHCHGDATA"."COMPANYCODE" = :gs_company ) AND  
							     ( "P3_MONTHCHGDATA"."WORKYM" = :sProcYearMonth ) AND  
								  ( "P3_MONTHCHGDATA"."EMPNO" = :sempno ) AND  
								  ( "P3_MONTHCHGDATA"."PBTAG" = :spbtag ) AND  
								  ( "P3_MONTHCHGDATA"."ALLOWCODE" = :sacode ) AND  
								  ( "P3_MONTHCHGDATA"."GUBUN" = '2' );
			END IF	
		  
					
			INSERT INTO "P3_MONTHCHGDATA"  
					      ("COMPANYCODE", "WORKYM", "EMPNO", "PBTAG", "ALLOWCODE", "ALLOWAMT", "GUBUN" )  
				  VALUES (:gs_company, :sProcYearMonth,:sempno,  :spbtag,  :sacode, :dnetspecialtax, '2' )  ;
					
			IF SQLCA.SQLCODE <> 0 THEN
				Rollback ;
			ELSE
				Commit ;
			END IF	
			
	 END IF	
			 
	 dnetincometax = 0
	 dnetresidenttax = 0 
	 dnetspecialtax = 0
NEXT	
end subroutine

on w_pip1016.create
int iCurrent
call super::create
this.rr_3=create rr_3
this.uo_progress=create uo_progress
this.rb_1=create rb_1
this.st_2=create st_2
this.rb_2=create rb_2
this.st_3=create st_3
this.em_ym=create em_ym
this.dw_allow=create dw_allow
this.pb_1=create pb_1
this.pb_2=create pb_2
this.dw_total=create dw_total
this.dw_personal=create dw_personal
this.rb_6=create rb_6
this.kem_ym=create kem_ym
this.st_11=create st_11
this.em_ymf=create em_ymf
this.em_ymt=create em_ymt
this.rb_3=create rb_3
this.st_4=create st_4
this.st_5=create st_5
this.ddlb_1=create ddlb_1
this.st_10=create st_10
this.st_6=create st_6
this.dw_saup=create dw_saup
this.gb_9=create gb_9
this.rr_1=create rr_1
this.rr_2=create rr_2
this.ln_1=create ln_1
this.ln_2=create ln_2
this.rr_4=create rr_4
this.rr_5=create rr_5
this.rr_6=create rr_6
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_3
this.Control[iCurrent+2]=this.uo_progress
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.rb_2
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.em_ym
this.Control[iCurrent+8]=this.dw_allow
this.Control[iCurrent+9]=this.pb_1
this.Control[iCurrent+10]=this.pb_2
this.Control[iCurrent+11]=this.dw_total
this.Control[iCurrent+12]=this.dw_personal
this.Control[iCurrent+13]=this.rb_6
this.Control[iCurrent+14]=this.kem_ym
this.Control[iCurrent+15]=this.st_11
this.Control[iCurrent+16]=this.em_ymf
this.Control[iCurrent+17]=this.em_ymt
this.Control[iCurrent+18]=this.rb_3
this.Control[iCurrent+19]=this.st_4
this.Control[iCurrent+20]=this.st_5
this.Control[iCurrent+21]=this.ddlb_1
this.Control[iCurrent+22]=this.st_10
this.Control[iCurrent+23]=this.st_6
this.Control[iCurrent+24]=this.dw_saup
this.Control[iCurrent+25]=this.gb_9
this.Control[iCurrent+26]=this.rr_1
this.Control[iCurrent+27]=this.rr_2
this.Control[iCurrent+28]=this.ln_1
this.Control[iCurrent+29]=this.ln_2
this.Control[iCurrent+30]=this.rr_4
this.Control[iCurrent+31]=this.rr_5
this.Control[iCurrent+32]=this.rr_6
end on

on w_pip1016.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_3)
destroy(this.uo_progress)
destroy(this.rb_1)
destroy(this.st_2)
destroy(this.rb_2)
destroy(this.st_3)
destroy(this.em_ym)
destroy(this.dw_allow)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.dw_total)
destroy(this.dw_personal)
destroy(this.rb_6)
destroy(this.kem_ym)
destroy(this.st_11)
destroy(this.em_ymf)
destroy(this.em_ymt)
destroy(this.rb_3)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.ddlb_1)
destroy(this.st_10)
destroy(this.st_6)
destroy(this.dw_saup)
destroy(this.gb_9)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.ln_1)
destroy(this.ln_2)
destroy(this.rr_4)
destroy(this.rr_5)
destroy(this.rr_6)
end on

event open;call super::open;
dw_total.SetTransObject(SQLCA)
dw_total.Reset()

dw_personal.SetTransObject(SQLCA)

dw_allow.SetTransObject(SQLCA)
dw_allow.Reset()
dw_allow.InsertRow(0)

dw_saup.SetTransObject(SQLCA)
dw_saup.InsertRow(0)

f_set_saupcd(dw_saup,'saupcd','1')
is_saupcd = gs_saupcd

em_ym.text = String(Left(is_today,6),'@@@@.@@')
kem_ym.text = String(Left(is_today,6),'@@@@.@@')
em_ym.SetFocus()

sProcGbn = 'CAL'

em_ymf.text = string(left(em_ym.text,4) + '04','@@@@.@@')
em_ymt.text = string(left(em_ym.text,4) + right(em_ym.text,2),'@@@@.@@')

rb_1.Checked = True

//rb_11.Checked = True

rb_3.Checked = True														/*처리구분*/
//rb_3.TriggerEvent(Clicked!)

uo_progress.Hide()


end event

type p_delrow from w_inherite_multi`p_delrow within w_pip1016
boolean visible = false
integer x = 4238
integer y = 2836
integer taborder = 80
end type

type p_addrow from w_inherite_multi`p_addrow within w_pip1016
boolean visible = false
integer x = 4064
integer y = 2836
integer taborder = 70
end type

type p_search from w_inherite_multi`p_search within w_pip1016
boolean visible = false
integer x = 3872
integer y = 2612
integer taborder = 170
end type

type p_ins from w_inherite_multi`p_ins within w_pip1016
boolean visible = false
integer x = 3890
integer y = 2836
integer taborder = 40
end type

type p_exit from w_inherite_multi`p_exit within w_pip1016
integer x = 4338
integer taborder = 150
end type

type p_can from w_inherite_multi`p_can within w_pip1016
integer x = 4165
integer taborder = 140
end type

event p_can::clicked;call super::clicked;
uo_progress.Hide()

sle_msg.text =""

dw_total.Reset()
dw_personal.Reset()

end event

type p_print from w_inherite_multi`p_print within w_pip1016
boolean visible = false
integer x = 4046
integer y = 2612
integer taborder = 190
end type

type p_inq from w_inherite_multi`p_inq within w_pip1016
integer x = 3817
end type

event p_inq::clicked;call super::clicked;string sgubn 

dw_total.Reset()
dw_personal.Reset()

sProcYearMonth = Left(em_ym.text,4) + Right(em_ym.text,2)
sKProcYearMonth = Left(kem_ym.text,4) + Right(kem_ym.text,2)


IF sProcYearMonth ="" OR IsNull(sProcYearMonth) THEN
	MessageBox("확 인","급여적용년월를 입력하세요!!")
	em_ym.SetFocus()
	Return
END IF

IF sKProcYearMonth ="" OR IsNull(sKProcYearMonth) THEN
	MessageBox("확 인","기준년월를 입력하세요!!")
	kem_ym.SetFocus()
	Return
END IF
IF sProcGbn = 'CAL' THEN	

	dw_total.dataobject= 'd_pip1016_7'
	dw_total.settransobject(sqlca)
	dw_personal.dataobject= 'd_pip1016_7'
	dw_personal.settransobject(sqlca)
	IF dw_total.Retrieve(left(sKProcYearMonth,6),is_saupcd) <=0 THEN
		MessageBox("확 인","처리할 자료가 없습니다!!",StopSign!)
		kem_ym.SetFocus()
		Return
	END IF			
END IF	

dw_Process = dw_total
il_RowCount = dw_total.RowCount()






end event

type p_del from w_inherite_multi`p_del within w_pip1016
boolean visible = false
integer x = 4242
integer y = 2604
integer taborder = 120
end type

type p_mod from w_inherite_multi`p_mod within w_pip1016
integer x = 3991
integer taborder = 100
end type

event p_mod::clicked;call super::clicked;
Int    il_meterPosition,k,il_CurRow,il_Count,i ,rtnval
String sEmpNo,sEmpNoSql,sAllowCode,sGubn,sAddReplace, sSubAddGubn, &
		 sAllowCode1,sSubAddGubn1,sAddReplace1, spbtag , &
		 sAllowCode2,sSubAddGubn2,sAddReplace2

sProcYearMonth = Left(em_ym.text,4) + Right(em_ym.text,2)
sKProcYearMonth = Left(kem_ym.text,4) + Right(kem_ym.text,2)

IF sProcYearMonth ="" OR IsNull(sProcYearMonth) THEN
	MessageBox("확 인","정산년월를 입력하세요!!")
	em_ym.SetFocus()
	Return
END IF

IF sKProcYearMonth ="" OR IsNull(sKProcYearMonth) THEN
	MessageBox("확 인","적용년월를 입력하세요!!")
	kem_ym.SetFocus()
	Return
END IF


IF rb_1.Checked = True THEN										//전체
	dw_Process = dw_total
	il_RowCount = dw_total.RowCount()
ELSEIF rb_2.Checked = True THEN									//개인
	dw_Process = dw_personal
	il_RowCount = dw_personal.RowCount()
END IF



IF il_RowCount <=0 THEN 
	MessageBox("확 인","처리할 자료가 없습니다!!")
	Return
END IF

dw_allow.AcceptText() 

sAllowCode = left(dw_allow.GetItemString(1,"allowcode"),2)
sSubAddGubn = right(dw_allow.GetItemString(1,"allowcode"),1)
sAddReplace = dw_allow.GetItemString(1,"gubn")


IF sAllowCode = "" OR IsNull(sAllowCode) THEN
	messagebox("확인","대상항목을 선택하십시오.")
	return
END IF

SetPointer(HourGlass!)

w_mdi_frame.sle_msg.text = '자료생성중 ...'
IF sProcGbn = 'SOK'	THEN						/*소급금액 자료생성*/	
	wf_calc_sokamt(sAllowCode , sAddReplace, sSubAddGubn)
ELSEIF sProcGbn = 'CAL'	THEN						/*정산금액 자료생성*/	
	wf_calc_calcamt(sAllowCode , sAddReplace, sSubAddGubn, & 
	                sAllowCode1, sAddReplace1,sSubAddGubn1, spbtag, &
						 sAllowCode2, sAddReplace2,sSubAddGubn2 )
END IF

SetPointer(Arrow!)

w_mdi_frame.sle_msg.text = '작업완료 ...'

end event

type dw_insert from w_inherite_multi`dw_insert within w_pip1016
boolean visible = false
integer x = 0
integer y = 2280
integer taborder = 20
end type

type st_window from w_inherite_multi`st_window within w_pip1016
boolean visible = false
integer x = 1989
integer y = 3000
integer taborder = 50
end type

type cb_append from w_inherite_multi`cb_append within w_pip1016
boolean visible = false
integer x = 946
integer y = 3000
integer taborder = 0
end type

type cb_exit from w_inherite_multi`cb_exit within w_pip1016
boolean visible = false
integer x = 3195
integer taborder = 220
end type

type cb_update from w_inherite_multi`cb_update within w_pip1016
boolean visible = false
integer x = 2482
integer taborder = 200
end type

type cb_insert from w_inherite_multi`cb_insert within w_pip1016
boolean visible = false
integer x = 1312
integer y = 3000
integer taborder = 0
end type

type cb_delete from w_inherite_multi`cb_delete within w_pip1016
boolean visible = false
integer x = 1737
integer y = 3000
integer taborder = 0
end type

type cb_retrieve from w_inherite_multi`cb_retrieve within w_pip1016
boolean visible = false
integer x = 2117
integer taborder = 180
end type

type st_1 from w_inherite_multi`st_1 within w_pip1016
boolean visible = false
integer x = 32
end type

type cb_cancel from w_inherite_multi`cb_cancel within w_pip1016
boolean visible = false
integer x = 2830
integer taborder = 210
end type

type dw_datetime from w_inherite_multi`dw_datetime within w_pip1016
boolean visible = false
integer x = 2843
end type

type sle_msg from w_inherite_multi`sle_msg within w_pip1016
boolean visible = false
integer x = 183
integer y = 3000
integer width = 1801
end type

type gb_2 from w_inherite_multi`gb_2 within w_pip1016
boolean visible = false
integer x = 2057
end type

type gb_1 from w_inherite_multi`gb_1 within w_pip1016
boolean visible = false
integer x = 2144
integer y = 3000
end type

type gb_10 from w_inherite_multi`gb_10 within w_pip1016
boolean visible = false
integer x = 14
end type

type rr_3 from roundrectangle within w_pip1016
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 480
integer y = 100
integer width = 782
integer height = 248
integer cornerheight = 40
integer cornerwidth = 55
end type

type uo_progress from u_progress_bar within w_pip1016
integer x = 763
integer y = 2096
integer width = 1083
integer height = 72
boolean bringtotop = true
end type

on uo_progress.destroy
call u_progress_bar::destroy
end on

type rb_1 from radiobutton within w_pip1016
integer x = 1362
integer y = 256
integer width = 247
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "전체"
boolean checked = true
end type

type st_2 from statictext within w_pip1016
integer x = 1335
integer y = 84
integer width = 261
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
boolean enabled = false
string text = "작업대상"
alignment alignment = center!
boolean focusrectangle = false
end type

type rb_2 from radiobutton within w_pip1016
integer x = 1659
integer y = 256
integer width = 247
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "개인"
end type

type st_3 from statictext within w_pip1016
integer x = 571
integer y = 152
integer width = 329
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "정산년월"
boolean focusrectangle = false
end type

type em_ym from editmask within w_pip1016
event ue_keydown pbm_keydown
integer x = 859
integer y = 248
integer width = 315
integer height = 64
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
boolean border = false
alignment alignment = center!
maskdatatype maskdatatype = datemask!
string mask = "yyyy.mm"
end type

event ue_keydown;if KeyDown(KeyEnter!) then
   Send( Handle(this), 256, 9, 0 )
   Return 
end if
end event

event modified;//String sYm
//
//sYm = Left(Trim(em_ym.text),4) + Right(Trim(em_ym.text),2) + '01'
//
//dw_total.Retrieve(sYm+'31')
//
end event

type dw_allow from datawindow within w_pip1016
integer x = 2670
integer y = 208
integer width = 919
integer height = 76
integer taborder = 90
boolean bringtotop = true
string dataobject = "d_pip1016_1"
boolean border = false
boolean livescroll = true
end type

event itemerror;return 2
end event

event itemchanged;return 0
end event

type pb_1 from picturebutton within w_pip1016
integer x = 2103
integer y = 756
integer width = 114
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\erpman\Image\next.gif"
alignment htextalign = left!
end type

event clicked;String sEmpNo,sEmpName,sJikJongGbn, sdept, STAG
Long   totRow , sRow,rowcnt
double sokamt, medamt,ciramt,drvdst, irestamt,iexpamt, &
		 netincometax, netspecialtax,netresidenttax,subemployee	
int i

totrow =dw_total.Rowcount()

FOR i = 1 TO totrow 
	sRow = dw_total.getselectedrow(0)
	
	IF sRow <=0 THEN EXIT
	
	sEmpNo      = dw_total.GetItemString(sRow, "empno")
   sEmpName    = dw_total.GetItemString(sRow, "empname")
	sdept       = dw_total.GetItemString(sRow, "deptcode")
	IF rb_6.checked = true THEN
		sokamt = dw_total.GetItemnumber(sRow, "sokamt") 	
		medamt = dw_total.GetItemnumber(sRow, "medamt") 	
		ciramt = dw_total.GetItemnumber(sRow, "ciramt") 
	
	
	ELSEIF rb_3.checked = true THEN	
		netincometax = dw_total.GetItemnumber(sRow, "netincometax") 	
		netspecialtax = dw_total.GetItemnumber(sRow, "netspecialtax") 	
		netresidenttax = dw_total.GetItemnumber(sRow, "netresidenttax") 		
		subemployee = dw_total.GetItemnumber(sRow, "subemployee") 				
		STAG = dw_total.GetItemstring(sRow, "tag") 
	END IF	
	rowcnt = dw_personal.RowCount() + 1
	
	dw_personal.insertrow(rowcnt)
	dw_personal.setitem(rowcnt,"empname", sEmpName)
	dw_personal.setitem(rowcnt,"empno", sEmpNo)
	dw_personal.setitem(rowcnt,"deptcode", sdept)
	IF rb_6.checked = true THEN
		dw_personal.setitem(rowcnt,"sokamt", sokamt)	
		dw_personal.setitem(rowcnt,"medamt", medamt)
		dw_personal.setitem(rowcnt,"ciramt", ciramt)	
	ELSEIF rb_3.checked = true THEN	
		dw_personal.setitem(rowcnt,"netincometax",netincometax) 	
		dw_personal.setitem(rowcnt,"netspecialtax",netspecialtax) 	
		dw_personal.setitem(rowcnt,"netresidenttax",netresidenttax) 		
		dw_personal.setitem(rowcnt,"subemployee",subemployee)
		dw_personal.setitem(rowcnt,"tag",STAG)		
	END IF		
	
	
	dw_total.deleterow(sRow)
NEXT	

IF dw_personal.RowCount() > 0 THEN
	rb_2.Checked = True
ELSE
	rb_1.Checked = True
END IF	
end event

type pb_2 from picturebutton within w_pip1016
integer x = 2103
integer y = 896
integer width = 114
integer height = 92
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\erpman\Image\prior.gif"
end type

event clicked;String sEmpNo,sEmpName,sJikJongGbn, sdept, stag
Long    rowcnt , totRow , sRow 
double sokamt, medamt,ciramt,drvdst,irestamt,iexpamt, &
		 netincometax, netspecialtax,netresidenttax,subemployee	
int     i

totRow =dw_personal.Rowcount()

FOR i = 1 TO totRow 
	sRow = dw_personal.getselectedrow(0)
	
	IF sRow <=0 THEN EXIT
	
	sEmpNo      = dw_personal.GetItemString(sRow, "empno")
   sEmpName    = dw_personal.GetItemString(sRow, "empname")
	sdept       = dw_personal.GetItemString(sRow, "deptcode")
	IF rb_6.checked = true THEN
		sokamt = dw_personal.GetItemnumber(sRow, "sokamt") 	
		medamt = dw_personal.GetItemnumber(sRow, "medamt") 	
		ciramt = dw_personal.GetItemnumber(sRow, "ciramt") 
	
	ELSEIF rb_3.checked = true THEN	
		netincometax = dw_personal.GetItemnumber(sRow, "netincometax") 	
		netspecialtax = dw_personal.GetItemnumber(sRow, "netspecialtax") 	
		netresidenttax = dw_personal.GetItemnumber(sRow, "netresidenttax") 		
		subemployee = dw_personal.GetItemnumber(sRow, "subemployee")
		stag = dw_personal.GetItemstring(sRow, "tag")		
	END IF	
	
	rowcnt = dw_total.RowCount() + 1
	
	dw_total.insertrow(rowcnt)
	dw_total.setitem(rowcnt, "empname", sEmpName)
	dw_total.setitem(rowcnt, "empno", sEmpNo)
	dw_total.setitem(rowcnt, "deptcode", sdept)
	IF rb_6.checked = true THEN
		dw_total.setitem(rowcnt, "sokamt", sokamt)	
		dw_total.setitem(rowcnt, "medamt", medamt)
		dw_total.setitem(rowcnt, "ciramt", ciramt)
	
	ELSEIF rb_3.checked = true THEN	
		dw_total.setitem(rowcnt,"netincometax",netincometax) 	
		dw_total.setitem(rowcnt,"netspecialtax",netspecialtax) 	
		dw_total.setitem(rowcnt,"netresidenttax",netresidenttax) 		
		dw_total.setitem(rowcnt,"subemployee",subemployee)
		dw_total.setitem(rowcnt,"tag",stag)
	END IF		
	dw_personal.deleterow(sRow)
NEXT	

IF dw_personal.RowCount() > 0 THEN
	rb_2.Checked = True
ELSE
	rb_1.Checked = True
END IF	
end event

type dw_total from u_d_select_sort within w_pip1016
integer x = 480
integer y = 476
integer width = 1573
integer height = 1540
integer taborder = 0
boolean bringtotop = true
string dataobject = "d_pip1016_7"
boolean hscrollbar = false
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event clicked;If Row <= 0 then
	b_flag =True
ELSE
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

type dw_personal from u_d_select_sort within w_pip1016
integer x = 2281
integer y = 476
integer width = 1573
integer height = 1540
integer taborder = 0
boolean bringtotop = true
string dataobject = "d_pip1016_7"
boolean hscrollbar = false
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event clicked;If Row <= 0 then
	b_flag =True
ELSE
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

type rb_6 from radiobutton within w_pip1016
boolean visible = false
integer x = 357
integer y = 2608
integer width = 558
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "소급금액 생성"
boolean automatic = false
end type

event clicked;sProcGbn = 'SOK'			/*소급금액*/



em_ymf.text = string(left(em_ym.text,4) + '04','@@@@.@@')
em_ymt.text = string(left(em_ym.text,4) + right(em_ym.text,2),'@@@@.@@')
em_ymf.visible = true
em_ymt.visible = true
p_inq.TriggerEvent(Clicked!)

em_ymf.setfocus()
end event

type kem_ym from editmask within w_pip1016
event ue_keydown pbm_keydown
integer x = 859
integer y = 148
integer width = 315
integer height = 64
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
boolean border = false
alignment alignment = center!
maskdatatype maskdatatype = datemask!
string mask = "yyyy.mm"
end type

event ue_keydown;if KeyDown(KeyEnter!) then
   Send( Handle(this), 256, 9, 0 )
   Return 
end if
end event

event modified;cb_retrieve.TriggerEvent(Clicked!)
end event

type st_11 from statictext within w_pip1016
integer x = 571
integer y = 244
integer width = 279
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "적용년월"
boolean focusrectangle = false
end type

type em_ymf from editmask within w_pip1016
event ue_keydown pbm_keydown
boolean visible = false
integer x = 1376
integer y = 2680
integer width = 238
integer height = 72
integer taborder = 130
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "yyyy.mm"
end type

event ue_keydown;if KeyDown(KeyEnter!) then
   Send( Handle(this), 256, 9, 0 )
   Return 
end if
end event

event modified;cb_retrieve.TriggerEvent(Clicked!)
end event

type em_ymt from editmask within w_pip1016
event ue_keydown pbm_keydown
boolean visible = false
integer x = 1673
integer y = 2680
integer width = 238
integer height = 72
integer taborder = 160
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "yyyy.mm"
end type

event ue_keydown;if KeyDown(KeyEnter!) then
   Send( Handle(this), 256, 9, 0 )
   Return 
end if
end event

event modified;cb_retrieve.TriggerEvent(Clicked!)
end event

type rb_3 from radiobutton within w_pip1016
boolean visible = false
integer x = 352
integer y = 2692
integer width = 608
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "정산금액 생성"
boolean automatic = false
end type

event clicked;sProcGbn = 'CAL'			/*정산자료생성*/
em_ymf.visible = false
em_ymt.visible = false


p_inq.TriggerEvent(Clicked!)
end event

type st_4 from statictext within w_pip1016
boolean visible = false
integer x = 1614
integer y = 2692
integer width = 55
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "-"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_5 from statictext within w_pip1016
integer x = 2030
integer y = 84
integer width = 261
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
boolean enabled = false
string text = "정산항목"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_1 from dropdownlistbox within w_pip1016
integer x = 2043
integer y = 212
integer width = 512
integer height = 300
integer taborder = 110
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
string item[] = {"소득세","주민세","전체","농특세"}
borderstyle borderstyle = stylelowered!
end type

type st_10 from statictext within w_pip1016
integer x = 539
integer y = 84
integer width = 128
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
boolean enabled = false
string text = "조건"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_6 from statictext within w_pip1016
integer x = 2720
integer y = 84
integer width = 261
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
boolean enabled = false
string text = "지급항목"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_saup from datawindow within w_pip1016
integer x = 1285
integer y = 144
integer width = 667
integer height = 88
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_saupcd_1"
boolean border = false
boolean livescroll = true
end type

event itemchanged;is_saupcd = data
if IsNull(is_saupcd) or Trim(is_saupcd) = '' then is_saupcd = '%'
end event

type gb_9 from groupbox within w_pip1016
boolean visible = false
integer x = 1001
integer y = 2768
integer width = 1271
integer height = 248
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type rr_1 from roundrectangle within w_pip1016
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 471
integer y = 468
integer width = 1591
integer height = 1564
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_pip1016
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 2272
integer y = 468
integer width = 1595
integer height = 1564
integer cornerheight = 40
integer cornerwidth = 46
end type

type ln_1 from line within w_pip1016
integer linethickness = 1
integer beginx = 859
integer beginy = 212
integer endx = 1175
integer endy = 212
end type

type ln_2 from line within w_pip1016
integer linethickness = 1
integer beginx = 859
integer beginy = 312
integer endx = 1175
integer endy = 312
end type

type rr_4 from roundrectangle within w_pip1016
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 1275
integer y = 100
integer width = 681
integer height = 248
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_5 from roundrectangle within w_pip1016
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 1970
integer y = 100
integer width = 667
integer height = 248
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_6 from roundrectangle within w_pip1016
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 2656
integer y = 100
integer width = 974
integer height = 248
integer cornerheight = 40
integer cornerwidth = 55
end type

